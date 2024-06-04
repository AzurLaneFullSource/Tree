local var0 = math
local var1 = var0.acos
local var2 = var0.sqrt
local var3 = var0.max
local var4 = var0.min
local var5 = Mathf.Clamp
local var6 = var0.cos
local var7 = var0.sin
local var8 = var0.abs
local var9 = Mathf.Sign
local var10 = setmetatable
local var11 = rawset
local var12 = rawget
local var13 = type
local var14 = 57.295779513082
local var15 = 0.017453292519943
local var16 = {}
local var17 = tolua.initget(var16)

function var16.__index(arg0, arg1)
	local var0 = var12(var16, arg1)

	if var0 == nil then
		var0 = var12(var17, arg1)

		if var0 ~= nil then
			return var0(arg0)
		end
	end

	return var0
end

function var16.New(arg0, arg1, arg2)
	local var0 = {
		x = arg0 or 0,
		y = arg1 or 0,
		z = arg2 or 0
	}

	var10(var0, var16)

	return var0
end

local var18 = var16.New

function var16.__call(arg0, arg1, arg2, arg3)
	local var0 = {
		x = arg1 or 0,
		y = arg2 or 0,
		z = arg3 or 0
	}

	var10(var0, var16)

	return var0
end

function var16.Set(arg0, arg1, arg2, arg3)
	arg0.x = arg1 or 0
	arg0.y = arg2 or 0
	arg0.z = arg3 or 0
end

function var16.Get(arg0)
	return arg0.x, arg0.y, arg0.z
end

function var16.Clone(arg0)
	return var10({
		x = arg0.x,
		y = arg0.y,
		z = arg0.z
	}, var16)
end

function var16.Copy(arg0, arg1)
	arg0.x = arg1.x
	arg0.y = arg1.y
	arg0.z = arg1.z

	return arg0
end

function var16.Copy2(arg0, arg1)
	if arg1 then
		arg1.x = arg0.x
		arg1.y = arg0.y
		arg1.z = arg0.z

		return arg1
	else
		return var18(arg0.x, arg0.y, arg0.z)
	end
end

function var16.Distance(arg0, arg1)
	return var2((arg0.x - arg1.x)^2 + (arg0.y - arg1.y)^2 + (arg0.z - arg1.z)^2)
end

function var16.BattleDistance(arg0, arg1)
	return var2((arg0.x - arg1.x)^2 + (arg0.z - arg1.z)^2)
end

function var16.SqrDistance(arg0, arg1)
	return (arg0.x - arg1.x)^2 + (arg0.y - arg1.y)^2 + (arg0.z - arg1.z)^2
end

function var16.Dot(arg0, arg1)
	return arg0.x * arg1.x + arg0.y * arg1.y + arg0.z * arg1.z
end

function var16.Lerp(arg0, arg1, arg2)
	arg2 = var5(arg2, 0, 1)

	return var18(arg0.x + (arg1.x - arg0.x) * arg2, arg0.y + (arg1.y - arg0.y) * arg2, arg0.z + (arg1.z - arg0.z) * arg2)
end

function var16.Magnitude(arg0)
	return var2(arg0.x * arg0.x + arg0.y * arg0.y + arg0.z * arg0.z)
end

function var16.Max(arg0, arg1)
	return var18(var3(arg0.x, arg1.x), var3(arg0.y, arg1.y), var3(arg0.z, arg1.z))
end

function var16.Min(arg0, arg1)
	return var18(var4(arg0.x, arg1.x), var4(arg0.y, arg1.y), var4(arg0.z, arg1.z))
end

function var16.Normalize(arg0)
	local var0 = arg0.x
	local var1 = arg0.y
	local var2 = arg0.z
	local var3 = var2(var0 * var0 + var1 * var1 + var2 * var2)

	if var3 > 1e-05 then
		return var10({
			x = var0 / var3,
			y = var1 / var3,
			z = var2 / var3
		}, var16)
	end

	return var10({
		z = 0,
		x = 0,
		y = 0
	}, var16)
