local var0_0 = type
local var1_0 = string.sub
local var2_0 = string.byte
local var3_0 = string.format
local var4_0 = string.match
local var5_0 = string.gmatch
local var6_0 = string.gsub
local var7_0 = table.concat
local var8_0 = require("bit")
local var9_0 = var8_0.band
local var10_0 = var8_0.bor
local var11_0 = var8_0.bxor
local var12_0 = var8_0.tohex
local var13_0 = var8_0.lshift
local var14_0 = var8_0.rshift
local var15_0 = var8_0.arshift
local var16_0 = var8_0.ror
local var17_0 = {
	[0] = "adrDBx",
	"adrpDBx",
	shift = 31,
	mask = 1
}
local var18_0 = {
	[0] = "add|movDNIg",
	"adds|cmnD0NIg",
	"subDNIg",
	"subs|cmpD0NIg",
	shift = 29,
	mask = 3
}
local var19_0 = {
	[0] = {
		false,
		shift = 22,
		mask = 1,
		[0] = {
			[0] = "andDNig",
			"orr|movDN0ig",
			"eorDNig",
			"ands|tstD0Nig",
			shift = 29,
			mask = 3
		}
	},
	{
		[0] = "andDNig",
		"orr|movDN0ig",
		"eorDNig",
		"ands|tstD0Nig",
		shift = 29,
		mask = 3
	},
	shift = 31,
	mask = 1
}
local var20_0 = {
	[0] = {
		false,
		shift = 22,
		mask = 1,
		[0] = {
			[0] = "movnDWRg",
			false,
			"movz|movDYRg",
			"movkDWRg",
			shift = 29,
			mask = 3
		}
	},
	{
		[0] = "movnDWRg",
		false,
		"movz|movDYRg",
		"movkDWRg",
		shift = 29,
		mask = 3
	},
	shift = 31,
	mask = 1
}
local var21_0 = {
	[0] = {
		shift = 22,
		mask = 1,
		[0] = {
			[0] = "sbfm|sbfiz|sbfx|asr|sxtw|sxth|sxtbDN12w",
			"bfm|bfi|bfxilDN13w",
			"ubfm|ubfiz|ubfx|lsr|lsl|uxth|uxtbDN12w",
			shift = 29,
			mask = 3
		}
	},
	{
		{
			[0] = "sbfm|sbfiz|sbfx|asr|sxtw|sxth|sxtbDN12x",
			"bfm|bfi|bfxilDN13x",
			"ubfm|ubfiz|ubfx|lsr|lsl|uxth|uxtbDN12x",
			shift = 29,
			mask = 3
		},
		shift = 22,
		mask = 1
	},
	shift = 31,
	mask = 1
}
local var22_0 = {
	[0] = var17_0,
	var17_0,
	var18_0,
	false,
	var19_0,
	var20_0,
	var21_0,
	{
		[0] = "extr|rorDNM4w",
		shift = 15,
		[65665] = "extr|rorDNM4x",
		[65664] = "extr|rorDNM4x",
		mask = 114881
	},
	shift = 23,
	mask = 7
}
local var23_0 = {
	[0] = {
		false,
		shift = 15,
		mask = 1,
		[0] = {
			[0] = {
				[0] = "andDNMSg",
				"bicDNMSg",
				"andDNMSg",
				"bicDNMSg",
				"andDNMSg",
				"bicDNMSg",
				"andDNMg",
				"bicDNMg",
				shift = 21,
				mask = 7
			},
			{
				[0] = "orr|movDN0MSg",
				"orn|mvnDN0MSg",
				"orr|movDN0MSg",
				"orn|mvnDN0MSg",
				"orr|movDN0MSg",
				"orn|mvnDN0MSg",
				"orr|movDN0Mg",
				"orn|mvnDN0Mg",
				shift = 21,
				mask = 7
			},
			{
				[0] = "eorDNMSg",
				"eonDNMSg",
				"eorDNMSg",
				"eonDNMSg",
				"eorDNMSg",
				"eonDNMSg",
				"eorDNMg",
				"eonDNMg",
				shift = 21,
				mask = 7
			},
			{
				[0] = "ands|tstD0NMSg",
				"bicsDNMSg",
				"ands|tstD0NMSg",
				"bicsDNMSg",
				"ands|tstD0NMSg",
				"bicsDNMSg",
				"ands|tstD0NMg",
				"bicsDNMg",
				shift = 21,
				mask = 7
			},
			shift = 29,
			mask = 3
		}
	},
	{
		[0] = {
			[0] = "andDNMSg",
			"bicDNMSg",
			"andDNMSg",
			"bicDNMSg",
			"andDNMSg",
			"bicDNMSg",
			"andDNMg",
			"bicDNMg",
			shift = 21,
			mask = 7
		},
		{
			[0] = "orr|movDN0MSg",
			"orn|mvnDN0MSg",
			"orr|movDN0MSg",
			"orn|mvnDN0MSg",
			"orr|movDN0MSg",
			"orn|mvnDN0MSg",
			"orr|movDN0Mg",
			"orn|mvnDN0Mg",
			shift = 21,
			mask = 7
		},
		{
			[0] = "eorDNMSg",
			"eonDNMSg",
			"eorDNMSg",
			"eonDNMSg",
			"eorDNMSg",
			"eonDNMSg",
			"eorDNMg",
			"eonDNMg",
			shift = 21,
			mask = 7
		},
		{
			[0] = "ands|tstD0NMSg",
			"bicsDNMSg",
			"ands|tstD0NMSg",
			"bicsDNMSg",
			"ands|tstD0NMSg",
			"bicsDNMSg",
			"ands|tstD0NMg",
			"bicsDNMg",
			shift = 21,
			mask = 7
		},
		shift = 29,
		mask = 3
	},
	shift = 31,
	mask = 1
}
local var24_0 = {
	[0] = {
		false,
		shift = 15,
		mask = 1,
		[0] = {
			[0] = {
				[0] = "addDNMSg",
				"addDNMSg",
				"addDNMSg",
				"addDNMg",
				shift = 22,
				mask = 3
			},
			{
				[0] = "adds|cmnD0NMSg",
				"adds|cmnD0NMSg",
				"adds|cmnD0NMSg",
				"adds|cmnD0NMg",
				shift = 22,
				mask = 3
			},
			{
				[0] = "sub|negDN0MSg",
				"sub|negDN0MSg",
				"sub|negDN0MSg",
				"sub|negDN0Mg",
				shift = 22,
				mask = 3
			},
			{
				[0] = "subs|cmp|negsD0N0MzSg",
				"subs|cmp|negsD0N0MzSg",
				"subs|cmp|negsD0N0MzSg",
				"subs|cmp|negsD0N0Mzg",
				shift = 22,
				mask = 3
			},
			shift = 29,
			mask = 3
		}
	},
	{
		[0] = {
			[0] = "addDNMSg",
			"addDNMSg",
			"addDNMSg",
			"addDNMg",
			shift = 22,
			mask = 3
		},
		{
			[0] = "adds|cmnD0NMSg",
			"adds|cmnD0NMSg",
			"adds|cmnD0NMSg",
			"adds|cmnD0NMg",
			shift = 22,
			mask = 3
		},
		{
			[0] = "sub|negDN0MSg",
			"sub|negDN0MSg",
			"sub|negDN0MSg",
			"sub|negDN0Mg",
			shift = 22,
			mask = 3
		},
		{
			[0] = "subs|cmp|negsD0N0MzSg",
			"subs|cmp|negsD0N0MzSg",
			"subs|cmp|negsD0N0MzSg",
			"subs|cmp|negsD0N0Mzg",
			shift = 22,
			mask = 3
		},
		shift = 29,
		mask = 3
	},
	shift = 31,
	mask = 1
}
local var25_0 = {
	[0] = var24_0,
	var24_0,
	var24_0,
	shift = 22,
	mask = 3
}
local var26_0 = {
	shift = 22,
	mask = 3,
	[0] = {
		[0] = "addDNMXg",
		"adds|cmnD0NMXg",
		"subDNMXg",
		"subs|cmpD0NMzXg",
		shift = 29,
		mask = 3
	}
}
local var27_0 = {
	shift = 10,
	mask = 63,
	[0] = {
		[0] = "adcDNMg",
		"adcsDNMg",
		"sbc|ngcDN0Mg",
		"sbcs|ngcsDN0Mg",
		shift = 29,
		mask = 3
	}
}
local var28_0 = {
	shift = 4,
	mask = 1,
	[0] = {
		shift = 10,
		mask = 3,
		[0] = {
			"ccmnNMVCg",
			false,
			"ccmpNMVCg",
			shift = 29,
			mask = 3
		},
		[2] = {
			"ccmnN5VCg",
			false,
			"ccmpN5VCg",
			shift = 29,
			mask = 3
		}
	}
}
local var29_0 = {
	shift = 11,
	mask = 1,
	[0] = {
		[0] = {
			[0] = "cselDNMzCg",
			false,
			"csinv|cinv|csetmDNMcg",
			false,
			shift = 29,
			mask = 3
		},
		{
			[0] = "csinc|cinc|csetDNMcg",
			false,
			"csneg|cnegDNMcg",
			false,
			shift = 29,
			mask = 3
		},
		shift = 10,
		mask = 1
	}
}
local var30_0 = {
	shift = 29,
	mask = 1,
	[0] = {
		[0] = {
			[0] = "rbitDNg",
			"rev16DNg",
			"revDNw",
			false,
			"clzDNg",
			"clsDNg",
			shift = 10,
			mask = 2047
		},
		{
			[0] = "rbitDNg",
			"rev16DNg",
			"rev32DNx",
			"revDNx",
			"clzDNg",
			"clsDNg",
			shift = 10,
			mask = 2047
		},
		shift = 31,
		mask = 1
	}
}
local var31_0 = {
	shift = 29,
	mask = 1,
	[0] = {
		false,
		"udivDNMg",
		"sdivDNMg",
		false,
		false,
		false,
		false,
		"lslDNMg",
		"lsrDNMg",
		"asrDNMg",
		"rorDNMg",
		shift = 10,
		mask = 63
	}
}
local var32_0 = {
	false,
	false,
	false,
	[0] = {
		shift = 21,
		mask = 7,
		[0] = {
			[0] = "madd|mulDNMA0g",
			"msub|mnegDNMA0g",
			shift = 15,
			mask = 1
		}
	},
	{
		[0] = {
			[0] = "madd|mulDNMA0g",
			"smaddl|smullDxNMwA0x",
			"smulhDNMx",
			false,
			false,
			"umaddl|umullDxNMwA0x",
			"umulhDNMx",
			shift = 21,
			mask = 7
		},
		{
			[0] = "msub|mnegDNMA0g",
			"smsubl|smneglDxNMwA0x",
			false,
			false,
			false,
			"umsubl|umneglDxNMwA0x",
			shift = 21,
			mask = 7
		},
		shift = 15,
		mask = 1
	},
	shift = 29,
	mask = 7
}
local var33_0 = {
	[0] = {
		[0] = var23_0,
		{
			[0] = var25_0,
			var26_0,
			shift = 21,
			mask = 1
		},
		shift = 24,
		mask = 1
	},
	{
		false,
		[0] = var27_0,
		var28_0,
		false,
		var29_0,
		false,
		{
			[0] = var31_0,
			var30_0,
			shift = 30,
			mask = 1
		},
		false,
		var32_0,
		var32_0,
		var32_0,
		var32_0,
		var32_0,
		var32_0,
		var32_0,
		var32_0,
		shift = 21,
		mask = 15
	},
	shift = 28,
	mask = 1
}
local var34_0 = {
	[0] = {
		[0] = "ldrDwB",
		"ldrDxB",
		"ldrswDxB",
		shift = 30,
		mask = 3
	},
	{
		[0] = "ldrDsB",
		"ldrDdB",
		shift = 30,
		mask = 3
	},
	shift = 26,
	mask = 1
}
local var35_0 = {
	[0] = {
		shift = 26,
		mask = 1,
		[0] = {
			[0] = "strbDwzL",
			"ldrbDwzL",
			"ldrsbDxzL",
			"ldrsbDwzL",
			shift = 22,
			mask = 3
		}
	},
	{
		shift = 26,
		mask = 1,
		[0] = {
			[0] = "strhDwzL",
			"ldrhDwzL",
			"ldrshDxzL",
			"ldrshDwzL",
			shift = 22,
			mask = 3
		}
	},
	{
		[0] = {
			[0] = "strDwzL",
			"ldrDwzL",
			"ldrswDxzL",
			shift = 22,
			mask = 3
		},
		{
			[0] = "strDszL",
			"ldrDszL",
			shift = 22,
			mask = 3
		},
		shift = 26,
		mask = 1
	},
	{
		[0] = {
			[0] = "strDxzL",
			"ldrDxzL",
			shift = 22,
			mask = 3
		},
		{
			[0] = "strDdzL",
			"ldrDdzL",
			shift = 22,
			mask = 3
		},
		shift = 26,
		mask = 1
	},
	shift = 30,
	mask = 3
}
local var36_0 = {
	[0] = {
		[0] = {
			shift = 26,
			mask = 1,
			[0] = {
				[0] = {
					[0] = "sturbDwK",
					"ldurbDwK",
					shift = 22,
					mask = 3
				},
				{
					[0] = "sturhDwK",
					"ldurhDwK",
					shift = 22,
					mask = 3
				},
				{
					[0] = "sturDwK",
					"ldurDwK",
					shift = 22,
					mask = 3
				},
				{
					[0] = "sturDxK",
					"ldurDxK",
					shift = 22,
					mask = 3
				},
				shift = 30,
				mask = 3
			}
		},
		var35_0,
		false,
		var35_0,
		shift = 10,
		mask = 3
	},
	{
		shift = 10,
		mask = 3,
		[2] = {
			[0] = {
				[0] = {
					[0] = "strbDwO",
					"ldrbDwO",
					"ldrsbDxO",
					"ldrsbDwO",
					shift = 22,
					mask = 3
				},
				{
					[0] = "strhDwO",
					"ldrhDwO",
					"ldrshDxO",
					"ldrshDwO",
					shift = 22,
					mask = 3
				},
				{
					[0] = "strDwO",
					"ldrDwO",
					"ldrswDxO",
					shift = 22,
					mask = 3
				},
				{
					[0] = "strDxO",
					"ldrDxO",
					shift = 22,
					mask = 3
				},
				shift = 30,
				mask = 3
			},
			{
				shift = 30,
				mask = 3,
				[2] = {
					[0] = "strDsO",
					"ldrDsO",
					shift = 22,
					mask = 3
				},
				[3] = {
					[0] = "strDdO",
					"ldrDdO",
					shift = 22,
					mask = 3
				}
			},
			shift = 26,
			mask = 1
		}
	},
	shift = 21,
	mask = 1
}
local var37_0 = {
	[0] = {
		[0] = {
			[0] = "stpDzAzwP",
			"stpDzAzsP",
			shift = 26,
			mask = 1
		},
		{
			"stpDzAzdP",
			shift = 26,
			mask = 1
		},
		{
			[0] = "stpDzAzxP",
			shift = 26,
			mask = 1
		},
		shift = 30,
		mask = 3
	},
	{
		[0] = {
			[0] = "ldpDzAzwP",
			"ldpDzAzsP",
			shift = 26,
			mask = 1
		},
		{
			[0] = "ldpswDAxP",
			"ldpDzAzdP",
			shift = 26,
			mask = 1
		},
		{
			[0] = "ldpDzAzxP",
			shift = 26,
			mask = 1
		},
		shift = 30,
		mask = 3
	},
	shift = 22,
	mask = 1
}
local var38_0 = {
	shift = 24,
	mask = 49,
	[16] = var34_0,
	[48] = var36_0,
	[32] = {
		var37_0,
		var37_0,
		var37_0,
		shift = 23,
		mask = 3
	},
	[33] = {
		var37_0,
		var37_0,
		var37_0,
		shift = 23,
		mask = 3
	},
	[49] = {
		[0] = {
			[0] = {
				[0] = "strbDwzU",
				"ldrbDwzU",
				shift = 22,
				mask = 3
			},
			{
				[0] = "strhDwzU",
				"ldrhDwzU",
				shift = 22,
				mask = 3
			},
			{
				[0] = "strDwzU",
				"ldrDwzU",
				shift = 22,
				mask = 3
			},
			{
				[0] = "strDxzU",
				"ldrDxzU",
				shift = 22,
				mask = 3
			},
			shift = 30,
			mask = 3
		},
		{
			shift = 30,
			mask = 3,
			[2] = {
				[0] = "strDszU",
				"ldrDszU",
				shift = 22,
				mask = 3
			},
			[3] = {
				[0] = "strDdzU",
				"ldrDdzU",
				shift = 22,
				mask = 3
			}
		},
		shift = 26,
		mask = 1
	}
}
local var39_0 = {
	{
		[0] = {
			{
				[0] = {
					[0] = {
						[0] = {
							[0] = {
								shift = 15,
								mask = 1,
								[0] = {
									[0] = {
										[57] = "fcvtzuDwNs",
										[121] = "fcvtzuDwNd",
										[104] = "fcvtpsDwNd",
										[112] = "fcvtmsDwNd",
										[96] = "fcvtnsDwNd",
										[97] = "fcvtnuDwNd",
										[113] = "fcvtmuDwNd",
										[33] = "fcvtnuDwNs",
										[39] = "fmovDsNw",
										[120] = "fcvtzsDwNd",
										[38] = "fmovDwNs",
										[40] = "fcvtpsDwNs",
										[56] = "fcvtzsDwNs",
										[49] = "fcvtmuDwNs",
										[32] = "fcvtnsDwNs",
										shift = 16,
										[36] = "fcvtasDwNs",
										[100] = "fcvtasDwNd",
										mask = 255,
										[48] = "fcvtmsDwNs",
										[101] = "fcvtauDwNd",
										[35] = "ucvtfDsNw",
										[37] = "fcvtauDwNs",
										[98] = "scvtfDdNw",
										[41] = "fcvtpuDwNs",
										[99] = "ucvtfDdNw",
										[105] = "fcvtpuDwNd",
										[34] = "scvtfDsNw"
									},
									{
										[96] = "fcvtnsDxNd",
										[121] = "fcvtzuDxNd",
										[104] = "fcvtpsDxNd",
										[112] = "fcvtmsDxNd",
										[113] = "fcvtmuDxNd",
										[97] = "fcvtnuDxNd",
										[120] = "fcvtzsDxNd",
										[33] = "fcvtnuDxNs",
										[57] = "fcvtzuDxNs",
										[102] = "fmovDxNd",
										[40] = "fcvtpsDxNs",
										[35] = "ucvtfDsNx",
										[49] = "fcvtmuDxNs",
										[103] = "fmovDdNx",
										[32] = "fcvtnsDxNs",
										shift = 16,
										[36] = "fcvtasDxNs",
										[100] = "fcvtasDxNd",
										mask = 255,
										[48] = "fcvtmsDxNs",
										[101] = "fcvtauDxNd",
										[56] = "fcvtzsDxNs",
										[37] = "fcvtauDxNs",
										[98] = "scvtfDdNx",
										[41] = "fcvtpuDxNs",
										[99] = "ucvtfDdNx",
										[105] = "fcvtpuDxNd",
										[34] = "scvtfDsNx"
									},
									shift = 31,
									mask = 1
								}
							},
							{
								shift = 31,
								mask = 1,
								[0] = {
									[0] = {
										[0] = "fmovDNf",
										"fabsDNf",
										"fnegDNf",
										"fsqrtDNf",
										false,
										"fcvtDdNs",
										false,
										false,
										"frintnDNf",
										"frintpDNf",
										"frintmDNf",
										"frintzDNf",
										"frintaDNf",
										false,
										"frintxDNf",
										"frintiDNf",
										shift = 15,
										mask = 63
									},
									{
										[0] = "fmovDNf",
										"fabsDNf",
										"fnegDNf",
										"fsqrtDNf",
										"fcvtDsNd",
										false,
										false,
										false,
										"frintnDNf",
										"frintpDNf",
										"frintmDNf",
										"frintzDNf",
										"frintaDNf",
										false,
										"frintxDNf",
										"frintiDNf",
										shift = 15,
										mask = 63
									},
									shift = 22,
									mask = 3
								}
							},
							shift = 14,
							mask = 1
						},
						{
							shift = 31,
							mask = 1,
							[0] = {
								shift = 14,
								mask = 3,
								[0] = {
									shift = 23,
									mask = 1,
									[0] = {
										[0] = "fcmpNMf",
										[24] = "fcmpeNZf",
										shift = 0,
										[16] = "fcmpeNMf",
										mask = 31,
										[8] = "fcmpNZf"
									}
								}
							}
						},
						shift = 13,
						mask = 1
					},
					{
						shift = 31,
						mask = 1,
						[0] = {
							shift = 5,
							mask = 31,
							[0] = {
								[0] = "fmovDFf",
								shift = 23,
								mask = 1
							}
						}
					},
					shift = 12,
					mask = 1
				},
				{
					shift = 31,
					mask = 1,
					[0] = {
						shift = 23,
						mask = 1,
						[0] = {
							[0] = "fccmpNMVCf",
							"fccmpeNMVCf",
							shift = 4,
							mask = 1
						}
					}
				},
				{
					shift = 31,
					mask = 1,
					[0] = {
						shift = 23,
						mask = 1,
						[0] = {
							[0] = "fmulDNMf",
							"fdivDNMf",
							"faddDNMf",
							"fsubDNMf",
							"fmaxDNMf",
							"fminDNMf",
							"fmaxnmDNMf",
							"fminnmDNMf",
							"fnmulDNMf",
							shift = 12,
							mask = 15
						}
					}
				},
				{
					shift = 31,
					mask = 1,
					[0] = {
						[0] = "fcselDNMCf",
						shift = 23,
						mask = 1
					}
				},
				shift = 10,
				mask = 3
			},
			shift = 21,
			mask = 1
		},
		{
			shift = 31,
			mask = 1,
			[0] = {
				[0] = {
					[0] = "fmaddDNMAf",
					"fnmaddDNMAf",
					shift = 21,
					mask = 5
				},
				{
					[0] = "fmsubDNMAf",
					"fnmsubDNMAf",
					shift = 21,
					mask = 5
				},
				shift = 15,
				mask = 1
			}
		},
		shift = 24,
		mask = 1
	},
	shift = 28,
	mask = 7
}
local var40_0 = {
	[0] = "bB",
	{
		[0] = "cbzDBg",
		"cbnzDBg",
		"tbzDTBw",
		"tbnzDTBw",
		shift = 24,
		mask = 3
	},
	{
		shift = 24,
		mask = 3,
		[0] = {
			shift = 4,
			mask = 1,
			[0] = {
				[0] = "beqB",
				"bneB",
				"bhsB",
				"bloB",
				"bmiB",
				"bplB",
				"bvsB",
				"bvcB",
				"bhiB",
				"blsB",
				"bgeB",
				"bltB",
				"bgtB",
				"bleB",
				"balB",
				shift = 0,
				mask = 15
			}
		}
	},
	false,
	"blB",
	{
		[0] = "cbzDBg",
		"cbnzDBg",
		"tbzDTBx",
		"tbnzDTBx",
		shift = 24,
		mask = 3
	},
	{
		[0] = {
			shift = 0,
			[2097152] = "brkW",
			mask = 14680095
		},
		{
			[204831] = "nop",
			shift = 0,
			mask = 4194303
		},
		{
			mask = 16776223,
			[4128768] = "blrNx",
			[6225920] = "retNx",
			[2031616] = "brNx",
			shift = 0
		},
		shift = 24,
		mask = 3
	},
	shift = 29,
	mask = 7
}
local var41_0 = {
	[0] = false,
	false,
	false,
	false,
	var38_0,
	var33_0,
	var38_0,
	var39_0,
	var22_0,
	var22_0,
	var40_0,
	var40_0,
	var38_0,
	var33_0,
	var38_0,
	var39_0,
	shift = 25,
	mask = 15
}
local var42_0 = {
	x = {},
	w = {},
	d = {},
	s = {}
}

