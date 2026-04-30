pg = pg or {}
pg.island_achievement = rawget(pg, "island_achievement") or setmetatable({
	__name = "island_achievement"
}, confNEO)
pg.island_achievement.all = {
	1,
	2,
	3,
	4,
	5,
	6,
	21,
	22,
	23,
	24,
	25,
	26,
	31,
	32,
	33,
	34,
	35,
	36,
	41,
	42,
	43,
	44,
	45,
	46,
	51,
	52,
	53,
	54,
	55,
	56,
	61,
	62,
	63,
	64,
	65,
	66,
	71,
	72,
	73,
	74,
	75,
	76,
	81,
	82,
	83,
	84,
	85,
	86,
	91,
	92,
	93,
	94,
	95,
	96,
	1011,
	1012,
	1013,
	1014,
	1015,
	1016,
	1021,
	1022,
	1023,
	1024,
	1025,
	1026,
	1031,
	1032,
	1033,
	1034,
	1035,
	1036,
	1041,
	1042,
	1043,
	1044,
	1045,
	1046,
	1051,
	1052,
	1053,
	1054,
	1055,
	1056,
	1061,
	1062,
	1063,
	1064,
	1065,
	1066,
	1071,
	1072,
	1073,
	1074,
	1075,
	1076,
	1081,
	1082,
	1083,
	1084,
	1085,
	1086,
	2011,
	2012,
	2013,
	2014,
	2015,
	2016,
	2021,
	2022,
	2023,
	2024,
	2025,
	2026,
	2031,
	2032,
	2033,
	2034,
	2035,
	2036,
	2041,
	2042,
	2043,
	2044,
	2045,
	2046,
	2051,
	2052,
	2053,
	2054,
	2055,
	2056,
	3011,
	3012,
	3013,
	3014,
	3015,
	3016,
	3021,
	3022,
	3023,
	3024,
	3025,
	3026,
	3031,
	3032,
	3033,
	3034,
	3035,
	3036,
	3041,
	3042,
	3043,
	3044,
	3045,
	3046,
	3051,
	3052,
	3053,
	3054,
	3055,
	3056,
	3061,
	3062,
	3063,
	3064,
	3065,
	3066,
	3071,
	3072,
	3073,
	3074,
	3075,
	3076,
	3081,
	3082,
	3083,
	3084,
	3085,
	3086
}
pg.island_achievement.get_id_list_by_group = {
	{
		1,
		2,
		3,
		4,
		5,
		6
	},
	{
		21,
		22,
		23,
		24,
		25,
		26
	},
	{
		31,
		32,
		33,
		34,
		35,
		36
	},
	{
		41,
		42,
		43,
		44,
		45,
		46
	},
	{
		51,
		52,
		53,
		54,
		55,
		56
	},
	{
		61,
		62,
		63,
		64,
		65,
		66
	},
	{
		71,
		72,
		73,
		74,
		75,
		76
	},
	{
		81,
		82,
		83,
		84,
		85,
		86
	},
	{
		91,
		92,
		93,
		94,
		95,
		96
	},
	[101] = {
		1011,
		1012,
		1013,
		1014,
		1015,
		1016
	},
	[102] = {
		1021,
		1022,
		1023,
		1024,
		1025,
		1026
	},
	[103] = {
		1031,
		1032,
		1033,
		1034,
		1035,
		1036
	},
	[104] = {
		1041,
		1042,
		1043,
		1044,
		1045,
		1046
	},
	[105] = {
		1051,
		1052,
		1053,
		1054,
		1055,
		1056
	},
	[106] = {
		1061,
		1062,
		1063,
		1064,
		1065,
		1066
	},
	[107] = {
		1071,
		1072,
		1073,
		1074,
		1075,
		1076
	},
	[108] = {
		1081,
		1082,
		1083,
		1084,
		1085,
		1086
	},
	[201] = {
		2011,
		2012,
		2013,
		2014,
		2015,
		2016
	},
	[202] = {
		2021,
		2022,
		2023,
		2024,
		2025,
		2026
	},
	[203] = {
		2031,
		2032,
		2033,
		2034,
		2035,
		2036
	},
	[204] = {
		2041,
		2042,
		2043,
		2044,
		2045,
		2046
	},
	[205] = {
		2051,
		2052,
		2053,
		2054,
		2055,
		2056
	},
	[301] = {
		3011,
		3012,
		3013,
		3014,
		3015,
		3016
	},
	[302] = {
		3021,
		3022,
		3023,
		3024,
		3025,
		3026
	},
	[303] = {
		3031,
		3032,
		3033,
		3034,
		3035,
		3036
	},
	[304] = {
		3041,
		3042,
		3043,
		3044,
		3045,
		3046
	},
	[305] = {
		3051,
		3052,
		3053,
		3054,
		3055,
		3056
	},
	[306] = {
		3061,
		3062,
		3063,
		3064,
		3065,
		3066
	},
	[307] = {
		3071,
		3072,
		3073,
		3074,
		3075,
		3076
	},
	[308] = {
		3081,
		3082,
		3083,
		3084,
		3085,
		3086
	}
}
pg.base = pg.base or {}
pg.base.island_achievement = {}

