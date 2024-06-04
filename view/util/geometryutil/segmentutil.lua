local var0 = {}
local var1 = 1e-06

local function var2(arg0)
	return arg0 >= -var1 and arg0 <= var1
end

local function var3(arg0)
	if var0.IsZero(arg0) then
		return 0
	else
		return arg0
	end
end

local function var4(arg0)
	if arg0 < -var1 then
		return -1
	elseif arg0 <= var1 then
		return 0
	else
		return 1
	end
end

local function var5(arg0, arg1)
	return Vector2.Min(arg0, arg1), Vector2.Max(arg0, arg1)
end

local function var6(arg0, arg1)
	return arg0.x * arg1.y - arg0.y * arg1.x
end

local function var7(arg0, arg1)
	return arg0.x * arg1.x + arg0.y * arg1.y
end

local function var8(arg0, arg1, arg2, arg3)
	local var0 = arg1 - arg0
	local var1 = arg3 and arg3 - arg2 or arg2 - arg0

	return var3(var6(var0, var1))
end

local function var9(arg0, arg1, arg2, arg3)
	local var0 = arg1 - arg0
	local var1 = arg3 and arg3 - arg2 or arg2 - arg0

	return var3(var7(var0, var1))
end

local function var10(arg0, arg1, arg2, arg3)
	local var0, var1 = var5(arg0, arg1)
	local var2, var3 = var5(arg2, arg3)

	return var0.x <= var3.x and var2.x <= var1.x and var0.y <= var3.y and var2.y <= var1.y
end

local function var11(arg0, arg1, arg2, arg3)
	local var0 = arg1.x - arg0.x

	if var2(var0) then
		return var4(arg2.x - arg0.x) * var4(arg0.x - arg3.x) >= 0
	end

	local var1 = (arg1.y - arg0.y) / var0
	local var2 = arg1.y - var1 * arg1.x

	return var4(var1 * arg2.x + var2 - arg2.y) * var4(var1 * arg3.x + var2 - arg3.y) <= 0
end

local function var12(arg0, arg1, arg2, arg3)
	local var0 = var8(arg0, arg2, arg1)
	local var1 = var8(arg0, arg1, arg3)
	local var2 = var0 * var1
	local var3 = var4(var0) == 0 and var4(var1)

	if var2 < -var1 then
		return false
	end

	return var8(arg2, arg3, arg0) * var8(arg2, arg1, arg3) >= -var1, var3
end

local function var13(arg0, arg1, arg2, arg3)
	local var0 = var8(arg0, arg2, arg1)

	if var0 * var8(arg0, arg1, arg3) <= var1 then
		return false
	end

	return var8(arg2, arg3, arg0) * var8(arg2, arg1, arg3) > var1, var4(var0)
end

local function var14(arg0, arg1, arg2, arg3)
	local var0 = var9(arg1, arg0, arg2, arg3) <= var1

	return var2(var8(arg0, arg1, arg2, arg3)), var0
end

local function var15(arg0, arg1, arg2, arg3)
	local var0, var1 = var12(arg0, arg1, arg2, arg3)

	if not var0 then
		return false
	end

	local var2 = arg1.x - arg0.x
	local var3 = arg1.y - arg0.y
	local var4 = arg3.x - arg2.x
	local var5 = arg3.y - arg2.y
	local var6 = var2 * var5 - var3 * var4

	if var2(var6) then
		return false
	end

	local var7 = arg0.x * arg1.y - arg0.y * arg1.x
	local var8 = arg2.x * arg3.y - arg2.y * arg3.x
	local var9 = (-var4 * var7 - -var2 * var8) / var6
	local var10 = (-var5 * var7 - -var3 * var8) / var6

	return true, Vector2(var9, var10)
end

var0.IsZero = var2
var0.DistinguishZero = var3
var0.Sign = var4
var0.GetRect = var5
var0.VectorCross = var8
var0.VectorDot = var9
var0.IsRectCross = var10
var0.GetCrossPoint = var15
var0.IntersectLineandSegament = var11
var0.IsSegamentTouch = var12
var0.IsSegamentCross = var13
var0.IsSegamentParallel = var14

return var0
