local var0_0 = require("socket")
local var1_0 = require("socket.url")
local var2_0 = require("ltn12")
local var3_0 = require("mime")
local var4_0 = require("string")
local var5_0 = require("socket.headers")
local var6_0 = _G
local var7_0 = require("table")

var0_0.http = {}

local var8_0 = var0_0.http

var8_0.TIMEOUT = 60
var8_0.USERAGENT = var0_0._VERSION

local var9_0 = {
	http = true
}
local var10_0 = 80

local function var11_0(arg0_1, arg1_1)
	local var0_1
	local var1_1
	local var2_1
	local var3_1

	arg1_1 = arg1_1 or {}

	local var4_1, var5_1 = arg0_1:receive()

	if var5_1 then
		return nil, var5_1
	end

	while var4_1 ~= "" do
		local var6_1, var7_1 = var0_0.skip(2, var4_0.find(var4_1, "^(.-):%s*(.*)"))

		if not var6_1 or not var7_1 then
			return nil, "malformed reponse headers"
		end

		local var8_1 = var4_0.lower(var6_1)
		local var9_1

		var4_1, var9_1 = arg0_1:receive()

		if var9_1 then
			return nil, var9_1
		end

		while var4_0.find(var4_1, "^%s") do
			var7_1 = var7_1 .. var4_1

			local var10_1 = arg0_1:receive()

			if var9_1 then
				return nil, var9_1
			end
		end

		if arg1_1[var8_1] then
			arg1_1[var8_1] = arg1_1[var8_1] .. ", " .. var7_1
		else
			arg1_1[var8_1] = var7_1
		end
	end

	return arg1_1
end

var0_0.sourcet["http-chunked"] = function(arg0_2, arg1_2)
	return var6_0.setmetatable({
		getfd = function()
			return arg0_2:getfd()
		end,
		dirty = function()
			return arg0_2:dirty()
		end
	}, {
		__call = function()
			local var0_5, var1_5 = arg0_2:receive()

			if var1_5 then
				return nil, var1_5
			end

			local var2_5 = var6_0.tonumber(var4_0.gsub(var0_5, ";.*", ""), 16)

			if not var2_5 then
				return nil, "invalid chunk size"
			end

			if var2_5 > 0 then
				local var3_5, var4_5, var5_5 = arg0_2:receive(var2_5)

				if var3_5 then
					arg0_2:receive()
				end

				return var3_5, var4_5
			else
				local var6_5

				arg1_2, var6_5 = var11_0(arg0_2, arg1_2)

				if not arg1_2 then
					return nil, var6_5
				end
			end
		end
	})
end
var0_0.sinkt["http-chunked"] = function(arg0_6)
	return var6_0.setmetatable({
		getfd = function()
			return arg0_6:getfd()
		end,
		dirty = function()
			return arg0_6:dirty()
		end
	}, {
		__call = function(arg0_9, arg1_9, arg2_9)
			if not arg1_9 then
				return arg0_6:send("0\r\n\r\n")
			end

			local var0_9 = var4_0.format("%X\r\n", var4_0.len(arg1_9))

			return arg0_6:send(var0_9 .. arg1_9 .. "\r\n")
		end
	})
end

local var12_0 = {
	__index = {}
}

function var8_0.open(arg0_10, arg1_10, arg2_10)
	local var0_10 = var0_0.try((arg2_10 or var0_0.tcp)())
	local var1_10 = var6_0.setmetatable({
		c = var0_10
	}, var12_0)

	var1_10.try = var0_0.newtry(function()
		var1_10:close()
	end)

	var1_10.try(var0_10:settimeout(var8_0.TIMEOUT))
	var1_10.try(var0_10:connect(arg0_10, arg1_10 or var10_0))

	return var1_10
end

function var12_0.__index.sendrequestline(arg0_12, arg1_12, arg2_12)
	local var0_12 = var4_0.format("%s %s HTTP/1.1\r\n", arg1_12 or "GET", arg2_12)

	return arg0_12.try(arg0_12.c:send(var0_12))
end

function var12_0.__index.sendheaders(arg0_13, arg1_13)
	local var0_13 = var5_0.canonic
	local var1_13 = "\r\n"

	for iter0_13, iter1_13 in var6_0.pairs(arg1_13) do
		var1_13 = (var0_13[iter0_13] or iter0_13) .. ": " .. iter1_13 .. "\r\n" .. var1_13
	end

	arg0_13.try(arg0_13.c:send(var1_13))

	return 1
