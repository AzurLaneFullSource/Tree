local var0 = _G
local var1 = require("table")
local var2 = require("string")
local var3 = require("math")
local var4 = require("socket")
local var5 = require("socket.url")
local var6 = require("socket.tp")
local var7 = require("ltn12")

var4.ftp = {}

local var8 = var4.ftp

var8.TIMEOUT = 60

local var9 = 21

var8.USER = "ftp"
var8.PASSWORD = "anonymous@anonymous.org"

local var10 = {
	__index = {}
}

function var8.open(arg0, arg1, arg2)
	local var0 = var4.try(var6.connect(arg0, arg1 or var9, var8.TIMEOUT, arg2))
	local var1 = var0.setmetatable({
		tp = var0
	}, var10)

	var1.try = var4.newtry(function()
		var1:close()
	end)

	return var1
end

function var10.__index.portconnect(arg0)
	arg0.try(arg0.server:settimeout(var8.TIMEOUT))

	arg0.data = arg0.try(arg0.server:accept())

	arg0.try(arg0.data:settimeout(var8.TIMEOUT))
end

function var10.__index.pasvconnect(arg0)
	arg0.data = arg0.try(var4.tcp())

	arg0.try(arg0.data:settimeout(var8.TIMEOUT))
	arg0.try(arg0.data:connect(arg0.pasvt.address, arg0.pasvt.port))
end

function var10.__index.login(arg0, arg1, arg2)
	arg0.try(arg0.tp:command("user", arg1 or var8.USER))

	local var0, var1 = arg0.try(arg0.tp:check({
		"2..",
		331
	}))

	if var0 == 331 then
		arg0.try(arg0.tp:command("pass", arg2 or var8.PASSWORD))
		arg0.try(arg0.tp:check("2.."))
	end

	return 1
end

function var10.__index.pasv(arg0)
	arg0.try(arg0.tp:command("pasv"))

	local var0, var1 = arg0.try(arg0.tp:check("2.."))
	local var2 = "(%d+)%D(%d+)%D(%d+)%D(%d+)%D(%d+)%D(%d+)"
	local var3, var4, var5, var6, var7, var8 = var4.skip(2, var2.find(var1, var2))

	arg0.try(var3 and var4 and var5 and var6 and var7 and var8, var1)

	arg0.pasvt = {
		address = var2.format("%d.%d.%d.%d", var3, var4, var5, var6),
		port = var7 * 256 + var8
	}

	if arg0.server then
		arg0.server:close()

		arg0.server = nil
	end

	return arg0.pasvt.address, arg0.pasvt.port
end

function var10.__index.epsv(arg0)
	arg0.try(arg0.tp:command("epsv"))

	local var0, var1 = arg0.try(arg0.tp:check("229"))
	local var2 = "%((.)(.-)%1(.-)%1(.-)%1%)"
	local var3, var4, var5, var6 = var2.match(var1, var2)

	arg0.try(var6, "invalid epsv response")

	arg0.pasvt = {
		address = arg0.tp:getpeername(),
		port = var6
	}

	if arg0.server then
		arg0.server:close()

		arg0.server = nil
	end

	return arg0.pasvt.address, arg0.pasvt.port
end

function var10.__index.port(arg0, arg1, arg2)
	arg0.pasvt = nil

	if not arg1 then
		arg1, arg2 = arg0.try(arg0.tp:getsockname())
		arg0.server = arg0.try(var4.bind(arg1, 0))
		arg1, arg2 = arg0.try(arg0.server:getsockname())

		arg0.try(arg0.server:settimeout(var8.TIMEOUT))
	end

	local var0 = arg2 % 256
	local var1 = (arg2 - var0) / 256
	local var2 = var2.gsub(var2.format("%s,%d,%d", arg1, var1, var0), "%.", ",")

	arg0.try(arg0.tp:command("port", var2))
	arg0.try(arg0.tp:check("2.."))

	return 1
end

function var10.__index.eprt(arg0, arg1, arg2, arg3)
	arg0.pasvt = nil

	if not arg2 then
		arg2, arg3 = arg0.try(arg0.tp:getsockname())
		arg0.server = arg0.try(var4.bind(arg2, 0))
		arg2, arg3 = arg0.try(arg0.server:getsockname())

		arg0.try(arg0.server:settimeout(var8.TIMEOUT))
	end

	local var0 = var2.format("|%s|%s|%d|", arg1, arg2, arg3)

	arg0.try(arg0.tp:command("eprt", var0))
	arg0.try(arg0.tp:check("2.."))

	return 1
end

function var10.__index.send(arg0, arg1)
	arg0.try(arg0.pasvt or arg0.server, "need port or pasv first")

	if arg0.pasvt then
		arg0:pasvconnect()
	end

	local var0 = arg1.argument or var5.unescape(var2.gsub(arg1.path or "", "^[/\\]", ""))

	if var0 == "" then
		var0 = nil
	end

	local var1 = arg1.command or "stor"

	arg0.try(arg0.tp:command(var1, var0))

	local var2, var3 = arg0.try(arg0.tp:check({
		"2..",
		"1.."
	}))

	if not arg0.pasvt then
		arg0:portconnect()
	end

	local var4 = arg1.step or var7.pump.step
	local var5 = {
		arg0.tp
	}
	local var6 = function(arg0, arg1)
		if var4.select(var5, nil, 0)[var6] then
			var2 = arg0.try(arg0.tp:check("2.."))
		end

		return var4(arg0, arg1)
	end
	local var7 = var4.sink("close-when-done", arg0.data)

	arg0.try(var7.pump.all(arg1.source, var7, var6))

	if var2.find(var2, "1..") then
		arg0.try(arg0.tp:check("2.."))
	end

	arg0.data:close()

	local var8 = var4.skip(1, arg0.data:getstats())

	arg0.data = nil

	return var8
