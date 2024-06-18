local var0_0 = {}
local var1_0 = 1e-06

local function var2_0(arg0_1)
	return arg0_1 >= -var1_0 and arg0_1 <= var1_0
end

local function var3_0(arg0_2)
	if var0_0.IsZero(arg0_2) then
		return 0
	else
		return arg0_2
	end
end

local function var4_0(arg0_3)
	if arg0_3 < -var1_0 then
		return -1
	elseif arg0_3 <= var1_0 then
		return 0
	else
		return 1
	end
end

local function var5_0(arg0_4, arg1_4)
	return Vector2.Min(arg0_4, arg1_4), Vector2.Max(arg0_4, arg1_4)
end

local function var6_0(arg0_5, arg1_5)
	return arg0_5.x * arg1_5.y - arg0_5.y * arg1_5.x
end

local function var7_0(arg0_6, arg1_6)
	return arg0_6.x * arg1_6.x + arg0_6.y * arg1_6.y
end

local function var8_0(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = arg1_7 - arg0_7
	local var1_7 = arg3_7 and arg3_7 - arg2_7 or arg2_7 - arg0_7

	return var3_0(var6_0(var0_7, var1_7))
end

local function var9_0(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = arg1_8 - arg0_8
	local var1_8 = arg3_8 and arg3_8 - arg2_8 or arg2_8 - arg0_8

	return var3_0(var7_0(var0_8, var1_8))
end

local function var10_0(arg0_9, arg1_9, arg2_9, arg3_9)
	local var0_9, var1_9 = var5_0(arg0_9, arg1_9)
	local var2_9, var3_9 = var5_0(arg2_9, arg3_9)

	return var0_9.x <= var3_9.x and var2_9.x <= var1_9.x and var0_9.y <= var3_9.y and var2_9.y <= var1_9.y
end

local function var11_0(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = arg1_10.x - arg0_10.x

	if var2_0(var0_10) then
		return var4_0(arg2_10.x - arg0_10.x) * var4_0(arg0_10.x - arg3_10.x) >= 0
	end

	local var1_10 = (arg1_10.y - arg0_10.y) / var0_10
	local var2_10 = arg1_10.y - var1_10 * arg1_10.x

	return var4_0(var1_10 * arg2_10.x + var2_10 - arg2_10.y) * var4_0(var1_10 * arg3_10.x + var2_10 - arg3_10.y) <= 0
end

local function var12_0(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11 = var8_0(arg0_11, arg2_11, arg1_11)
	local var1_11 = var8_0(arg0_11, arg1_11, arg3_11)
	local var2_11 = var0_11 * var1_11
	local var3_11 = var4_0(var0_11) == 0 and var4_0(var1_11)

	if var2_11 < -var1_0 then
		return false
	end

	return var8_0(arg2_11, arg3_11, arg0_11) * var8_0(arg2_11, arg1_11, arg3_11) >= -var1_0, var3_11
end

local function var13_0(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12 = var8_0(arg0_12, arg2_12, arg1_12)

	if var0_12 * var8_0(arg0_12, arg1_12, arg3_12) <= var1_0 then
		return false
	end

	return var8_0(arg2_12, arg3_12, arg0_12) * var8_0(arg2_12, arg1_12, arg3_12) > var1_0, var4_0(var0_12)
end

local function var14_0(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = var9_0(arg1_13, arg0_13, arg2_13, arg3_13) <= var1_0

	return var2_0(var8_0(arg0_13, arg1_13, arg2_13, arg3_13)), var0_13
end

local function var15_0(arg0_14, arg1_14, arg2_14, arg3_14)
	local var0_14, var1_14 = var12_0(arg0_14, arg1_14, arg2_14, arg3_14)

	if not var0_14 then
		return false
	end

	local var2_14 = arg1_14.x - arg0_14.x
	local var3_14 = arg1_14.y - arg0_14.y
	local var4_14 = arg3_14.x - arg2_14.x
	local var5_14 = arg3_14.y - arg2_14.y
	local var6_14 = var2_14 * var5_14 - var3_14 * var4_14

	if var2_0(var6_14) then
		return false
	end

	local var7_14 = arg0_14.x * arg1_14.y - arg0_14.y * arg1_14.x
	local var8_14 = arg2_14.x * arg3_14.y - arg2_14.y * arg3_14.x
	local var9_14 = (-var4_14 * var7_14 - -var2_14 * var8_14) / var6_14
	local var10_14 = (-var5_14 * var7_14 - -var3_14 * var8_14) / var6_14

	return true, Vector2(var9_14, var10_14)
end

var0_0.IsZero = var2_0
var0_0.DistinguishZero = var3_0
var0_0.Sign = var4_0
var0_0.GetRect = var5_0
var0_0.VectorCross = var8_0
var0_0.VectorDot = var9_0
var0_0.IsRectCross = var10_0
var0_0.GetCrossPoint = var15_0
var0_0.IntersectLineandSegament = var11_0
var0_0.IsSegamentTouch = var12_0
var0_0.IsSegamentCross = var13_0
var0_0.IsSegamentParallel = var14_0

return var0_0
