local var0 = type
local var1 = string.sub
local var2 = string.byte
local var3 = string.format
local var4 = string.match
local var5 = string.gmatch
local var6 = string.gsub
local var7 = table.concat
local var8 = require("bit")
local var9 = var8.band
local var10 = var8.bor
local var11 = var8.bxor
local var12 = var8.tohex
local var13 = var8.lshift
local var14 = var8.rshift
local var15 = var8.arshift
local var16 = var8.ror
local var17 = {
	[0] = "adrDBx",
	"adrpDBx",
	shift = 31,
	mask = 1
}
local var18 = {
	[0] = "add|movDNIg",
	"adds|cmnD0NIg",
	"subDNIg",
	"subs|cmpD0NIg",
	shift = 29,
	mask = 3
}
local var19 = {
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
local var20 = {
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
local var21 = {
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
local var22 = {
	[0] = var17,
	var17,
	var18,
	false,
	var19,
	var20,
	var21,
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
local var23 = {
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
local var24 = {
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
local var25 = {
	[0] = var24,
	var24,
	var24,
	shift = 22,
	mask = 3
}
local var26 = {
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
local var27 = {
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
local var28 = {
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
local var29 = {
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
local var30 = {
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
local var31 = {
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
local var32 = {
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
local var33 = {
	[0] = {
		[0] = var23,
		{
			[0] = var25,
			var26,
			shift = 21,
			mask = 1
		},
		shift = 24,
		mask = 1
	},
	{
		false,
		[0] = var27,
		var28,
		false,
		var29,
		false,
		{
			[0] = var31,
			var30,
			shift = 30,
			mask = 1
		},
		false,
		var32,
		var32,
		var32,
		var32,
		var32,
		var32,
		var32,
		var32,
		shift = 21,
		mask = 15
	},
	shift = 28,
	mask = 1
}
local var34 = {
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
local var35 = {
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
local var36 = {
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
		var35,
		false,
		var35,
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
local var37 = {
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
local var38 = {
	shift = 24,
	mask = 49,
	[16] = var34,
	[48] = var36,
	[32] = {
		var37,
		var37,
		var37,
		shift = 23,
		mask = 3
	},
	[33] = {
		var37,
		var37,
		var37,
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
local var39 = {
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
local var40 = {
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
local var41 = {
	[0] = false,
	false,
	false,
	false,
	var38,
	var33,
	var38,
	var39,
	var22,
	var22,
	var40,
	var40,
	var38,
	var33,
	var38,
	var39,
	shift = 25,
	mask = 15
}
local var42 = {
	x = {},
	w = {},
	d = {},
	s = {}
}

for iter0 = 0, 30 do
	var42.x[iter0] = "x" .. iter0
	var42.w[iter0] = "w" .. iter0
	var42.d[iter0] = "d" .. iter0
	var42.s[iter0] = "s" .. iter0
end

var42.x[31] = "sp"
var42.w[31] = "wsp"
var42.d[31] = "d31"
var42.s[31] = "s31"

local var43 = {
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
local var44 = {
	[0] = "lsl",
	"lsr",
	"asr"
}
local var45 = {
	[0] = "uxtb",
	"uxth",
	"uxtw",
	"uxtx",
	"sxtb",
	"sxth",
	"sxtw",
	"sxtx"
}

local function var46(arg0, arg1, arg2)
	local var0 = arg0.pos
	local var1 = ""

	if arg0.rel then
		local var2 = arg0.symtab[arg0.rel]

		if var2 then
			var1 = "\t->" .. var2
		end
	end

	if arg0.hexdump > 0 then
		arg0.out(var3("%08x  %s  %-5s %s%s\n", arg0.addr + var0, var12(arg0.op), arg1, var7(arg2, ", "), var1))
	else
		arg0.out(var3("%08x  %-5s %s%s\n", arg0.addr + var0, arg1, var7(arg2, ", "), var1))
	end

	arg0.pos = var0 + 4
end

local function var47(arg0)
	return var46(arg0, ".long", {
		"0x" .. var12(arg0.op)
	})
end

local function var48(arg0, arg1, arg2)
	return var42[var4(arg1, arg0 .. "%w-([xwds])")][arg2]
end

local function var49(arg0)
	if arg0 < 0 then
		return var12(arg0)
	else
		return var3("%x", arg0)
	end
end

local var50 = {
	1431655765,
	286331153,
	16843009,
	65537,
	1
}

local function var51(arg0)
	local var0 = var9(var14(arg0, 10), 63)
	local var1 = var9(var14(arg0, 16), 63)

	if var9(arg0, 4194304) == 0 then
		local var2 = 5

		if var0 >= 56 then
			if var0 >= 60 then
				var2 = 1
			else
				var2 = 2
			end
		elseif var0 >= 48 then
			var2 = 3
		elseif var0 >= 32 then
			var2 = 4
		end

		local var3 = var13(1, var2) - 1
		local var4 = var9(var0, var3)
		local var5 = var9(var1, var3)
		local var6 = var16(var14(-1, 31 - var4), var5)

		if var2 ~= 5 then
			var6 = var9(var6, var13(1, var3) - 1) + var14(var6, 31 - var3)
		end

		local var7 = var6 * var50[var2]
		local var8 = var49(var7)

		if var14(arg0, 31) ~= 0 then
			return var8 .. var12(var7)
		else
			return var8
		end
	else
		local var9 = -1
		local var10 = 0

		if var0 < 32 then
			var9 = var14(-1, 31 - var0)
		else
			var10 = var14(-1, 63 - var0)
		end

		if var1 ~= 0 then
			var9, var10 = var16(var9, var1), var16(var10, var1)

			local var11 = var1 == 32 and 0 or var9(var11(var9, var10), var13(-1, 32 - var1))

			var9, var10 = var11(var9, var11), var11(var10, var11)

			if var1 >= 32 then
				var9, var10 = var10, var9
			end
		end

		if var10 ~= 0 then
			return var49(var10) .. var12(var9)
		else
			return var49(var9)
		end
	end
end

local function var52(arg0, arg1)
	if arg1 == "b" or arg1 == "bl" then
		return var15(var13(arg0, 6), 4)
	elseif arg1 == "adr" or arg1 == "adrp" then
		local var0 = var9(var14(arg0, 29), 3)
		local var1 = var13(var15(var13(arg0, 8), 13), 2)

		return var10(var1, var0)
	elseif arg1 == "tbz" or arg1 == "tbnz" then
		return var13(var15(var13(arg0, 13), 18), 2)
	else
		return var13(var15(var13(arg0, 8), 13), 2)
	end
end

local function var53(arg0)
	local var0 = var9(arg0, 1048576) == 0 and 1 or -1
	local var1 = var11(var14(var15(var13(arg0, 12), 5), 24), 128) - 131

	return var0 * (16 + var9(var14(arg0, 13), 15)) * 2^var1
end

local function var54(arg0, arg1, arg2, arg3)
	if arg2 < arg3 or arg2 == 31 or arg2 == 63 then
		return false
	end

	if arg3 == 0 then
		if arg0 == 0 and (arg2 == 7 or arg2 == 15) then
			return false
		end

		if arg0 ~= 0 and arg1 == 0 and (arg2 == 7 or arg2 == 15 or arg2 == 31) then
			return false
		end
	end

	return true
end

local function var55(arg0)
	local var0 = arg0.pos
	local var1, var2, var3, var4 = var2(arg0.code, var0 + 1, var0 + 4)
	local var5 = var10(var13(var4, 24), var13(var3, 16), var13(var2, 8), var1)
	local var6 = {}
	local var7 = ""
	local var8
	local var9
	local var10
	local var11

	arg0.op = var5
	arg0.rel = nil

	local var12
	local var13
	local var14 = var41[var9(var14(var5, 25), 15)]

	while var0(var14) ~= "string" do
		if not var14 then
			return var47(arg0)
		end

		var14 = var14[var9(var14(var5, var14.shift), var14.mask)] or var14._
	end

	local var15, var16 = var4(var14, "^([a-z0-9]*)(.*)")
	local var17, var18 = var4(var16, "|([a-z0-9_.|]*)(.*)")

	if var17 then
		var16 = var18
	end

	if var1(var16, 1, 1) == "." then
		local var19, var20 = var4(var16, "^([a-z0-9.]*)(.*)")

		var7 = var7 .. var19
		var16 = var20
	end

	local var21 = var4(var16, "[gf]")

	if var21 then
		if var21 == "g" then
			var11 = var9(var5, 2147483648) ~= 0 and var42.x or var42.w
		else
			var11 = var9(var5, 4194304) ~= 0 and var42.d or var42.s
		end
	end

	local var22
	local var23

	for iter0 in var5(var16, ".") do
		local var24

		if iter0 == "D" then
			local var25 = var9(var5, 31)

			var24 = var21 and var11[var25] or var48(iter0, var16, var25)
		elseif iter0 == "N" then
			local var26 = var9(var14(var5, 5), 31)

			var24 = var21 and var11[var26] or var48(iter0, var16, var26)
		elseif iter0 == "M" then
			local var27 = var9(var14(var5, 16), 31)

			var24 = var21 and var11[var27] or var48(iter0, var16, var27)
		elseif iter0 == "A" then
			local var28 = var9(var14(var5, 10), 31)

			var24 = var21 and var11[var28] or var48(iter0, var16, var28)
		elseif iter0 == "B" then
			local var29 = arg0.addr + var0 + var52(var5, var15)

			arg0.rel = var29
			var24 = "0x" .. var12(var29)
		elseif iter0 == "T" then
			var24 = var10(var9(var14(var5, 26), 32), var9(var14(var5, 19), 31))
		elseif iter0 == "V" then
			var24 = var9(var5, 15)
		elseif iter0 == "C" then
			var24 = var43[var9(var14(var5, 12), 15)]
		elseif iter0 == "c" then
			local var30 = var9(var14(var5, 5), 31)
			local var31 = var9(var14(var5, 16), 31)
			local var32 = var9(var14(var5, 12), 15)
			local var33 = var11(var32, 1)

			var24 = var43[var32]

			if var17 and var32 ~= 14 and var32 ~= 15 then
				local var34, var35 = var4(var17, "([^|]*)|(.*)")

				if var30 == var31 then
					local var36 = #var6

					var6[var36] = nil
					var24 = var43[var33]

					if var30 ~= 31 then
						if var34 then
							var15 = var34
						else
							var15 = var17
						end
					else
						var6[var36 - 1] = nil
						var15 = var35
					end
				end
			end
		elseif iter0 == "W" then
			var24 = var9(var14(var5, 5), 65535)
		elseif iter0 == "Y" then
			var24 = var9(var14(var5, 5), 65535)

			local var37 = var9(var14(var5, 21), 3)

			if var17 and (var37 == 0 or var24 ~= 0) then
				var15 = var17
			end
		elseif iter0 == "L" then
			local var38 = var42.x[var9(var14(var5, 5), 31)]
			local var39 = var15(var13(var5, 11), 23)

			if var9(var5, 2048) ~= 0 then
				var24 = "[" .. var38 .. ", #" .. var39 .. "]!"
			else
				var24 = "[" .. var38 .. "], #" .. var39
			end
		elseif iter0 == "U" then
			local var40 = var42.x[var9(var14(var5, 5), 31)]
			local var41 = var9(var14(var5, 30), 3)
			local var42 = var13(var15(var13(var5, 10), 20), var41)

			if var42 ~= 0 then
				var24 = "[" .. var40 .. ", #" .. var42 .. "]"
			else
				var24 = "[" .. var40 .. "]"
			end
		elseif iter0 == "K" then
			local var43 = var42.x[var9(var14(var5, 5), 31)]
			local var44 = var15(var13(var5, 11), 23)

			if var44 ~= 0 then
				var24 = "[" .. var43 .. ", #" .. var44 .. "]"
			else
				var24 = "[" .. var43 .. "]"
			end
		elseif iter0 == "O" then
			local var45 = var42.x[var9(var14(var5, 5), 31)]
			local var46

			if var9(var14(var5, 13), 1) == 0 then
				var46 = var42.w[var9(var14(var5, 16), 31)]
			else
				var46 = var42.x[var9(var14(var5, 16), 31)]
			end

			var24 = "[" .. var45 .. ", " .. var46

			local var47 = var9(var14(var5, 13), 7)
			local var48 = var9(var14(var5, 12), 1)
			local var49 = var9(var14(var5, 30), 3)

			if var47 == 3 then
				if var48 == 0 then
					var24 = var24 .. "]"
				else
					var24 = var24 .. ", lsl #" .. var49 .. "]"
				end
			elseif var47 == 2 or var47 == 6 or var47 == 7 then
				if var48 == 0 then
					var24 = var24 .. ", " .. var45[var47] .. "]"
				else
					var24 = var24 .. ", " .. var45[var47] .. " #" .. var49 .. "]"
				end
			else
				var24 = var24 .. "]"
			end
		elseif iter0 == "P" then
			local var50 = var14(var5, 26)
			local var51 = 2

			if var50 >= 42 then
				var51 = 4
			elseif var50 >= 27 then
				var51 = 3
			end

			local var52 = var13(var15(var13(var5, 10), 25), var51)
			local var53 = var42.x[var9(var14(var5, 5), 31)]
			local var54 = var9(var14(var5, 23), 3)

			if var54 == 1 then
				var24 = "[" .. var53 .. "], #" .. var52
			elseif var54 == 2 then
				if var52 == 0 then
					var24 = "[" .. var53 .. "]"
				else
					var24 = "[" .. var53 .. ", #" .. var52 .. "]"
				end
			elseif var54 == 3 then
				var24 = "[" .. var53 .. ", #" .. var52 .. "]!"
			end
		elseif iter0 == "I" then
			local var55 = var9(var14(var5, 22), 3)
			local var56 = var9(var14(var5, 10), 4095)
			local var57 = var9(var14(var5, 5), 31)
			local var58 = var9(var5, 31)

			if var17 == "mov" and var55 == 0 and var56 == 0 and (var57 == 31 or var58 == 31) then
				var15 = var17
				var24 = nil
			elseif var55 == 0 then
				var24 = var56
			elseif var55 == 1 then
				var24 = var56 .. ", lsl #12"
			end
		elseif iter0 == "i" then
			var24 = "#0x" .. var51(var5)
		elseif iter0 == "1" then
			var23 = var9(var14(var5, 16), 63)
			var24 = var23
		elseif iter0 == "2" then
			var24 = var9(var14(var5, 10), 63)

			if var17 then
				local var59, var60, var61, var62, var63, var64 = var4(var17, "([^|]*)|([^|]*)|([^|]*)|([^|]*)|([^|]*)|(.*)")
				local var65 = var9(var14(var5, 26), 32)
				local var66 = var9(var14(var5, 30), 1)

				if var54(var65, var66, var24, var23) then
					var15 = var60
					var24 = var24 - var23 + 1
				elseif var23 == 0 and var24 == 7 then
					local var67 = #var6

					var6[var67] = nil

					if var65 ~= 0 then
						var6[var67 - 1] = var6(var6[var67 - 1], "x", "w")
					end

					var12 = var6[var67 - 1]
					var15 = var64
					var24 = nil
				elseif var23 == 0 and var24 == 15 then
					local var68 = #var6

					var6[var68] = nil

					if var65 ~= 0 then
						var6[var68 - 1] = var6(var6[var68 - 1], "x", "w")
					end

					var12 = var6[var68 - 1]
					var15 = var63
					var24 = nil
				elseif var24 == 31 or var24 == 63 then
					if var24 == 31 and var23 == 0 and var15 == "sbfm" then
						var15 = var62

						local var69 = #var6

						var6[var69] = nil

						if var65 ~= 0 then
							var6[var69 - 1] = var6(var6[var69 - 1], "x", "w")
						end

						var12 = var6[var69 - 1]
					else
						var15 = var61
					end

					var24 = nil
				elseif var9(var24, 31) ~= 31 and var23 == var24 + 1 and var15 == "ubfm" then
					var15 = var62
					var12 = "#" .. var65 + 32 - var23
					var6[#var6] = var12
					var24 = nil
				elseif var24 < var23 then
					var15 = var59
					var12 = "#" .. var65 + 32 - var23
					var6[#var6] = var12
					var24 = var24 + 1
				end
			end
		elseif iter0 == "3" then
			var24 = var9(var14(var5, 10), 63)

			if var17 then
				local var70, var71 = var4(var17, "([^|]*)|(.*)")

				if var24 < var23 then
					var15 = var70

					local var72 = var9(var14(var5, 26), 32)

					var12 = "#" .. var72 + 32 - var23
					var6[#var6] = var12
					var24 = var24 + 1
				elseif var23 <= var24 then
					var15 = var71
					var24 = var24 - var23 + 1
				end
			end
		elseif iter0 == "4" then
			var24 = var9(var14(var5, 10), 63)

			local var73 = var9(var14(var5, 5), 31)
			local var74 = var9(var14(var5, 16), 31)

			if var17 and var73 == var74 then
				local var75 = #var6

				var6[var75] = nil
				var12 = var6[var75 - 1]
				var15 = var17
			end
		elseif iter0 == "5" then
			var24 = var9(var14(var5, 16), 31)
		elseif iter0 == "S" then
			var24 = var9(var14(var5, 10), 63)

			if var24 == 0 then
				var24 = nil
			else
				var24 = var44[var9(var14(var5, 22), 3)] .. " #" .. var24
			end
		elseif iter0 == "X" then
			local var76 = var9(var14(var5, 13), 7)

			if var76 ~= 3 and var76 ~= 7 then
				var12 = var42.w[var9(var14(var5, 16), 31)]
				var6[#var6] = var12
			end

			var24 = var9(var14(var5, 10), 7)

			if var76 == 2 + var9(var14(var5, 31), 1) and var9(var14(var5, var22 and 5 or 0), 31) == 31 then
				if var24 == 0 then
					var24 = nil
				else
					var24 = "lsl #" .. var24
				end
			elseif var24 == 0 then
				var24 = var45[var9(var14(var5, 13), 7)]
			else
				var24 = var45[var9(var14(var5, 13), 7)] .. " #" .. var24
			end
		elseif iter0 == "R" then
			var24 = var9(var14(var5, 21), 3)

			if var24 == 0 then
				var24 = nil
			else
				var24 = "lsl #" .. var24 * 16
			end
		elseif iter0 == "z" then
			local var77 = #var6

			if var6[var77] == "sp" then
				var6[var77] = "xzr"
			elseif var6[var77] == "wsp" then
				var6[var77] = "wzr"
			end
		elseif iter0 == "Z" then
			var24 = 0
		elseif iter0 == "F" then
			var24 = var53(var5)
		elseif iter0 == "g" or iter0 == "f" or iter0 == "x" or iter0 == "w" or iter0 == "d" or iter0 == "s" then
			-- block empty
		elseif iter0 == "0" then
			if var12 == "sp" or var12 == "wsp" then
				local var78 = #var6

				var6[var78] = nil
				var12 = var6[var78 - 1]

				if var17 then
					local var79, var80 = var4(var17, "([^|]*)|(.*)")

					if not var79 then
						var15 = var17
					elseif var22 then
						var15, var17 = var80, var79
					else
						var15, var17 = var79, var80
					end
				end
			end

			var22 = true
		else
			assert(false)
		end

		if var24 then
			var12 = var24

			if var0(var24) == "number" then
				var24 = "#" .. var24
			end

			var6[#var6 + 1] = var24
		end
	end

	return var46(arg0, var15 .. var7, var6)
end

local function var56(arg0, arg1, arg2)
	arg1 = arg1 or 0

	local var0 = arg2 and arg1 + arg2 or #arg0.code

	arg0.pos = arg1
	arg0.rel = nil

	while var0 > arg0.pos do
		var55(arg0)
	end
end

local function var57(arg0, arg1, arg2)
	local var0 = {
		code = arg0,
		addr = arg1 or 0,
		out = arg2 or io.write,
		symtab = {},
		disass = var56
	}

	var0.hexdump = 8

	return var0
end

local function var58(arg0, arg1, arg2)
	var57(arg0, arg1, arg2):disass()
end

local function var59(arg0)
	if arg0 < 32 then
		return var42.x[arg0]
	end

	return var42.d[arg0 - 32]
end

return {
	create = var57,
	disass = var58,
	regname = var59
}
