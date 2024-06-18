local var0_0 = type
local var1_0 = string.sub
local var2_0 = string.byte
local var3_0 = string.format
local var4_0 = string.match
local var5_0 = string.gmatch
local var6_0 = table.concat
local var7_0 = require("bit")
local var8_0 = var7_0.band
local var9_0 = var7_0.bor
local var10_0 = var7_0.ror
local var11_0 = var7_0.tohex
local var12_0 = var7_0.lshift
local var13_0 = var7_0.rshift
local var14_0 = var7_0.arshift
local var15_0 = {
	shift = 8,
	mask = 15,
	[10] = {
		[0] = {
			[0] = "vmovFmDN",
			"vstmFNdr",
			shift = 23,
			mask = 3,
			_ = {
				[0] = "vstrFdl",
				{
					_ = "vstmdbFNdr",
					shift = 16,
					[13] = "vpushFdr",
					mask = 15
				},
				shift = 21,
				mask = 1
			}
		},
		{
			[0] = "vmovFDNm",
			{
				_ = "vldmFNdr",
				shift = 16,
				[13] = "vpopFdr",
				mask = 15
			},
			shift = 23,
			mask = 3,
			_ = {
				[0] = "vldrFdl",
				"vldmdbFNdr",
				shift = 21,
				mask = 1
			}
		},
		shift = 20,
		mask = 1
	},
	[11] = {
		[0] = {
			[0] = "vmovGmDN",
			"vstmGNdr",
			shift = 23,
			mask = 3,
			_ = {
				[0] = "vstrGdl",
				{
					_ = "vstmdbGNdr",
					shift = 16,
					[13] = "vpushGdr",
					mask = 15
				},
				shift = 21,
				mask = 1
			}
		},
		{
			[0] = "vmovGDNm",
			{
				_ = "vldmGNdr",
				shift = 16,
				[13] = "vpopGdr",
				mask = 15
			},
			shift = 23,
			mask = 3,
			_ = {
				[0] = "vldrGdl",
				"vldmdbGNdr",
				shift = 21,
				mask = 1
			}
		},
		shift = 20,
		mask = 1
	},
	_ = {
		shift = 0,
		mask = 0
	}
}
local var16_0 = {
	[0] = "vmlaF.dnm",
	"vmlsF.dnm",
	[147456] = "vfnmsF.dnm",
	[163840] = "vfmaF.dnm",
	[16385] = "vnmlaF.dnm",
	mask = 180225,
	[32769] = "vnmulF.dnm",
	[163841] = "vfmsF.dnm",
	[32768] = "vmulF.dnm",
	[180224] = "vmovF.dY",
	[49153] = "vsubF.dnm",
	shift = 6,
	[16384] = "vnmlsF.dnm",
	[49152] = "vaddF.dnm",
	[131072] = "vdivF.dnm",
	[147457] = "vfnmaF.dnm",
	[180225] = {
		[0] = "vmovF.dm",
		"vabsF.dm",
		[513] = "vsqrtF.dm",
		[2049] = "vcmpeF.dm",
		[4096] = "vcvt.f32.u32Fdm",
		mask = 7681,
		[4097] = "vcvt.f32.s32Fdm",
		[2561] = "vcmpzeF.d",
		[2048] = "vcmpF.dm",
		[6145] = "vcvt.u32F.dm",
		[6144] = "vcvtr.u32F.dm",
		[2560] = "vcmpzF.d",
		[6656] = "vcvtr.s32F.dm",
		[6657] = "vcvt.s32F.dm",
		shift = 7,
		[512] = "vnegF.dm",
		[3585] = "vcvtG.dF.m"
	}
}
local var17_0 = {
	[0] = "vmlaG.dnm",
	"vmlsG.dnm",
	[147456] = "vfnmsG.dnm",
	[163840] = "vfmaG.dnm",
	[16385] = "vnmlaG.dnm",
	mask = 180225,
	[32769] = "vnmulG.dnm",
	[163841] = "vfmsG.dnm",
	[32768] = "vmulG.dnm",
	[180224] = "vmovG.dY",
	[49153] = "vsubG.dnm",
	shift = 6,
	[16384] = "vnmlsG.dnm",
	[49152] = "vaddG.dnm",
	[131072] = "vdivG.dnm",
	[147457] = "vfnmaG.dnm",
	[180225] = {
		[0] = "vmovG.dm",
		"vabsG.dm",
		[513] = "vsqrtG.dm",
		[2049] = "vcmpeG.dm",
		[4096] = "vcvt.f64.u32GdFm",
		mask = 7681,
		[4097] = "vcvt.f64.s32GdFm",
		[2561] = "vcmpzeG.d",
		[2048] = "vcmpG.dm",
		[6145] = "vcvt.u32FdG.m",
		[6144] = "vcvtr.u32FdG.m",
		[2560] = "vcmpzG.d",
		[6656] = "vcvtr.s32FdG.m",
		[6657] = "vcvt.s32FdG.m",
		shift = 7,
		[512] = "vnegG.dm",
		[3585] = "vcvtF.dG.m"
	}
}
local var18_0 = {
	"svcT",
	shift = 24,
	mask = 1,
	[0] = {
		[0] = {
			shift = 8,
			mask = 15,
			[10] = var16_0,
			[11] = var17_0
		},
		{
			shift = 8,
			mask = 15,
			[10] = {
				[0] = "vmovFnD",
				"vmovFDn",
				mask = 15,
				shift = 20,
				[14] = "vmsrD",
				[15] = {
					shift = 12,
					[15] = "vmrs",
					_ = "vmrsD",
					mask = 15
				}
			}
		},
		shift = 4,
		mask = 1
	}
}
local var19_0 = {
	shift = 0,
	mask = 0
}
local var20_0 = {
	shift = 0,
	mask = 0
}
local var21_0 = {
	shift = 0,
	mask = 0
}
local var22_0 = {
	shift = 0,
	mask = 0
}
local var23_0 = {
	shift = 0,
	mask = 0
}
local var24_0 = {
	[0] = false,
	{
		[0] = "sadd16DNM",
		"sasxDNM",
		"ssaxDNM",
		"ssub16DNM",
		"sadd8DNM",
		false,
		false,
		"ssub8DNM",
		shift = 5,
		mask = 7
	},
	{
		[0] = "qadd16DNM",
		"qasxDNM",
		"qsaxDNM",
		"qsub16DNM",
		"qadd8DNM",
		false,
		false,
		"qsub8DNM",
		shift = 5,
		mask = 7
	},
	{
		[0] = "shadd16DNM",
		"shasxDNM",
		"shsaxDNM",
		"shsub16DNM",
		"shadd8DNM",
		false,
		false,
		"shsub8DNM",
		shift = 5,
		mask = 7
	},
	false,
	{
		[0] = "uadd16DNM",
		"uasxDNM",
		"usaxDNM",
		"usub16DNM",
		"uadd8DNM",
		false,
		false,
		"usub8DNM",
		shift = 5,
		mask = 7
	},
	{
		[0] = "uqadd16DNM",
		"uqasxDNM",
		"uqsaxDNM",
		"uqsub16DNM",
		"uqadd8DNM",
		false,
		false,
		"uqsub8DNM",
		shift = 5,
		mask = 7
	},
	{
		[0] = "uhadd16DNM",
		"uhasxDNM",
		"uhsaxDNM",
		"uhsub16DNM",
		"uhadd8DNM",
		false,
		false,
		"uhsub8DNM",
		shift = 5,
		mask = 7
	},
	{
		[0] = "pkhbtDNMU",
		false,
		"pkhtbDNMU",
		{
			shift = 16,
			[15] = "sxtb16DMU",
			_ = "sxtab16DNMU",
			mask = 15
		},
		"pkhbtDNMU",
		"selDNM",
		"pkhtbDNMU",
		shift = 5,
		mask = 7
	},
	false,
	{
		[0] = "ssatDxMu",
		"ssat16DxM",
		"ssatDxMu",
		{
			shift = 16,
			[15] = "sxtbDMU",
			_ = "sxtabDNMU",
			mask = 15
		},
		"ssatDxMu",
		false,
		"ssatDxMu",
		shift = 5,
		mask = 7
	},
	{
		[0] = "ssatDxMu",
		"revDM",
		"ssatDxMu",
		{
			shift = 16,
			[15] = "sxthDMU",
			_ = "sxtahDNMU",
			mask = 15
		},
		"ssatDxMu",
		"rev16DM",
		"ssatDxMu",
		shift = 5,
		mask = 7
	},
	{
		shift = 5,
		mask = 7,
		[3] = {
			shift = 16,
			[15] = "uxtb16DMU",
			_ = "uxtab16DNMU",
			mask = 15
		}
	},
	false,
	{
		[0] = "usatDwMu",
		"usat16DwM",
		"usatDwMu",
		{
			shift = 16,
			[15] = "uxtbDMU",
			_ = "uxtabDNMU",
			mask = 15
		},
		"usatDwMu",
		false,
		"usatDwMu",
		shift = 5,
		mask = 7
	},
	{
		[0] = "usatDwMu",
		"rbitDM",
		"usatDwMu",
		{
			shift = 16,
			[15] = "uxthDMU",
			_ = "uxtahDNMU",
			mask = 15
		},
		"usatDwMu",
		"revshDM",
		"usatDwMu",
		shift = 5,
		mask = 7
	},
	{
		shift = 12,
		mask = 15,
		[15] = {
			"smuadNMS",
			"smuadxNMS",
			"smusdNMS",
			"smusdxNMS",
			shift = 5,
			mask = 7
		},
		_ = {
			[0] = "smladNMSD",
			"smladxNMSD",
			"smlsdNMSD",
			"smlsdxNMSD",
			shift = 5,
			mask = 7
		}
	},
	false,
	false,
	false,
	{
		[0] = "smlaldDNMS",
		"smlaldxDNMS",
		"smlsldDNMS",
		"smlsldxDNMS",
		shift = 5,
		mask = 7
	},
	{
		[0] = {
			shift = 12,
			[15] = "smmulNMS",
			_ = "smmlaNMSD",
			mask = 15
		},
		{
			shift = 12,
			[15] = "smmulrNMS",
			_ = "smmlarNMSD",
			mask = 15
		},
		false,
		false,
		false,
		false,
		"smmlsNMSD",
		"smmlsrNMSD",
		shift = 5,
		mask = 7
	},
	false,
	false,
	{
		shift = 5,
		mask = 7,
		[0] = {
			shift = 12,
			[15] = "usad8NMS",
			_ = "usada8NMSD",
			mask = 15
		}
	},
	false,
	{
		nil,
		"sbfxDMvw",
		shift = 5,
		mask = 3
	},
	{
		nil,
		"sbfxDMvw",
		shift = 5,
		mask = 3
	},
	{
		shift = 5,
		mask = 3,
		[0] = {
			shift = 0,
			[15] = "bfcDvX",
			_ = "bfiDMvX",
			mask = 15
		}
	},
	{
		shift = 5,
		mask = 3,
		[0] = {
			shift = 0,
			[15] = "bfcDvX",
			_ = "bfiDMvX",
			mask = 15
		}
	},
	{
		nil,
		"ubfxDMvw",
		shift = 5,
		mask = 3
	},
	{
		nil,
		"ubfxDMvw",
		shift = 5,
		mask = 3
	},
	shift = 20,
	mask = 31
}
local var25_0 = {
	{
		[0] = "strtDL",
		"ldrtDL",
		nil,
		nil,
		"strbtDL",
		"ldrbtDL",
		shift = 20,
		mask = 5
	},
	shift = 21,
	mask = 9,
	_ = {
		[0] = "strDL",
		"ldrDL",
		nil,
		nil,
		"strbDL",
		"ldrbDL",
		shift = 20,
		mask = 5
	}
}
local var26_0 = {
	[0] = var25_0,
	var24_0,
	shift = 4,
	mask = 1
}
local var27_0 = {
	[0] = {
		[0] = "stmdaNR",
		"stmNR",
		{
			shift = 16,
			mask = 63,
			_ = "stmdbNR",
			[45] = "pushR"
		},
		"stmibNR",
		shift = 23,
		mask = 3
	},
	{
		[0] = "ldmdaNR",
		{
			shift = 16,
			[61] = "popR",
			_ = "ldmNR",
			mask = 63
		},
		"ldmdbNR",
		"ldmibNR",
		shift = 23,
		mask = 3
	},
	shift = 20,
	mask = 1
}
local var28_0 = {
	[0] = "andDNPs",
	"eorDNPs",
	"subDNPs",
	"rsbDNPs",
	"addDNPs",
	"adcDNPs",
	"sbcDNPs",
	"rscDNPs",
	"tstNP",
	"teqNP",
	"cmpNP",
	"cmnNP",
	"orrDNPs",
	"movDPs",
	"bicDNPs",
	"mvnDPs",
	shift = 21,
	mask = 15
}
local var29_0 = {
	[0] = "mulNMSs",
	"mlaNMSDs",
	"umaalDNMS",
	"mlsDNMS",
	"umullDNMSs",
	"umlalDNMSs",
	"smullDNMSs",
	"smlalDNMSs",
	shift = 21,
	mask = 7
}
local var30_0 = {
	[0] = "swpDMN",
	false,
	false,
	false,
	"swpbDMN",
	false,
	false,
	false,
	"strexDMN",
	"ldrexDN",
	"strexdDN",
	"ldrexdDN",
	"strexbDMN",
	"ldrexbDN",
	"strexhDN",
	"ldrexhDN",
	shift = 20,
	mask = 15
}
local var31_0 = {
	[0] = {
		[0] = "smlabbNMSD",
		"smlatbNMSD",
		"smlabtNMSD",
		"smlattNMSD",
		shift = 5,
		mask = 3
	},
	{
		[0] = "smlawbNMSD",
		"smulwbNMS",
		"smlawtNMSD",
		"smulwtNMS",
		shift = 5,
		mask = 3
	},
	{
		[0] = "smlalbbDNMS",
		"smlaltbDNMS",
		"smlalbtDNMS",
		"smlalttDNMS",
		shift = 5,
		mask = 3
	},
	{
		[0] = "smulbbNMS",
		"smultbNMS",
		"smulbtNMS",
		"smulttNMS",
		shift = 5,
		mask = 3
	},
	shift = 21,
	mask = 3
}
local var32_0 = {
	[0] = {
		[0] = "mrsD",
		"msrM",
		shift = 21,
		mask = 1
	},
	{
		"bxM",
		false,
		"clzDM",
		shift = 21,
		mask = 3
	},
	{
		"bxjM",
		shift = 21,
		mask = 3
	},
	{
		"blxM",
		shift = 21,
		mask = 3
	},
	false,
	{
		[0] = "qaddDMN",
		"qsubDMN",
		"qdaddDMN",
		"qdsubDMN",
		shift = 21,
		mask = 3
	},
	false,
	{
		"bkptK",
		shift = 21,
		mask = 3
	},
	shift = 4,
	mask = 7
}
local var33_0 = {
	shift = 4,
	mask = 9,
	[9] = {
		[0] = {
			[0] = var29_0,
			var30_0,
			shift = 24,
			mask = 1
		},
		{
			[0] = "strhDL",
			"ldrhDL",
			shift = 20,
			mask = 1
		},
		{
			[0] = "ldrdDL",
			"ldrsbDL",
			shift = 20,
			mask = 1
		},
		{
			[0] = "strdDL",
			"ldrshDL",
			shift = 20,
			mask = 1
		},
		shift = 5,
		mask = 3
	},
	_ = {
		shift = 20,
		mask = 25,
		[16] = {
			[0] = var32_0,
			var31_0,
			shift = 7,
			mask = 1
		},
		_ = {
			shift = 0,
			mask = 4294967295,
			[var9_0(3785359360)] = "nop",
			_ = var28_0
		}
	}
}
local var34_0 = {
	[16] = "movwDW",
	mask = 31,
	[20] = "movtDW",
	shift = 20,
	[22] = "msrNW",
	[18] = {
		[0] = "nopv6",
		shift = 0,
		_ = "msrNW",
		mask = 983295
	},
	_ = var28_0
}
local var35_0 = {
	[0] = "bB",
	"blB",
	shift = 24,
	mask = 1
}
local var36_0 = {
	[0] = var33_0,
	var34_0,
	var25_0,
	var26_0,
	var27_0,
	var35_0,
	var15_0,
	var18_0
}
local var37_0 = {
	[0] = false,
	var21_0,
	var22_0,
	var23_0,
	false,
	"blxB",
	var19_0,
	var20_0
}
local var38_0 = {
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
	"sp",
	"lr",
	"pc"
}
local var39_0 = {
	[0] = "eq",
	"ne",
	"hs",
	"lo",
	"mi",
	"pl",
	"vs",
	"vc",
	"hi",
	"ls",
	"ge",
	"lt",
	"gt",
	"le",
	"al"
}
local var40_0 = {
	[0] = "lsl",
	"lsr",
	"asr",
	"ror"
}

