local var0 = math
local var1 = var0.sin
local var2 = var0.cos
local var3 = var0.acos
local var4 = var0.asin
local var5 = var0.sqrt
local var6 = var0.min
local var7 = var0.max
local var8 = var0.sign
local var9 = var0.atan2
local var10 = Mathf.Clamp
local var11 = var0.abs
local var12 = setmetatable
local var13 = getmetatable
local var14 = rawget
local var15 = rawset
local var16 = Vector3
local var17 = Mathf.Rad2Deg
local var18 = 0.5 * Mathf.Deg2Rad
local var19 = var16.forward
local var20 = var16.up
local var21 = {
	2,
	3,
	1
}
local var22 = {}
local var23 = tolua.initget(var22)

function var22.__index(arg0, arg1)
	local var0 = var14(var22, arg1)

	if var0 == nil then
		var0 = var14(var23, arg1)

		if var0 ~= nil then
			return var0(arg0)
		end
	end

	return var0
end

function var22.__newindex(arg0, arg1, arg2)
	if arg1 == "eulerAngles" then
		arg0:SetEuler(arg2)
	else
		var15(arg0, arg1, arg2)
	end
end

function var22.New(arg0, arg1, arg2, arg3)
	local var0 = {
		x = arg0 or 0,
		y = arg1 or 0,
		z = arg2 or 0,
		w = arg3 or 0
	}

	var12(var0, var22)

	return var0
end

local var24 = var22.New

function var22.__call(arg0, arg1, arg2, arg3, arg4)
	local var0 = {
		x = arg1 or 0,
		y = arg2 or 0,
		z = arg3 or 0,
		w = arg4 or 0
	}

	var12(var0, var22)

	return var0
end

function var22.Set(arg0, arg1, arg2, arg3, arg4)
	arg0.x = arg1 or 0
	arg0.y = arg2 or 0
	arg0.z = arg3 or 0
	arg0.w = arg4 or 0
end

function var22.Clone(arg0)
	return var24(arg0.x, arg0.y, arg0.z, arg0.w)
end

function var22.Get(arg0)
	return arg0.x, arg0.y, arg0.z, arg0.w
end

function var22.Dot(arg0, arg1)
	return arg0.x * arg1.x + arg0.y * arg1.y + arg0.z * arg1.z + arg0.w * arg1.w
end

function var22.Angle(arg0, arg1)
	local var0 = var22.Dot(arg0, arg1)

	if var0 < 0 then
		var0 = -var0
	end

	return var3(var6(var0, 1)) * 2 * 57.29578
end

function var22.AngleAxis(arg0, arg1)
	local var0 = arg1:Normalize()

	arg0 = arg0 * var18

	local var1 = var1(arg0)
	local var2 = var2(arg0)
	local var3 = var0.x * var1
	local var4 = var0.y * var1
	local var5 = var0.z * var1

	return var24(var3, var4, var5, var2)
end

function var22.Equals(arg0, arg1)
	return arg0.x == arg1.x and arg0.y == arg1.y and arg0.z == arg1.z and arg0.w == arg1.w
end

function var22.Euler(arg0, arg1, arg2)
	arg0 = arg0 * 0.0087266462599716
	arg1 = arg1 * 0.0087266462599716
	arg2 = arg2 * 0.0087266462599716

	local var0 = var1(arg0)

	arg0 = var2(arg0)

	local var1 = var1(arg1)

	arg1 = var2(arg1)

	local var2 = var1(arg2)

	arg2 = var2(arg2)

	local var3 = {
		x = arg1 * var0 * arg2 + var1 * arg0 * var2,
		y = var1 * arg0 * arg2 - arg1 * var0 * var2,
		z = arg1 * arg0 * var2 - var1 * var0 * arg2,
		w = arg1 * arg0 * arg2 + var1 * var0 * var2
	}

	var12(var3, var22)

	return var3
end

