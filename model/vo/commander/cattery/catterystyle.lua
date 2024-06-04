local var0 = class("CatteryStyle", import("...BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.own = arg1.own
end

function var0.bindConfigTable(arg0)
	return pg.commander_home_style
end

function var0.IsOwn(arg0)
	return arg0.own
end

function var0.GetName(arg0, arg1)
	local var0 = arg0:getConfig("name")

	return arg1 and var0 .. "_d" or var0
end

return var0
