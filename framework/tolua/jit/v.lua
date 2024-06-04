local var0 = require("jit")

assert(var0.version_num == 20100, "LuaJIT core/library version mismatch")

local var1 = require("jit.util")
local var2 = require("jit.vmdef")
local var3 = var1.funcinfo
local var4 = var1.traceinfo
local var5 = type
local var6 = string.format
local var7 = io.stdout
local var8 = io.stderr
local var9
local var10
local var11
local var12

local function var13(arg0, arg1)
	local var0 = var3(arg0, arg1)

	if var0.loc then
		return var0.loc
	elseif var0.ffid then
		return var2.ffnames[var0.ffid]
	elseif var0.addr then
		return var6("C:%x", var0.addr)
	else
		return "(?)"
	end
end

local function var14(arg0, arg1)
	if var5(arg0) == "number" then
		if var5(arg1) == "function" then
			arg1 = var13(arg1)
		end

		arg0 = var6(var2.traceerr[arg0], arg1)
	end

	return arg0
end

local function var15(arg0, arg1, arg2, arg3, arg4, arg5)
	if arg0 == "start" then
		var11 = var13(arg2, arg3)
		var12 = arg4 and "(" .. arg4 .. "/" .. (arg5 == -1 and "stitch" or arg5) .. ") " or ""
	else
		if arg0 == "abort" then
			local var0 = var13(arg2, arg3)

			if var0 ~= var11 then
				print(var6("[TRACE --- %s%s -- %s at %s]\n", var12, var11, var14(arg4, arg5), var0))
			else
				print(var6("[TRACE --- %s%s -- %s]\n", var12, var11, var14(arg4, arg5)))
			end
		elseif arg0 == "stop" then
			local var1 = var4(arg1)
			local var2 = var1.link
			local var3 = var1.linktype

			if var3 == "interpreter" then
				print(var6("[TRACE %3s %s%s -- fallback to interpreter]\n", arg1, var12, var11))
			elseif var3 == "stitch" then
				print(var6("[TRACE %3s %s%s %s %s]\n", arg1, var12, var11, var3, var13(arg2, arg3)))
			elseif var2 == arg1 or var2 == 0 then
				print(var6("[TRACE %3s %s%s %s]\n", arg1, var12, var11, var3))
			elseif var3 == "root" then
				print(var6("[TRACE %3s %s%s -> %d]\n", arg1, var12, var11, var2))
			else
				print(var6("[TRACE %3s %s%s -> %d %s]\n", arg1, var12, var11, var2, var3))
			end
		else
			print(var6("[TRACE %s]\n", arg0))
		end

		var10:flush()
	end
end

local function var16()
	if var9 then
		var9 = false

		var0.attach(var15)

		if var10 and var10 ~= var7 and var10 ~= var8 then
			var10:close()
		end

		var10 = nil
	end
end

local function var17(arg0)
	if var9 then
		var16()
	end

	arg0 = arg0 or os.getenv("LUAJIT_VERBOSEFILE")

	if arg0 then
		var10 = arg0 == "-" and var7 or assert(io.open(arg0, "w"))
	else
		var10 = var8
	end

	var0.attach(var15, "trace")

	var9 = true
end

return {
	on = var17,
	off = var16,
	start = var17
}
