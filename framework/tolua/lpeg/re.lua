local var0 = tonumber
local var1 = type
local var2 = print
local var3 = error
local var4 = setmetatable
local var5 = require("lpeg")
local var6 = var5
local var7 = getmetatable(var6.P(0))
local var8 = _VERSION

if var8 == "Lua 5.2" then
	_ENV = nil
end

local var9 = var5.P(1)
local var10 = {
	nl = var5.P("\n")
}
local var11
local var12
local var13

local function var14()
	var6.locale(var10)

	var10.a = var10.alpha
	var10.c = var10.cntrl
	var10.d = var10.digit
	var10.g = var10.graph
	var10.l = var10.lower
	var10.p = var10.punct
	var10.s = var10.space
	var10.u = var10.upper
	var10.w = var10.alnum
	var10.x = var10.xdigit
	var10.A = var9 - var10.a
	var10.C = var9 - var10.c
	var10.D = var9 - var10.d
	var10.G = var9 - var10.g
	var10.L = var9 - var10.l
	var10.P = var9 - var10.p
	var10.S = var9 - var10.s
	var10.U = var9 - var10.u
	var10.W = var9 - var10.w
	var10.X = var9 - var10.x
	var11 = {}
	var12 = {}
	var13 = {}

	local var0 = {
		__mode = "v"
	}

	var4(var11, var0)
	var4(var12, var0)
	var4(var13, var0)
end

var14()

local var15 = var5.P(function(arg0, arg1)
	var2(arg1, arg0:sub(1, arg1 - 1))

	return arg1
end)

local function var16(arg0, arg1)
	local var0 = arg1 and arg1[arg0]

	if not var0 then
		var3("undefined name: " .. arg0)
	end

	return var0
end

local function var17(arg0, arg1)
	local var0 = #arg0 < arg1 + 20 and arg0:sub(arg1) or arg0:sub(arg1, arg1 + 20) .. "..."
	local var1 = ("pattern error near '%s'"):format(var0)

	var3(var1, 2)
end

local function var18(arg0, arg1)
	local var0 = var6.P(true)

	while arg1 >= 1 do
		if arg1 % 2 >= 1 then
			var0 = var0 * arg0
		end

		arg0 = arg0 * arg0
		arg1 = arg1 / 2
	end

	return var0
end

local function var19(arg0, arg1, arg2)
	if var1(arg2) ~= "string" then
		return nil
	end

	local var0 = #arg2 + arg1

	if arg0:sub(arg1, var0 - 1) == arg2 then
		return var0
	else
		return nil
	end
end

local var20 = (var10.space + "--" * (var9 - var10.nl)^0)^0
local var21 = var5.R("AZ", "az", "__") * var5.R("AZ", "az", "__", "09")^0
local var22 = var20 * "<-"
local var23 = var5.P("/") + ")" + "}" + ":}" + "~}" + "|}" + var21 * var22 + -1
local var24 = var5.C(var21)
local var25 = var24 * var5.Carg(1)
local var26 = var5.C(var5.R("09")^1) * var20 / var0
local var27 = "'" * var5.C((var9 - "'")^0) * "'" + "\"" * var5.C((var9 - "\"")^0) * "\""
local var28 = "%" * var25 / function(arg0, arg1)
	local var0 = arg1 and arg1[arg0] or var10[arg0]

	if not var0 then
		var3("name '" .. arg0 .. "' undefined")
	end

	return var0
end
local var29 = var28 + var5.Cs(var9 * (var5.P("-") / "") * (var9 - "]")) / var6.R + var5.C(var9)
local var30 = "[" * var5.C(var5.P("^")^-1) * var5.Cf(var29 * (var29 - "]")^0, var7.__add) / function(arg0, arg1)
	return arg0 == "^" and var9 - arg1 or arg1
end * "]"

local function var31(arg0, arg1, arg2)
	if arg0[arg1] then
		var3("'" .. arg1 .. "' already defined as a rule")
	else
		arg0[arg1] = arg2
	end

	return arg0
end

local function var32(arg0, arg1)
	return var31({
		arg0
	}, arg0, arg1)
end

