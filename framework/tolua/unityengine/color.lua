local var0 = rawget
local var1 = setmetatable
local var2 = type
local var3 = Mathf
local var4 = {}
local var5 = tolua.initget(var4)

function var4.__index(arg0, arg1)
	local var0 = var0(var4, arg1)

	if var0 == nil then
		var0 = var0(var5, arg1)

		if var0 ~= nil then
			return var0(arg0)
		end
	end

	return var0
end

function var4.__call(arg0, arg1, arg2, arg3, arg4)
	return var1({
		r = arg1 or 0,
		g = arg2 or 0,
		b = arg3 or 0,
		a = arg4 or 1
	}, var4)
end

function var4.New(arg0, arg1, arg2, arg3)
	return var1({
		r = arg0 or 0,
		g = arg1 or 0,
		b = arg2 or 0,
		a = arg3 or 1
	}, var4)
end

function var4.Set(arg0, arg1, arg2, arg3, arg4)
	arg0.r = arg1
	arg0.g = arg2
	arg0.b = arg3
	arg0.a = arg4 or 1
end

function var4.Get(arg0)
	return arg0.r, arg0.g, arg0.b, arg0.a
end

function var4.Equals(arg0, arg1)
	return arg0.r == arg1.r and arg0.g == arg1.g and arg0.b == arg1.b and arg0.a == arg1.a
end

function var4.Lerp(arg0, arg1, arg2)
	arg2 = var3.Clamp01(arg2)

	return var4.New(arg0.r + arg2 * (arg1.r - arg0.r), arg0.g + arg2 * (arg1.g - arg0.g), arg0.b + arg2 * (arg1.b - arg0.b), arg0.a + arg2 * (arg1.a - arg0.a))
end

function var4.LerpUnclamped(arg0, arg1, arg2)
	return var4.New(arg0.r + arg2 * (arg1.r - arg0.r), arg0.g + arg2 * (arg1.g - arg0.g), arg0.b + arg2 * (arg1.b - arg0.b), arg0.a + arg2 * (arg1.a - arg0.a))
end

function var4.HSVToRGB(arg0, arg1, arg2, arg3)
	if arg3 then
		-- block empty
	end

	arg3 = true

	local var0 = var4.New(1, 1, 1, 1)

	if arg1 == 0 then
		var0.r = arg2
		var0.g = arg2
		var0.b = arg2

		return var0
	end

	if arg2 == 0 then
		var0.r = 0
		var0.g = 0
		var0.b = 0

		return var0
	end

	var0.r = 0
	var0.g = 0
	var0.b = 0

	local var1 = arg1
	local var2 = arg2
	local var3 = arg0 * 6
	local var4 = var3.Floor(var3)
	local var5 = var3 - var4
	local var6 = var2 * (1 - var1)
	local var7 = var2 * (1 - var1 * var5)
	local var8 = var2 * (1 - var1 * (1 - var5))
	local var9 = var4 + 1

	if var9 == 0 then
		var0.r = var2
		var0.g = var6
		var0.b = var7
	elseif var9 == 1 then
		var0.r = var2
		var0.g = var8
		var0.b = var6
	elseif var9 == 2 then
		var0.r = var7
		var0.g = var2
		var0.b = var6
	elseif var9 == 3 then
		var0.r = var6
		var0.g = var2
		var0.b = var8
	elseif var9 == 4 then
		var0.r = var6
		var0.g = var7
		var0.b = var2
	elseif var9 == 5 then
		var0.r = var8
		var0.g = var6
		var0.b = var2
	elseif var9 == 6 then
		var0.r = var2
		var0.g = var6
		var0.b = var7
	elseif var9 == 7 then
		var0.r = var2
		var0.g = var8
		var0.b = var6
	end

	if not arg3 then
		var0.r = var3.Clamp(var0.r, 0, 1)
		var0.g = var3.Clamp(var0.g, 0, 1)
		var0.b = var3.Clamp(var0.b, 0, 1)
	end

	return var0
end

local function var6(arg0, arg1, arg2, arg3)
	local var0 = arg1

	if var0 ~= 0 then
		local var1 = 0

		if arg3 < arg2 then
			var1 = arg3
		else
			var1 = arg2
		end

		local var2 = var0 - var1
		local var3 = 0
		local var4 = 0

		if var2 ~= 0 then
			var4 = var2 / var0
			var3 = arg0 + (arg2 - arg3) / var2
		else
			var4 = 0
			var3 = arg0 + (arg2 - arg3)
		end

		local var5 = var3 / 6

		if var5 < 0 then
			var5 = var5 + 1
		end

		return var5, var4, var0
	end

	return 0, 0, var0
