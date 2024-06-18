local var0_0 = math.sqrt
local var1_0 = setmetatable
local var2_0 = rawget
local var3_0 = math
local var4_0 = var3_0.acos
local var5_0 = var3_0.max
local var6_0 = {}
local var7_0 = tolua.initget(var6_0)

function var6_0.__index(arg0_1, arg1_1)
	local var0_1 = var2_0(var6_0, arg1_1)

	if var0_1 == nil then
		var0_1 = var2_0(var7_0, arg1_1)

		if var0_1 ~= nil then
			return var0_1(arg0_1)
		end
	end

	return var0_1
end

function var6_0.__call(arg0_2, arg1_2, arg2_2)
	return var1_0({
		x = arg1_2 or 0,
		y = arg2_2 or 0
	}, var6_0)
end

function var6_0.New(arg0_3, arg1_3)
	return var1_0({
		x = arg0_3 or 0,
		y = arg1_3 or 0
	}, var6_0)
end

function var6_0.Set(arg0_4, arg1_4, arg2_4)
	arg0_4.x = arg1_4 or 0
	arg0_4.y = arg2_4 or 0
end

function var6_0.Get(arg0_5)
	return arg0_5.x, arg0_5.y
end

function var6_0.SqrMagnitude(arg0_6)
	return arg0_6.x * arg0_6.x + arg0_6.y * arg0_6.y
end

function var6_0.Clone(arg0_7)
	return var1_0({
		x = arg0_7.x,
		y = arg0_7.y
	}, var6_0)
end

function var6_0.Normalize(arg0_8)
	local var0_8 = arg0_8.x
	local var1_8 = arg0_8.y
	local var2_8 = var0_0(var0_8 * var0_8 + var1_8 * var1_8)

	if var2_8 > 1e-05 then
		var0_8 = var0_8 / var2_8
		var1_8 = var1_8 / var2_8
	else
		var0_8 = 0
		var1_8 = 0
	end

	return var1_0({
		x = var0_8,
		y = var1_8
	}, var6_0)
end

function var6_0.SetNormalize(arg0_9)
	local var0_9 = var0_0(arg0_9.x * arg0_9.x + arg0_9.y * arg0_9.y)

	if var0_9 > 1e-05 then
		arg0_9.x = arg0_9.x / var0_9
		arg0_9.y = arg0_9.y / var0_9
	else
		arg0_9.x = 0
		arg0_9.y = 0
	end

	return arg0_9
end

function var6_0.Dot(arg0_10, arg1_10)
	return arg0_10.x * arg1_10.x + arg0_10.y * arg1_10.y
end

function var6_0.Angle(arg0_11, arg1_11)
	local var0_11 = arg0_11.x
	local var1_11 = arg0_11.y
	local var2_11 = var0_0(var0_11 * var0_11 + var1_11 * var1_11)

	if var2_11 > 1e-05 then
		var0_11 = var0_11 / var2_11
		var1_11 = var1_11 / var2_11
	else
		var0_11, var1_11 = 0, 0
	end

	local var3_11 = arg1_11.x
	local var4_11 = arg1_11.y
	local var5_11 = var0_0(var3_11 * var3_11 + var4_11 * var4_11)

	if var5_11 > 1e-05 then
		var3_11 = var3_11 / var5_11
		var4_11 = var4_11 / var5_11
	else
		var3_11, var4_11 = 0, 0
	end

	local var6_11 = var0_11 * var3_11 + var1_11 * var4_11

	if var6_11 < -1 then
		var6_11 = -1
	elseif var6_11 > 1 then
		var6_11 = 1
	end

	return var4_0(var6_11) * 57.29578
end

function var6_0.Magnitude(arg0_12)
	return var0_0(arg0_12.x * arg0_12.x + arg0_12.y * arg0_12.y)
end

function var6_0.Reflect(arg0_13, arg1_13)
	local var0_13 = arg0_13.x
	local var1_13 = arg0_13.y
	local var2_13 = arg1_13.x
	local var3_13 = arg1_13.y
	local var4_13 = -2 * (var0_13 * var2_13 + var1_13 * var3_13)

	return var1_0({
		x = var4_13 * var2_13 + var0_13,
		y = var4_13 * var3_13 + var1_13
	}, var6_0)