end

function var16.SetNormalize(arg0)
	local var0 = var2(arg0.x * arg0.x + arg0.y * arg0.y + arg0.z * arg0.z)

	if var0 > 1e-05 then
		arg0.x = arg0.x / var0
		arg0.y = arg0.y / var0
		arg0.z = arg0.z / var0
	else
		arg0.x = 0
		arg0.y = 0
		arg0.z = 0
	end

	return arg0
end

function var16.SqrMagnitude(arg0)
	return arg0.x * arg0.x + arg0.y * arg0.y + arg0.z * arg0.z
end

local var19 = var16.Dot

function var16.Angle(arg0, arg1)
	return var1(var5(var19(arg0:Normalize(), arg1:Normalize()), -1, 1)) * var14
end

function var16.ClampMagnitude(arg0, arg1)
	if arg0:SqrMagnitude() > arg1 * arg1 then
		arg0:SetNormalize()
		arg0:Mul(arg1)
	end

	return arg0
end

function var16.OrthoNormalize(arg0, arg1, arg2)
	arg0:SetNormalize()
	arg1:Sub(arg1:Project(arg0))
	arg1:SetNormalize()

	if arg2 == nil then
		return arg0, arg1
	end

	arg2:Sub(arg2:Project(arg0))
	arg2:Sub(arg2:Project(arg1))
	arg2:SetNormalize()

	return arg0, arg1, arg2
end

function var16.MoveTowards(arg0, arg1, arg2)
	local var0 = arg1 - arg0
	local var1 = var0:SqrMagnitude()

	if var1 > arg2 * arg2 then
		local var2 = var2(var1)

		if var2 > 1e-06 then
			var0:Mul(arg2 / var2)
			var0:Add(arg0)

			return var0
		else
			return arg0:Clone()
		end
	end

	return arg1:Clone()
end

function ClampedMove(arg0, arg1, arg2)
	local var0 = arg1 - arg0

	if var0 > 0 then
		return arg0 + var4(var0, arg2)
	else
		return arg0 - var4(-var0, arg2)
	end
end

local var20 = 0.707106781186548

local function var21(arg0)
	local var0 = var18()

	if var8(arg0.z) > var20 then
		local var1 = arg0.y * arg0.y + arg0.z * arg0.z
		local var2 = 1 / var2(var1)

		var0.x = 0
		var0.y = -arg0.z * var2
		var0.z = arg0.y * var2
	else
		local var3 = arg0.x * arg0.x + arg0.y * arg0.y
		local var4 = 1 / var2(var3)

		var0.x = -arg0.y * var4
		var0.y = arg0.x * var4
		var0.z = 0
	end

	return var0
end

function var16.RotateTowards(arg0, arg1, arg2, arg3)
	local var0 = arg0:Magnitude()
	local var1 = arg1:Magnitude()

	if var0 > 1e-06 and var1 > 1e-06 then
		local var2 = arg0 / var0
		local var3 = arg1 / var1
		local var4 = var19(var2, var3)

		if var4 > 0.999999 then
			return var16.MoveTowards(arg0, arg1, arg3)
		elseif var4 < -0.999999 then
			local var5 = var21(var2)
			local var6 = Quaternion.AngleAxis(arg2 * var14, var5):MulVec3(var2)
			local var7 = ClampedMove(var0, var1, arg3)

			var6:Mul(var7)

			return var6
		else
			local var8 = var1(var4)
			local var9 = var16.Cross(var2, var3)

			var9:SetNormalize()

			local var10 = Quaternion.AngleAxis(var4(arg2, var8) * var14, var9):MulVec3(var2)
			local var11 = ClampedMove(var0, var1, arg3)

			var10:Mul(var11)

			return var10
		end
	end

	return var16.MoveTowards(arg0, arg1, arg3)
end