function var22.SetEuler(arg0, arg1, arg2, arg3)
	if arg2 == nil and arg3 == nil then
		arg2 = arg1.y
		arg3 = arg1.z
		arg1 = arg1.x
	end

	arg1 = arg1 * 0.0087266462599716
	arg2 = arg2 * 0.0087266462599716
	arg3 = arg3 * 0.0087266462599716

	local var0 = var1(arg1)
	local var1 = var2(arg1)
	local var2 = var1(arg2)
	local var3 = var2(arg2)
	local var4 = var1(arg3)
	local var5 = var2(arg3)

	arg0.w = var3 * var1 * var5 + var2 * var0 * var4
	arg0.x = var3 * var0 * var5 + var2 * var1 * var4
	arg0.y = var2 * var1 * var5 - var3 * var0 * var4
	arg0.z = var3 * var1 * var4 - var2 * var0 * var5

	return arg0
end

function var22.Normalize(arg0)
	local var0 = arg0:Clone()

	var0:SetNormalize()

	return var0
end

function var22.SetNormalize(arg0)
	local var0 = arg0.x * arg0.x + arg0.y * arg0.y + arg0.z * arg0.z + arg0.w * arg0.w

	if var0 ~= 1 and var0 > 0 then
		local var1 = 1 / var5(var0)

		arg0.x = arg0.x * var1
		arg0.y = arg0.y * var1
		arg0.z = arg0.z * var1
		arg0.w = arg0.w * var1
	end
end

function var22.FromToRotation(arg0, arg1)
	local var0 = var22.New()

	var0:SetFromToRotation(arg0, arg1)

	return var0
end

function var22.SetFromToRotation1(arg0, arg1, arg2)
	local var0 = arg1:Normalize()
	local var1 = arg2:Normalize()
	local var2 = var16.Dot(var0, var1)

	if var2 > -0.999999 then
		local var3 = var5((1 + var2) * 2)
		local var4 = 1 / var3
		local var5 = var16.Cross(var0, var1) * var4

		arg0:Set(var5.x, var5.y, var5.z, var3 * 0.5)
	elseif var2 > 0.999999 then
		return var24(0, 0, 0, 1)
	else
		local var6 = var16.Cross(var16.right, var0)

		if var6:SqrMagnitude() < 1e-06 then
			var6 = var16.Cross(var16.forward, var0)
		end

		arg0:Set(var6.x, var6.y, var6.z, 0)

		return arg0
	end

	return arg0
end

local function var25(arg0, arg1)
	local var0 = arg0[1][1] + arg0[2][2] + arg0[3][3]

	if var0 > 0 then
		local var1 = var5(var0 + 1)

		arg1.w = 0.5 * var1

		local var2 = 0.5 / var1

		arg1.x = (arg0[3][2] - arg0[2][3]) * var2
		arg1.y = (arg0[1][3] - arg0[3][1]) * var2
		arg1.z = (arg0[2][1] - arg0[1][2]) * var2

		arg1:SetNormalize()
	else
		local var3 = 1
		local var4 = {
			0,
			0,
			0
		}

		if arg0[2][2] > arg0[1][1] then
			var3 = 2
		end

		if arg0[3][3] > arg0[var3][var3] then
			var3 = 3
		end

		local var5 = var21[var3]
		local var6 = var21[var5]
		local var7 = arg0[var3][var3] - arg0[var5][var5] - arg0[var6][var6] + 1
		local var8 = 0.5 / var5(var7)

		var4[var3] = var8 * var7

		local var9 = (arg0[var6][var5] - arg0[var5][var6]) * var8

		var4[var5] = (arg0[var5][var3] + arg0[var3][var5]) * var8
		var4[var6] = (arg0[var6][var3] + arg0[var3][var6]) * var8

		arg1:Set(var4[1], var4[2], var4[3], var9)
		arg1:SetNormalize()
	end
end