end

function var10.__index.receive(arg0, arg1)
	arg0.try(arg0.pasvt or arg0.server, "need port or pasv first")

	if arg0.pasvt then
		arg0:pasvconnect()
	end

	local var0 = arg1.argument or var5.unescape(var2.gsub(arg1.path or "", "^[/\\]", ""))

	if var0 == "" then
		var0 = nil
	end

	local var1 = arg1.command or "retr"

	arg0.try(arg0.tp:command(var1, var0))

	local var2, var3 = arg0.try(arg0.tp:check({
		"1..",
		"2.."
	}))

	if var2 >= 200 and var2 <= 299 then
		arg1.sink(var3)

		return 1
	end

	if not arg0.pasvt then
		arg0:portconnect()
	end

	local var4 = var4.source("until-closed", arg0.data)
	local var5 = arg1.step or var7.pump.step

	arg0.try(var7.pump.all(var4, arg1.sink, var5))

	if var2.find(var2, "1..") then
		arg0.try(arg0.tp:check("2.."))
	end

	arg0.data:close()

	arg0.data = nil

	return 1
end

function var10.__index.cwd(arg0, arg1)
	arg0.try(arg0.tp:command("cwd", arg1))
	arg0.try(arg0.tp:check(250))

	return 1
end

function var10.__index.type(arg0, arg1)
	arg0.try(arg0.tp:command("type", arg1))
	arg0.try(arg0.tp:check(200))

	return 1
end

function var10.__index.greet(arg0)
	local var0 = arg0.try(arg0.tp:check({
		"1..",
		"2.."
	}))

	if var2.find(var0, "1..") then
		arg0.try(arg0.tp:check("2.."))
	end

	return 1
end

function var10.__index.quit(arg0)
	arg0.try(arg0.tp:command("quit"))
	arg0.try(arg0.tp:check("2.."))

	return 1
end

function var10.__index.close(arg0)
	if arg0.data then
		arg0.data:close()
	end

	if arg0.server then
		arg0.server:close()
	end

	return arg0.tp:close()
end

local function var11(arg0)
	if arg0.url then
		local var0 = var5.parse(arg0.url)

		for iter0, iter1 in var0.pairs(arg0) do
			var0[iter0] = iter1
		end

		return var0
	else
		return arg0
	end
end

local function var12(arg0)
	arg0 = var11(arg0)

	var4.try(arg0.host, "missing hostname")

	local var0 = var8.open(arg0.host, arg0.port, arg0.create)

	var0:greet()
	var0:login(arg0.user, arg0.password)

	if arg0.type then
		var0:type(arg0.type)
	end

	var0:epsv()

	local var1 = var0:send(arg0)

	var0:quit()
	var0:close()

	return var1
end

local var13 = {
	path = "/",
	scheme = "ftp"
}

local function var14(arg0)
	local var0 = var4.try(var5.parse(arg0, var13))

	var4.try(var0.scheme == "ftp", "wrong scheme '" .. var0.scheme .. "'")
	var4.try(var0.host, "missing hostname")

	local var1 = "^type=(.)$"

	if var0.params then
		var0.type = var4.skip(2, var2.find(var0.params, var1))

		var4.try(var0.type == "a" or var0.type == "i", "invalid type '" .. var0.type .. "'")
	end

	return var0
end

var8.genericform = var14

local function var15(arg0, arg1)
	local var0 = var14(arg0)

	var0.source = var7.source.string(arg1)

	return var12(var0)
end

var8.put = var4.protect(function(arg0, arg1)
	if var0.type(arg0) == "string" then
		return var15(arg0, arg1)
	else
		return var12(arg0)
	end
end)

local function var16(arg0)
	arg0 = var11(arg0)

	var4.try(arg0.host, "missing hostname")

	local var0 = var8.open(arg0.host, arg0.port, arg0.create)

	var0:greet()
	var0:login(arg0.user, arg0.password)

	if arg0.type then
		var0:type(arg0.type)
	end

	var0:epsv()
	var0:receive(arg0)
	var0:quit()

	return var0:close()
end

local function var17(arg0)
	local var0 = var14(arg0)
	local var1 = {}

	var0.sink = var7.sink.table(var1)

	var16(var0)

	return var1.concat(var1)
end

var8.command = var4.protect(function(arg0)
	arg0 = var11(arg0)

	var4.try(arg0.host, "missing hostname")
	var4.try(arg0.command, "missing command")

	local var0 = var8.open(arg0.host, arg0.port, arg0.create)

	var0:greet()
	var0:login(arg0.user, arg0.password)

	if type(arg0.command) == "table" then
		local var1 = arg0.argument or {}
		local var2 = arg0.check or {}

		for iter0, iter1 in ipairs(arg0.command) do
			var0.try(var0.tp:command(iter1, var1[iter0]))

			if var2[iter0] then
				var0.try(var0.tp:check(var2[iter0]))
			end
		end
	else
		var0.try(var0.tp:command(arg0.command, arg0.argument))

		if arg0.check then
			var0.try(var0.tp:check(arg0.check))
		end
	end

	var0:quit()

	return var0:close()
end)
var8.get = var4.protect(function(arg0)
	if var0.type(arg0) == "string" then
		return var17(arg0)
	else
		return var16(arg0)
	end
end)

return var8
