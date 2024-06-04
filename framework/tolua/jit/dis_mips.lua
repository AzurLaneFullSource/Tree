local var0 = type
local var1 = string.byte
local var2 = string.format
local var3 = string.match
local var4 = string.gmatch
local var5 = table.concat
local var6 = require("bit")
local var7 = var6.band
local var8 = var6.bor
local var9 = var6.tohex
local var10 = var6.lshift
local var11 = var6.rshift
local var12 = var6.arshift
local var13 = {
	[0] = "movfDSC",
	"movtDSC",
	shift = 16,
	mask = 1
}
local var14 = {
	[0] = "srlDTA",
	"rotrDTA",
	shift = 21,
	mask = 1
}
local var15 = {
	[0] = "srlvDTS",
	"rotrvDTS",
	shift = 6,
	mask = 1
}
local var16 = {
	[0] = {
		[0] = "nop",
		shift = 0,
		_ = "sllDTA",
		mask = -1
	},
	var13,
	var14,
	"sraDTA",
	"sllvDTS",
	false,
	var15,
	"sravDTS",
	"jrS",
	"jalrD1S",
	"movzDST",
	"movnDST",
	"syscallY",
	"breakY",
	false,
	"sync",
	"mfhiD",
	"mthiS",
	"mfloD",
	"mtloS",
	"dsllvDST",
	false,
	"dsrlvDST",
	"dsravDST",
	"multST",
	"multuST",
	"divST",
	"divuST",
	"dmultST",
	"dmultuST",
	"ddivST",
	"ddivuST",
	"addDST",
	"addu|moveDST0",
	"subDST",
	"subu|neguDS0T",
	"andDST",
	"or|moveDST0",
	"xorDST",
	"nor|notDST0",
	false,
	false,
	"sltDST",
	"sltuDST",
	"daddDST",
	"dadduDST",
	"dsubDST",
	"dsubuDST",
	"tgeSTZ",
	"tgeuSTZ",
	"tltSTZ",
	"tltuSTZ",
	"teqSTZ",
	false,
	"tneSTZ",
	false,
	"dsllDTA",
	false,
	"dsrlDTA",
	"dsraDTA",
	"dsll32DTA",
	false,
	"dsrl32DTA",
	"dsra32DTA",
	shift = 0,
	mask = 63
}
local var17 = {
	[0] = "maddST",
	"madduST",
	"mulDST",
	false,
	"msubST",
	"msubuST",
	shift = 0,
	[63] = "sdbbpY",
	mask = 63,
	[32] = "clzDS",
	[33] = "cloDS"
}
local var18 = {
	nil,
	"wsbhDT",
	[24] = "sehDT",
	shift = 6,
	[16] = "sebDT",
	mask = 31
}
local var19 = {
	nil,
	"dsbhDT",
	[5] = "dshdDT",
	shift = 6,
	mask = 31
}
local var20 = {
	[0] = "extTSAK",
	"dextmTSAP",
	nil,
	"dextTSAK",
	"insTSAL",
	nil,
	"dinsuTSEQ",
	"dinsTSAL",
	[59] = "rdhwrTD",
	shift = 0,
	mask = 63,
	[32] = var18,
	[36] = var19
}
local var21 = {
	[0] = "bltzSB",
	"bgezSB",
	"bltzlSB",
	"bgezlSB",
	false,
	false,
	false,
	false,
	"tgeiSI",
	"tgeiuSI",
	"tltiSI",
	"tltiuSI",
	"teqiSI",
	false,
	"tneiSI",
	false,
	"bltzalSB",
	"bgezalSB",
	"bltzallSB",
	"bgezallSB",
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	"synciSO",
	shift = 16,
	mask = 31
}
local var22 = {
	[0] = {
		[0] = "mfc0TDW",
		nil,
		nil,
		nil,
		"mtc0TDW",
		mask = 15,
		[10] = "rdpgprDT",
		shift = 21,
		[14] = "wrpgprDT",
		[11] = {
			[0] = "diT0",
			"eiT0",
			shift = 5,
			mask = 1
		}
	},
	{
		"tlbr",
		"tlbwi",
		nil,
		nil,
		nil,
		"tlbwr",
		nil,
		"tlbp",
		[24] = "eret",
		shift = 0,
		mask = 63,
		[31] = "deret",
		[32] = "wait"
	},
	shift = 25,
	mask = 1
}
local var23 = {
	[0] = "add.sFGH",
	"sub.sFGH",
	"mul.sFGH",
	"div.sFGH",
	"sqrt.sFG",
	"abs.sFG",
	"mov.sFG",
	"neg.sFG",
	"round.l.sFG",
	"trunc.l.sFG",
	"ceil.l.sFG",
	"floor.l.sFG",
	"round.w.sFG",
	"trunc.w.sFG",
	"ceil.w.sFG",
	"floor.w.sFG",
	false,
	{
		[0] = "movf.sFGC",
		"movt.sFGC",
		shift = 16,
		mask = 1
	},
	"movz.sFGT",
	"movn.sFGT",
	false,
	"recip.sFG",
	"rsqrt.sFG",
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	"cvt.d.sFG",
	false,
	false,
	"cvt.w.sFG",
	"cvt.l.sFG",
	"cvt.ps.sFGH",
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	"c.f.sVGH",
	"c.un.sVGH",
	"c.eq.sVGH",
	"c.ueq.sVGH",
	"c.olt.sVGH",
	"c.ult.sVGH",
	"c.ole.sVGH",
	"c.ule.sVGH",
	"c.sf.sVGH",
	"c.ngle.sVGH",
	"c.seq.sVGH",
	"c.ngl.sVGH",
	"c.lt.sVGH",
	"c.nge.sVGH",
	"c.le.sVGH",
	"c.ngt.sVGH",
	shift = 0,
	mask = 63
}
local var24 = {
	[0] = "add.dFGH",
	"sub.dFGH",
	"mul.dFGH",
	"div.dFGH",
	"sqrt.dFG",
	"abs.dFG",
	"mov.dFG",
	"neg.dFG",
	"round.l.dFG",
	"trunc.l.dFG",
	"ceil.l.dFG",
	"floor.l.dFG",
	"round.w.dFG",
	"trunc.w.dFG",
	"ceil.w.dFG",
	"floor.w.dFG",
	false,
	{
		[0] = "movf.dFGC",
		"movt.dFGC",
		shift = 16,
		mask = 1
	},
	"movz.dFGT",
	"movn.dFGT",
	false,
	"recip.dFG",
	"rsqrt.dFG",
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	"cvt.s.dFG",
	false,
	false,
	false,
	"cvt.w.dFG",
	"cvt.l.dFG",
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	"c.f.dVGH",
	"c.un.dVGH",
	"c.eq.dVGH",
	"c.ueq.dVGH",
	"c.olt.dVGH",
	"c.ult.dVGH",
	"c.ole.dVGH",
	"c.ule.dVGH",
	"c.df.dVGH",
	"c.ngle.dVGH",
	"c.deq.dVGH",
	"c.ngl.dVGH",
	"c.lt.dVGH",
	"c.nge.dVGH",
	"c.le.dVGH",
	"c.ngt.dVGH",
	shift = 0,
	mask = 63
}
local var25 = {
	[0] = "add.psFGH",
	"sub.psFGH",
	"mul.psFGH",
	false,
	false,
	"abs.psFG",
	"mov.psFG",
	"neg.psFG",
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	{
		[0] = "movf.psFGC",
		"movt.psFGC",
		shift = 16,
		mask = 1
	},
	"movz.psFGT",
	"movn.psFGT",
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	"cvt.s.puFG",
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	"cvt.s.plFG",
	false,
	false,
	false,
	"pll.psFGH",
	"plu.psFGH",
	"pul.psFGH",
	"puu.psFGH",
	"c.f.psVGH",
	"c.un.psVGH",
	"c.eq.psVGH",
	"c.ueq.psVGH",
	"c.olt.psVGH",
	"c.ult.psVGH",
	"c.ole.psVGH",
	"c.ule.psVGH",
	"c.psf.psVGH",
	"c.ngle.psVGH",
	"c.pseq.psVGH",
	"c.ngl.psVGH",
	"c.lt.psVGH",
	"c.nge.psVGH",
	"c.le.psVGH",
	"c.ngt.psVGH",
	shift = 0,
	mask = 63
}
local var26 = {
	shift = 0,
	mask = 63,
	[32] = "cvt.s.wFG",
	[33] = "cvt.d.wFG"
}
local var27 = {
	shift = 0,
	mask = 63,
	[32] = "cvt.s.lFG",
	[33] = "cvt.d.lFG"
}
local var28 = {
	[0] = "bc1fCB",
	"bc1tCB",
	"bc1flCB",
	"bc1tlCB",
	shift = 16,
	mask = 3
}
local var29 = {
	[0] = "mfc1TG",
	"dmfc1TG",
	"cfc1TG",
	"mfhc1TG",
	"mtc1TG",
	"dmtc1TG",
	"ctc1TG",
	"mthc1TG",
	var28,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	var23,
	var24,
	false,
	false,
	var26,
	var27,
	var25,
	shift = 21,
	mask = 31
}
local var30 = {
	[0] = "lwxc1FSX",
	"ldxc1FSX",
	false,
	false,
	false,
	"luxc1FSX",
	false,
	false,
	"swxc1FSX",
	"sdxc1FSX",
	false,
	false,
	false,
	"suxc1FSX",
	false,
	"prefxMSX",
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	"alnv.psFGHS",
	false,
	"madd.sFRGH",
	"madd.dFRGH",
	false,
	false,
	false,
	false,
	"madd.psFRGH",
	false,
	"msub.sFRGH",
	"msub.dFRGH",
	false,
	false,
	false,
	false,
	"msub.psFRGH",
	false,
	"nmadd.sFRGH",
	"nmadd.dFRGH",
	false,
	false,
	false,
	false,
	"nmadd.psFRGH",
	false,
	"nmsub.sFRGH",
	"nmsub.dFRGH",
	false,
	false,
	false,
	false,
	"nmsub.psFRGH",
	false,
	shift = 0,
	mask = 63
}
local var31 = {
	[0] = var16,
	var21,
	"jJ",
	"jalJ",
	"beq|beqz|bST00B",
	"bne|bnezST0B",
	"blezSB",
	"bgtzSB",
	"addiTSI",
	"addiu|liTS0I",
	"sltiTSI",
	"sltiuTSI",
	"andiTSU",
	"ori|liTS0U",
	"xoriTSU",
	"luiTU",
	var22,
	var29,
	false,
	var30,
	"beql|beqzlST0B",
	"bnel|bnezlST0B",
	"blezlSB",
	"bgtzlSB",
	"daddiTSI",
	"daddiuTSI",
	false,
	false,
	var17,
	"jalxJ",
	false,
	var20,
	"lbTSO",
	"lhTSO",
	"lwlTSO",
	"lwTSO",
	"lbuTSO",
	"lhuTSO",
	"lwrTSO",
	false,
	"sbTSO",
	"shTSO",
	"swlTSO",
	"swTSO",
	false,
	false,
	"swrTSO",
	"cacheNSO",
	"llTSO",
	"lwc1HSO",
	"lwc2TSO",
	"prefNSO",
	false,
	"ldc1HSO",
	"ldc2TSO",
	"ldTSO",
	"scTSO",
	"swc1HSO",
	"swc2TSO",
	false,
	false,
	"sdc1HSO",
	"sdc2TSO",
	"sdTSO"
}
local var32 = {
	[0] = "r0",
	"r1",
	"r2",
	"r3",
	"r4",
	"r5",
	"r6",
	"r7",
	"r8",
	"r9",
	"r10",
	"r11",
	"r12",
	"r13",
	"r14",
	"r15",
	"r16",
	"r17",
	"r18",
	"r19",
	"r20",
	"r21",
	"r22",
	"r23",
	"r24",
	"r25",
	"r26",
	"r27",
	"r28",
	"sp",
	"r30",
	"ra"
}

