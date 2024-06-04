local var0 = setmetatable
local var1 = Mathf
local var2 = Vector3
local var3 = {}

function var3.__index(arg0, arg1)
	return rawget(var3, arg1)
end

function var3.__call(arg0, arg1)
	return var3.New(arg1)
end

function var3.New(arg0, arg1)
	return var0({
		normal = arg0:Normalize(),
		distance = arg1
	}, var3)
end

function var3.Get(arg0)
	return arg0.normal, arg0.distance
end

function var3.Raycast(arg0, arg1)
	local var0 = var2.Dot(arg1.direction, arg0.normal)
	local var1 = -var2.Dot(arg1.origin, arg0.normal) - arg0.distance

	if var1.Approximately(var0, 0) then
		return false, 0
	end

	local var2 = var1 / var0

	return var2 > 0, var2
end

function var3.SetNormalAndPosition(arg0, arg1, arg2)
	arg0.normal = arg1:Normalize()
	arg0.distance = -var2.Dot(arg1, arg2)
end

function var3.Set3Points(arg0, arg1, arg2, arg3)
	arg0.normal = var2.Normalize(var2.Cross(arg2 - arg1, arg3 - arg1))
	arg0.distance = -var2.Dot(arg0.normal, arg1)
end

function var3.GetDistanceToPoint(arg0, arg1)
	return var2.Dot(arg0.normal, arg1) + arg0.distance
end

function var3.GetSide(arg0, arg1)
	return var2.Dot(arg0.normal, arg1) + arg0.distance > 0
end

function var3.SameSide(arg0, arg1, arg2)
	local var0 = arg0:GetDistanceToPoint(arg1)
	local var1 = arg0:GetDistanceToPoint(arg2)

	return var0 > 0 and var1 > 0 or var0 <= 0 and var1 <= 0
end

UnityEngine.Plane = var3

var0(var3, var3)

return var3
