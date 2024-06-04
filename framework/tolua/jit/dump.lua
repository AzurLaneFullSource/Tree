local var0 = require("jit")

assert(var0.version_num == 20100, "LuaJIT core/library version mismatch")

local var1 = require("jit.util")
local var2 = require("jit.vmdef")
local var3 = var1.funcinfo
local var4 = var1.funcbc
local var5 = var1.traceinfo
local var6 = var1.traceir
local var7 = var1.tracek
local var8 = var1.tracemc
local var9 = var1.tracesnap
local var10 = var1.traceexitstub
local var11 = var1.ircalladdr
local var12 = require("bit")
local var13 = var12.band
local var14 = var12.rshift
local var15 = var12.tohex
local var16 = string.sub
local var17 = string.gsub
local var18 = string.format
local var19 = string.byte
local var20 = string.rep
local var21 = type
local var22 = tostring
local var23 = io.stdout
local var24 = io.stderr
local var25
local var26
local var27
local var28
local var29
local var30 = {
	__index = false
}
local var31 = {}
local var32 = 0

local function var33(arg0, arg1)
	local var0 = {}

	var30.__index = var0

	if var0.arch:sub(1, 4) == "mips" then
		var0[var10(arg0, 0)] = "exit"

		return
	end

	for iter0 = 0, arg1 - 1 do
		local var1 = var10(arg0, iter0)

		if var1 < 0 then
			var1 = var1 + 4294967296
		end

		var0[var1] = var22(iter0)
	end

	local var2 = var10(arg0, arg1)

	if var2 then
		var0[var2] = "stack_check"
	end
end

local function var34(arg0, arg1)
	local var0 = var31

	if var32 == 0 then
		local var1 = var2.ircall

		for iter0 = 0, #var1 do
			local var2 = var11(iter0)

			if var2 ~= 0 then
				if var2 < 0 then
					var2 = var2 + 4294967296
				end

				var0[var2] = var1[iter0]
			end
		end
	end

	if var32 == 1000000 then
		var33(arg0, arg1)
	elseif arg1 > var32 then
		for iter1 = var32, arg1 - 1 do
			local var3 = var10(iter1)

			if var3 == nil then
				var33(arg0, arg1)
				setmetatable(var31, var30)

				arg1 = 1000000

				break
			end

			if var3 < 0 then
				var3 = var3 + 4294967296
			end

			var0[var3] = var22(iter1)
		end

		var32 = arg1
	end

	return var0
end

local function var35(arg0)
	var28:write(arg0)
end

