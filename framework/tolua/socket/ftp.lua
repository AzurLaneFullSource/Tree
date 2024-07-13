local var0_0 = _G
local var1_0 = require("table")
local var2_0 = require("string")
local var3_0 = require("math")
local var4_0 = require("socket")
local var5_0 = require("socket.url")
local var6_0 = require("socket.tp")
local var7_0 = require("ltn12")

var4_0.ftp = {}

local var8_0 = var4_0.ftp

var8_0.TIMEOUT = 60

local var9_0 = 21

var8_0.USER = "ftp"
var8_0.PASSWORD = "anonymous@anonymous.org"

local var10_0 = {
	__index = {}
}

function var8_0.open(arg0_1, arg1_1, arg2_1)
	local var0_1 = var4_0.try(var6_0.connect(arg0_1, arg1_1 or var9_0, var8_0.TIMEOUT, arg2_1))
	local var1_1 = var0_0.setmetatable({
		tp = var0_1
	}, var10_0)

	var1_1.try = var4_0.newtry(function()
		var1_1:close()
	end)

	return var1_1
end

function var10_0.__index.portconnect(arg0_3)
	arg0_3.try(arg0_3.server:settimeout(var8_0.TIMEOUT))

	arg0_3.data = arg0_3.try(arg0_3.server:accept())

	arg0_3.try(arg0_3.data:settimeout(var8_0.TIMEOUT))
end

function var10_0.__index.pasvconnect(arg0_4)
	arg0_4.data = arg0_4.try(var4_0.tcp())

	arg0_4.try(arg0_4.data:settimeout(var8_0.TIMEOUT))
	arg0_4.try(arg0_4.data:connect(arg0_4.pasvt.address, arg0_4.pasvt.port))
end

function var10_0.__index.login(arg0_5, arg1_5, arg2_5)
	arg0_5.try(arg0_5.tp:command("user", arg1_5 or var8_0.USER))

	local var0_5, var1_5 = arg0_5.try(arg0_5.tp:check({
		"2..",
		331
	}))

	if var0_5 == 331 then
		arg0_5.try(arg0_5.tp:command("pass", arg2_5 or var8_0.PASSWORD))
		arg0_5.try(arg0_5.tp:check("2.."))
	end

	return 1
end

function var10_0.__index.pasv(arg0_6)
	arg0_6.try(arg0_6.tp:command("pasv"))

	local var0_6, var1_6 = arg0_6.try(arg0_6.tp:check("2.."))
	local var2_6 = "(%d+)%D(%d+)%D(%d+)%D(%d+)%D(%d+)%D(%d+)"
	local var3_6, var4_6, var5_6, var6_6, var7_6, var8_6 = var4_0.skip(2, var2_0.find(var1_6, var2_6))

	arg0_6.try(var3_6 and var4_6 and var5_6 and var6_6 and var7_6 and var8_6, var1_6)

	arg0_6.pasvt = {
		address = var2_0.format("%d.%d.%d.%d", var3_6, var4_6, var5_6, var6_6),
		port = var7_6 * 256 + var8_6
	}

	if arg0_6.server then
		arg0_6.server:close()

		arg0_6.server = nil
	end

	return arg0_6.pasvt.address, arg0_6.pasvt.port
end

function var10_0.__index.epsv(arg0_7)
	arg0_7.try(arg0_7.tp:command("epsv"))

	local var0_7, var1_7 = arg0_7.try(arg0_7.tp:check("229"))
	local var2_7 = "%((.)(.-)%1(.-)%1(.-)%1%)"
	local var3_7, var4_7, var5_7, var6_7 = var2_0.match(var1_7, var2_7)

	arg0_7.try(var6_7, "invalid epsv response")

	arg0_7.pasvt = {
		address = arg0_7.tp:getpeername(),
		port = var6_7
	}

	if arg0_7.server then
		arg0_7.server:close()

		arg0_7.server = nil
	end

	return arg0_7.pasvt.address, arg0_7.pasvt.port
end

function var10_0.__index.port(arg0_8, arg1_8, arg2_8)
	arg0_8.pasvt = nil

	if not arg1_8 then
		arg1_8, arg2_8 = arg0_8.try(arg0_8.tp:getsockname())
		arg0_8.server = arg0_8.try(var4_0.bind(arg1_8, 0))
		arg1_8, arg2_8 = arg0_8.try(arg0_8.server:getsockname())

		arg0_8.try(arg0_8.server:settimeout(var8_0.TIMEOUT))
	end

	local var0_8 = arg2_8 % 256
	local var1_8 = (arg2_8 - var0_8) / 256
	local var2_8 = var2_0.gsub(var2_0.format("%s,%d,%d", arg1_8, var1_8, var0_8), "%.", ",")

	arg0_8.try(arg0_8.tp:command("port", var2_8))
	arg0_8.try(arg0_8.tp:check("2.."))

	return 1
