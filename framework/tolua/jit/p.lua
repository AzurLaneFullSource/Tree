local var0_0 = require("jit")

assert(var0_0.version_num == 20100, "LuaJIT core/library version mismatch")

local var1_0 = require("jit.profile")
local var2_0 = require("jit.vmdef")
local var3_0 = math
local var4_0 = pairs
local var5_0 = ipairs
local var6_0 = tonumber
local var7_0 = var3_0.floor
local var8_0 = table.sort
local var9_0 = string.format
local var10_0 = io.stdout
local var11_0
local var12_0
local var13_0
local var14_0
local var15_0
local var16_0
local var17_0
local var18_0
local var19_0
local var20_0
local var21_0
local var22_0
local var23_0
local var24_0 = {
	G = "Garbage Collector",
	C = "C code",
	N = "Compiled",
	J = "JIT Compiler",
	I = "Interpreted"
}

local function var25_0(arg0_1, arg1_1, arg2_1)
	var23_0 = var23_0 + arg1_1

	local var0_1
	local var1_1
	local var2_1

	if var14_0 then
		if var14_0 == "v" then
			var2_1 = var24_0[arg2_1] or arg2_1
		else
			var2_1 = var11_0:get() or "(none)"
		end
	end

	if var18_0 then
		var0_1 = var1_0.dumpstack(arg0_1, var18_0, var19_0)
		var0_1 = var0_1:gsub("%[builtin#(%d+)%]", function(arg0_2)
			return var2_0.ffnames[var6_0(arg0_2)]
		end)

		if var15_0 == 2 then
			local var3_1, var4_1 = var0_1:match("(.-) [<>] (.*)")

			if var4_1 then
				var0_1, var1_1 = var3_1, var4_1
			end
		elseif var15_0 == 3 then
			var1_1 = var1_0.dumpstack(arg0_1, "l", 1)
		end
	end

	local var5_1
	local var6_1

	if var15_0 == 1 then
		if var2_1 then
			var5_1 = var2_1

			if var0_1 then
				var6_1 = var0_1
			end
		end
	elseif var0_1 then
		var5_1 = var0_1

		if var1_1 then
			var6_1 = var1_1
		elseif var2_1 then
			var6_1 = var2_1
		end
	end

	if var5_1 then
		local var7_1 = var21_0

		var7_1[var5_1] = (var7_1[var5_1] or 0) + arg1_1

		if var6_1 then
			local var8_1 = var22_0
			local var9_1 = var8_1[var5_1]

			if not var9_1 then
				var9_1 = {}
				var8_1[var5_1] = var9_1
			end

			var9_1[var6_1] = (var9_1[var6_1] or 0) + arg1_1
		end
	end
end