end

function var12_0.__index.sendbody(arg0_14, arg1_14, arg2_14, arg3_14)
	arg2_14 = arg2_14 or var2_0.source.empty()
	arg3_14 = arg3_14 or var2_0.pump.step

	local var0_14 = "http-chunked"

	if arg1_14["content-length"] then
		var0_14 = "keep-open"
	end

	return arg0_14.try(var2_0.pump.all(arg2_14, var0_0.sink(var0_14, arg0_14.c), arg3_14))
end

function var12_0.__index.receivestatusline(arg0_15)
	local var0_15 = arg0_15.try(arg0_15.c:receive(5))

	if var0_15 ~= "HTTP/" then
		return nil, var0_15
	end

	local var1_15 = arg0_15.try(arg0_15.c:receive("*l", var0_15))
	local var2_15 = var0_0.skip(2, var4_0.find(var1_15, "HTTP/%d*%.%d* (%d%d%d)"))

	return arg0_15.try(var6_0.tonumber(var2_15), var1_15)
end

function var12_0.__index.receiveheaders(arg0_16)
	return arg0_16.try(var11_0(arg0_16.c))
end

function var12_0.__index.receivebody(arg0_17, arg1_17, arg2_17, arg3_17)
	arg2_17 = arg2_17 or var2_0.sink.null()
	arg3_17 = arg3_17 or var2_0.pump.step

	local var0_17 = var6_0.tonumber(arg1_17["content-length"])
	local var1_17 = arg1_17["transfer-encoding"]
	local var2_17 = "default"

	if var1_17 and var1_17 ~= "identity" then
		var2_17 = "http-chunked"
	elseif var6_0.tonumber(arg1_17["content-length"]) then
		var2_17 = "by-length"
	end

	return arg0_17.try(var2_0.pump.all(var0_0.source(var2_17, arg0_17.c, var0_17), arg2_17, arg3_17))
end