local function var33(arg0, arg1)
	if not arg1 then
		var3("rule '" .. arg0 .. "' used outside a grammar")
	else
		return var6.V(arg0)
	end
end

local var34 = var5.P({
	"Exp",
	Exp = var20 * (var5.V("Grammar") + var5.Cf(var5.V("Seq") * ("/" * var20 * var5.V("Seq"))^0, var7.__add)),
	Seq = var5.Cf(var5.Cc(var5.P("")) * var5.V("Prefix")^0, var7.__mul) * (#var23 + var17),
	Prefix = "&" * var20 * var5.V("Prefix") / var7.__len + "!" * var20 * var5.V("Prefix") / var7.__unm + var5.V("Suffix"),
	Suffix = var5.Cf(var5.V("Primary") * var20 * ((var5.P("+") * var5.Cc(1, var7.__pow) + var5.P("*") * var5.Cc(0, var7.__pow) + var5.P("?") * var5.Cc(-1, var7.__pow) + "^" * (var5.Cg(var26 * var5.Cc(var18)) + var5.Cg(var5.C(var5.S("+-") * var5.R("09")^1) * var5.Cc(var7.__pow))) + "->" * var20 * (var5.Cg((var27 + var26) * var5.Cc(var7.__div)) + var5.P("{}") * var5.Cc(nil, var5.Ct) + var5.Cg(var25 / var16 * var5.Cc(var7.__div))) + "=>" * var20 * var5.Cg(var25 / var16 * var5.Cc(var5.Cmt))) * var20)^0, function(arg0, arg1, arg2)
		return arg2(arg0, arg1)
	end),
	Primary = "(" * var5.V("Exp") * ")" + var27 / var6.P + var30 + var28 + "{:" * (var24 * ":" + var5.Cc(nil)) * var5.V("Exp") * ":}" / function(arg0, arg1)
		return var6.Cg(arg1, arg0)
	end + "=" * var24 / function(arg0)
		return var6.Cmt(var6.Cb(arg0), var19)
	end + var5.P("{}") / var6.Cp + "{~" * var5.V("Exp") * "~}" / var6.Cs + "{|" * var5.V("Exp") * "|}" / var6.Ct + "{" * var5.V("Exp") * "}" / var6.C + var5.P(".") * var5.Cc(var9) + (var24 * -var22 + "<" * var24 * ">") * var5.Cb("G") / var33,
	Definition = var24 * var22 * var5.V("Exp"),
	Grammar = var5.Cg(var5.Cc(true), "G") * var5.Cf(var5.V("Definition") / var32 * var5.Cg(var5.V("Definition"))^0, var31) / var6.P
})
local var35 = var20 * var5.Cg(var5.Cc(false), "G") * var34 / var6.P * (-var9 + var17)

local function var36(arg0, arg1)
	if var6.type(arg0) == "pattern" then
		return arg0
	end

	local var0 = var35:match(arg0, 1, arg1)

	if not var0 then
		var3("incorrect pattern", 3)
	end

	return var0
end

local function var37(arg0, arg1, arg2)
	local var0 = var11[arg1]

	if not var0 then
		var0 = var36(arg1)
		var11[arg1] = var0
	end

	return var0:match(arg0, arg2 or 1)
end

local function var38(arg0, arg1, arg2)
	local var0 = var12[arg1]

	if not var0 then
		var0 = var36(arg1) / 0
		var0 = var6.P({
			var6.Cp() * var0 * var6.Cp() + 1 * var6.V(1)
		})
		var12[arg1] = var0
	end

	local var1, var2 = var0:match(arg0, arg2 or 1)

	if var1 then
		return var1, var2 - 1
	else
		return var1
	end
end

local function var39(arg0, arg1, arg2)
	local var0 = var13[arg1] or {}

	var13[arg1] = var0

	local var1 = var0[arg2]

	if not var1 then
		var1 = var36(arg1)
		var1 = var6.Cs((var1 / arg2 + 1)^0)
		var0[arg2] = var1
	end

	return var1:match(arg0)
end

local var40 = {
	compile = var36,
	match = var37,
	find = var38,
	gsub = var39,
	updatelocale = var14
}

if var8 == "Lua 5.1" then
	-- block empty
end

return var40