local function var41_0(arg0_1, arg1_1, arg2_1)
	local var0_1 = arg0_1.pos
	local var1_1 = ""

	if arg0_1.rel then
		local var2_1 = arg0_1.symtab[arg0_1.rel]

		if var2_1 then
			var1_1 = "\t->" .. var2_1
		elseif var8_0(arg0_1.op, 234881024) ~= 167772160 then
			var1_1 = "\t; 0x" .. var11_0(arg0_1.rel)
		end
	end

	if arg0_1.hexdump > 0 then
		arg0_1.out(var3_0("%08x  %s  %-5s %s%s\n", arg0_1.addr + var0_1, var11_0(arg0_1.op), arg1_1, var6_0(arg2_1, ", "), var1_1))
	else
		arg0_1.out(var3_0("%08x  %-5s %s%s\n", arg0_1.addr + var0_1, arg1_1, var6_0(arg2_1, ", "), var1_1))
	end

	arg0_1.pos = var0_1 + 4
end

local function var42_0(arg0_2)
	return var41_0(arg0_2, ".long", {
		"0x" .. var11_0(arg0_2.op)
	})
end

local function var43_0(arg0_3, arg1_3, arg2_3)
	local var0_3 = var38_0[var8_0(var13_0(arg1_3, 16), 15)]
	local var1_3
	local var2_3
	local var3_3 = var8_0(arg1_3, 67108864) == 0

	if not var3_3 and var8_0(arg1_3, 33554432) == 0 then
		var2_3 = var8_0(arg1_3, 4095)

		if var8_0(arg1_3, 8388608) == 0 then
			var2_3 = -var2_3
		end

		if var0_3 == "pc" then
			arg0_3.rel = arg0_3.addr + arg2_3 + 8 + var2_3
		end

		var2_3 = "#" .. var2_3
	elseif var3_3 and var8_0(arg1_3, 4194304) ~= 0 then
		var2_3 = var8_0(arg1_3, 15) + var8_0(var13_0(arg1_3, 4), 240)

		if var8_0(arg1_3, 8388608) == 0 then
			var2_3 = -var2_3
		end

		if var0_3 == "pc" then
			arg0_3.rel = arg0_3.addr + arg2_3 + 8 + var2_3
		end

		var2_3 = "#" .. var2_3
	else
		var2_3 = var38_0[var8_0(arg1_3, 15)]

		if var3_3 or var8_0(arg1_3, 4064) == 0 then
			-- block empty
		elseif var8_0(arg1_3, 4064) == 96 then
			var2_3 = var3_0("%s, rrx", var2_3)
		else
			local var4_3 = var8_0(var13_0(arg1_3, 7), 31)

			if var4_3 == 0 then
				var4_3 = 32
			end

			var2_3 = var3_0("%s, %s #%d", var2_3, var40_0[var8_0(var13_0(arg1_3, 5), 3)], var4_3)
		end

		if var8_0(arg1_3, 8388608) == 0 then
			var2_3 = "-" .. var2_3
		end
	end

	if var2_3 == "#0" then
		var1_3 = var3_0("[%s]", var0_3)
	elseif var8_0(arg1_3, 16777216) == 0 then
		var1_3 = var3_0("[%s], %s", var0_3, var2_3)
	else
		var1_3 = var3_0("[%s, %s]", var0_3, var2_3)
	end

	if var8_0(arg1_3, 18874368) == 18874368 then
		var1_3 = var1_3 .. "!"
	end

	return var1_3
