local var0_0 = _G
local var1_0 = require("string")
local var2_0 = require("socket")
local var3_0 = require("ltn12")

var2_0.tp = {}

local var4_0 = var2_0.tp

var4_0.TIMEOUT = 60

local function var5_0(arg0_1)
	local var0_1
	local var1_1
	local var2_1
	local var3_1, var4_1 = arg0_1:receive()
	local var5_1 = var3_1

	if var4_1 then
		return nil, var4_1
	end

	local var6_1, var7_1 = var2_0.skip(2, var1_0.find(var3_1, "^(%d%d%d)(.?)"))

	if not var6_1 then
		return nil, "invalid server reply"
	end

	if var7_1 == "-" then
		repeat
			local var8_1, var9_1 = arg0_1:receive()

			if var9_1 then
				return nil, var9_1
			end

			local var10_1, var11_1 = var2_0.skip(2, var1_0.find(var8_1, "^(%d%d%d)(.?)"))

			var5_1 = var5_1 .. "\n" .. var8_1
		until var6_1 == var10_1 and var11_1 == " "
	end

	return var6_1, var5_1
end

local var6_0 = {
	__index = {}
}

function var6_0.__index.getpeername(arg0_2)
	return arg0_2.c:getpeername()
end

function var6_0.__index.getsockname(arg0_3)
	return arg0_3.c:getpeername()
end

function var6_0.__index.check(arg0_4, arg1_4)
	local var0_4, var1_4 = var5_0(arg0_4.c)

	if not var0_4 then
		return nil, var1_4
	end

	if var0_0.type(arg1_4) ~= "function" then
		if var0_0.type(arg1_4) == "table" then
			for iter0_4, iter1_4 in var0_0.ipairs(arg1_4) do
				if var1_0.find(var0_4, iter1_4) then
					return var0_0.tonumber(var0_4), var1_4
				end
			end

			return nil, var1_4
		elseif var1_0.find(var0_4, arg1_4) then
			return var0_0.tonumber(var0_4), var1_4
		else
			return nil, var1_4
		end
	else
		return arg1_4(var0_0.tonumber(var0_4), var1_4)
	end
end

function var6_0.__index.command(arg0_5, arg1_5, arg2_5)
	arg1_5 = var1_0.upper(arg1_5)

	if arg2_5 then
		return arg0_5.c:send(arg1_5 .. " " .. arg2_5 .. "\r\n")
	else
		return arg0_5.c:send(arg1_5 .. "\r\n")
	end
end

function var6_0.__index.sink(arg0_6, arg1_6, arg2_6)
	local var0_6, var1_6 = arg0_6.c:receive(arg2_6)

	return arg1_6(var0_6, var1_6)
end

function var6_0.__index.send(arg0_7, arg1_7)
	return arg0_7.c:send(arg1_7)
end

function var6_0.__index.receive(arg0_8, arg1_8)
	return arg0_8.c:receive(arg1_8)
end

function var6_0.__index.getfd(arg0_9)
	return arg0_9.c:getfd()
end

function var6_0.__index.dirty(arg0_10)
	return arg0_10.c:dirty()
end

function var6_0.__index.getcontrol(arg0_11)
	return arg0_11.c
end

function var6_0.__index.source(arg0_12, arg1_12, arg2_12)
	local var0_12 = var2_0.sink("keep-open", arg0_12.c)
	local var1_12, var2_12 = var3_0.pump.all(arg1_12, var0_12, arg2_12 or var3_0.pump.step)

	return var1_12, var2_12
end

function var6_0.__index.close(arg0_13)
	arg0_13.c:close()

	return 1
end

function var4_0.connect(arg0_14, arg1_14, arg2_14, arg3_14)
	local var0_14, var1_14 = (arg3_14 or var2_0.tcp)()

	if not var0_14 then
		return nil, var1_14
	end

	var0_14:settimeout(arg2_14 or var4_0.TIMEOUT)

	local var2_14, var3_14 = var0_14:connect(arg0_14, arg1_14)

	if not var2_14 then
		var0_14:close()

		return nil, var3_14
	end

	return var0_0.setmetatable({
		c = var0_14
	}, var6_0)
end

return var4_0
