local var0_0 = tonumber
local var1_0 = type
local var2_0 = print
local var3_0 = error
local var4_0 = setmetatable
local var5_0 = require("lpeg")
local var6_0 = var5_0
local var7_0 = getmetatable(var6_0.P(0))
local var8_0 = _VERSION

if var8_0 == "Lua 5.2" then
	_ENV = nil
end

local var9_0 = var5_0.P(1)
local var10_0 = {
	nl = var5_0.P("\n")
}
local var11_0
local var12_0
local var13_0

local function var14_0()
	var6_0.locale(var10_0)

	var10_0.a = var10_0.alpha
	var10_0.c = var10_0.cntrl
	var10_0.d = var10_0.digit
	var10_0.g = var10_0.graph
	var10_0.l = var10_0.lower
	var10_0.p = var10_0.punct
	var10_0.s = var10_0.space
	var10_0.u = var10_0.upper
	var10_0.w = var10_0.alnum
	var10_0.x = var10_0.xdigit
	var10_0.A = var9_0 - var10_0.a
	var10_0.C = var9_0 - var10_0.c
	var10_0.D = var9_0 - var10_0.d
	var10_0.G = var9_0 - var10_0.g
	var10_0.L = var9_0 - var10_0.l
	var10_0.P = var9_0 - var10_0.p
	var10_0.S = var9_0 - var10_0.s
	var10_0.U = var9_0 - var10_0.u
	var10_0.W = var9_0 - var10_0.w
	var10_0.X = var9_0 - var10_0.x
	var11_0 = {}
	var12_0 = {}
	var13_0 = {}

	local var0_1 = {
		__mode = "v"
	}

	var4_0(var11_0, var0_1)
	var4_0(var12_0, var0_1)
	var4_0(var13_0, var0_1)
end

var14_0()

local var15_0 = var5_0.P(function(arg0_2, arg1_2)
	var2_0(arg1_2, arg0_2:sub(1, arg1_2 - 1))

	return arg1_2
end)

local function var16_0(arg0_3, arg1_3)
	local var0_3 = arg1_3 and arg1_3[arg0_3]

	if not var0_3 then
		var3_0("undefined name: " .. arg0_3)
	end

	return var0_3
end

local function var17_0(arg0_4, arg1_4)
	local var0_4 = #arg0_4 < arg1_4 + 20 and arg0_4:sub(arg1_4) or arg0_4:sub(arg1_4, arg1_4 + 20) .. "..."
	local var1_4 = ("pattern error near '%s'"):format(var0_4)

	var3_0(var1_4, 2)
end

local function var18_0(arg0_5, arg1_5)
	local var0_5 = var6_0.P(true)

	while arg1_5 >= 1 do
		if arg1_5 % 2 >= 1 then
			var0_5 = var0_5 * arg0_5
		end

		arg0_5 = arg0_5 * arg0_5
		arg1_5 = arg1_5 / 2
	end

	return var0_5
end

local function var19_0(arg0_6, arg1_6, arg2_6)
	if var1_0(arg2_6) ~= "string" then
		return nil
	end

	local var0_6 = #arg2_6 + arg1_6

	if arg0_6:sub(arg1_6, var0_6 - 1) == arg2_6 then
		return var0_6
	else
		return nil
	end
end

local var20_0 = (var10_0.space + "--" * (var9_0 - var10_0.nl)^0)^0
local var21_0 = var5_0.R("AZ", "az", "__") * var5_0.R("AZ", "az", "__", "09")^0
local var22_0 = var20_0 * "<-"
local var23_0 = var5_0.P("/") + ")" + "}" + ":}" + "~}" + "|}" + var21_0 * var22_0 + -1
local var24_0 = var5_0.C(var21_0)
local var25_0 = var24_0 * var5_0.Carg(1)
local var26_0 = var5_0.C(var5_0.R("09")^1) * var20_0 / var0_0
local var27_0 = "'" * var5_0.C((var9_0 - "'")^0) * "'" + "\"" * var5_0.C((var9_0 - "\"")^0) * "\""
local var28_0 = "%" * var25_0 / function(arg0_7, arg1_7)
	local var0_7 = arg1_7 and arg1_7[arg0_7] or var10_0[arg0_7]

	if not var0_7 then
		var3_0("name '" .. arg0_7 .. "' undefined")
	end

	return var0_7
end
local var29_0 = var28_0 + var5_0.Cs(var9_0 * (var5_0.P("-") / "") * (var9_0 - "]")) / var6_0.R + var5_0.C(var9_0)
local var30_0 = "[" * var5_0.C(var5_0.P("^")^-1) * var5_0.Cf(var29_0 * (var29_0 - "]")^0, var7_0.__add) / function(arg0_8, arg1_8)
	return arg0_8 == "^" and var9_0 - arg1_8 or arg1_8
end * "]"

local function var31_0(arg0_9, arg1_9, arg2_9)
	if arg0_9[arg1_9] then
		var3_0("'" .. arg1_9 .. "' already defined as a rule")
	else
		arg0_9[arg1_9] = arg2_9
	end

	return arg0_9
end

local function var32_0(arg0_10, arg1_10)
	return var31_0({
		arg0_10
	}, arg0_10, arg1_10)
end

