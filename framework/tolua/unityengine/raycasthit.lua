local var0 = rawget
local var1 = setmetatable

RaycastBits = {
	ALL = 31,
	Collider = 1,
	Point = 4,
	Transform = 16,
	Normal = 2,
	Rigidbody = 8
}

local var2 = RaycastBits
local var3 = {}
local var4 = tolua.initget(var3)

function var3.__index(arg0, arg1)
	local var0 = var0(var3, arg1)

	if var0 == nil then
		var0 = var0(var4, arg1)

		if var0 ~= nil then
			return var0(arg0)
		end
	end

	return var0
end

function var3.New(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = {
		collider = arg0,
		distance = arg1,
		normal = arg2,
		point = arg3,
		rigidbody = arg4,
		transform = arg5
	}

	var1(var0, var3)

	return var0
end

function var3.Init(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	arg0.collider = arg1
	arg0.distance = arg2
	arg0.normal = arg3
	arg0.point = arg4
	arg0.rigidbody = arg5
	arg0.transform = arg6
end

function var3.Get(arg0)
	return arg0.collider, arg0.distance, arg0.normal, arg0.point, arg0.rigidbody, arg0.transform
end

function var3.Destroy(arg0)
	arg0.collider = nil
	arg0.rigidbody = nil
	arg0.transform = nil
end

function var3.GetMask(...)
	local var0 = {
		...
	}
	local var1 = 0

	for iter0 = 1, #var0 do
		local var2 = var2[var0[iter0]] or 0

		if var2 ~= 0 then
			var1 = var1 + var2
		end
	end

	if var1 == 0 then
		var1 = var2.all
	end

	return var1
end

UnityEngine.RaycastHit = var3

var1(var3, var3)

return var3
