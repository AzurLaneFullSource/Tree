local var0 = _G
local var1 = require("string")
local var2 = require("math")
local var3 = require("socket.core")
local var4 = var3

function var4.connect4(arg0, arg1, arg2, arg3)
	return var3.connect(arg0, arg1, arg2, arg3, "inet")
end

function var4.connect6(arg0, arg1, arg2, arg3)
	return var3.connect(arg0, arg1, arg2, arg3, "inet6")
end

function var4.bind(arg0, arg1, arg2)
	if arg0 == "*" then
		arg0 = "0.0.0.0"
	end

	local var0, var1 = var3.dns.getaddrinfo(arg0)

	if not var0 then
		return nil, var1
	end

	local var2
	local var3
	local var4 = "no info on address"

	for iter0, iter1 in var0.ipairs(var0) do
		if iter1.family == "inet" then
			var2, var4 = var3.tcp4()
		else
			var2, var4 = var3.tcp6()
		end

		if not var2 then
			return nil, var4
		end

		var2:setoption("reuseaddr", true)

		local var5, var6 = var2:bind(iter1.addr, arg1)

		var4 = var6

		if not var5 then
			var2:close()
		else
			local var7, var8 = var2:listen(arg2)

			var4 = var8

			if not var7 then
				var2:close()
			else
				return var2
			end
		end
	end

	return nil, var4
end

var4.try = var4.newtry()

function var4.choose(arg0)
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

local var5 = {}
local var6 = {}

var4.sourcet = var5
var4.sinkt = var6
var4.BLOCKSIZE = 2048
var6["close-when-done"] = function(arg0)
	return var0.setmetatable({
		getfd = function()
			return arg0:getfd()
		end,
		dirty = function()
			return arg0:dirty()
		end
	}, {
		__call = function(arg0, arg1, arg2)
			if not arg1 then
				arg0:close()

				return 1
			else
				return arg0:send(arg1)
			end
		end
	})
end
var6["keep-open"] = function(arg0)
	return var0.setmetatable({
		getfd = function()
			return arg0:getfd()
		end,
		dirty = function()
			return arg0:dirty()
		end
	}, {
		__call = function(arg0, arg1, arg2)
			if arg1 then
				return arg0:send(arg1)
			else
				return 1
			end
		end
	})
end
var6.default = var6["keep-open"]
var4.sink = var4.choose(var6)
var5["by-length"] = function(arg0, arg1)
	return var0.setmetatable({
		getfd = function()
			return arg0:getfd()
		end,
		dirty = function()
			return arg0:dirty()
		end
	}, {
		__call = function()
			if arg1 <= 0 then
				return nil
			end

			local var0 = var2.min(var3.BLOCKSIZE, arg1)
			local var1, var2 = arg0:receive(var0)

			if var2 then
				return nil, var2
			end

			arg1 = arg1 - var1.len(var1)

			return var1
		end
	})
end
var5["until-closed"] = function(arg0)
	local var0

	return var0.setmetatable({
		getfd = function()
			return arg0:getfd()
		end,
		dirty = function()
			return arg0:dirty()
		end
	}, {
		__call = function()
			if var0 then
				return nil
			end

			local var0, var1, var2 = arg0:receive(var3.BLOCKSIZE)

			if not var1 then
				return var0
			elseif var1 == "closed" then
				arg0:close()

				var0 = 1

				return var2
			else
				return nil, var1
			end
		end
	})
end
var5.default = var5["until-closed"]
var4.source = var4.choose(var5)

return var4
