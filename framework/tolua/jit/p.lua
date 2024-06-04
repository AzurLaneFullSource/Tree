local var0 = require("jit")

assert(var0.version_num == 20100, "LuaJIT core/library version mismatch")

local var1 = require("jit.profile")
local var2 = require("jit.vmdef")
local var3 = math
local var4 = pairs
local var5 = ipairs
local var6 = tonumber
local var7 = var3.floor
local var8 = table.sort
local var9 = string.format
local var10 = io.stdout
local var11
local var12
local var13
local var14
local var15
local var16
local var17
local var18
local var19
local var20
local var21
local var22
local var23
local var24 = {
	G = "Garbage Collector",
	C = "C code",
	N = "Compiled",
	J = "JIT Compiler",
	I = "Interpreted"
}

local function var25(arg0, arg1, arg2)
	var23 = var23 + arg1

	local var0
	local var1
	local var2

	if var14 then
		if var14 == "v" then
			var2 = var24[arg2] or arg2
		else
			var2 = var11:get() or "(none)"
		end
	end

	if var18 then
		var0 = var1.dumpstack(arg0, var18, var19)
		var0 = var0:gsub("%[builtin#(%d+)%]", function(arg0)
			return var2.ffnames[var6(arg0)]
		end)

		if var15 == 2 then
			local var3, var4 = var0:match("(.-) [<>] (.*)")

			if var4 then
				var0, var1 = var3, var4
			end
		elseif var15 == 3 then
			var1 = var1.dumpstack(arg0, "l", 1)
		end
	end

	local var5
	local var6

	if var15 == 1 then
		if var2 then
			var5 = var2

			if var0 then
				var6 = var0
			end
		end
	elseif var0 then
		var5 = var0

		if var1 then
			var6 = var1
		elseif var2 then
			var6 = var2
		end
	end

	if var5 then
		local var7 = var21

		var7[var5] = (var7[var5] or 0) + arg1

		if var6 then
			local var8 = var22
			local var9 = var8[var5]

			if not var9 then
				var9 = {}
				var8[var5] = var9
			end

			var9[var6] = (var9[var6] or 0) + arg1
		end
	end
end

local function var26(arg0, arg1, arg2, arg3)
	local var0 = {}
	local var1 = 0

	for iter0 in var4(arg0) do
		var1 = var1 + 1
		var0[var1] = iter0
	end

	var8(var0, function(arg0, arg1)
		return arg0[arg0] > arg0[arg1]
	end)

	for iter1 = 1, var1 do
		local var2 = var0[iter1]
		local var3 = arg0[var2]
		local var4 = var7(var3 * 100 / arg2 + 0.5)

		if var4 < var16 then
			break
		end

		if not var17 then
			var12:write(var9("%s%2d%%  %s\n", arg3, var4, var2))
		elseif var17 == "r" then
			var12:write(var9("%s%5d  %s\n", arg3, var3, var2))
		else
			var12:write(var9("%s %d\n", var2, var3))
		end

		if arg1 then
			local var5 = arg1[var2]

			if var5 then
				var26(var5, nil, var3, (var15 == 3 or var15 == 1) and "  -- " or var19 < 0 and "  -> " or "  <- ")
			end
		end
	end
end

