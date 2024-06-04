local var0 = require("socket")
local var1 = require("socket.url")
local var2 = require("ltn12")
local var3 = require("mime")
local var4 = require("string")
local var5 = require("socket.headers")
local var6 = _G
local var7 = require("table")

var0.http = {}

local var8 = var0.http

var8.TIMEOUT = 60
var8.USERAGENT = var0._VERSION

local var9 = {
	http = true
}
local var10 = 80

local function var11(arg0, arg1)
	local var0
	local var1
	local var2
	local var3

	arg1 = arg1 or {}

	local var4, var5 = arg0:receive()

	if var5 then
		return nil, var5
	end

	while var4 ~= "" do
		local var6, var7 = var0.skip(2, var4.find(var4, "^(.-):%s*(.*)"))

		if not var6 or not var7 then
			return nil, "malformed reponse headers"
		end

		local var8 = var4.lower(var6)
		local var9

		var4, var9 = arg0:receive()

		if var9 then
			return nil, var9
		end

		while var4.find(var4, "^%s") do
			var7 = var7 .. var4

			local var10 = arg0:receive()

			if var9 then
				return nil, var9
			end
		end

		if arg1[var8] then
			arg1[var8] = arg1[var8] .. ", " .. var7
		else
			arg1[var8] = var7
		end
	end

	return arg1
end

var0.sourcet["http-chunked"] = function(arg0, arg1)
	return var6.setmetatable({
		getfd = function()
			return arg0:getfd()
		end,
		dirty = function()
			return arg0:dirty()
		end
	}, {
		__call = function()
			local var0, var1 = arg0:receive()

			if var1 then
				return nil, var1
			end

			local var2 = var6.tonumber(var4.gsub(var0, ";.*", ""), 16)

			if not var2 then
				return nil, "invalid chunk size"
			end

			if var2 > 0 then
				local var3, var4, var5 = arg0:receive(var2)

				if var3 then
					arg0:receive()
				end

				return var3, var4
			else
				local var6

				arg1, var6 = var11(arg0, arg1)

				if not arg1 then
					return nil, var6
				end
			end
		end
	})
end
var0.sinkt["http-chunked"] = function(arg0)
	return var6.setmetatable({
		getfd = function()
			return arg0:getfd()
		end,
		dirty = function()
			return arg0:dirty()
		end
	}, {
		__call = function(arg0, arg1, arg2)
			if not arg1 then
				return arg0:send("0\r\n\r\n")
			end

			local var0 = var4.format("%X\r\n", var4.len(arg1))

			return arg0:send(var0 .. arg1 .. "\r\n")
		end
	})
end

local var12 = {
	__index = {}
}

function var8.open(arg0, arg1, arg2)
	local var0 = var0.try((arg2 or var0.tcp)())
	local var1 = var6.setmetatable({
		c = var0
	}, var12)

	var1.try = var0.newtry(function()
		var1:close()
	end)

	var1.try(var0:settimeout(var8.TIMEOUT))
	var1.try(var0:connect(arg0, arg1 or var10))

	return var1
end

function var12.__index.sendrequestline(arg0, arg1, arg2)
	local var0 = var4.format("%s %s HTTP/1.1\r\n", arg1 or "GET", arg2)

	return arg0.try(arg0.c:send(var0))
end

function var12.__index.sendheaders(arg0, arg1)
	local var0 = var5.canonic
	local var1 = "\r\n"

	for iter0, iter1 in var6.pairs(arg1) do
		var1 = (var0[iter0] or iter0) .. ": " .. iter1 .. "\r\n" .. var1
	end

	arg0.try(arg0.c:send(var1))

	return 1
end

function var12.__index.sendbody(arg0, arg1, arg2, arg3)
	arg2 = arg2 or var2.source.empty()
	arg3 = arg3 or var2.pump.step

	local var0 = "http-chunked"

	if arg1["content-length"] then
		var0 = "keep-open"
	end

	return arg0.try(var2.pump.all(arg2, var0.sink(var0, arg0.c), arg3))
end

function var12.__index.receivestatusline(arg0)
	local var0 = arg0.try(arg0.c:receive(5))

	if var0 ~= "HTTP/" then
		return nil, var0
	end

	local var1 = arg0.try(arg0.c:receive("*l", var0))
	local var2 = var0.skip(2, var4.find(var1, "HTTP/%d*%.%d* (%d%d%d)"))

	return arg0.try(var6.tonumber(var2), var1)
end

function var12.__index.receiveheaders(arg0)
	return arg0.try(var11(arg0.c))
end

function var12.__index.receivebody(arg0, arg1, arg2, arg3)
	arg2 = arg2 or var2.sink.null()
	arg3 = arg3 or var2.pump.step

	local var0 = var6.tonumber(arg1["content-length"])
	local var1 = arg1["transfer-encoding"]
	local var2 = "default"

	if var1 and var1 ~= "identity" then
		var2 = "http-chunked"
	elseif var6.tonumber(arg1["content-length"]) then
		var2 = "by-length"
	end

	return arg0.try(var2.pump.all(var0.source(var2, arg0.c, var0), arg2, arg3))
end

function var12.__index.receive09body(arg0, arg1, arg2, arg3)
	local var0 = var2.source.rewind(var0.source("until-closed", arg0.c))

	var0(arg1)

	return arg0.try(var2.pump.all(var0, arg2, arg3))
