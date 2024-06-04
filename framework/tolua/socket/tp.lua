local var0 = _G
local var1 = require("string")
local var2 = require("socket")
local var3 = require("ltn12")

var2.tp = {}

local var4 = var2.tp

var4.TIMEOUT = 60

local function var5(arg0)
	local var0
	local var1
	local var2
	local var3, var4 = arg0:receive()
	local var5 = var3

	if var4 then
		return nil, var4
	end

	local var6, var7 = var2.skip(2, var1.find(var3, "^(%d%d%d)(.?)"))

	if not var6 then
		return nil, "invalid server reply"
	end

	if var7 == "-" then
		repeat
			local var8, var9 = arg0:receive()

			if var9 then
				return nil, var9
			end

			local var10, var11 = var2.skip(2, var1.find(var8, "^(%d%d%d)(.?)"))

			var5 = var5 .. "\n" .. var8
		until var6 == var10 and var11 == " "
	end

	return var6, var5
end

local var6 = {
	__index = {}
}

function var6.__index.getpeername(arg0)
	return arg0.c:getpeername()
end

function var6.__index.getsockname(arg0)
	return arg0.c:getpeername()
end

function var6.__index.check(arg0, arg1)
	local var0, var1 = var5(arg0.c)

	if not var0 then
		return nil, var1
	end

	if var0.type(arg1) ~= "function" then
		if var0.type(arg1) == "table" then
			for iter0, iter1 in var0.ipairs(arg1) do
				if var1.find(var0, iter1) then
					return var0.tonumber(var0), var1
				end
			end

			return nil, var1
		elseif var1.find(var0, arg1) then
			return var0.tonumber(var0), var1
		else
			return nil, var1
		end
	else
		return arg1(var0.tonumber(var0), var1)
	end
end

function var6.__index.command(arg0, arg1, arg2)
	arg1 = var1.upper(arg1)

	if arg2 then
		return arg0.c:send(arg1 .. " " .. arg2 .. "\r\n")
	else
		return arg0.c:send(arg1 .. "\r\n")
	end
end

function var6.__index.sink(arg0, arg1, arg2)
	local var0, var1 = arg0.c:receive(arg2)

	return arg1(var0, var1)
end

function var6.__index.send(arg0, arg1)
	return arg0.c:send(arg1)
end

function var6.__index.receive(arg0, arg1)
	return arg0.c:receive(arg1)
end

function var6.__index.getfd(arg0)
	return arg0.c:getfd()
end

function var6.__index.dirty(arg0)
	return arg0.c:dirty()
end

function var6.__index.getcontrol(arg0)
	return arg0.c
end

function var6.__index.source(arg0, arg1, arg2)
	local var0 = var2.sink("keep-open", arg0.c)
	local var1, var2 = var3.pump.all(arg1, var0, arg2 or var3.pump.step)

	return var1, var2
end

function var6.__index.close(arg0)
	arg0.c:close()

	return 1
end

function var4.connect(arg0, arg1, arg2, arg3)
	local var0, var1 = (arg3 or var2.tcp)()

	if not var0 then
		return nil, var1
	end

	var0:settimeout(arg2 or var4.TIMEOUT)

	local var2, var3 = var0:connect(arg0, arg1)

	if not var2 then
		var0:close()

		return nil, var3
	end

	return var0.setmetatable({
		c = var0
	}, var6)
end

return var4
