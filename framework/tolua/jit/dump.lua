local var0_0 = require("jit")

assert(var0_0.version_num == 20100, "LuaJIT core/library version mismatch")

local var1_0 = require("jit.util")
local var2_0 = require("jit.vmdef")
local var3_0 = var1_0.funcinfo
local var4_0 = var1_0.funcbc
local var5_0 = var1_0.traceinfo
local var6_0 = var1_0.traceir
local var7_0 = var1_0.tracek
local var8_0 = var1_0.tracemc
local var9_0 = var1_0.tracesnap
local var10_0 = var1_0.traceexitstub
local var11_0 = var1_0.ircalladdr
local var12_0 = require("bit")
local var13_0 = var12_0.band
local var14_0 = var12_0.rshift
local var15_0 = var12_0.tohex
local var16_0 = string.sub
local var17_0 = string.gsub
local var18_0 = string.format
local var19_0 = string.byte
local var20_0 = string.rep
local var21_0 = type
local var22_0 = tostring
local var23_0 = io.stdout
local var24_0 = io.stderr
local var25_0
local var26_0
local var27_0
local var28_0
local var29_0
local var30_0 = {
	__index = false
}
local var31_0 = {}
local var32_0 = 0

local function var33_0(arg0_1, arg1_1)
	local var0_1 = {}

	var30_0.__index = var0_1

	if var0_0.arch:sub(1, 4) == "mips" then
		var0_1[var10_0(arg0_1, 0)] = "exit"

		return
	end

	for iter0_1 = 0, arg1_1 - 1 do
		local var1_1 = var10_0(arg0_1, iter0_1)

		if var1_1 < 0 then
			var1_1 = var1_1 + 4294967296
		end

		var0_1[var1_1] = var22_0(iter0_1)
	end

	local var2_1 = var10_0(arg0_1, arg1_1)

	if var2_1 then
		var0_1[var2_1] = "stack_check"
	end
end

local function var34_0(arg0_2, arg1_2)
	local var0_2 = var31_0

	if var32_0 == 0 then
		local var1_2 = var2_0.ircall

		for iter0_2 = 0, #var1_2 do
			local var2_2 = var11_0(iter0_2)

			if var2_2 ~= 0 then
				if var2_2 < 0 then
					var2_2 = var2_2 + 4294967296
				end

				var0_2[var2_2] = var1_2[iter0_2]
			end
		end
	end

	if var32_0 == 1000000 then
		var33_0(arg0_2, arg1_2)
	elseif arg1_2 > var32_0 then
		for iter1_2 = var32_0, arg1_2 - 1 do
			local var3_2 = var10_0(iter1_2)

			if var3_2 == nil then
				var33_0(arg0_2, arg1_2)
				setmetatable(var31_0, var30_0)

				arg1_2 = 1000000

				break
			end

			if var3_2 < 0 then
				var3_2 = var3_2 + 4294967296
			end

			var0_2[var3_2] = var22_0(iter1_2)
		end

		var32_0 = arg1_2
	end

	return var0_2
end

local function var35_0(arg0_3)
	var28_0:write(arg0_3)
end