end

function var10_0.__index.eprt(arg0_9, arg1_9, arg2_9, arg3_9)
	arg0_9.pasvt = nil

	if not arg2_9 then
		arg2_9, arg3_9 = arg0_9.try(arg0_9.tp:getsockname())
		arg0_9.server = arg0_9.try(var4_0.bind(arg2_9, 0))
		arg2_9, arg3_9 = arg0_9.try(arg0_9.server:getsockname())

		arg0_9.try(arg0_9.server:settimeout(var8_0.TIMEOUT))
	end

	local var0_9 = var2_0.format("|%s|%s|%d|", arg1_9, arg2_9, arg3_9)

	arg0_9.try(arg0_9.tp:command("eprt", var0_9))
	arg0_9.try(arg0_9.tp:check("2.."))

	return 1
end

function var10_0.__index.send(arg0_10, arg1_10)
	arg0_10.try(arg0_10.pasvt or arg0_10.server, "need port or pasv first")

	if arg0_10.pasvt then
		arg0_10:pasvconnect()
	end

	local var0_10 = arg1_10.argument or var5_0.unescape(var2_0.gsub(arg1_10.path or "", "^[/\\]", ""))

	if var0_10 == "" then
		var0_10 = nil
	end

	local var1_10 = arg1_10.command or "stor"

	arg0_10.try(arg0_10.tp:command(var1_10, var0_10))

	local var2_10, var3_10 = arg0_10.try(arg0_10.tp:check({
		"2..",
		"1.."
	}))

	if not arg0_10.pasvt then
		arg0_10:portconnect()
	end

	local var4_10 = arg1_10.step or var7_0.pump.step
	local var5_10 = {
		arg0_10.tp
	}

	local function var6_10(arg0_11, arg1_11)
		if var4_0.select(var5_10, nil, 0)[var6_0] then
			var2_10 = arg0_10.try(arg0_10.tp:check("2.."))
		end

		return var4_10(arg0_11, arg1_11)
	end

	local var7_10 = var4_0.sink("close-when-done", arg0_10.data)

	arg0_10.try(var7_0.pump.all(arg1_10.source, var7_10, var6_10))

	if var2_0.find(var2_10, "1..") then
		arg0_10.try(arg0_10.tp:check("2.."))
	end

	arg0_10.data:close()

	local var8_10 = var4_0.skip(1, arg0_10.data:getstats())

	arg0_10.data = nil

	return var8_10
end

function var10_0.__index.receive(arg0_12, arg1_12)
	arg0_12.try(arg0_12.pasvt or arg0_12.server, "need port or pasv first")

	if arg0_12.pasvt then
		arg0_12:pasvconnect()
	end

	local var0_12 = arg1_12.argument or var5_0.unescape(var2_0.gsub(arg1_12.path or "", "^[/\\]", ""))

	if var0_12 == "" then
		var0_12 = nil
	end

	local var1_12 = arg1_12.command or "retr"

	arg0_12.try(arg0_12.tp:command(var1_12, var0_12))

	local var2_12, var3_12 = arg0_12.try(arg0_12.tp:check({
		"1..",
		"2.."
	}))

	if var2_12 >= 200 and var2_12 <= 299 then
		arg1_12.sink(var3_12)

		return 1
	end

	if not arg0_12.pasvt then
		arg0_12:portconnect()
	end

	local var4_12 = var4_0.source("until-closed", arg0_12.data)
	local var5_12 = arg1_12.step or var7_0.pump.step

	arg0_12.try(var7_0.pump.all(var4_12, arg1_12.sink, var5_12))

	if var2_0.find(var2_12, "1..") then
		arg0_12.try(arg0_12.tp:check("2.."))
	end

	arg0_12.data:close()

	arg0_12.data = nil

	return 1
end

function var10_0.__index.cwd(arg0_13, arg1_13)
	arg0_13.try(arg0_13.tp:command("cwd", arg1_13))
	arg0_13.try(arg0_13.tp:check(250))

	return 1
end

function var10_0.__index.type(arg0_14, arg1_14)
	arg0_14.try(arg0_14.tp:command("type", arg1_14))
	arg0_14.try(arg0_14.tp:check(200))

	return 1
end

function var10_0.__index.greet(arg0_15)
	local var0_15 = arg0_15.try(arg0_15.tp:check({
		"1..",
		"2.."
	}))

	if var2_0.find(var0_15, "1..") then
		arg0_15.try(arg0_15.tp:check("2.."))
	end

	return 1
