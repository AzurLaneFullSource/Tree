local var0_0 = math
local var1_0 = var0_0.acos
local var2_0 = var0_0.sqrt
local var3_0 = var0_0.max
local var4_0 = var0_0.min
local var5_0 = Mathf.Clamp
local var6_0 = var0_0.cos
local var7_0 = var0_0.sin
local var8_0 = var0_0.abs
local var9_0 = Mathf.Sign
local var10_0 = setmetatable
local var11_0 = rawset
local var12_0 = rawget
local var13_0 = type
local var14_0 = 57.295779513082
local var15_0 = 0.017453292519943
local var16_0 = {}
local var17_0 = tolua.initget(var16_0)

function var16_0.__index(arg0_1, arg1_1)
	local var0_1 = var12_0(var16_0, arg1_1)

	if var0_1 == nil then
		var0_1 = var12_0(var17_0, arg1_1)

		if var0_1 ~= nil then
			return var0_1(arg0_1)
		end
	end

	return var0_1
end

function var16_0.New(arg0_2, arg1_2, arg2_2)
	local var0_2 = {
		x = arg0_2 or 0,
		y = arg1_2 or 0,
		z = arg2_2 or 0
	}

	var10_0(var0_2, var16_0)

	return var0_2
end

local var18_0 = var16_0.New