local function var27(arg0, arg1)
	local var0 = {}
	local var1 = 0

	for iter0, iter1 in var4(arg0) do
		local var2 = var7(iter1 * 100 / arg1 + 0.5)

		var1 = var3.max(var1, iter1)

		if var2 >= var16 then
			local var3, var4 = iter0:match("^(.*):(%d+)$")

			if not var3 then
				var3 = iter0
				var4 = 0
			end

			local var5 = var0[var3]

			if not var5 then
				var5 = {}
				var0[var3] = var5
				var0[#var0 + 1] = var3
			end

			var5[var6(var4)] = var17 and iter1 or var2
		end
	end

	var8(var0)

	local var6 = " %3d%% | %s\n"
	local var7 = "      | %s\n"

	if var17 then
		local var8 = var3.max(5, var3.ceil(var3.log10(var1)))

		var6 = "%" .. var8 .. "d | %s\n"
		var7 = (" "):rep(var8) .. " | %s\n"
	end

	local var9 = var20

	for iter2, iter3 in var5(var0) do
		local var10 = iter3:byte()

		if var10 == 40 or var10 == 91 then
			var12:write(var9("\n====== %s ======\n[Cannot annotate non-file]\n", iter3))

			break
		end

		local var11, var12 = io.open(iter3)

		if not var11 then
			var12:write(var9("====== ERROR: %s: %s\n", iter3, var12))

			break
		end

		var12:write(var9("\n====== %s ======\n", iter3))

		local var13 = var0[iter3]
		local var14 = 1
		local var15 = false

		if var9 ~= 0 then
			for iter4 = 1, var9 do
				if var13[iter4] then
					var15 = true

					var12:write("@@ 1 @@\n")

					break
				end
			end
		end

		for iter5 in var11:lines() do
			if iter5:byte() == 27 then
				var12:write("[Cannot annotate bytecode file]\n")

				break
			end

			local var16 = var13[var14]

			if var9 ~= 0 then
				local var17 = var13[var14 + var9]

				if var15 then
					if var17 then
						var15 = var14 + var9
					elseif var16 then
						var15 = var14
					elseif var14 > var15 + var9 then
						var15 = false
					end
				elseif var17 then
					var15 = var14 + var9

					var12:write(var9("@@ %d @@\n", var14))
				end

				if not var15 then
					goto label0_
				end
			end

			if var16 then
				var12:write(var9(var6, var16, iter5))
			else
				var12:write(var9(var7, iter5))
			end

			::label0_::

			var14 = var14 + 1
		end

		var11:close()
	end
end

local function var28()
	if var13 then
		var1.stop()

		local var0 = var23

		if var0 == 0 then
			if var17 ~= true then
				var12:write("[No samples collected]\n")
			end

			return
		end

		if var20 then
			var27(var21, var0)
		else
			var26(var21, var22, var0, "")
		end

		var21 = nil
		var22 = nil
		var13 = nil
	end
end

local function var29(arg0)
	local var0 = ""

	arg0 = arg0:gsub("i%d*", function(arg0)
		var0 = arg0

		return ""
	end)
	var16 = 3
	arg0 = arg0:gsub("m(%d+)", function(arg0)
		var16 = var6(arg0)

		return ""
	end)
	var19 = 1
	arg0 = arg0:gsub("%-?%d+", function(arg0)
		var19 = var6(arg0)

		return ""
	end)

	local var1 = {}

	for iter0 in arg0:gmatch(".") do
		var1[iter0] = iter0
	end

	var14 = var1.z or var1.v

	if var14 == "z" then
		var11 = require("jit.zone")
	end

	local var2 = var1.l or var1.f or var1.F or var14 and "" or "f"
	local var3 = var1.p or ""

	var17 = var1.r

	if var1.s then
		var15 = 2

		if var19 == -1 or var1["-"] then
			var19 = -2
		elseif var19 == 1 then
			var19 = 2
		end
	elseif arg0:find("[fF].*l") then
		var2 = "l"
		var15 = 3
	else
		var15 = (var2 == "" or arg0:find("[zv].*[lfF]")) and 1 or 0
	end

	var20 = var1.A and 0 or var1.a and 3

	if var20 then
		var2 = "l"
		var18 = "pl"
		var15 = 0
		var19 = 1
	elseif var1.G and var2 ~= "" then
		var18 = var3 .. var2 .. "Z;"
		var19 = -100
		var17 = true
		var16 = 0
	elseif var2 == "" then
		var18 = false
	else
		local var4 = var15 == 3 and var1.f or var1.F or var2

		var18 = var3 .. var4 .. (var19 >= 0 and "Z < " or "Z > ")
	end

	var21 = {}
	var22 = {}
	var23 = 0

	var1.start(var2:lower() .. var0, var25)

	var13 = newproxy(true)
	getmetatable(var13).__gc = var28
end

local function var30(arg0, arg1)
	arg1 = arg1 or os.getenv("LUAJIT_PROFILEFILE")

	if arg1 then
		var12 = arg1 == "-" and var10 or assert(io.open(arg1, "w"))
	else
		var12 = var10
	end

	var29(arg0 or "f")
end

return {
	start = var30,
	stop = var28
}
