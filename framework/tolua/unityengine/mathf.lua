local var0_0 = math
local var1_0 = var0_0.floor
local var2_0 = var0_0.abs
local var3_0 = Mathf

var3_0.Deg2Rad = var0_0.rad(1)
var3_0.Epsilon = 1.4013e-45
var3_0.Infinity = var0_0.huge
var3_0.NegativeInfinity = -var0_0.huge
var3_0.PI = var0_0.pi
var3_0.Rad2Deg = var0_0.deg(1)
var3_0.Abs = var0_0.abs
var3_0.Acos = var0_0.acos
var3_0.Asin = var0_0.asin
var3_0.Atan = var0_0.atan
var3_0.Atan2 = var0_0.atan2
var3_0.Ceil = var0_0.ceil
var3_0.Cos = var0_0.cos
var3_0.Exp = var0_0.exp
var3_0.Floor = var0_0.floor
var3_0.Log = var0_0.log
var3_0.Log10 = var0_0.log10
var3_0.Max = var0_0.max
var3_0.Min = var0_0.min
var3_0.Pow = var0_0.pow
var3_0.Sin = var0_0.sin
var3_0.Sqrt = var0_0.sqrt
var3_0.Tan = var0_0.tan
var3_0.Deg = var0_0.deg
var3_0.Rad = var0_0.rad
var3_0.Random = var0_0.random

function var3_0.Approximately(arg0_1, arg1_1)
	return var2_0(arg1_1 - arg0_1) < var0_0.max(1e-06 * var0_0.max(var2_0(arg0_1), var2_0(arg1_1)), 1.121039e-44)
end

function var3_0.Clamp(arg0_2, arg1_2, arg2_2)
	if arg0_2 < arg1_2 then
		arg0_2 = arg1_2
	elseif arg2_2 < arg0_2 then
		arg0_2 = arg2_2
	end

	return arg0_2
end

function var3_0.Clamp01(arg0_3)
	if arg0_3 < 0 then
		return 0
	elseif arg0_3 > 1 then
		return 1
	end

	return arg0_3
end

function var3_0.DeltaAngle(arg0_4, arg1_4)
	local var0_4 = var3_0.Repeat(arg1_4 - arg0_4, 360)

	if var0_4 > 180 then
		var0_4 = var0_4 - 360
	end

	return var0_4
end

function var3_0.Gamma(arg0_5, arg1_5, arg2_5)
	local var0_5 = false

	if arg0_5 < 0 then
		var0_5 = true
	end

	local var1_5 = var2_0(arg0_5)

	if arg1_5 < var1_5 then
		return not var0_5 and var1_5 or -var1_5
	end

	local var2_5 = var0_0.pow(var1_5 / arg1_5, arg2_5) * arg1_5

	return not var0_5 and var2_5 or -var2_5
end

function var3_0.InverseLerp(arg0_6, arg1_6, arg2_6)
	if arg0_6 < arg1_6 then
		if arg2_6 < arg0_6 then
			return 0
		end

		if arg1_6 < arg2_6 then
			return 1
		end

		arg2_6 = arg2_6 - arg0_6
		arg2_6 = arg2_6 / (arg1_6 - arg0_6)

		return arg2_6
	end

	if arg0_6 <= arg1_6 then
		return 0
	end

	if arg2_6 < arg1_6 then
		return 1
	end

	if arg0_6 < arg2_6 then
		return 0
	end

	return 1 - (arg2_6 - arg1_6) / (arg0_6 - arg1_6)
end

function var3_0.Lerp(arg0_7, arg1_7, arg2_7)
	return arg0_7 + (arg1_7 - arg0_7) * var3_0.Clamp01(arg2_7)
end

function var3_0.LerpAngle(arg0_8, arg1_8, arg2_8)
	local var0_8 = var3_0.Repeat(arg1_8 - arg0_8, 360)

	if var0_8 > 180 then
		var0_8 = var0_8 - 360
	end

	return arg0_8 + var0_8 * var3_0.Clamp01(arg2_8)
end

function var3_0.LerpUnclamped(arg0_9, arg1_9, arg2_9)
	return arg0_9 + (arg1_9 - arg0_9) * arg2_9
end

function var3_0.MoveTowards(arg0_10, arg1_10, arg2_10)
	if arg2_10 >= var2_0(arg1_10 - arg0_10) then
		return arg1_10
	end

	return arg0_10 + var3_0.Sign(arg1_10 - arg0_10) * arg2_10
