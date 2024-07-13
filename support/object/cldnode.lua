pg = pg or {}

local var0_0 = pg
local var1_0 = class("CldNode")

var0_0.CldNode = var1_0

function var1_0.Ctor(arg0_1, arg1_1)
	arg0_1.cylinder = false
end

function var1_0.UpdateBox(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.min = arg1_2:Copy2(arg0_2.min)
	arg0_2.max = arg2_2:Copy2(arg0_2.max)

	if arg3_2 then
		arg0_2.min:Add(arg3_2)
		arg0_2.max:Add(arg3_2)
	end

	return arg0_2
end

function var1_0.UpdateStaticBox(arg0_3, arg1_3, arg2_3)
	arg0_3.min = arg1_3
	arg0_3.max = arg2_3

	return arg0_3
end

function var1_0.UpdateCylinder(arg0_4, arg1_4, arg2_4, arg3_4)
	if arg3_4 < 0 then
		arg3_4 = -arg3_4
	end

	arg0_4.center = arg1_4:Copy2(arg0_4.center)
	arg0_4.range = arg3_4

	local var0_4 = Vector3(arg3_4, arg2_4, arg3_4)

	arg0_4.min = arg1_4 - var0_4
	arg0_4.max = arg1_4 + var0_4
	arg0_4.cylinder = true

	return arg0_4
end
