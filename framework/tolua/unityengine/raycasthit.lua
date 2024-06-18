local var0_0 = rawget
local var1_0 = setmetatable

RaycastBits = {
	ALL = 31,
	Collider = 1,
	Point = 4,
	Transform = 16,
	Normal = 2,
	Rigidbody = 8
}

local var2_0 = RaycastBits
local var3_0 = {}
local var4_0 = tolua.initget(var3_0)

function var3_0.__index(arg0_1, arg1_1)
	local var0_1 = var0_0(var3_0, arg1_1)

	if var0_1 == nil then
		var0_1 = var0_0(var4_0, arg1_1)

		if var0_1 ~= nil then
			return var0_1(arg0_1)
		end
	end

	return var0_1
end

function var3_0.New(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2, arg5_2)
	local var0_2 = {
		collider = arg0_2,
		distance = arg1_2,
		normal = arg2_2,
		point = arg3_2,
		rigidbody = arg4_2,
		transform = arg5_2
	}

	var1_0(var0_2, var3_0)

	return var0_2
end

function var3_0.Init(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3, arg5_3, arg6_3)
	arg0_3.collider = arg1_3
	arg0_3.distance = arg2_3
	arg0_3.normal = arg3_3
	arg0_3.point = arg4_3
	arg0_3.rigidbody = arg5_3
	arg0_3.transform = arg6_3
end

function var3_0.Get(arg0_4)
	return arg0_4.collider, arg0_4.distance, arg0_4.normal, arg0_4.point, arg0_4.rigidbody, arg0_4.transform
end

function var3_0.Destroy(arg0_5)
	arg0_5.collider = nil
	arg0_5.rigidbody = nil
	arg0_5.transform = nil
end

function var3_0.GetMask(...)
	local var0_6 = {
		...
	}
	local var1_6 = 0

	for iter0_6 = 1, #var0_6 do
		local var2_6 = var2_0[var0_6[iter0_6]] or 0

		if var2_6 ~= 0 then
			var1_6 = var1_6 + var2_6
		end
	end

	if var1_6 == 0 then
		var1_6 = var2_0.all
	end

	return var1_6
end

UnityEngine.RaycastHit = var3_0

var1_0(var3_0, var3_0)

return var3_0