for iter0_0 = 0, 30 do
	var42_0.x[iter0_0] = "x" .. iter0_0
	var42_0.w[iter0_0] = "w" .. iter0_0
	var42_0.d[iter0_0] = "d" .. iter0_0
	var42_0.s[iter0_0] = "s" .. iter0_0
end

var42_0.x[31] = "sp"
var42_0.w[31] = "wsp"
var42_0.d[31] = "d31"
var42_0.s[31] = "s31"

local var43_0 = {
	[0] = "eq",
	"ne",
	"cs",
	"cc",
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
local var44_0 = {
	[0] = "lsl",
	"lsr",
	"asr"
}
local var45_0 = {
	[0] = "uxtb",
	"uxth",
	"uxtw",
	"uxtx",
	"sxtb",
	"sxth",
	"sxtw",
	"sxtx"
}

local function var46_0(arg0_1, arg1_1, arg2_1)
	local var0_1 = arg0_1.pos
	local var1_1 = ""

	if arg0_1.rel then
		local var2_1 = arg0_1.symtab[arg0_1.rel]

		if var2_1 then
			var1_1 = "\t->" .. var2_1
		end
	end

	if arg0_1.hexdump > 0 then
		arg0_1.out(var3_0("%08x  %s  %-5s %s%s\n", arg0_1.addr + var0_1, var12_0(arg0_1.op), arg1_1, var7_0(arg2_1, ", "), var1_1))
	else
		arg0_1.out(var3_0("%08x  %-5s %s%s\n", arg0_1.addr + var0_1, arg1_1, var7_0(arg2_1, ", "), var1_1))
	end

	arg0_1.pos = var0_1 + 4
end

local function var47_0(arg0_2)
	return var46_0(arg0_2, ".long", {
		"0x" .. var12_0(arg0_2.op)
	})
end

local function var48_0(arg0_3, arg1_3, arg2_3)
	return var42_0[var4_0(arg1_3, arg0_3 .. "%w-([xwds])")][arg2_3]
end

local function var49_0(arg0_4)
	if arg0_4 < 0 then
		return var12_0(arg0_4)
	else
		return var3_0("%x", arg0_4)
	end
end

local var50_0 = {
	1431655765,
	286331153,
	16843009,
	65537,
	1
}

local function var51_0(arg0_5)
	local var0_5 = var9_0(var14_0(arg0_5, 10), 63)
	local var1_5 = var9_0(var14_0(arg0_5, 16), 63)

	if var9_0(arg0_5, 4194304) == 0 then
		local var2_5 = 5

		if var0_5 >= 56 then
			if var0_5 >= 60 then
				var2_5 = 1
			else
				var2_5 = 2
			end
		elseif var0_5 >= 48 then
			var2_5 = 3
		elseif var0_5 >= 32 then
			var2_5 = 4
		end

		local var3_5 = var13_0(1, var2_5) - 1
		local var4_5 = var9_0(var0_5, var3_5)
		local var5_5 = var9_0(var1_5, var3_5)
		local var6_5 = var16_0(var14_0(-1, 31 - var4_5), var5_5)

		if var2_5 ~= 5 then
			var6_5 = var9_0(var6_5, var13_0(1, var3_5) - 1) + var14_0(var6_5, 31 - var3_5)
		end

		local var7_5 = var6_5 * var50_0[var2_5]
		local var8_5 = var49_0(var7_5)

		if var14_0(arg0_5, 31) ~= 0 then
			return var8_5 .. var12_0(var7_5)
		else
			return var8_5
		end
	else
		local var9_5 = -1
		local var10_5 = 0

		if var0_5 < 32 then
			var9_5 = var14_0(-1, 31 - var0_5)
		else
			var10_5 = var14_0(-1, 63 - var0_5)
		end

		if var1_5 ~= 0 then
			var9_5, var10_5 = var16_0(var9_5, var1_5), var16_0(var10_5, var1_5)

			local var11_5 = var1_5 == 32 and 0 or var9_0(var11_0(var9_5, var10_5), var13_0(-1, 32 - var1_5))

			var9_5, var10_5 = var11_0(var9_5, var11_5), var11_0(var10_5, var11_5)

			if var1_5 >= 32 then
				var9_5, var10_5 = var10_5, var9_5
			end
		end

		if var10_5 ~= 0 then
			return var49_0(var10_5) .. var12_0(var9_5)
		else
			return var49_0(var9_5)
		end
	end
end

local function var52_0(arg0_6, arg1_6)
	if arg1_6 == "b" or arg1_6 == "bl" then
		return var15_0(var13_0(arg0_6, 6), 4)
	elseif arg1_6 == "adr" or arg1_6 == "adrp" then
		local var0_6 = var9_0(var14_0(arg0_6, 29), 3)
		local var1_6 = var13_0(var15_0(var13_0(arg0_6, 8), 13), 2)

		return var10_0(var1_6, var0_6)
	elseif arg1_6 == "tbz" or arg1_6 == "tbnz" then
		return var13_0(var15_0(var13_0(arg0_6, 13), 18), 2)
	else
		return var13_0(var15_0(var13_0(arg0_6, 8), 13), 2)
	end
end

local function var53_0(arg0_7)
	local var0_7 = var9_0(arg0_7, 1048576) == 0 and 1 or -1
	local var1_7 = var11_0(var14_0(var15_0(var13_0(arg0_7, 12), 5), 24), 128) - 131

	return var0_7 * (16 + var9_0(var14_0(arg0_7, 13), 15)) * 2^var1_7
end

local function var54_0(arg0_8, arg1_8, arg2_8, arg3_8)
	if arg2_8 < arg3_8 or arg2_8 == 31 or arg2_8 == 63 then
		return false
	end

	if arg3_8 == 0 then
		if arg0_8 == 0 and (arg2_8 == 7 or arg2_8 == 15) then
			return false
		end

		if arg0_8 ~= 0 and arg1_8 == 0 and (arg2_8 == 7 or arg2_8 == 15 or arg2_8 == 31) then
			return false
		end
	end

	return true
end

local function var55_0(arg0_9)
	local var0_9 = arg0_9.pos
	local var1_9, var2_9, var3_9, var4_9 = var2_0(arg0_9.code, var0_9 + 1, var0_9 + 4)
	local var5_9 = var10_0(var13_0(var4_9, 24), var13_0(var3_9, 16), var13_0(var2_9, 8), var1_9)
	local var6_9 = {}
	local var7_9 = ""
	local var8_9
	local var9_9
	local var10_9
	local var11_9

	arg0_9.op = var5_9
	arg0_9.rel = nil

	local var12_9
	local var13_9
	local var14_9 = var41_0[var9_0(var14_0(var5_9, 25), 15)]

	while var0_0(var14_9) ~= "string" do
		if not var14_9 then
			return var47_0(arg0_9)
		end

		var14_9 = var14_9[var9_0(var14_0(var5_9, var14_9.shift), var14_9.mask)] or var14_9._
	end

	local var15_9, var16_9 = var4_0(var14_9, "^([a-z0-9]*)(.*)")
	local var17_9, var18_9 = var4_0(var16_9, "|([a-z0-9_.|]*)(.*)")

	if var17_9 then
		var16_9 = var18_9
	end

	if var1_0(var16_9, 1, 1) == "." then
		local var19_9, var20_9 = var4_0(var16_9, "^([a-z0-9.]*)(.*)")

		var7_9 = var7_9 .. var19_9
		var16_9 = var20_9
	end

	local var21_9 = var4_0(var16_9, "[gf]")

	if var21_9 then
		if var21_9 == "g" then
			var11_9 = var9_0(var5_9, 2147483648) ~= 0 and var42_0.x or var42_0.w
		else
			var11_9 = var9_0(var5_9, 4194304) ~= 0 and var42_0.d or var42_0.s
		end
	end

	local var22_9
	local var23_9

	for iter0_9 in var5_0(var16_9, ".") do
		local var24_9

		if iter0_9 == "D" then
			local var25_9 = var9_0(var5_9, 31)

			var24_9 = var21_9 and var11_9[var25_9] or var48_0(iter0_9, var16_9, var25_9)
		elseif iter0_9 == "N" then
			local var26_9 = var9_0(var14_0(var5_9, 5), 31)

			var24_9 = var21_9 and var11_9[var26_9] or var48_0(iter0_9, var16_9, var26_9)
		elseif iter0_9 == "M" then
			local var27_9 = var9_0(var14_0(var5_9, 16), 31)

			var24_9 = var21_9 and var11_9[var27_9] or var48_0(iter0_9, var16_9, var27_9)
		elseif iter0_9 == "A" then
			local var28_9 = var9_0(var14_0(var5_9, 10), 31)

			var24_9 = var21_9 and var11_9[var28_9] or var48_0(iter0_9, var16_9, var28_9)
		elseif iter0_9 == "B" then
			local var29_9 = arg0_9.addr + var0_9 + var52_0(var5_9, var15_9)

			arg0_9.rel = var29_9
			var24_9 = "0x" .. var12_0(var29_9)
		elseif iter0_9 == "T" then
			var24_9 = var10_0(var9_0(var14_0(var5_9, 26), 32), var9_0(var14_0(var5_9, 19), 31))
		elseif iter0_9 == "V" then
			var24_9 = var9_0(var5_9, 15)
		elseif iter0_9 == "C" then
			var24_9 = var43_0[var9_0(var14_0(var5_9, 12), 15)]
		elseif iter0_9 == "c" then
			local var30_9 = var9_0(var14_0(var5_9, 5), 31)
			local var31_9 = var9_0(var14_0(var5_9, 16), 31)
			local var32_9 = var9_0(var14_0(var5_9, 12), 15)
			local var33_9 = var11_0(var32_9, 1)

			var24_9 = var43_0[var32_9]

			if var17_9 and var32_9 ~= 14 and var32_9 ~= 15 then
				local var34_9, var35_9 = var4_0(var17_9, "([^|]*)|(.*)")

				if var30_9 == var31_9 then
					local var36_9 = #var6_9

					var6_9[var36_9] = nil
					var24_9 = var43_0[var33_9]

					if var30_9 ~= 31 then
						if var34_9 then
							var15_9 = var34_9
						else
							var15_9 = var17_9
						end
					else
						var6_9[var36_9 - 1] = nil
						var15_9 = var35_9
					end
				end
			end
		elseif iter0_9 == "W" then
			var24_9 = var9_0(var14_0(var5_9, 5), 65535)
		elseif iter0_9 == "Y" then
			var24_9 = var9_0(var14_0(var5_9, 5), 65535)

			local var37_9 = var9_0(var14_0(var5_9, 21), 3)

			if var17_9 and (var37_9 == 0 or var24_9 ~= 0) then
				var15_9 = var17_9
			end
		elseif iter0_9 == "L" then
			local var38_9 = var42_0.x[var9_0(var14_0(var5_9, 5), 31)]
			local var39_9 = var15_0(var13_0(var5_9, 11), 23)

			if var9_0(var5_9, 2048) ~= 0 then
				var24_9 = "[" .. var38_9 .. ", #" .. var39_9 .. "]!"
			else
				var24_9 = "[" .. var38_9 .. "], #" .. var39_9
			end
		elseif iter0_9 == "U" then
			local var40_9 = var42_0.x[var9_0(var14_0(var5_9, 5), 31)]
			local var41_9 = var9_0(var14_0(var5_9, 30), 3)
			local var42_9 = var13_0(var15_0(var13_0(var5_9, 10), 20), var41_9)

			if var42_9 ~= 0 then
				var24_9 = "[" .. var40_9 .. ", #" .. var42_9 .. "]"
			else
				var24_9 = "[" .. var40_9 .. "]"
			end
		elseif iter0_9 == "K" then
			local var43_9 = var42_0.x[var9_0(var14_0(var5_9, 5), 31)]
			local var44_9 = var15_0(var13_0(var5_9, 11), 23)

			if var44_9 ~= 0 then
				var24_9 = "[" .. var43_9 .. ", #" .. var44_9 .. "]"
			else
				var24_9 = "[" .. var43_9 .. "]"
			end
		elseif iter0_9 == "O" then
			local var45_9 = var42_0.x[var9_0(var14_0(var5_9, 5), 31)]
			local var46_9

			if var9_0(var14_0(var5_9, 13), 1) == 0 then
				var46_9 = var42_0.w[var9_0(var14_0(var5_9, 16), 31)]
			else
				var46_9 = var42_0.x[var9_0(var14_0(var5_9, 16), 31)]
			end

			var24_9 = "[" .. var45_9 .. ", " .. var46_9

			local var47_9 = var9_0(var14_0(var5_9, 13), 7)
			local var48_9 = var9_0(var14_0(var5_9, 12), 1)
			local var49_9 = var9_0(var14_0(var5_9, 30), 3)

			if var47_9 == 3 then
				if var48_9 == 0 then
					var24_9 = var24_9 .. "]"
				else
					var24_9 = var24_9 .. ", lsl #" .. var49_9 .. "]"
				end
			elseif var47_9 == 2 or var47_9 == 6 or var47_9 == 7 then
				if var48_9 == 0 then
					var24_9 = var24_9 .. ", " .. var45_0[var47_9] .. "]"
				else
					var24_9 = var24_9 .. ", " .. var45_0[var47_9] .. " #" .. var49_9 .. "]"
				end
			else
				var24_9 = var24_9 .. "]"
			end
		elseif iter0_9 == "P" then
			local var50_9 = var14_0(var5_9, 26)
			local var51_9 = 2

			if var50_9 >= 42 then
				var51_9 = 4
			elseif var50_9 >= 27 then
				var51_9 = 3
			end

			local var52_9 = var13_0(var15_0(var13_0(var5_9, 10), 25), var51_9)
			local var53_9 = var42_0.x[var9_0(var14_0(var5_9, 5), 31)]
			local var54_9 = var9_0(var14_0(var5_9, 23), 3)

			if var54_9 == 1 then
				var24_9 = "[" .. var53_9 .. "], #" .. var52_9
			elseif var54_9 == 2 then
				if var52_9 == 0 then
					var24_9 = "[" .. var53_9 .. "]"
				else
					var24_9 = "[" .. var53_9 .. ", #" .. var52_9 .. "]"
				end
			elseif var54_9 == 3 then
				var24_9 = "[" .. var53_9 .. ", #" .. var52_9 .. "]!"
			end
		elseif iter0_9 == "I" then
			local var55_9 = var9_0(var14_0(var5_9, 22), 3)
			local var56_9 = var9_0(var14_0(var5_9, 10), 4095)
			local var57_9 = var9_0(var14_0(var5_9, 5), 31)
			local var58_9 = var9_0(var5_9, 31)

			if var17_9 == "mov" and var55_9 == 0 and var56_9 == 0 and (var57_9 == 31 or var58_9 == 31) then
				var15_9 = var17_9
				var24_9 = nil
			elseif var55_9 == 0 then
				var24_9 = var56_9
			elseif var55_9 == 1 then
				var24_9 = var56_9 .. ", lsl #12"
			end
		elseif iter0_9 == "i" then
			var24_9 = "#0x" .. var51_0(var5_9)
		elseif iter0_9 == "1" then
			var23_9 = var9_0(var14_0(var5_9, 16), 63)
			var24_9 = var23_9
		elseif iter0_9 == "2" then
			var24_9 = var9_0(var14_0(var5_9, 10), 63)

			if var17_9 then
				local var59_9, var60_9, var61_9, var62_9, var63_9, var64_9 = var4_0(var17_9, "([^|]*)|([^|]*)|([^|]*)|([^|]*)|([^|]*)|(.*)")
				local var65_9 = var9_0(var14_0(var5_9, 26), 32)
				local var66_9 = var9_0(var14_0(var5_9, 30), 1)

				if var54_0(var65_9, var66_9, var24_9, var23_9) then
					var15_9 = var60_9
					var24_9 = var24_9 - var23_9 + 1
				elseif var23_9 == 0 and var24_9 == 7 then
					local var67_9 = #var6_9

					var6_9[var67_9] = nil

					if var65_9 ~= 0 then
						var6_9[var67_9 - 1] = var6_0(var6_9[var67_9 - 1], "x", "w")
					end

					var12_9 = var6_9[var67_9 - 1]
					var15_9 = var64_9
					var24_9 = nil
				elseif var23_9 == 0 and var24_9 == 15 then
					local var68_9 = #var6_9

					var6_9[var68_9] = nil

					if var65_9 ~= 0 then
						var6_9[var68_9 - 1] = var6_0(var6_9[var68_9 - 1], "x", "w")
					end

					var12_9 = var6_9[var68_9 - 1]
					var15_9 = var63_9
					var24_9 = nil
				elseif var24_9 == 31 or var24_9 == 63 then
					if var24_9 == 31 and var23_9 == 0 and var15_9 == "sbfm" then
						var15_9 = var62_9

						local var69_9 = #var6_9

						var6_9[var69_9] = nil

						if var65_9 ~= 0 then
							var6_9[var69_9 - 1] = var6_0(var6_9[var69_9 - 1], "x", "w")
						end

						var12_9 = var6_9[var69_9 - 1]
					else
						var15_9 = var61_9
					end

					var24_9 = nil
				elseif var9_0(var24_9, 31) ~= 31 and var23_9 == var24_9 + 1 and var15_9 == "ubfm" then
					var15_9 = var62_9
					var12_9 = "#" .. var65_9 + 32 - var23_9
					var6_9[#var6_9] = var12_9
					var24_9 = nil
				elseif var24_9 < var23_9 then
					var15_9 = var59_9
					var12_9 = "#" .. var65_9 + 32 - var23_9
					var6_9[#var6_9] = var12_9
					var24_9 = var24_9 + 1
				end
			end
		elseif iter0_9 == "3" then
			var24_9 = var9_0(var14_0(var5_9, 10), 63)

			if var17_9 then
				local var70_9, var71_9 = var4_0(var17_9, "([^|]*)|(.*)")

				if var24_9 < var23_9 then
					var15_9 = var70_9

					local var72_9 = var9_0(var14_0(var5_9, 26), 32)

					var12_9 = "#" .. var72_9 + 32 - var23_9
					var6_9[#var6_9] = var12_9
					var24_9 = var24_9 + 1
				elseif var23_9 <= var24_9 then
					var15_9 = var71_9
					var24_9 = var24_9 - var23_9 + 1
				end
			end
		elseif iter0_9 == "4" then
			var24_9 = var9_0(var14_0(var5_9, 10), 63)

			local var73_9 = var9_0(var14_0(var5_9, 5), 31)
			local var74_9 = var9_0(var14_0(var5_9, 16), 31)

			if var17_9 and var73_9 == var74_9 then
				local var75_9 = #var6_9

				var6_9[var75_9] = nil
				var12_9 = var6_9[var75_9 - 1]
				var15_9 = var17_9
			end
		elseif iter0_9 == "5" then
			var24_9 = var9_0(var14_0(var5_9, 16), 31)
		elseif iter0_9 == "S" then
			var24_9 = var9_0(var14_0(var5_9, 10), 63)

			if var24_9 == 0 then
				var24_9 = nil
			else
				var24_9 = var44_0[var9_0(var14_0(var5_9, 22), 3)] .. " #" .. var24_9
			end
		elseif iter0_9 == "X" then
			local var76_9 = var9_0(var14_0(var5_9, 13), 7)

			if var76_9 ~= 3 and var76_9 ~= 7 then
				var12_9 = var42_0.w[var9_0(var14_0(var5_9, 16), 31)]
				var6_9[#var6_9] = var12_9
			end

			var24_9 = var9_0(var14_0(var5_9, 10), 7)

			if var76_9 == 2 + var9_0(var14_0(var5_9, 31), 1) and var9_0(var14_0(var5_9, var22_9 and 5 or 0), 31) == 31 then
				if var24_9 == 0 then
					var24_9 = nil
				else
					var24_9 = "lsl #" .. var24_9
				end
			elseif var24_9 == 0 then
				var24_9 = var45_0[var9_0(var14_0(var5_9, 13), 7)]
			else
				var24_9 = var45_0[var9_0(var14_0(var5_9, 13), 7)] .. " #" .. var24_9
			end
		elseif iter0_9 == "R" then
			var24_9 = var9_0(var14_0(var5_9, 21), 3)

			if var24_9 == 0 then
				var24_9 = nil
			else
				var24_9 = "lsl #" .. var24_9 * 16
			end
		elseif iter0_9 == "z" then
			local var77_9 = #var6_9

			if var6_9[var77_9] == "sp" then
				var6_9[var77_9] = "xzr"
			elseif var6_9[var77_9] == "wsp" then
				var6_9[var77_9] = "wzr"
			end
		elseif iter0_9 == "Z" then
			var24_9 = 0
		elseif iter0_9 == "F" then
			var24_9 = var53_0(var5_9)
		elseif iter0_9 == "g" or iter0_9 == "f" or iter0_9 == "x" or iter0_9 == "w" or iter0_9 == "d" or iter0_9 == "s" then
			-- block empty
		elseif iter0_9 == "0" then
			if var12_9 == "sp" or var12_9 == "wsp" then
				local var78_9 = #var6_9

				var6_9[var78_9] = nil
				var12_9 = var6_9[var78_9 - 1]

				if var17_9 then
					local var79_9, var80_9 = var4_0(var17_9, "([^|]*)|(.*)")

					if not var79_9 then
						var15_9 = var17_9
					elseif var22_9 then
						var15_9, var17_9 = var80_9, var79_9
					else
						var15_9, var17_9 = var79_9, var80_9
					end
				end
			end

			var22_9 = true
		else
			assert(false)
		end

		if var24_9 then
			var12_9 = var24_9

			if var0_0(var24_9) == "number" then
				var24_9 = "#" .. var24_9
			end

			var6_9[#var6_9 + 1] = var24_9
		end
	end

	return var46_0(arg0_9, var15_9 .. var7_9, var6_9)
end

local function var56_0(arg0_10, arg1_10, arg2_10)
	arg1_10 = arg1_10 or 0

	local var0_10 = arg2_10 and arg1_10 + arg2_10 or #arg0_10.code

	arg0_10.pos = arg1_10
	arg0_10.rel = nil

	while var0_10 > arg0_10.pos do
		var55_0(arg0_10)
	end
end

local function var57_0(arg0_11, arg1_11, arg2_11)
	local var0_11 = {
		code = arg0_11,
		addr = arg1_11 or 0,
		out = arg2_11 or io.write,
		symtab = {},
		disass = var56_0
	}

	var0_11.hexdump = 8

	return var0_11
end

local function var58_0(arg0_12, arg1_12, arg2_12)
	var57_0(arg0_12, arg1_12, arg2_12):disass()
end

local function var59_0(arg0_13)
	if arg0_13 < 32 then
		return var42_0.x[arg0_13]
	end

	return var42_0.d[arg0_13 - 32]
end

return {
	create = var57_0,
	disass = var58_0,
	regname = var59_0
}
