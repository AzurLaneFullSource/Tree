local var0 = type
local var1 = string.sub
local var2 = string.byte
local var3 = string.format
local var4 = string.match
local var5 = string.gmatch
local var6 = table.concat
local var7 = require("bit")
local var8 = var7.band
local var9 = var7.bor
local var10 = var7.ror
local var11 = var7.tohex
local var12 = var7.lshift
local var13 = var7.rshift
local var14 = var7.arshift
local var15 = {
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
local var16 = {
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
local var17 = {
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
local var18 = {
	"svcT",
	shift = 24,
	mask = 1,
	[0] = {
		[0] = {
			shift = 8,
			mask = 15,
			[10] = var16,
			[11] = var17
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
local var19 = {
	shift = 0,
	mask = 0
}
local var20 = {
	shift = 0,
	mask = 0
}
local var21 = {
	shift = 0,
	mask = 0
}
local var22 = {
	shift = 0,
	mask = 0
}
local var23 = {
	shift = 0,
	mask = 0
}
local var24 = {
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
local var25 = {
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
local var26 = {
	[0] = var25,
	var24,
	shift = 4,
	mask = 1
}
local var27 = {
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
local var28 = {
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
local var29 = {
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
local var30 = {
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
local var31 = {
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
local var32 = {
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
local var33 = {
	shift = 4,
	mask = 9,
	[9] = {
		[0] = {
			[0] = var29,
			var30,
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
			[0] = var32,
			var31,
			shift = 7,
			mask = 1
		},
		_ = {
			shift = 0,
			mask = 4294967295,
			[var9(3785359360)] = "nop",
			_ = var28
		}
	}
}
local var34 = {
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
	_ = var28
}
local var35 = {
	[0] = "bB",
	"blB",
	shift = 24,
	mask = 1
}
local var36 = {
	[0] = var33,
	var34,
	var25,
	var26,
	var27,
	var35,
	var15,
	var18
}
local var37 = {
	[0] = false,
	var21,
	var22,
	var23,
	false,
	"blxB",
	var19,
	var20
}
local var38 = {
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
local var39 = {
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
local var40 = {
	[0] = "lsl",
	"lsr",
	"asr",
	"ror"
}

local function var41(arg0, arg1, arg2)
	local var0 = arg0.pos
	local var1 = ""

	if arg0.rel then
		local var2 = arg0.symtab[arg0.rel]

		if var2 then
			var1 = "\t->" .. var2
		elseif var8(arg0.op, 234881024) ~= 167772160 then
			var1 = "\t; 0x" .. var11(arg0.rel)
		end
	end

	if arg0.hexdump > 0 then
		arg0.out(var3("%08x  %s  %-5s %s%s\n", arg0.addr + var0, var11(arg0.op), arg1, var6(arg2, ", "), var1))
	else
		arg0.out(var3("%08x  %-5s %s%s\n", arg0.addr + var0, arg1, var6(arg2, ", "), var1))
	end

	arg0.pos = var0 + 4
end

local function var42(arg0)
	return var41(arg0, ".long", {
		"0x" .. var11(arg0.op)
	})
end

local function var43(arg0, arg1, arg2)
	local var0 = var38[var8(var13(arg1, 16), 15)]
	local var1
	local var2
	local var3 = var8(arg1, 67108864) == 0

	if not var3 and var8(arg1, 33554432) == 0 then
		var2 = var8(arg1, 4095)

		if var8(arg1, 8388608) == 0 then
			var2 = -var2
		end

		if var0 == "pc" then
			arg0.rel = arg0.addr + arg2 + 8 + var2
		end

		var2 = "#" .. var2
	elseif var3 and var8(arg1, 4194304) ~= 0 then
		var2 = var8(arg1, 15) + var8(var13(arg1, 4), 240)

		if var8(arg1, 8388608) == 0 then
			var2 = -var2
		end

		if var0 == "pc" then
			arg0.rel = arg0.addr + arg2 + 8 + var2
		end

		var2 = "#" .. var2
	else
		var2 = var38[var8(arg1, 15)]

		if var3 or var8(arg1, 4064) == 0 then
			-- block empty
		elseif var8(arg1, 4064) == 96 then
			var2 = var3("%s, rrx", var2)
		else
			local var4 = var8(var13(arg1, 7), 31)

			if var4 == 0 then
				var4 = 32
			end

			var2 = var3("%s, %s #%d", var2, var40[var8(var13(arg1, 5), 3)], var4)
		end

		if var8(arg1, 8388608) == 0 then
			var2 = "-" .. var2
		end
	end

	if var2 == "#0" then
		var1 = var3("[%s]", var0)
	elseif var8(arg1, 16777216) == 0 then
		var1 = var3("[%s], %s", var0, var2)
	else
		var1 = var3("[%s, %s]", var0, var2)
	end

	if var8(arg1, 18874368) == 18874368 then
		var1 = var1 .. "!"
	end

	return var1
end

local function var44(arg0, arg1, arg2)
	local var0 = var38[var8(var13(arg1, 16), 15)]
	local var1 = var8(arg1, 255) * 4

	if var8(arg1, 8388608) == 0 then
		var1 = -var1
	end

	if var0 == "pc" then
		arg0.rel = arg0.addr + arg2 + 8 + var1
	end

	if var1 == 0 then
		return var3("[%s]", var0)
	else
		return var3("[%s, #%d]", var0, var1)
	end
end

local function var45(arg0, arg1, arg2, arg3)
	if arg1 == "s" then
		return var3("s%d", 2 * var8(var13(arg0, arg2), 15) + var8(var13(arg0, arg3), 1))
	else
		return var3("d%d", var8(var13(arg0, arg2), 15) + var8(var13(arg0, arg3 - 4), 16))
	end
end

local function var46(arg0)
	local var0 = arg0.pos
	local var1, var2, var3, var4 = var2(arg0.code, var0 + 1, var0 + 4)
	local var5 = var9(var12(var4, 24), var12(var3, 16), var12(var2, 8), var1)
	local var6 = {}
	local var7 = ""
	local var8
	local var9
	local var10
	local var11

	arg0.op = var5
	arg0.rel = nil

	local var12 = var13(var5, 28)
	local var13

	if var12 == 15 then
		var13 = var37[var8(var13(var5, 25), 7)]
	else
		if var12 ~= 14 then
			var7 = var39[var12]
		end

		var13 = var36[var8(var13(var5, 25), 7)]
	end

	while var0(var13) ~= "string" do
		if not var13 then
			return var42(arg0)
		end

		var13 = var13[var8(var13(var5, var13.shift), var13.mask)] or var13._
	end

	local var14, var15 = var4(var13, "^([a-z0-9]*)(.*)")

	if var1(var15, 1, 1) == "." then
		local var16, var17 = var4(var15, "^([a-z0-9.]*)(.*)")

		var7 = var7 .. var16
		var15 = var17
	end

	for iter0 in var5(var15, ".") do
		local var18

		if iter0 == "D" then
			var18 = var38[var8(var13(var5, 12), 15)]
		elseif iter0 == "N" then
			var18 = var38[var8(var13(var5, 16), 15)]
		elseif iter0 == "S" then
			var18 = var38[var8(var13(var5, 8), 15)]
		elseif iter0 == "M" then
			var18 = var38[var8(var5, 15)]
		elseif iter0 == "d" then
			var18 = var45(var5, var11, 12, 22)
		elseif iter0 == "n" then
			var18 = var45(var5, var11, 16, 7)
		elseif iter0 == "m" then
			var18 = var45(var5, var11, 0, 5)
		elseif iter0 == "P" then
			if var8(var5, 33554432) ~= 0 then
				var18 = var10(var8(var5, 255), 2 * var8(var13(var5, 8), 15))
			else
				var18 = var38[var8(var5, 15)]

				if var8(var5, 4080) ~= 0 then
					var6[#var6 + 1] = var18

					local var19 = var40[var8(var13(var5, 5), 3)]
					local var20

					if var8(var5, 3984) == 0 then
						if var19 == "ror" then
							var19 = "rrx"
						else
							var20 = "#32"
						end
					elseif var8(var5, 16) == 0 then
						var20 = "#" .. var8(var13(var5, 7), 31)
					else
						var20 = var38[var8(var13(var5, 8), 15)]
					end

					if var14 == "mov" then
						var14 = var19
						var18 = var20
					elseif var20 then
						var18 = var3("%s %s", var19, var20)
					else
						var18 = var19
					end
				end
			end
		elseif iter0 == "L" then
			var18 = var43(arg0, var5, var0)
		elseif iter0 == "l" then
			var18 = var44(arg0, var5, var0)
		elseif iter0 == "B" then
			local var21 = arg0.addr + var0 + 8 + var14(var12(var5, 8), 6)

			if var12 == 15 then
				var21 = var21 + var8(var13(var5, 23), 2)
			end

			arg0.rel = var21
			var18 = "0x" .. var11(var21)
		elseif iter0 == "F" then
			var11 = "s"
		elseif iter0 == "G" then
			var11 = "d"
		elseif iter0 == "." then
			var7 = var7 .. (var11 == "s" and ".f32" or ".f64")
		elseif iter0 == "R" then
			if var8(var5, 2097152) ~= 0 and #var6 == 1 then
				var6[1] = var6[1] .. "!"
			end

			local var22 = {}

			for iter1 = 0, 15 do
				if var8(var13(var5, iter1), 1) == 1 then
					var22[#var22 + 1] = var38[iter1]
				end
			end

			var18 = "{" .. var6(var22, ", ") .. "}"
		elseif iter0 == "r" then
			if var8(var5, 2097152) ~= 0 and #var6 == 2 then
				var6[1] = var6[1] .. "!"
			end

			local var23 = tonumber(var1(var8, 2))
			local var24 = var8(var5, 255)

			if var11 == "d" then
				var24 = var13(var24, 1)
			end

			var6[#var6] = var3("{%s-%s%d}", var8, var11, var23 + var24 - 1)
		elseif iter0 == "W" then
			var18 = var8(var5, 4095) + var8(var13(var5, 4), 61440)
		elseif iter0 == "T" then
			var18 = "#0x" .. var11(var8(var5, 16777215), 6)
		elseif iter0 == "U" then
			var18 = var8(var13(var5, 7), 31)

			if var18 == 0 then
				var18 = nil
			end
		elseif iter0 == "u" then
			var18 = var8(var13(var5, 7), 31)

			if var8(var5, 64) == 0 then
				if var18 == 0 then
					var18 = nil
				else
					var18 = "lsl #" .. var18
				end
			elseif var18 == 0 then
				var18 = "asr #32"
			else
				var18 = "asr #" .. var18
			end
		elseif iter0 == "v" then
			var18 = var8(var13(var5, 7), 31)
		elseif iter0 == "w" then
			var18 = var8(var13(var5, 16), 31)
		elseif iter0 == "x" then
			var18 = var8(var13(var5, 16), 31) + 1
		elseif iter0 == "X" then
			var18 = var8(var13(var5, 16), 31) - var8 + 1
		elseif iter0 == "Y" then
			var18 = var8(var13(var5, 12), 240) + var8(var5, 15)
		elseif iter0 == "K" then
			var18 = "#0x" .. var11(var8(var13(var5, 4), 65520) + var8(var5, 15), 4)
		elseif iter0 == "s" then
			if var8(var5, 1048576) ~= 0 then
				var7 = "s" .. var7
			end
		else
			assert(false)
		end

		if var18 then
			var8 = var18

			if var0(var18) == "number" then
				var18 = "#" .. var18
			end

			var6[#var6 + 1] = var18
		end
	end

	return var41(arg0, var14 .. var7, var6)
end

local function var47(arg0, arg1, arg2)
	arg1 = arg1 or 0

	local var0 = arg2 and arg1 + arg2 or #arg0.code

	arg0.pos = arg1
	arg0.rel = nil

	while var0 > arg0.pos do
		var46(arg0)
	end
end

local function var48(arg0, arg1, arg2)
	local var0 = {
		code = arg0,
		addr = arg1 or 0,
		out = arg2 or io.write,
		symtab = {},
		disass = var47
	}

	var0.hexdump = 8

	return var0
end

local function var49(arg0, arg1, arg2)
	var48(arg0, arg1, arg2):disass()
end

local function var50(arg0)
	if arg0 < 16 then
		return var38[arg0]
	end

	return "d" .. arg0 - 16
end

return {
	create = var48,
	disass = var49,
	regname = var50
}
