local var0_0 = class("EventInfo", import(".BaseVO"))

var0_0.StateExpire = -1
var0_0.StateNone = 0
var0_0.StateActive = 1
var0_0.StateFinish = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.template = pg.collection_template[arg0_1.id]

	assert(arg0_1.template, "pg.collection_template>>>" .. arg0_1.id)

	arg0_1.finishTime = arg1_1.finish_time or 0
	arg0_1.overTime = arg1_1.over_time or 0
	arg0_1.shipIds = underscore.to_array(arg1_1.ship_id_list) or {}
	arg0_1.activityId = arg1_1.activity_id or 0

	if arg0_1:IsActivityType() and arg0_1.overTime == 0 then
		arg0_1.overTime = GetZeroTime()
	end
end

function var0_0.IsActivityType(arg0_2)
	return arg0_2.activityId > 0
end

function var0_0.GetState(arg0_3)
	if arg0_3.finishTime == 0 then
		if arg0_3.overTime == 0 or pg.TimeMgr.GetInstance():GetServerTime() < arg0_3.overTime then
			return var0_0.StateNone
		else
			return var0_0.StateExpire
		end
	elseif arg0_3.finishTime < pg.TimeMgr.GetInstance():GetServerTime() then
		return var0_0.StateFinish
	else
		return var0_0.StateActive
	end
end

function var0_0.IsStarting(arg0_4)
	return arg0_4:GetState() ~= var0_0.StateNone
end

function var0_0.SetActivityId(arg0_5, arg1_5)
	arg0_5.activityId = arg1_5
end

function var0_0.BelongActivity(arg0_6, arg1_6)
	return arg0_6.activityId > 0 and arg0_6.activityId == arg1_6
end

function var0_0.setShipIds(arg0_7, arg1_7)
	arg0_7.valid = false
	arg0_7.shipIds = underscore.to_array(arg1_7)
end

function var0_0.getShipList(arg0_8)
	arg0_8:checkValid()

	return getProxy(BayProxy):getShipList(arg0_8.shipIds)
end

function var0_0.checkValid(arg0_9)
	if arg0_9.valid then
		return
	end

	arg0_9.valid = true

	local var0_9 = getProxy(BayProxy)

	arg0_9.shipIds = underscore.filter(arg0_9.shipIds, function(arg0_10)
		return tobool(var0_9:RawGetShipById(arg0_10))
	end)
end

function var0_0.reachNum(arg0_11)
	arg0_11:checkValid()

	return arg0_11.template.ship_num <= #arg0_11.shipIds
end

function var0_0.reachLevel(arg0_12)
	local var0_12 = arg0_12:getShipList()

	return #var0_12 > 0 and underscore.any(var0_12, function(arg0_13)
		return arg0_13.level >= arg0_12.template.ship_lv
	end)
end

function var0_0.reachTypes(arg0_14)
	local var0_14 = arg0_14:getShipList()

	if table.getCount(var0_14) == 0 then
		return false
	end

	local var1_14 = true

	for iter0_14, iter1_14 in ipairs(var0_14) do
		local var2_14 = iter1_14:getShipType()

		if not table.contains(arg0_14.template.ship_type, var2_14) then
			var1_14 = false

			break
		end
	end

	return var1_14
end

function var0_0.getOilConsume(arg0_15)
	return arg0_15.template.oil or 0
end

function var0_0.getTypesStr(arg0_16)
	local var0_16 = pg.ship_data_by_type
	local var1_16 = arg0_16.template.ship_type
	local var2_16 = false

	if #var1_16 == #var0_16.all then
		var2_16 = true

		for iter0_16, iter1_16 in pairs(var0_16.all) do
			if not table.contains(var1_16, iter1_16) then
				var2_16 = false

				break
			end
		end
	end

	if var2_16 then
		return i18n("event_type_unlimit")
	else
		local var3_16 = ""

		for iter2_16, iter3_16 in ipairs(ShipType.FilterOverQuZhuType(var1_16)) do
			local var4_16 = iter2_16 == #arg0_16.template.ship_type and "" or ", "

			var3_16 = var3_16 .. var0_16[iter3_16].type_name .. var4_16
		end

		return i18n("event_condition_ship_type", var3_16)
	end
end

local var1_0 = "EVENTINFO_FORMATION_KEY_"

function var0_0.ExistPrevFormation(arg0_17)
	local var0_17 = getProxy(PlayerProxy):getRawData().id

	return PlayerPrefs.HasKey(var1_0 .. var0_17)
end

function var0_0.GetPrevFormation(arg0_18)
	local var0_18 = getProxy(PlayerProxy):getRawData().id
	local var1_18 = PlayerPrefs.GetString(var1_0 .. var0_18)
	local var2_18 = string.split(var1_18, "#")

	return _.map(var2_18, function(arg0_19)
		return tonumber(arg0_19)
	end)
end

function var0_0.SavePrevFormation(arg0_20)
	arg0_20:checkValid()

	if not arg0_20:CanRecordPrevFormation() then
		return
	end

	local var0_20 = table.concat(arg0_20.shipIds, "#")
	local var1_20 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetString(var1_0 .. var1_20, var0_20)
	PlayerPrefs.Save()
end

function var0_0.CanRecordPrevFormation(arg0_21)
	return arg0_21.template.oil >= 800
end

function var0_0.GetCountDownTime(arg0_22)
	return not arg0_22:IsActivityType() and arg0_22:GetState() == var0_0.StateNone and arg0_22.overTime > 0 and arg0_22.overTime - pg.TimeMgr.GetInstance():GetServerTime()
end

return var0_0
