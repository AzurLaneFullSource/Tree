local var0_0 = setmetatable
local var1_0 = Mathf
local var2_0 = Vector3
local var3_0 = {}

function var3_0.__index(arg0_1, arg1_1)
	return rawget(var3_0, arg1_1)
end

function var3_0.__call(arg0_2, arg1_2)
	return var3_0.New(arg1_2)
end

function var3_0.New(arg0_3, arg1_3)
	return var0_0({
		normal = arg0_3:Normalize(),
		distance = arg1_3
	}, var3_0)
end

function var3_0.Get(arg0_4)
	return arg0_4.normal, arg0_4.distance
end

function var3_0.Raycast(arg0_5, arg1_5)
	local var0_5 = var2_0.Dot(arg1_5.direction, arg0_5.normal)
	local var1_5 = -var2_0.Dot(arg1_5.origin, arg0_5.normal) - arg0_5.distance

	if var1_0.Approximately(var0_5, 0) then
		return false, 0
	end

	local var2_5 = var1_5 / var0_5

	return var2_5 > 0, var2_5
end

function var3_0.SetNormalAndPosition(arg0_6, arg1_6, arg2_6)
	arg0_6.normal = arg1_6:Normalize()
	arg0_6.distance = -var2_0.Dot(arg1_6, arg2_6)
end

function var3_0.Set3Points(arg0_7, arg1_7, arg2_7, arg3_7)
	arg0_7.normal = var2_0.Normalize(var2_0.Cross(arg2_7 - arg1_7, arg3_7 - arg1_7))
	arg0_7.distance = -var2_0.Dot(arg0_7.normal, arg1_7)
end

function var3_0.GetDistanceToPoint(arg0_8, arg1_8)
	return var2_0.Dot(arg0_8.normal, arg1_8) + arg0_8.distance
end

function var3_0.GetSide(arg0_9, arg1_9)
	return var2_0.Dot(arg0_9.normal, arg1_9) + arg0_9.distance > 0
end

function var3_0.SameSide(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10:GetDistanceToPoint(arg1_10)
	local var1_10 = arg0_10:GetDistanceToPoint(arg2_10)

	return var0_10 > 0 and var1_10 > 0 or var0_10 <= 0 and var1_10 <= 0
end

UnityEngine.Plane = var3_0

var0_0(var3_0, var3_0)

return var3_0
