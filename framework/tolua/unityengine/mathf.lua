local var0 = math
local var1 = var0.floor
local var2 = var0.abs
local var3 = Mathf

var3.Deg2Rad = var0.rad(1)
var3.Epsilon = 1.4013e-45
var3.Infinity = var0.huge
var3.NegativeInfinity = -var0.huge
var3.PI = var0.pi
var3.Rad2Deg = var0.deg(1)
var3.Abs = var0.abs
var3.Acos = var0.acos
var3.Asin = var0.asin
var3.Atan = var0.atan
var3.Atan2 = var0.atan2
var3.Ceil = var0.ceil
var3.Cos = var0.cos
var3.Exp = var0.exp
var3.Floor = var0.floor
var3.Log = var0.log
var3.Log10 = var0.log10
var3.Max = var0.max
var3.Min = var0.min
var3.Pow = var0.pow
var3.Sin = var0.sin
var3.Sqrt = var0.sqrt
var3.Tan = var0.tan
var3.Deg = var0.deg
var3.Rad = var0.rad
var3.Random = var0.random

function var3.Approximately(arg0, arg1)
	return var2(arg1 - arg0) < var0.max(1e-06 * var0.max(var2(arg0), var2(arg1)), 1.121039e-44)
end

function var3.Clamp(arg0, arg1, arg2)
	if arg0 < arg1 then
		arg0 = arg1
	elseif arg2 < arg0 then
		arg0 = arg2
	end

	return arg0
end

function var3.Clamp01(arg0)
	if arg0 < 0 then
		return 0
	elseif arg0 > 1 then
		return 1
	end

	return arg0
end

function var3.DeltaAngle(arg0, arg1)
	local var0 = var3.Repeat(arg1 - arg0, 360)

	if var0 > 180 then
		var0 = var0 - 360
	end

	return var0
end

function var3.Gamma(arg0, arg1, arg2)
	local var0 = false

	if arg0 < 0 then
		var0 = true
	end

	local var1 = var2(arg0)

	if arg1 < var1 then
		return not var0 and var1 or -var1
	end

	local var2 = var0.pow(var1 / arg1, arg2) * arg1

	return not var0 and var2 or -var2
end

function var3.InverseLerp(arg0, arg1, arg2)
	if arg0 < arg1 then
		if arg2 < arg0 then
			return 0
		end

		if arg1 < arg2 then
			return 1
		end

		arg2 = arg2 - arg0
		arg2 = arg2 / (arg1 - arg0)

		return arg2
	end

	if arg0 <= arg1 then
		return 0
	end

	if arg2 < arg1 then
		return 1
	end

	if arg0 < arg2 then
		return 0
	end

	return 1 - (arg2 - arg1) / (arg0 - arg1)
end

function var3.Lerp(arg0, arg1, arg2)
	return arg0 + (arg1 - arg0) * var3.Clamp01(arg2)
end

function var3.LerpAngle(arg0, arg1, arg2)
	local var0 = var3.Repeat(arg1 - arg0, 360)

	if var0 > 180 then
		var0 = var0 - 360
	end

	return arg0 + var0 * var3.Clamp01(arg2)
end

function var3.LerpUnclamped(arg0, arg1, arg2)
	return arg0 + (arg1 - arg0) * arg2
end

function var3.MoveTowards(arg0, arg1, arg2)
	if arg2 >= var2(arg1 - arg0) then
		return arg1
	end

	return arg0 + var3.Sign(arg1 - arg0) * arg2
end

function var3.MoveTowardsAngle(arg0, arg1, arg2)
	arg1 = arg0 + var3.DeltaAngle(arg0, arg1)

	return var3.MoveTowards(arg0, arg1, arg2)
end

function var3.PingPong(arg0, arg1)
	arg0 = var3.Repeat(arg0, arg1 * 2)

	return arg1 - var2(arg0 - arg1)
end

function var3.Repeat(arg0, arg1)
	return arg0 - var1(arg0 / arg1) * arg1
end

function var3.Round(arg0)
	return var1(arg0 + 0.5)
end

function var3.Sign(arg0)
	arg0 = arg0 > 0 and 1 or arg0 < 0 and -1 or 0

	return arg0
end

function var3.SmoothDamp(arg0, arg1, arg2, arg3, arg4, arg5)
	arg4 = arg4 or var3.Infinity
	arg5 = arg5 or Time.deltaTime
	arg3 = var3.Max(0.0001, arg3)

	local var0 = 2 / arg3
	local var1 = var0 * arg5
	local var2 = 1 / (1 + var1 + 0.48 * var1 * var1 + 0.235 * var1 * var1 * var1)
	local var3 = arg0 - arg1
	local var4 = arg1
	local var5 = arg4 * arg3
	local var6 = var3.Clamp(var3, -var5, var5)

	arg1 = arg0 - var6

	local var7 = (arg2 + var0 * var6) * arg5

	arg2 = (arg2 - var0 * var7) * var2

	local var8 = arg1 + (var6 + var7) * var2

	if arg0 < var4 == (var4 < var8) then
		var8 = var4
		arg2 = (var8 - var4) / arg5
	end

	return var8, arg2
end

function var3.SmoothDampAngle(arg0, arg1, arg2, arg3, arg4, arg5)
	arg5 = arg5 or Time.deltaTime
	arg4 = arg4 or var3.Infinity
	arg1 = arg0 + var3.DeltaAngle(arg0, arg1)

	return var3.SmoothDamp(arg0, arg1, arg2, arg3, arg4, arg5)
end

function var3.SmoothStep(arg0, arg1, arg2)
	arg2 = var3.Clamp01(arg2)
	arg2 = -2 * arg2 * arg2 * arg2 + 3 * arg2 * arg2

	return arg1 * arg2 + arg0 * (1 - arg2)
end

function var3.HorizontalAngle(arg0)
	return var0.deg(var0.atan2(arg0.x, arg0.z))
end

function var3.IsNan(arg0)
	return arg0 ~= arg0
end

function var3.MultiRandom(arg0, arg1)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in ipairs(arg0) do
		table.insert(var1, iter0)
	end

	arg1 = var0.min(#arg0, arg1)

	while arg1 > 0 do
		local var2 = var0.random(#var1)
		local var3 = table.remove(var1, var2)

		table.insert(var0, arg0[var3])

		arg1 = arg1 - 1
	end

	return var0
end

function var3.RandomFloat(arg0, arg1, arg2)
	arg1 = arg1 or 0
	arg2 = arg2 or 10000
	arg1 = arg1 * arg2
	arg0 = arg0 * arg2

	return var0.random(arg1, arg0) / arg2
end

UnityEngine.Mathf = var3

return var3
