pg = pg or {}
pg.music_collect_config = rawget(pg, "music_collect_config") or setmetatable({
	__name = "music_collect_config"
}, confNEO)
pg.music_collect_config.all = {
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
	24,
	25,
	26,
	27,
	28,
	29,
	30,
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
	54
}
pg.music_collect_config.get_id_list_by_album_id = {
	{
		1,
		2,
		3,
		4
	},
	{
		5,
		6,
		7
	},
	{
		8,
		9,
		10,
		11,
		12,
		13,
		14
	},
	{
		15,
		16,
		17,
		18
	},
	{
		19,
		20,
		21,
		22,
		23,
		24,
		25,
		26,
		27,
		28,
		29,
		30,
		31,
		32,
		33
	},
	{
		34,
		35
	},
	{
		36
	},
	{
		37,
		38,
		39,
		40,
		41,
		42
	},
	{
		43,
		44,
		45,
		46
	},
	{
		47,
		48,
		49,
		50,
		51,
		52,
		53,
		54
	}
}
pg.base = pg.base or {}
pg.base.music_collect_config = {}

;(function()
	pg.base.music_collect_config[1] = {
		id = 1,
		name = "Dawn of Disaster",
		unlock_other = 0,
		music_time = 108266,
		album_id = 1,
		music = "bgm-bsm-1",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[2] = {
		id = 2,
		name = "Observer of the Past",
		unlock_other = 0,
		music_time = 126166,
		album_id = 1,
		music = "bgm-bsm-2",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[3] = {
		id = 3,
		name = "Last Stand",
		unlock_other = 0,
		music_time = 122000,
		album_id = 1,
		music = "bgm-bsm-3",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[4] = {
		id = 4,
		name = "Crisis",
		unlock_other = 0,
		music_time = 65666,
		album_id = 1,
		music = "bgm-bsm-9",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[5] = {
		id = 5,
		name = "Sacred Tragicomedy",
		unlock_other = 0,
		music_time = 118000,
		album_id = 2,
		music = "bgm-story-italy",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[6] = {
		id = 6,
		name = "Glory and Falsehoods",
		unlock_other = 0,
		music_time = 91633,
		album_id = 2,
		music = "bgm-battle-italy",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[7] = {
		id = 7,
		name = "Twilight Prayer",
		unlock_other = 0,
		music_time = 98000,
		album_id = 2,
		music = "bgm-battle-boss-italy",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[8] = {
		id = 8,
		name = "Wade Through Fire",
		unlock_other = 0,
		music_time = 128002,
		album_id = 3,
		music = "bgm-theme-bismark-reborn",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[9] = {
		id = 9,
		name = "Autonomous Warfare System",
		unlock_other = 0,
		music_time = 90000,
		album_id = 3,
		music = "bgm-battle-siren-centraltower",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[10] = {
		id = 10,
		name = "Demon's Judgment",
		unlock_other = 0,
		music_time = 91428,
		album_id = 3,
		music = "bgm-battle-thedevilXV-control",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[11] = {
		id = 11,
		name = "Combat: Executor",
		unlock_other = 0,
		music_time = 100645,
		album_id = 3,
		music = "bgm-theme-thehermitIX",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[12] = {
		id = 12,
		name = "Combat: Marco Polo",
		unlock_other = 0,
		music_time = 93333,
		album_id = 3,
		music = "bgm-theme-thetowerXVI",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[13] = {
		id = 13,
		name = "The Philosopher and the Spider",
		unlock_other = 0,
		music_time = 139701,
		album_id = 3,
		music = "bgm-theme-ulrich",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[14] = {
		id = 14,
		name = "Path of Iron and Blood",
		unlock_other = 0,
		music_time = 62502,
		album_id = 3,
		music = "bgm-story-bismark-determination",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[15] = {
		id = 15,
		name = "Sail Towards Adventure",
		unlock_other = 0,
		music_time = 90000,
		album_id = 4,
		music = "bgm-theme-SeaAndSun-image",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[16] = {
		id = 16,
		name = "Peaceful Sea",
		unlock_other = 0,
		music_time = 89638,
		album_id = 4,
		music = "bgm-theme-SeaAndSun-soft",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[17] = {
		id = 17,
		name = "Golden Hind and Silver Octopus",
		unlock_other = 0,
		music_time = 151500,
		album_id = 4,
		music = "bgm-theme-tempest",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[18] = {
		id = 18,
		name = "Uncharted Summer",
		unlock_other = 0,
		music_time = 90955,
		album_id = 4,
		music = "bgm-main-SeaAndSun",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[19] = {
		id = 19,
		name = "Weigh Anchor",
		unlock_other = 0,
		music_time = 66071,
		album_id = 5,
		music = "bgm-login",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[20] = {
		id = 20,
		name = "Port",
		unlock_other = 0,
		music_time = 56711,
		album_id = 5,
		music = "bgm-main",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[21] = {
		id = 21,
		name = "Carefree Moment",
		unlock_other = 0,
		music_time = 45000,
		album_id = 5,
		music = "bgm-backyard",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[22] = {
		id = 22,
		name = "Everyday Life",
		unlock_other = 0,
		music_time = 105931,
		album_id = 5,
		music = "bgm-story-1",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[23] = {
		id = 23,
		name = "Feelings",
		unlock_other = 0,
		music_time = 35217,
		album_id = 5,
		music = "bgm-story-2",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[24] = {
		id = 24,
		name = "Sortie",
		unlock_other = 0,
		music_time = 108800,
		album_id = 5,
		music = "bgm-level",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[25] = {
		id = 25,
		name = "Blue Wind",
		unlock_other = 0,
		music_time = 120678,
		album_id = 5,
		music = "bgm-battle-1",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[26] = {
		id = 26,
		name = "Night Over Solomon",
		unlock_other = 0,
		music_time = 149647,
		album_id = 5,
		music = "bgm-battle-2",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[27] = {
		id = 27,
		name = "Fierce Battle",
		unlock_other = 0,
		music_time = 98823,
		album_id = 5,
		music = "bgm-battle-boss-1",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[28] = {
		id = 28,
		name = "Resolve",
		unlock_other = 0,
		music_time = 137964,
		album_id = 5,
		music = "bgm-battle-boss-2",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[29] = {
		id = 29,
		name = "Danger Approaching",
		unlock_other = 0,
		music_time = 204739,
		album_id = 5,
		music = "bgm-battle-boss-3",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[30] = {
		id = 30,
		name = "Duty",
		unlock_other = 0,
		music_time = 63033,
		album_id = 5,
		music = "bgm-level02",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[31] = {
		id = 31,
		name = "Dispose of the Pawns",
		unlock_other = 0,
		music_time = 58630,
		album_id = 5,
		music = "bgm-battle-boss-4",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[32] = {
		id = 32,
		name = "Promised Moment",
		unlock_other = 0,
		music_time = 83905,
		album_id = 5,
		music = "bgm-wedding",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[33] = {
		id = 33,
		name = "Set Sail",
		unlock_other = 0,
		music_time = 91428,
		album_id = 5,
		music = "bgm-story-richang",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[34] = {
		id = 34,
		name = "Pristine Leaves, Rich Warmth",
		unlock_other = 0,
		music_time = 124998,
		album_id = 6,
		music = "bgm-theme-yixian-soft-loop",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[35] = {
		id = 35,
		name = "First in Freshness",
		unlock_other = 0,
		music_time = 117750,
		album_id = 6,
		music = "bgm-theme-yixian-pv-loop",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[36] = {
		id = 36,
		name = "Silken Road's Growing Sound",
		unlock_other = 0,
		music_time = 154666,
		album_id = 7,
		music = "bgm-theme-haitian-soft-loop",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[37] = {
		id = 37,
		name = "Winds of Kerguelen",
		unlock_other = 0,
		music_time = 45333,
		album_id = 8,
		music = "bgm-theme-kerguelen",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[38] = {
		id = 38,
		name = "Basilica",
		unlock_other = 0,
		music_time = 101649,
		album_id = 8,
		music = "bgm-theme-vichy-church",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[39] = {
		id = 39,
		name = "Symbol of Judgment",
		unlock_other = 0,
		music_time = 130669,
		album_id = 8,
		music = "bgm-theme-vichy-revelation",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[40] = {
		id = 40,
		name = "Mechanicus Harbinger",
		unlock_other = 0,
		music_time = 119999,
		album_id = 8,
		music = "bgm-theme-vichy-slaughter",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[41] = {
		id = 41,
		name = "Revelations of Dust",
		unlock_other = 0,
		music_time = 88615,
		album_id = 8,
		music = "bgm-theme-elizabeth-andmeta",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[42] = {
		id = 42,
		name = "Digital Arbiter",
		unlock_other = 0,
		music_time = 151048,
		album_id = 8,
		music = "bgm-battle-whaling-normal",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[43] = {
		id = 43,
		name = "World-Spanning Arclight",
		unlock_other = 0,
		music_time = 123806,
		album_id = 9,
		music = "bgm-ssss-az-pv",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[44] = {
		id = 44,
		name = "Piano and Guitar",
		unlock_other = 0,
		music_time = 121199,
		album_id = 9,
		music = "bgm-ssss-az-story",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[45] = {
		id = 45,
		name = "All This Siren",
		unlock_other = 0,
		music_time = 123428,
		album_id = 9,
		music = "bgm-ssss-az-battle",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[46] = {
		id = 46,
		name = "Shining Electronic Beating",
		unlock_other = 0,
		music_time = 114705,
		album_id = 9,
		music = "bgm-ssss-az-battle-boss",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[47] = {
		id = 47,
		name = "Attendre et espérer.",
		unlock_other = 0,
		music_time = 121876,
		album_id = 10,
		music = "bgm-theme-clemenceau",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[48] = {
		id = 48,
		name = "Broken Light",
		unlock_other = 0,
		music_time = 138459,
		album_id = 10,
		music = "bgm-story-french1",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[49] = {
		id = 49,
		name = "Like a Sacred White Lily",
		unlock_other = 0,
		music_time = 125373,
		album_id = 10,
		music = "bgm-level-french1",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[50] = {
		id = 50,
		name = "Will of Freedom",
		unlock_other = 0,
		music_time = 105566,
		album_id = 10,
		music = "bgm-story-french",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[51] = {
		id = 51,
		name = "Beneath the Iris' Banner",
		unlock_other = 0,
		music_time = 112133,
		album_id = 10,
		music = "bgm-battle-underholyflag",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[52] = {
		id = 52,
		name = "Holy Recovery",
		unlock_other = 0,
		music_time = 89006,
		album_id = 10,
		music = "bgm-theme-irisangel",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[53] = {
		id = 53,
		name = "Iris' Enchantress",
		unlock_other = 0,
		music_time = 147814,
		album_id = 10,
		music = "bgm-theme-richelieu",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
	pg.base.music_collect_config[54] = {
		id = 54,
		name = "Symphony of Gold and Ceremony",
		unlock_other = 0,
		music_time = 96363,
		album_id = 10,
		music = "bgm-story-musicanniversary-gorgeous",
		illustrate = "",
		unlock_level = {
			1,
			0
		},
		unlock_cost = {}
	}
end)()
