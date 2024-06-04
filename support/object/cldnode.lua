pg = pg or {}

local var0 = pg
local var1 = class("CldNode")

var0.CldNode = var1

function var1.Ctor(arg0, arg1)
	arg0.cylinder = false
end

function var1.UpdateBox(arg0, arg1, arg2, arg3)
	arg0.min = arg1:Copy2(arg0.min)
	arg0.max = arg2:Copy2(arg0.max)

	if arg3 then
		arg0.min:Add(arg3)
		arg0.max:Add(arg3)
	end

	return arg0
end

function var1.UpdateStaticBox(arg0, arg1, arg2)
	arg0.min = arg1
	arg0.max = arg2

	return arg0
end

function var1.UpdateCylinder(arg0, arg1, arg2, arg3)
	if arg3 < 0 then
		arg3 = -arg3
	end

	arg0.center = arg1:Copy2(arg0.center)
	arg0.range = arg3

	local var0 = Vector3(arg3, arg2, arg3)

	arg0.min = arg1 - var0
	arg0.max = arg1 + var0
	arg0.cylinder = true

	return arg0
end