end

function var6_0.Distance(arg0_14, arg1_14)
	return var0_0((arg0_14.x - arg1_14.x)^2 + (arg0_14.y - arg1_14.y)^2)
end

function var6_0.Lerp(arg0_15, arg1_15, arg2_15)
	if arg2_15 < 0 then
		arg2_15 = 0
	elseif arg2_15 > 1 then
		arg2_15 = 1
	end

	return var1_0({
		x = arg0_15.x + (arg1_15.x - arg0_15.x) * arg2_15,
		y = arg0_15.y + (arg1_15.y - arg0_15.y) * arg2_15
	}, var6_0)
end

function var6_0.LerpUnclamped(arg0_16, arg1_16, arg2_16)
	return var1_0({
		x = arg0_16.x + (arg1_16.x - arg0_16.x) * arg2_16,
		y = arg0_16.y + (arg1_16.y - arg0_16.y) * arg2_16
	}, var6_0)
end

function var6_0.MoveTowards(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg0_17.x
	local var1_17 = arg0_17.y
	local var2_17 = arg1_17.x - var0_17
	local var3_17 = arg1_17.y - var1_17
	local var4_17 = var2_17 * var2_17 + var3_17 * var3_17

	if var4_17 > arg2_17 * arg2_17 and var4_17 ~= 0 then
		local var5_17 = arg2_17 / var0_0(var4_17)

		return var1_0({
			x = var0_17 + var2_17 * var5_17,
			y = var1_17 + var3_17 * var5_17
		}, var6_0)
	end

	return var1_0({
		x = arg1_17.x,
		y = arg1_17.y
	}, var6_0)
end

function var6_0.ClampMagnitude(arg0_18, arg1_18)
	local var0_18 = arg0_18.x
	local var1_18 = arg0_18.y
	local var2_18 = var0_18 * var0_18 + var1_18 * var1_18

	if var2_18 > arg1_18 * arg1_18 then
		local var3_18 = arg1_18 / var0_0(var2_18)

		var0_18 = var0_18 * var3_18
		var1_18 = var1_18 * var3_18

		return var1_0({
			x = var0_18,
			y = var1_18
		}, var6_0)
	end

	return var1_0({
		x = var0_18,
		y = var1_18
	}, var6_0)
end

function var6_0.SmoothDamp(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19, arg5_19)
	arg5_19 = arg5_19 or Time.deltaTime
	arg4_19 = arg4_19 or var3_0.huge
	arg3_19 = var3_0.max(0.0001, arg3_19)

	local var0_19 = 2 / arg3_19
	local var1_19 = var0_19 * arg5_19
	local var2_19 = 1 / (1 + var1_19 + 0.48 * var1_19 * var1_19 + 0.235 * var1_19 * var1_19 * var1_19)
	local var3_19 = arg1_19.x
	local var4_19 = arg1_19.y
	local var5_19 = arg0_19.x
	local var6_19 = arg0_19.y
	local var7_19 = var5_19 - var3_19
	local var8_19 = var6_19 - var4_19
	local var9_19 = var7_19 * var7_19 + var8_19 * var8_19
	local var10_19 = arg4_19 * arg3_19

	if var9_19 > var10_19 * var10_19 then
		local var11_19 = var10_19 / var0_0(var9_19)

		var7_19 = var7_19 * var11_19
		var8_19 = var8_19 * var11_19
	end

	local var12_19 = arg2_19.x
	local var13_19 = arg2_19.y
	local var14_19 = (var12_19 + var0_19 * var7_19) * arg5_19
	local var15_19 = (var13_19 + var0_19 * var8_19) * arg5_19

	arg2_19.x = (var12_19 - var0_19 * var14_19) * var2_19
	arg2_19.y = (var13_19 - var0_19 * var15_19) * var2_19

	local var16_19 = var5_19 - var7_19 + (var7_19 + var14_19) * var2_19
	local var17_19 = var6_19 - var8_19 + (var8_19 + var15_19) * var2_19

	if (var3_19 - var5_19) * (var16_19 - var3_19) + (var4_19 - var6_19) * (var17_19 - var4_19) > 0 then
		var16_19 = var3_19
		var17_19 = var4_19
		arg2_19.x = 0
		arg2_19.y = 0
	end

	return var1_0({
		x = var16_19,
		y = var17_19
	}, var6_0), arg2_19
end

function var6_0.Max(arg0_20, arg1_20)
	return var1_0({
		x = var3_0.max(arg0_20.x, arg1_20.x),
		y = var3_0.max(arg0_20.y, arg1_20.y)
	}, var6_0)
end

function var6_0.Min(arg0_21, arg1_21)
	return var1_0({
		x = var3_0.min(arg0_21.x, arg1_21.x),
		y = var3_0.min(arg0_21.y, arg1_21.y)
	}, var6_0)
end

function var6_0.Scale(arg0_22, arg1_22)
	return var1_0({
		x = arg0_22.x * arg1_22.x,
		y = arg0_22.y * arg1_22.y
	}, var6_0)
end

function var6_0.Div(arg0_23, arg1_23)
	arg0_23.x = arg0_23.x / arg1_23
	arg0_23.y = arg0_23.y / arg1_23

	return arg0_23
end

function var6_0.Mul(arg0_24, arg1_24)
	arg0_24.x = arg0_24.x * arg1_24
	arg0_24.y = arg0_24.y * arg1_24

	return arg0_24
end

function var6_0.Add(arg0_25, arg1_25)
	arg0_25.x = arg0_25.x + arg1_25.x
	arg0_25.y = arg0_25.y + arg1_25.y

	return arg0_25
end

function var6_0.Sub(arg0_26, arg1_26)
	arg0_26.x = arg0_26.x - arg1_26.x
	arg0_26.y = arg0_26.y - arg1_26.y

	return arg0_26
end

function var6_0.__tostring(arg0_27)
	return string.format("(%f,%f)", arg0_27.x, arg0_27.y)
end

function var6_0.__div(arg0_28, arg1_28)
	return var1_0({
		x = arg0_28.x / arg1_28,
		y = arg0_28.y / arg1_28
	}, var6_0)
end

function var6_0.__mul(arg0_29, arg1_29)
	if type(arg1_29) == "number" then
		return var1_0({
			x = arg0_29.x * arg1_29,
			y = arg0_29.y * arg1_29
		}, var6_0)
	else
		return var1_0({
			x = arg0_29 * arg1_29.x,
			y = arg0_29 * arg1_29.y
		}, var6_0)
	end
end

function var6_0.__add(arg0_30, arg1_30)
	return var1_0({
		x = arg0_30.x + arg1_30.x,
		y = arg0_30.y + arg1_30.y
	}, var6_0)
end

function var6_0.__sub(arg0_31, arg1_31)
	return var1_0({
		x = arg0_31.x - arg1_31.x,
		y = arg0_31.y - arg1_31.y
	}, var6_0)
end

function var6_0.__unm(arg0_32)
	return var1_0({
		x = -arg0_32.x,
		y = -arg0_32.y
	}, var6_0)
end

function var6_0.__eq(arg0_33, arg1_33)
	return (arg0_33.x - arg1_33.x)^2 + (arg0_33.y - arg1_33.y)^2 < 9.999999e-11
end

function var7_0.up()
	return var1_0({
		x = 0,
		y = 1
	}, var6_0)
end

function var7_0.right()
	return var1_0({
		x = 1,
		y = 0
	}, var6_0)
end

function var7_0.zero()
	return var1_0({
		x = 0,
		y = 0
	}, var6_0)
end

function var7_0.one()
	return var1_0({
		x = 1,
		y = 1
	}, var6_0)
end

var7_0.magnitude = var6_0.Magnitude
var7_0.normalized = var6_0.Normalize
var7_0.sqrMagnitude = var6_0.SqrMagnitude
UnityEngine.Vector2 = var6_0

var1_0(var6_0, var6_0)

return var6_0
