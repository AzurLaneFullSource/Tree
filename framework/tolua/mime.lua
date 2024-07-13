local var0_0 = _G
local var1_0 = require("ltn12")
local var2_0 = require("mime.core")
local var3_0 = require("io")
local var4_0 = require("string")
local var5_0 = var2_0
local var6_0 = {}
local var7_0 = {}
local var8_0 = {}

var5_0.encodet = var6_0
var5_0.decodet = var7_0
var5_0.wrapt = var8_0

local function var9_0(arg0_1)
	return function(arg0_2, arg1_2, arg2_2)
		if var0_0.type(arg0_2) ~= "string" then
			arg0_2, arg1_2, arg2_2 = "default", arg0_2, arg1_2
		end

		local var0_2 = arg0_1[arg0_2 or "nil"]

		if not var0_2 then
			var0_0.error("unknown key (" .. var0_0.tostring(arg0_2) .. ")", 3)
		else
			return var0_2(arg1_2, arg2_2)
		end
	end
end

function var6_0.base64()
	return var1_0.filter.cycle(var5_0.b64, "")
end

var6_0["quoted-printable"] = function(arg0_4)
	return var1_0.filter.cycle(var5_0.qp, "", arg0_4 == "binary" and "=0D=0A" or "\r\n")
end

function var7_0.base64()
	return var1_0.filter.cycle(var5_0.unb64, "")
end

var7_0["quoted-printable"] = function()
	return var1_0.filter.cycle(var5_0.unqp, "")
end

local function var10_0(arg0_7)
	if arg0_7 then
		if arg0_7 == "" then
			return "''"
		else
			return var4_0.len(arg0_7)
		end
	else
		return "nil"
	end
end

function var8_0.text(arg0_8)
	arg0_8 = arg0_8 or 76

	return var1_0.filter.cycle(var5_0.wrp, arg0_8, arg0_8)
end

var8_0.base64 = var8_0.text
var8_0.default = var8_0.text
var8_0["quoted-printable"] = function()
	return var1_0.filter.cycle(var5_0.qpwrp, 76, 76)
end
var5_0.encode = var9_0(var6_0)
var5_0.decode = var9_0(var7_0)
var5_0.wrap = var9_0(var8_0)

function var5_0.normalize(arg0_10)
	return var1_0.filter.cycle(var5_0.eol, 0, arg0_10)
end

function var5_0.stuff()
	return var1_0.filter.cycle(var5_0.dot, 2)
end

return var5_0
