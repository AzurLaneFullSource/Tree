local var0_0 = class("EventInfo", import(".BaseVO"))

var0_0.StateNone = 0
var0_0.StateActive = 1
var0_0.StateFinish = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.template = pg.collection_template[arg0_1.id]

	assert(arg0_1.template, "pg.collection_template>>>" .. arg0_1.id)

	arg0_1.finishTime = arg1_1.finish_time
	arg0_1.overTime = arg1_1.over_time
	arg0_1.shipIds = arg1_1.ship_id_list or {}
	arg0_1.ships = {}
	arg0_1.state = var0_0.StateNone
	arg0_1.activityId = arg1_1.activity_id or 0

	if arg0_1.finishTime == 0 then
		arg0_1.state = var0_0.StateNone
	elseif arg0_1.finishTime >= pg.TimeMgr.GetInstance():GetServerTime() then
		arg0_1.state = var0_0.StateActive
	else
		arg0_1.state = var0_0.StateFinish
	end
end

function var0_0.IsActivityType(arg0_2)
	return arg0_2.activityId > 0
end

function var0_0.IsStarting(arg0_3)
	return arg0_3.state ~= var0_0.StateNone
end

function var0_0.SetActivityId(arg0_4, arg1_4)
	arg0_4.activityId = arg1_4
end

function var0_0.BelongActivity(arg0_5, arg1_5)
	return arg0_5.activityId > 0 and arg0_5.activityId == arg1_5
end

function var0_0.reachNum(arg0_6)
	return arg0_6.template.ship_num <= #arg0_6.ships
end

function var0_0.reachLevel(arg0_7)
	return #arg0_7.ships > 0 and _.any(arg0_7.ships, function(arg0_8)
		return arg0_8.level >= arg0_7.template.ship_lv
	end)
end

function var0_0.reachTypes(arg0_9)
	if table.getCount(arg0_9.ships) == 0 then
		return false
	end

	local var0_9 = true

	for iter0_9, iter1_9 in ipairs(arg0_9.ships) do
		local var1_9 = iter1_9:getShipType()

		if not table.contains(arg0_9.template.ship_type, var1_9) then
			var0_9 = false

			break
		end
	end

	return var0_9
end

function var0_0.getOilConsume(arg0_10)
	return arg0_10.template.oil or 0
end

function var0_0.updateTime(arg0_11)
	local var0_11 = false

	if arg0_11.state == var0_0.StateActive and pg.TimeMgr.GetInstance():GetServerTime() > arg0_11.finishTime then
		arg0_11.state = var0_0.StateFinish
		var0_11 = true
	end

	return var0_11
end

function var0_0.getTypesStr(arg0_12)
	local var0_12 = pg.ship_data_by_type
	local var1_12 = arg0_12.template.ship_type
	local var2_12 = false

	if #var1_12 == #var0_12.all then
		var2_12 = true

		for iter0_12, iter1_12 in pairs(var0_12.all) do
			if not table.contains(var1_12, iter1_12) then
				var2_12 = false

				break
			end
		end
	end

	if var2_12 then
		return i18n("event_type_unlimit")
	else
		local var3_12 = ""

		for iter2_12, iter3_12 in ipairs(ShipType.FilterOverQuZhuType(var1_12)) do
			local var4_12 = iter2_12 == #arg0_12.template.ship_type and "" or ", "

			var3_12 = var3_12 .. var0_12[iter3_12].type_name .. var4_12
		end

		return i18n("event_condition_ship_type", var3_12)
	end
end

local var1_0 = "EVENTINFO_FORMATION_KEY_"

function var0_0.ExistPrevFormation(arg0_13)
	local var0_13 = getProxy(PlayerProxy):getRawData().id

	return PlayerPrefs.HasKey(var1_0 .. var0_13)
end

function var0_0.GetPrevFormation(arg0_14)
	local var0_14 = getProxy(PlayerProxy):getRawData().id
	local var1_14 = PlayerPrefs.GetString(var1_0 .. var0_14)
	local var2_14 = string.split(var1_14, "#")

	return _.map(var2_14, function(arg0_15)
		return tonumber(arg0_15)
	end)
end

function var0_0.SavePrevFormation(arg0_16)
	if not arg0_16:CanRecordPrevFormation() then
		return
	end

	local var0_16 = _.map(arg0_16.ships, function(arg0_17)
		return arg0_17.id
	end)

	if #var0_16 == 0 then
		var0_16 = arg0_16.shipIds
	end

	local var1_16 = table.concat(var0_16, "#")
	local var2_16 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetString(var1_0 .. var2_16, var1_16)
	PlayerPrefs.Save()
end

function var0_0.CanRecordPrevFormation(arg0_18)
	return arg0_18.template.oil >= 800
end

function var0_0.GetCountDownTime(arg0_19)
	return arg0_19.state == EventInfo.StateNone and arg0_19.overTime > 0 and arg0_19.overTime - pg.TimeMgr.GetInstance():GetServerTime()
end

return var0_0
