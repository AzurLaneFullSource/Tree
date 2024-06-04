local var0 = math.sqrt
local var1 = setmetatable
local var2 = rawget
local var3 = math
local var4 = var3.acos
local var5 = var3.max
local var6 = {}
local var7 = tolua.initget(var6)

function var6.__index(arg0, arg1)
	local var0 = var2(var6, arg1)

	if var0 == nil then
		var0 = var2(var7, arg1)

		if var0 ~= nil then
			return var0(arg0)
		end
	end

	return var0
end

function var6.__call(arg0, arg1, arg2)
	return var1({
		x = arg1 or 0,
		y = arg2 or 0
	}, var6)
end

function var6.New(arg0, arg1)
	return var1({
		x = arg0 or 0,
		y = arg1 or 0
	}, var6)
end

function var6.Set(arg0, arg1, arg2)
	arg0.x = arg1 or 0
	arg0.y = arg2 or 0
end

function var6.Get(arg0)
	return arg0.x, arg0.y
end

function var6.SqrMagnitude(arg0)
	return arg0.x * arg0.x + arg0.y * arg0.y
end

function var6.Clone(arg0)
	return var1({
		x = arg0.x,
		y = arg0.y
	}, var6)
end

function var6.Normalize(arg0)
	local var0 = arg0.x
	local var1 = arg0.y
	local var2 = var0(var0 * var0 + var1 * var1)

	if var2 > 1e-05 then
		var0 = var0 / var2
		var1 = var1 / var2
	else
		var0 = 0
		var1 = 0
	end

	return var1({
		x = var0,
		y = var1
	}, var6)
end

function var6.SetNormalize(arg0)
	local var0 = var0(arg0.x * arg0.x + arg0.y * arg0.y)

	if var0 > 1e-05 then
		arg0.x = arg0.x / var0
		arg0.y = arg0.y / var0
	else
		arg0.x = 0
		arg0.y = 0
	end

	return arg0
end

function var6.Dot(arg0, arg1)
	return arg0.x * arg1.x + arg0.y * arg1.y
end

function var6.Angle(arg0, arg1)
	local var0 = arg0.x
	local var1 = arg0.y
	local var2 = var0(var0 * var0 + var1 * var1)

	if var2 > 1e-05 then
		var0 = var0 / var2
		var1 = var1 / var2
	else
		var0, var1 = 0, 0
	end

	local var3 = arg1.x
	local var4 = arg1.y
	local var5 = var0(var3 * var3 + var4 * var4)

	if var5 > 1e-05 then
		var3 = var3 / var5
		var4 = var4 / var5
	else
		var3, var4 = 0, 0
	end

	local var6 = var0 * var3 + var1 * var4

	if var6 < -1 then
		var6 = -1
	elseif var6 > 1 then
		var6 = 1
	end

	return var4(var6) * 57.29578
end

function var6.Magnitude(arg0)
	return var0(arg0.x * arg0.x + arg0.y * arg0.y)
end

function var6.Reflect(arg0, arg1)
	local var0 = arg0.x
	local var1 = arg0.y
	local var2 = arg1.x
	local var3 = arg1.y
	local var4 = -2 * (var0 * var2 + var1 * var3)

	return var1({
		x = var4 * var2 + var0,
		y = var4 * var3 + var1
	}, var6)
end

function var6.Distance(arg0, arg1)
	return var0((arg0.x - arg1.x)^2 + (arg0.y - arg1.y)^2)
end

function var6.Lerp(arg0, arg1, arg2)
	if arg2 < 0 then
		arg2 = 0
	elseif arg2 > 1 then
		arg2 = 1
	end

	return var1({
		x = arg0.x + (arg1.x - arg0.x) * arg2,
		y = arg0.y + (arg1.y - arg0.y) * arg2
	}, var6)
end

function var6.LerpUnclamped(arg0, arg1, arg2)
	return var1({
		x = arg0.x + (arg1.x - arg0.x) * arg2,
		y = arg0.y + (arg1.y - arg0.y) * arg2
	}, var6)
end

function var6.MoveTowards(arg0, arg1, arg2)
	local var0 = arg0.x
	local var1 = arg0.y
	local var2 = arg1.x - var0
	local var3 = arg1.y - var1
	local var4 = var2 * var2 + var3 * var3

	if var4 > arg2 * arg2 and var4 ~= 0 then
		local var5 = arg2 / var0(var4)

		return var1({
			x = var0 + var2 * var5,
			y = var1 + var3 * var5
		}, var6)
	end

	return var1({
		x = arg1.x,
		y = arg1.y
	}, var6)
end