local function var36(arg0)
	local var0 = var5(arg0)

	if not var0 then
		return
	end

	local var1, var2, var3 = var8(arg0)

	if not var1 then
		return
	end

	if not var26 then
		var26 = require("jit.dis_" .. var0.arch)
	end

	if var2 < 0 then
		var2 = var2 + 4294967296
	end

	var28:write("---- TRACE ", arg0, " mcode ", #var1, "\n")

	local var4 = var26.create(var1, var2, var35)

	var4.hexdump = 0
	var4.symtab = var34(arg0, var0.nexit)

	if var3 ~= 0 then
		var31[var2 + var3] = "LOOP"

		var4:disass(0, var3)
		var28:write("->LOOP:\n")
		var4:disass(var3, #var1 - var3)

		var31[var2 + var3] = nil
	else
		var4:disass(0, #var1)
	end
end

local var37 = {
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
local var38 = {
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

local function var39(arg0)
	return arg0
end

local function var40(arg0, arg1)
	return var18(var38[arg1], arg0)
end

local var41 = setmetatable({}, {
	__index = function(arg0, arg1)
		local var0 = var40(var37[arg1], arg1)

		arg0[arg1] = var0

		return var0
	end
})
local var42 = {
	[">"] = "&gt;",
	["<"] = "&lt;",
	["&"] = "&amp;"
}

local function var43(arg0, arg1)
	arg0 = var17(arg0, "[<>&]", var42)

	return var18("<span class=\"irt_%s\">%s</span>", var37[arg1], arg0)
end

local var44 = setmetatable({}, {
	__index = function(arg0, arg1)
		local var0 = var43(var37[arg1], arg1)

		arg0[arg1] = var0

		return var0
	end
})
local var45 = "<style type=\"text/css\">\nbackground { background: #ffffff; color: #000000; }\npre.ljdump {\nfont-size: 10pt;\nbackground: #f0f4ff;\ncolor: #000000;\nborder: 1px solid #bfcfff;\npadding: 0.5em;\nmargin-left: 2em;\nmargin-right: 2em;\n}\nspan.irt_str { color: #00a000; }\nspan.irt_thr, span.irt_fun { color: #404040; font-weight: bold; }\nspan.irt_tab { color: #c00000; }\nspan.irt_udt, span.irt_lud { color: #00c0c0; }\nspan.irt_num { color: #4040c0; }\nspan.irt_int, span.irt_i8, span.irt_u8, span.irt_i16, span.irt_u16 { color: #b040b0; }\n</style>\n"
local var46
local var47
local var48 = {
	["SLOAD "] = setmetatable({}, {
		__index = function(arg0, arg1)
			local var0 = ""

			if var13(arg1, 1) ~= 0 then
				var0 = var0 .. "P"
			end

			if var13(arg1, 2) ~= 0 then
				var0 = var0 .. "F"
			end

			if var13(arg1, 4) ~= 0 then
				var0 = var0 .. "T"
			end

			if var13(arg1, 8) ~= 0 then
				var0 = var0 .. "C"
			end

			if var13(arg1, 16) ~= 0 then
				var0 = var0 .. "R"
			end

			if var13(arg1, 32) ~= 0 then
				var0 = var0 .. "I"
			end

			arg0[arg1] = var0

			return var0
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
		__index = function(arg0, arg1)
			local var0 = var47[var13(arg1, 31)]
			local var1 = var47[var13(var14(arg1, 5), 31)] .. "." .. var0

			if var13(arg1, 2048) ~= 0 then
				var1 = var1 .. " sext"
			end

			local var2 = var14(arg1, 14)

			if var2 == 2 then
				var1 = var1 .. " index"
			elseif var2 == 3 then
				var1 = var1 .. " check"
			end

			arg0[arg1] = var1

			return var1
		end
	}),
	["FLOAD "] = var2.irfield,
	["FREF  "] = var2.irfield,
	FPMATH = var2.irfpm,
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

local function var49(arg0)
	if arg0 == "\n" then
		return "\\n"
	elseif arg0 == "\r" then
		return "\\r"
	elseif arg0 == "\t" then
		return "\\t"
	else
		return var18("\\%03d", var19(arg0))
	end
end

local function var50(arg0, arg1)
	local var0 = var3(arg0, arg1)

	if var0.loc then
		return var0.loc
	elseif var0.ffid then
		return var2.ffnames[var0.ffid]
	elseif var0.addr then
		return var18("C:%x", var0.addr)
	else
		return "(?)"
	end
end

local function var51(arg0, arg1, arg2)
	local var0, var1, var2 = var7(arg0, arg1)
	local var3 = var21(var0)
	local var4

	if var3 == "number" then
		if var13(arg2 or 0, 196608) ~= 0 then
			var4 = var13(arg2, 131072) ~= 0 and "contpc" or "ftsz"
		elseif var0 == 6.75539944105574e+15 then
			var4 = "bias"
		else
			var4 = var18(var0 > 0 and var0 < 1.390671161567e-309 and "%+a" or "%+.14g", var0)
		end
	elseif var3 == "string" then
		var4 = var18(#var0 > 20 and "\"%.20s\"~" or "\"%s\"", var17(var0, "%c", var49))
	elseif var3 == "function" then
		var4 = var50(var0)
	elseif var3 == "table" then
		var4 = var18("{%p}", var0)
	elseif var3 == "userdata" then
		if var1 == 12 then
			var4 = var18("userdata:%p", var0)
		else
			var4 = var18("[%p]", var0)

			if var4 == "[NULL]" then
				var4 = "NULL"
			end
		end
	elseif var1 == 21 then
		var4 = var16(var22(var0), 1, -3)

		if var16(var4, 1, 1) ~= "-" then
			var4 = "+" .. var4
		end
	elseif arg2 == 17137663 then
		return "----"
	else
		var4 = var22(var0)
	end

	local var5 = var46(var18("%-4s", var4), var1)

	if var2 then
		var5 = var18("%s @%d", var5, var2)
	end

	return var5
end

local function var52(arg0, arg1)
	local var0 = 2

	for iter0 = 0, arg1[1] - 1 do
		local var1 = arg1[var0]

		if var14(var1, 24) == iter0 then
			var0 = var0 + 1

			local var2 = var13(var1, 65535) - 32768

			if var2 < 0 then
				var28:write(var51(arg0, var2, var1))
			elseif var13(var1, 524288) ~= 0 then
				var28:write(var46(var18("%04d/%04d", var2, var2 + 1), 14))
			else
				local var3, var4, var5, var6 = var6(arg0, var2)

				var28:write(var46(var18("%04d", var2), var13(var4, 31)))
			end

			var28:write(var13(var1, 65536) == 0 and " " or "|")
		else
			var28:write("---- ")
		end
	end

	var28:write("]\n")
end

local function var53(arg0)
	var28:write("---- TRACE ", arg0, " snapshots\n")

	for iter0 = 0, 1000000000 do
		local var0 = var9(arg0, iter0)

		if not var0 then
			break
		end

		var28:write(var18("#%-3d %04d [ ", iter0, var0[0]))
		var52(arg0, var0)
	end
end

local function var54(arg0, arg1)
	if not var26 then
		var26 = require("jit.dis_" .. var0.arch)
	end

	local var0 = var13(arg0, 255)
	local var1 = var14(arg0, 8)

	if var0 == 253 or var0 == 254 then
		return (var1 == 0 or var1 == 255) and " {sink" or var18(" {%04d", arg1 - var1)
	end

	if arg0 > 255 then
		return var18("[%x]", var1 * 4)
	end

	if var0 < 128 then
		return var26.regname(var0)
	end

	return ""
end

local function var55(arg0, arg1)
	local var0

	if arg1 > 0 then
		local var1, var2, var3, var4 = var6(arg0, arg1)

		if var13(var2, 31) == 0 then
			arg1 = var3
			var0 = var51(arg0, var4)
		end
	end

	if arg1 < 0 then
		var28:write(var18("[0x%x](", tonumber((var7(arg0, arg1)))))
	else
		var28:write(var18("%04d (", arg1))
	end

	return var0
end

local function var56(arg0, arg1)
	if arg1 < 0 then
		var28:write(var51(arg0, arg1))
	else
		local var0, var1, var2, var3 = var6(arg0, arg1)
		local var4 = 6 * var14(var1, 8)

		if var16(var2.irnames, var4 + 1, var4 + 6) == "CARG  " then
			var56(arg0, var2)

			if var3 < 0 then
				var28:write(" ", var51(arg0, var3))
			else
				var28:write(" ", var18("%04d", var3))
			end
		else
			var28:write(var18("%04d", arg1))
		end
	end
end

local function var57(arg0, arg1, arg2)
	local var0 = var5(arg0)

	if not var0 then
		return
	end

	local var1 = var0.nins

	var28:write("---- TRACE ", arg0, " IR\n")

	local var2 = var2.irnames
	local var3 = 65536
	local var4
	local var5

	if arg1 then
		var4 = var9(arg0, 0)
		var3 = var4[0]
		var5 = 0
	end

	for iter0 = 1, var1 do
		if var3 <= iter0 then
			if arg2 then
				var28:write(var18("....              SNAP   #%-3d [ ", var5))
			else
				var28:write(var18("....        SNAP   #%-3d [ ", var5))
			end

			var52(arg0, var4)

			var5 = var5 + 1
			var4 = var9(arg0, var5)
			var3 = var4 and var4[0] or 65536
		end

		local var6, var7, var8, var9, var10 = var6(arg0, iter0)
		local var11 = 6 * var14(var7, 8)
		local var12 = var13(var7, 31)
		local var13 = var16(var2, var11 + 1, var11 + 6)

		if var13 == "LOOP  " then
			if arg2 then
				var28:write(var18("%04d ------------ LOOP ------------\n", iter0))
			else
				var28:write(var18("%04d ------ LOOP ------------\n", iter0))
			end
		elseif var13 ~= "NOP   " and var13 ~= "CARG  " and (arg2 or var13 ~= "RENAME") then
			local var14 = var13(var10, 255)

			if arg2 then
				var28:write(var18("%04d %-6s", iter0, var54(var10, iter0)))
			else
				var28:write(var18("%04d ", iter0))
			end

			var28:write(var18("%s%s %s %s ", (var14 == 254 or var14 == 253) and "}" or var13(var7, 128) == 0 and " " or ">", var13(var7, 64) == 0 and " " or "+", var47[var12], var13))

			local var15 = var13(var6, 3)
			local var16 = var13(var6, 12)

			if var16(var13, 1, 4) == "CALL" then
				local var17

				if var16 == 4 then
					var28:write(var18("%-10s  (", var2.ircall[var9]))
				else
					var17 = var55(arg0, var9)
				end

				if var8 ~= -1 then
					var56(arg0, var8)
				end

				var28:write(")")

				if var17 then
					var28:write(" ctype ", var17)
				end
			elseif var13 == "CNEW  " and var9 == -1 then
				var28:write(var51(arg0, var8))
			elseif var15 ~= 3 then
				if var8 < 0 then
					var28:write(var51(arg0, var8))
				else
					var28:write(var18(var15 == 0 and "%04d" or "#%-3d", var8))
				end

				if var16 ~= 12 then
					if var16 == 4 then
						local var18 = var48[var13]

						if var18 and var18[var9] then
							var28:write("  ", var18[var9])
						elseif var13 == "UREFO " or var13 == "UREFC " then
							var28:write(var18("  #%-3d", var14(var9, 8)))
						else
							var28:write(var18("  #%-3d", var9))
						end
					elseif var9 < 0 then
						var28:write("  ", var51(arg0, var9))
					else
						var28:write(var18("  %04d", var9))
					end
				end
			end

			var28:write("\n")
		end
	end

	if var4 then
		if arg2 then
			var28:write(var18("....              SNAP   #%-3d [ ", var5))
		else
			var28:write(var18("....        SNAP   #%-3d [ ", var5))
		end

		var52(arg0, var4)
	end
end

local var58 = ""
local var59 = 0

local function var60(arg0, arg1)
	if var21(arg0) == "number" then
		if var21(arg1) == "function" then
			arg1 = var50(arg1)
		end

		arg0 = var18(var2.traceerr[arg0], arg1)
	end

	return arg0
end

local function var61(arg0, arg1, arg2, arg3, arg4, arg5)
	if arg0 == "stop" or arg0 == "abort" and var29.a then
		if var29.i then
			var57(arg1, var29.s, var29.r and arg0 == "stop")
		elseif var29.s then
			var53(arg1)
		end

		if var29.m then
			var36(arg1)
		end
	end

	if arg0 == "start" then
		if var29.H then
			var28:write("<pre class=\"ljdump\">\n")
		end

		var28:write("---- TRACE ", arg1, " ", arg0)

		if arg4 then
			var28:write(" ", arg4, "/", arg5 == -1 and "stitch" or arg5)
		end

		var28:write(" ", var50(arg2, arg3), "\n")
	elseif arg0 == "stop" or arg0 == "abort" then
		var28:write("---- TRACE ", arg1, " ", arg0)

		if arg0 == "abort" then
			var28:write(" ", var50(arg2, arg3), " -- ", var60(arg4, arg5), "\n")
		else
			local var0 = var5(arg1)
			local var1 = var0.link
			local var2 = var0.linktype

			if var1 == arg1 or var1 == 0 then
				var28:write(" -> ", var2, "\n")
			elseif var2 == "root" then
				var28:write(" -> ", var1, "\n")
			else
				var28:write(" -> ", var1, " ", var2, "\n")
			end
		end

		if var29.H then
			var28:write("</pre>\n\n")
		else
			var28:write("\n")
		end
	else
		if arg0 == "flush" then
			var31, var32 = {}, 0
		end

		var28:write("---- TRACE ", arg0, "\n\n")
	end

	var28:flush()
end

local function var62(arg0, arg1, arg2, arg3, arg4)
	if arg3 ~= var59 then
		var59 = arg3
		var58 = var20(" .", arg3)
	end

	local var0

	if arg2 >= 0 then
		var0 = var25(arg1, arg2, var58)

		if var29.H then
			var0 = var17(var0, "[<>&]", var42)
		end
	else
		var0 = "0000 " .. var58 .. " FUNCC      \n"
		arg4 = arg1
	end

	if arg2 <= 0 then
		var28:write(var16(var0, 1, -2), "         ; ", var50(arg1), "\n")
	else
		var28:write(var0)
	end

	if arg2 >= 0 and var13(var4(arg1, arg2), 255) < 16 then
		var28:write(var25(arg1, arg2 + 1, var58))
	end
end

local function var63(arg0, arg1, arg2, arg3, ...)
	var28:write("---- TRACE ", arg0, " exit ", arg1, "\n")

	if var29.X then
		local var0 = {
			...
		}

		if var0.arch == "x64" then
			for iter0 = 1, arg2 do
				var28:write(var18(" %016x", var0[iter0]))

				if iter0 % 4 == 0 then
					var28:write("\n")
				end
			end
		else
			for iter1 = 1, arg2 do
				var28:write(" ", var15(var0[iter1]))

				if iter1 % 8 == 0 then
					var28:write("\n")
				end
			end
		end

		if var0.arch == "mips" or var0.arch == "mipsel" then
			for iter2 = 1, arg3, 2 do
				var28:write(var18(" %+17.14g", var0[arg2 + iter2]))

				if iter2 % 8 == 7 then
					var28:write("\n")
				end
			end
		else
			for iter3 = 1, arg3 do
				var28:write(var18(" %+17.14g", var0[arg2 + iter3]))

				if iter3 % 4 == 0 then
					var28:write("\n")
				end
			end
		end
	end
end

local function var64()
	if var27 then
		var27 = false

		var0.attach(var63)
		var0.attach(var62)
		var0.attach(var61)

		if var28 and var28 ~= var23 and var28 ~= var24 then
			var28:close()
		end

		var28 = nil
	end
end

local function var65(arg0, arg1)
	if var27 then
		var64()
	end

	local var0 = os.getenv("TERM")
	local var1 = (var0 and var0:match("color") or os.getenv("COLORTERM")) and "A" or "T"

	arg0 = arg0 and var17(arg0, "[TAH]", function(arg0)
		var1 = arg0

		return ""
	end)

	local var2 = {
		i = true,
		t = true,
		m = true,
		b = true
	}

	if arg0 and arg0 ~= "" then
		local var3 = var16(arg0, 1, 1)

		if var3 ~= "+" and var3 ~= "-" then
			var2 = {}
		end

		for iter0 = 1, #arg0 do
			var2[var16(arg0, iter0, iter0)] = var3 ~= "-"
		end
	end

	var29 = var2

	if var2.t or var2.b or var2.i or var2.s or var2.m then
		var0.attach(var61, "trace")
	end

	if var2.b then
		var0.attach(var62, "record")

		if not var25 then
			var25 = require("jit.bc").line
		end
	end

	if var2.x or var2.X then
		var0.attach(var63, "texit")
	end

	arg1 = arg1 or os.getenv("LUAJIT_DUMPFILE")

	if arg1 then
		var28 = arg1 == "-" and var23 or assert(io.open(arg1, "w"))
	else
		var28 = var23
	end

	var2[var1] = true

	if var1 == "A" then
		var46 = var40
		var47 = var41
	elseif var1 == "H" then
		var46 = var43
		var47 = var44

		var28:write(var45)
	else
		var46 = var39
		var47 = var37
	end

	var27 = true
end

return {
	on = var65,
	off = var64,
	start = var65
}
