local var0_0 = _G
local var1_0 = require("coroutine")
local var2_0 = require("string")
local var3_0 = require("math")
local var4_0 = require("os")
local var5_0 = require("socket")
local var6_0 = require("socket.tp")
local var7_0 = require("ltn12")
local var8_0 = require("socket.headers")
local var9_0 = require("mime")

var5_0.smtp = {}

local var10_0 = var5_0.smtp

var10_0.TIMEOUT = 60
var10_0.SERVER = "localhost"
var10_0.PORT = 25
var10_0.DOMAIN = var4_0.getenv("SERVER_NAME") or "localhost"
var10_0.ZONE = "-0000"

local var11_0 = {
	__index = {}
}

function var11_0.__index.greet(arg0_1, arg1_1)
	arg0_1.try(arg0_1.tp:check("2.."))
	arg0_1.try(arg0_1.tp:command("EHLO", arg1_1 or var10_0.DOMAIN))

	return var5_0.skip(1, arg0_1.try(arg0_1.tp:check("2..")))
end

function var11_0.__index.mail(arg0_2, arg1_2)
	arg0_2.try(arg0_2.tp:command("MAIL", "FROM:" .. arg1_2))

	return arg0_2.try(arg0_2.tp:check("2.."))
end

function var11_0.__index.rcpt(arg0_3, arg1_3)
	arg0_3.try(arg0_3.tp:command("RCPT", "TO:" .. arg1_3))

	return arg0_3.try(arg0_3.tp:check("2.."))
end

function var11_0.__index.data(arg0_4, arg1_4, arg2_4)
	arg0_4.try(arg0_4.tp:command("DATA"))
	arg0_4.try(arg0_4.tp:check("3.."))
	arg0_4.try(arg0_4.tp:source(arg1_4, arg2_4))
	arg0_4.try(arg0_4.tp:send("\r\n.\r\n"))

	return arg0_4.try(arg0_4.tp:check("2.."))
end

function var11_0.__index.quit(arg0_5)
	arg0_5.try(arg0_5.tp:command("QUIT"))

	return arg0_5.try(arg0_5.tp:check("2.."))
end

function var11_0.__index.close(arg0_6)
	return arg0_6.tp:close()
end

function var11_0.__index.login(arg0_7, arg1_7, arg2_7)
	arg0_7.try(arg0_7.tp:command("AUTH", "LOGIN"))
	arg0_7.try(arg0_7.tp:check("3.."))
	arg0_7.try(arg0_7.tp:send(var9_0.b64(arg1_7) .. "\r\n"))
	arg0_7.try(arg0_7.tp:check("3.."))
	arg0_7.try(arg0_7.tp:send(var9_0.b64(arg2_7) .. "\r\n"))

	return arg0_7.try(arg0_7.tp:check("2.."))
end

function var11_0.__index.plain(arg0_8, arg1_8, arg2_8)
	local var0_8 = "PLAIN " .. var9_0.b64("\x00" .. arg1_8 .. "\x00" .. arg2_8)

	arg0_8.try(arg0_8.tp:command("AUTH", var0_8))

	return arg0_8.try(arg0_8.tp:check("2.."))
end

function var11_0.__index.auth(arg0_9, arg1_9, arg2_9, arg3_9)
	if not arg1_9 or not arg2_9 then
		return 1
	end

	if var2_0.find(arg3_9, "AUTH[^\n]+LOGIN") then
		return arg0_9:login(arg1_9, arg2_9)
	elseif var2_0.find(arg3_9, "AUTH[^\n]+PLAIN") then
		return arg0_9:plain(arg1_9, arg2_9)
	else
		arg0_9.try(nil, "authentication not supported")
	end
end

function var11_0.__index.send(arg0_10, arg1_10)
	arg0_10:mail(arg1_10.from)

	if var0_0.type(arg1_10.rcpt) == "table" then
		for iter0_10, iter1_10 in var0_0.ipairs(arg1_10.rcpt) do
			arg0_10:rcpt(iter1_10)
		end
	else
		arg0_10:rcpt(arg1_10.rcpt)
	end

	arg0_10:data(var7_0.source.chain(arg1_10.source, var9_0.stuff()), arg1_10.step)
end