end

local function var44_0(arg0_4, arg1_4, arg2_4)
	local var0_4 = var38_0[var8_0(var13_0(arg1_4, 16), 15)]
	local var1_4 = var8_0(arg1_4, 255) * 4

	if var8_0(arg1_4, 8388608) == 0 then
		var1_4 = -var1_4
	end

	if var0_4 == "pc" then
		arg0_4.rel = arg0_4.addr + arg2_4 + 8 + var1_4
	end

	if var1_4 == 0 then
		return var3_0("[%s]", var0_4)
	else
		return var3_0("[%s, #%d]", var0_4, var1_4)
	end
end

local function var45_0(arg0_5, arg1_5, arg2_5, arg3_5)
	if arg1_5 == "s" then
		return var3_0("s%d", 2 * var8_0(var13_0(arg0_5, arg2_5), 15) + var8_0(var13_0(arg0_5, arg3_5), 1))
	else
		return var3_0("d%d", var8_0(var13_0(arg0_5, arg2_5), 15) + var8_0(var13_0(arg0_5, arg3_5 - 4), 16))
	end
end

local function var46_0(arg0_6)
	local var0_6 = arg0_6.pos
	local var1_6, var2_6, var3_6, var4_6 = var2_0(arg0_6.code, var0_6 + 1, var0_6 + 4)
	local var5_6 = var9_0(var12_0(var4_6, 24), var12_0(var3_6, 16), var12_0(var2_6, 8), var1_6)
	local var6_6 = {}
	local var7_6 = ""
	local var8_6
	local var9_6
	local var10_6
	local var11_6

	arg0_6.op = var5_6
	arg0_6.rel = nil

	local var12_6 = var13_0(var5_6, 28)
	local var13_6

	if var12_6 == 15 then
		var13_6 = var37_0[var8_0(var13_0(var5_6, 25), 7)]
	else
		if var12_6 ~= 14 then
			var7_6 = var39_0[var12_6]
		end

		var13_6 = var36_0[var8_0(var13_0(var5_6, 25), 7)]
	end

	while var0_0(var13_6) ~= "string" do
		if not var13_6 then
			return var42_0(arg0_6)
		end

		var13_6 = var13_6[var8_0(var13_0(var5_6, var13_6.shift), var13_6.mask)] or var13_6._
	end

	local var14_6, var15_6 = var4_0(var13_6, "^([a-z0-9]*)(.*)")

	if var1_0(var15_6, 1, 1) == "." then
		local var16_6, var17_6 = var4_0(var15_6, "^([a-z0-9.]*)(.*)")

		var7_6 = var7_6 .. var16_6
		var15_6 = var17_6
	end

	for iter0_6 in var5_0(var15_6, ".") do
		local var18_6

		if iter0_6 == "D" then
			var18_6 = var38_0[var8_0(var13_0(var5_6, 12), 15)]
		elseif iter0_6 == "N" then
			var18_6 = var38_0[var8_0(var13_0(var5_6, 16), 15)]
		elseif iter0_6 == "S" then
			var18_6 = var38_0[var8_0(var13_0(var5_6, 8), 15)]
		elseif iter0_6 == "M" then
			var18_6 = var38_0[var8_0(var5_6, 15)]
		elseif iter0_6 == "d" then
			var18_6 = var45_0(var5_6, var11_6, 12, 22)
		elseif iter0_6 == "n" then
			var18_6 = var45_0(var5_6, var11_6, 16, 7)
		elseif iter0_6 == "m" then
			var18_6 = var45_0(var5_6, var11_6, 0, 5)
		elseif iter0_6 == "P" then
			if var8_0(var5_6, 33554432) ~= 0 then
				var18_6 = var10_0(var8_0(var5_6, 255), 2 * var8_0(var13_0(var5_6, 8), 15))
			else
				var18_6 = var38_0[var8_0(var5_6, 15)]

				if var8_0(var5_6, 4080) ~= 0 then
					var6_6[#var6_6 + 1] = var18_6

					local var19_6 = var40_0[var8_0(var13_0(var5_6, 5), 3)]
					local var20_6

					if var8_0(var5_6, 3984) == 0 then
						if var19_6 == "ror" then
							var19_6 = "rrx"
						else
							var20_6 = "#32"
						end
					elseif var8_0(var5_6, 16) == 0 then
						var20_6 = "#" .. var8_0(var13_0(var5_6, 7), 31)
					else
						var20_6 = var38_0[var8_0(var13_0(var5_6, 8), 15)]
					end

					if var14_6 == "mov" then
						var14_6 = var19_6
						var18_6 = var20_6
					elseif var20_6 then
						var18_6 = var3_0("%s %s", var19_6, var20_6)
					else
						var18_6 = var19_6
					end
				end
			end
		elseif iter0_6 == "L" then
			var18_6 = var43_0(arg0_6, var5_6, var0_6)
		elseif iter0_6 == "l" then
			var18_6 = var44_0(arg0_6, var5_6, var0_6)
		elseif iter0_6 == "B" then
			local var21_6 = arg0_6.addr + var0_6 + 8 + var14_0(var12_0(var5_6, 8), 6)

			if var12_6 == 15 then
				var21_6 = var21_6 + var8_0(var13_0(var5_6, 23), 2)
			end

			arg0_6.rel = var21_6
			var18_6 = "0x" .. var11_0(var21_6)
		elseif iter0_6 == "F" then
			var11_6 = "s"
		elseif iter0_6 == "G" then
			var11_6 = "d"
		elseif iter0_6 == "." then
			var7_6 = var7_6 .. (var11_6 == "s" and ".f32" or ".f64")
		elseif iter0_6 == "R" then
			if var8_0(var5_6, 2097152) ~= 0 and #var6_6 == 1 then
				var6_6[1] = var6_6[1] .. "!"
			end

			local var22_6 = {}

			for iter1_6 = 0, 15 do
				if var8_0(var13_0(var5_6, iter1_6), 1) == 1 then
					var22_6[#var22_6 + 1] = var38_0[iter1_6]
				end
			end

			var18_6 = "{" .. var6_0(var22_6, ", ") .. "}"
		elseif iter0_6 == "r" then
			if var8_0(var5_6, 2097152) ~= 0 and #var6_6 == 2 then
				var6_6[1] = var6_6[1] .. "!"
			end

			local var23_6 = tonumber(var1_0(var8_6, 2))
			local var24_6 = var8_0(var5_6, 255)

			if var11_6 == "d" then
				var24_6 = var13_0(var24_6, 1)
			end

			var6_6[#var6_6] = var3_0("{%s-%s%d}", var8_6, var11_6, var23_6 + var24_6 - 1)
		elseif iter0_6 == "W" then
			var18_6 = var8_0(var5_6, 4095) + var8_0(var13_0(var5_6, 4), 61440)
		elseif iter0_6 == "T" then
			var18_6 = "#0x" .. var11_0(var8_0(var5_6, 16777215), 6)
		elseif iter0_6 == "U" then
			var18_6 = var8_0(var13_0(var5_6, 7), 31)

			if var18_6 == 0 then
				var18_6 = nil
			end
		elseif iter0_6 == "u" then
			var18_6 = var8_0(var13_0(var5_6, 7), 31)

			if var8_0(var5_6, 64) == 0 then
				if var18_6 == 0 then
					var18_6 = nil
				else
					var18_6 = "lsl #" .. var18_6
				end
			elseif var18_6 == 0 then
				var18_6 = "asr #32"
			else
				var18_6 = "asr #" .. var18_6
			end
		elseif iter0_6 == "v" then
			var18_6 = var8_0(var13_0(var5_6, 7), 31)
		elseif iter0_6 == "w" then
			var18_6 = var8_0(var13_0(var5_6, 16), 31)
		elseif iter0_6 == "x" then
			var18_6 = var8_0(var13_0(var5_6, 16), 31) + 1
		elseif iter0_6 == "X" then
			var18_6 = var8_0(var13_0(var5_6, 16), 31) - var8_6 + 1
		elseif iter0_6 == "Y" then
			var18_6 = var8_0(var13_0(var5_6, 12), 240) + var8_0(var5_6, 15)
		elseif iter0_6 == "K" then
			var18_6 = "#0x" .. var11_0(var8_0(var13_0(var5_6, 4), 65520) + var8_0(var5_6, 15), 4)
		elseif iter0_6 == "s" then
			if var8_0(var5_6, 1048576) ~= 0 then
				var7_6 = "s" .. var7_6
			end
		else
			assert(false)
		end

		if var18_6 then
			var8_6 = var18_6

			if var0_0(var18_6) == "number" then
				var18_6 = "#" .. var18_6
			end

			var6_6[#var6_6 + 1] = var18_6
		end
	end

	return var41_0(arg0_6, var14_6 .. var7_6, var6_6)
end

local function var47_0(arg0_7, arg1_7, arg2_7)
	arg1_7 = arg1_7 or 0

	local var0_7 = arg2_7 and arg1_7 + arg2_7 or #arg0_7.code

	arg0_7.pos = arg1_7
	arg0_7.rel = nil

	while var0_7 > arg0_7.pos do
		var46_0(arg0_7)
	end
end

local function var48_0(arg0_8, arg1_8, arg2_8)
	local var0_8 = {
		code = arg0_8,
		addr = arg1_8 or 0,
		out = arg2_8 or io.write,
		symtab = {},
		disass = var47_0
	}

	var0_8.hexdump = 8

	return var0_8
end

local function var49_0(arg0_9, arg1_9, arg2_9)
	var48_0(arg0_9, arg1_9, arg2_9):disass()
end

local function var50_0(arg0_10)
	if arg0_10 < 16 then
		return var38_0[arg0_10]
	end

	return "d" .. arg0_10 - 16
end

return {
	create = var48_0,
	disass = var49_0,
	regname = var50_0
}