function var22.SetFromToRotation(arg0, arg1, arg2)
	arg1 = arg1:Normalize()
	arg2 = arg2:Normalize()

	local var0 = var16.Dot(arg1, arg2)

	if var0 > 0.999999 then
		arg0:Set(0, 0, 0, 1)
	elseif var0 < -0.999999 then
		local var1 = {
			0,
			arg1.z,
			arg1.y
		}
		local var2 = var1[2] * var1[2] + var1[3] * var1[3]

		if var2 < 1e-06 then
			var1[1] = -arg1.z
			var1[2] = 0
			var1[3] = arg1.x
			var2 = var1[1] * var1[1] + var1[3] * var1[3]
		end

		local var3 = 1 / var5(var2)

		var1[1] = var1[1] * var3
		var1[2] = var1[2] * var3
		var1[3] = var1[3] * var3

		local var4 = {
			0,
			0,
			0,
			[1] = var1[2] * arg1.z - var1[3] * arg1.y,
			[2] = var1[3] * arg1.x - var1[1] * arg1.z,
			[3] = var1[1] * arg1.y - var1[2] * arg1.x
		}
		local var5 = -arg1.x * arg1.x
		local var6 = -arg1.y * arg1.y
		local var7 = -arg1.z * arg1.z
		local var8 = -arg1.x * arg1.y
		local var9 = -arg1.x * arg1.z
		local var10 = -arg1.y * arg1.z
		local var11 = var4[1] * var4[1]
		local var12 = var4[2] * var4[2]
		local var13 = var4[3] * var4[3]
		local var14 = var4[1] * var4[2]
		local var15 = var4[1] * var4[3]
		local var16 = var4[2] * var4[3]
		local var17 = -var1[1] * var1[1]
		local var18 = -var1[2] * var1[2]
		local var19 = -var1[3] * var1[3]
		local var20 = -var1[1] * var1[2]
		local var21 = -var1[1] * var1[3]
		local var22 = -var1[2] * var1[3]
		local var23 = {
			{
				var5 + var11 + var17,
				var8 + var14 + var20,
				var9 + var15 + var21
			},
			{
				var8 + var14 + var20,
				var6 + var12 + var18,
				var10 + var16 + var22
			},
			{
				var9 + var15 + var21,
				var10 + var16 + var22,
				var7 + var13 + var19
			}
		}

		var25(var23, arg0)
	else
		local var24 = var16.Cross(arg1, arg2)
		local var25 = (1 - var0) / var16.Dot(var24, var24)
		local var26 = var25 * var24.x
		local var27 = var25 * var24.z
		local var28 = var26 * var24.y
		local var29 = var26 * var24.z
		local var30 = var27 * var24.y
		local var31 = {
			{
				var0 + var26 * var24.x,
				var28 - var24.z,
				var29 + var24.y
			},
			{
				var28 + var24.z,
				var0 + var25 * var24.y * var24.y,
				var30 - var24.x
			},
			{
				var29 - var24.y,
				var30 + var24.x,
				var0 + var27 * var24.z
			}
		}

		var25(var31, arg0)
	end
end

function var22.Inverse(arg0)
	local var0 = var22.New()

	var0.x = -arg0.x
	var0.y = -arg0.y
	var0.z = -arg0.z
	var0.w = arg0.w

	return var0
end

function var22.Lerp(arg0, arg1, arg2)
	arg2 = var10(arg2, 0, 1)

	local var0 = {
		w = 1,
		z = 0,
		x = 0,
		y = 0
	}

	if var22.Dot(arg0, arg1) < 0 then
		var0.x = arg0.x + arg2 * (-arg1.x - arg0.x)
		var0.y = arg0.y + arg2 * (-arg1.y - arg0.y)
		var0.z = arg0.z + arg2 * (-arg1.z - arg0.z)
		var0.w = arg0.w + arg2 * (-arg1.w - arg0.w)
	else
		var0.x = arg0.x + (arg1.x - arg0.x) * arg2
		var0.y = arg0.y + (arg1.y - arg0.y) * arg2
		var0.z = arg0.z + (arg1.z - arg0.z) * arg2
		var0.w = arg0.w + (arg1.w - arg0.w) * arg2
	end

	var22.SetNormalize(var0)
	var12(var0, var22)

	return var0
end