function var10_0.open(arg0_11, arg1_11, arg2_11)
	local var0_11 = var5_0.try(var6_0.connect(arg0_11 or var10_0.SERVER, arg1_11 or var10_0.PORT, var10_0.TIMEOUT, arg2_11))
	local var1_11 = var0_0.setmetatable({
		tp = var0_11
	}, var11_0)

	var1_11.try = var5_0.newtry(function()
		var1_11:close()
	end)

	return var1_11
end

local function var12_0(arg0_13)
	local var0_13 = {}

	for iter0_13, iter1_13 in var0_0.pairs(arg0_13 or var0_13) do
		var0_13[var2_0.lower(iter0_13)] = iter1_13
	end

	return var0_13
end

local var13_0 = 0

local function var14_0()
	var13_0 = var13_0 + 1

	return var2_0.format("%s%05d==%05u", var4_0.date("%d%m%Y%H%M%S"), var3_0.random(0, 99999), var13_0)
end

local var15_0

local function var16_0(arg0_15)
	local var0_15 = var8_0.canonic
	local var1_15 = "\r\n"

	for iter0_15, iter1_15 in var0_0.pairs(arg0_15) do
		var1_15 = (var0_15[iter0_15] or iter0_15) .. ": " .. iter1_15 .. "\r\n" .. var1_15
	end

	var1_0.yield(var1_15)
end

local function var17_0(arg0_16)
	local var0_16 = var14_0()
	local var1_16 = var12_0(arg0_16.headers or {})

	var1_16["content-type"] = var1_16["content-type"] or "multipart/mixed"
	var1_16["content-type"] = var1_16["content-type"] .. "; boundary=\"" .. var0_16 .. "\""

	var16_0(var1_16)

	if arg0_16.body.preamble then
		var1_0.yield(arg0_16.body.preamble)
		var1_0.yield("\r\n")
	end

	for iter0_16, iter1_16 in var0_0.ipairs(arg0_16.body) do
		var1_0.yield("\r\n--" .. var0_16 .. "\r\n")
		var15_0(iter1_16)
	end

	var1_0.yield("\r\n--" .. var0_16 .. "--\r\n\r\n")

	if arg0_16.body.epilogue then
		var1_0.yield(arg0_16.body.epilogue)
		var1_0.yield("\r\n")
	end
end

local function var18_0(arg0_17)
	local var0_17 = var12_0(arg0_17.headers or {})

	var0_17["content-type"] = var0_17["content-type"] or "text/plain; charset=\"iso-8859-1\""

	var16_0(var0_17)

	while true do
		local var1_17, var2_17 = arg0_17.body()

		if var2_17 then
			var1_0.yield(nil, var2_17)
		elseif var1_17 then
			var1_0.yield(var1_17)
		else
			break
		end
	end
end

local function var19_0(arg0_18)
	local var0_18 = var12_0(arg0_18.headers or {})

	var0_18["content-type"] = var0_18["content-type"] or "text/plain; charset=\"iso-8859-1\""

	var16_0(var0_18)
	var1_0.yield(arg0_18.body)
end

function var15_0(arg0_19)
	if var0_0.type(arg0_19.body) == "table" then
		var17_0(arg0_19)
	elseif var0_0.type(arg0_19.body) == "function" then
		var18_0(arg0_19)
	else
		var19_0(arg0_19)
	end
end

local function var20_0(arg0_20)
	local var0_20 = var12_0(arg0_20.headers)

	var0_20.date = var0_20.date or var4_0.date("!%a, %d %b %Y %H:%M:%S ") .. (arg0_20.zone or var10_0.ZONE)
	var0_20["x-mailer"] = var0_20["x-mailer"] or var5_0._VERSION
	var0_20["mime-version"] = "1.0"

	return var0_20
end

function var10_0.message(arg0_21)
	arg0_21.headers = var20_0(arg0_21)

	local var0_21 = var1_0.create(function()
		var15_0(arg0_21)
	end)

	return function()
		local var0_23, var1_23, var2_23 = var1_0.resume(var0_21)

		if var0_23 then
			return var1_23, var2_23
		else
			return nil, var1_23
		end
	end
end

var10_0.send = var5_0.protect(function(arg0_24)
	local var0_24 = var10_0.open(arg0_24.server, arg0_24.port, arg0_24.create)
	local var1_24 = var0_24:greet(arg0_24.domain)

	var0_24:auth(arg0_24.user, arg0_24.password, var1_24)
	var0_24:send(arg0_24)
	var0_24:quit()

	return var0_24:close()
end)

return var10_0
