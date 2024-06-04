local var0 = class("EventInfo", import(".BaseVO"))

var0.StateNone = 0
var0.StateActive = 1
var0.StateFinish = 2

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.template = pg.collection_template[arg0.id]

	assert(arg0.template, "pg.collection_template>>>" .. arg0.id)

	arg0.finishTime = arg1.finish_time
	arg0.overTime = arg1.over_time
	arg0.shipIds = arg1.ship_id_list or {}
	arg0.ships = {}
	arg0.state = var0.StateNone
	arg0.activityId = arg1.activity_id or 0

	if arg0.finishTime == 0 then
		arg0.state = var0.StateNone
	elseif arg0.finishTime >= pg.TimeMgr.GetInstance():GetServerTime() then
		arg0.state = var0.StateActive
	else
		arg0.state = var0.StateFinish
	end
end

function var0.IsActivityType(arg0)
	return arg0.activityId > 0
end

function var0.IsStarting(arg0)
	return arg0.state ~= var0.StateNone
end

function var0.SetActivityId(arg0, arg1)
	arg0.activityId = arg1
end

function var0.BelongActivity(arg0, arg1)
	return arg0.activityId > 0 and arg0.activityId == arg1
end

function var0.reachNum(arg0)
	return arg0.template.ship_num <= #arg0.ships
end

function var0.reachLevel(arg0)
	return #arg0.ships > 0 and _.any(arg0.ships, function(arg0)
		return arg0.level >= arg0.template.ship_lv
	end)
end

function var0.reachTypes(arg0)
	if table.getCount(arg0.ships) == 0 then
		return false
	end

	local var0 = true

	for iter0, iter1 in ipairs(arg0.ships) do
		local var1 = iter1:getShipType()

		if not table.contains(arg0.template.ship_type, var1) then
			var0 = false

			break
		end
	end

	return var0
end

function var0.getOilConsume(arg0)
	return arg0.template.oil or 0
end

function var0.updateTime(arg0)
	local var0 = false

	if arg0.state == var0.StateActive and pg.TimeMgr.GetInstance():GetServerTime() > arg0.finishTime then
		arg0.state = var0.StateFinish
		var0 = true
	end

	return var0
end

function var0.getTypesStr(arg0)
	local var0 = pg.ship_data_by_type
	local var1 = arg0.template.ship_type
	local var2 = false

	if #var1 == #var0.all then
		var2 = true

		for iter0, iter1 in pairs(var0.all) do
			if not table.contains(var1, iter1) then
				var2 = false

				break
			end
		end
	end

	if var2 then
		return i18n("event_type_unlimit")
	else
		local var3 = ""

		for iter2, iter3 in ipairs(ShipType.FilterOverQuZhuType(var1)) do
			local var4 = iter2 == #arg0.template.ship_type and "" or ", "

			var3 = var3 .. var0[iter3].type_name .. var4
		end

		return i18n("event_condition_ship_type", var3)
	end
end

local var1 = "EVENTINFO_FORMATION_KEY_"

function var0.ExistPrevFormation(arg0)
	local var0 = getProxy(PlayerProxy):getRawData().id

	return PlayerPrefs.HasKey(var1 .. var0)
end

function var0.GetPrevFormation(arg0)
	local var0 = getProxy(PlayerProxy):getRawData().id
	local var1 = PlayerPrefs.GetString(var1 .. var0)
	local var2 = string.split(var1, "#")

	return _.map(var2, function(arg0)
		return tonumber(arg0)
	end)
end

function var0.SavePrevFormation(arg0)
	if not arg0:CanRecordPrevFormation() then
		return
	end

	local var0 = _.map(arg0.ships, function(arg0)
		return arg0.id
	end)

	if #var0 == 0 then
		var0 = arg0.shipIds
	end

	local var1 = table.concat(var0, "#")
	local var2 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetString(var1 .. var2, var1)
	PlayerPrefs.Save()
end

function var0.CanRecordPrevFormation(arg0)
	return arg0.template.oil >= 800
end

function var0.GetCountDownTime(arg0)
	return arg0.state == EventInfo.StateNone and arg0.overTime > 0 and arg0.overTime - pg.TimeMgr.GetInstance():GetServerTime()
end

return var0