;(function()
	pg.base.island_achievement[1] = {
		target_type = 1,
		name = "Starting From Zero",
		stage = 1,
		target_value1 = 0,
		group = 1,
		show_type = 1,
		desc = "Reach Island Dev. Level <color=#cd7900><b>$2</b></color>",
		id = 1,
		target_num = 15,
		award = {
			{
				45,
				10421,
				1
			}
		},
		award_display = {
			{
				45,
				10421,
				1
			}
		}
	}
	pg.base.island_achievement[2] = {
		target_type = 1,
		name = "Starting From Zero",
		stage = 2,
		target_value1 = 0,
		group = 1,
		show_type = 1,
		desc = "Reach Island Dev. Level <color=#cd7900><b>$2</b></color>",
		id = 2,
		target_num = 30,
		award = {
			{
				41,
				1,
				15000
			}
		},
		award_display = {
			{
				41,
				1,
				15000
			}
		}
	}
	pg.base.island_achievement[3] = {
		target_type = 1,
		name = "Starting From Zero",
		stage = 3,
		target_value1 = 0,
		group = 1,
		show_type = 1,
		desc = "Reach Island Dev. Level <color=#cd7900><b>$2</b></color>",
		id = 3,
		target_num = 40,
		award = {
			{
				41,
				100002,
				10
			}
		},
		award_display = {
			{
				41,
				100002,
				10
			}
		}
	}
	pg.base.island_achievement[4] = {
		target_type = 1,
		name = "Starting From Zero",
		stage = 4,
		target_value1 = 0,
		group = 1,
		show_type = 1,
		desc = "Reach Island Dev. Level <color=#cd7900><b>$2</b></color>",
		id = 4,
		target_num = 60,
		award = {
			{
				44,
				60802,
				1
			}
		},
		award_display = {
			{
				41,
				200015,
				1
			}
		}
	}
	pg.base.island_achievement[5] = {
		target_type = 1,
		name = "Starting From Zero",
		stage = 5,
		target_value1 = 0,
		group = 1,
		show_type = 1,
		desc = "Reach Island Dev. Level <color=#cd7900><b>$2</b></color>",
		id = 5,
		target_num = 80,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[6] = {
		target_type = 1,
		name = "Starting From Zero",
		stage = 6,
		target_value1 = 0,
		group = 1,
		show_type = 1,
		desc = "Reach Island Dev. Level <color=#cd7900><b>$2</b></color>",
		id = 6,
		target_num = 100,
		award = {
			{
				1,
				14,
				40
			}
		},
		award_display = {
			{
				1,
				14,
				40
			}
		}
	}
	pg.base.island_achievement[21] = {
		target_type = 27,
		name = "Face the Future",
		stage = 1,
		target_value1 = 0,
		group = 2,
		show_type = 1,
		desc = "Research <color=#cd7900><b>$2</b></color> Island Technologies",
		id = 21,
		target_num = 60,
		award = {
			{
				45,
				10409,
				1
			}
		},
		award_display = {
			{
				45,
				10409,
				1
			}
		}
	}
	pg.base.island_achievement[22] = {
		target_type = 27,
		name = "Face the Future",
		stage = 2,
		target_value1 = 0,
		group = 2,
		show_type = 1,
		desc = "Research <color=#cd7900><b>$2</b></color> Island Technologies",
		id = 22,
		target_num = 80,
		award = {
			{
				41,
				1,
				15000
			}
		},
		award_display = {
			{
				41,
				1,
				15000
			}
		}
	}
	pg.base.island_achievement[23] = {
		target_type = 27,
		name = "Face the Future",
		stage = 3,
		target_value1 = 0,
		group = 2,
		show_type = 1,
		desc = "Research <color=#cd7900><b>$2</b></color> Island Technologies",
		id = 23,
		target_num = 100,
		award = {
			{
				41,
				100002,
				10
			}
		},
		award_display = {
			{
				41,
				100002,
				10
			}
		}
	}
	pg.base.island_achievement[24] = {
		target_type = 27,
		name = "Face the Future",
		stage = 4,
		target_value1 = 0,
		group = 2,
		show_type = 1,
		desc = "Research <color=#cd7900><b>$2</b></color> Island Technologies",
		id = 24,
		target_num = 120,
		award = {
			{
				44,
				90111,
				1
			}
		},
		award_display = {
			{
				41,
				200008,
				1
			}
		}
	}
	pg.base.island_achievement[25] = {
		target_type = 27,
		name = "Face the Future",
		stage = 5,
		target_value1 = 0,
		group = 2,
		show_type = 1,
		desc = "Research <color=#cd7900><b>$2</b></color> Island Technologies",
		id = 25,
		target_num = 150,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[26] = {
		target_type = 27,
		name = "Face the Future",
		stage = 6,
		target_value1 = 0,
		group = 2,
		show_type = 1,
		desc = "Research <color=#cd7900><b>$2</b></color> Island Technologies",
		id = 26,
		target_num = 180,
		award = {
			{
				1,
				14,
				40
			}
		},
		award_display = {
			{
				1,
				14,
				40
			}
		}
	}
	pg.base.island_achievement[31] = {
		target_type = 2,
		name = "Model Islander",
		stage = 1,
		target_value1 = 3,
		group = 3,
		show_type = 1,
		desc = "Complete Daily Plans <color=#cd7900><b>$2</b></color> Time(s)",
		id = 31,
		target_num = 50,
		award = {
			{
				45,
				4,
				3
			}
		},
		award_display = {
			{
				45,
				4,
				3
			}
		}
	}
	pg.base.island_achievement[32] = {
		target_type = 2,
		name = "Model Islander",
		stage = 2,
		target_value1 = 3,
		group = 3,
		show_type = 1,
		desc = "Complete Daily Plans <color=#cd7900><b>$2</b></color> Time(s)",
		id = 32,
		target_num = 150,
		award = {
			{
				41,
				1,
				10000
			}
		},
		award_display = {
			{
				41,
				1,
				10000
			}
		}
	}
	pg.base.island_achievement[33] = {
		target_type = 2,
		name = "Model Islander",
		stage = 3,
		target_value1 = 3,
		group = 3,
		show_type = 1,
		desc = "Complete Daily Plans <color=#cd7900><b>$2</b></color> Time(s)",
		id = 33,
		target_num = 300,
		award = {
			{
				41,
				100002,
				5
			}
		},
		award_display = {
			{
				41,
				100002,
				5
			}
		}
	}
	pg.base.island_achievement[34] = {
		target_type = 2,
		name = "Model Islander",
		stage = 4,
		target_value1 = 3,
		group = 3,
		show_type = 1,
		desc = "Complete Daily Plans <color=#cd7900><b>$2</b></color> Time(s)",
		id = 34,
		target_num = 500,
		award = {
			{
				1,
				14,
				10
			}
		},
		award_display = {
			{
				1,
				14,
				10
			}
		}
	}
	pg.base.island_achievement[35] = {
		target_type = 2,
		name = "Model Islander",
		stage = 5,
		target_value1 = 3,
		group = 3,
		show_type = 1,
		desc = "Complete Daily Plans <color=#cd7900><b>$2</b></color> Time(s)",
		id = 35,
		target_num = 1000,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[36] = {
		target_type = 2,
		name = "Model Islander",
		stage = 6,
		target_value1 = 3,
		group = 3,
		show_type = 1,
		desc = "Complete Daily Plans <color=#cd7900><b>$2</b></color> Time(s)",
		id = 36,
		target_num = 2000,
		award = {
			{
				1,
				14,
				30
			}
		},
		award_display = {
			{
				1,
				14,
				30
			}
		}
	}
	pg.base.island_achievement[41] = {
		target_type = 22,
		name = "Reasonable Development Area",
		stage = 1,
		target_value1 = 1,
		group = 4,
		show_type = 1,
		desc = "Amass <color=#cd7900><b>$2</b></color> Development Funds",
		id = 41,
		target_num = 100000,
		award = {
			{
				45,
				10403,
				1
			}
		},
		award_display = {
			{
				45,
				10403,
				1
			}
		}
	}
	pg.base.island_achievement[42] = {
		target_type = 22,
		name = "Reasonable Development Area",
		stage = 2,
		target_value1 = 1,
		group = 4,
		show_type = 1,
		desc = "Amass <color=#cd7900><b>$2</b></color> Development Funds",
		id = 42,
		target_num = 1000000,
		award = {
			{
				41,
				1,
				10000
			}
		},
		award_display = {
			{
				41,
				1,
				10000
			}
		}
	}
	pg.base.island_achievement[43] = {
		target_type = 22,
		name = "Reasonable Development Area",
		stage = 3,
		target_value1 = 1,
		group = 4,
		show_type = 1,
		desc = "Amass <color=#cd7900><b>$2</b></color> Development Funds",
		id = 43,
		target_num = 5000000,
		award = {
			{
				41,
				100002,
				5
			}
		},
		award_display = {
			{
				41,
				100002,
				5
			}
		}
	}
	pg.base.island_achievement[44] = {
		target_type = 22,
		name = "Reasonable Development Area",
		stage = 4,
		target_value1 = 1,
		group = 4,
		show_type = 1,
		desc = "Amass <color=#cd7900><b>$2</b></color> Development Funds",
		id = 44,
		target_num = 10000000,
		award = {
			{
				1,
				14,
				10
			}
		},
		award_display = {
			{
				1,
				14,
				10
			}
		}
	}
	pg.base.island_achievement[45] = {
		target_type = 22,
		name = "Reasonable Development Area",
		stage = 5,
		target_value1 = 1,
		group = 4,
		show_type = 1,
		desc = "Amass <color=#cd7900><b>$2</b></color> Development Funds",
		id = 45,
		target_num = 20000000,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[46] = {
		target_type = 22,
		name = "Reasonable Development Area",
		stage = 6,
		target_value1 = 1,
		group = 4,
		show_type = 1,
		desc = "Amass <color=#cd7900><b>$2</b></color> Development Funds",
		id = 46,
		target_num = 50000000,
		award = {
			{
				1,
				14,
				30
			}
		},
		award_display = {
			{
				1,
				14,
				30
			}
		}
	}
	pg.base.island_achievement[51] = {
		target_type = 16,
		name = "The Miraculous Development Area",
		stage = 1,
		target_value1 = 6,
		group = 5,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Outfit(s) - Costume",
		id = 51,
		target_num = 3,
		award = {
			{
				45,
				10416,
				1
			}
		},
		award_display = {
			{
				45,
				10416,
				1
			}
		}
	}
	pg.base.island_achievement[52] = {
		target_type = 16,
		name = "The Miraculous Development Area",
		stage = 2,
		target_value1 = 6,
		group = 5,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Outfit(s) - Costume",
		id = 52,
		target_num = 4,
		award = {
			{
				41,
				1,
				10000
			}
		},
		award_display = {
			{
				41,
				1,
				10000
			}
		}
	}
	pg.base.island_achievement[53] = {
		target_type = 16,
		name = "The Miraculous Development Area",
		stage = 3,
		target_value1 = 6,
		group = 5,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Outfit(s) - Costume",
		id = 53,
		target_num = 6,
		award = {
			{
				41,
				100002,
				5
			}
		},
		award_display = {
			{
				41,
				100002,
				5
			}
		}
	}
	pg.base.island_achievement[54] = {
		target_type = 16,
		name = "The Miraculous Development Area",
		stage = 4,
		target_value1 = 6,
		group = 5,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Outfit(s) - Costume",
		id = 54,
		target_num = 8,
		award = {
			{
				1,
				14,
				10
			}
		},
		award_display = {
			{
				1,
				14,
				10
			}
		}
	}
	pg.base.island_achievement[55] = {
		target_type = 16,
		name = "The Miraculous Development Area",
		stage = 5,
		target_value1 = 6,
		group = 5,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Outfit(s) - Costume",
		id = 55,
		target_num = 10,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[56] = {
		target_type = 16,
		name = "The Miraculous Development Area",
		stage = 6,
		target_value1 = 6,
		group = 5,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Outfit(s) - Costume",
		id = 56,
		target_num = 16,
		award = {
			{
				1,
				14,
				30
			}
		},
		award_display = {
			{
				1,
				14,
				30
			}
		}
	}
	pg.base.island_achievement[61] = {
		target_type = 16,
		name = "Don't Look Back",
		stage = 1,
		target_value1 = 1,
		group = 6,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Outfit(s) - Back",
		id = 61,
		target_num = 3,
		award = {
			{
				45,
				10418,
				1
			}
		},
		award_display = {
			{
				45,
				10418,
				1
			}
		}
	}
	pg.base.island_achievement[62] = {
		target_type = 16,
		name = "Don't Look Back",
		stage = 2,
		target_value1 = 1,
		group = 6,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Outfit(s) - Back",
		id = 62,
		target_num = 4,
		award = {
			{
				41,
				1,
				10000
			}
		},
		award_display = {
			{
				41,
				1,
				10000
			}
		}
	}
	pg.base.island_achievement[63] = {
		target_type = 16,
		name = "Don't Look Back",
		stage = 3,
		target_value1 = 1,
		group = 6,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Outfit(s) - Back",
		id = 63,
		target_num = 6,
		award = {
			{
				41,
				100002,
				5
			}
		},
		award_display = {
			{
				41,
				100002,
				5
			}
		}
	}
	pg.base.island_achievement[64] = {
		target_type = 16,
		name = "Don't Look Back",
		stage = 4,
		target_value1 = 1,
		group = 6,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Outfit(s) - Back",
		id = 64,
		target_num = 8,
		award = {
			{
				1,
				14,
				10
			}
		},
		award_display = {
			{
				1,
				14,
				10
			}
		}
	}
	pg.base.island_achievement[65] = {
		target_type = 16,
		name = "Don't Look Back",
		stage = 5,
		target_value1 = 1,
		group = 6,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Outfit(s) - Back",
		id = 65,
		target_num = 10,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[66] = {
		target_type = 16,
		name = "Don't Look Back",
		stage = 6,
		target_value1 = 1,
		group = 6,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Outfit(s) - Back",
		id = 66,
		target_num = 16,
		award = {
			{
				1,
				14,
				30
			}
		},
		award_display = {
			{
				1,
				14,
				30
			}
		}
	}
	pg.base.island_achievement[71] = {
		target_type = 16,
		name = "Leaving My Mark",
		stage = 1,
		target_value1 = 3,
		group = 7,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Outfit(s) - Trail",
		id = 71,
		target_num = 3,
		award = {
			{
				45,
				10412,
				1
			}
		},
		award_display = {
			{
				45,
				10412,
				1
			}
		}
	}
	pg.base.island_achievement[72] = {
		target_type = 16,
		name = "Leaving My Mark",
		stage = 2,
		target_value1 = 3,
		group = 7,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Outfit(s) - Trail",
		id = 72,
		target_num = 4,
		award = {
			{
				41,
				1,
				10000
			}
		},
		award_display = {
			{
				41,
				1,
				10000
			}
		}
	}
	pg.base.island_achievement[73] = {
		target_type = 16,
		name = "Leaving My Mark",
		stage = 3,
		target_value1 = 3,
		group = 7,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Outfit(s) - Trail",
		id = 73,
		target_num = 6,
		award = {
			{
				41,
				100002,
				5
			}
		},
		award_display = {
			{
				41,
				100002,
				5
			}
		}
	}
	pg.base.island_achievement[74] = {
		target_type = 16,
		name = "Leaving My Mark",
		stage = 4,
		target_value1 = 3,
		group = 7,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Outfit(s) - Trail",
		id = 74,
		target_num = 8,
		award = {
			{
				1,
				14,
				10
			}
		},
		award_display = {
			{
				1,
				14,
				10
			}
		}
	}
	pg.base.island_achievement[75] = {
		target_type = 16,
		name = "Leaving My Mark",
		stage = 5,
		target_value1 = 3,
		group = 7,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Outfit(s) - Trail",
		id = 75,
		target_num = 10,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[76] = {
		target_type = 16,
		name = "Leaving My Mark",
		stage = 6,
		target_value1 = 3,
		group = 7,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Outfit(s) - Trail",
		id = 76,
		target_num = 16,
		award = {
			{
				1,
				14,
				30
			}
		},
		award_display = {
			{
				1,
				14,
				30
			}
		}
	}
	pg.base.island_achievement[81] = {
		target_type = 16,
		name = "I'm Flying!",
		stage = 1,
		target_value1 = 2,
		group = 8,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Outfit(s) - Floating",
		id = 81,
		target_num = 3,
		award = {
			{
				45,
				11,
				3
			}
		},
		award_display = {
			{
				45,
				11,
				3
			}
		}
	}
	pg.base.island_achievement[82] = {
		target_type = 16,
		name = "I'm Flying!",
		stage = 2,
		target_value1 = 2,
		group = 8,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Outfit(s) - Floating",
		id = 82,
		target_num = 4,
		award = {
			{
				41,
				1,
				10000
			}
		},
		award_display = {
			{
				41,
				1,
				10000
			}
		}
	}
	pg.base.island_achievement[83] = {
		target_type = 16,
		name = "I'm Flying!",
		stage = 3,
		target_value1 = 2,
		group = 8,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Outfit(s) - Floating",
		id = 83,
		target_num = 6,
		award = {
			{
				41,
				100002,
				5
			}
		},
		award_display = {
			{
				41,
				100002,
				5
			}
		}
	}
	pg.base.island_achievement[84] = {
		target_type = 16,
		name = "I'm Flying!",
		stage = 4,
		target_value1 = 2,
		group = 8,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Outfit(s) - Floating",
		id = 84,
		target_num = 8,
		award = {
			{
				1,
				14,
				10
			}
		},
		award_display = {
			{
				1,
				14,
				10
			}
		}
	}
	pg.base.island_achievement[85] = {
		target_type = 16,
		name = "I'm Flying!",
		stage = 5,
		target_value1 = 2,
		group = 8,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Outfit(s) - Floating",
		id = 85,
		target_num = 10,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[86] = {
		target_type = 16,
		name = "I'm Flying!",
		stage = 6,
		target_value1 = 2,
		group = 8,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Outfit(s) - Floating",
		id = 86,
		target_num = 16,
		award = {
			{
				1,
				14,
				30
			}
		},
		award_display = {
			{
				1,
				14,
				30
			}
		}
	}
	pg.base.island_achievement[91] = {
		target_type = 36,
		name = "Beat Maniac",
		stage = 1,
		target_value1 = 0,
		group = 9,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Interactive Action(s)",
		id = 91,
		target_num = 10,
		award = {
			{
				45,
				10414,
				1
			}
		},
		award_display = {
			{
				45,
				10414,
				1
			}
		}
	}
	pg.base.island_achievement[92] = {
		target_type = 36,
		name = "Beat Maniac",
		stage = 2,
		target_value1 = 0,
		group = 9,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Interactive Action(s)",
		id = 92,
		target_num = 12,
		award = {
			{
				41,
				1,
				10000
			}
		},
		award_display = {
			{
				41,
				1,
				10000
			}
		}
	}
	pg.base.island_achievement[93] = {
		target_type = 36,
		name = "Beat Maniac",
		stage = 3,
		target_value1 = 0,
		group = 9,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Interactive Action(s)",
		id = 93,
		target_num = 15,
		award = {
			{
				41,
				100002,
				5
			}
		},
		award_display = {
			{
				41,
				100002,
				5
			}
		}
	}
	pg.base.island_achievement[94] = {
		target_type = 36,
		name = "Beat Maniac",
		stage = 4,
		target_value1 = 0,
		group = 9,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Interactive Action(s)",
		id = 94,
		target_num = 20,
		award = {
			{
				1,
				14,
				10
			}
		},
		award_display = {
			{
				1,
				14,
				10
			}
		}
	}
	pg.base.island_achievement[95] = {
		target_type = 36,
		name = "Beat Maniac",
		stage = 5,
		target_value1 = 0,
		group = 9,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Interactive Action(s)",
		id = 95,
		target_num = 25,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[96] = {
		target_type = 36,
		name = "Beat Maniac",
		stage = 6,
		target_value1 = 0,
		group = 9,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Commander Interactive Action(s)",
		id = 96,
		target_num = 35,
		award = {
			{
				1,
				14,
				30
			}
		},
		award_display = {
			{
				1,
				14,
				30
			}
		}
	}
	pg.base.island_achievement[1011] = {
		target_type = 13,
		name = "Perfect Attendance Medal",
		stage = 1,
		target_value1 = 0,
		group = 101,
		show_type = 1,
		desc = "Log In to the Island Planner Mode for <color=#cd7900><b>$2</b></color> Days",
		id = 1011,
		target_num = 15,
		award = {
			{
				45,
				10421,
				1
			}
		},
		award_display = {
			{
				45,
				10421,
				1
			}
		}
	}
	pg.base.island_achievement[1012] = {
		target_type = 13,
		name = "Perfect Attendance Medal",
		stage = 2,
		target_value1 = 0,
		group = 101,
		show_type = 1,
		desc = "Log In to the Island Planner Mode for <color=#cd7900><b>$2</b></color> Days",
		id = 1012,
		target_num = 30,
		award = {
			{
				41,
				1,
				15000
			}
		},
		award_display = {
			{
				41,
				1,
				15000
			}
		}
	}
	pg.base.island_achievement[1013] = {
		target_type = 13,
		name = "Perfect Attendance Medal",
		stage = 3,
		target_value1 = 0,
		group = 101,
		show_type = 1,
		desc = "Log In to the Island Planner Mode for <color=#cd7900><b>$2</b></color> Days",
		id = 1013,
		target_num = 60,
		award = {
			{
				41,
				100002,
				10
			}
		},
		award_display = {
			{
				41,
				100002,
				10
			}
		}
	}
	pg.base.island_achievement[1014] = {
		target_type = 13,
		name = "Perfect Attendance Medal",
		stage = 4,
		target_value1 = 0,
		group = 101,
		show_type = 1,
		desc = "Log In to the Island Planner Mode for <color=#cd7900><b>$2</b></color> Days",
		id = 1014,
		target_num = 120,
		award = {
			{
				1,
				14,
				20
			}
		},
		award_display = {
			{
				1,
				14,
				20
			}
		}
	}
	pg.base.island_achievement[1015] = {
		target_type = 13,
		name = "Perfect Attendance Medal",
		stage = 5,
		target_value1 = 0,
		group = 101,
		show_type = 1,
		desc = "Log In to the Island Planner Mode for <color=#cd7900><b>$2</b></color> Days",
		id = 1015,
		target_num = 250,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[1016] = {
		target_type = 13,
		name = "Perfect Attendance Medal",
		stage = 6,
		target_value1 = 0,
		group = 101,
		show_type = 1,
		desc = "Log In to the Island Planner Mode for <color=#cd7900><b>$2</b></color> Days",
		id = 1016,
		target_num = 500,
		award = {
			{
				1,
				14,
				40
			}
		},
		award_display = {
			{
				1,
				14,
				40
			}
		}
	}
	pg.base.island_achievement[1021] = {
		target_type = 21,
		name = "There's Gold in Them Thar Hills",
		stage = 1,
		target_value1 = 401,
		group = 102,
		show_type = 1,
		desc = "Manually Collect From Rockheap Mine <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1021,
		target_num = 15,
		award = {
			{
				45,
				10418,
				1
			}
		},
		award_display = {
			{
				45,
				10418,
				1
			}
		}
	}
	pg.base.island_achievement[1022] = {
		target_type = 21,
		name = "There's Gold in Them Thar Hills",
		stage = 2,
		target_value1 = 401,
		group = 102,
		show_type = 1,
		desc = "Manually Collect From Rockheap Mine <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1022,
		target_num = 50,
		award = {
			{
				41,
				1,
				5000
			}
		},
		award_display = {
			{
				41,
				1,
				5000
			}
		}
	}
	pg.base.island_achievement[1023] = {
		target_type = 21,
		name = "There's Gold in Them Thar Hills",
		stage = 3,
		target_value1 = 401,
		group = 102,
		show_type = 1,
		desc = "Manually Collect From Rockheap Mine <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1023,
		target_num = 100,
		award = {
			{
				41,
				100002,
				2
			}
		},
		award_display = {
			{
				41,
				100002,
				2
			}
		}
	}
	pg.base.island_achievement[1024] = {
		target_type = 21,
		name = "There's Gold in Them Thar Hills",
		stage = 4,
		target_value1 = 401,
		group = 102,
		show_type = 1,
		desc = "Manually Collect From Rockheap Mine <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1024,
		target_num = 250,
		award = {
			{
				41,
				1,
				20000
			}
		},
		award_display = {
			{
				41,
				1,
				20000
			}
		}
	}
	pg.base.island_achievement[1025] = {
		target_type = 21,
		name = "There's Gold in Them Thar Hills",
		stage = 5,
		target_value1 = 401,
		group = 102,
		show_type = 1,
		desc = "Manually Collect From Rockheap Mine <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1025,
		target_num = 400,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[1026] = {
		target_type = 21,
		name = "There's Gold in Them Thar Hills",
		stage = 6,
		target_value1 = 401,
		group = 102,
		show_type = 1,
		desc = "Manually Collect From Rockheap Mine <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1026,
		target_num = 700,
		award = {
			{
				1,
				14,
				20
			}
		},
		award_display = {
			{
				1,
				14,
				20
			}
		}
	}
	pg.base.island_achievement[1031] = {
		target_type = 21,
		name = "An Axe to Grind",
		stage = 1,
		target_value1 = 402,
		group = 103,
		show_type = 1,
		desc = "Manually Collect From the Woods <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1031,
		target_num = 15,
		award = {
			{
				45,
				10412,
				1
			}
		},
		award_display = {
			{
				45,
				10412,
				1
			}
		}
	}
	pg.base.island_achievement[1032] = {
		target_type = 21,
		name = "An Axe to Grind",
		stage = 2,
		target_value1 = 402,
		group = 103,
		show_type = 1,
		desc = "Manually Collect From the Woods <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1032,
		target_num = 50,
		award = {
			{
				41,
				1,
				5000
			}
		},
		award_display = {
			{
				41,
				1,
				5000
			}
		}
	}
	pg.base.island_achievement[1033] = {
		target_type = 21,
		name = "An Axe to Grind",
		stage = 3,
		target_value1 = 402,
		group = 103,
		show_type = 1,
		desc = "Manually Collect From the Woods <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1033,
		target_num = 100,
		award = {
			{
				41,
				100002,
				2
			}
		},
		award_display = {
			{
				41,
				100002,
				2
			}
		}
	}
	pg.base.island_achievement[1034] = {
		target_type = 21,
		name = "An Axe to Grind",
		stage = 4,
		target_value1 = 402,
		group = 103,
		show_type = 1,
		desc = "Manually Collect From the Woods <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1034,
		target_num = 250,
		award = {
			{
				41,
				1,
				20000
			}
		},
		award_display = {
			{
				41,
				1,
				20000
			}
		}
	}
	pg.base.island_achievement[1035] = {
		target_type = 21,
		name = "An Axe to Grind",
		stage = 5,
		target_value1 = 402,
		group = 103,
		show_type = 1,
		desc = "Manually Collect From the Woods <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1035,
		target_num = 400,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[1036] = {
		target_type = 21,
		name = "An Axe to Grind",
		stage = 6,
		target_value1 = 402,
		group = 103,
		show_type = 1,
		desc = "Manually Collect From the Woods <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1036,
		target_num = 700,
		award = {
			{
				1,
				14,
				20
			}
		},
		award_display = {
			{
				1,
				14,
				20
			}
		}
	}
	pg.base.island_achievement[1041] = {
		target_type = 21,
		name = "Build More Burrows",
		stage = 1,
		target_value1 = 101,
		group = 104,
		show_type = 1,
		desc = "Manually Collect From the Fields <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1041,
		target_num = 15,
		award = {
			{
				45,
				10413,
				1
			}
		},
		award_display = {
			{
				45,
				10413,
				1
			}
		}
	}
	pg.base.island_achievement[1042] = {
		target_type = 21,
		name = "Build More Burrows",
		stage = 2,
		target_value1 = 101,
		group = 104,
		show_type = 1,
		desc = "Manually Collect From the Fields <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1042,
		target_num = 50,
		award = {
			{
				41,
				1,
				5000
			}
		},
		award_display = {
			{
				41,
				1,
				5000
			}
		}
	}
	pg.base.island_achievement[1043] = {
		target_type = 21,
		name = "Build More Burrows",
		stage = 3,
		target_value1 = 101,
		group = 104,
		show_type = 1,
		desc = "Manually Collect From the Fields <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1043,
		target_num = 100,
		award = {
			{
				41,
				100002,
				2
			}
		},
		award_display = {
			{
				41,
				100002,
				2
			}
		}
	}
	pg.base.island_achievement[1044] = {
		target_type = 21,
		name = "Build More Burrows",
		stage = 4,
		target_value1 = 101,
		group = 104,
		show_type = 1,
		desc = "Manually Collect From the Fields <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1044,
		target_num = 250,
		award = {
			{
				41,
				1,
				20000
			}
		},
		award_display = {
			{
				41,
				1,
				20000
			}
		}
	}
	pg.base.island_achievement[1045] = {
		target_type = 21,
		name = "Build More Burrows",
		stage = 5,
		target_value1 = 101,
		group = 104,
		show_type = 1,
		desc = "Manually Collect From the Fields <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1045,
		target_num = 400,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[1046] = {
		target_type = 21,
		name = "Build More Burrows",
		stage = 6,
		target_value1 = 101,
		group = 104,
		show_type = 1,
		desc = "Manually Collect From the Fields <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1046,
		target_num = 700,
		award = {
			{
				1,
				14,
				20
			}
		},
		award_display = {
			{
				1,
				14,
				20
			}
		}
	}
	pg.base.island_achievement[1051] = {
		target_type = 21,
		name = "Holy Grail of Fruits",
		stage = 1,
		target_value1 = 501,
		group = 105,
		show_type = 1,
		desc = "Manually Collect From the Orchard <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1051,
		target_num = 15,
		award = {
			{
				45,
				10415,
				1
			}
		},
		award_display = {
			{
				45,
				10415,
				1
			}
		}
	}
	pg.base.island_achievement[1052] = {
		target_type = 21,
		name = "Holy Grail of Fruits",
		stage = 2,
		target_value1 = 501,
		group = 105,
		show_type = 1,
		desc = "Manually Collect From the Orchard <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1052,
		target_num = 50,
		award = {
			{
				41,
				1,
				5000
			}
		},
		award_display = {
			{
				41,
				1,
				5000
			}
		}
	}
	pg.base.island_achievement[1053] = {
		target_type = 21,
		name = "Holy Grail of Fruits",
		stage = 3,
		target_value1 = 501,
		group = 105,
		show_type = 1,
		desc = "Manually Collect From the Orchard <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1053,
		target_num = 100,
		award = {
			{
				41,
				100002,
				2
			}
		},
		award_display = {
			{
				41,
				100002,
				2
			}
		}
	}
	pg.base.island_achievement[1054] = {
		target_type = 21,
		name = "Holy Grail of Fruits",
		stage = 4,
		target_value1 = 501,
		group = 105,
		show_type = 1,
		desc = "Manually Collect From the Orchard <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1054,
		target_num = 250,
		award = {
			{
				41,
				1,
				20000
			}
		},
		award_display = {
			{
				41,
				1,
				20000
			}
		}
	}
	pg.base.island_achievement[1055] = {
		target_type = 21,
		name = "Holy Grail of Fruits",
		stage = 5,
		target_value1 = 501,
		group = 105,
		show_type = 1,
		desc = "Manually Collect From the Orchard <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1055,
		target_num = 400,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[1056] = {
		target_type = 21,
		name = "Holy Grail of Fruits",
		stage = 6,
		target_value1 = 501,
		group = 105,
		show_type = 1,
		desc = "Manually Collect From the Orchard <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1056,
		target_num = 700,
		award = {
			{
				1,
				14,
				20
			}
		},
		award_display = {
			{
				1,
				14,
				20
			}
		}
	}
	pg.base.island_achievement[1061] = {
		target_type = 21,
		name = "The Secret Garden",
		stage = 1,
		target_value1 = 502,
		group = 106,
		show_type = 1,
		desc = "Manually Collect From the Nursery <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1061,
		target_num = 15,
		award = {
			{
				45,
				10403,
				1
			}
		},
		award_display = {
			{
				45,
				10403,
				1
			}
		}
	}
	pg.base.island_achievement[1062] = {
		target_type = 21,
		name = "The Secret Garden",
		stage = 2,
		target_value1 = 502,
		group = 106,
		show_type = 1,
		desc = "Manually Collect From the Nursery <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1062,
		target_num = 50,
		award = {
			{
				41,
				1,
				5000
			}
		},
		award_display = {
			{
				41,
				1,
				5000
			}
		}
	}
	pg.base.island_achievement[1063] = {
		target_type = 21,
		name = "The Secret Garden",
		stage = 3,
		target_value1 = 502,
		group = 106,
		show_type = 1,
		desc = "Manually Collect From the Nursery <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1063,
		target_num = 100,
		award = {
			{
				41,
				100002,
				2
			}
		},
		award_display = {
			{
				41,
				100002,
				2
			}
		}
	}
	pg.base.island_achievement[1064] = {
		target_type = 21,
		name = "The Secret Garden",
		stage = 4,
		target_value1 = 502,
		group = 106,
		show_type = 1,
		desc = "Manually Collect From the Nursery <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1064,
		target_num = 250,
		award = {
			{
				41,
				1,
				20000
			}
		},
		award_display = {
			{
				41,
				1,
				20000
			}
		}
	}
	pg.base.island_achievement[1065] = {
		target_type = 21,
		name = "The Secret Garden",
		stage = 5,
		target_value1 = 502,
		group = 106,
		show_type = 1,
		desc = "Manually Collect From the Nursery <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1065,
		target_num = 400,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[1066] = {
		target_type = 21,
		name = "The Secret Garden",
		stage = 6,
		target_value1 = 502,
		group = 106,
		show_type = 1,
		desc = "Manually Collect From the Nursery <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1066,
		target_num = 700,
		award = {
			{
				1,
				14,
				20
			}
		},
		award_display = {
			{
				1,
				14,
				20
			}
		}
	}
	pg.base.island_achievement[1071] = {
		target_type = 24,
		name = "All About That Hustle",
		stage = 1,
		target_value1 = 0,
		group = 107,
		show_type = 1,
		desc = "Assign Characters a Total of <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1071,
		target_num = 75,
		award = {
			{
				45,
				10420,
				1
			}
		},
		award_display = {
			{
				45,
				10420,
				1
			}
		}
	}
	pg.base.island_achievement[1072] = {
		target_type = 24,
		name = "All About That Hustle",
		stage = 2,
		target_value1 = 0,
		group = 107,
		show_type = 1,
		desc = "Assign Characters a Total of <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1072,
		target_num = 150,
		award = {
			{
				41,
				1,
				5000
			}
		},
		award_display = {
			{
				41,
				1,
				5000
			}
		}
	}
	pg.base.island_achievement[1073] = {
		target_type = 24,
		name = "All About That Hustle",
		stage = 3,
		target_value1 = 0,
		group = 107,
		show_type = 1,
		desc = "Assign Characters a Total of <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1073,
		target_num = 300,
		award = {
			{
				41,
				100002,
				2
			}
		},
		award_display = {
			{
				41,
				100002,
				2
			}
		}
	}
	pg.base.island_achievement[1074] = {
		target_type = 24,
		name = "All About That Hustle",
		stage = 4,
		target_value1 = 0,
		group = 107,
		show_type = 1,
		desc = "Assign Characters a Total of <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1074,
		target_num = 600,
		award = {
			{
				41,
				1,
				20000
			}
		},
		award_display = {
			{
				41,
				1,
				20000
			}
		}
	}
	pg.base.island_achievement[1075] = {
		target_type = 24,
		name = "All About That Hustle",
		stage = 5,
		target_value1 = 0,
		group = 107,
		show_type = 1,
		desc = "Assign Characters a Total of <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1075,
		target_num = 1000,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[1076] = {
		target_type = 24,
		name = "All About That Hustle",
		stage = 6,
		target_value1 = 0,
		group = 107,
		show_type = 1,
		desc = "Assign Characters a Total of <color=#cd7900><b>$2</b></color> Time(s)",
		id = 1076,
		target_num = 2000,
		award = {
			{
				1,
				14,
				20
			}
		},
		award_display = {
			{
				1,
				14,
				20
			}
		}
	}
	pg.base.island_achievement[1081] = {
		target_type = 33,
		name = "Let's Get This Party Started",
		stage = 1,
		target_value1 = 0,
		group = 108,
		show_type = 1,
		desc = "Acquire a Total of <color=#cd7900><b>$2</b></color> Kind(s) of Furniture",
		id = 1081,
		target_num = 30,
		award = {
			{
				45,
				10414,
				1
			}
		},
		award_display = {
			{
				45,
				10414,
				1
			}
		}
	}
	pg.base.island_achievement[1082] = {
		target_type = 33,
		name = "Let's Get This Party Started",
		stage = 2,
		target_value1 = 0,
		group = 108,
		show_type = 1,
		desc = "Acquire a Total of <color=#cd7900><b>$2</b></color> Kind(s) of Furniture",
		id = 1082,
		target_num = 40,
		award = {
			{
				41,
				1,
				5000
			}
		},
		award_display = {
			{
				41,
				1,
				5000
			}
		}
	}
	pg.base.island_achievement[1083] = {
		target_type = 33,
		name = "Let's Get This Party Started",
		stage = 3,
		target_value1 = 0,
		group = 108,
		show_type = 1,
		desc = "Acquire a Total of <color=#cd7900><b>$2</b></color> Kind(s) of Furniture",
		id = 1083,
		target_num = 50,
		award = {
			{
				41,
				100002,
				2
			}
		},
		award_display = {
			{
				41,
				100002,
				2
			}
		}
	}
	pg.base.island_achievement[1084] = {
		target_type = 33,
		name = "Let's Get This Party Started",
		stage = 4,
		target_value1 = 0,
		group = 108,
		show_type = 1,
		desc = "Acquire a Total of <color=#cd7900><b>$2</b></color> Kind(s) of Furniture",
		id = 1084,
		target_num = 70,
		award = {
			{
				41,
				1,
				20000
			}
		},
		award_display = {
			{
				41,
				1,
				20000
			}
		}
	}
end)()
;(function()
	pg.base.island_achievement[1085] = {
		target_type = 33,
		name = "Let's Get This Party Started",
		stage = 5,
		target_value1 = 0,
		group = 108,
		show_type = 1,
		desc = "Acquire a Total of <color=#cd7900><b>$2</b></color> Kind(s) of Furniture",
		id = 1085,
		target_num = 90,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[1086] = {
		target_type = 33,
		name = "Let's Get This Party Started",
		stage = 6,
		target_value1 = 0,
		group = 108,
		show_type = 1,
		desc = "Acquire a Total of <color=#cd7900><b>$2</b></color> Kind(s) of Furniture",
		id = 1086,
		target_num = 200,
		award = {
			{
				1,
				14,
				20
			}
		},
		award_display = {
			{
				1,
				14,
				20
			}
		}
	}
	pg.base.island_achievement[2011] = {
		target_type = 4,
		name = "No Time Like Overtime",
		stage = 1,
		target_value1 = 1,
		group = 201,
		show_type = 1,
		desc = "Complete a Total of <color=#cd7900><b>$2</b></color> Island Request(s)",
		id = 2011,
		target_num = 75,
		award = {
			{
				45,
				10410,
				1
			}
		},
		award_display = {
			{
				45,
				10410,
				1
			}
		}
	}
	pg.base.island_achievement[2012] = {
		target_type = 4,
		name = "No Time Like Overtime",
		stage = 2,
		target_value1 = 1,
		group = 201,
		show_type = 1,
		desc = "Complete a Total of <color=#cd7900><b>$2</b></color> Island Request(s)",
		id = 2012,
		target_num = 150,
		award = {
			{
				41,
				1,
				15000
			}
		},
		award_display = {
			{
				41,
				1,
				15000
			}
		}
	}
	pg.base.island_achievement[2013] = {
		target_type = 4,
		name = "No Time Like Overtime",
		stage = 3,
		target_value1 = 1,
		group = 201,
		show_type = 1,
		desc = "Complete a Total of <color=#cd7900><b>$2</b></color> Island Request(s)",
		id = 2013,
		target_num = 300,
		award = {
			{
				41,
				100002,
				10
			}
		},
		award_display = {
			{
				41,
				100002,
				10
			}
		}
	}
	pg.base.island_achievement[2014] = {
		target_type = 4,
		name = "No Time Like Overtime",
		stage = 4,
		target_value1 = 1,
		group = 201,
		show_type = 1,
		desc = "Complete a Total of <color=#cd7900><b>$2</b></color> Island Request(s)",
		id = 2014,
		target_num = 600,
		award = {
			{
				1,
				14,
				20
			}
		},
		award_display = {
			{
				1,
				14,
				20
			}
		}
	}
	pg.base.island_achievement[2015] = {
		target_type = 4,
		name = "No Time Like Overtime",
		stage = 5,
		target_value1 = 1,
		group = 201,
		show_type = 1,
		desc = "Complete a Total of <color=#cd7900><b>$2</b></color> Island Request(s)",
		id = 2015,
		target_num = 1000,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[2016] = {
		target_type = 4,
		name = "No Time Like Overtime",
		stage = 6,
		target_value1 = 1,
		group = 201,
		show_type = 1,
		desc = "Complete a Total of <color=#cd7900><b>$2</b></color> Island Request(s)",
		id = 2016,
		target_num = 2000,
		award = {
			{
				1,
				14,
				40
			}
		},
		award_display = {
			{
				1,
				14,
				40
			}
		}
	}
	pg.base.island_achievement[2021] = {
		target_type = 4,
		name = "Delivery Buddy",
		stage = 1,
		target_value1 = 3,
		group = 202,
		show_type = 1,
		desc = "Complete a Total of <color=#cd7900><b>$2</b></color> Transport Job(s)",
		id = 2021,
		target_num = 10,
		award = {
			{
				45,
				10411,
				1
			}
		},
		award_display = {
			{
				45,
				10411,
				1
			}
		}
	}
	pg.base.island_achievement[2022] = {
		target_type = 4,
		name = "Delivery Buddy",
		stage = 2,
		target_value1 = 3,
		group = 202,
		show_type = 1,
		desc = "Complete a Total of <color=#cd7900><b>$2</b></color> Transport Job(s)",
		id = 2022,
		target_num = 50,
		award = {
			{
				41,
				1,
				15000
			}
		},
		award_display = {
			{
				41,
				1,
				15000
			}
		}
	}
	pg.base.island_achievement[2023] = {
		target_type = 4,
		name = "Delivery Buddy",
		stage = 3,
		target_value1 = 3,
		group = 202,
		show_type = 1,
		desc = "Complete a Total of <color=#cd7900><b>$2</b></color> Transport Job(s)",
		id = 2023,
		target_num = 180,
		award = {
			{
				41,
				100002,
				10
			}
		},
		award_display = {
			{
				41,
				100002,
				10
			}
		}
	}
	pg.base.island_achievement[2024] = {
		target_type = 4,
		name = "Delivery Buddy",
		stage = 4,
		target_value1 = 3,
		group = 202,
		show_type = 1,
		desc = "Complete a Total of <color=#cd7900><b>$2</b></color> Transport Job(s)",
		id = 2024,
		target_num = 350,
		award = {
			{
				1,
				14,
				20
			}
		},
		award_display = {
			{
				1,
				14,
				20
			}
		}
	}
	pg.base.island_achievement[2025] = {
		target_type = 4,
		name = "Delivery Buddy",
		stage = 5,
		target_value1 = 3,
		group = 202,
		show_type = 1,
		desc = "Complete a Total of <color=#cd7900><b>$2</b></color> Transport Job(s)",
		id = 2025,
		target_num = 750,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[2026] = {
		target_type = 4,
		name = "Delivery Buddy",
		stage = 6,
		target_value1 = 3,
		group = 202,
		show_type = 1,
		desc = "Complete a Total of <color=#cd7900><b>$2</b></color> Transport Job(s)",
		id = 2026,
		target_num = 1000,
		award = {
			{
				1,
				14,
				40
			}
		},
		award_display = {
			{
				1,
				14,
				40
			}
		}
	}
	pg.base.island_achievement[2031] = {
		target_type = 17,
		name = "I Guess It's Technically Free?",
		stage = 1,
		target_value1 = 1,
		group = 203,
		show_type = 1,
		desc = "Spend <color=#cd7900><b>$2</b></color> Development Funds in the Shop",
		id = 2031,
		target_num = 100000,
		award = {
			{
				45,
				10410,
				1
			}
		},
		award_display = {
			{
				45,
				10410,
				1
			}
		}
	}
	pg.base.island_achievement[2032] = {
		target_type = 17,
		name = "I Guess It's Technically Free?",
		stage = 2,
		target_value1 = 1,
		group = 203,
		show_type = 1,
		desc = "Spend <color=#cd7900><b>$2</b></color> Development Funds in the Shop",
		id = 2032,
		target_num = 500000,
		award = {
			{
				41,
				1,
				15000
			}
		},
		award_display = {
			{
				41,
				1,
				15000
			}
		}
	}
	pg.base.island_achievement[2033] = {
		target_type = 17,
		name = "I Guess It's Technically Free?",
		stage = 3,
		target_value1 = 1,
		group = 203,
		show_type = 1,
		desc = "Spend <color=#cd7900><b>$2</b></color> Development Funds in the Shop",
		id = 2033,
		target_num = 2500000,
		award = {
			{
				41,
				100002,
				10
			}
		},
		award_display = {
			{
				41,
				100002,
				10
			}
		}
	}
	pg.base.island_achievement[2034] = {
		target_type = 17,
		name = "I Guess It's Technically Free?",
		stage = 4,
		target_value1 = 1,
		group = 203,
		show_type = 1,
		desc = "Spend <color=#cd7900><b>$2</b></color> Development Funds in the Shop",
		id = 2034,
		target_num = 5000000,
		award = {
			{
				1,
				14,
				20
			}
		},
		award_display = {
			{
				1,
				14,
				20
			}
		}
	}
	pg.base.island_achievement[2035] = {
		target_type = 17,
		name = "I Guess It's Technically Free?",
		stage = 5,
		target_value1 = 1,
		group = 203,
		show_type = 1,
		desc = "Spend <color=#cd7900><b>$2</b></color> Development Funds in the Shop",
		id = 2035,
		target_num = 10000000,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[2036] = {
		target_type = 17,
		name = "I Guess It's Technically Free?",
		stage = 6,
		target_value1 = 1,
		group = 203,
		show_type = 1,
		desc = "Spend <color=#cd7900><b>$2</b></color> Development Funds in the Shop",
		id = 2036,
		target_num = 25000000,
		award = {
			{
				1,
				14,
				40
			}
		},
		award_display = {
			{
				1,
				14,
				40
			}
		}
	}
	pg.base.island_achievement[2041] = {
		target_type = 31,
		name = "Pop-Up Shop Props",
		stage = 1,
		target_value1 = 0,
		group = 204,
		show_type = 1,
		desc = "Manage the Island's Shops <color=#cd7900><b>$2</b></color> Time(s)",
		id = 2041,
		target_num = 100,
		award = {
			{
				45,
				10409,
				1
			}
		},
		award_display = {
			{
				45,
				10409,
				1
			}
		}
	}
	pg.base.island_achievement[2042] = {
		target_type = 31,
		name = "Pop-Up Shop Props",
		stage = 2,
		target_value1 = 0,
		group = 204,
		show_type = 1,
		desc = "Manage the Island's Shops <color=#cd7900><b>$2</b></color> Time(s)",
		id = 2042,
		target_num = 200,
		award = {
			{
				41,
				1,
				15000
			}
		},
		award_display = {
			{
				41,
				1,
				15000
			}
		}
	}
	pg.base.island_achievement[2043] = {
		target_type = 31,
		name = "Pop-Up Shop Props",
		stage = 3,
		target_value1 = 0,
		group = 204,
		show_type = 1,
		desc = "Manage the Island's Shops <color=#cd7900><b>$2</b></color> Time(s)",
		id = 2043,
		target_num = 400,
		award = {
			{
				41,
				100002,
				10
			}
		},
		award_display = {
			{
				41,
				100002,
				10
			}
		}
	}
	pg.base.island_achievement[2044] = {
		target_type = 31,
		name = "Pop-Up Shop Props",
		stage = 4,
		target_value1 = 0,
		group = 204,
		show_type = 1,
		desc = "Manage the Island's Shops <color=#cd7900><b>$2</b></color> Time(s)",
		id = 2044,
		target_num = 720,
		award = {
			{
				1,
				14,
				20
			}
		},
		award_display = {
			{
				1,
				14,
				20
			}
		}
	}
	pg.base.island_achievement[2045] = {
		target_type = 31,
		name = "Pop-Up Shop Props",
		stage = 5,
		target_value1 = 0,
		group = 204,
		show_type = 1,
		desc = "Manage the Island's Shops <color=#cd7900><b>$2</b></color> Time(s)",
		id = 2045,
		target_num = 1200,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[2046] = {
		target_type = 31,
		name = "Pop-Up Shop Props",
		stage = 6,
		target_value1 = 0,
		group = 204,
		show_type = 1,
		desc = "Manage the Island's Shops <color=#cd7900><b>$2</b></color> Time(s)",
		id = 2046,
		target_num = 2000,
		award = {
			{
				1,
				14,
				40
			}
		},
		award_display = {
			{
				1,
				14,
				40
			}
		}
	}
	pg.base.island_achievement[2051] = {
		target_type = 38,
		name = "Livin' the Premium Life",
		stage = 1,
		target_value1 = 0,
		group = 205,
		show_type = 1,
		desc = "Play the Stellar Prize Draw <color=#cd7900><b>$2</b></color> Time(s)",
		id = 2051,
		target_num = 30,
		award = {
			{
				45,
				9,
				3
			}
		},
		award_display = {
			{
				45,
				9,
				3
			}
		}
	}
	pg.base.island_achievement[2052] = {
		target_type = 38,
		name = "Livin' the Premium Life",
		stage = 2,
		target_value1 = 0,
		group = 205,
		show_type = 1,
		desc = "Play the Stellar Prize Draw <color=#cd7900><b>$2</b></color> Time(s)",
		id = 2052,
		target_num = 80,
		award = {
			{
				41,
				1,
				15000
			}
		},
		award_display = {
			{
				41,
				1,
				15000
			}
		}
	}
	pg.base.island_achievement[2053] = {
		target_type = 38,
		name = "Livin' the Premium Life",
		stage = 3,
		target_value1 = 0,
		group = 205,
		show_type = 1,
		desc = "Play the Stellar Prize Draw <color=#cd7900><b>$2</b></color> Time(s)",
		id = 2053,
		target_num = 150,
		award = {
			{
				41,
				100002,
				10
			}
		},
		award_display = {
			{
				41,
				100002,
				10
			}
		}
	}
	pg.base.island_achievement[2054] = {
		target_type = 38,
		name = "Livin' the Premium Life",
		stage = 4,
		target_value1 = 0,
		group = 205,
		show_type = 1,
		desc = "Play the Stellar Prize Draw <color=#cd7900><b>$2</b></color> Time(s)",
		id = 2054,
		target_num = 300,
		award = {
			{
				1,
				14,
				20
			}
		},
		award_display = {
			{
				1,
				14,
				20
			}
		}
	}
	pg.base.island_achievement[2055] = {
		target_type = 38,
		name = "Livin' the Premium Life",
		stage = 5,
		target_value1 = 0,
		group = 205,
		show_type = 1,
		desc = "Play the Stellar Prize Draw <color=#cd7900><b>$2</b></color> Time(s)",
		id = 2055,
		target_num = 600,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[2056] = {
		target_type = 38,
		name = "Livin' the Premium Life",
		stage = 6,
		target_value1 = 0,
		group = 205,
		show_type = 1,
		desc = "Play the Stellar Prize Draw <color=#cd7900><b>$2</b></color> Time(s)",
		id = 2056,
		target_num = 900,
		award = {
			{
				1,
				14,
				40
			}
		},
		award_display = {
			{
				1,
				14,
				40
			}
		}
	}
	pg.base.island_achievement[3011] = {
		target_type = 5,
		name = "Living Large on the Island",
		stage = 1,
		target_value1 = 50,
		group = 301,
		show_type = 1,
		desc = "Raise <color=#cd7900><b>$2</b></color> Character(s) to Level 50",
		id = 3011,
		target_num = 1,
		award = {
			{
				45,
				10413,
				1
			}
		},
		award_display = {
			{
				45,
				10413,
				1
			}
		}
	}
	pg.base.island_achievement[3012] = {
		target_type = 5,
		name = "Living Large on the Island",
		stage = 2,
		target_value1 = 50,
		group = 301,
		show_type = 1,
		desc = "Raise <color=#cd7900><b>$2</b></color> Character(s) to Level 50",
		id = 3012,
		target_num = 3,
		award = {
			{
				41,
				1,
				10000
			}
		},
		award_display = {
			{
				41,
				1,
				10000
			}
		}
	}
	pg.base.island_achievement[3013] = {
		target_type = 5,
		name = "Living Large on the Island",
		stage = 3,
		target_value1 = 50,
		group = 301,
		show_type = 1,
		desc = "Raise <color=#cd7900><b>$2</b></color> Character(s) to Level 50",
		id = 3013,
		target_num = 5,
		award = {
			{
				41,
				100002,
				5
			}
		},
		award_display = {
			{
				41,
				100002,
				5
			}
		}
	}
	pg.base.island_achievement[3014] = {
		target_type = 5,
		name = "Living Large on the Island",
		stage = 4,
		target_value1 = 50,
		group = 301,
		show_type = 1,
		desc = "Raise <color=#cd7900><b>$2</b></color> Character(s) to Level 50",
		id = 3014,
		target_num = 7,
		award = {
			{
				1,
				14,
				10
			}
		},
		award_display = {
			{
				1,
				14,
				10
			}
		}
	}
	pg.base.island_achievement[3015] = {
		target_type = 5,
		name = "Living Large on the Island",
		stage = 5,
		target_value1 = 50,
		group = 301,
		show_type = 1,
		desc = "Raise <color=#cd7900><b>$2</b></color> Character(s) to Level 50",
		id = 3015,
		target_num = 10,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[3016] = {
		target_type = 5,
		name = "Living Large on the Island",
		stage = 6,
		target_value1 = 50,
		group = 301,
		show_type = 1,
		desc = "Raise <color=#cd7900><b>$2</b></color> Character(s) to Level 50",
		id = 3016,
		target_num = 15,
		award = {
			{
				1,
				14,
				30
			}
		},
		award_display = {
			{
				1,
				14,
				30
			}
		}
	}
	pg.base.island_achievement[3021] = {
		target_type = 6,
		name = "Efficiency is Key!",
		stage = 1,
		target_value1 = 10,
		group = 302,
		show_type = 1,
		desc = "Raise <color=#cd7900><b>$2</b></color> Character Skills to Level 10",
		id = 3021,
		target_num = 1,
		award = {
			{
				45,
				10412,
				1
			}
		},
		award_display = {
			{
				45,
				10412,
				1
			}
		}
	}
	pg.base.island_achievement[3022] = {
		target_type = 6,
		name = "Efficiency is Key!",
		stage = 2,
		target_value1 = 10,
		group = 302,
		show_type = 1,
		desc = "Raise <color=#cd7900><b>$2</b></color> Character Skills to Level 10",
		id = 3022,
		target_num = 2,
		award = {
			{
				41,
				1,
				10000
			}
		},
		award_display = {
			{
				41,
				1,
				10000
			}
		}
	}
	pg.base.island_achievement[3023] = {
		target_type = 6,
		name = "Efficiency is Key!",
		stage = 3,
		target_value1 = 10,
		group = 302,
		show_type = 1,
		desc = "Raise <color=#cd7900><b>$2</b></color> Character Skills to Level 10",
		id = 3023,
		target_num = 4,
		award = {
			{
				41,
				100002,
				5
			}
		},
		award_display = {
			{
				41,
				100002,
				5
			}
		}
	}
	pg.base.island_achievement[3024] = {
		target_type = 6,
		name = "Efficiency is Key!",
		stage = 4,
		target_value1 = 10,
		group = 302,
		show_type = 1,
		desc = "Raise <color=#cd7900><b>$2</b></color> Character Skills to Level 10",
		id = 3024,
		target_num = 6,
		award = {
			{
				1,
				14,
				10
			}
		},
		award_display = {
			{
				1,
				14,
				10
			}
		}
	}
	pg.base.island_achievement[3025] = {
		target_type = 6,
		name = "Efficiency is Key!",
		stage = 5,
		target_value1 = 10,
		group = 302,
		show_type = 1,
		desc = "Raise <color=#cd7900><b>$2</b></color> Character Skills to Level 10",
		id = 3025,
		target_num = 8,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[3026] = {
		target_type = 6,
		name = "Efficiency is Key!",
		stage = 6,
		target_value1 = 10,
		group = 302,
		show_type = 1,
		desc = "Raise <color=#cd7900><b>$2</b></color> Character Skills to Level 10",
		id = 3026,
		target_num = 10,
		award = {
			{
				1,
				14,
				30
			}
		},
		award_display = {
			{
				1,
				14,
				30
			}
		}
	}
	pg.base.island_achievement[3031] = {
		target_type = 32,
		name = "Best Friends",
		stage = 1,
		target_value1 = 0,
		group = 303,
		show_type = 1,
		desc = "Interact with Characters <color=#cd7900><b>$2</b></color> Time(s)",
		id = 3031,
		target_num = 10,
		award = {
			{
				45,
				10416,
				1
			}
		},
		award_display = {
			{
				45,
				10416,
				1
			}
		}
	}
	pg.base.island_achievement[3032] = {
		target_type = 32,
		name = "Best Friends",
		stage = 2,
		target_value1 = 0,
		group = 303,
		show_type = 1,
		desc = "Interact with Characters <color=#cd7900><b>$2</b></color> Time(s)",
		id = 3032,
		target_num = 20,
		award = {
			{
				41,
				1,
				10000
			}
		},
		award_display = {
			{
				41,
				1,
				10000
			}
		}
	}
	pg.base.island_achievement[3033] = {
		target_type = 32,
		name = "Best Friends",
		stage = 3,
		target_value1 = 0,
		group = 303,
		show_type = 1,
		desc = "Interact with Characters <color=#cd7900><b>$2</b></color> Time(s)",
		id = 3033,
		target_num = 50,
		award = {
			{
				41,
				100002,
				5
			}
		},
		award_display = {
			{
				41,
				100002,
				5
			}
		}
	}
	pg.base.island_achievement[3034] = {
		target_type = 32,
		name = "Best Friends",
		stage = 4,
		target_value1 = 0,
		group = 303,
		show_type = 1,
		desc = "Interact with Characters <color=#cd7900><b>$2</b></color> Time(s)",
		id = 3034,
		target_num = 100,
		award = {
			{
				1,
				14,
				10
			}
		},
		award_display = {
			{
				1,
				14,
				10
			}
		}
	}
	pg.base.island_achievement[3035] = {
		target_type = 32,
		name = "Best Friends",
		stage = 5,
		target_value1 = 0,
		group = 303,
		show_type = 1,
		desc = "Interact with Characters <color=#cd7900><b>$2</b></color> Time(s)",
		id = 3035,
		target_num = 150,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[3036] = {
		target_type = 32,
		name = "Best Friends",
		stage = 6,
		target_value1 = 0,
		group = 303,
		show_type = 1,
		desc = "Interact with Characters <color=#cd7900><b>$2</b></color> Time(s)",
		id = 3036,
		target_num = 300,
		award = {
			{
				1,
				14,
				30
			}
		},
		award_display = {
			{
				1,
				14,
				30
			}
		}
	}
	pg.base.island_achievement[3041] = {
		target_type = 23,
		name = "It's Basically Telepathy",
		stage = 1,
		target_value1 = 0,
		group = 304,
		show_type = 1,
		desc = "Give Gifts to Characters <color=#cd7900><b>$2</b></color> Time(s)",
		id = 3041,
		target_num = 10,
		award = {
			{
				45,
				10420,
				1
			}
		},
		award_display = {
			{
				45,
				10420,
				1
			}
		}
	}
	pg.base.island_achievement[3042] = {
		target_type = 23,
		name = "It's Basically Telepathy",
		stage = 2,
		target_value1 = 0,
		group = 304,
		show_type = 1,
		desc = "Give Gifts to Characters <color=#cd7900><b>$2</b></color> Time(s)",
		id = 3042,
		target_num = 20,
		award = {
			{
				41,
				1,
				10000
			}
		},
		award_display = {
			{
				41,
				1,
				10000
			}
		}
	}
	pg.base.island_achievement[3043] = {
		target_type = 23,
		name = "It's Basically Telepathy",
		stage = 3,
		target_value1 = 0,
		group = 304,
		show_type = 1,
		desc = "Give Gifts to Characters <color=#cd7900><b>$2</b></color> Time(s)",
		id = 3043,
		target_num = 30,
		award = {
			{
				41,
				100002,
				5
			}
		},
		award_display = {
			{
				41,
				100002,
				5
			}
		}
	}
	pg.base.island_achievement[3044] = {
		target_type = 23,
		name = "It's Basically Telepathy",
		stage = 4,
		target_value1 = 0,
		group = 304,
		show_type = 1,
		desc = "Give Gifts to Characters <color=#cd7900><b>$2</b></color> Time(s)",
		id = 3044,
		target_num = 40,
		award = {
			{
				1,
				14,
				10
			}
		},
		award_display = {
			{
				1,
				14,
				10
			}
		}
	}
	pg.base.island_achievement[3045] = {
		target_type = 23,
		name = "It's Basically Telepathy",
		stage = 5,
		target_value1 = 0,
		group = 304,
		show_type = 1,
		desc = "Give Gifts to Characters <color=#cd7900><b>$2</b></color> Time(s)",
		id = 3045,
		target_num = 50,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[3046] = {
		target_type = 23,
		name = "It's Basically Telepathy",
		stage = 6,
		target_value1 = 0,
		group = 304,
		show_type = 1,
		desc = "Give Gifts to Characters <color=#cd7900><b>$2</b></color> Time(s)",
		id = 3046,
		target_num = 60,
		award = {
			{
				1,
				14,
				30
			}
		},
		award_display = {
			{
				1,
				14,
				30
			}
		}
	}
	pg.base.island_achievement[3051] = {
		target_type = 14,
		name = "Fashion Advisor",
		stage = 1,
		target_value1 = 0,
		group = 305,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Character Outfit(s) - Costume",
		id = 3051,
		target_num = 1,
		award = {
			{
				45,
				10415,
				1
			}
		},
		award_display = {
			{
				45,
				10415,
				1
			}
		}
	}
	pg.base.island_achievement[3052] = {
		target_type = 14,
		name = "Fashion Advisor",
		stage = 2,
		target_value1 = 0,
		group = 305,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Character Outfit(s) - Costume",
		id = 3052,
		target_num = 3,
		award = {
			{
				41,
				1,
				10000
			}
		},
		award_display = {
			{
				41,
				1,
				10000
			}
		}
	}
	pg.base.island_achievement[3053] = {
		target_type = 14,
		name = "Fashion Advisor",
		stage = 3,
		target_value1 = 0,
		group = 305,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Character Outfit(s) - Costume",
		id = 3053,
		target_num = 5,
		award = {
			{
				41,
				100002,
				5
			}
		},
		award_display = {
			{
				41,
				100002,
				5
			}
		}
	}
	pg.base.island_achievement[3054] = {
		target_type = 14,
		name = "Fashion Advisor",
		stage = 4,
		target_value1 = 0,
		group = 305,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Character Outfit(s) - Costume",
		id = 3054,
		target_num = 10,
		award = {
			{
				1,
				14,
				10
			}
		},
		award_display = {
			{
				1,
				14,
				10
			}
		}
	}
	pg.base.island_achievement[3055] = {
		target_type = 14,
		name = "Fashion Advisor",
		stage = 5,
		target_value1 = 0,
		group = 305,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Character Outfit(s) - Costume",
		id = 3055,
		target_num = 15,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[3056] = {
		target_type = 14,
		name = "Fashion Advisor",
		stage = 6,
		target_value1 = 0,
		group = 305,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Character Outfit(s) - Costume",
		id = 3056,
		target_num = 25,
		award = {
			{
				1,
				14,
				30
			}
		},
		award_display = {
			{
				1,
				14,
				30
			}
		}
	}
	pg.base.island_achievement[3061] = {
		target_type = 15,
		name = "You Are Your Own Wings",
		stage = 1,
		target_value1 = 1,
		group = 306,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Character Outfit(s) - Back",
		id = 3061,
		target_num = 1,
		award = {
			{
				45,
				10413,
				1
			}
		},
		award_display = {
			{
				45,
				10413,
				1
			}
		}
	}
	pg.base.island_achievement[3062] = {
		target_type = 15,
		name = "You Are Your Own Wings",
		stage = 2,
		target_value1 = 1,
		group = 306,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Character Outfit(s) - Back",
		id = 3062,
		target_num = 2,
		award = {
			{
				41,
				1,
				10000
			}
		},
		award_display = {
			{
				41,
				1,
				10000
			}
		}
	}
	pg.base.island_achievement[3063] = {
		target_type = 15,
		name = "You Are Your Own Wings",
		stage = 3,
		target_value1 = 1,
		group = 306,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Character Outfit(s) - Back",
		id = 3063,
		target_num = 4,
		award = {
			{
				41,
				100002,
				5
			}
		},
		award_display = {
			{
				41,
				100002,
				5
			}
		}
	}
	pg.base.island_achievement[3064] = {
		target_type = 15,
		name = "You Are Your Own Wings",
		stage = 4,
		target_value1 = 1,
		group = 306,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Character Outfit(s) - Back",
		id = 3064,
		target_num = 8,
		award = {
			{
				1,
				14,
				10
			}
		},
		award_display = {
			{
				1,
				14,
				10
			}
		}
	}
	pg.base.island_achievement[3065] = {
		target_type = 15,
		name = "You Are Your Own Wings",
		stage = 5,
		target_value1 = 1,
		group = 306,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Character Outfit(s) - Back",
		id = 3065,
		target_num = 10,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[3066] = {
		target_type = 15,
		name = "You Are Your Own Wings",
		stage = 6,
		target_value1 = 1,
		group = 306,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Character Outfit(s) - Back",
		id = 3066,
		target_num = 15,
		award = {
			{
				1,
				14,
				30
			}
		},
		award_display = {
			{
				1,
				14,
				30
			}
		}
	}
	pg.base.island_achievement[3071] = {
		target_type = 15,
		name = "Aesthetic of Floating Things",
		stage = 1,
		target_value1 = 2,
		group = 307,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Character Outfit(s) - Floating",
		id = 3071,
		target_num = 1,
		award = {
			{
				45,
				10414,
				1
			}
		},
		award_display = {
			{
				45,
				10414,
				1
			}
		}
	}
	pg.base.island_achievement[3072] = {
		target_type = 15,
		name = "Aesthetic of Floating Things",
		stage = 2,
		target_value1 = 2,
		group = 307,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Character Outfit(s) - Floating",
		id = 3072,
		target_num = 2,
		award = {
			{
				41,
				1,
				10000
			}
		},
		award_display = {
			{
				41,
				1,
				10000
			}
		}
	}
	pg.base.island_achievement[3073] = {
		target_type = 15,
		name = "Aesthetic of Floating Things",
		stage = 3,
		target_value1 = 2,
		group = 307,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Character Outfit(s) - Floating",
		id = 3073,
		target_num = 4,
		award = {
			{
				41,
				100002,
				5
			}
		},
		award_display = {
			{
				41,
				100002,
				5
			}
		}
	}
	pg.base.island_achievement[3074] = {
		target_type = 15,
		name = "Aesthetic of Floating Things",
		stage = 4,
		target_value1 = 2,
		group = 307,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Character Outfit(s) - Floating",
		id = 3074,
		target_num = 8,
		award = {
			{
				1,
				14,
				10
			}
		},
		award_display = {
			{
				1,
				14,
				10
			}
		}
	}
	pg.base.island_achievement[3075] = {
		target_type = 15,
		name = "Aesthetic of Floating Things",
		stage = 5,
		target_value1 = 2,
		group = 307,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Character Outfit(s) - Floating",
		id = 3075,
		target_num = 10,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[3076] = {
		target_type = 15,
		name = "Aesthetic of Floating Things",
		stage = 6,
		target_value1 = 2,
		group = 307,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Character Outfit(s) - Floating",
		id = 3076,
		target_num = 15,
		award = {
			{
				1,
				14,
				30
			}
		},
		award_display = {
			{
				1,
				14,
				30
			}
		}
	}
	pg.base.island_achievement[3081] = {
		target_type = 15,
		name = "One Small Step for Chibikind",
		stage = 1,
		target_value1 = 3,
		group = 308,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Character Outfit(s) - Trail",
		id = 3081,
		target_num = 1,
		award = {
			{
				45,
				10411,
				1
			}
		},
		award_display = {
			{
				45,
				10411,
				1
			}
		}
	}
	pg.base.island_achievement[3082] = {
		target_type = 15,
		name = "One Small Step for Chibikind",
		stage = 2,
		target_value1 = 3,
		group = 308,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Character Outfit(s) - Trail",
		id = 3082,
		target_num = 2,
		award = {
			{
				41,
				1,
				10000
			}
		},
		award_display = {
			{
				41,
				1,
				10000
			}
		}
	}
	pg.base.island_achievement[3083] = {
		target_type = 15,
		name = "One Small Step for Chibikind",
		stage = 3,
		target_value1 = 3,
		group = 308,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Character Outfit(s) - Trail",
		id = 3083,
		target_num = 4,
		award = {
			{
				41,
				100002,
				5
			}
		},
		award_display = {
			{
				41,
				100002,
				5
			}
		}
	}
	pg.base.island_achievement[3084] = {
		target_type = 15,
		name = "One Small Step for Chibikind",
		stage = 4,
		target_value1 = 3,
		group = 308,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Character Outfit(s) - Trail",
		id = 3084,
		target_num = 8,
		award = {
			{
				1,
				14,
				10
			}
		},
		award_display = {
			{
				1,
				14,
				10
			}
		}
	}
	pg.base.island_achievement[3085] = {
		target_type = 15,
		name = "One Small Step for Chibikind",
		stage = 5,
		target_value1 = 3,
		group = 308,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Character Outfit(s) - Trail",
		id = 3085,
		target_num = 10,
		award = {
			{
				41,
				100201,
				1
			}
		},
		award_display = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_achievement[3086] = {
		target_type = 15,
		name = "One Small Step for Chibikind",
		stage = 6,
		target_value1 = 3,
		group = 308,
		show_type = 1,
		desc = "Acquire <color=#cd7900><b>$2</b></color> Character Outfit(s) - Trail",
		id = 3086,
		target_num = 15,
		award = {
			{
				1,
				14,
				30
			}
		},
		award_display = {
			{
				1,
				14,
				30
			}
		}
	}
end)()
