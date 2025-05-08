local var0_0 = class("IslandShipStatus", import("model.vo.BaseVO"))

var0_0.TYPE_BUFF = 1
var0_0.TYPE_DEBUFF = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg1_1.id
	arg0_1.time = arg1_1.end_time or 0
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_ship_state
end

function var0_0.AddTime(arg0_3, arg1_3)
	local var0_3 = pg.TimeMgr.GetInstance():GetServerTime()

	arg0_3.time = math.max(arg0_3.time, var0_3) + arg1_3
end

function var0_0.IsExpiration(arg0_4)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0_4.time
end

function var0_0.GetDesc(arg0_5)
	return arg0_5:getConfig("desc")
end

function var0_0.GetIcon(arg0_6)
	return arg0_6:getConfig("icon")
end

function var0_0.GetName(arg0_7)
	return arg0_7:getConfig("name")
end

function var0_0.IsDebuff(arg0_8)
	return arg0_8:getConfig("type") == var0_0.TYPE_DEBUFF
end

return var0_0