end

function var12.__index.close(arg0)
	return arg0.c:close()
end

local function var13(arg0)
	local var0 = arg0

	if not arg0.proxy and not var8.PROXY then
		var0 = {
			path = var0.try(arg0.path, "invalid path 'nil'"),
			params = arg0.params,
			query = arg0.query,
			fragment = arg0.fragment
		}
	end

	return var1.build(var0)
end

local function var14(arg0)
	local var0 = arg0.proxy or var8.PROXY

	if var0 then
		local var1 = var1.parse(var0)

		return var1.host, var1.port or 3128
	else
		return arg0.host, arg0.port
	end
end

local function var15(arg0)
	local var0 = var4.gsub(arg0.authority, "^.-@", "")
	local var1 = {
		connection = "close, TE",
		te = "trailers",
		["user-agent"] = var8.USERAGENT,
		host = var0
	}

	if arg0.user and arg0.password then
		var1.authorization = "Basic " .. var3.b64(arg0.user .. ":" .. arg0.password)
	end

	local var2 = arg0.proxy or var8.PROXY

	if var2 then
		local var3 = var1.parse(var2)

		if var3.user and var3.password then
			var1["proxy-authorization"] = "Basic " .. var3.b64(var3.user .. ":" .. var3.password)
		end
	end

	for iter0, iter1 in var6.pairs(arg0.headers or var1) do
		var1[var4.lower(iter0)] = iter1
	end

	return var1
end

local var16 = {
	host = "",
	scheme = "http",
	path = "/",
	port = var10
}

local function var17(arg0)
	local var0 = arg0.url and var1.parse(arg0.url, var16) or {}

	for iter0, iter1 in var6.pairs(arg0) do
		var0[iter0] = iter1
	end

	if var0.port == "" then
		var0.port = var10
	end

	if not var0.host or var0.host == "" then
		var0.try(nil, "invalid host '" .. var6.tostring(var0.host) .. "'")
	end

	var0.uri = arg0.uri or var13(var0)
	var0.headers = var15(var0)
	var0.host, var0.port = var14(var0)

	return var0
end

local function var18(arg0, arg1, arg2)
	local var0 = arg2.location

	if not var0 then
		return false
	end

	local var1 = var4.gsub(var0, "%s", "")

	if var1 == "" then
		return false
	end

	local var2 = var4.match(var1, "^([%w][%w%+%-%.]*)%:")

	if var2 and not var9[var2] then
		return false
	end

	return arg0.redirect ~= false and (arg1 == 301 or arg1 == 302 or arg1 == 303 or arg1 == 307) and (not arg0.method or arg0.method == "GET" or arg0.method == "HEAD") and (not arg0.nredirects or arg0.nredirects < 5)
end

local function var19(arg0, arg1)
	if arg0.method == "HEAD" then
		return nil
	end

	if arg1 == 204 or arg1 == 304 then
		return nil
	end

	if arg1 >= 100 and arg1 < 200 then
		return nil
	end

	return 1
end

local var20
local var21

local function var22(arg0, arg1)
	local var0, var1, var2, var3 = var20({
		url = var1.absolute(arg0.url, arg1),
		source = arg0.source,
		sink = arg0.sink,
		headers = arg0.headers,
		proxy = arg0.proxy,
		nredirects = (arg0.nredirects or 0) + 1,
		create = arg0.create
	})

	var2 = var2 or {}
	var2.location = var2.location or arg1

	return var0, var1, var2, var3
end

function var20(arg0)
	local var0 = var17(arg0)
	local var1 = var8.open(var0.host, var0.port, var0.create)

	var1:sendrequestline(var0.method, var0.uri)
	var1:sendheaders(var0.headers)

	if var0.source then
		var1:sendbody(var0.headers, var0.source, var0.step)
	end

	local var2, var3 = var1:receivestatusline()

	if not var2 then
		var1:receive09body(var3, var0.sink, var0.step)

		return 1, 200
	end

	local var4

	while var2 == 100 do
		local var5 = var1:receiveheaders()

		var2, var3 = var1:receivestatusline()
	end

	local var6 = var1:receiveheaders()

	if var18(var0, var2, var6) and not var0.source then
		var1:close()

		return var22(arg0, var6.location)
	end

	if var19(var0, var2) then
		var1:receivebody(var6, var0.sink, var0.step)
	end

	var1:close()

	return 1, var2, var6, var3
end

local function var23(arg0, arg1)
	local var0 = {}
	local var1 = {
		url = arg0,
		sink = var2.sink.table(var0),
		target = var0
	}

	if arg1 then
		var1.source = var2.source.string(arg1)
		var1.headers = {
			["content-type"] = "application/x-www-form-urlencoded",
			["content-length"] = var4.len(arg1)
		}
		var1.method = "POST"
	end

	return var1
end

var8.genericform = var23

local function var24(arg0, arg1)
	local var0 = var23(arg0, arg1)
	local var1, var2, var3, var4 = var20(var0)

	return var7.concat(var0.target), var2, var3, var4
end

var8.request = var0.protect(function(arg0, arg1)
	if var6.type(arg0) == "string" then
		return var24(arg0, arg1)
	else
		return var20(arg0)
	end
end)

return var8