function var16_0.__call(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = {
		x = arg1_3 or 0,
		y = arg2_3 or 0,
		z = arg3_3 or 0
	}

	var10_0(var0_3, var16_0)

	return var0_3
end

function var16_0.Set(arg0_4, arg1_4, arg2_4, arg3_4)
	arg0_4.x = arg1_4 or 0
	arg0_4.y = arg2_4 or 0
	arg0_4.z = arg3_4 or 0
end

function var16_0.Get(arg0_5)
	return arg0_5.x, arg0_5.y, arg0_5.z
end

function var16_0.Clone(arg0_6)
	return var10_0({
		x = arg0_6.x,
		y = arg0_6.y,
		z = arg0_6.z
	}, var16_0)
end

function var16_0.Copy(arg0_7, arg1_7)
	arg0_7.x = arg1_7.x
	arg0_7.y = arg1_7.y
	arg0_7.z = arg1_7.z

	return arg0_7
end

function var16_0.Copy2(arg0_8, arg1_8)
	if arg1_8 then
		arg1_8.x = arg0_8.x
		arg1_8.y = arg0_8.y
		arg1_8.z = arg0_8.z

		return arg1_8
	else
		return var18_0(arg0_8.x, arg0_8.y, arg0_8.z)
	end
end

function var16_0.Distance(arg0_9, arg1_9)
	return var2_0((arg0_9.x - arg1_9.x)^2 + (arg0_9.y - arg1_9.y)^2 + (arg0_9.z - arg1_9.z)^2)
end

function var16_0.BattleDistance(arg0_10, arg1_10)
	return var2_0((arg0_10.x - arg1_10.x)^2 + (arg0_10.z - arg1_10.z)^2)
end

function var16_0.SqrDistance(arg0_11, arg1_11)
	return (arg0_11.x - arg1_11.x)^2 + (arg0_11.y - arg1_11.y)^2 + (arg0_11.z - arg1_11.z)^2
end

function var16_0.Dot(arg0_12, arg1_12)
	return arg0_12.x * arg1_12.x + arg0_12.y * arg1_12.y + arg0_12.z * arg1_12.z
end

function var16_0.Lerp(arg0_13, arg1_13, arg2_13)
	arg2_13 = var5_0(arg2_13, 0, 1)

	return var18_0(arg0_13.x + (arg1_13.x - arg0_13.x) * arg2_13, arg0_13.y + (arg1_13.y - arg0_13.y) * arg2_13, arg0_13.z + (arg1_13.z - arg0_13.z) * arg2_13)
end

function var16_0.Magnitude(arg0_14)
	return var2_0(arg0_14.x * arg0_14.x + arg0_14.y * arg0_14.y + arg0_14.z * arg0_14.z)
end

function var16_0.Max(arg0_15, arg1_15)
	return var18_0(var3_0(arg0_15.x, arg1_15.x), var3_0(arg0_15.y, arg1_15.y), var3_0(arg0_15.z, arg1_15.z))
end

function var16_0.Min(arg0_16, arg1_16)
	return var18_0(var4_0(arg0_16.x, arg1_16.x), var4_0(arg0_16.y, arg1_16.y), var4_0(arg0_16.z, arg1_16.z))
end

function var16_0.Normalize(arg0_17)
	local var0_17 = arg0_17.x
	local var1_17 = arg0_17.y
	local var2_17 = arg0_17.z
	local var3_17 = var2_0(var0_17 * var0_17 + var1_17 * var1_17 + var2_17 * var2_17)

	if var3_17 > 1e-05 then
		return var10_0({
			x = var0_17 / var3_17,
			y = var1_17 / var3_17,
			z = var2_17 / var3_17
		}, var16_0)
	end

	return var10_0({
		z = 0,
		x = 0,
		y = 0
	}, var16_0)
end

function var16_0.SetNormalize(arg0_18)
	local var0_18 = var2_0(arg0_18.x * arg0_18.x + arg0_18.y * arg0_18.y + arg0_18.z * arg0_18.z)

	if var0_18 > 1e-05 then
		arg0_18.x = arg0_18.x / var0_18
		arg0_18.y = arg0_18.y / var0_18
		arg0_18.z = arg0_18.z / var0_18
	else
		arg0_18.x = 0
		arg0_18.y = 0
		arg0_18.z = 0
	end

	return arg0_18
end

function var16_0.SqrMagnitude(arg0_19)
	return arg0_19.x * arg0_19.x + arg0_19.y * arg0_19.y + arg0_19.z * arg0_19.z
end

local var19_0 = var16_0.Dot

function var16_0.Angle(arg0_20, arg1_20)
	return var1_0(var5_0(var19_0(arg0_20:Normalize(), arg1_20:Normalize()), -1, 1)) * var14_0
end

function var16_0.ClampMagnitude(arg0_21, arg1_21)
	if arg0_21:SqrMagnitude() > arg1_21 * arg1_21 then
		arg0_21:SetNormalize()
		arg0_21:Mul(arg1_21)
	end

	return arg0_21
end

function var16_0.OrthoNormalize(arg0_22, arg1_22, arg2_22)
	arg0_22:SetNormalize()
	arg1_22:Sub(arg1_22:Project(arg0_22))
	arg1_22:SetNormalize()

	if arg2_22 == nil then
		return arg0_22, arg1_22
	end

	arg2_22:Sub(arg2_22:Project(arg0_22))
	arg2_22:Sub(arg2_22:Project(arg1_22))
	arg2_22:SetNormalize()

	return arg0_22, arg1_22, arg2_22
end

function var16_0.MoveTowards(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg1_23 - arg0_23
	local var1_23 = var0_23:SqrMagnitude()

	if var1_23 > arg2_23 * arg2_23 then
		local var2_23 = var2_0(var1_23)

		if var2_23 > 1e-06 then
			var0_23:Mul(arg2_23 / var2_23)
			var0_23:Add(arg0_23)

			return var0_23
		else
			return arg0_23:Clone()
		end
	end

	return arg1_23:Clone()
end

function ClampedMove(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg1_24 - arg0_24

	if var0_24 > 0 then
		return arg0_24 + var4_0(var0_24, arg2_24)
	else
		return arg0_24 - var4_0(-var0_24, arg2_24)
	end
end

local var20_0 = 0.707106781186548

local function var21_0(arg0_25)
	local var0_25 = var18_0()

	if var8_0(arg0_25.z) > var20_0 then
		local var1_25 = arg0_25.y * arg0_25.y + arg0_25.z * arg0_25.z
		local var2_25 = 1 / var2_0(var1_25)

		var0_25.x = 0
		var0_25.y = -arg0_25.z * var2_25
		var0_25.z = arg0_25.y * var2_25
	else
		local var3_25 = arg0_25.x * arg0_25.x + arg0_25.y * arg0_25.y
		local var4_25 = 1 / var2_0(var3_25)

		var0_25.x = -arg0_25.y * var4_25
		var0_25.y = arg0_25.x * var4_25
		var0_25.z = 0
	end

	return var0_25
end

function var16_0.RotateTowards(arg0_26, arg1_26, arg2_26, arg3_26)
	local var0_26 = arg0_26:Magnitude()
	local var1_26 = arg1_26:Magnitude()

	if var0_26 > 1e-06 and var1_26 > 1e-06 then
		local var2_26 = arg0_26 / var0_26
		local var3_26 = arg1_26 / var1_26
		local var4_26 = var19_0(var2_26, var3_26)

		if var4_26 > 0.999999 then
			return var16_0.MoveTowards(arg0_26, arg1_26, arg3_26)
		elseif var4_26 < -0.999999 then
			local var5_26 = var21_0(var2_26)
			local var6_26 = Quaternion.AngleAxis(arg2_26 * var14_0, var5_26):MulVec3(var2_26)
			local var7_26 = ClampedMove(var0_26, var1_26, arg3_26)

			var6_26:Mul(var7_26)

			return var6_26
		else
			local var8_26 = var1_0(var4_26)
			local var9_26 = var16_0.Cross(var2_26, var3_26)

			var9_26:SetNormalize()

			local var10_26 = Quaternion.AngleAxis(var4_0(arg2_26, var8_26) * var14_0, var9_26):MulVec3(var2_26)
			local var11_26 = ClampedMove(var0_26, var1_26, arg3_26)

			var10_26:Mul(var11_26)

			return var10_26
		end
	end

	return var16_0.MoveTowards(arg0_26, arg1_26, arg3_26)
end

function var16_0.SmoothDamp(arg0_27, arg1_27, arg2_27, arg3_27)
	local var0_27 = Mathf.Infinity
	local var1_27 = Time.deltaTime

	arg3_27 = var3_0(0.0001, arg3_27)

	local var2_27 = 2 / arg3_27
	local var3_27 = var2_27 * var1_27
	local var4_27 = 1 / (1 + var3_27 + 0.48 * var3_27 * var3_27 + 0.235 * var3_27 * var3_27 * var3_27)
	local var5_27 = arg1_27:Clone()
	local var6_27 = var0_27 * arg3_27
	local var7_27 = arg0_27 - arg1_27

	var7_27:ClampMagnitude(var6_27)

	arg1_27 = arg0_27 - var7_27

	local var8_27 = (arg2_27 + var7_27 * var2_27) * var1_27

	arg2_27 = (arg2_27 - var8_27 * var2_27) * var4_27

	local var9_27 = arg1_27 + (var7_27 + var8_27) * var4_27

	if var16_0.Dot(var5_27 - arg0_27, var9_27 - var5_27) > 0 then
		var9_27 = var5_27

		arg2_27:Set(0, 0, 0)
	end

	return var9_27, arg2_27
end

function var16_0.Scale(arg0_28, arg1_28)
	local var0_28 = arg0_28.x * arg1_28.x
	local var1_28 = arg0_28.y * arg1_28.y
	local var2_28 = arg0_28.z * arg1_28.z

	return var18_0(var0_28, var1_28, var2_28)
end

function var16_0.Cross2(arg0_29, arg1_29)
	local var0_29 = arg0_29
	local var1_29 = var0_29.y * arg1_29.z - var0_29.z * arg1_29.y
	local var2_29 = var0_29.z * arg1_29.x - var0_29.x * arg1_29.z
	local var3_29 = var0_29.x * arg1_29.y - var0_29.y * arg1_29.x

	arg0_29.x, arg0_29.y, arg0_29.z = var1_29, var2_29, var3_29

	return arg0_29
end

function var16_0.Cross(arg0_30, arg1_30)
	local var0_30 = arg0_30.y * arg1_30.z - arg0_30.z * arg1_30.y
	local var1_30 = arg0_30.z * arg1_30.x - arg0_30.x * arg1_30.z
	local var2_30 = arg0_30.x * arg1_30.y - arg0_30.y * arg1_30.x

	return var18_0(var0_30, var1_30, var2_30)
end

function var16_0.Equals(arg0_31, arg1_31)
	return arg0_31.x == arg1_31.x and arg0_31.y == arg1_31.y and arg0_31.z == arg1_31.z
end

function var16_0.EqualZero(arg0_32)
	return arg0_32.x * arg0_32.x + arg0_32.y * arg0_32.y + arg0_32.z * arg0_32.z < 1e-10
end

function var16_0.Reflect(arg0_33, arg1_33)
	arg1_33 = arg1_33 * (-2 * var19_0(arg1_33, arg0_33))

	arg1_33:Add(arg0_33)

	return arg1_33
end

function var16_0.Project(arg0_34, arg1_34)
	local var0_34 = arg1_34:SqrMagnitude()

	if var0_34 < 1.175494e-38 then
		return var18_0(0, 0, 0)
	end

	local var1_34 = var19_0(arg0_34, arg1_34)
	local var2_34 = arg1_34:Clone()

	var2_34:Mul(var1_34 / var0_34)

	return var2_34
end

function var16_0.ProjectOnPlane(arg0_35, arg1_35)
	local var0_35 = var16_0.Project(arg0_35, arg1_35)

	var0_35:Mul(-1)
	var0_35:Add(arg0_35)

	return var0_35
end

function var16_0.Slerp(arg0_36, arg1_36, arg2_36)
	local var0_36
	local var1_36
	local var2_36
	local var3_36

	if arg2_36 <= 0 then
		return arg0_36:Clone()
	elseif arg2_36 >= 1 then
		return arg1_36:Clone()
	end

	local var4_36 = arg1_36:Clone()
	local var5_36 = arg0_36:Clone()
	local var6_36 = arg1_36:Magnitude()
	local var7_36 = arg0_36:Magnitude()

	var4_36:Div(var6_36)
	var5_36:Div(var7_36)

	local var8_36 = (var6_36 - var7_36) * arg2_36 + var7_36
	local var9_36 = var5_36.x * var4_36.x + var5_36.y * var4_36.y + var5_36.z * var4_36.z

	if var9_36 > 0.999999 then
		var2_36 = 1 - arg2_36
		var3_36 = arg2_36
	elseif var9_36 < -0.999999 then
		local var10_36 = var21_0(arg0_36)
		local var11_36 = Quaternion.AngleAxis(180 * arg2_36, var10_36):MulVec3(arg0_36)

		var11_36:Mul(var8_36)

		return var11_36
	else
		local var12_36 = var1_0(var9_36)
		local var13_36 = var7_0(var12_36)

		var2_36 = var7_0((1 - arg2_36) * var12_36) / var13_36
		var3_36 = var7_0(arg2_36 * var12_36) / var13_36
	end

	var5_36:Mul(var2_36)
	var4_36:Mul(var3_36)
	var4_36:Add(var5_36)
	var4_36:Mul(var8_36)

	return var4_36
end

function var16_0.Mul(arg0_37, arg1_37)
	if var13_0(arg1_37) == "number" then
		arg0_37.x = arg0_37.x * arg1_37
		arg0_37.y = arg0_37.y * arg1_37
		arg0_37.z = arg0_37.z * arg1_37
	else
		arg0_37:MulQuat(arg1_37)
	end

	return arg0_37
end

function var16_0.Div(arg0_38, arg1_38)
	arg0_38.x = arg0_38.x / arg1_38
	arg0_38.y = arg0_38.y / arg1_38
	arg0_38.z = arg0_38.z / arg1_38

	return arg0_38
end

function var16_0.Add(arg0_39, arg1_39)
	arg0_39.x = arg0_39.x + arg1_39.x
	arg0_39.y = arg0_39.y + arg1_39.y
	arg0_39.z = arg0_39.z + arg1_39.z

	return arg0_39
end

function var16_0.Sub(arg0_40, arg1_40)
	arg0_40.x = arg0_40.x - arg1_40.x
	arg0_40.y = arg0_40.y - arg1_40.y
	arg0_40.z = arg0_40.z - arg1_40.z

	return arg0_40
end

function var16_0.MulQuat(arg0_41, arg1_41)
	local var0_41 = arg1_41.x * 2
	local var1_41 = arg1_41.y * 2
	local var2_41 = arg1_41.z * 2
	local var3_41 = arg1_41.x * var0_41
	local var4_41 = arg1_41.y * var1_41
	local var5_41 = arg1_41.z * var2_41
	local var6_41 = arg1_41.x * var1_41
	local var7_41 = arg1_41.x * var2_41
	local var8_41 = arg1_41.y * var2_41
	local var9_41 = arg1_41.w * var0_41
	local var10_41 = arg1_41.w * var1_41
	local var11_41 = arg1_41.w * var2_41
	local var12_41 = (1 - (var4_41 + var5_41)) * arg0_41.x + (var6_41 - var11_41) * arg0_41.y + (var7_41 + var10_41) * arg0_41.z
	local var13_41 = (var6_41 + var11_41) * arg0_41.x + (1 - (var3_41 + var5_41)) * arg0_41.y + (var8_41 - var9_41) * arg0_41.z
	local var14_41 = (var7_41 - var10_41) * arg0_41.x + (var8_41 + var9_41) * arg0_41.y + (1 - (var3_41 + var4_41)) * arg0_41.z

	arg0_41:Set(var12_41, var13_41, var14_41)

	return arg0_41
end

function var16_0.AngleAroundAxis(arg0_42, arg1_42, arg2_42)
	arg0_42 = arg0_42 - var16_0.Project(arg0_42, arg2_42)
	arg1_42 = arg1_42 - var16_0.Project(arg1_42, arg2_42)

	return var16_0.Angle(arg0_42, arg1_42) * (var16_0.Dot(arg2_42, var16_0.Cross(arg0_42, arg1_42)) < 0 and -1 or 1)
end

function var16_0.__tostring(arg0_43)
	return "[" .. arg0_43.x .. "," .. arg0_43.y .. "," .. arg0_43.z .. "]"
end

function var16_0.__div(arg0_44, arg1_44)
	return var18_0(arg0_44.x / arg1_44, arg0_44.y / arg1_44, arg0_44.z / arg1_44)
end

function var16_0.__mul(arg0_45, arg1_45)
	if var13_0(arg1_45) == "number" then
		return var18_0(arg0_45.x * arg1_45, arg0_45.y * arg1_45, arg0_45.z * arg1_45)
	else
		local var0_45 = arg0_45:Clone()

		var0_45:MulQuat(arg1_45)

		return var0_45
	end
end

function var16_0.__add(arg0_46, arg1_46)
	return var18_0(arg0_46.x + arg1_46.x, arg0_46.y + arg1_46.y, arg0_46.z + arg1_46.z)
end

function var16_0.__sub(arg0_47, arg1_47)
	return var18_0(arg0_47.x - arg1_47.x, arg0_47.y - arg1_47.y, arg0_47.z - arg1_47.z)
end

function var16_0.__unm(arg0_48)
	return var18_0(-arg0_48.x, -arg0_48.y, -arg0_48.z)
end

function var16_0.__eq(arg0_49, arg1_49)
	return (arg0_49.x - arg1_49.x) * (arg0_49.x - arg1_49.x) + (arg0_49.y - arg1_49.y) * (arg0_49.y - arg1_49.y) + (arg0_49.z - arg1_49.z) * (arg0_49.z - arg1_49.z) < 1e-10
end

function var17_0.up()
	return var18_0(0, 1, 0)
end

function var17_0.down()
	return var18_0(0, -1, 0)
end

function var17_0.right()
	return var18_0(1, 0, 0)
end

function var17_0.left()
	return var18_0(-1, 0, 0)
end

function var17_0.forward()
	return var18_0(0, 0, 1)
end

function var17_0.back()
	return var18_0(0, 0, -1)
end

function var17_0.zero()
	return var18_0(0, 0, 0)
end

function var17_0.one()
	return var18_0(1, 1, 1)
end

var17_0.magnitude = var16_0.Magnitude
var17_0.normalized = var16_0.Normalize
var17_0.sqrMagnitude = var16_0.SqrMagnitude
UnityEngine.Vector3 = var16_0

var10_0(var16_0, var16_0)

return var16_0