local function var33_0(arg0_11, arg1_11)
	if not arg1_11 then
		var3_0("rule '" .. arg0_11 .. "' used outside a grammar")
	else
		return var6_0.V(arg0_11)
	end
end

local var34_0 = var5_0.P({
	"Exp",
	Exp = var20_0 * (var5_0.V("Grammar") + var5_0.Cf(var5_0.V("Seq") * ("/" * var20_0 * var5_0.V("Seq"))^0, var7_0.__add)),
	Seq = var5_0.Cf(var5_0.Cc(var5_0.P("")) * var5_0.V("Prefix")^0, var7_0.__mul) * (#var23_0 + var17_0),
	Prefix = "&" * var20_0 * var5_0.V("Prefix") / var7_0.__len + "!" * var20_0 * var5_0.V("Prefix") / var7_0.__unm + var5_0.V("Suffix"),
	Suffix = var5_0.Cf(var5_0.V("Primary") * var20_0 * ((var5_0.P("+") * var5_0.Cc(1, var7_0.__pow) + var5_0.P("*") * var5_0.Cc(0, var7_0.__pow) + var5_0.P("?") * var5_0.Cc(-1, var7_0.__pow) + "^" * (var5_0.Cg(var26_0 * var5_0.Cc(var18_0)) + var5_0.Cg(var5_0.C(var5_0.S("+-") * var5_0.R("09")^1) * var5_0.Cc(var7_0.__pow))) + "->" * var20_0 * (var5_0.Cg((var27_0 + var26_0) * var5_0.Cc(var7_0.__div)) + var5_0.P("{}") * var5_0.Cc(nil, var5_0.Ct) + var5_0.Cg(var25_0 / var16_0 * var5_0.Cc(var7_0.__div))) + "=>" * var20_0 * var5_0.Cg(var25_0 / var16_0 * var5_0.Cc(var5_0.Cmt))) * var20_0)^0, function(arg0_12, arg1_12, arg2_12)
		return arg2_12(arg0_12, arg1_12)
	end),
	Primary = "(" * var5_0.V("Exp") * ")" + var27_0 / var6_0.P + var30_0 + var28_0 + "{:" * (var24_0 * ":" + var5_0.Cc(nil)) * var5_0.V("Exp") * ":}" / function(arg0_13, arg1_13)
		return var6_0.Cg(arg1_13, arg0_13)
	end + "=" * var24_0 / function(arg0_14)
		return var6_0.Cmt(var6_0.Cb(arg0_14), var19_0)
	end + var5_0.P("{}") / var6_0.Cp + "{~" * var5_0.V("Exp") * "~}" / var6_0.Cs + "{|" * var5_0.V("Exp") * "|}" / var6_0.Ct + "{" * var5_0.V("Exp") * "}" / var6_0.C + var5_0.P(".") * var5_0.Cc(var9_0) + (var24_0 * -var22_0 + "<" * var24_0 * ">") * var5_0.Cb("G") / var33_0,
	Definition = var24_0 * var22_0 * var5_0.V("Exp"),
	Grammar = var5_0.Cg(var5_0.Cc(true), "G") * var5_0.Cf(var5_0.V("Definition") / var32_0 * var5_0.Cg(var5_0.V("Definition"))^0, var31_0) / var6_0.P
})
local var35_0 = var20_0 * var5_0.Cg(var5_0.Cc(false), "G") * var34_0 / var6_0.P * (-var9_0 + var17_0)

local function var36_0(arg0_15, arg1_15)
	if var6_0.type(arg0_15) == "pattern" then
		return arg0_15
	end

	local var0_15 = var35_0:match(arg0_15, 1, arg1_15)

	if not var0_15 then
		var3_0("incorrect pattern", 3)
	end

	return var0_15
end

local function var37_0(arg0_16, arg1_16, arg2_16)
	local var0_16 = var11_0[arg1_16]

	if not var0_16 then
		var0_16 = var36_0(arg1_16)
		var11_0[arg1_16] = var0_16
	end

	return var0_16:match(arg0_16, arg2_16 or 1)
end

local function var38_0(arg0_17, arg1_17, arg2_17)
	local var0_17 = var12_0[arg1_17]

	if not var0_17 then
		var0_17 = var36_0(arg1_17) / 0
		var0_17 = var6_0.P({
			var6_0.Cp() * var0_17 * var6_0.Cp() + 1 * var6_0.V(1)
		})
		var12_0[arg1_17] = var0_17
	end

	local var1_17, var2_17 = var0_17:match(arg0_17, arg2_17 or 1)

	if var1_17 then
		return var1_17, var2_17 - 1
	else
		return var1_17
	end
end

local function var39_0(arg0_18, arg1_18, arg2_18)
	local var0_18 = var13_0[arg1_18] or {}

	var13_0[arg1_18] = var0_18

	local var1_18 = var0_18[arg2_18]

	if not var1_18 then
		var1_18 = var36_0(arg1_18)
		var1_18 = var6_0.Cs((var1_18 / arg2_18 + 1)^0)
		var0_18[arg2_18] = var1_18
	end

	return var1_18:match(arg0_18)
end

local var40_0 = {
	compile = var36_0,
	match = var37_0,
	find = var38_0,
	gsub = var39_0,
	updatelocale = var14_0
}

if var8_0 == "Lua 5.1" then
	-- block empty
end

return var40_0