function var16.SmoothDamp(arg0, arg1, arg2, arg3)
	local var0 = Mathf.Infinity
	local var1 = Time.deltaTime

	arg3 = var3(0.0001, arg3)

	local var2 = 2 / arg3
	local var3 = var2 * var1
	local var4 = 1 / (1 + var3 + 0.48 * var3 * var3 + 0.235 * var3 * var3 * var3)
	local var5 = arg1:Clone()
	local var6 = var0 * arg3
	local var7 = arg0 - arg1

	var7:ClampMagnitude(var6)

	arg1 = arg0 - var7

	local var8 = (arg2 + var7 * var2) * var1

	arg2 = (arg2 - var8 * var2) * var4

	local var9 = arg1 + (var7 + var8) * var4

	if var16.Dot(var5 - arg0, var9 - var5) > 0 then
		var9 = var5

		arg2:Set(0, 0, 0)
	end

	return var9, arg2
end

function var16.Scale(arg0, arg1)
	local var0 = arg0.x * arg1.x
	local var1 = arg0.y * arg1.y
	local var2 = arg0.z * arg1.z

	return var18(var0, var1, var2)
end

function var16.Cross2(arg0, arg1)
	local var0 = arg0
	local var1 = var0.y * arg1.z - var0.z * arg1.y
	local var2 = var0.z * arg1.x - var0.x * arg1.z
	local var3 = var0.x * arg1.y - var0.y * arg1.x

	arg0.x, arg0.y, arg0.z = var1, var2, var3

	return arg0
end

function var16.Cross(arg0, arg1)
	local var0 = arg0.y * arg1.z - arg0.z * arg1.y
	local var1 = arg0.z * arg1.x - arg0.x * arg1.z
	local var2 = arg0.x * arg1.y - arg0.y * arg1.x

	return var18(var0, var1, var2)
end

function var16.Equals(arg0, arg1)
	return arg0.x == arg1.x and arg0.y == arg1.y and arg0.z == arg1.z
end

function var16.EqualZero(arg0)
	return arg0.x * arg0.x + arg0.y * arg0.y + arg0.z * arg0.z < 1e-10
end

function var16.Reflect(arg0, arg1)
	arg1 = arg1 * (-2 * var19(arg1, arg0))

	arg1:Add(arg0)

	return arg1
end

function var16.Project(arg0, arg1)
	local var0 = arg1:SqrMagnitude()

	if var0 < 1.175494e-38 then
		return var18(0, 0, 0)
	end

	local var1 = var19(arg0, arg1)
	local var2 = arg1:Clone()

	var2:Mul(var1 / var0)

	return var2
end

function var16.ProjectOnPlane(arg0, arg1)
	local var0 = var16.Project(arg0, arg1)

	var0:Mul(-1)
	var0:Add(arg0)

	return var0
end

function var16.Slerp(arg0, arg1, arg2)
	local var0
	local var1
	local var2
	local var3

	if arg2 <= 0 then
		return arg0:Clone()
	elseif arg2 >= 1 then
		return arg1:Clone()
	end

	local var4 = arg1:Clone()
	local var5 = arg0:Clone()
	local var6 = arg1:Magnitude()
	local var7 = arg0:Magnitude()

	var4:Div(var6)
	var5:Div(var7)

	local var8 = (var6 - var7) * arg2 + var7
	local var9 = var5.x * var4.x + var5.y * var4.y + var5.z * var4.z

	if var9 > 0.999999 then
		var2 = 1 - arg2
		var3 = arg2
	elseif var9 < -0.999999 then
		local var10 = var21(arg0)
		local var11 = Quaternion.AngleAxis(180 * arg2, var10):MulVec3(arg0)

		var11:Mul(var8)

		return var11
	else
		local var12 = var1(var9)
		local var13 = var7(var12)

		var2 = var7((1 - arg2) * var12) / var13
		var3 = var7(arg2 * var12) / var13
	end

	var5:Mul(var2)
	var4:Mul(var3)
	var4:Add(var5)
	var4:Mul(var8)

	return var4
end

function var16.Mul(arg0, arg1)
	if var13(arg1) == "number" then
		arg0.x = arg0.x * arg1
		arg0.y = arg0.y * arg1
		arg0.z = arg0.z * arg1
	else
		arg0:MulQuat(arg1)
	end

	return arg0