local function var33(arg0, arg1, arg2)
	local var0 = arg0.pos
	local var1 = ""

	if arg0.rel then
		local var2 = arg0.symtab[arg0.rel]

		if var2 then
			var1 = "\t->" .. var2
		end
	end

	if arg0.hexdump > 0 then
		arg0.out(var2("%08x  %s  %-7s %s%s\n", arg0.addr + var0, var9(arg0.op), arg1, var5(arg2, ", "), var1))
	else
		arg0.out(var2("%08x  %-7s %s%s\n", arg0.addr + var0, arg1, var5(arg2, ", "), var1))
	end

	arg0.pos = var0 + 4
end

local function var34(arg0)
	return var33(arg0, ".long", {
		"0x" .. var9(arg0.op)
	})
end

local function var35(arg0)
	local var0 = arg0.pos
	local var1, var2, var3, var4 = var1(arg0.code, var0 + 1, var0 + 4)

	return var8(var10(var1, 24), var10(var2, 16), var10(var3, 8), var4)
end

local function var36(arg0)
	local var0 = arg0.pos
	local var1, var2, var3, var4 = var1(arg0.code, var0 + 1, var0 + 4)

	return var8(var10(var4, 24), var10(var3, 16), var10(var2, 8), var1)
end

local function var37(arg0)
	local var0 = arg0:get()
	local var1 = {}
	local var2

	arg0.op = var0
	arg0.rel = nil

	local var3 = var31[var11(var0, 26)]

	while var0(var3) ~= "string" do
		if not var3 then
			return var34(arg0)
		end

		var3 = var3[var7(var11(var0, var3.shift), var3.mask)] or var3._
	end

	local var4, var5 = var3(var3, "^([a-z0-9_.]*)(.*)")
	local var6, var7 = var3(var5, "|([a-z0-9_.|]*)(.*)")

	if var6 then
		var5 = var7
	end

	for iter0 in var4(var5, ".") do
		local var8

		if iter0 == "S" then
			var8 = var32[var7(var11(var0, 21), 31)]
		elseif iter0 == "T" then
			var8 = var32[var7(var11(var0, 16), 31)]
		elseif iter0 == "D" then
			var8 = var32[var7(var11(var0, 11), 31)]
		elseif iter0 == "F" then
			var8 = "f" .. var7(var11(var0, 6), 31)
		elseif iter0 == "G" then
			var8 = "f" .. var7(var11(var0, 11), 31)
		elseif iter0 == "H" then
			var8 = "f" .. var7(var11(var0, 16), 31)
		elseif iter0 == "R" then
			var8 = "f" .. var7(var11(var0, 21), 31)
		elseif iter0 == "A" then
			var8 = var7(var11(var0, 6), 31)
		elseif iter0 == "E" then
			var8 = var7(var11(var0, 6), 31) + 32
		elseif iter0 == "M" then
			var8 = var7(var11(var0, 11), 31)
		elseif iter0 == "N" then
			var8 = var7(var11(var0, 16), 31)
		elseif iter0 == "C" then
			var8 = var7(var11(var0, 18), 7)

			if var8 == 0 then
				var8 = nil
			end
		elseif iter0 == "K" then
			var8 = var7(var11(var0, 11), 31) + 1
		elseif iter0 == "P" then
			var8 = var7(var11(var0, 11), 31) + 33
		elseif iter0 == "L" then
			var8 = var7(var11(var0, 11), 31) - var2 + 1
		elseif iter0 == "Q" then
			var8 = var7(var11(var0, 11), 31) - var2 + 33
		elseif iter0 == "I" then
			var8 = var12(var10(var0, 16), 16)
		elseif iter0 == "U" then
			var8 = var7(var0, 65535)
		elseif iter0 == "O" then
			local var9 = var12(var10(var0, 16), 16)

			var1[#var1] = var2("%d(%s)", var9, var2)
		elseif iter0 == "X" then
			local var10 = var32[var7(var11(var0, 16), 31)]

			var1[#var1] = var2("%s(%s)", var10, var2)
		elseif iter0 == "B" then
			var8 = arg0.addr + arg0.pos + var12(var10(var0, 16), 16) * 4 + 4
			arg0.rel = var8
			var8 = var2("0x%08x", var8)
		elseif iter0 == "J" then
			local var11 = arg0.addr + arg0.pos

			var8 = var11 - var7(var11, 268435455) + var7(var0, 67108863) * 4
			arg0.rel = var8
			var8 = var2("0x%08x", var8)
		elseif iter0 == "V" then
			var8 = var7(var11(var0, 8), 7)

			if var8 == 0 then
				var8 = nil
			end
		elseif iter0 == "W" then
			var8 = var7(var0, 7)

			if var8 == 0 then
				var8 = nil
			end
		elseif iter0 == "Y" then
			var8 = var7(var11(var0, 6), 1048575)

			if var8 == 0 then
				var8 = nil
			end
		elseif iter0 == "Z" then
			var8 = var7(var11(var0, 6), 1023)

			if var8 == 0 then
				var8 = nil
			end
		elseif iter0 == "0" then
			if var2 == "r0" or var2 == 0 then
				local var12 = #var1

				var1[var12] = nil
				var2 = var1[var12 - 1]

				if var6 then
					local var13, var14 = var3(var6, "([^|]*)|(.*)")

					if var13 then
						var4, var6 = var13, var14
					else
						var4 = var6
					end
				end
			end
		elseif iter0 == "1" then
			if var2 == "ra" then
				var1[#var1] = nil
			end
		else
			assert(false)
		end

		if var8 then
			var1[#var1 + 1] = var8
			var2 = var8
		end
	end

	return var33(arg0, var4, var1)
end

local function var38(arg0, arg1, arg2)
	arg1 = arg1 or 0

	local var0 = arg2 and arg1 + arg2 or #arg0.code
	local var1 = var0 - var0 % 4

	arg0.pos = arg1 - arg1 % 4
	arg0.rel = nil

	while var1 > arg0.pos do
		var37(arg0)
	end
end

local function var39(arg0, arg1, arg2)
	local var0 = {
		code = arg0,
		addr = arg1 or 0,
		out = arg2 or io.write,
		symtab = {},
		disass = var38
	}

	var0.hexdump = 8
	var0.get = var35

	return var0
end

local function var40(arg0, arg1, arg2)
	local var0 = var39(arg0, arg1, arg2)

	var0.get = var36

	return var0
end

local function var41(arg0, arg1, arg2)
	var39(arg0, arg1, arg2):disass()
end

local function var42(arg0, arg1, arg2)
	var40(arg0, arg1, arg2):disass()
end

local function var43(arg0)
	if arg0 < 32 then
		return var32[arg0]
	end

	return "f" .. arg0 - 32
end

return {
	create = var39,
	create_el = var40,
	disass = var41,
	disass_el = var42,
	regname = var43
}
