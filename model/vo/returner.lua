local var0 = class("Returner", import(".PlayerAttire"))

function var0.Ctor(arg0, arg1)
	local var0 = arg1.user or {}

	var0.super.Ctor(arg0, var0)

	arg0.pt = arg1.pt or 0
	arg0.id = var0.id or 0
	arg0.name = var0.name
end

function var0.getName(arg0)
	return arg0.name
end

function var0.getIcon(arg0)
	return arg0.icon
end

function var0.getPt(arg0)
	return arg0.pt
end

return var0
