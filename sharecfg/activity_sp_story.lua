pg = pg or {}
pg.activity_sp_story = {
	{
		story_type = 1,
		pre_event = "",
		name = "EPS-1 A Musician's Dream",
		unlock_conditions = "",
		change_prefab = "",
		change_background = "star_level_bg_546",
		story = "HUANMENGJIANZOUQU1",
		change_bgm = "story-richang-light",
		id = 1,
		lock = ""
	},
	{
		story_type = 1,
		name = "EPS-2A Formal Invitation",
		unlock_conditions = "Unlocked by reading the previous story chapter.",
		change_bgm = "story-richang-light",
		change_prefab = "",
		change_background = "star_level_bg_546",
		id = 2,
		story = "HUANMENGJIANZOUQU2",
		pre_event = {
			1
		},
		lock = {
			{
				4,
				1
			}
		}
	},
	{
		story_type = 1,
		name = "EPS-3 A Casual Meal",
		unlock_conditions = "Unlocked by reading the previous story chapter.",
		change_bgm = "level-french1",
		change_prefab = "",
		change_background = "bg_story_shengmixieer_1",
		id = 3,
		story = "HUANMENGJIANZOUQU3",
		pre_event = {
			2
		},
		lock = {
			{
				4,
				2
			}
		}
	},
	{
		story_type = 2,
		name = "EPS-4 Peace Interlude",
		unlock_conditions = "Unlocked by reading the previous story chapter.",
		change_bgm = "story-richang-light",
		change_prefab = "",
		change_background = "bg_story_shengmixieer_1",
		id = 4,
		story = "1826001",
		pre_event = {
			3
		},
		lock = {
			{
				4,
				3
			}
		}
	},
	{
		story_type = 1,
		name = "EPS-5 Face to Face",
		unlock_conditions = "Unlocked by reading the previous story chapter.",
		change_bgm = "story-richang-sooth",
		change_prefab = "",
		change_background = "bg_story_shengmixieer_2",
		id = 5,
		story = "HUANMENGJIANZOUQU5",
		pre_event = {
			4
		},
		lock = {
			{
				4,
				4
			}
		}
	},
	{
		story_type = 1,
		name = "EPS-6 Music in the Night",
		unlock_conditions = "Unlocked by reading the previous story chapter.",
		change_bgm = "story-richang-sooth",
		change_prefab = "",
		change_background = "bg_story_shengmixieer_2",
		id = 6,
		story = "HUANMENGJIANZOUQU6",
		pre_event = {
			5
		},
		lock = {
			{
				4,
				5
			}
		}
	},
	{
		story_type = 1,
		name = "EPS-7 The Secret of the Basilica",
		unlock_conditions = "Unlocked by reading the previous story chapter.",
		change_bgm = "theme-vichy-church",
		change_prefab = "",
		change_background = "bg_story_shengmixieer_2",
		id = 7,
		story = "HUANMENGJIANZOUQU7",
		pre_event = {
			6
		},
		lock = {
			{
				4,
				6
			}
		}
	},
	{
		story_type = 1,
		name = "EPS-8 The Dream of HER",
		unlock_conditions = "Unlocked by reading the previous story chapter.",
		change_bgm = "story-richang-light",
		change_prefab = "",
		change_background = "bg_story_shengmixieer_1",
		id = 8,
		story = "HUANMENGJIANZOUQU8",
		pre_event = {
			7
		},
		lock = {
			{
				4,
				7
			}
		}
	},
	{
		story_type = 1,
		name = "EPS-9 A Fine Day",
		unlock_conditions = "Unlocked by reading the previous story chapter.",
		change_bgm = "story-richang-light",
		change_prefab = "",
		change_background = "bg_story_shengmixieer_1",
		id = 9,
		story = "HUANMENGJIANZOUQU9",
		pre_event = {
			8
		},
		lock = {
			{
				4,
				8
			}
		}
	},
	{
		story_type = 1,
		name = "EPS-10 Another Fine Day",
		unlock_conditions = "Unlocked by reading the previous story chapter.",
		change_bgm = "story-richang-light",
		change_prefab = "",
		change_background = "bg_story_shengmixieer_1",
		id = 10,
		story = "HUANMENGJIANZOUQU10",
		pre_event = {
			9
		},
		lock = {
			{
				4,
				9
			}
		}
	},
	{
		story_type = 1,
		pre_event = "",
		name = "EPS-1 The Guardian Fox's Departure",
		unlock_conditions = "",
		change_prefab = "",
		change_background = "star_level_bg_531",
		story = "MAIZANGYUBIANZHIHUA1",
		change_bgm = "map-longgong",
		id = 11,
		lock = ""
	},
	{
		story_type = 1,
		name = "EPS-2 Trailing the Mountains",
		unlock_conditions = "Clear EPS-1.",
		change_bgm = "story-richang-light",
		change_prefab = "",
		change_background = "star_level_bg_532",
		id = 12,
		story = "MAIZANGYUBIANZHIHUA2",
		pre_event = {
			11
		},
		lock = {
			{
				4,
				11
			}
		}
	},
	{
		story_type = 1,
		name = "EPS-3 The Prime Barrier",
		unlock_conditions = "Clear EPS-2.",
		change_bgm = "story-4",
		change_prefab = "",
		change_background = "bg_story_tiancheng6",
		id = 13,
		story = "MAIZANGYUBIANZHIHUA3",
		pre_event = {
			12
		},
		lock = {
			{
				4,
				12
			}
		}
	},
	{
		story_type = 1,
		name = "EPS-4 Ink-Stained Dream",
		unlock_conditions = "Clear EPS-3.",
		change_bgm = "musashi-2",
		change_prefab = "",
		change_background = "star_level_bg_508",
		id = 14,
		story = "MAIZANGYUBIANZHIHUA4",
		pre_event = {
			13
		},
		lock = {
			{
				4,
				13
			}
		}
	},
	{
		story_type = 1,
		name = "EPS-5 Misfortune Arriveth",
		unlock_conditions = "Clear EPS-4.",
		change_bgm = "nagato-boss",
		change_prefab = "",
		change_background = "star_level_bg_504",
		id = 15,
		story = "MAIZANGYUBIANZHIHUA5",
		pre_event = {
			14
		},
		lock = {
			{
				4,
				14
			}
		}
	},
	{
		story_type = 1,
		name = "EPS-6 Obsession Rooted in the Past",
		unlock_conditions = "Clear EPS-5.",
		change_bgm = "musashi-2",
		change_prefab = "",
		change_background = "star_level_bg_510",
		id = 16,
		story = "MAIZANGYUBIANZHIHUA6",
		pre_event = {
			15
		},
		lock = {
			{
				4,
				15
			}
		}
	},
	{
		story_type = 1,
		name = "EPS-7 Planning Interference",
		unlock_conditions = "Clear EPS-6.",
		change_bgm = "story-nailuo-theme",
		change_prefab = "",
		change_background = "bg_bianzhihua_1",
		id = 17,
		story = "MAIZANGYUBIANZHIHUA7",
		pre_event = {
			16
		},
		lock = {
			{
				4,
				16
			}
		}
	},
	{
		story_type = 1,
		name = "EPS-8 Decisive Weapon",
		unlock_conditions = "Clear EPS-7.",
		change_bgm = "story-nailuo-theme",
		change_prefab = "",
		change_background = "bg_bianzhihua_1",
		id = 18,
		story = "MAIZANGYUBIANZHIHUA8",
		pre_event = {
			17
		},
		lock = {
			{
				4,
				17
			}
		}
	},
	{
		story_type = 1,
		name = "EPS-9 Retreat",
		unlock_conditions = "Clear EPS-8.",
		change_bgm = "story-nailuo-theme",
		change_prefab = "",
		change_background = "bg_bianzhihua_1",
		id = 19,
		story = "MAIZANGYUBIANZHIHUA9",
		pre_event = {
			17
		},
		lock = {
			{
				4,
				18
			}
		}
	},
	{
		story_type = 1,
		name = "EPS-10 Scattering Thunder",
		unlock_conditions = "Clear EPS-9.",
		change_bgm = "story-nailuo-theme",
		change_prefab = "",
		change_background = "bg_bianzhihua_1",
		id = 20,
		story = "MAIZANGYUBIANZHIHUA10",
		pre_event = {
			19
		},
		lock = {
			{
				4,
				19
			}
		}
	},
	{
		story_type = 1,
		name = "EPS-11 Entrusted Will",
		unlock_conditions = "Clear EPS-10.",
		change_bgm = "story-nailuo-theme",
		change_prefab = "",
		change_background = "bg_bianzhihua_1",
		id = 21,
		story = "MAIZANGYUBIANZHIHUA11",
		pre_event = {
			18
		},
		lock = {
			{
				4,
				20
			}
		}
	},
	{
		story_type = 1,
		name = "EPS-12 Fallen Petals",
		unlock_conditions = "Clear EPS-11.",
		change_bgm = "story-nailuo-theme",
		change_prefab = "",
		change_background = "bg_bianzhihua_2",
		id = 22,
		story = "MAIZANGYUBIANZHIHUA12",
		pre_event = {
			21,
			20
		},
		lock = {
			{
				4,
				21
			}
		}
	},
	{
		story_type = 1,
		name = "EPS-13 Our Commander",
		unlock_conditions = "Clear EPS-12.",
		change_bgm = "story-nailuo-theme",
		change_prefab = "Map_1840002",
		change_background = "bg_bianzhihua_2",
		id = 23,
		story = "MAIZANGYUBIANZHIHUA13",
		pre_event = {
			22
		},
		lock = {
			{
				4,
				22
			}
		}
	},
	[31] = {
		story_type = 1,
		pre_event = "",
		name = "EP1-1 A Deal With Observer",
		unlock_conditions = "",
		change_prefab = "",
		change_background = "star_level_bg_504",
		story = "HUANXINGCANGHONGZHIYAN1",
		change_bgm = "battle-eagleunion",
		id = 31,
		lock = ""
	},
	[32] = {
		story_type = 1,
		name = "EP1-2 Tester's Destruction",
		unlock_conditions = "Clear EP1-1.",
		change_bgm = "battle-eagleunion",
		change_prefab = "",
		change_background = "star_level_bg_504",
		id = 32,
		story = "HUANXINGCANGHONGZHIYAN2",
		pre_event = {
			31
		},
		lock = {
			{
				4,
				31
			}
		}
	},
	[33] = {
		story_type = 1,
		name = "EP1-3 Omitter's Destruction",
		unlock_conditions = "Clear EP1-2.",
		change_bgm = "battle-eagleunion",
		change_prefab = "",
		change_background = "star_level_bg_504",
		id = 33,
		story = "HUANXINGCANGHONGZHIYAN3",
		pre_event = {
			31
		},
		lock = {
			{
				4,
				32
			}
		}
	},
	[34] = {
		story_type = 1,
		name = "EP1-4 Purifier's Destruction",
		unlock_conditions = "Clear EP1-3.",
		change_bgm = "story-commander-up",
		change_prefab = "",
		change_background = "bg_story_task",
		id = 34,
		story = "HUANXINGCANGHONGZHIYAN4",
		pre_event = {
			31
		},
		lock = {
			{
				4,
				33
			}
		}
	},
	[35] = {
		story_type = 1,
		name = "EP2-1 To the Singularity",
		unlock_conditions = "Clear EP1-4.",
		change_bgm = "bsm-2",
		change_prefab = "",
		change_background = "bg_port_chongdong",
		id = 35,
		story = "HUANXINGCANGHONGZHIYAN5",
		pre_event = {
			32,
			33,
			34
		},
		lock = {
			{
				4,
				34
			}
		}
	},
	[36] = {
		story_type = 1,
		name = "EP2-2 Making of a World Segment",
		unlock_conditions = "Clear EP2-1.",
		change_bgm = "battle-eagleunion",
		change_prefab = "",
		change_background = "star_level_bg_504",
		id = 36,
		story = "HUANXINGCANGHONGZHIYAN6",
		pre_event = {
			35
		},
		lock = {
			{
				4,
				35
			}
		}
	},
	[37] = {
		story_type = 1,
		name = "EP2-3 Departure",
		unlock_conditions = "Clear EP2-2.",
		change_bgm = "story-finalbattle-unity",
		change_prefab = "",
		change_background = "star_level_bg_507",
		id = 37,
		story = "HUANXINGCANGHONGZHIYAN7",
		pre_event = {
			36
		},
		lock = {
			{
				4,
				36
			}
		}
	},
	[38] = {
		story_type = 1,
		name = "EP3-1 Europa's Fight",
		unlock_conditions = "Clear EP2-3.",
		change_bgm = "story-newsakura",
		change_prefab = "",
		change_background = "bg_port_chuanwu1",
		id = 38,
		story = "HUANXINGCANGHONGZHIYAN8",
		pre_event = {
			37
		},
		lock = {
			{
				4,
				37
			}
		}
	},
	[39] = {
		story_type = 1,
		name = "EP3-2 The Floating Dock Returns",
		unlock_conditions = "Clear EP3-1.",
		change_bgm = "story-nailuo-theme",
		change_prefab = "",
		change_background = "bg_canghongzhiyan_1",
		id = 39,
		story = "HUANXINGCANGHONGZHIYAN9",
		pre_event = {
			38
		},
		lock = {
			{
				4,
				38
			}
		}
	},
	[40] = {
		story_type = 1,
		name = "EP4-1 Divergent METAmorphosis",
		unlock_conditions = "Clear EP3-2.",
		change_bgm = "story-nailuo-theme",
		change_prefab = "",
		change_background = "bg_canghongzhiyan_1",
		id = 40,
		story = "HUANXINGCANGHONGZHIYAN10",
		pre_event = {
			37
		},
		lock = {
			{
				4,
				39
			}
		}
	},
	[41] = {
		story_type = 2,
		name = "EP4-2 A Meeting in the Mist",
		unlock_conditions = "Clear EP4-1.",
		change_bgm = "story-nailuo-theme",
		change_prefab = "",
		change_background = "bg_canghongzhiyan_1",
		id = 41,
		story = "1856001",
		pre_event = {
			40
		},
		lock = {
			{
				4,
				40
			}
		}
	},
	[42] = {
		story_type = 1,
		name = "EP4-3 As Thanks",
		unlock_conditions = "Clear EP4-2.",
		change_bgm = "battle-nightmare-theme",
		change_prefab = "",
		change_background = "bg_bianzhihua_3",
		id = 42,
		story = "HUANXINGCANGHONGZHIYAN12",
		pre_event = {
			41
		},
		lock = {
			{
				4,
				41
			}
		}
	},
	[43] = {
		story_type = 1,
		name = "EPS-1 The Way Cleared",
		unlock_conditions = "Clear EP4-3.",
		change_bgm = "story-darkplan",
		change_prefab = "",
		change_background = "star_level_bg_499",
		id = 43,
		story = "HUANXINGCANGHONGZHIYAN13",
		pre_event = {
			39,
			42
		},
		lock = {
			{
				4,
				42
			}
		}
	},
	[44] = {
		story_type = 1,
		name = "EPS-2 Amagi's Dream",
		unlock_conditions = "Clear EPS-1.",
		change_bgm = "story-tiancheng",
		change_prefab = "",
		change_background = "bg_canghongzhiyan_2",
		id = 44,
		story = "HUANXINGCANGHONGZHIYAN14",
		pre_event = {
			43
		},
		lock = {
			{
				4,
				43
			}
		}
	},
	[45] = {
		story_type = 1,
		name = "EP5-1 Homecoming",
		unlock_conditions = "Clear EPS-2.",
		change_bgm = "story-tiancheng",
		change_prefab = "",
		change_background = "bg_canghongzhiyan_2",
		id = 45,
		story = "HUANXINGCANGHONGZHIYAN15",
		pre_event = {
			44
		},
		lock = {
			{
				4,
				44
			}
		}
	},
	[46] = {
		story_type = 1,
		name = "EP5-2 Reunion",
		unlock_conditions = "Clear EP5-1.",
		change_bgm = "theme-amagi-cv",
		change_prefab = "",
		change_background = "star_level_bg_111",
		id = 46,
		story = "HUANXINGCANGHONGZHIYAN16",
		pre_event = {
			45
		},
		lock = {
			{
				4,
				45
			}
		}
	},
	[47] = {
		story_type = 1,
		name = "EP5-3 Face to Face",
		unlock_conditions = "Clear EP5-2.",
		change_bgm = "theme-amagi-cv",
		change_prefab = "",
		change_background = "bg_canghongzhiyan_3",
		id = 47,
		story = "HUANXINGCANGHONGZHIYAN17",
		pre_event = {
			46
		},
		lock = {
			{
				4,
				46
			}
		}
	},
	[48] = {
		story_type = 2,
		name = "EP5-4 When Least Expected",
		unlock_conditions = "Clear EP5-3.",
		change_bgm = "story-nailuo-theme",
		change_prefab = "",
		change_background = "bg_canghongzhiyan_1",
		id = 48,
		story = "1856002",
		pre_event = {
			47
		},
		lock = {
			{
				4,
				47
			}
		}
	},
	[49] = {
		story_type = 1,
		name = "EP5-5 Fighting Back",
		unlock_conditions = "Clear EP6-3.",
		change_bgm = "theme-nagato-meta",
		change_prefab = "",
		change_background = "star_level_bg_192",
		id = 49,
		story = "HUANXINGCANGHONGZHIYAN19",
		pre_event = {
			48
		},
		lock = {
			{
				4,
				53
			}
		}
	},
	[50] = {
		story_type = 1,
		name = "EP5-6 Turning the Tables",
		unlock_conditions = "Clear EP5-5.",
		change_bgm = "theme-nagato-meta",
		change_prefab = "",
		change_background = "bg_canghongzhiyan_4",
		id = 50,
		story = "HUANXINGCANGHONGZHIYAN20",
		pre_event = {
			49
		},
		lock = {
			{
				4,
				49
			}
		}
	},
	[51] = {
		story_type = 1,
		name = "EP6-1 Scanning the Singularity",
		unlock_conditions = "Clear EP5-4.",
		change_bgm = "theme-amagi-cv",
		change_prefab = "",
		change_background = "bg_canghongzhiyan_1",
		id = 51,
		story = "HUANXINGCANGHONGZHIYAN21",
		pre_event = {
			44
		},
		lock = {
			{
				4,
				48
			}
		}
	},
	[52] = {
		story_type = 2,
		name = "EP6-2 Obsession's True Form",
		unlock_conditions = "Clear EP6-1.",
		change_bgm = "theme-amagi-cv",
		change_prefab = "",
		change_background = "bg_canghongzhiyan_1",
		id = 52,
		story = "1856003",
		pre_event = {
			51
		},
		lock = {
			{
				4,
				51
			}
		}
	},
	[53] = {
		story_type = 1,
		name = "EP6-3 Purification",
		unlock_conditions = "Clear EP6-2.",
		change_bgm = "theme-akagi-meta",
		change_prefab = "",
		change_background = "star_level_bg_191",
		id = 53,
		story = "HUANXINGCANGHONGZHIYAN23",
		pre_event = {
			52
		},
		lock = {
			{
				4,
				52
			}
		}
	},
	[54] = {
		story_type = 1,
		name = "EPS-3 Heart and Feelings",
		unlock_conditions = "Clear EP5-6.",
		change_bgm = "battle-unknown-approaching",
		change_prefab = "",
		change_background = "star_level_bg_504",
		id = 54,
		story = "HUANXINGCANGHONGZHIYAN24",
		pre_event = {
			50,
			53
		},
		lock = {
			{
				4,
				50
			}
		}
	},
	[55] = {
		story_type = 1,
		name = "EP7-1 Fragmented",
		unlock_conditions = "Clear EP8-1.",
		change_bgm = "story-amagi-up",
		change_prefab = "",
		change_background = "bg_canghongzhiyan_4",
		id = 55,
		story = "HUANXINGCANGHONGZHIYAN25",
		pre_event = {
			54
		},
		lock = {
			{
				4,
				59
			}
		}
	},
	[56] = {
		story_type = 2,
		name = "EP7-2 Seething Heart",
		unlock_conditions = "Clear EP7-1.",
		change_bgm = "theme-akagi-meta",
		change_prefab = "",
		change_background = "bg_canghongzhiyan_4",
		id = 56,
		story = "1856004",
		pre_event = {
			55
		},
		lock = {
			{
				4,
				55
			}
		}
	},
	[57] = {
		story_type = 1,
		name = "EP7-3 Melting",
		unlock_conditions = "Clear EP7-2.",
		change_bgm = "story-flowerdust-soft",
		change_prefab = "",
		change_background = "star_level_bg_504",
		id = 57,
		story = "HUANXINGCANGHONGZHIYAN27",
		pre_event = {
			56
		},
		lock = {
			{
				4,
				56
			}
		}
	},
	[58] = {
		story_type = 1,
		name = "EP7-4 Reunion",
		unlock_conditions = "Clear EP8-2.",
		change_bgm = "battle-eagleunion",
		change_prefab = "",
		change_background = "star_level_bg_504",
		id = 58,
		story = "HUANXINGCANGHONGZHIYAN28",
		pre_event = {
			57
		},
		lock = {
			{
				4,
				60
			}
		}
	},
	[59] = {
		story_type = 1,
		name = "EP8-1 Suppressing Naraka",
		unlock_conditions = "Clear EPS-3.",
		change_bgm = "theme-amagi-cv",
		change_prefab = "",
		change_background = "bg_canghongzhiyan_4",
		id = 59,
		story = "HUANXINGCANGHONGZHIYAN29",
		pre_event = {
			54
		},
		lock = {
			{
				4,
				54
			}
		}
	},
	[60] = {
		story_type = 1,
		name = "EP8-2 Core Sector Operation",
		unlock_conditions = "Clear EP7-3.",
		change_bgm = "battle-donghuang-static",
		change_prefab = "",
		change_background = "bg_canghongzhiyan_6",
		id = 60,
		story = "HUANXINGCANGHONGZHIYAN30",
		pre_event = {
			59
		},
		lock = {
			{
				4,
				57
			}
		}
	},
	[61] = {
		story_type = 1,
		name = "EP8-3 Moment of Truth",
		unlock_conditions = "Clear EP7-4.",
		change_bgm = "story-newsakura",
		change_prefab = "",
		change_background = "bg_canghongzhiyan_6",
		id = 61,
		story = "HUANXINGCANGHONGZHIYAN31",
		pre_event = {
			60
		},
		lock = {
			{
				4,
				58
			}
		}
	},
	[62] = {
		story_type = 1,
		name = "EP9-1 The Long Road Home",
		unlock_conditions = "Clear EP8-3.",
		change_bgm = "story-startravel",
		change_prefab = "",
		change_background = "bg_port_chongdong",
		id = 62,
		story = "HUANXINGCANGHONGZHIYAN32",
		pre_event = {
			58,
			61
		},
		lock = {
			{
				4,
				61
			}
		}
	},
	[63] = {
		story_type = 1,
		name = "EX-1 Contingency Plan F",
		unlock_conditions = "Clear EP9-1.",
		change_bgm = "story-darkplan",
		change_prefab = "",
		change_background = "star_level_bg_503",
		id = 63,
		story = "HUANXINGCANGHONGZHIYAN33",
		pre_event = {
			62
		},
		lock = {
			{
				4,
				62
			}
		}
	},
	[64] = {
		story_type = 1,
		name = "EX-2 Error",
		unlock_conditions = "Clear EX-1.",
		change_bgm = "theme-thetowerXVI",
		change_prefab = "",
		change_background = "bg_port_chongdong",
		id = 64,
		story = "HUANXINGCANGHONGZHIYAN34",
		pre_event = {
			63
		},
		lock = {
			{
				4,
				63
			}
		}
	},
	[65] = {
		story_type = 1,
		name = "EX-3 Thus Spake The Tower",
		unlock_conditions = "Clear EX-2.",
		change_bgm = "bsm-2",
		change_prefab = "",
		change_background = "bg_story_tower",
		id = 65,
		story = "HUANXINGCANGHONGZHIYAN35",
		pre_event = {
			64
		},
		lock = {
			{
				4,
				64
			}
		}
	},
	[66] = {
		story_type = 1,
		name = "EX-4 I, Observer",
		unlock_conditions = "Clear EX-3.",
		change_bgm = "theme-themagicianI",
		change_prefab = "",
		change_background = "bg_port_chongdong",
		id = 66,
		story = "HUANXINGCANGHONGZHIYAN36",
		pre_event = {
			65
		},
		lock = {
			{
				4,
				65
			}
		}
	},
	[67] = {
		story_type = 1,
		name = "EX-5 Illusory World",
		unlock_conditions = "Clear EX-4.",
		change_bgm = "theme-akagi-meta",
		change_prefab = "Map_1850004",
		change_background = "bg_canghongzhiyan_6",
		id = 67,
		story = "HUANXINGCANGHONGZHIYAN37",
		pre_event = {
			66
		},
		lock = {
			{
				4,
				66
			}
		}
	},
	[68] = {
		story_type = 1,
		pre_event = "",
		name = "EP1-1 罗盘的指引",
		unlock_conditions = "",
		change_prefab = "",
		change_background = "bg_jufengv1_2",
		story = "JUFENGYUCHENMIANZHIHAI1",
		change_bgm = "theme-tempest-up",
		id = 68,
		lock = ""
	},
	[69] = {
		story_type = 1,
		name = "EP1-2 与大海盗的重逢",
		unlock_conditions = "Clear EP1-1.",
		change_bgm = "theme-tempest-up",
		change_prefab = "",
		change_background = "bg_jufengv1_2",
		id = 69,
		story = "JUFENGYUCHENMIANZHIHAI2",
		pre_event = {
			68
		},
		lock = {
			{
				4,
				68
			}
		}
	},
	[70] = {
		story_type = 1,
		name = "EP1-3 集结！飓风船团！",
		unlock_conditions = "Clear EP1-2.",
		change_bgm = "theme-tempest",
		change_prefab = "",
		change_background = "star_level_bg_504",
		id = 70,
		story = "JUFENGYUCHENMIANZHIHAI3",
		pre_event = {
			69
		},
		lock = {
			{
				4,
				69
			}
		}
	},
	[71] = {
		story_type = 2,
		name = "EP1-4 寻宝猎人",
		unlock_conditions = "Clear EP1-3.",
		change_bgm = "story-temepest-2",
		change_prefab = "",
		change_background = "star_level_bg_162",
		id = 71,
		story = "1868001",
		pre_event = {
			70
		},
		lock = {
			{
				4,
				70
			}
		}
	},
	[72] = {
		story_type = 1,
		name = "EP2-1 复生与永生",
		unlock_conditions = "Clear EP1-4.",
		change_bgm = "story-temepest-2",
		change_prefab = "",
		change_background = "bg_jufengv2_cg1",
		id = 72,
		story = "JUFENGYUCHENMIANZHIHAI5",
		pre_event = {
			71
		},
		lock = {
			{
				4,
				71
			}
		}
	},
	[73] = {
		story_type = 2,
		name = "EP2-2 浮动宝库",
		unlock_conditions = "Clear EP2-1.",
		change_bgm = "theme-tempest-up",
		change_prefab = "",
		change_background = "bg_jufengv1_2",
		id = 73,
		story = "1868002",
		pre_event = {
			72
		},
		lock = {
			{
				4,
				72
			}
		}
	},
	[74] = {
		story_type = 1,
		name = "EP2-3 船团新人",
		unlock_conditions = "Clear EP2-2.",
		change_bgm = "theme-SeaAndSun-soft",
		change_prefab = "",
		change_background = "bg_jufengv2_cg4",
		id = 74,
		story = "JUFENGYUCHENMIANZHIHAI7",
		pre_event = {
			73
		},
		lock = {
			{
				4,
				73
			}
		}
	},
	[75] = {
		story_type = 1,
		name = "EP2-4 淅淅索索",
		unlock_conditions = "Clear EP2-3.",
		change_bgm = "theme-tempest",
		change_prefab = "",
		change_background = "bg_jufengv1_1",
		id = 75,
		story = "JUFENGYUCHENMIANZHIHAI8",
		pre_event = {
			74
		},
		lock = {
			{
				4,
				74
			}
		}
	},
	[76] = {
		story_type = 1,
		name = "EP3-1 新的线索",
		unlock_conditions = "完成EP2-4",
		change_bgm = "battle-nightmare-theme",
		change_prefab = "",
		change_background = "bg_jufengv2_1",
		id = 76,
		story = "JUFENGYUCHENMIANZHIHAI9",
		pre_event = {
			75
		},
		lock = {
			{
				4,
				75
			}
		}
	},
	[77] = {
		story_type = 1,
		name = "EP3-2 沉眠之海",
		unlock_conditions = "Clear EP3-1.",
		change_bgm = "battle-nightmare-theme",
		change_prefab = "",
		change_background = "bg_jufengv2_1",
		id = 77,
		story = "JUFENGYUCHENMIANZHIHAI10",
		pre_event = {
			76
		},
		lock = {
			{
				4,
				76
			}
		}
	},
	[78] = {
		story_type = 2,
		name = "EP3-3 风雨祭司",
		unlock_conditions = "Clear EP3-2.",
		change_bgm = "battle-nightmare-theme",
		change_prefab = "",
		change_background = "bg_jufengv2_1",
		id = 78,
		story = "1868003",
		pre_event = {
			77
		},
		lock = {
			{
				4,
				77
			}
		}
	},
	[79] = {
		story_type = 1,
		name = "EP3-4 圣殿与风暴",
		unlock_conditions = "完成EP3-3",
		change_bgm = "story-temepest-2",
		change_prefab = "",
		change_background = "star_level_bg_525",
		id = 79,
		story = "JUFENGYUCHENMIANZHIHAI12",
		pre_event = {
			78
		},
		lock = {
			{
				4,
				78
			}
		}
	},
	[80] = {
		story_type = 1,
		name = "EP4-1 深海魔物",
		unlock_conditions = "完成EP3-4",
		change_bgm = "story-temepest-2",
		change_prefab = "",
		change_background = "bg_jufengv2_cg6",
		id = 80,
		story = "JUFENGYUCHENMIANZHIHAI13",
		pre_event = {
			79
		},
		lock = {
			{
				4,
				79
			}
		}
	},
	[81] = {
		story_type = 2,
		name = "EP4-2 寂静之灵",
		unlock_conditions = "Clear EP4-1.",
		change_bgm = "battle-nightmare-theme",
		change_prefab = "",
		change_background = "bg_jufengv2_2",
		id = 81,
		story = "1868004",
		pre_event = {
			80
		},
		lock = {
			{
				4,
				80
			}
		}
	},
	[82] = {
		story_type = 1,
		name = "EP4-3 女神的主机",
		unlock_conditions = "Clear EP4-2.",
		change_bgm = "battle-nightmare-theme",
		change_prefab = "",
		change_background = "bg_jufengv2_2",
		id = 82,
		story = "JUFENGYUCHENMIANZHIHAI15",
		pre_event = {
			81
		},
		lock = {
			{
				4,
				81
			}
		}
	},
	[83] = {
		story_type = 1,
		name = "EP4-4 船团的决定",
		unlock_conditions = "Clear EP4-3.",
		change_bgm = "theme-ganjisawai",
		change_prefab = "",
		change_background = "star_level_bg_524",
		id = 83,
		story = "JUFENGYUCHENMIANZHIHAI16",
		pre_event = {
			82
		},
		lock = {
			{
				4,
				82
			}
		}
	},
	[84] = {
		story_type = 1,
		name = "EP5-1 风的另一面",
		unlock_conditions = "完成EP4-4",
		change_bgm = "theme-ganjisawai",
		change_prefab = "",
		change_background = "bg_jufengv2_cg7",
		id = 84,
		story = "JUFENGYUCHENMIANZHIHAI17",
		pre_event = {
			83
		},
		lock = {
			{
				4,
				83
			}
		}
	},
	[85] = {
		story_type = 1,
		name = "EP5-2 风雨齐奏",
		unlock_conditions = "Clear EP5-1.",
		change_bgm = "theme-SeaAndSun-soft",
		change_prefab = "",
		change_background = "bg_underwater",
		id = 85,
		story = "JUFENGYUCHENMIANZHIHAI18",
		pre_event = {
			84
		},
		lock = {
			{
				4,
				84
			}
		}
	},
	[86] = {
		story_type = 1,
		name = "EP5-3 罗盘的回归",
		unlock_conditions = "Clear EP5-2.",
		change_bgm = "story-temepest-1",
		change_prefab = "",
		change_background = "star_level_bg_539",
		id = 86,
		story = "JUFENGYUCHENMIANZHIHAI19",
		pre_event = {
			85
		},
		lock = {
			{
				4,
				85
			}
		}
	},
	[87] = {
		story_type = 1,
		name = "EX-1 沉眠之海的故事",
		unlock_conditions = "Clear EP5-3.",
		change_bgm = "theme-tempest-up",
		change_prefab = "",
		change_background = "star_level_bg_162",
		id = 87,
		story = "JUFENGYUCHENMIANZHIHAI20",
		pre_event = {
			86
		},
		lock = {
			{
				4,
				86
			}
		}
	},
	[88] = {
		story_type = 1,
		name = "EX-2 飓风的信使",
		unlock_conditions = "Clear EX-1.",
		change_bgm = "theme-ganjisawai",
		change_prefab = "",
		change_background = "star_level_bg_524",
		id = 88,
		story = "JUFENGYUCHENMIANZHIHAI21",
		pre_event = {
			87
		},
		lock = {
			{
				4,
				87
			}
		}
	},
	[89] = {
		story_type = 1,
		name = "EX-3 祭司与神使",
		unlock_conditions = "Clear EX-2.",
		change_bgm = "battle-nightmare-theme",
		change_prefab = "Map_1860001",
		change_background = "bg_jufengv2_1",
		id = 89,
		story = "JUFENGYUCHENMIANZHIHAI22",
		pre_event = {
			88
		},
		lock = {
			{
				4,
				88
			}
		}
	},
	all = {
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8,
		9,
		10,
		11,
		12,
		13,
		14,
		15,
		16,
		17,
		18,
		19,
		20,
		21,
		22,
		23,
		31,
		32,
		33,
		34,
		35,
		36,
		37,
		38,
		39,
		40,
		41,
		42,
		43,
		44,
		45,
		46,
		47,
		48,
		49,
		50,
		51,
		52,
		53,
		54,
		55,
		56,
		57,
		58,
		59,
		60,
		61,
		62,
		63,
		64,
		65,
		66,
		67,
		68,
		69,
		70,
		71,
		72,
		73,
		74,
		75,
		76,
		77,
		78,
		79,
		80,
		81,
		82,
		83,
		84,
		85,
		86,
		87,
		88,
		89
	}
}
