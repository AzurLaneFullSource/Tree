local var0_0 = class("CatteryStyle", import("...BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.own = arg1_1.own
end

function var0_0.bindConfigTable(arg0_2)
	return pg.commander_home_style
end

function var0_0.IsOwn(arg0_3)
	return arg0_3.own
end

function var0_0.GetName(arg0_4, arg1_4)
	local var0_4 = arg0_4:getConfig("name")

	return arg1_4 and var0_4 .. "_d" or var0_4
end

return var0_0