local function var26_0(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = {}
	local var1_3 = 0

	for iter0_3 in var4_0(arg0_3) do
		var1_3 = var1_3 + 1
		var0_3[var1_3] = iter0_3
	end

	var8_0(var0_3, function(arg0_4, arg1_4)
		return arg0_3[arg0_4] > arg0_3[arg1_4]
	end)

	for iter1_3 = 1, var1_3 do
		local var2_3 = var0_3[iter1_3]
		local var3_3 = arg0_3[var2_3]
		local var4_3 = var7_0(var3_3 * 100 / arg2_3 + 0.5)

		if var4_3 < var16_0 then
			break
		end

		if not var17_0 then
			var12_0:write(var9_0("%s%2d%%  %s\n", arg3_3, var4_3, var2_3))
		elseif var17_0 == "r" then
			var12_0:write(var9_0("%s%5d  %s\n", arg3_3, var3_3, var2_3))
		else
			var12_0:write(var9_0("%s %d\n", var2_3, var3_3))
		end

		if arg1_3 then
			local var5_3 = arg1_3[var2_3]

			if var5_3 then
				var26_0(var5_3, nil, var3_3, (var15_0 == 3 or var15_0 == 1) and "  -- " or var19_0 < 0 and "  -> " or "  <- ")
			end
		end
	end
end

local function var27_0(arg0_5, arg1_5)
	local var0_5 = {}
	local var1_5 = 0

	for iter0_5, iter1_5 in var4_0(arg0_5) do
		local var2_5 = var7_0(iter1_5 * 100 / arg1_5 + 0.5)

		var1_5 = var3_0.max(var1_5, iter1_5)

		if var2_5 >= var16_0 then
			local var3_5, var4_5 = iter0_5:match("^(.*):(%d+)$")

			if not var3_5 then
				var3_5 = iter0_5
				var4_5 = 0
			end

			local var5_5 = var0_5[var3_5]

			if not var5_5 then
				var5_5 = {}
				var0_5[var3_5] = var5_5
				var0_5[#var0_5 + 1] = var3_5
			end

			var5_5[var6_0(var4_5)] = var17_0 and iter1_5 or var2_5
		end
	end

	var8_0(var0_5)

	local var6_5 = " %3d%% | %s\n"
	local var7_5 = "      | %s\n"

	if var17_0 then
		local var8_5 = var3_0.max(5, var3_0.ceil(var3_0.log10(var1_5)))

		var6_5 = "%" .. var8_5 .. "d | %s\n"
		var7_5 = (" "):rep(var8_5) .. " | %s\n"
	end

	local var9_5 = var20_0

	for iter2_5, iter3_5 in var5_0(var0_5) do
		local var10_5 = iter3_5:byte()

		if var10_5 == 40 or var10_5 == 91 then
			var12_0:write(var9_0("\n====== %s ======\n[Cannot annotate non-file]\n", iter3_5))

			break
		end

		local var11_5, var12_5 = io.open(iter3_5)

		if not var11_5 then
			var12_0:write(var9_0("====== ERROR: %s: %s\n", iter3_5, var12_5))

			break
		end

		var12_0:write(var9_0("\n====== %s ======\n", iter3_5))

		local var13_5 = var0_5[iter3_5]
		local var14_5 = 1
		local var15_5 = false

		if var9_5 ~= 0 then
			for iter4_5 = 1, var9_5 do
				if var13_5[iter4_5] then
					var15_5 = true

					var12_0:write("@@ 1 @@\n")

					break
				end
			end
		end

		for iter5_5 in var11_5:lines() do
			if iter5_5:byte() == 27 then
				var12_0:write("[Cannot annotate bytecode file]\n")

				break
			end

			local var16_5 = var13_5[var14_5]

			if var9_5 ~= 0 then
				local var17_5 = var13_5[var14_5 + var9_5]

				if var15_5 then
					if var17_5 then
						var15_5 = var14_5 + var9_5
					elseif var16_5 then
						var15_5 = var14_5
					elseif var14_5 > var15_5 + var9_5 then
						var15_5 = false
					end
				elseif var17_5 then
					var15_5 = var14_5 + var9_5

					var12_0:write(var9_0("@@ %d @@\n", var14_5))
				end

				if not var15_5 then
					goto label0_5
				end
			end

			if var16_5 then
				var12_0:write(var9_0(var6_5, var16_5, iter5_5))
			else
				var12_0:write(var9_0(var7_5, iter5_5))
			end

			::label0_5::

			var14_5 = var14_5 + 1
		end

		var11_5:close()
	end
end

local function var28_0()
	if var13_0 then
		var1_0.stop()

		local var0_6 = var23_0

		if var0_6 == 0 then
			if var17_0 ~= true then
				var12_0:write("[No samples collected]\n")
			end

			return
		end

		if var20_0 then
			var27_0(var21_0, var0_6)
		else
			var26_0(var21_0, var22_0, var0_6, "")
		end

		var21_0 = nil
		var22_0 = nil
		var13_0 = nil
	end
end

local function var29_0(arg0_7)
	local var0_7 = ""

	arg0_7 = arg0_7:gsub("i%d*", function(arg0_8)
		var0_7 = arg0_8

		return ""
	end)
	var16_0 = 3
	arg0_7 = arg0_7:gsub("m(%d+)", function(arg0_9)
		var16_0 = var6_0(arg0_9)

		return ""
	end)
	var19_0 = 1
	arg0_7 = arg0_7:gsub("%-?%d+", function(arg0_10)
		var19_0 = var6_0(arg0_10)

		return ""
	end)

	local var1_7 = {}

	for iter0_7 in arg0_7:gmatch(".") do
		var1_7[iter0_7] = iter0_7
	end

	var14_0 = var1_7.z or var1_7.v

	if var14_0 == "z" then
		var11_0 = require("jit.zone")
	end

	local var2_7 = var1_7.l or var1_7.f or var1_7.F or var14_0 and "" or "f"
	local var3_7 = var1_7.p or ""

	var17_0 = var1_7.r

	if var1_7.s then
		var15_0 = 2

		if var19_0 == -1 or var1_7["-"] then
			var19_0 = -2
		elseif var19_0 == 1 then
			var19_0 = 2
		end
	elseif arg0_7:find("[fF].*l") then
		var2_7 = "l"
		var15_0 = 3
	else
		var15_0 = (var2_7 == "" or arg0_7:find("[zv].*[lfF]")) and 1 or 0
	end

	var20_0 = var1_7.A and 0 or var1_7.a and 3

	if var20_0 then
		var2_7 = "l"
		var18_0 = "pl"
		var15_0 = 0
		var19_0 = 1
	elseif var1_7.G and var2_7 ~= "" then
		var18_0 = var3_7 .. var2_7 .. "Z;"
		var19_0 = -100
		var17_0 = true
		var16_0 = 0
	elseif var2_7 == "" then
		var18_0 = false
	else
		local var4_7 = var15_0 == 3 and var1_7.f or var1_7.F or var2_7

		var18_0 = var3_7 .. var4_7 .. (var19_0 >= 0 and "Z < " or "Z > ")
	end

	var21_0 = {}
	var22_0 = {}
	var23_0 = 0

	var1_0.start(var2_7:lower() .. var0_7, var25_0)

	var13_0 = newproxy(true)
	getmetatable(var13_0).__gc = var28_0
end

local function var30_0(arg0_11, arg1_11)
	arg1_11 = arg1_11 or os.getenv("LUAJIT_PROFILEFILE")

	if arg1_11 then
		var12_0 = arg1_11 == "-" and var10_0 or assert(io.open(arg1_11, "w"))
	else
		var12_0 = var10_0
	end

	var29_0(arg0_11 or "f")
end

return {
	start = var30_0,
	stop = var28_0
}