end

function var16.Div(arg0, arg1)
	arg0.x = arg0.x / arg1
	arg0.y = arg0.y / arg1
	arg0.z = arg0.z / arg1

	return arg0
end

function var16.Add(arg0, arg1)
	arg0.x = arg0.x + arg1.x
	arg0.y = arg0.y + arg1.y
	arg0.z = arg0.z + arg1.z

	return arg0
end

function var16.Sub(arg0, arg1)
	arg0.x = arg0.x - arg1.x
	arg0.y = arg0.y - arg1.y
	arg0.z = arg0.z - arg1.z

	return arg0
end

function var16.MulQuat(arg0, arg1)
	local var0 = arg1.x * 2
	local var1 = arg1.y * 2
	local var2 = arg1.z * 2
	local var3 = arg1.x * var0
	local var4 = arg1.y * var1
	local var5 = arg1.z * var2
	local var6 = arg1.x * var1
	local var7 = arg1.x * var2
	local var8 = arg1.y * var2
	local var9 = arg1.w * var0
	local var10 = arg1.w * var1
	local var11 = arg1.w * var2
	local var12 = (1 - (var4 + var5)) * arg0.x + (var6 - var11) * arg0.y + (var7 + var10) * arg0.z
	local var13 = (var6 + var11) * arg0.x + (1 - (var3 + var5)) * arg0.y + (var8 - var9) * arg0.z
	local var14 = (var7 - var10) * arg0.x + (var8 + var9) * arg0.y + (1 - (var3 + var4)) * arg0.z

	arg0:Set(var12, var13, var14)

	return arg0
end

function var16.AngleAroundAxis(arg0, arg1, arg2)
	arg0 = arg0 - var16.Project(arg0, arg2)
	arg1 = arg1 - var16.Project(arg1, arg2)

	return var16.Angle(arg0, arg1) * (var16.Dot(arg2, var16.Cross(arg0, arg1)) < 0 and -1 or 1)
end

function var16.__tostring(arg0)
	return "[" .. arg0.x .. "," .. arg0.y .. "," .. arg0.z .. "]"
end

function var16.__div(arg0, arg1)
	return var18(arg0.x / arg1, arg0.y / arg1, arg0.z / arg1)
end

function var16.__mul(arg0, arg1)
	if var13(arg1) == "number" then
		return var18(arg0.x * arg1, arg0.y * arg1, arg0.z * arg1)
	else
		local var0 = arg0:Clone()

		var0:MulQuat(arg1)

		return var0
	end
end

function var16.__add(arg0, arg1)
	return var18(arg0.x + arg1.x, arg0.y + arg1.y, arg0.z + arg1.z)
end

function var16.__sub(arg0, arg1)
	return var18(arg0.x - arg1.x, arg0.y - arg1.y, arg0.z - arg1.z)
end

function var16.__unm(arg0)
	return var18(-arg0.x, -arg0.y, -arg0.z)
end

function var16.__eq(arg0, arg1)
	return (arg0.x - arg1.x) * (arg0.x - arg1.x) + (arg0.y - arg1.y) * (arg0.y - arg1.y) + (arg0.z - arg1.z) * (arg0.z - arg1.z) < 1e-10
end

function var17.up()
	return var18(0, 1, 0)
end

function var17.down()
	return var18(0, -1, 0)
end

function var17.right()
	return var18(1, 0, 0)
end

function var17.left()
	return var18(-1, 0, 0)
end

function var17.forward()
	return var18(0, 0, 1)
end

function var17.back()
	return var18(0, 0, -1)
end

function var17.zero()
	return var18(0, 0, 0)
end

function var17.one()
	return var18(1, 1, 1)
end

var17.magnitude = var16.Magnitude
var17.normalized = var16.Normalize
var17.sqrMagnitude = var16.SqrMagnitude
UnityEngine.Vector3 = var16

var10(var16, var16)

return var16