function var22.LookRotation(arg0, arg1)
	local var0 = arg0:Magnitude()

	if var0 < 1e-06 then
		error("error input forward to Quaternion.LookRotation" .. tostring(arg0))

		return nil
	end

	arg0 = arg0 / var0
	arg1 = arg1 or var20

	local var1 = var16.Cross(arg1, arg0)

	var1:SetNormalize()

	arg1 = var16.Cross(arg0, var1)

	local var2 = var16.Cross(arg1, arg0)
	local var3 = var2.x + arg1.y + arg0.z

	if var3 > 0 then
		local var4
		local var5
		local var6
		local var7
		local var8 = var3 + 1
		local var9 = 0.5 / var5(var8)
		local var10 = var9 * var8
		local var11 = (arg1.z - arg0.y) * var9
		local var12 = (arg0.x - var2.z) * var9
		local var13 = (var2.y - arg1.x) * var9
		local var14 = var24(var11, var12, var13, var10)

		var14:SetNormalize()

		return var14
	else
		local var15 = {
			{
				var2.x,
				arg1.x,
				arg0.x
			},
			{
				var2.y,
				arg1.y,
				arg0.y
			},
			{
				var2.z,
				arg1.z,
				arg0.z
			}
		}
		local var16 = {
			0,
			0,
			0
		}
		local var17 = 1

		if arg1.y > var2.x then
			var17 = 2
		end

		if arg0.z > var15[var17][var17] then
			var17 = 3
		end

		local var18 = var21[var17]
		local var19 = var21[var18]
		local var20 = var15[var17][var17] - var15[var18][var18] - var15[var19][var19] + 1
		local var21 = 0.5 / var5(var20)

		var16[var17] = var21 * var20

		local var22 = (var15[var19][var18] - var15[var18][var19]) * var21

		var16[var18] = (var15[var18][var17] + var15[var17][var18]) * var21
		var16[var19] = (var15[var19][var17] + var15[var17][var19]) * var21

		local var23 = var24(var16[1], var16[2], var16[3], var22)

		var23:SetNormalize()

		return var23
	end
end

function var22.SetIdentity(arg0)
	arg0.x = 0
	arg0.y = 0
	arg0.z = 0
	arg0.w = 1
end

local function var26(arg0, arg1, arg2)
	local var0 = arg0.x * arg1.x + arg0.y * arg1.y + arg0.z * arg1.z + arg0.w * arg1.w

	if var0 < 0 then
		var0 = -var0
		arg1 = var12({
			x = -arg1.x,
			y = -arg1.y,
			z = -arg1.z,
			w = -arg1.w
		}, var22)
	end

	if var0 < 0.95 then
		local var1 = var3(var0)
		local var2 = 1 / var1(var1)
		local var3 = var1((1 - arg2) * var1) * var2
		local var4 = var1(arg2 * var1) * var2

		arg0 = {
			x = arg0.x * var3 + arg1.x * var4,
			y = arg0.y * var3 + arg1.y * var4,
			z = arg0.z * var3 + arg1.z * var4,
			w = arg0.w * var3 + arg1.w * var4
		}

		var12(arg0, var22)

		return arg0
	else
		arg0 = {
			x = arg0.x + arg2 * (arg1.x - arg0.x),
			y = arg0.y + arg2 * (arg1.y - arg0.y),
			z = arg0.z + arg2 * (arg1.z - arg0.z),
			w = arg0.w + arg2 * (arg1.w - arg0.w)
		}

		var22.SetNormalize(arg0)
		var12(arg0, var22)

		return arg0
	end
end

function var22.Slerp(arg0, arg1, arg2)
	if arg2 < 0 then
		arg2 = 0
	elseif arg2 > 1 then
		arg2 = 1
	end

	return var26(arg0, arg1, arg2)
end

function var22.RotateTowards(arg0, arg1, arg2)
	local var0 = var22.Angle(arg0, arg1)

	if var0 == 0 then
		return arg1
	end

	local var1 = var6(1, arg2 / var0)

	return var26(arg0, arg1, var1)
end

local function var27(arg0, arg1)
	return var11(arg0 - arg1) < 1e-06
end

function var22.ToAngleAxis(arg0)
	local var0 = 2 * var3(arg0.w)

	if var27(var0, 0) then
		return var0 * 57.29578, var16.New(1, 0, 0)
	end

	local var1 = 1 / var5(1 - var5(arg0.w))

	return var0 * 57.29578, var16.New(arg0.x * var1, arg0.y * var1, arg0.z * var1)
end