local function var36_0(arg0_4)
	local var0_4 = var5_0(arg0_4)

	if not var0_4 then
		return
	end

	local var1_4, var2_4, var3_4 = var8_0(arg0_4)

	if not var1_4 then
		return
	end

	if not var26_0 then
		var26_0 = require("jit.dis_" .. var0_0.arch)
	end

	if var2_4 < 0 then
		var2_4 = var2_4 + 4294967296
	end

	var28_0:write("---- TRACE ", arg0_4, " mcode ", #var1_4, "\n")

	local var4_4 = var26_0.create(var1_4, var2_4, var35_0)

	var4_4.hexdump = 0
	var4_4.symtab = var34_0(arg0_4, var0_4.nexit)

	if var3_4 ~= 0 then
		var31_0[var2_4 + var3_4] = "LOOP"

		var4_4:disass(0, var3_4)
		var28_0:write("->LOOP:\n")
		var4_4:disass(var3_4, #var1_4 - var3_4)

		var31_0[var2_4 + var3_4] = nil
	else
		var4_4:disass(0, #var1_4)
	end
end

local var37_0 = {
	[0] = "nil",
	"fal",
	"tru",
	"lud",
	"str",
	"p32",
	"thr",
	"pro",
	"fun",
	"p64",
	"cdt",
	"tab",
	"udt",
	"flt",
	"num",
	"i8 ",
	"u8 ",
	"i16",
	"u16",
	"int",
	"u32",
	"i64",
	"u64",
	"sfp"
}
local var38_0 = {
	[0] = "%s",
	"%s",
	"%s",
	"\x1B[36m%s\x1B[m",
	"\x1B[32m%s\x1B[m",
	"%s",
	"\x1B[1m%s\x1B[m",
	"%s",
	"\x1B[1m%s\x1B[m",
	"%s",
	"\x1B[33m%s\x1B[m",
	"\x1B[31m%s\x1B[m",
	"\x1B[36m%s\x1B[m",
	"\x1B[34m%s\x1B[m",
	"\x1B[34m%s\x1B[m",
	"\x1B[35m%s\x1B[m",
	"\x1B[35m%s\x1B[m",
	"\x1B[35m%s\x1B[m",
	"\x1B[35m%s\x1B[m",
	"\x1B[35m%s\x1B[m",
	"\x1B[35m%s\x1B[m",
	"\x1B[35m%s\x1B[m",
	"\x1B[35m%s\x1B[m",
	"\x1B[35m%s\x1B[m"
}

local function var39_0(arg0_5)
	return arg0_5
end

local function var40_0(arg0_6, arg1_6)
	return var18_0(var38_0[arg1_6], arg0_6)
end

local var41_0 = setmetatable({}, {
	__index = function(arg0_7, arg1_7)
		local var0_7 = var40_0(var37_0[arg1_7], arg1_7)

		arg0_7[arg1_7] = var0_7

		return var0_7
	end
})
local var42_0 = {
	[">"] = "&gt;",
	["<"] = "&lt;",
	["&"] = "&amp;"
}

local function var43_0(arg0_8, arg1_8)
	arg0_8 = var17_0(arg0_8, "[<>&]", var42_0)

	return var18_0("<span class=\"irt_%s\">%s</span>", var37_0[arg1_8], arg0_8)
end

local var44_0 = setmetatable({}, {
	__index = function(arg0_9, arg1_9)
		local var0_9 = var43_0(var37_0[arg1_9], arg1_9)

		arg0_9[arg1_9] = var0_9

		return var0_9
	end
})
local var45_0 = "<style type=\"text/css\">\nbackground { background: #ffffff; color: #000000; }\npre.ljdump {\nfont-size: 10pt;\nbackground: #f0f4ff;\ncolor: #000000;\nborder: 1px solid #bfcfff;\npadding: 0.5em;\nmargin-left: 2em;\nmargin-right: 2em;\n}\nspan.irt_str { color: #00a000; }\nspan.irt_thr, span.irt_fun { color: #404040; font-weight: bold; }\nspan.irt_tab { color: #c00000; }\nspan.irt_udt, span.irt_lud { color: #00c0c0; }\nspan.irt_num { color: #4040c0; }\nspan.irt_int, span.irt_i8, span.irt_u8, span.irt_i16, span.irt_u16 { color: #b040b0; }\n</style>\n"
local var46_0
local var47_0
local var48_0 = {
	["SLOAD "] = setmetatable({}, {
		__index = function(arg0_10, arg1_10)
			local var0_10 = ""

			if var13_0(arg1_10, 1) ~= 0 then
				var0_10 = var0_10 .. "P"
			end

			if var13_0(arg1_10, 2) ~= 0 then
				var0_10 = var0_10 .. "F"
			end

			if var13_0(arg1_10, 4) ~= 0 then
				var0_10 = var0_10 .. "T"
			end

			if var13_0(arg1_10, 8) ~= 0 then
				var0_10 = var0_10 .. "C"
			end

			if var13_0(arg1_10, 16) ~= 0 then
				var0_10 = var0_10 .. "R"
			end

			if var13_0(arg1_10, 32) ~= 0 then
				var0_10 = var0_10 .. "I"
			end

			arg0_10[arg1_10] = var0_10

			return var0_10
		end
	}),
	["XLOAD "] = {
		[0] = "",
		"R",
		"V",
		"RV",
		"U",
		"RU",
		"VU",
		"RVU"
	},
	["CONV  "] = setmetatable({}, {
		__index = function(arg0_11, arg1_11)
			local var0_11 = var47_0[var13_0(arg1_11, 31)]
			local var1_11 = var47_0[var13_0(var14_0(arg1_11, 5), 31)] .. "." .. var0_11

			if var13_0(arg1_11, 2048) ~= 0 then
				var1_11 = var1_11 .. " sext"
			end

			local var2_11 = var14_0(arg1_11, 14)

			if var2_11 == 2 then
				var1_11 = var1_11 .. " index"
			elseif var2_11 == 3 then
				var1_11 = var1_11 .. " check"
			end

			arg0_11[arg1_11] = var1_11

			return var1_11
		end
	}),
	["FLOAD "] = var2_0.irfield,
	["FREF  "] = var2_0.irfield,
	FPMATH = var2_0.irfpm,
	BUFHDR = {
		[0] = "RESET",
		"APPEND"
	},
	["TOSTR "] = {
		[0] = "INT",
		"NUM",
		"CHAR"
	}
}

local function var49_0(arg0_12)
	if arg0_12 == "\n" then
		return "\\n"
	elseif arg0_12 == "\r" then
		return "\\r"
	elseif arg0_12 == "\t" then
		return "\\t"
	else
		return var18_0("\\%03d", var19_0(arg0_12))
	end
end

local function var50_0(arg0_13, arg1_13)
	local var0_13 = var3_0(arg0_13, arg1_13)

	if var0_13.loc then
		return var0_13.loc
	elseif var0_13.ffid then
		return var2_0.ffnames[var0_13.ffid]
	elseif var0_13.addr then
		return var18_0("C:%x", var0_13.addr)
	else
		return "(?)"
	end
end

local function var51_0(arg0_14, arg1_14, arg2_14)
	local var0_14, var1_14, var2_14 = var7_0(arg0_14, arg1_14)
	local var3_14 = var21_0(var0_14)
	local var4_14

	if var3_14 == "number" then
		if var13_0(arg2_14 or 0, 196608) ~= 0 then
			var4_14 = var13_0(arg2_14, 131072) ~= 0 and "contpc" or "ftsz"
		elseif var0_14 == 6.75539944105574e+15 then
			var4_14 = "bias"
		else
			var4_14 = var18_0(var0_14 > 0 and var0_14 < 1.390671161567e-309 and "%+a" or "%+.14g", var0_14)
		end
	elseif var3_14 == "string" then
		var4_14 = var18_0(#var0_14 > 20 and "\"%.20s\"~" or "\"%s\"", var17_0(var0_14, "%c", var49_0))
	elseif var3_14 == "function" then
		var4_14 = var50_0(var0_14)
	elseif var3_14 == "table" then
		var4_14 = var18_0("{%p}", var0_14)
	elseif var3_14 == "userdata" then
		if var1_14 == 12 then
			var4_14 = var18_0("userdata:%p", var0_14)
		else
			var4_14 = var18_0("[%p]", var0_14)

			if var4_14 == "[NULL]" then
				var4_14 = "NULL"
			end
		end
	elseif var1_14 == 21 then
		var4_14 = var16_0(var22_0(var0_14), 1, -3)

		if var16_0(var4_14, 1, 1) ~= "-" then
			var4_14 = "+" .. var4_14
		end
	elseif arg2_14 == 17137663 then
		return "----"
	else
		var4_14 = var22_0(var0_14)
	end

	local var5_14 = var46_0(var18_0("%-4s", var4_14), var1_14)

	if var2_14 then
		var5_14 = var18_0("%s @%d", var5_14, var2_14)
	end

	return var5_14
end

local function var52_0(arg0_15, arg1_15)
	local var0_15 = 2

	for iter0_15 = 0, arg1_15[1] - 1 do
		local var1_15 = arg1_15[var0_15]

		if var14_0(var1_15, 24) == iter0_15 then
			var0_15 = var0_15 + 1

			local var2_15 = var13_0(var1_15, 65535) - 32768

			if var2_15 < 0 then
				var28_0:write(var51_0(arg0_15, var2_15, var1_15))
			elseif var13_0(var1_15, 524288) ~= 0 then
				var28_0:write(var46_0(var18_0("%04d/%04d", var2_15, var2_15 + 1), 14))
			else
				local var3_15, var4_15, var5_15, var6_15 = var6_0(arg0_15, var2_15)

				var28_0:write(var46_0(var18_0("%04d", var2_15), var13_0(var4_15, 31)))
			end

			var28_0:write(var13_0(var1_15, 65536) == 0 and " " or "|")
		else
			var28_0:write("---- ")
		end
	end

	var28_0:write("]\n")
end

local function var53_0(arg0_16)
	var28_0:write("---- TRACE ", arg0_16, " snapshots\n")

	for iter0_16 = 0, 1000000000 do
		local var0_16 = var9_0(arg0_16, iter0_16)

		if not var0_16 then
			break
		end

		var28_0:write(var18_0("#%-3d %04d [ ", iter0_16, var0_16[0]))
		var52_0(arg0_16, var0_16)
	end
end

local function var54_0(arg0_17, arg1_17)
	if not var26_0 then
		var26_0 = require("jit.dis_" .. var0_0.arch)
	end

	local var0_17 = var13_0(arg0_17, 255)
	local var1_17 = var14_0(arg0_17, 8)

	if var0_17 == 253 or var0_17 == 254 then
		return (var1_17 == 0 or var1_17 == 255) and " {sink" or var18_0(" {%04d", arg1_17 - var1_17)
	end

	if arg0_17 > 255 then
		return var18_0("[%x]", var1_17 * 4)
	end

	if var0_17 < 128 then
		return var26_0.regname(var0_17)
	end

	return ""
end

local function var55_0(arg0_18, arg1_18)
	local var0_18

	if arg1_18 > 0 then
		local var1_18, var2_18, var3_18, var4_18 = var6_0(arg0_18, arg1_18)

		if var13_0(var2_18, 31) == 0 then
			arg1_18 = var3_18
			var0_18 = var51_0(arg0_18, var4_18)
		end
	end

	if arg1_18 < 0 then
		var28_0:write(var18_0("[0x%x](", tonumber((var7_0(arg0_18, arg1_18)))))
	else
		var28_0:write(var18_0("%04d (", arg1_18))
	end

	return var0_18
end

local function var56_0(arg0_19, arg1_19)
	if arg1_19 < 0 then
		var28_0:write(var51_0(arg0_19, arg1_19))
	else
		local var0_19, var1_19, var2_19, var3_19 = var6_0(arg0_19, arg1_19)
		local var4_19 = 6 * var14_0(var1_19, 8)

		if var16_0(var2_0.irnames, var4_19 + 1, var4_19 + 6) == "CARG  " then
			var56_0(arg0_19, var2_19)

			if var3_19 < 0 then
				var28_0:write(" ", var51_0(arg0_19, var3_19))
			else
				var28_0:write(" ", var18_0("%04d", var3_19))
			end
		else
			var28_0:write(var18_0("%04d", arg1_19))
		end
	end
end

local function var57_0(arg0_20, arg1_20, arg2_20)
	local var0_20 = var5_0(arg0_20)

	if not var0_20 then
		return
	end

	local var1_20 = var0_20.nins

	var28_0:write("---- TRACE ", arg0_20, " IR\n")

	local var2_20 = var2_0.irnames
	local var3_20 = 65536
	local var4_20
	local var5_20

	if arg1_20 then
		var4_20 = var9_0(arg0_20, 0)
		var3_20 = var4_20[0]
		var5_20 = 0
	end

	for iter0_20 = 1, var1_20 do
		if var3_20 <= iter0_20 then
			if arg2_20 then
				var28_0:write(var18_0("....              SNAP   #%-3d [ ", var5_20))
			else
				var28_0:write(var18_0("....        SNAP   #%-3d [ ", var5_20))
			end

			var52_0(arg0_20, var4_20)

			var5_20 = var5_20 + 1
			var4_20 = var9_0(arg0_20, var5_20)
			var3_20 = var4_20 and var4_20[0] or 65536
		end

		local var6_20, var7_20, var8_20, var9_20, var10_20 = var6_0(arg0_20, iter0_20)
		local var11_20 = 6 * var14_0(var7_20, 8)
		local var12_20 = var13_0(var7_20, 31)
		local var13_20 = var16_0(var2_20, var11_20 + 1, var11_20 + 6)

		if var13_20 == "LOOP  " then
			if arg2_20 then
				var28_0:write(var18_0("%04d ------------ LOOP ------------\n", iter0_20))
			else
				var28_0:write(var18_0("%04d ------ LOOP ------------\n", iter0_20))
			end
		elseif var13_20 ~= "NOP   " and var13_20 ~= "CARG  " and (arg2_20 or var13_20 ~= "RENAME") then
			local var14_20 = var13_0(var10_20, 255)

			if arg2_20 then
				var28_0:write(var18_0("%04d %-6s", iter0_20, var54_0(var10_20, iter0_20)))
			else
				var28_0:write(var18_0("%04d ", iter0_20))
			end

			var28_0:write(var18_0("%s%s %s %s ", (var14_20 == 254 or var14_20 == 253) and "}" or var13_0(var7_20, 128) == 0 and " " or ">", var13_0(var7_20, 64) == 0 and " " or "+", var47_0[var12_20], var13_20))

			local var15_20 = var13_0(var6_20, 3)
			local var16_20 = var13_0(var6_20, 12)

			if var16_0(var13_20, 1, 4) == "CALL" then
				local var17_20

				if var16_20 == 4 then
					var28_0:write(var18_0("%-10s  (", var2_0.ircall[var9_20]))
				else
					var17_20 = var55_0(arg0_20, var9_20)
				end

				if var8_20 ~= -1 then
					var56_0(arg0_20, var8_20)
				end

				var28_0:write(")")

				if var17_20 then
					var28_0:write(" ctype ", var17_20)
				end
			elseif var13_20 == "CNEW  " and var9_20 == -1 then
				var28_0:write(var51_0(arg0_20, var8_20))
			elseif var15_20 ~= 3 then
				if var8_20 < 0 then
					var28_0:write(var51_0(arg0_20, var8_20))
				else
					var28_0:write(var18_0(var15_20 == 0 and "%04d" or "#%-3d", var8_20))
				end

				if var16_20 ~= 12 then
					if var16_20 == 4 then
						local var18_20 = var48_0[var13_20]

						if var18_20 and var18_20[var9_20] then
							var28_0:write("  ", var18_20[var9_20])
						elseif var13_20 == "UREFO " or var13_20 == "UREFC " then
							var28_0:write(var18_0("  #%-3d", var14_0(var9_20, 8)))
						else
							var28_0:write(var18_0("  #%-3d", var9_20))
						end
					elseif var9_20 < 0 then
						var28_0:write("  ", var51_0(arg0_20, var9_20))
					else
						var28_0:write(var18_0("  %04d", var9_20))
					end
				end
			end

			var28_0:write("\n")
		end
	end

	if var4_20 then
		if arg2_20 then
			var28_0:write(var18_0("....              SNAP   #%-3d [ ", var5_20))
		else
			var28_0:write(var18_0("....        SNAP   #%-3d [ ", var5_20))
		end

		var52_0(arg0_20, var4_20)
	end
end

local var58_0 = ""
local var59_0 = 0

local function var60_0(arg0_21, arg1_21)
	if var21_0(arg0_21) == "number" then
		if var21_0(arg1_21) == "function" then
			arg1_21 = var50_0(arg1_21)
		end

		arg0_21 = var18_0(var2_0.traceerr[arg0_21], arg1_21)
	end

	return arg0_21
end

local function var61_0(arg0_22, arg1_22, arg2_22, arg3_22, arg4_22, arg5_22)
	if arg0_22 == "stop" or arg0_22 == "abort" and var29_0.a then
		if var29_0.i then
			var57_0(arg1_22, var29_0.s, var29_0.r and arg0_22 == "stop")
		elseif var29_0.s then
			var53_0(arg1_22)
		end

		if var29_0.m then
			var36_0(arg1_22)
		end
	end

	if arg0_22 == "start" then
		if var29_0.H then
			var28_0:write("<pre class=\"ljdump\">\n")
		end

		var28_0:write("---- TRACE ", arg1_22, " ", arg0_22)

		if arg4_22 then
			var28_0:write(" ", arg4_22, "/", arg5_22 == -1 and "stitch" or arg5_22)
		end

		var28_0:write(" ", var50_0(arg2_22, arg3_22), "\n")
	elseif arg0_22 == "stop" or arg0_22 == "abort" then
		var28_0:write("---- TRACE ", arg1_22, " ", arg0_22)

		if arg0_22 == "abort" then
			var28_0:write(" ", var50_0(arg2_22, arg3_22), " -- ", var60_0(arg4_22, arg5_22), "\n")
		else
			local var0_22 = var5_0(arg1_22)
			local var1_22 = var0_22.link
			local var2_22 = var0_22.linktype

			if var1_22 == arg1_22 or var1_22 == 0 then
				var28_0:write(" -> ", var2_22, "\n")
			elseif var2_22 == "root" then
				var28_0:write(" -> ", var1_22, "\n")
			else
				var28_0:write(" -> ", var1_22, " ", var2_22, "\n")
			end
		end

		if var29_0.H then
			var28_0:write("</pre>\n\n")
		else
			var28_0:write("\n")
		end
	else
		if arg0_22 == "flush" then
			var31_0, var32_0 = {}, 0
		end

		var28_0:write("---- TRACE ", arg0_22, "\n\n")
	end

	var28_0:flush()
end

local function var62_0(arg0_23, arg1_23, arg2_23, arg3_23, arg4_23)
	if arg3_23 ~= var59_0 then
		var59_0 = arg3_23
		var58_0 = var20_0(" .", arg3_23)
	end

	local var0_23

	if arg2_23 >= 0 then
		var0_23 = var25_0(arg1_23, arg2_23, var58_0)

		if var29_0.H then
			var0_23 = var17_0(var0_23, "[<>&]", var42_0)
		end
	else
		var0_23 = "0000 " .. var58_0 .. " FUNCC      \n"
		arg4_23 = arg1_23
	end

	if arg2_23 <= 0 then
		var28_0:write(var16_0(var0_23, 1, -2), "         ; ", var50_0(arg1_23), "\n")
	else
		var28_0:write(var0_23)
	end

	if arg2_23 >= 0 and var13_0(var4_0(arg1_23, arg2_23), 255) < 16 then
		var28_0:write(var25_0(arg1_23, arg2_23 + 1, var58_0))
	end
end

local function var63_0(arg0_24, arg1_24, arg2_24, arg3_24, ...)
	var28_0:write("---- TRACE ", arg0_24, " exit ", arg1_24, "\n")

	if var29_0.X then
		local var0_24 = {
			...
		}

		if var0_0.arch == "x64" then
			for iter0_24 = 1, arg2_24 do
				var28_0:write(var18_0(" %016x", var0_24[iter0_24]))

				if iter0_24 % 4 == 0 then
					var28_0:write("\n")
				end
			end
		else
			for iter1_24 = 1, arg2_24 do
				var28_0:write(" ", var15_0(var0_24[iter1_24]))

				if iter1_24 % 8 == 0 then
					var28_0:write("\n")
				end
			end
		end

		if var0_0.arch == "mips" or var0_0.arch == "mipsel" then
			for iter2_24 = 1, arg3_24, 2 do
				var28_0:write(var18_0(" %+17.14g", var0_24[arg2_24 + iter2_24]))

				if iter2_24 % 8 == 7 then
					var28_0:write("\n")
				end
			end
		else
			for iter3_24 = 1, arg3_24 do
				var28_0:write(var18_0(" %+17.14g", var0_24[arg2_24 + iter3_24]))

				if iter3_24 % 4 == 0 then
					var28_0:write("\n")
				end
			end
		end
	end
end

local function var64_0()
	if var27_0 then
		var27_0 = false

		var0_0.attach(var63_0)
		var0_0.attach(var62_0)
		var0_0.attach(var61_0)

		if var28_0 and var28_0 ~= var23_0 and var28_0 ~= var24_0 then
			var28_0:close()
		end

		var28_0 = nil
	end
end

local function var65_0(arg0_26, arg1_26)
	if var27_0 then
		var64_0()
	end

	local var0_26 = os.getenv("TERM")
	local var1_26 = (var0_26 and var0_26:match("color") or os.getenv("COLORTERM")) and "A" or "T"

	arg0_26 = arg0_26 and var17_0(arg0_26, "[TAH]", function(arg0_27)
		var1_26 = arg0_27

		return ""
	end)

	local var2_26 = {
		i = true,
		t = true,
		m = true,
		b = true
	}

	if arg0_26 and arg0_26 ~= "" then
		local var3_26 = var16_0(arg0_26, 1, 1)

		if var3_26 ~= "+" and var3_26 ~= "-" then
			var2_26 = {}
		end

		for iter0_26 = 1, #arg0_26 do
			var2_26[var16_0(arg0_26, iter0_26, iter0_26)] = var3_26 ~= "-"
		end
	end

	var29_0 = var2_26

	if var2_26.t or var2_26.b or var2_26.i or var2_26.s or var2_26.m then
		var0_0.attach(var61_0, "trace")
	end

	if var2_26.b then
		var0_0.attach(var62_0, "record")

		if not var25_0 then
			var25_0 = require("jit.bc").line
		end
	end

	if var2_26.x or var2_26.X then
		var0_0.attach(var63_0, "texit")
	end

	arg1_26 = arg1_26 or os.getenv("LUAJIT_DUMPFILE")

	if arg1_26 then
		var28_0 = arg1_26 == "-" and var23_0 or assert(io.open(arg1_26, "w"))
	else
		var28_0 = var23_0
	end

	var2_26[var1_26] = true

	if var1_26 == "A" then
		var46_0 = var40_0
		var47_0 = var41_0
	elseif var1_26 == "H" then
		var46_0 = var43_0
		var47_0 = var44_0

		var28_0:write(var45_0)
	else
		var46_0 = var39_0
		var47_0 = var37_0
	end

	var27_0 = true
end

return {
	on = var65_0,
	off = var64_0,
	start = var65_0
}