end

function var10_0.__index.quit(arg0_16)
	arg0_16.try(arg0_16.tp:command("quit"))
	arg0_16.try(arg0_16.tp:check("2.."))

	return 1
end

function var10_0.__index.close(arg0_17)
	if arg0_17.data then
		arg0_17.data:close()
	end

	if arg0_17.server then
		arg0_17.server:close()
	end

	return arg0_17.tp:close()
end

local function var11_0(arg0_18)
	if arg0_18.url then
		local var0_18 = var5_0.parse(arg0_18.url)

		for iter0_18, iter1_18 in var0_0.pairs(arg0_18) do
			var0_18[iter0_18] = iter1_18
		end

		return var0_18
	else
		return arg0_18
	end
end

local function var12_0(arg0_19)
	arg0_19 = var11_0(arg0_19)

	var4_0.try(arg0_19.host, "missing hostname")

	local var0_19 = var8_0.open(arg0_19.host, arg0_19.port, arg0_19.create)

	var0_19:greet()
	var0_19:login(arg0_19.user, arg0_19.password)

	if arg0_19.type then
		var0_19:type(arg0_19.type)
	end

	var0_19:epsv()

	local var1_19 = var0_19:send(arg0_19)

	var0_19:quit()
	var0_19:close()

	return var1_19
end

local var13_0 = {
	path = "/",
	scheme = "ftp"
}

local function var14_0(arg0_20)
	local var0_20 = var4_0.try(var5_0.parse(arg0_20, var13_0))

	var4_0.try(var0_20.scheme == "ftp", "wrong scheme '" .. var0_20.scheme .. "'")
	var4_0.try(var0_20.host, "missing hostname")

	local var1_20 = "^type=(.)$"

	if var0_20.params then
		var0_20.type = var4_0.skip(2, var2_0.find(var0_20.params, var1_20))

		var4_0.try(var0_20.type == "a" or var0_20.type == "i", "invalid type '" .. var0_20.type .. "'")
	end

	return var0_20
end

var8_0.genericform = var14_0

local function var15_0(arg0_21, arg1_21)
	local var0_21 = var14_0(arg0_21)

	var0_21.source = var7_0.source.string(arg1_21)

	return var12_0(var0_21)
end

var8_0.put = var4_0.protect(function(arg0_22, arg1_22)
	if var0_0.type(arg0_22) == "string" then
		return var15_0(arg0_22, arg1_22)
	else
		return var12_0(arg0_22)
	end
end)

local function var16_0(arg0_23)
	arg0_23 = var11_0(arg0_23)

	var4_0.try(arg0_23.host, "missing hostname")

	local var0_23 = var8_0.open(arg0_23.host, arg0_23.port, arg0_23.create)

	var0_23:greet()
	var0_23:login(arg0_23.user, arg0_23.password)

	if arg0_23.type then
		var0_23:type(arg0_23.type)
	end

	var0_23:epsv()
	var0_23:receive(arg0_23)
	var0_23:quit()

	return var0_23:close()
end

local function var17_0(arg0_24)
	local var0_24 = var14_0(arg0_24)
	local var1_24 = {}

	var0_24.sink = var7_0.sink.table(var1_24)

	var16_0(var0_24)

	return var1_0.concat(var1_24)
end

var8_0.command = var4_0.protect(function(arg0_25)
	arg0_25 = var11_0(arg0_25)

	var4_0.try(arg0_25.host, "missing hostname")
	var4_0.try(arg0_25.command, "missing command")

	local var0_25 = var8_0.open(arg0_25.host, arg0_25.port, arg0_25.create)

	var0_25:greet()
	var0_25:login(arg0_25.user, arg0_25.password)

	if type(arg0_25.command) == "table" then
		local var1_25 = arg0_25.argument or {}
		local var2_25 = arg0_25.check or {}

		for iter0_25, iter1_25 in ipairs(arg0_25.command) do
			var0_25.try(var0_25.tp:command(iter1_25, var1_25[iter0_25]))

			if var2_25[iter0_25] then
				var0_25.try(var0_25.tp:check(var2_25[iter0_25]))
			end
		end
	else
		var0_25.try(var0_25.tp:command(arg0_25.command, arg0_25.argument))

		if arg0_25.check then
			var0_25.try(var0_25.tp:check(arg0_25.check))
		end
	end

	var0_25:quit()

	return var0_25:close()
end)
var8_0.get = var4_0.protect(function(arg0_26)
	if var0_0.type(arg0_26) == "string" then
		return var17_0(arg0_26)
	else
		return var16_0(arg0_26)
	end
end)

return var8_0
