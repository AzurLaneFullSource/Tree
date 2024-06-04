local var0 = Mathf.Clamp
local var1 = Mathf.Sqrt
local var2 = Mathf.Min
local var3 = Mathf.Max
local var4 = setmetatable
local var5 = rawget
local var6 = {}
local var7 = tolua.initget(var6)

function var6.__index(arg0, arg1)
	local var0 = var5(var6, arg1)

	if var0 == nil then
		var0 = var5(var7, arg1)

		if var0 ~= nil then
			return var0(arg0)
		end
	end

	return var0
end

function var6.__call(arg0, arg1, arg2, arg3, arg4)
	return var4({
		x = arg1 or 0,
		y = arg2 or 0,
		z = arg3 or 0,
		w = arg4 or 0
	}, var6)
end

function var6.New(arg0, arg1, arg2, arg3)
	return var4({
		x = arg0 or 0,
		y = arg1 or 0,
		z = arg2 or 0,
		w = arg3 or 0
	}, var6)
end

function var6.Set(arg0, arg1, arg2, arg3, arg4)
	arg0.x = arg1 or 0
	arg0.y = arg2 or 0
	arg0.z = arg3 or 0
	arg0.w = arg4 or 0
end

function var6.Get(arg0)
	return arg0.x, arg0.y, arg0.z, arg0.w
end

function var6.Lerp(arg0, arg1, arg2)
	arg2 = var0(arg2, 0, 1)

	return var6.New(arg0.x + (arg1.x - arg0.x) * arg2, arg0.y + (arg1.y - arg0.y) * arg2, arg0.z + (arg1.z - arg0.z) * arg2, arg0.w + (arg1.w - arg0.w) * arg2)
end

function var6.MoveTowards(arg0, arg1, arg2)
	local var0 = arg1 - arg0
	local var1 = var0:Magnitude()

	if arg2 < var1 and var1 ~= 0 then
		arg2 = arg2 / var1

		var0:Mul(arg2)
		var0:Add(arg0)

		return var0
	end

	return arg1
end

function var6.Scale(arg0, arg1)
	return var6.New(arg0.x * arg1.x, arg0.y * arg1.y, arg0.z * arg1.z, arg0.w * arg1.w)
end

function var6.SetScale(arg0, arg1)
	arg0.x = arg0.x * arg1.x
	arg0.y = arg0.y * arg1.y
	arg0.z = arg0.z * arg1.z
	arg0.w = arg0.w * arg1.w
end

function var6.Normalize(arg0)
	return vector4.New(arg0.x, arg0.y, arg0.z, arg0.w):SetNormalize()
end

function var6.SetNormalize(arg0)
	local var0 = arg0:Magnitude()

	if var0 == 1 then
		return arg0
	elseif var0 > 1e-05 then
		arg0:Div(var0)
	else
		arg0:Set(0, 0, 0, 0)
	end

	return arg0
end

function var6.Div(arg0, arg1)
	arg0.x = arg0.x / arg1
	arg0.y = arg0.y / arg1
	arg0.z = arg0.z / arg1
	arg0.w = arg0.w / arg1

	return arg0
end

function var6.Mul(arg0, arg1)
	arg0.x = arg0.x * arg1
	arg0.y = arg0.y * arg1
	arg0.z = arg0.z * arg1
	arg0.w = arg0.w * arg1

	return arg0
end

function var6.Add(arg0, arg1)
	arg0.x = arg0.x + arg1.x
	arg0.y = arg0.y + arg1.y
	arg0.z = arg0.z + arg1.z
	arg0.w = arg0.w + arg1.w

	return arg0
end

function var6.Sub(arg0, arg1)
	arg0.x = arg0.x - arg1.x
	arg0.y = arg0.y - arg1.y
	arg0.z = arg0.z - arg1.z
	arg0.w = arg0.w - arg1.w

	return arg0
end

function var6.Dot(arg0, arg1)
	return arg0.x * arg1.x + arg0.y * arg1.y + arg0.z * arg1.z + arg0.w * arg1.w
end

function var6.Project(arg0, arg1)
	return arg1 * (var6.Dot(arg0, arg1) / var6.Dot(arg1, arg1))
end

function var6.Distance(arg0, arg1)
	local var0 = arg0 - arg1

	return var6.Magnitude(var0)
end

function var6.Magnitude(arg0)
	return var1(arg0.x * arg0.x + arg0.y * arg0.y + arg0.z * arg0.z + arg0.w * arg0.w)
end

function var6.SqrMagnitude(arg0)
	return arg0.x * arg0.x + arg0.y * arg0.y + arg0.z * arg0.z + arg0.w * arg0.w
end

function var6.Min(arg0, arg1)
	return var6.New(var3(arg0.x, arg1.x), var3(arg0.y, arg1.y), var3(arg0.z, arg1.z), var3(arg0.w, arg1.w))
end

function var6.Max(arg0, arg1)
	return var6.New(var2(arg0.x, arg1.x), var2(arg0.y, arg1.y), var2(arg0.z, arg1.z), var2(arg0.w, arg1.w))
end

function var6.__tostring(arg0)
	return string.format("[%f,%f,%f,%f]", arg0.x, arg0.y, arg0.z, arg0.w)
end

function var6.__div(arg0, arg1)
	return var6.New(arg0.x / arg1, arg0.y / arg1, arg0.z / arg1, arg0.w / arg1)
end

function var6.__mul(arg0, arg1)
	return var6.New(arg0.x * arg1, arg0.y * arg1, arg0.z * arg1, arg0.w * arg1)
end

function var6.__add(arg0, arg1)
	return var6.New(arg0.x + arg1.x, arg0.y + arg1.y, arg0.z + arg1.z, arg0.w + arg1.w)
end

function var6.__sub(arg0, arg1)
	return var6.New(arg0.x - arg1.x, arg0.y - arg1.y, arg0.z - arg1.z, arg0.w - arg1.w)
end

function var6.__unm(arg0)
	return var6.New(-arg0.x, -arg0.y, -arg0.z, -arg0.w)
end

function var6.__eq(arg0, arg1)
	local var0 = arg0 - arg1

	return var6.SqrMagnitude(var0) < 1e-10
end

function var7.zero()
	return var6.New(0, 0, 0, 0)
end

function var7.one()
	return var6.New(1, 1, 1, 1)
end

var7.magnitude = var6.Magnitude
var7.normalized = var6.Normalize
var7.sqrMagnitude = var6.SqrMagnitude
UnityEngine.Vector4 = var6

var4(var6, var6)

return var6