function var12_0.__index.receive09body(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = var2_0.source.rewind(var0_0.source("until-closed", arg0_18.c))

	var0_18(arg1_18)

	return arg0_18.try(var2_0.pump.all(var0_18, arg2_18, arg3_18))
end

function var12_0.__index.close(arg0_19)
	return arg0_19.c:close()
end

local function var13_0(arg0_20)
	local var0_20 = arg0_20

	if not arg0_20.proxy and not var8_0.PROXY then
		var0_20 = {
			path = var0_0.try(arg0_20.path, "invalid path 'nil'"),
			params = arg0_20.params,
			query = arg0_20.query,
			fragment = arg0_20.fragment
		}
	end

	return var1_0.build(var0_20)
end

local function var14_0(arg0_21)
	local var0_21 = arg0_21.proxy or var8_0.PROXY

	if var0_21 then
		local var1_21 = var1_0.parse(var0_21)

		return var1_21.host, var1_21.port or 3128
	else
		return arg0_21.host, arg0_21.port
	end
end

local function var15_0(arg0_22)
	local var0_22 = var4_0.gsub(arg0_22.authority, "^.-@", "")
	local var1_22 = {
		connection = "close, TE",
		te = "trailers",
		["user-agent"] = var8_0.USERAGENT,
		host = var0_22
	}

	if arg0_22.user and arg0_22.password then
		var1_22.authorization = "Basic " .. var3_0.b64(arg0_22.user .. ":" .. arg0_22.password)
	end

	local var2_22 = arg0_22.proxy or var8_0.PROXY

	if var2_22 then
		local var3_22 = var1_0.parse(var2_22)

		if var3_22.user and var3_22.password then
			var1_22["proxy-authorization"] = "Basic " .. var3_0.b64(var3_22.user .. ":" .. var3_22.password)
		end
	end

	for iter0_22, iter1_22 in var6_0.pairs(arg0_22.headers or var1_22) do
		var1_22[var4_0.lower(iter0_22)] = iter1_22
	end

	return var1_22
end

local var16_0 = {
	host = "",
	scheme = "http",
	path = "/",
	port = var10_0
}

local function var17_0(arg0_23)
	local var0_23 = arg0_23.url and var1_0.parse(arg0_23.url, var16_0) or {}

	for iter0_23, iter1_23 in var6_0.pairs(arg0_23) do
		var0_23[iter0_23] = iter1_23
	end

	if var0_23.port == "" then
		var0_23.port = var10_0
	end

	if not var0_23.host or var0_23.host == "" then
		var0_0.try(nil, "invalid host '" .. var6_0.tostring(var0_23.host) .. "'")
	end

	var0_23.uri = arg0_23.uri or var13_0(var0_23)
	var0_23.headers = var15_0(var0_23)
	var0_23.host, var0_23.port = var14_0(var0_23)

	return var0_23
end

local function var18_0(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg2_24.location

	if not var0_24 then
		return false
	end

	local var1_24 = var4_0.gsub(var0_24, "%s", "")

	if var1_24 == "" then
		return false
	end

	local var2_24 = var4_0.match(var1_24, "^([%w][%w%+%-%.]*)%:")

	if var2_24 and not var9_0[var2_24] then
		return false
	end

	return arg0_24.redirect ~= false and (arg1_24 == 301 or arg1_24 == 302 or arg1_24 == 303 or arg1_24 == 307) and (not arg0_24.method or arg0_24.method == "GET" or arg0_24.method == "HEAD") and (not arg0_24.nredirects or arg0_24.nredirects < 5)
end

local function var19_0(arg0_25, arg1_25)
	if arg0_25.method == "HEAD" then
		return nil
	end

	if arg1_25 == 204 or arg1_25 == 304 then
		return nil
	end

	if arg1_25 >= 100 and arg1_25 < 200 then
		return nil
	end

	return 1
end

local var20_0
local var21_0

local function var22_0(arg0_26, arg1_26)
	local var0_26, var1_26, var2_26, var3_26 = var20_0({
		url = var1_0.absolute(arg0_26.url, arg1_26),
		source = arg0_26.source,
		sink = arg0_26.sink,
		headers = arg0_26.headers,
		proxy = arg0_26.proxy,
		nredirects = (arg0_26.nredirects or 0) + 1,
		create = arg0_26.create
	})

	var2_26 = var2_26 or {}
	var2_26.location = var2_26.location or arg1_26

	return var0_26, var1_26, var2_26, var3_26
end

function var20_0(arg0_27)
	local var0_27 = var17_0(arg0_27)
	local var1_27 = var8_0.open(var0_27.host, var0_27.port, var0_27.create)

	var1_27:sendrequestline(var0_27.method, var0_27.uri)
	var1_27:sendheaders(var0_27.headers)

	if var0_27.source then
		var1_27:sendbody(var0_27.headers, var0_27.source, var0_27.step)
	end

	local var2_27, var3_27 = var1_27:receivestatusline()

	if not var2_27 then
		var1_27:receive09body(var3_27, var0_27.sink, var0_27.step)

		return 1, 200
	end

	local var4_27

	while var2_27 == 100 do
		local var5_27 = var1_27:receiveheaders()

		var2_27, var3_27 = var1_27:receivestatusline()
	end

	local var6_27 = var1_27:receiveheaders()

	if var18_0(var0_27, var2_27, var6_27) and not var0_27.source then
		var1_27:close()

		return var22_0(arg0_27, var6_27.location)
	end

	if var19_0(var0_27, var2_27) then
		var1_27:receivebody(var6_27, var0_27.sink, var0_27.step)
	end

	var1_27:close()

	return 1, var2_27, var6_27, var3_27
end

local function var23_0(arg0_28, arg1_28)
	local var0_28 = {}
	local var1_28 = {
		url = arg0_28,
		sink = var2_0.sink.table(var0_28),
		target = var0_28
	}

	if arg1_28 then
		var1_28.source = var2_0.source.string(arg1_28)
		var1_28.headers = {
			["content-type"] = "application/x-www-form-urlencoded",
			["content-length"] = var4_0.len(arg1_28)
		}
		var1_28.method = "POST"
	end

	return var1_28
end

var8_0.genericform = var23_0

local function var24_0(arg0_29, arg1_29)
	local var0_29 = var23_0(arg0_29, arg1_29)
	local var1_29, var2_29, var3_29, var4_29 = var20_0(var0_29)

	return var7_0.concat(var0_29.target), var2_29, var3_29, var4_29
end

var8_0.request = var0_0.protect(function(arg0_30, arg1_30)
	if var6_0.type(arg0_30) == "string" then
		return var24_0(arg0_30, arg1_30)
	else
		return var20_0(arg0_30)
	end
end)

return var8_0
