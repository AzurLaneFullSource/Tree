local var0_0 = require("jit")

assert(var0_0.version_num == 20100, "LuaJIT core/library version mismatch")

local var1_0 = require("jit.util")
local var2_0 = require("jit.vmdef")
local var3_0 = var1_0.funcinfo
local var4_0 = var1_0.traceinfo
local var5_0 = type
local var6_0 = string.format
local var7_0 = io.stdout
local var8_0 = io.stderr
local var9_0
local var10_0
local var11_0
local var12_0

local function var13_0(arg0_1, arg1_1)
	local var0_1 = var3_0(arg0_1, arg1_1)

	if var0_1.loc then
		return var0_1.loc
	elseif var0_1.ffid then
		return var2_0.ffnames[var0_1.ffid]
	elseif var0_1.addr then
		return var6_0("C:%x", var0_1.addr)
	else
		return "(?)"
	end
end

local function var14_0(arg0_2, arg1_2)
	if var5_0(arg0_2) == "number" then
		if var5_0(arg1_2) == "function" then
			arg1_2 = var13_0(arg1_2)
		end

		arg0_2 = var6_0(var2_0.traceerr[arg0_2], arg1_2)
	end

	return arg0_2
end

local function var15_0(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3, arg5_3)
	if arg0_3 == "start" then
		var11_0 = var13_0(arg2_3, arg3_3)
		var12_0 = arg4_3 and "(" .. arg4_3 .. "/" .. (arg5_3 == -1 and "stitch" or arg5_3) .. ") " or ""
	else
		if arg0_3 == "abort" then
			local var0_3 = var13_0(arg2_3, arg3_3)

			if var0_3 ~= var11_0 then
				print(var6_0("[TRACE --- %s%s -- %s at %s]\n", var12_0, var11_0, var14_0(arg4_3, arg5_3), var0_3))
			else
				print(var6_0("[TRACE --- %s%s -- %s]\n", var12_0, var11_0, var14_0(arg4_3, arg5_3)))
			end
		elseif arg0_3 == "stop" then
			local var1_3 = var4_0(arg1_3)
			local var2_3 = var1_3.link
			local var3_3 = var1_3.linktype

			if var3_3 == "interpreter" then
				print(var6_0("[TRACE %3s %s%s -- fallback to interpreter]\n", arg1_3, var12_0, var11_0))
			elseif var3_3 == "stitch" then
				print(var6_0("[TRACE %3s %s%s %s %s]\n", arg1_3, var12_0, var11_0, var3_3, var13_0(arg2_3, arg3_3)))
			elseif var2_3 == arg1_3 or var2_3 == 0 then
				print(var6_0("[TRACE %3s %s%s %s]\n", arg1_3, var12_0, var11_0, var3_3))
			elseif var3_3 == "root" then
				print(var6_0("[TRACE %3s %s%s -> %d]\n", arg1_3, var12_0, var11_0, var2_3))
			else
				print(var6_0("[TRACE %3s %s%s -> %d %s]\n", arg1_3, var12_0, var11_0, var2_3, var3_3))
			end
		else
			print(var6_0("[TRACE %s]\n", arg0_3))
		end

		var10_0:flush()
	end
end

local function var16_0()
	if var9_0 then
		var9_0 = false

		var0_0.attach(var15_0)

		if var10_0 and var10_0 ~= var7_0 and var10_0 ~= var8_0 then
			var10_0:close()
		end

		var10_0 = nil
	end
end

local function var17_0(arg0_5)
	if var9_0 then
		var16_0()
	end

	arg0_5 = arg0_5 or os.getenv("LUAJIT_VERBOSEFILE")

	if arg0_5 then
		var10_0 = arg0_5 == "-" and var7_0 or assert(io.open(arg0_5, "w"))
	else
		var10_0 = var8_0
	end

	var0_0.attach(var15_0, "trace")

	var9_0 = true
end

return {
	on = var17_0,
	off = var16_0,
	start = var17_0
}
