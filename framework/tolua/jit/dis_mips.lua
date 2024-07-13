local var0_0 = type
local var1_0 = string.byte
local var2_0 = string.format
local var3_0 = string.match
local var4_0 = string.gmatch
local var5_0 = table.concat
local var6_0 = require("bit")
local var7_0 = var6_0.band
local var8_0 = var6_0.bor
local var9_0 = var6_0.tohex
local var10_0 = var6_0.lshift
local var11_0 = var6_0.rshift
local var12_0 = var6_0.arshift
local var13_0 = {
	[0] = "movfDSC",
	"movtDSC",
	shift = 16,
	mask = 1
}
local var14_0 = {
	[0] = "srlDTA",
	"rotrDTA",
	shift = 21,
	mask = 1
}
local var15_0 = {
	[0] = "srlvDTS",
	"rotrvDTS",
	shift = 6,
	mask = 1
}
local var16_0 = {
	[0] = {
		[0] = "nop",
		shift = 0,
		_ = "sllDTA",
		mask = -1
	},
	var13_0,
	var14_0,
	"sraDTA",
	"sllvDTS",
	false,
	var15_0,
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
local var17_0 = {
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
local var18_0 = {
	nil,
	"wsbhDT",
	[24] = "sehDT",
	shift = 6,
	[16] = "sebDT",
	mask = 31
}
local var19_0 = {
	nil,
	"dsbhDT",
	[5] = "dshdDT",
	shift = 6,
	mask = 31
}
local var20_0 = {
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
	[32] = var18_0,
	[36] = var19_0
}
local var21_0 = {
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
local var22_0 = {
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
local var23_0 = {
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
local var24_0 = {
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
local var25_0 = {
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
local var26_0 = {
	shift = 0,
	mask = 63,
	[32] = "cvt.s.wFG",
	[33] = "cvt.d.wFG"
}
local var27_0 = {
	shift = 0,
	mask = 63,
	[32] = "cvt.s.lFG",
	[33] = "cvt.d.lFG"
}
local var28_0 = {
	[0] = "bc1fCB",
	"bc1tCB",
	"bc1flCB",
	"bc1tlCB",
	shift = 16,
	mask = 3
}
local var29_0 = {
	[0] = "mfc1TG",
	"dmfc1TG",
	"cfc1TG",
	"mfhc1TG",
	"mtc1TG",
	"dmtc1TG",
	"ctc1TG",
	"mthc1TG",
	var28_0,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	var23_0,
	var24_0,
	false,
	false,
	var26_0,
	var27_0,
	var25_0,
	shift = 21,
	mask = 31
}
local var30_0 = {
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
local var31_0 = {
	[0] = var16_0,
	var21_0,
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
	var22_0,
	var29_0,
	false,
	var30_0,
	"beql|beqzlST0B",
	"bnel|bnezlST0B",
	"blezlSB",
	"bgtzlSB",
	"daddiTSI",
	"daddiuTSI",
	false,
	false,
	var17_0,
	"jalxJ",
	false,
	var20_0,
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
local var32_0 = {
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

local function var33_0(arg0_1, arg1_1, arg2_1)
	local var0_1 = arg0_1.pos
	local var1_1 = ""

	if arg0_1.rel then
		local var2_1 = arg0_1.symtab[arg0_1.rel]

		if var2_1 then
			var1_1 = "\t->" .. var2_1
		end
	end

	if arg0_1.hexdump > 0 then
		arg0_1.out(var2_0("%08x  %s  %-7s %s%s\n", arg0_1.addr + var0_1, var9_0(arg0_1.op), arg1_1, var5_0(arg2_1, ", "), var1_1))
	else
		arg0_1.out(var2_0("%08x  %-7s %s%s\n", arg0_1.addr + var0_1, arg1_1, var5_0(arg2_1, ", "), var1_1))
	end

	arg0_1.pos = var0_1 + 4
end

local function var34_0(arg0_2)
	return var33_0(arg0_2, ".long", {
		"0x" .. var9_0(arg0_2.op)
	})
end

local function var35_0(arg0_3)
	local var0_3 = arg0_3.pos
	local var1_3, var2_3, var3_3, var4_3 = var1_0(arg0_3.code, var0_3 + 1, var0_3 + 4)

	return var8_0(var10_0(var1_3, 24), var10_0(var2_3, 16), var10_0(var3_3, 8), var4_3)
end

local function var36_0(arg0_4)
	local var0_4 = arg0_4.pos
	local var1_4, var2_4, var3_4, var4_4 = var1_0(arg0_4.code, var0_4 + 1, var0_4 + 4)

	return var8_0(var10_0(var4_4, 24), var10_0(var3_4, 16), var10_0(var2_4, 8), var1_4)
end

local function var37_0(arg0_5)
	local var0_5 = arg0_5:get()
	local var1_5 = {}
	local var2_5

	arg0_5.op = var0_5
	arg0_5.rel = nil

	local var3_5 = var31_0[var11_0(var0_5, 26)]

	while var0_0(var3_5) ~= "string" do
		if not var3_5 then
			return var34_0(arg0_5)
		end

		var3_5 = var3_5[var7_0(var11_0(var0_5, var3_5.shift), var3_5.mask)] or var3_5._
	end

	local var4_5, var5_5 = var3_0(var3_5, "^([a-z0-9_.]*)(.*)")
	local var6_5, var7_5 = var3_0(var5_5, "|([a-z0-9_.|]*)(.*)")

	if var6_5 then
		var5_5 = var7_5
	end

	for iter0_5 in var4_0(var5_5, ".") do
		local var8_5

		if iter0_5 == "S" then
			var8_5 = var32_0[var7_0(var11_0(var0_5, 21), 31)]
		elseif iter0_5 == "T" then
			var8_5 = var32_0[var7_0(var11_0(var0_5, 16), 31)]
		elseif iter0_5 == "D" then
			var8_5 = var32_0[var7_0(var11_0(var0_5, 11), 31)]
		elseif iter0_5 == "F" then
			var8_5 = "f" .. var7_0(var11_0(var0_5, 6), 31)
		elseif iter0_5 == "G" then
			var8_5 = "f" .. var7_0(var11_0(var0_5, 11), 31)
		elseif iter0_5 == "H" then
			var8_5 = "f" .. var7_0(var11_0(var0_5, 16), 31)
		elseif iter0_5 == "R" then
			var8_5 = "f" .. var7_0(var11_0(var0_5, 21), 31)
		elseif iter0_5 == "A" then
			var8_5 = var7_0(var11_0(var0_5, 6), 31)
		elseif iter0_5 == "E" then
			var8_5 = var7_0(var11_0(var0_5, 6), 31) + 32
		elseif iter0_5 == "M" then
			var8_5 = var7_0(var11_0(var0_5, 11), 31)
		elseif iter0_5 == "N" then
			var8_5 = var7_0(var11_0(var0_5, 16), 31)
		elseif iter0_5 == "C" then
			var8_5 = var7_0(var11_0(var0_5, 18), 7)

			if var8_5 == 0 then
				var8_5 = nil
			end
		elseif iter0_5 == "K" then
			var8_5 = var7_0(var11_0(var0_5, 11), 31) + 1
		elseif iter0_5 == "P" then
			var8_5 = var7_0(var11_0(var0_5, 11), 31) + 33
		elseif iter0_5 == "L" then
			var8_5 = var7_0(var11_0(var0_5, 11), 31) - var2_5 + 1
		elseif iter0_5 == "Q" then
			var8_5 = var7_0(var11_0(var0_5, 11), 31) - var2_5 + 33
		elseif iter0_5 == "I" then
			var8_5 = var12_0(var10_0(var0_5, 16), 16)
		elseif iter0_5 == "U" then
			var8_5 = var7_0(var0_5, 65535)
		elseif iter0_5 == "O" then
			local var9_5 = var12_0(var10_0(var0_5, 16), 16)

			var1_5[#var1_5] = var2_0("%d(%s)", var9_5, var2_5)
		elseif iter0_5 == "X" then
			local var10_5 = var32_0[var7_0(var11_0(var0_5, 16), 31)]

			var1_5[#var1_5] = var2_0("%s(%s)", var10_5, var2_5)
		elseif iter0_5 == "B" then
			var8_5 = arg0_5.addr + arg0_5.pos + var12_0(var10_0(var0_5, 16), 16) * 4 + 4
			arg0_5.rel = var8_5
			var8_5 = var2_0("0x%08x", var8_5)
		elseif iter0_5 == "J" then
			local var11_5 = arg0_5.addr + arg0_5.pos

			var8_5 = var11_5 - var7_0(var11_5, 268435455) + var7_0(var0_5, 67108863) * 4
			arg0_5.rel = var8_5
			var8_5 = var2_0("0x%08x", var8_5)
		elseif iter0_5 == "V" then
			var8_5 = var7_0(var11_0(var0_5, 8), 7)

			if var8_5 == 0 then
				var8_5 = nil
			end
		elseif iter0_5 == "W" then
			var8_5 = var7_0(var0_5, 7)

			if var8_5 == 0 then
				var8_5 = nil
			end
		elseif iter0_5 == "Y" then
			var8_5 = var7_0(var11_0(var0_5, 6), 1048575)

			if var8_5 == 0 then
				var8_5 = nil
			end
		elseif iter0_5 == "Z" then
			var8_5 = var7_0(var11_0(var0_5, 6), 1023)

			if var8_5 == 0 then
				var8_5 = nil
			end
		elseif iter0_5 == "0" then
			if var2_5 == "r0" or var2_5 == 0 then
				local var12_5 = #var1_5

				var1_5[var12_5] = nil
				var2_5 = var1_5[var12_5 - 1]

				if var6_5 then
					local var13_5, var14_5 = var3_0(var6_5, "([^|]*)|(.*)")

					if var13_5 then
						var4_5, var6_5 = var13_5, var14_5
					else
						var4_5 = var6_5
					end
				end
			end
		elseif iter0_5 == "1" then
			if var2_5 == "ra" then
				var1_5[#var1_5] = nil
			end
		else
			assert(false)
		end

		if var8_5 then
			var1_5[#var1_5 + 1] = var8_5
			var2_5 = var8_5
		end
	end

	return var33_0(arg0_5, var4_5, var1_5)
end

local function var38_0(arg0_6, arg1_6, arg2_6)
	arg1_6 = arg1_6 or 0

	local var0_6 = arg2_6 and arg1_6 + arg2_6 or #arg0_6.code
	local var1_6 = var0_6 - var0_6 % 4

	arg0_6.pos = arg1_6 - arg1_6 % 4
	arg0_6.rel = nil

	while var1_6 > arg0_6.pos do
		var37_0(arg0_6)
	end
end

local function var39_0(arg0_7, arg1_7, arg2_7)
	local var0_7 = {
		code = arg0_7,
		addr = arg1_7 or 0,
		out = arg2_7 or io.write,
		symtab = {},
		disass = var38_0
	}

	var0_7.hexdump = 8
	var0_7.get = var35_0

	return var0_7
end

local function var40_0(arg0_8, arg1_8, arg2_8)
	local var0_8 = var39_0(arg0_8, arg1_8, arg2_8)

	var0_8.get = var36_0

	return var0_8
end

local function var41_0(arg0_9, arg1_9, arg2_9)
	var39_0(arg0_9, arg1_9, arg2_9):disass()
end

local function var42_0(arg0_10, arg1_10, arg2_10)
	var40_0(arg0_10, arg1_10, arg2_10):disass()
end

local function var43_0(arg0_11)
	if arg0_11 < 32 then
		return var32_0[arg0_11]
	end

	return "f" .. arg0_11 - 32
end

return {
	create = var39_0,
	create_el = var40_0,
	disass = var41_0,
	disass_el = var42_0,
	regname = var43_0
}