end

function var3_0.MoveTowardsAngle(arg0_11, arg1_11, arg2_11)
	arg1_11 = arg0_11 + var3_0.DeltaAngle(arg0_11, arg1_11)

	return var3_0.MoveTowards(arg0_11, arg1_11, arg2_11)
end

function var3_0.PingPong(arg0_12, arg1_12)
	arg0_12 = var3_0.Repeat(arg0_12, arg1_12 * 2)

	return arg1_12 - var2_0(arg0_12 - arg1_12)
end

function var3_0.Repeat(arg0_13, arg1_13)
	return arg0_13 - var1_0(arg0_13 / arg1_13) * arg1_13
end

function var3_0.Round(arg0_14)
	return var1_0(arg0_14 + 0.5)
end

function var3_0.Sign(arg0_15)
	arg0_15 = arg0_15 > 0 and 1 or arg0_15 < 0 and -1 or 0

	return arg0_15
end

function var3_0.SmoothDamp(arg0_16, arg1_16, arg2_16, arg3_16, arg4_16, arg5_16)
	arg4_16 = arg4_16 or var3_0.Infinity
	arg5_16 = arg5_16 or Time.deltaTime
	arg3_16 = var3_0.Max(0.0001, arg3_16)

	local var0_16 = 2 / arg3_16
	local var1_16 = var0_16 * arg5_16
	local var2_16 = 1 / (1 + var1_16 + 0.48 * var1_16 * var1_16 + 0.235 * var1_16 * var1_16 * var1_16)
	local var3_16 = arg0_16 - arg1_16
	local var4_16 = arg1_16
	local var5_16 = arg4_16 * arg3_16
	local var6_16 = var3_0.Clamp(var3_16, -var5_16, var5_16)

	arg1_16 = arg0_16 - var6_16

	local var7_16 = (arg2_16 + var0_16 * var6_16) * arg5_16

	arg2_16 = (arg2_16 - var0_16 * var7_16) * var2_16

	local var8_16 = arg1_16 + (var6_16 + var7_16) * var2_16

	if arg0_16 < var4_16 == (var4_16 < var8_16) then
		var8_16 = var4_16
		arg2_16 = (var8_16 - var4_16) / arg5_16
	end

	return var8_16, arg2_16
end

function var3_0.SmoothDampAngle(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17, arg5_17)
	arg5_17 = arg5_17 or Time.deltaTime
	arg4_17 = arg4_17 or var3_0.Infinity
	arg1_17 = arg0_17 + var3_0.DeltaAngle(arg0_17, arg1_17)

	return var3_0.SmoothDamp(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17, arg5_17)
end

function var3_0.SmoothStep(arg0_18, arg1_18, arg2_18)
	arg2_18 = var3_0.Clamp01(arg2_18)
	arg2_18 = -2 * arg2_18 * arg2_18 * arg2_18 + 3 * arg2_18 * arg2_18

	return arg1_18 * arg2_18 + arg0_18 * (1 - arg2_18)
end

function var3_0.HorizontalAngle(arg0_19)
	return var0_0.deg(var0_0.atan2(arg0_19.x, arg0_19.z))
end

function var3_0.IsNan(arg0_20)
	return arg0_20 ~= arg0_20
end

function var3_0.MultiRandom(arg0_21, arg1_21)
	local var0_21 = {}
	local var1_21 = {}

	for iter0_21, iter1_21 in ipairs(arg0_21) do
		table.insert(var1_21, iter0_21)
	end

	arg1_21 = var0_0.min(#arg0_21, arg1_21)

	while arg1_21 > 0 do
		local var2_21 = var0_0.random(#var1_21)
		local var3_21 = table.remove(var1_21, var2_21)

		table.insert(var0_21, arg0_21[var3_21])

		arg1_21 = arg1_21 - 1
	end

	return var0_21
end

function var3_0.RandomFloat(arg0_22, arg1_22, arg2_22)
	arg1_22 = arg1_22 or 0
	arg2_22 = arg2_22 or 10000
	arg1_22 = arg1_22 * arg2_22
	arg0_22 = arg0_22 * arg2_22

	return var0_0.random(arg1_22, arg0_22) / arg2_22
end

UnityEngine.Mathf = var3_0

return var3_0