local var28 = Mathf.PI
local var29 = var28 * 0.5
local var30 = 2 * var28
local var31 = -0.0001
local var32 = var30 - 0.0001

local function var33(arg0)
	if arg0.x < var31 then
		arg0.x = arg0.x + var30
	elseif arg0.x > var32 then
		arg0.x = arg0.x - var30
	end

	if arg0.y < var31 then
		arg0.y = arg0.y + var30
	elseif arg0.y > var32 then
		arg0.y = arg0.y - var30
	end

	if arg0.z < var31 then
		arg0.z = arg0.z + var30
	elseif arg0.z > var32 then
		arg0.z = arg0.z + var30
	end
end

function var22.ToEulerAngles(arg0)
	local var0 = arg0.x
	local var1 = arg0.y
	local var2 = arg0.z
	local var3 = arg0.w
	local var4 = 2 * (var1 * var2 - var3 * var0)

	if var4 < 0.999 then
		if var4 > -0.999 then
			local var5 = var16.New(-var4(var4), var9(2 * (var0 * var2 + var3 * var1), 1 - 2 * (var0 * var0 + var1 * var1)), var9(2 * (var0 * var1 + var3 * var2), 1 - 2 * (var0 * var0 + var2 * var2)))

			var33(var5)
			var5:Mul(var17)

			return var5
		else
			local var6 = var16.New(var29, var9(2 * (var0 * var1 - var3 * var2), 1 - 2 * (var1 * var1 + var2 * var2)), 0)

			var33(var6)
			var6:Mul(var17)

			return var6
		end
	else
		local var7 = var16.New(-var29, var9(-2 * (var0 * var1 - var3 * var2), 1 - 2 * (var1 * var1 + var2 * var2)), 0)

		var33(var7)
		var7:Mul(var17)

		return var7
	end
end

function var22.Forward(arg0)
	return arg0:MulVec3(var19)
end

function var22.MulVec3(arg0, arg1)
	local var0 = var16.New()
	local var1 = arg0.x * 2
	local var2 = arg0.y * 2
	local var3 = arg0.z * 2
	local var4 = arg0.x * var1
	local var5 = arg0.y * var2
	local var6 = arg0.z * var3
	local var7 = arg0.x * var2
	local var8 = arg0.x * var3
	local var9 = arg0.y * var3
	local var10 = arg0.w * var1
	local var11 = arg0.w * var2
	local var12 = arg0.w * var3

	var0.x = (1 - (var5 + var6)) * arg1.x + (var7 - var12) * arg1.y + (var8 + var11) * arg1.z
	var0.y = (var7 + var12) * arg1.x + (1 - (var4 + var6)) * arg1.y + (var9 - var10) * arg1.z
	var0.z = (var8 - var11) * arg1.x + (var9 + var10) * arg1.y + (1 - (var4 + var5)) * arg1.z

	return var0
end

function var22.__mul(arg0, arg1)
	if var22 == var13(arg1) then
		return var22.New(arg0.w * arg1.x + arg0.x * arg1.w + arg0.y * arg1.z - arg0.z * arg1.y, arg0.w * arg1.y + arg0.y * arg1.w + arg0.z * arg1.x - arg0.x * arg1.z, arg0.w * arg1.z + arg0.z * arg1.w + arg0.x * arg1.y - arg0.y * arg1.x, arg0.w * arg1.w - arg0.x * arg1.x - arg0.y * arg1.y - arg0.z * arg1.z)
	elseif var16 == var13(arg1) then
		return arg0:MulVec3(arg1)
	end
end

function var22.__unm(arg0)
	return var22.New(-arg0.x, -arg0.y, -arg0.z, -arg0.w)
end

function var22.__eq(arg0, arg1)
	return var22.Dot(arg0, arg1) > 0.999999
end

function var22.__tostring(arg0)
	return "[" .. arg0.x .. "," .. arg0.y .. "," .. arg0.z .. "," .. arg0.w .. "]"
end

function var23.identity()
	return var24(0, 0, 0, 1)
end

var23.eulerAngles = var22.ToEulerAngles
UnityEngine.Quaternion = var22

var12(var22, var22)

return var22
