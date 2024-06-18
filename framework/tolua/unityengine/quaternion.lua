local var0_0 = math
local var1_0 = var0_0.sin
local var2_0 = var0_0.cos
local var3_0 = var0_0.acos
local var4_0 = var0_0.asin
local var5_0 = var0_0.sqrt
local var6_0 = var0_0.min
local var7_0 = var0_0.max
local var8_0 = var0_0.sign
local var9_0 = var0_0.atan2
local var10_0 = Mathf.Clamp
local var11_0 = var0_0.abs
local var12_0 = setmetatable
local var13_0 = getmetatable
local var14_0 = rawget
local var15_0 = rawset
local var16_0 = Vector3
local var17_0 = Mathf.Rad2Deg
local var18_0 = 0.5 * Mathf.Deg2Rad
local var19_0 = var16_0.forward
local var20_0 = var16_0.up
local var21_0 = {
	2,
	3,
	1
}
local var22_0 = {}
local var23_0 = tolua.initget(var22_0)

function var22_0.__index(arg0_1, arg1_1)
	local var0_1 = var14_0(var22_0, arg1_1)

	if var0_1 == nil then
		var0_1 = var14_0(var23_0, arg1_1)

		if var0_1 ~= nil then
			return var0_1(arg0_1)
		end
	end

	return var0_1
end

function var22_0.__newindex(arg0_2, arg1_2, arg2_2)
	if arg1_2 == "eulerAngles" then
		arg0_2:SetEuler(arg2_2)
	else
		var15_0(arg0_2, arg1_2, arg2_2)
	end
end

