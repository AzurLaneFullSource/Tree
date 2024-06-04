local var0 = _G
local var1 = require("coroutine")
local var2 = require("string")
local var3 = require("math")
local var4 = require("os")
local var5 = require("socket")
local var6 = require("socket.tp")
local var7 = require("ltn12")
local var8 = require("socket.headers")
local var9 = require("mime")

var5.smtp = {}

local var10 = var5.smtp

var10.TIMEOUT = 60
var10.SERVER = "localhost"
var10.PORT = 25
var10.DOMAIN = var4.getenv("SERVER_NAME") or "localhost"
var10.ZONE = "-0000"

local var11 = {
	__index = {}
}

function var11.__index.greet(arg0, arg1)
	arg0.try(arg0.tp:check("2.."))
	arg0.try(arg0.tp:command("EHLO", arg1 or var10.DOMAIN))

	return var5.skip(1, arg0.try(arg0.tp:check("2..")))
end

function var11.__index.mail(arg0, arg1)
	arg0.try(arg0.tp:command("MAIL", "FROM:" .. arg1))

	return arg0.try(arg0.tp:check("2.."))
end

function var11.__index.rcpt(arg0, arg1)
	arg0.try(arg0.tp:command("RCPT", "TO:" .. arg1))

	return arg0.try(arg0.tp:check("2.."))
end

function var11.__index.data(arg0, arg1, arg2)
	arg0.try(arg0.tp:command("DATA"))
	arg0.try(arg0.tp:check("3.."))
	arg0.try(arg0.tp:source(arg1, arg2))
	arg0.try(arg0.tp:send("\r\n.\r\n"))

	return arg0.try(arg0.tp:check("2.."))
end

function var11.__index.quit(arg0)
	arg0.try(arg0.tp:command("QUIT"))

	return arg0.try(arg0.tp:check("2.."))
end

function var11.__index.close(arg0)
	return arg0.tp:close()
end

function var11.__index.login(arg0, arg1, arg2)
	arg0.try(arg0.tp:command("AUTH", "LOGIN"))
	arg0.try(arg0.tp:check("3.."))
	arg0.try(arg0.tp:send(var9.b64(arg1) .. "\r\n"))
	arg0.try(arg0.tp:check("3.."))
	arg0.try(arg0.tp:send(var9.b64(arg2) .. "\r\n"))

	return arg0.try(arg0.tp:check("2.."))
end

function var11.__index.plain(arg0, arg1, arg2)
	local var0 = "PLAIN " .. var9.b64("\x00" .. arg1 .. "\x00" .. arg2)

	arg0.try(arg0.tp:command("AUTH", var0))

	return arg0.try(arg0.tp:check("2.."))
end

function var11.__index.auth(arg0, arg1, arg2, arg3)
	if not arg1 or not arg2 then
		return 1
	end

	if var2.find(arg3, "AUTH[^\n]+LOGIN") then
		return arg0:login(arg1, arg2)
	elseif var2.find(arg3, "AUTH[^\n]+PLAIN") then
		return arg0:plain(arg1, arg2)
	else
		arg0.try(nil, "authentication not supported")
	end
end

function var11.__index.send(arg0, arg1)
	arg0:mail(arg1.from)

	if var0.type(arg1.rcpt) == "table" then
		for iter0, iter1 in var0.ipairs(arg1.rcpt) do
			arg0:rcpt(iter1)
		end
	else
		arg0:rcpt(arg1.rcpt)
	end

	arg0:data(var7.source.chain(arg1.source, var9.stuff()), arg1.step)
end

function var10.open(arg0, arg1, arg2)
	local var0 = var5.try(var6.connect(arg0 or var10.SERVER, arg1 or var10.PORT, var10.TIMEOUT, arg2))
	local var1 = var0.setmetatable({
		tp = var0
	}, var11)

	var1.try = var5.newtry(function()
		var1:close()
	end)

	return var1
end

local function var12(arg0)
	local var0 = {}

	for iter0, iter1 in var0.pairs(arg0 or var0) do
		var0[var2.lower(iter0)] = iter1
	end

	return var0
end

local var13 = 0

local function var14()
	var13 = var13 + 1

	return var2.format("%s%05d==%05u", var4.date("%d%m%Y%H%M%S"), var3.random(0, 99999), var13)
end

local var15

local function var16(arg0)
	local var0 = var8.canonic
	local var1 = "\r\n"

	for iter0, iter1 in var0.pairs(arg0) do
		var1 = (var0[iter0] or iter0) .. ": " .. iter1 .. "\r\n" .. var1
	end

	var1.yield(var1)
end

local function var17(arg0)
	local var0 = var14()
	local var1 = var12(arg0.headers or {})

	var1["content-type"] = var1["content-type"] or "multipart/mixed"
	var1["content-type"] = var1["content-type"] .. "; boundary=\"" .. var0 .. "\""

	var16(var1)

	if arg0.body.preamble then
		var1.yield(arg0.body.preamble)
		var1.yield("\r\n")
	end

	for iter0, iter1 in var0.ipairs(arg0.body) do
		var1.yield("\r\n--" .. var0 .. "\r\n")
		var15(iter1)
	end

	var1.yield("\r\n--" .. var0 .. "--\r\n\r\n")

	if arg0.body.epilogue then
		var1.yield(arg0.body.epilogue)
		var1.yield("\r\n")
	end
end

local function var18(arg0)
	local var0 = var12(arg0.headers or {})

	var0["content-type"] = var0["content-type"] or "text/plain; charset=\"iso-8859-1\""

	var16(var0)

	while true do
		local var1, var2 = arg0.body()

		if var2 then
			var1.yield(nil, var2)
		elseif var1 then
			var1.yield(var1)
		else
			break
		end
	end
end

local function var19(arg0)
	local var0 = var12(arg0.headers or {})

	var0["content-type"] = var0["content-type"] or "text/plain; charset=\"iso-8859-1\""

	var16(var0)
	var1.yield(arg0.body)
end

function var15(arg0)
	if var0.type(arg0.body) == "table" then
		var17(arg0)
	elseif var0.type(arg0.body) == "function" then
		var18(arg0)
	else
		var19(arg0)
	end
end

local function var20(arg0)
	local var0 = var12(arg0.headers)

	var0.date = var0.date or var4.date("!%a, %d %b %Y %H:%M:%S ") .. (arg0.zone or var10.ZONE)
	var0["x-mailer"] = var0["x-mailer"] or var5._VERSION
	var0["mime-version"] = "1.0"

	return var0
end

function var10.message(arg0)
	arg0.headers = var20(arg0)

	local var0 = var1.create(function()
		var15(arg0)
	end)

	return function()
		local var0, var1, var2 = var1.resume(var0)

		if var0 then
			return var1, var2
		else
			return nil, var1
		end
	end
end

var10.send = var5.protect(function(arg0)
	local var0 = var10.open(arg0.server, arg0.port, arg0.create)
	local var1 = var0:greet(arg0.domain)

	var0:auth(arg0.user, arg0.password, var1)
	var0:send(arg0)
	var0:quit()

	return var0:close()
end)

return var10
