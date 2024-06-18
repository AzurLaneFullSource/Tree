local var0_0 = class("Returner", import(".PlayerAttire"))

function var0_0.Ctor(arg0_1, arg1_1)
	local var0_1 = arg1_1.user or {}

	var0_0.super.Ctor(arg0_1, var0_1)

	arg0_1.pt = arg1_1.pt or 0
	arg0_1.id = var0_1.id or 0
	arg0_1.name = var0_1.name
end

function var0_0.getName(arg0_2)
	return arg0_2.name
end

function var0_0.getIcon(arg0_3)
	return arg0_3.icon
end

function var0_0.getPt(arg0_4)
	return arg0_4.pt
end

return var0_0