function var22_0.New(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = {
		x = arg0_3 or 0,
		y = arg1_3 or 0,
		z = arg2_3 or 0,
		w = arg3_3 or 0
	}

	var12_0(var0_3, var22_0)

	return var0_3
end

local var24_0 = var22_0.New

function var22_0.__call(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
	local var0_4 = {
		x = arg1_4 or 0,
		y = arg2_4 or 0,
		z = arg3_4 or 0,
		w = arg4_4 or 0
	}

	var12_0(var0_4, var22_0)

	return var0_4
end

function var22_0.Set(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	arg0_5.x = arg1_5 or 0
	arg0_5.y = arg2_5 or 0
	arg0_5.z = arg3_5 or 0
	arg0_5.w = arg4_5 or 0
end

function var22_0.Clone(arg0_6)
	return var24_0(arg0_6.x, arg0_6.y, arg0_6.z, arg0_6.w)
end

function var22_0.Get(arg0_7)
	return arg0_7.x, arg0_7.y, arg0_7.z, arg0_7.w
end

function var22_0.Dot(arg0_8, arg1_8)
	return arg0_8.x * arg1_8.x + arg0_8.y * arg1_8.y + arg0_8.z * arg1_8.z + arg0_8.w * arg1_8.w
end

function var22_0.Angle(arg0_9, arg1_9)
	local var0_9 = var22_0.Dot(arg0_9, arg1_9)

	if var0_9 < 0 then
		var0_9 = -var0_9
	end

	return var3_0(var6_0(var0_9, 1)) * 2 * 57.29578
end

function var22_0.AngleAxis(arg0_10, arg1_10)
	local var0_10 = arg1_10:Normalize()

	arg0_10 = arg0_10 * var18_0

	local var1_10 = var1_0(arg0_10)
	local var2_10 = var2_0(arg0_10)
	local var3_10 = var0_10.x * var1_10
	local var4_10 = var0_10.y * var1_10
	local var5_10 = var0_10.z * var1_10

	return var24_0(var3_10, var4_10, var5_10, var2_10)
end

function var22_0.Equals(arg0_11, arg1_11)
	return arg0_11.x == arg1_11.x and arg0_11.y == arg1_11.y and arg0_11.z == arg1_11.z and arg0_11.w == arg1_11.w
end

function var22_0.Euler(arg0_12, arg1_12, arg2_12)
	arg0_12 = arg0_12 * 0.0087266462599716
	arg1_12 = arg1_12 * 0.0087266462599716
	arg2_12 = arg2_12 * 0.0087266462599716

	local var0_12 = var1_0(arg0_12)

	arg0_12 = var2_0(arg0_12)

	local var1_12 = var1_0(arg1_12)

	arg1_12 = var2_0(arg1_12)

	local var2_12 = var1_0(arg2_12)

	arg2_12 = var2_0(arg2_12)

	local var3_12 = {
		x = arg1_12 * var0_12 * arg2_12 + var1_12 * arg0_12 * var2_12,
		y = var1_12 * arg0_12 * arg2_12 - arg1_12 * var0_12 * var2_12,
		z = arg1_12 * arg0_12 * var2_12 - var1_12 * var0_12 * arg2_12,
		w = arg1_12 * arg0_12 * arg2_12 + var1_12 * var0_12 * var2_12
	}

	var12_0(var3_12, var22_0)

	return var3_12
end

function var22_0.SetEuler(arg0_13, arg1_13, arg2_13, arg3_13)
	if arg2_13 == nil and arg3_13 == nil then
		arg2_13 = arg1_13.y
		arg3_13 = arg1_13.z
		arg1_13 = arg1_13.x
	end

	arg1_13 = arg1_13 * 0.0087266462599716
	arg2_13 = arg2_13 * 0.0087266462599716
	arg3_13 = arg3_13 * 0.0087266462599716

	local var0_13 = var1_0(arg1_13)
	local var1_13 = var2_0(arg1_13)
	local var2_13 = var1_0(arg2_13)
	local var3_13 = var2_0(arg2_13)
	local var4_13 = var1_0(arg3_13)
	local var5_13 = var2_0(arg3_13)

	arg0_13.w = var3_13 * var1_13 * var5_13 + var2_13 * var0_13 * var4_13
	arg0_13.x = var3_13 * var0_13 * var5_13 + var2_13 * var1_13 * var4_13
	arg0_13.y = var2_13 * var1_13 * var5_13 - var3_13 * var0_13 * var4_13
	arg0_13.z = var3_13 * var1_13 * var4_13 - var2_13 * var0_13 * var5_13

	return arg0_13
end

function var22_0.Normalize(arg0_14)
	local var0_14 = arg0_14:Clone()

	var0_14:SetNormalize()

	return var0_14
end

function var22_0.SetNormalize(arg0_15)
	local var0_15 = arg0_15.x * arg0_15.x + arg0_15.y * arg0_15.y + arg0_15.z * arg0_15.z + arg0_15.w * arg0_15.w

	if var0_15 ~= 1 and var0_15 > 0 then
		local var1_15 = 1 / var5_0(var0_15)

		arg0_15.x = arg0_15.x * var1_15
		arg0_15.y = arg0_15.y * var1_15
		arg0_15.z = arg0_15.z * var1_15
		arg0_15.w = arg0_15.w * var1_15
	end
end

function var22_0.FromToRotation(arg0_16, arg1_16)
	local var0_16 = var22_0.New()

	var0_16:SetFromToRotation(arg0_16, arg1_16)

	return var0_16
end

function var22_0.SetFromToRotation1(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg1_17:Normalize()
	local var1_17 = arg2_17:Normalize()
	local var2_17 = var16_0.Dot(var0_17, var1_17)

	if var2_17 > -0.999999 then
		local var3_17 = var5_0((1 + var2_17) * 2)
		local var4_17 = 1 / var3_17
		local var5_17 = var16_0.Cross(var0_17, var1_17) * var4_17

		arg0_17:Set(var5_17.x, var5_17.y, var5_17.z, var3_17 * 0.5)
	elseif var2_17 > 0.999999 then
		return var24_0(0, 0, 0, 1)
	else
		local var6_17 = var16_0.Cross(var16_0.right, var0_17)

		if var6_17:SqrMagnitude() < 1e-06 then
			var6_17 = var16_0.Cross(var16_0.forward, var0_17)
		end

		arg0_17:Set(var6_17.x, var6_17.y, var6_17.z, 0)

		return arg0_17
	end

	return arg0_17
end

local function var25_0(arg0_18, arg1_18)
	local var0_18 = arg0_18[1][1] + arg0_18[2][2] + arg0_18[3][3]

	if var0_18 > 0 then
		local var1_18 = var5_0(var0_18 + 1)

		arg1_18.w = 0.5 * var1_18

		local var2_18 = 0.5 / var1_18

		arg1_18.x = (arg0_18[3][2] - arg0_18[2][3]) * var2_18
		arg1_18.y = (arg0_18[1][3] - arg0_18[3][1]) * var2_18
		arg1_18.z = (arg0_18[2][1] - arg0_18[1][2]) * var2_18

		arg1_18:SetNormalize()
	else
		local var3_18 = 1
		local var4_18 = {
			0,
			0,
			0
		}

		if arg0_18[2][2] > arg0_18[1][1] then
			var3_18 = 2
		end

		if arg0_18[3][3] > arg0_18[var3_18][var3_18] then
			var3_18 = 3
		end

		local var5_18 = var21_0[var3_18]
		local var6_18 = var21_0[var5_18]
		local var7_18 = arg0_18[var3_18][var3_18] - arg0_18[var5_18][var5_18] - arg0_18[var6_18][var6_18] + 1
		local var8_18 = 0.5 / var5_0(var7_18)

		var4_18[var3_18] = var8_18 * var7_18

		local var9_18 = (arg0_18[var6_18][var5_18] - arg0_18[var5_18][var6_18]) * var8_18

		var4_18[var5_18] = (arg0_18[var5_18][var3_18] + arg0_18[var3_18][var5_18]) * var8_18
		var4_18[var6_18] = (arg0_18[var6_18][var3_18] + arg0_18[var3_18][var6_18]) * var8_18

		arg1_18:Set(var4_18[1], var4_18[2], var4_18[3], var9_18)
		arg1_18:SetNormalize()
	end
end

function var22_0.SetFromToRotation(arg0_19, arg1_19, arg2_19)
	arg1_19 = arg1_19:Normalize()
	arg2_19 = arg2_19:Normalize()

	local var0_19 = var16_0.Dot(arg1_19, arg2_19)

	if var0_19 > 0.999999 then
		arg0_19:Set(0, 0, 0, 1)
	elseif var0_19 < -0.999999 then
		local var1_19 = {
			0,
			arg1_19.z,
			arg1_19.y
		}
		local var2_19 = var1_19[2] * var1_19[2] + var1_19[3] * var1_19[3]

		if var2_19 < 1e-06 then
			var1_19[1] = -arg1_19.z
			var1_19[2] = 0
			var1_19[3] = arg1_19.x
			var2_19 = var1_19[1] * var1_19[1] + var1_19[3] * var1_19[3]
		end

		local var3_19 = 1 / var5_0(var2_19)

		var1_19[1] = var1_19[1] * var3_19
		var1_19[2] = var1_19[2] * var3_19
		var1_19[3] = var1_19[3] * var3_19

		local var4_19 = {
			0,
			0,
			0,
			[1] = var1_19[2] * arg1_19.z - var1_19[3] * arg1_19.y,
			[2] = var1_19[3] * arg1_19.x - var1_19[1] * arg1_19.z,
			[3] = var1_19[1] * arg1_19.y - var1_19[2] * arg1_19.x
		}
		local var5_19 = -arg1_19.x * arg1_19.x
		local var6_19 = -arg1_19.y * arg1_19.y
		local var7_19 = -arg1_19.z * arg1_19.z
		local var8_19 = -arg1_19.x * arg1_19.y
		local var9_19 = -arg1_19.x * arg1_19.z
		local var10_19 = -arg1_19.y * arg1_19.z
		local var11_19 = var4_19[1] * var4_19[1]
		local var12_19 = var4_19[2] * var4_19[2]
		local var13_19 = var4_19[3] * var4_19[3]
		local var14_19 = var4_19[1] * var4_19[2]
		local var15_19 = var4_19[1] * var4_19[3]
		local var16_19 = var4_19[2] * var4_19[3]
		local var17_19 = -var1_19[1] * var1_19[1]
		local var18_19 = -var1_19[2] * var1_19[2]
		local var19_19 = -var1_19[3] * var1_19[3]
		local var20_19 = -var1_19[1] * var1_19[2]
		local var21_19 = -var1_19[1] * var1_19[3]
		local var22_19 = -var1_19[2] * var1_19[3]
		local var23_19 = {
			{
				var5_19 + var11_19 + var17_19,
				var8_19 + var14_19 + var20_19,
				var9_19 + var15_19 + var21_19
			},
			{
				var8_19 + var14_19 + var20_19,
				var6_19 + var12_19 + var18_19,
				var10_19 + var16_19 + var22_19
			},
			{
				var9_19 + var15_19 + var21_19,
				var10_19 + var16_19 + var22_19,
				var7_19 + var13_19 + var19_19
			}
		}

		var25_0(var23_19, arg0_19)
	else
		local var24_19 = var16_0.Cross(arg1_19, arg2_19)
		local var25_19 = (1 - var0_19) / var16_0.Dot(var24_19, var24_19)
		local var26_19 = var25_19 * var24_19.x
		local var27_19 = var25_19 * var24_19.z
		local var28_19 = var26_19 * var24_19.y
		local var29_19 = var26_19 * var24_19.z
		local var30_19 = var27_19 * var24_19.y
		local var31_19 = {
			{
				var0_19 + var26_19 * var24_19.x,
				var28_19 - var24_19.z,
				var29_19 + var24_19.y
			},
			{
				var28_19 + var24_19.z,
				var0_19 + var25_19 * var24_19.y * var24_19.y,
				var30_19 - var24_19.x
			},
			{
				var29_19 - var24_19.y,
				var30_19 + var24_19.x,
				var0_19 + var27_19 * var24_19.z
			}
		}

		var25_0(var31_19, arg0_19)
	end
end

function var22_0.Inverse(arg0_20)
	local var0_20 = var22_0.New()

	var0_20.x = -arg0_20.x
	var0_20.y = -arg0_20.y
	var0_20.z = -arg0_20.z
	var0_20.w = arg0_20.w

	return var0_20
end

function var22_0.Lerp(arg0_21, arg1_21, arg2_21)
	arg2_21 = var10_0(arg2_21, 0, 1)

	local var0_21 = {
		w = 1,
		z = 0,
		x = 0,
		y = 0
	}

	if var22_0.Dot(arg0_21, arg1_21) < 0 then
		var0_21.x = arg0_21.x + arg2_21 * (-arg1_21.x - arg0_21.x)
		var0_21.y = arg0_21.y + arg2_21 * (-arg1_21.y - arg0_21.y)
		var0_21.z = arg0_21.z + arg2_21 * (-arg1_21.z - arg0_21.z)
		var0_21.w = arg0_21.w + arg2_21 * (-arg1_21.w - arg0_21.w)
	else
		var0_21.x = arg0_21.x + (arg1_21.x - arg0_21.x) * arg2_21
		var0_21.y = arg0_21.y + (arg1_21.y - arg0_21.y) * arg2_21
		var0_21.z = arg0_21.z + (arg1_21.z - arg0_21.z) * arg2_21
		var0_21.w = arg0_21.w + (arg1_21.w - arg0_21.w) * arg2_21
	end

	var22_0.SetNormalize(var0_21)
	var12_0(var0_21, var22_0)

	return var0_21
end

function var22_0.LookRotation(arg0_22, arg1_22)
	local var0_22 = arg0_22:Magnitude()

	if var0_22 < 1e-06 then
		error("error input forward to Quaternion.LookRotation" .. tostring(arg0_22))

		return nil
	end

	arg0_22 = arg0_22 / var0_22
	arg1_22 = arg1_22 or var20_0

	local var1_22 = var16_0.Cross(arg1_22, arg0_22)

	var1_22:SetNormalize()

	arg1_22 = var16_0.Cross(arg0_22, var1_22)

	local var2_22 = var16_0.Cross(arg1_22, arg0_22)
	local var3_22 = var2_22.x + arg1_22.y + arg0_22.z

	if var3_22 > 0 then
		local var4_22
		local var5_22
		local var6_22
		local var7_22
		local var8_22 = var3_22 + 1
		local var9_22 = 0.5 / var5_0(var8_22)
		local var10_22 = var9_22 * var8_22
		local var11_22 = (arg1_22.z - arg0_22.y) * var9_22
		local var12_22 = (arg0_22.x - var2_22.z) * var9_22
		local var13_22 = (var2_22.y - arg1_22.x) * var9_22
		local var14_22 = var24_0(var11_22, var12_22, var13_22, var10_22)

		var14_22:SetNormalize()

		return var14_22
	else
		local var15_22 = {
			{
				var2_22.x,
				arg1_22.x,
				arg0_22.x
			},
			{
				var2_22.y,
				arg1_22.y,
				arg0_22.y
			},
			{
				var2_22.z,
				arg1_22.z,
				arg0_22.z
			}
		}
		local var16_22 = {
			0,
			0,
			0
		}
		local var17_22 = 1

		if arg1_22.y > var2_22.x then
			var17_22 = 2
		end

		if arg0_22.z > var15_22[var17_22][var17_22] then
			var17_22 = 3
		end

		local var18_22 = var21_0[var17_22]
		local var19_22 = var21_0[var18_22]
		local var20_22 = var15_22[var17_22][var17_22] - var15_22[var18_22][var18_22] - var15_22[var19_22][var19_22] + 1
		local var21_22 = 0.5 / var5_0(var20_22)

		var16_22[var17_22] = var21_22 * var20_22

		local var22_22 = (var15_22[var19_22][var18_22] - var15_22[var18_22][var19_22]) * var21_22

		var16_22[var18_22] = (var15_22[var18_22][var17_22] + var15_22[var17_22][var18_22]) * var21_22
		var16_22[var19_22] = (var15_22[var19_22][var17_22] + var15_22[var17_22][var19_22]) * var21_22

		local var23_22 = var24_0(var16_22[1], var16_22[2], var16_22[3], var22_22)

		var23_22:SetNormalize()

		return var23_22
	end
end

function var22_0.SetIdentity(arg0_23)
	arg0_23.x = 0
	arg0_23.y = 0
	arg0_23.z = 0
	arg0_23.w = 1
end

local function var26_0(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg0_24.x * arg1_24.x + arg0_24.y * arg1_24.y + arg0_24.z * arg1_24.z + arg0_24.w * arg1_24.w

	if var0_24 < 0 then
		var0_24 = -var0_24
		arg1_24 = var12_0({
			x = -arg1_24.x,
			y = -arg1_24.y,
			z = -arg1_24.z,
			w = -arg1_24.w
		}, var22_0)
	end

	if var0_24 < 0.95 then
		local var1_24 = var3_0(var0_24)
		local var2_24 = 1 / var1_0(var1_24)
		local var3_24 = var1_0((1 - arg2_24) * var1_24) * var2_24
		local var4_24 = var1_0(arg2_24 * var1_24) * var2_24

		arg0_24 = {
			x = arg0_24.x * var3_24 + arg1_24.x * var4_24,
			y = arg0_24.y * var3_24 + arg1_24.y * var4_24,
			z = arg0_24.z * var3_24 + arg1_24.z * var4_24,
			w = arg0_24.w * var3_24 + arg1_24.w * var4_24
		}

		var12_0(arg0_24, var22_0)

		return arg0_24
	else
		arg0_24 = {
			x = arg0_24.x + arg2_24 * (arg1_24.x - arg0_24.x),
			y = arg0_24.y + arg2_24 * (arg1_24.y - arg0_24.y),
			z = arg0_24.z + arg2_24 * (arg1_24.z - arg0_24.z),
			w = arg0_24.w + arg2_24 * (arg1_24.w - arg0_24.w)
		}

		var22_0.SetNormalize(arg0_24)
		var12_0(arg0_24, var22_0)

		return arg0_24
	end
end

function var22_0.Slerp(arg0_25, arg1_25, arg2_25)
	if arg2_25 < 0 then
		arg2_25 = 0
	elseif arg2_25 > 1 then
		arg2_25 = 1
	end

	return var26_0(arg0_25, arg1_25, arg2_25)
end

function var22_0.RotateTowards(arg0_26, arg1_26, arg2_26)
	local var0_26 = var22_0.Angle(arg0_26, arg1_26)

	if var0_26 == 0 then
		return arg1_26
	end

	local var1_26 = var6_0(1, arg2_26 / var0_26)

	return var26_0(arg0_26, arg1_26, var1_26)
end

local function var27_0(arg0_27, arg1_27)
	return var11_0(arg0_27 - arg1_27) < 1e-06
end

function var22_0.ToAngleAxis(arg0_28)
	local var0_28 = 2 * var3_0(arg0_28.w)

	if var27_0(var0_28, 0) then
		return var0_28 * 57.29578, var16_0.New(1, 0, 0)
	end

	local var1_28 = 1 / var5_0(1 - var5_0(arg0_28.w))

	return var0_28 * 57.29578, var16_0.New(arg0_28.x * var1_28, arg0_28.y * var1_28, arg0_28.z * var1_28)
end

local var28_0 = Mathf.PI
local var29_0 = var28_0 * 0.5
local var30_0 = 2 * var28_0
local var31_0 = -0.0001
local var32_0 = var30_0 - 0.0001

local function var33_0(arg0_29)
	if arg0_29.x < var31_0 then
		arg0_29.x = arg0_29.x + var30_0
	elseif arg0_29.x > var32_0 then
		arg0_29.x = arg0_29.x - var30_0
	end

	if arg0_29.y < var31_0 then
		arg0_29.y = arg0_29.y + var30_0
	elseif arg0_29.y > var32_0 then
		arg0_29.y = arg0_29.y - var30_0
	end

	if arg0_29.z < var31_0 then
		arg0_29.z = arg0_29.z + var30_0
	elseif arg0_29.z > var32_0 then
		arg0_29.z = arg0_29.z + var30_0
	end
end

function var22_0.ToEulerAngles(arg0_30)
	local var0_30 = arg0_30.x
	local var1_30 = arg0_30.y
	local var2_30 = arg0_30.z
	local var3_30 = arg0_30.w
	local var4_30 = 2 * (var1_30 * var2_30 - var3_30 * var0_30)

	if var4_30 < 0.999 then
		if var4_30 > -0.999 then
			local var5_30 = var16_0.New(-var4_0(var4_30), var9_0(2 * (var0_30 * var2_30 + var3_30 * var1_30), 1 - 2 * (var0_30 * var0_30 + var1_30 * var1_30)), var9_0(2 * (var0_30 * var1_30 + var3_30 * var2_30), 1 - 2 * (var0_30 * var0_30 + var2_30 * var2_30)))

			var33_0(var5_30)
			var5_30:Mul(var17_0)

			return var5_30
		else
			local var6_30 = var16_0.New(var29_0, var9_0(2 * (var0_30 * var1_30 - var3_30 * var2_30), 1 - 2 * (var1_30 * var1_30 + var2_30 * var2_30)), 0)

			var33_0(var6_30)
			var6_30:Mul(var17_0)

			return var6_30
		end
	else
		local var7_30 = var16_0.New(-var29_0, var9_0(-2 * (var0_30 * var1_30 - var3_30 * var2_30), 1 - 2 * (var1_30 * var1_30 + var2_30 * var2_30)), 0)

		var33_0(var7_30)
		var7_30:Mul(var17_0)

		return var7_30
	end
end

function var22_0.Forward(arg0_31)
	return arg0_31:MulVec3(var19_0)
end

function var22_0.MulVec3(arg0_32, arg1_32)
	local var0_32 = var16_0.New()
	local var1_32 = arg0_32.x * 2
	local var2_32 = arg0_32.y * 2
	local var3_32 = arg0_32.z * 2
	local var4_32 = arg0_32.x * var1_32
	local var5_32 = arg0_32.y * var2_32
	local var6_32 = arg0_32.z * var3_32
	local var7_32 = arg0_32.x * var2_32
	local var8_32 = arg0_32.x * var3_32
	local var9_32 = arg0_32.y * var3_32
	local var10_32 = arg0_32.w * var1_32
	local var11_32 = arg0_32.w * var2_32
	local var12_32 = arg0_32.w * var3_32

	var0_32.x = (1 - (var5_32 + var6_32)) * arg1_32.x + (var7_32 - var12_32) * arg1_32.y + (var8_32 + var11_32) * arg1_32.z
	var0_32.y = (var7_32 + var12_32) * arg1_32.x + (1 - (var4_32 + var6_32)) * arg1_32.y + (var9_32 - var10_32) * arg1_32.z
	var0_32.z = (var8_32 - var11_32) * arg1_32.x + (var9_32 + var10_32) * arg1_32.y + (1 - (var4_32 + var5_32)) * arg1_32.z

	return var0_32
end

function var22_0.__mul(arg0_33, arg1_33)
	if var22_0 == var13_0(arg1_33) then
		return var22_0.New(arg0_33.w * arg1_33.x + arg0_33.x * arg1_33.w + arg0_33.y * arg1_33.z - arg0_33.z * arg1_33.y, arg0_33.w * arg1_33.y + arg0_33.y * arg1_33.w + arg0_33.z * arg1_33.x - arg0_33.x * arg1_33.z, arg0_33.w * arg1_33.z + arg0_33.z * arg1_33.w + arg0_33.x * arg1_33.y - arg0_33.y * arg1_33.x, arg0_33.w * arg1_33.w - arg0_33.x * arg1_33.x - arg0_33.y * arg1_33.y - arg0_33.z * arg1_33.z)
	elseif var16_0 == var13_0(arg1_33) then
		return arg0_33:MulVec3(arg1_33)
	end
end

function var22_0.__unm(arg0_34)
	return var22_0.New(-arg0_34.x, -arg0_34.y, -arg0_34.z, -arg0_34.w)
end

function var22_0.__eq(arg0_35, arg1_35)
	return var22_0.Dot(arg0_35, arg1_35) > 0.999999
end

function var22_0.__tostring(arg0_36)
	return "[" .. arg0_36.x .. "," .. arg0_36.y .. "," .. arg0_36.z .. "," .. arg0_36.w .. "]"
end

function var23_0.identity()
	return var24_0(0, 0, 0, 1)
end

var23_0.eulerAngles = var22_0.ToEulerAngles
UnityEngine.Quaternion = var22_0

var12_0(var22_0, var22_0)

return var22_0
