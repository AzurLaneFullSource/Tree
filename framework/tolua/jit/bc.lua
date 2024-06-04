local var0 = require("jit")

assert(var0.version_num == 20100, "LuaJIT core/library version mismatch")

local var1 = require("jit.util")
local var2 = require("jit.vmdef")
local var3 = require("bit")
local var4 = string.sub
local var5 = string.gsub
local var6 = string.format
local var7 = string.byte
local var8 = var3.band
local var9 = var3.rshift
local var10 = var1.funcinfo
local var11 = var1.funcbc
local var12 = var1.funck
local var13 = var1.funcuvname
local var14 = var2.bcnames
local var15 = io.stdout
local var16 = io.stderr

local function var17(arg0)
	if arg0 == "\n" then
		return "\\n"
	elseif arg0 == "\r" then
		return "\\r"
	elseif arg0 == "\t" then
		return "\\t"
	else
		return var6("\\%03d", var7(arg0))
	end
end

local function var18(arg0, arg1, arg2)
	local var0, var1 = var11(arg0, arg1)

	if not var0 then
		return
	end

	local var2 = var8(var1, 7)
	local var3 = var8(var1, 120)
	local var4 = var8(var1, 1920)
	local var5 = var8(var9(var0, 8), 255)
	local var6 = 6 * var8(var0, 255)
	local var7 = var4(var14, var6 + 1, var6 + 6)
	local var8 = var6("%04d %s %-6s %3s ", arg1, arg2 or "  ", var7, var2 == 0 and "" or var5)
	local var9 = var9(var0, 16)

	if var4 == 1664 then
		return var6("%s=> %04d\n", var8, arg1 + var9 - 32767)
	end

	if var3 ~= 0 then
		var9 = var8(var9, 255)
	elseif var4 == 0 then
		return var8 .. "\n"
	end

	local var10

	if var4 == 1280 then
		var10 = var12(arg0, -var9 - 1)
		var10 = var6(#var10 > 40 and "\"%.40s\"~" or "\"%s\"", var5(var10, "%c", var17))
	elseif var4 == 1152 then
		var10 = var12(arg0, var9)

		if var7 == "TSETM " then
			var10 = var10 - 4.5035996273705e+15
		end
	elseif var4 == 1536 then
		local var11 = var10(var12(arg0, -var9 - 1))

		if var11.ffid then
			var10 = var2.ffnames[var11.ffid]
		else
			var10 = var11.loc
		end
	elseif var4 == 640 then
		var10 = var13(arg0, var9)
	end

	if var2 == 5 then
		local var12 = var13(arg0, var5)

		if var10 then
			var10 = var12 .. " ; " .. var10
		else
			var10 = var12
		end
	end

	if var3 ~= 0 then
		local var13 = var9(var0, 24)

		if var10 then
			return var6("%s%3d %3d  ; %s\n", var8, var13, var9, var10)
		end

		return var6("%s%3d %3d\n", var8, var13, var9)
	end

	if var10 then
		return var6("%s%3d      ; %s\n", var8, var9, var10)
	end

	if var4 == 896 and var9 > 32767 then
		var9 = var9 - 65536
	end

	return var6("%s%3d\n", var8, var9)
end

local function var19(arg0)
	local var0 = {}

	for iter0 = 1, 1000000000 do
		local var1, var2 = var11(arg0, iter0)

		if not var1 then
			break
		end

		if var8(var2, 1920) == 1664 then
			var0[iter0 + var9(var1, 16) - 32767] = true
		end
	end

	return var0
end

local function var20(arg0, arg1, arg2)
	arg1 = arg1 or var15

	local var0 = var10(arg0)

	if arg2 and var0.children then
		for iter0 = -1, -1000000000, -1 do
			local var1 = var12(arg0, iter0)

			if not var1 then
				break
			end

			if type(var1) == "proto" then
				var20(var1, arg1, true)
			end
		end
	end

	arg1:write(var6("-- BYTECODE -- %s-%d\n", var0.loc, var0.lastlinedefined))

	local var2 = var19(arg0)

	for iter1 = 1, 1000000000 do
		local var3 = var18(arg0, iter1, var2[iter1] and "=>")

		if not var3 then
			break
		end

		arg1:write(var3)
	end

	arg1:write("\n")
	arg1:flush()
end

local var21
local var22

local function var23(arg0)
	return var20(arg0, var22)
end

local function var24()
	if var21 then
		var21 = false

		var0.attach(var23)

		if var22 and var22 ~= var15 and var22 ~= var16 then
			var22:close()
		end

		var22 = nil
	end
end

local function var25(arg0)
	if var21 then
		var24()
	end

	arg0 = arg0 or os.getenv("LUAJIT_LISTFILE")

	if arg0 then
		var22 = arg0 == "-" and var15 or assert(io.open(arg0, "w"))
	else
		var22 = var16
	end

	var0.attach(var23, "bc")

	var21 = true
end

return {
	line = var18,
	dump = var20,
	targets = var19,
	on = var25,
	off = var24,
	start = var25
}
