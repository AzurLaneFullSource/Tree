local var0_0 = rawget
local var1_0 = setmetatable
local var2_0 = type
local var3_0 = Mathf
local var4_0 = {}
local var5_0 = tolua.initget(var4_0)

function var4_0.__index(arg0_1, arg1_1)
	local var0_1 = var0_0(var4_0, arg1_1)

	if var0_1 == nil then
		var0_1 = var0_0(var5_0, arg1_1)

		if var0_1 ~= nil then
			return var0_1(arg0_1)
		end
	end

	return var0_1
end

function var4_0.__call(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	return var1_0({
		r = arg1_2 or 0,
		g = arg2_2 or 0,
		b = arg3_2 or 0,
		a = arg4_2 or 1
	}, var4_0)
end

function var4_0.New(arg0_3, arg1_3, arg2_3, arg3_3)
	return var1_0({
		r = arg0_3 or 0,
		g = arg1_3 or 0,
		b = arg2_3 or 0,
		a = arg3_3 or 1
	}, var4_0)
end

function var4_0.Set(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
	arg0_4.r = arg1_4
	arg0_4.g = arg2_4
	arg0_4.b = arg3_4
	arg0_4.a = arg4_4 or 1
end

function var4_0.Get(arg0_5)
	return arg0_5.r, arg0_5.g, arg0_5.b, arg0_5.a
end

function var4_0.Equals(arg0_6, arg1_6)
	return arg0_6.r == arg1_6.r and arg0_6.g == arg1_6.g and arg0_6.b == arg1_6.b and arg0_6.a == arg1_6.a
end

function var4_0.Lerp(arg0_7, arg1_7, arg2_7)
	arg2_7 = var3_0.Clamp01(arg2_7)

	return var4_0.New(arg0_7.r + arg2_7 * (arg1_7.r - arg0_7.r), arg0_7.g + arg2_7 * (arg1_7.g - arg0_7.g), arg0_7.b + arg2_7 * (arg1_7.b - arg0_7.b), arg0_7.a + arg2_7 * (arg1_7.a - arg0_7.a))
end

function var4_0.LerpUnclamped(arg0_8, arg1_8, arg2_8)
	return var4_0.New(arg0_8.r + arg2_8 * (arg1_8.r - arg0_8.r), arg0_8.g + arg2_8 * (arg1_8.g - arg0_8.g), arg0_8.b + arg2_8 * (arg1_8.b - arg0_8.b), arg0_8.a + arg2_8 * (arg1_8.a - arg0_8.a))
end

function var4_0.HSVToRGB(arg0_9, arg1_9, arg2_9, arg3_9)
	if arg3_9 then
		-- block empty
	end

	arg3_9 = true

	local var0_9 = var4_0.New(1, 1, 1, 1)

	if arg1_9 == 0 then
		var0_9.r = arg2_9
		var0_9.g = arg2_9
		var0_9.b = arg2_9

		return var0_9
	end

	if arg2_9 == 0 then
		var0_9.r = 0
		var0_9.g = 0
		var0_9.b = 0

		return var0_9
	end

	var0_9.r = 0
	var0_9.g = 0
	var0_9.b = 0

	local var1_9 = arg1_9
	local var2_9 = arg2_9
	local var3_9 = arg0_9 * 6
	local var4_9 = var3_0.Floor(var3_9)
	local var5_9 = var3_9 - var4_9
	local var6_9 = var2_9 * (1 - var1_9)
	local var7_9 = var2_9 * (1 - var1_9 * var5_9)
	local var8_9 = var2_9 * (1 - var1_9 * (1 - var5_9))
	local var9_9 = var4_9 + 1

	if var9_9 == 0 then
		var0_9.r = var2_9
		var0_9.g = var6_9
		var0_9.b = var7_9
	elseif var9_9 == 1 then
		var0_9.r = var2_9
		var0_9.g = var8_9
		var0_9.b = var6_9
	elseif var9_9 == 2 then
		var0_9.r = var7_9
		var0_9.g = var2_9
		var0_9.b = var6_9
	elseif var9_9 == 3 then
		var0_9.r = var6_9
		var0_9.g = var2_9
		var0_9.b = var8_9
	elseif var9_9 == 4 then
		var0_9.r = var6_9
		var0_9.g = var7_9
		var0_9.b = var2_9
	elseif var9_9 == 5 then
		var0_9.r = var8_9
		var0_9.g = var6_9
		var0_9.b = var2_9
	elseif var9_9 == 6 then
		var0_9.r = var2_9
		var0_9.g = var6_9
		var0_9.b = var7_9
	elseif var9_9 == 7 then
		var0_9.r = var2_9
		var0_9.g = var8_9
		var0_9.b = var6_9
	end

	if not arg3_9 then
		var0_9.r = var3_0.Clamp(var0_9.r, 0, 1)
		var0_9.g = var3_0.Clamp(var0_9.g, 0, 1)
		var0_9.b = var3_0.Clamp(var0_9.b, 0, 1)
	end

	return var0_9
end

local function var6_0(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = arg1_10

	if var0_10 ~= 0 then
		local var1_10 = 0

		if arg3_10 < arg2_10 then
			var1_10 = arg3_10
		else
			var1_10 = arg2_10
		end

		local var2_10 = var0_10 - var1_10
		local var3_10 = 0
		local var4_10 = 0

		if var2_10 ~= 0 then
			var4_10 = var2_10 / var0_10
			var3_10 = arg0_10 + (arg2_10 - arg3_10) / var2_10
		else
			var4_10 = 0
			var3_10 = arg0_10 + (arg2_10 - arg3_10)
		end

		local var5_10 = var3_10 / 6

		if var5_10 < 0 then
			var5_10 = var5_10 + 1
		end

		return var5_10, var4_10, var0_10
	end

	return 0, 0, var0_10
end

function var4_0.RGBToHSV(arg0_11)
	if arg0_11.b > arg0_11.g and arg0_11.b > arg0_11.r then
		return var6_0(4, arg0_11.b, arg0_11.r, arg0_11.g)
	elseif arg0_11.g > arg0_11.r then
		return var6_0(2, arg0_11.g, arg0_11.b, arg0_11.r)
	else
		return var6_0(0, arg0_11.r, arg0_11.g, arg0_11.b)
	end
end

function var4_0.GrayScale(arg0_12)
	return 0.299 * arg0_12.r + 0.587 * arg0_12.g + 0.114 * arg0_12.b
end

function var4_0.NewHex(arg0_13)
	if string.sub(arg0_13, 1, 1) == "#" then
		arg0_13 = string.sub(arg0_13, 2)
	end

	arg0_13 = string.upper(arg0_13)

	local var0_13 = {}

	for iter0_13 = 1, 4 do
		if iter0_13 + iter0_13 > #arg0_13 then
			var0_13[iter0_13] = 1
		else
			var0_13[iter0_13] = tonumber(string.sub(arg0_13, iter0_13 + iter0_13 - 1, iter0_13 + iter0_13), 16) / 255
		end
	end

	return var4_0.New(unpack(var0_13))
end

function var4_0.ToHex(arg0_14, arg1_14)
	return arg1_14 and string.format("%.2X%.2X%.2X%.2X", arg0_14.r * 255, arg0_14.g * 255, arg0_14.b * 255, arg0_14.a * 255) or string.format("%.2X%.2X%.2X", arg0_14.r * 255, arg0_14.g * 255, arg0_14.b * 255)
end

function var4_0.__tostring(arg0_15)
	return string.format("RGBA(%f,%f,%f,%f)", arg0_15.r, arg0_15.g, arg0_15.b, arg0_15.a)
end

function var4_0.__add(arg0_16, arg1_16)
	return var4_0.New(arg0_16.r + arg1_16.r, arg0_16.g + arg1_16.g, arg0_16.b + arg1_16.b, arg0_16.a + arg1_16.a)
end

function var4_0.__sub(arg0_17, arg1_17)
	return var4_0.New(arg0_17.r - arg1_17.r, arg0_17.g - arg1_17.g, arg0_17.b - arg1_17.b, arg0_17.a - arg1_17.a)
end

function var4_0.__mul(arg0_18, arg1_18)
	if var2_0(arg1_18) == "number" then
		return var4_0.New(arg0_18.r * arg1_18, arg0_18.g * arg1_18, arg0_18.b * arg1_18, arg0_18.a * arg1_18)
	elseif getmetatable(arg1_18) == var4_0 then
		return var4_0.New(arg0_18.r * arg1_18.r, arg0_18.g * arg1_18.g, arg0_18.b * arg1_18.b, arg0_18.a * arg1_18.a)
	end
end

function var4_0.__div(arg0_19, arg1_19)
	return var4_0.New(arg0_19.r / arg1_19, arg0_19.g / arg1_19, arg0_19.b / arg1_19, arg0_19.a / arg1_19)
end

function var4_0.__eq(arg0_20, arg1_20)
	return arg0_20.r == arg1_20.r and arg0_20.g == arg1_20.g and arg0_20.b == arg1_20.b and arg0_20.a == arg1_20.a
end

function var5_0.red()
	return var4_0.New(1, 0, 0, 1)
end

function var5_0.green()
	return var4_0.New(0, 1, 0, 1)
end

function var5_0.blue()
	return var4_0.New(0, 0, 1, 1)
end

function var5_0.white()
	return var4_0.New(1, 1, 1, 1)
end

function var5_0.black()
	return var4_0.New(0, 0, 0, 1)
end

function var5_0.yellow()
	return var4_0.New(1, 0.9215686, 0.01568628, 1)
end

function var5_0.cyan()
	return var4_0.New(0, 1, 1, 1)
end

function var5_0.magenta()
	return var4_0.New(1, 0, 1, 1)
end

function var5_0.gray()
	return var4_0.New(0.5, 0.5, 0.5, 1)
end

function var5_0.clear()
	return var4_0.New(0, 0, 0, 0)
end

function var5_0.buttonDisabled()
	return var4_0.New(0.784313725490196, 0.784313725490196, 0.784313725490196, 0.5)
end

function var5_0.ReisalinGold()
	return var4_0.New(1, 0.90196, 0.50196, 1)
end

function var5_0.gamma(arg0_33)
	return var4_0.New(var3_0.LinearToGammaSpace(arg0_33.r), var3_0.LinearToGammaSpace(arg0_33.g), var3_0.LinearToGammaSpace(arg0_33.b), arg0_33.a)
end

function var5_0.linear(arg0_34)
	return var4_0.New(var3_0.GammaToLinearSpace(arg0_34.r), var3_0.GammaToLinearSpace(arg0_34.g), var3_0.GammaToLinearSpace(arg0_34.b), arg0_34.a)
end

function var5_0.maxColorComponent(arg0_35)
	return var3_0.Max(var3_0.Max(arg0_35.r, arg0_35.g), arg0_35.b)
end

var5_0.grayscale = var4_0.GrayScale
UnityEngine.Color = var4_0

var1_0(var4_0, var4_0)

return var4_0
