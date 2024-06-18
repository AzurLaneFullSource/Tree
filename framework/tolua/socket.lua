local var0_0 = _G
local var1_0 = require("string")
local var2_0 = require("math")
local var3_0 = require("socket.core")
local var4_0 = var3_0

function var4_0.connect4(arg0_1, arg1_1, arg2_1, arg3_1)
	return var3_0.connect(arg0_1, arg1_1, arg2_1, arg3_1, "inet")
end

function var4_0.connect6(arg0_2, arg1_2, arg2_2, arg3_2)
	return var3_0.connect(arg0_2, arg1_2, arg2_2, arg3_2, "inet6")
end

function var4_0.bind(arg0_3, arg1_3, arg2_3)
	if arg0_3 == "*" then
		arg0_3 = "0.0.0.0"
	end

	local var0_3, var1_3 = var3_0.dns.getaddrinfo(arg0_3)

	if not var0_3 then
		return nil, var1_3
	end

	local var2_3
	local var3_3
	local var4_3 = "no info on address"

	for iter0_3, iter1_3 in var0_0.ipairs(var0_3) do
		if iter1_3.family == "inet" then
			var2_3, var4_3 = var3_0.tcp4()
		else
			var2_3, var4_3 = var3_0.tcp6()
		end

		if not var2_3 then
			return nil, var4_3
		end

		var2_3:setoption("reuseaddr", true)

		local var5_3, var6_3 = var2_3:bind(iter1_3.addr, arg1_3)

		var4_3 = var6_3

		if not var5_3 then
			var2_3:close()
		else
			local var7_3, var8_3 = var2_3:listen(arg2_3)

			var4_3 = var8_3

			if not var7_3 then
				var2_3:close()
			else
				return var2_3
			end
		end
	end

	return nil, var4_3
end

var4_0.try = var4_0.newtry()

function var4_0.choose(arg0_4)
	return function(arg0_5, arg1_5, arg2_5)
		if var0_0.type(arg0_5) ~= "string" then
			arg0_5, arg1_5, arg2_5 = "default", arg0_5, arg1_5
		end

		local var0_5 = arg0_4[arg0_5 or "nil"]

		if not var0_5 then
			var0_0.error("unknown key (" .. var0_0.tostring(arg0_5) .. ")", 3)
		else
			return var0_5(arg1_5, arg2_5)
		end
	end
end

local var5_0 = {}
local var6_0 = {}

var4_0.sourcet = var5_0
var4_0.sinkt = var6_0
var4_0.BLOCKSIZE = 2048
var6_0["close-when-done"] = function(arg0_6)
	return var0_0.setmetatable({
		getfd = function()
			return arg0_6:getfd()
		end,
		dirty = function()
			return arg0_6:dirty()
		end
	}, {
		__call = function(arg0_9, arg1_9, arg2_9)
			if not arg1_9 then
				arg0_6:close()

				return 1
			else
				return arg0_6:send(arg1_9)
			end
		end
	})
end
var6_0["keep-open"] = function(arg0_10)
	return var0_0.setmetatable({
		getfd = function()
			return arg0_10:getfd()
		end,
		dirty = function()
			return arg0_10:dirty()
		end
	}, {
		__call = function(arg0_13, arg1_13, arg2_13)
			if arg1_13 then
				return arg0_10:send(arg1_13)
			else
				return 1
			end
		end
	})
end
var6_0.default = var6_0["keep-open"]
var4_0.sink = var4_0.choose(var6_0)
var5_0["by-length"] = function(arg0_14, arg1_14)
	return var0_0.setmetatable({
		getfd = function()
			return arg0_14:getfd()
		end,
		dirty = function()
			return arg0_14:dirty()
		end
	}, {
		__call = function()
			if arg1_14 <= 0 then
				return nil
			end

			local var0_17 = var2_0.min(var3_0.BLOCKSIZE, arg1_14)
			local var1_17, var2_17 = arg0_14:receive(var0_17)

			if var2_17 then
				return nil, var2_17
			end

			arg1_14 = arg1_14 - var1_0.len(var1_17)

			return var1_17
		end
	})
end
var5_0["until-closed"] = function(arg0_18)
	local var0_18

	return var0_0.setmetatable({
		getfd = function()
			return arg0_18:getfd()
		end,
		dirty = function()
			return arg0_18:dirty()
		end
	}, {
		__call = function()
			if var0_18 then
				return nil
			end

			local var0_21, var1_21, var2_21 = arg0_18:receive(var3_0.BLOCKSIZE)

			if not var1_21 then
				return var0_21
			elseif var1_21 == "closed" then
				arg0_18:close()

				var0_18 = 1

				return var2_21
			else
				return nil, var1_21
			end
		end
	})
end
var5_0.default = var5_0["until-closed"]
var4_0.source = var4_0.choose(var5_0)

return var4_0