function var6.ClampMagnitude(arg0, arg1)
	local var0 = arg0.x
	local var1 = arg0.y
	local var2 = var0 * var0 + var1 * var1

	if var2 > arg1 * arg1 then
		local var3 = arg1 / var0(var2)

		var0 = var0 * var3
		var1 = var1 * var3

		return var1({
			x = var0,
			y = var1
		}, var6)
	end

	return var1({
		x = var0,
		y = var1
	}, var6)
end

function var6.SmoothDamp(arg0, arg1, arg2, arg3, arg4, arg5)
	arg5 = arg5 or Time.deltaTime
	arg4 = arg4 or var3.huge
	arg3 = var3.max(0.0001, arg3)

	local var0 = 2 / arg3
	local var1 = var0 * arg5
	local var2 = 1 / (1 + var1 + 0.48 * var1 * var1 + 0.235 * var1 * var1 * var1)
	local var3 = arg1.x
	local var4 = arg1.y
	local var5 = arg0.x
	local var6 = arg0.y
	local var7 = var5 - var3
	local var8 = var6 - var4
	local var9 = var7 * var7 + var8 * var8
	local var10 = arg4 * arg3

	if var9 > var10 * var10 then
		local var11 = var10 / var0(var9)

		var7 = var7 * var11
		var8 = var8 * var11
	end

	local var12 = arg2.x
	local var13 = arg2.y
	local var14 = (var12 + var0 * var7) * arg5
	local var15 = (var13 + var0 * var8) * arg5

	arg2.x = (var12 - var0 * var14) * var2
	arg2.y = (var13 - var0 * var15) * var2

	local var16 = var5 - var7 + (var7 + var14) * var2
	local var17 = var6 - var8 + (var8 + var15) * var2

	if (var3 - var5) * (var16 - var3) + (var4 - var6) * (var17 - var4) > 0 then
		var16 = var3
		var17 = var4
		arg2.x = 0
		arg2.y = 0
	end

	return var1({
		x = var16,
		y = var17
	}, var6), arg2
end

function var6.Max(arg0, arg1)
	return var1({
		x = var3.max(arg0.x, arg1.x),
		y = var3.max(arg0.y, arg1.y)
	}, var6)
end

function var6.Min(arg0, arg1)
	return var1({
		x = var3.min(arg0.x, arg1.x),
		y = var3.min(arg0.y, arg1.y)
	}, var6)
end

function var6.Scale(arg0, arg1)
	return var1({
		x = arg0.x * arg1.x,
		y = arg0.y * arg1.y
	}, var6)
end

function var6.Div(arg0, arg1)
	arg0.x = arg0.x / arg1
	arg0.y = arg0.y / arg1

	return arg0
end

function var6.Mul(arg0, arg1)
	arg0.x = arg0.x * arg1
	arg0.y = arg0.y * arg1

	return arg0
end

function var6.Add(arg0, arg1)
	arg0.x = arg0.x + arg1.x
	arg0.y = arg0.y + arg1.y

	return arg0
end

function var6.Sub(arg0, arg1)
	arg0.x = arg0.x - arg1.x
	arg0.y = arg0.y - arg1.y

	return arg0
end

function var6.__tostring(arg0)
	return string.format("(%f,%f)", arg0.x, arg0.y)
end

function var6.__div(arg0, arg1)
	return var1({
		x = arg0.x / arg1,
		y = arg0.y / arg1
	}, var6)
end

function var6.__mul(arg0, arg1)
	if type(arg1) == "number" then
		return var1({
			x = arg0.x * arg1,
			y = arg0.y * arg1
		}, var6)
	else
		return var1({
			x = arg0 * arg1.x,
			y = arg0 * arg1.y
		}, var6)
	end
end

function var6.__add(arg0, arg1)
	return var1({
		x = arg0.x + arg1.x,
		y = arg0.y + arg1.y
	}, var6)
end

function var6.__sub(arg0, arg1)
	return var1({
		x = arg0.x - arg1.x,
		y = arg0.y - arg1.y
	}, var6)
end

function var6.__unm(arg0)
	return var1({
		x = -arg0.x,
		y = -arg0.y
	}, var6)
end

function var6.__eq(arg0, arg1)
	return (arg0.x - arg1.x)^2 + (arg0.y - arg1.y)^2 < 9.999999e-11
end

function var7.up()
	return var1({
		x = 0,
		y = 1
	}, var6)
end

function var7.right()
	return var1({
		x = 1,
		y = 0
	}, var6)
end

function var7.zero()
	return var1({
		x = 0,
		y = 0
	}, var6)
end

function var7.one()
	return var1({
		x = 1,
		y = 1
	}, var6)
end

var7.magnitude = var6.Magnitude
var7.normalized = var6.Normalize
var7.sqrMagnitude = var6.SqrMagnitude
UnityEngine.Vector2 = var6

var1(var6, var6)

return var6
