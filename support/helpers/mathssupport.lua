function uuid()
	local var0_1 = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"

	return string.gsub(var0_1, "[xy]", function(arg0_2)
		local var0_2 = arg0_2 == "x" and math.random(0, 15) or math.random(8, 11)

		return string.format("%x", var0_2)
	end)
end

function map(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	return (arg0_3 - arg1_3) / (arg2_3 - arg1_3) * (arg4_3 - arg3_3) + arg3_3
end

function shuffle(arg0_4)
	for iter0_4 = #arg0_4, 2, -1 do
		local var0_4 = math.random(iter0_4)

		arg0_4[var0_4], arg0_4[iter0_4] = arg0_4[iter0_4], arg0_4[var0_4]
	end
end

local var0_0 = math.floor
local var1_0 = math.abs

function math.round(arg0_5)
	return var0_0(arg0_5 + 0.5)
end

function math.sign(arg0_6)
	arg0_6 = arg0_6 > 0 and 1 or arg0_6 < 0 and -1 or 0

	return arg0_6
end

function math.clamp(arg0_7, arg1_7, arg2_7)
	if arg0_7 < arg1_7 then
		arg0_7 = arg1_7
	elseif arg2_7 < arg0_7 then
		arg0_7 = arg2_7
	end

	return arg0_7
end

local var2_0 = math.clamp

function math.lerp(arg0_8, arg1_8, arg2_8)
	return arg0_8 + (arg1_8 - arg0_8) * var2_0(arg2_8, 0, 1)
end

function math.Repeat(arg0_9, arg1_9)
	return arg0_9 - var0_0(arg0_9 / arg1_9) * arg1_9
end

function math.LerpAngle(arg0_10, arg1_10, arg2_10)
	local var0_10 = math.Repeat(arg1_10 - arg0_10, 360)

	if var0_10 > 180 then
		var0_10 = var0_10 - 360
	end

	return arg0_10 + var0_10 * var2_0(arg2_10, 0, 1)
end

function math.MoveTowards(arg0_11, arg1_11, arg2_11)
	if arg2_11 >= var1_0(arg1_11 - arg0_11) then
		return arg1_11
	end

	return arg0_11 + math.sign(arg1_11 - arg0_11) * arg2_11
end

function math.DeltaAngle(arg0_12, arg1_12)
	local var0_12 = math.Repeat(arg1_12 - arg0_12, 360)

	if var0_12 > 180 then
		var0_12 = var0_12 - 360
	end

	return var0_12
end

function math.MoveTowardsAngle(arg0_13, arg1_13, arg2_13)
	arg1_13 = arg0_13 + math.DeltaAngle(arg0_13, arg1_13)

	return math.MoveTowards(arg0_13, arg1_13, arg2_13)
end

function math.Approximately(arg0_14, arg1_14)
	return var1_0(arg1_14 - arg0_14) < math.max(1e-06 * math.max(var1_0(arg0_14), var1_0(arg1_14)), 1.121039e-44)
end

function math.InverseLerp(arg0_15, arg1_15, arg2_15)
	if arg0_15 < arg1_15 then
		if arg2_15 < arg0_15 then
			return 0
		end

		if arg1_15 < arg2_15 then
			return 1
		end

		arg2_15 = arg2_15 - arg0_15
		arg2_15 = arg2_15 / (arg1_15 - arg0_15)

		return arg2_15
	end

	if arg0_15 <= arg1_15 then
		return 0
	end

	if arg2_15 < arg1_15 then
		return 1
	end

	if arg0_15 < arg2_15 then
		return 0
	end

	return 1 - (arg2_15 - arg1_15) / (arg0_15 - arg1_15)
end

function math.PingPong(arg0_16, arg1_16)
	arg0_16 = math.Repeat(arg0_16, arg1_16 * 2)

	return arg1_16 - var1_0(arg0_16 - arg1_16)
end

math.deg2Rad = math.pi / 180
math.rad2Deg = 180 / math.pi
math.epsilon = 1.401298e-45

function math.Random(arg0_17, arg1_17)
	local var0_17 = arg1_17 - arg0_17

	return math.random() * var0_17 + arg0_17
end

function math.isnan(arg0_18)
	return arg0_18 ~= arg0_18
end

local var3_0 = math.pi
local var4_0 = 2 * math.pi
local var5_0 = math.pi / 2

function math.sin16(arg0_19)
	local var0_19

	if arg0_19 < 0 or arg0_19 >= var4_0 then
		arg0_19 = arg0_19 - var0_0(arg0_19 / var4_0) * var4_0
	end

	if arg0_19 < var3_0 then
		if arg0_19 > var5_0 then
			arg0_19 = var3_0 - arg0_19
		end
	elseif arg0_19 > var3_0 + var5_0 then
		arg0_19 = arg0_19 - var4_0
	else
		arg0_19 = var3_0 - arg0_19
	end

	local var1_19 = arg0_19 * arg0_19

	return arg0_19 * (((((-2.39e-08 * var1_19 + 2.7526e-06) * var1_19 - 0.000198409) * var1_19 + 0.0083333315) * var1_19 - 0.1666666664) * var1_19 + 1)
end

function math.atan16(arg0_20)
	local var0_20

	if var1_0(arg0_20) > 1 then
		arg0_20 = 1 / arg0_20

		local var1_20 = arg0_20 * arg0_20
		local var2_20 = -((((((((0.0028662257 * var1_20 - 0.0161657367) * var1_20 + 0.0429096138) * var1_20 - 0.07528964) * var1_20 + 0.1065626393) * var1_20 - 0.1420889944) * var1_20 + 0.1999355085) * var1_20 - 0.3333314528) * var1_20 + 1) * arg0_20

		if FLOATSIGNBITSET(arg0_20) then
			return var2_20 - var5_0
		else
			return var2_20 + var5_0
		end
	else
		local var3_20 = arg0_20 * arg0_20

		return ((((((((0.0028662257 * var3_20 - 0.0161657367) * var3_20 + 0.0429096138) * var3_20 - 0.07528964) * var3_20 + 0.1065626393) * var3_20 - 0.1420889944) * var3_20 + 0.1999355085) * var3_20 - 0.3333314528) * var3_20 + 1) * arg0_20
	end
end

function getExpPercent(arg0_21, arg1_21, arg2_21)
	return (arg0_21 - arg1_21) / (arg2_21 - arg1_21) / 100
end

function intProperties(arg0_22)
	for iter0_22, iter1_22 in pairs(arg0_22) do
		arg0_22[iter0_22] = calcFloor(iter1_22)
	end

	return arg0_22
end

function defaultValue(arg0_23, arg1_23)
	if arg0_23 == nil then
		return arg1_23
	else
		return arg0_23
	end
end

function calcFloor(arg0_24)
	return math.floor(arg0_24 + 1e-09)
end

function getCompareFuncByPunctuation(arg0_25)
	local var0_25 = math.compareFuncList or {
		["="] = function(arg0_26, arg1_26)
			return arg0_26 == arg1_26
		end,
		["=="] = function(arg0_27, arg1_27)
			return arg0_27 == arg1_27
		end,
		[">="] = function(arg0_28, arg1_28)
			return arg1_28 <= arg0_28
		end,
		["<="] = function(arg0_29, arg1_29)
			return arg0_29 <= arg1_29
		end,
		[">"] = function(arg0_30, arg1_30)
			return arg1_30 < arg0_30
		end,
		["<"] = function(arg0_31, arg1_31)
			return arg0_31 < arg1_31
		end,
		["!="] = function(arg0_32, arg1_32)
			return arg0_32 ~= arg1_32
		end,
		["~="] = function(arg0_33, arg1_33)
			return arg0_33 ~= arg1_33
		end
	}

	math.compareFuncList = var0_25

	return var0_25[arg0_25]
end

function getArithmeticFuncByOperator(arg0_34)
	local var0_34 = math.arithmeticFuncList or {
		["+"] = function(arg0_35, arg1_35)
			return arg0_35 + arg1_35
		end,
		["-"] = function(arg0_36, arg1_36)
			return arg0_36 - arg1_36
		end,
		["*"] = function(arg0_37, arg1_37)
			return arg0_37 * arg1_37
		end,
		["/"] = function(arg0_38, arg1_38)
			return arg0_38 / arg1_38
		end
	}

	math.arithmeticFuncList = var0_34

	return var0_34[arg0_34]
end
