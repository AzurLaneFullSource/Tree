local var0_0 = Mathf.Clamp
local var1_0 = Mathf.Sqrt
local var2_0 = Mathf.Min
local var3_0 = Mathf.Max
local var4_0 = setmetatable
local var5_0 = rawget
local var6_0 = {}
local var7_0 = tolua.initget(var6_0)

function var6_0.__index(arg0_1, arg1_1)
	local var0_1 = var5_0(var6_0, arg1_1)

	if var0_1 == nil then
		var0_1 = var5_0(var7_0, arg1_1)

		if var0_1 ~= nil then
			return var0_1(arg0_1)
		end
	end

	return var0_1
end

function var6_0.__call(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	return var4_0({
		x = arg1_2 or 0,
		y = arg2_2 or 0,
		z = arg3_2 or 0,
		w = arg4_2 or 0
	}, var6_0)
end

function var6_0.New(arg0_3, arg1_3, arg2_3, arg3_3)
	return var4_0({
		x = arg0_3 or 0,
		y = arg1_3 or 0,
		z = arg2_3 or 0,
		w = arg3_3 or 0
	}, var6_0)
end

function var6_0.Set(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
	arg0_4.x = arg1_4 or 0
	arg0_4.y = arg2_4 or 0
	arg0_4.z = arg3_4 or 0
	arg0_4.w = arg4_4 or 0
end

function var6_0.Get(arg0_5)
	return arg0_5.x, arg0_5.y, arg0_5.z, arg0_5.w
end

function var6_0.Lerp(arg0_6, arg1_6, arg2_6)
	arg2_6 = var0_0(arg2_6, 0, 1)

	return var6_0.New(arg0_6.x + (arg1_6.x - arg0_6.x) * arg2_6, arg0_6.y + (arg1_6.y - arg0_6.y) * arg2_6, arg0_6.z + (arg1_6.z - arg0_6.z) * arg2_6, arg0_6.w + (arg1_6.w - arg0_6.w) * arg2_6)
end

function var6_0.MoveTowards(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg1_7 - arg0_7
	local var1_7 = var0_7:Magnitude()

	if arg2_7 < var1_7 and var1_7 ~= 0 then
		arg2_7 = arg2_7 / var1_7

		var0_7:Mul(arg2_7)
		var0_7:Add(arg0_7)

		return var0_7
	end

	return arg1_7
end

function var6_0.Scale(arg0_8, arg1_8)
	return var6_0.New(arg0_8.x * arg1_8.x, arg0_8.y * arg1_8.y, arg0_8.z * arg1_8.z, arg0_8.w * arg1_8.w)
end

function var6_0.SetScale(arg0_9, arg1_9)
	arg0_9.x = arg0_9.x * arg1_9.x
	arg0_9.y = arg0_9.y * arg1_9.y
	arg0_9.z = arg0_9.z * arg1_9.z
	arg0_9.w = arg0_9.w * arg1_9.w
end

function var6_0.Normalize(arg0_10)
	return vector4.New(arg0_10.x, arg0_10.y, arg0_10.z, arg0_10.w):SetNormalize()
end

function var6_0.SetNormalize(arg0_11)
	local var0_11 = arg0_11:Magnitude()

	if var0_11 == 1 then
		return arg0_11
	elseif var0_11 > 1e-05 then
		arg0_11:Div(var0_11)
	else
		arg0_11:Set(0, 0, 0, 0)
	end

	return arg0_11
end

function var6_0.Div(arg0_12, arg1_12)
	arg0_12.x = arg0_12.x / arg1_12
	arg0_12.y = arg0_12.y / arg1_12
	arg0_12.z = arg0_12.z / arg1_12
	arg0_12.w = arg0_12.w / arg1_12

	return arg0_12
end

function var6_0.Mul(arg0_13, arg1_13)
	arg0_13.x = arg0_13.x * arg1_13
	arg0_13.y = arg0_13.y * arg1_13
	arg0_13.z = arg0_13.z * arg1_13
	arg0_13.w = arg0_13.w * arg1_13

	return arg0_13
end

function var6_0.Add(arg0_14, arg1_14)
	arg0_14.x = arg0_14.x + arg1_14.x
	arg0_14.y = arg0_14.y + arg1_14.y
	arg0_14.z = arg0_14.z + arg1_14.z
	arg0_14.w = arg0_14.w + arg1_14.w

	return arg0_14
end

function var6_0.Sub(arg0_15, arg1_15)
	arg0_15.x = arg0_15.x - arg1_15.x
	arg0_15.y = arg0_15.y - arg1_15.y
	arg0_15.z = arg0_15.z - arg1_15.z
	arg0_15.w = arg0_15.w - arg1_15.w

	return arg0_15
end

function var6_0.Dot(arg0_16, arg1_16)
	return arg0_16.x * arg1_16.x + arg0_16.y * arg1_16.y + arg0_16.z * arg1_16.z + arg0_16.w * arg1_16.w
end

function var6_0.Project(arg0_17, arg1_17)
	return arg1_17 * (var6_0.Dot(arg0_17, arg1_17) / var6_0.Dot(arg1_17, arg1_17))
end

function var6_0.Distance(arg0_18, arg1_18)
	local var0_18 = arg0_18 - arg1_18

	return var6_0.Magnitude(var0_18)
end

function var6_0.Magnitude(arg0_19)
	return var1_0(arg0_19.x * arg0_19.x + arg0_19.y * arg0_19.y + arg0_19.z * arg0_19.z + arg0_19.w * arg0_19.w)
end

function var6_0.SqrMagnitude(arg0_20)
	return arg0_20.x * arg0_20.x + arg0_20.y * arg0_20.y + arg0_20.z * arg0_20.z + arg0_20.w * arg0_20.w
end

function var6_0.Min(arg0_21, arg1_21)
	return var6_0.New(var3_0(arg0_21.x, arg1_21.x), var3_0(arg0_21.y, arg1_21.y), var3_0(arg0_21.z, arg1_21.z), var3_0(arg0_21.w, arg1_21.w))
end

function var6_0.Max(arg0_22, arg1_22)
	return var6_0.New(var2_0(arg0_22.x, arg1_22.x), var2_0(arg0_22.y, arg1_22.y), var2_0(arg0_22.z, arg1_22.z), var2_0(arg0_22.w, arg1_22.w))
end

function var6_0.__tostring(arg0_23)
	return string.format("[%f,%f,%f,%f]", arg0_23.x, arg0_23.y, arg0_23.z, arg0_23.w)
end

function var6_0.__div(arg0_24, arg1_24)
	return var6_0.New(arg0_24.x / arg1_24, arg0_24.y / arg1_24, arg0_24.z / arg1_24, arg0_24.w / arg1_24)
end

function var6_0.__mul(arg0_25, arg1_25)
	return var6_0.New(arg0_25.x * arg1_25, arg0_25.y * arg1_25, arg0_25.z * arg1_25, arg0_25.w * arg1_25)
end

function var6_0.__add(arg0_26, arg1_26)
	return var6_0.New(arg0_26.x + arg1_26.x, arg0_26.y + arg1_26.y, arg0_26.z + arg1_26.z, arg0_26.w + arg1_26.w)
end

function var6_0.__sub(arg0_27, arg1_27)
	return var6_0.New(arg0_27.x - arg1_27.x, arg0_27.y - arg1_27.y, arg0_27.z - arg1_27.z, arg0_27.w - arg1_27.w)
end

function var6_0.__unm(arg0_28)
	return var6_0.New(-arg0_28.x, -arg0_28.y, -arg0_28.z, -arg0_28.w)
end

function var6_0.__eq(arg0_29, arg1_29)
	local var0_29 = arg0_29 - arg1_29

	return var6_0.SqrMagnitude(var0_29) < 1e-10
end

function var7_0.zero()
	return var6_0.New(0, 0, 0, 0)
end

function var7_0.one()
	return var6_0.New(1, 1, 1, 1)
end

var7_0.magnitude = var6_0.Magnitude
var7_0.normalized = var6_0.Normalize
var7_0.sqrMagnitude = var6_0.SqrMagnitude
UnityEngine.Vector4 = var6_0

var4_0(var6_0, var6_0)

return var6_0
