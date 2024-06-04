function uuid()
	local var0 = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"

	return string.gsub(var0, "[xy]", function(arg0)
		local var0 = arg0 == "x" and math.random(0, 15) or math.random(8, 11)

		return string.format("%x", var0)
	end)
end

function map(arg0, arg1, arg2, arg3, arg4)
	return (arg0 - arg1) / (arg2 - arg1) * (arg4 - arg3) + arg3
end

function shuffle(arg0)
	for iter0 = #arg0, 2, -1 do
		local var0 = math.random(iter0)

		arg0[var0], arg0[iter0] = arg0[iter0], arg0[var0]
	end
end

local var0 = math.floor
local var1 = math.abs

function math.round(arg0)
	return var0(arg0 + 0.5)
end

function math.sign(arg0)
	arg0 = arg0 > 0 and 1 or arg0 < 0 and -1 or 0

	return arg0
end

function math.clamp(arg0, arg1, arg2)
	if arg0 < arg1 then
		arg0 = arg1
	elseif arg2 < arg0 then
		arg0 = arg2
	end

	return arg0
end

local var2 = math.clamp

function math.lerp(arg0, arg1, arg2)
	return arg0 + (arg1 - arg0) * var2(arg2, 0, 1)
end

function math.Repeat(arg0, arg1)
	return arg0 - var0(arg0 / arg1) * arg1
end

function math.LerpAngle(arg0, arg1, arg2)
	local var0 = math.Repeat(arg1 - arg0, 360)

	if var0 > 180 then
		var0 = var0 - 360
	end

	return arg0 + var0 * var2(arg2, 0, 1)
end

function math.MoveTowards(arg0, arg1, arg2)
	if arg2 >= var1(arg1 - arg0) then
		return arg1
	end

	return arg0 + math.sign(arg1 - arg0) * arg2
end

function math.DeltaAngle(arg0, arg1)
	local var0 = math.Repeat(arg1 - arg0, 360)

	if var0 > 180 then
		var0 = var0 - 360
	end

	return var0
end

function math.MoveTowardsAngle(arg0, arg1, arg2)
	arg1 = arg0 + math.DeltaAngle(arg0, arg1)

	return math.MoveTowards(arg0, arg1, arg2)
end

function math.Approximately(arg0, arg1)
	return var1(arg1 - arg0) < math.max(1e-06 * math.max(var1(arg0), var1(arg1)), 1.121039e-44)
end

function math.InverseLerp(arg0, arg1, arg2)
	if arg0 < arg1 then
		if arg2 < arg0 then
			return 0
		end

		if arg1 < arg2 then
			return 1
		end

		arg2 = arg2 - arg0
		arg2 = arg2 / (arg1 - arg0)

		return arg2
	end

	if arg0 <= arg1 then
		return 0
	end

	if arg2 < arg1 then
		return 1
	end

	if arg0 < arg2 then
		return 0
	end

	return 1 - (arg2 - arg1) / (arg0 - arg1)
end

function math.PingPong(arg0, arg1)
	arg0 = math.Repeat(arg0, arg1 * 2)

	return arg1 - var1(arg0 - arg1)
end

math.deg2Rad = math.pi / 180
math.rad2Deg = 180 / math.pi
math.epsilon = 1.401298e-45

function math.Random(arg0, arg1)
	local var0 = arg1 - arg0

	return math.random() * var0 + arg0
end

function math.isnan(arg0)
	return arg0 ~= arg0
end

local var3 = math.pi
local var4 = 2 * math.pi
local var5 = math.pi / 2

function math.sin16(arg0)
	local var0

	if arg0 < 0 or arg0 >= var4 then
		arg0 = arg0 - var0(arg0 / var4) * var4
	end

	if arg0 < var3 then
		if arg0 > var5 then
			arg0 = var3 - arg0
		end
	elseif arg0 > var3 + var5 then
		arg0 = arg0 - var4
	else
		arg0 = var3 - arg0
	end

	local var1 = arg0 * arg0

	return arg0 * (((((-2.39e-08 * var1 + 2.7526e-06) * var1 - 0.000198409) * var1 + 0.0083333315) * var1 - 0.1666666664) * var1 + 1)
end

function math.atan16(arg0)
	local var0

	if var1(arg0) > 1 then
		arg0 = 1 / arg0

		local var1 = arg0 * arg0
		local var2 = -((((((((0.0028662257 * var1 - 0.0161657367) * var1 + 0.0429096138) * var1 - 0.07528964) * var1 + 0.1065626393) * var1 - 0.1420889944) * var1 + 0.1999355085) * var1 - 0.3333314528) * var1 + 1) * arg0

		if FLOATSIGNBITSET(arg0) then
			return var2 - var5
		else
			return var2 + var5
		end
	else
		local var3 = arg0 * arg0

		return ((((((((0.0028662257 * var3 - 0.0161657367) * var3 + 0.0429096138) * var3 - 0.07528964) * var3 + 0.1065626393) * var3 - 0.1420889944) * var3 + 0.1999355085) * var3 - 0.3333314528) * var3 + 1) * arg0
	end
end

function getExpPercent(arg0, arg1, arg2)
	return (arg0 - arg1) / (arg2 - arg1) / 100
end

function intProperties(arg0)
	for iter0, iter1 in pairs(arg0) do
		arg0[iter0] = calcFloor(iter1)
	end

	return arg0
end

function defaultValue(arg0, arg1)
	if arg0 == nil then
		return arg1
	else
		return arg0
	end
end

function calcFloor(arg0)
	return math.floor(arg0 + 1e-09)
end

function getCompareFuncByPunctuation(arg0)
	local var0 = math.compareFuncList or {
		["="] = function(arg0, arg1)
			return arg0 == arg1
		end,
		["=="] = function(arg0, arg1)
			return arg0 == arg1
		end,
		[">="] = function(arg0, arg1)
			return arg1 <= arg0
		end,
		["<="] = function(arg0, arg1)
			return arg0 <= arg1
		end,
		[">"] = function(arg0, arg1)
			return arg1 < arg0
		end,
		["<"] = function(arg0, arg1)
			return arg0 < arg1
		end,
		["!="] = function(arg0, arg1)
			return arg0 ~= arg1
		end,
		["~="] = function(arg0, arg1)
			return arg0 ~= arg1
		end
	}

	math.compareFuncList = var0

	return var0[arg0]
end

function getArithmeticFuncByOperator(arg0)
	local var0 = math.arithmeticFuncList or {
		["+"] = function(arg0, arg1)
			return arg0 + arg1
		end,
		["-"] = function(arg0, arg1)
			return arg0 - arg1
		end,
		["*"] = function(arg0, arg1)
			return arg0 * arg1
		end,
		["/"] = function(arg0, arg1)
			return arg0 / arg1
		end
	}

	math.arithmeticFuncList = var0

	return var0[arg0]
end
