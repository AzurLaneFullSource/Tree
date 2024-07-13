local var0_0 = require("jit")

assert(var0_0.version_num == 20100, "LuaJIT core/library version mismatch")

local var1_0 = require("jit.util")
local var2_0 = require("jit.vmdef")
local var3_0 = require("bit")
local var4_0 = string.sub
local var5_0 = string.gsub
local var6_0 = string.format
local var7_0 = string.byte
local var8_0 = var3_0.band
local var9_0 = var3_0.rshift
local var10_0 = var1_0.funcinfo
local var11_0 = var1_0.funcbc
local var12_0 = var1_0.funck
local var13_0 = var1_0.funcuvname
local var14_0 = var2_0.bcnames
local var15_0 = io.stdout
local var16_0 = io.stderr

local function var17_0(arg0_1)
	if arg0_1 == "\n" then
		return "\\n"
	elseif arg0_1 == "\r" then
		return "\\r"
	elseif arg0_1 == "\t" then
		return "\\t"
	else
		return var6_0("\\%03d", var7_0(arg0_1))
	end
end

local function var18_0(arg0_2, arg1_2, arg2_2)
	local var0_2, var1_2 = var11_0(arg0_2, arg1_2)

	if not var0_2 then
		return
	end

	local var2_2 = var8_0(var1_2, 7)
	local var3_2 = var8_0(var1_2, 120)
	local var4_2 = var8_0(var1_2, 1920)
	local var5_2 = var8_0(var9_0(var0_2, 8), 255)
	local var6_2 = 6 * var8_0(var0_2, 255)
	local var7_2 = var4_0(var14_0, var6_2 + 1, var6_2 + 6)
	local var8_2 = var6_0("%04d %s %-6s %3s ", arg1_2, arg2_2 or "  ", var7_2, var2_2 == 0 and "" or var5_2)
	local var9_2 = var9_0(var0_2, 16)

	if var4_2 == 1664 then
		return var6_0("%s=> %04d\n", var8_2, arg1_2 + var9_2 - 32767)
	end

	if var3_2 ~= 0 then
		var9_2 = var8_0(var9_2, 255)
	elseif var4_2 == 0 then
		return var8_2 .. "\n"
	end

	local var10_2

	if var4_2 == 1280 then
		var10_2 = var12_0(arg0_2, -var9_2 - 1)
		var10_2 = var6_0(#var10_2 > 40 and "\"%.40s\"~" or "\"%s\"", var5_0(var10_2, "%c", var17_0))
	elseif var4_2 == 1152 then
		var10_2 = var12_0(arg0_2, var9_2)

		if var7_2 == "TSETM " then
			var10_2 = var10_2 - 4.5035996273705e+15
		end
	elseif var4_2 == 1536 then
		local var11_2 = var10_0(var12_0(arg0_2, -var9_2 - 1))

		if var11_2.ffid then
			var10_2 = var2_0.ffnames[var11_2.ffid]
		else
			var10_2 = var11_2.loc
		end
	elseif var4_2 == 640 then
		var10_2 = var13_0(arg0_2, var9_2)
	end

	if var2_2 == 5 then
		local var12_2 = var13_0(arg0_2, var5_2)

		if var10_2 then
			var10_2 = var12_2 .. " ; " .. var10_2
		else
			var10_2 = var12_2
		end
	end

	if var3_2 ~= 0 then
		local var13_2 = var9_0(var0_2, 24)

		if var10_2 then
			return var6_0("%s%3d %3d  ; %s\n", var8_2, var13_2, var9_2, var10_2)
		end

		return var6_0("%s%3d %3d\n", var8_2, var13_2, var9_2)
	end

	if var10_2 then
		return var6_0("%s%3d      ; %s\n", var8_2, var9_2, var10_2)
	end

	if var4_2 == 896 and var9_2 > 32767 then
		var9_2 = var9_2 - 65536
	end

	return var6_0("%s%3d\n", var8_2, var9_2)
end

local function var19_0(arg0_3)
	local var0_3 = {}

	for iter0_3 = 1, 1000000000 do
		local var1_3, var2_3 = var11_0(arg0_3, iter0_3)

		if not var1_3 then
			break
		end

		if var8_0(var2_3, 1920) == 1664 then
			var0_3[iter0_3 + var9_0(var1_3, 16) - 32767] = true
		end
	end

	return var0_3
end

local function var20_0(arg0_4, arg1_4, arg2_4)
	arg1_4 = arg1_4 or var15_0

	local var0_4 = var10_0(arg0_4)

	if arg2_4 and var0_4.children then
		for iter0_4 = -1, -1000000000, -1 do
			local var1_4 = var12_0(arg0_4, iter0_4)

			if not var1_4 then
				break
			end

			if type(var1_4) == "proto" then
				var20_0(var1_4, arg1_4, true)
			end
		end
	end

	arg1_4:write(var6_0("-- BYTECODE -- %s-%d\n", var0_4.loc, var0_4.lastlinedefined))

	local var2_4 = var19_0(arg0_4)

	for iter1_4 = 1, 1000000000 do
		local var3_4 = var18_0(arg0_4, iter1_4, var2_4[iter1_4] and "=>")

		if not var3_4 then
			break
		end

		arg1_4:write(var3_4)
	end

	arg1_4:write("\n")
	arg1_4:flush()
end

local var21_0
local var22_0

local function var23_0(arg0_5)
	return var20_0(arg0_5, var22_0)
end

local function var24_0()
	if var21_0 then
		var21_0 = false

		var0_0.attach(var23_0)

		if var22_0 and var22_0 ~= var15_0 and var22_0 ~= var16_0 then
			var22_0:close()
		end

		var22_0 = nil
	end
end

local function var25_0(arg0_7)
	if var21_0 then
		var24_0()
	end

	arg0_7 = arg0_7 or os.getenv("LUAJIT_LISTFILE")

	if arg0_7 then
		var22_0 = arg0_7 == "-" and var15_0 or assert(io.open(arg0_7, "w"))
	else
		var22_0 = var16_0
	end

	var0_0.attach(var23_0, "bc")

	var21_0 = true
end

return {
	line = var18_0,
	dump = var20_0,
	targets = var19_0,
	on = var25_0,
	off = var24_0,
	start = var25_0
}