end

function var4.RGBToHSV(arg0)
	if arg0.b > arg0.g and arg0.b > arg0.r then
		return var6(4, arg0.b, arg0.r, arg0.g)
	elseif arg0.g > arg0.r then
		return var6(2, arg0.g, arg0.b, arg0.r)
	else
		return var6(0, arg0.r, arg0.g, arg0.b)
	end
end

function var4.GrayScale(arg0)
	return 0.299 * arg0.r + 0.587 * arg0.g + 0.114 * arg0.b
end

function var4.NewHex(arg0)
	if string.sub(arg0, 1, 1) == "#" then
		arg0 = string.sub(arg0, 2)
	end

	arg0 = string.upper(arg0)

	local var0 = {}

	for iter0 = 1, 4 do
		if iter0 + iter0 > #arg0 then
			var0[iter0] = 1
		else
			var0[iter0] = tonumber(string.sub(arg0, iter0 + iter0 - 1, iter0 + iter0), 16) / 255
		end
	end

	return var4.New(unpack(var0))
end

function var4.ToHex(arg0, arg1)
	return arg1 and string.format("%.2X%.2X%.2X%.2X", arg0.r * 255, arg0.g * 255, arg0.b * 255, arg0.a * 255) or string.format("%.2X%.2X%.2X", arg0.r * 255, arg0.g * 255, arg0.b * 255)
end

function var4.__tostring(arg0)
	return string.format("RGBA(%f,%f,%f,%f)", arg0.r, arg0.g, arg0.b, arg0.a)
end

function var4.__add(arg0, arg1)
	return var4.New(arg0.r + arg1.r, arg0.g + arg1.g, arg0.b + arg1.b, arg0.a + arg1.a)
end

function var4.__sub(arg0, arg1)
	return var4.New(arg0.r - arg1.r, arg0.g - arg1.g, arg0.b - arg1.b, arg0.a - arg1.a)
end

function var4.__mul(arg0, arg1)
	if var2(arg1) == "number" then
		return var4.New(arg0.r * arg1, arg0.g * arg1, arg0.b * arg1, arg0.a * arg1)
	elseif getmetatable(arg1) == var4 then
		return var4.New(arg0.r * arg1.r, arg0.g * arg1.g, arg0.b * arg1.b, arg0.a * arg1.a)
	end
end

function var4.__div(arg0, arg1)
	return var4.New(arg0.r / arg1, arg0.g / arg1, arg0.b / arg1, arg0.a / arg1)
end

function var4.__eq(arg0, arg1)
	return arg0.r == arg1.r and arg0.g == arg1.g and arg0.b == arg1.b and arg0.a == arg1.a
end

function var5.red()
	return var4.New(1, 0, 0, 1)
end

function var5.green()
	return var4.New(0, 1, 0, 1)
end

function var5.blue()
	return var4.New(0, 0, 1, 1)
end

function var5.white()
	return var4.New(1, 1, 1, 1)
end

function var5.black()
	return var4.New(0, 0, 0, 1)
end

function var5.yellow()
	return var4.New(1, 0.9215686, 0.01568628, 1)
end

function var5.cyan()
	return var4.New(0, 1, 1, 1)
end

function var5.magenta()
	return var4.New(1, 0, 1, 1)
end

function var5.gray()
	return var4.New(0.5, 0.5, 0.5, 1)
end

function var5.clear()
	return var4.New(0, 0, 0, 0)
end

function var5.buttonDisabled()
	return var4.New(0.784313725490196, 0.784313725490196, 0.784313725490196, 0.5)
end

function var5.ReisalinGold()
	return var4.New(1, 0.90196, 0.50196, 1)
end

function var5.gamma(arg0)
	return var4.New(var3.LinearToGammaSpace(arg0.r), var3.LinearToGammaSpace(arg0.g), var3.LinearToGammaSpace(arg0.b), arg0.a)
end

function var5.linear(arg0)
	return var4.New(var3.GammaToLinearSpace(arg0.r), var3.GammaToLinearSpace(arg0.g), var3.GammaToLinearSpace(arg0.b), arg0.a)
end

function var5.maxColorComponent(arg0)
	return var3.Max(var3.Max(arg0.r, arg0.g), arg0.b)
end

var5.grayscale = var4.GrayScale
UnityEngine.Color = var4

var1(var4, var4)

return var4
