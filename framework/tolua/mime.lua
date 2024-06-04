local var0 = _G
local var1 = require("ltn12")
local var2 = require("mime.core")
local var3 = require("io")
local var4 = require("string")
local var5 = var2
local var6 = {}
local var7 = {}
local var8 = {}

var5.encodet = var6
var5.decodet = var7
var5.wrapt = var8

local function var9(arg0)
	return function(arg0, arg1, arg2)
		if var0.type(arg0) ~= "string" then
			arg0, arg1, arg2 = "default", arg0, arg1
		end

		local var0 = arg0[arg0 or "nil"]

		if not var0 then
			var0.error("unknown key (" .. var0.tostring(arg0) .. ")", 3)
		else
			return var0(arg1, arg2)
		end
	end
end

function var6.base64()
	return var1.filter.cycle(var5.b64, "")
end

var6["quoted-printable"] = function(arg0)
	return var1.filter.cycle(var5.qp, "", arg0 == "binary" and "=0D=0A" or "\r\n")
end

function var7.base64()
	return var1.filter.cycle(var5.unb64, "")
end

var7["quoted-printable"] = function()
	return var1.filter.cycle(var5.unqp, "")
end

local function var10(arg0)
	if arg0 then
		if arg0 == "" then
			return "''"
		else
			return var4.len(arg0)
		end
	else
		return "nil"
	end
end

function var8.text(arg0)
	arg0 = arg0 or 76

	return var1.filter.cycle(var5.wrp, arg0, arg0)
end

var8.base64 = var8.text
var8.default = var8.text
var8["quoted-printable"] = function()
	return var1.filter.cycle(var5.qpwrp, 76, 76)
end
var5.encode = var9(var6)
var5.decode = var9(var7)
var5.wrap = var9(var8)

function var5.normalize(arg0)
	return var1.filter.cycle(var5.eol, 0, arg0)
end

function var5.stuff()
	return var1.filter.cycle(var5.dot, 2)
end

return var5
