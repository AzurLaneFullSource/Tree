pg = pg or {}
pg.auction_collection = rawget(pg, "auction_collection") or setmetatable({
	__name = "auction_collection"
}, confNEO)
pg.auction_collection.all = {
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
	89,
	90,
	91,
	92,
	93,
	94,
	95,
	96,
	97,
	98,
	99,
	100,
	101,
	102,
	103,
	104,
	105,
	106,
	107,
	108,
	109,
	110,
	111,
	112,
	113,
	114,
	115,
	116,
	117,
	118,
	119,
	120
}
pg.auction_collection.get_id_list_by_rarity = {
	{
		106,
		107,
		108,
		109,
		110,
		111,
		112,
		113,
		114,
		115,
		116,
		117,
		118,
		119,
		120
	},
	{
		91,
		92,
		93,
		94,
		95,
		96,
		97,
		98,
		99,
		100,
		101,
		102,
		103,
		104,
		105
	},
	{
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
		89,
		90
	},
	{
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
		70
	},
	{
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
		40
	}
}
pg.base = pg.base or {}
pg.base.auction_collection = {}

;(function()
	pg.base.auction_collection[1] = {
		rarity = 5,
		name = "Z Flag",
		id = 1,
		value = 2685114,
		icon = "auctionicon/1",
		contour = {
			1,
			1
		}
	}
	pg.base.auction_collection[2] = {
		rarity = 5,
		name = "Blue Cornflower",
		id = 2,
		value = 1307336,
		icon = "auctionicon/2",
		contour = {
			1,
			1
		}
	}
	pg.base.auction_collection[3] = {
		rarity = 5,
		name = "Pearl",
		id = 3,
		value = 886532,
		icon = "auctionicon/3",
		contour = {
			1,
			1
		}
	}
	pg.base.auction_collection[4] = {
		rarity = 5,
		name = "Colorful Gamepad",
		id = 4,
		value = 799999,
		icon = "auctionicon/4",
		contour = {
			1,
			1
		}
	}
	pg.base.auction_collection[5] = {
		rarity = 5,
		name = "Magic Bread",
		id = 5,
		value = 452757,
		icon = "auctionicon/5",
		contour = {
			1,
			1
		}
	}
	pg.base.auction_collection[6] = {
		rarity = 5,
		name = "Special Equipment Blueprint",
		id = 6,
		value = 364855,
		icon = "auctionicon/6",
		contour = {
			1,
			1
		}
	}
	pg.base.auction_collection[7] = {
		rarity = 5,
		name = "Specialized Gear Upgrade Part",
		id = 7,
		value = 283538,
		icon = "auctionicon/7",
		contour = {
			1,
			1
		}
	}
	pg.base.auction_collection[8] = {
		rarity = 5,
		name = "Hologramjuu",
		id = 8,
		value = 195426,
		icon = "auctionicon/8",
		contour = {
			1,
			1
		}
	}
	pg.base.auction_collection[9] = {
		rarity = 5,
		name = "Type 93 Pure Oxygen Torpedo",
		id = 9,
		value = 878245,
		icon = "auctionicon/9",
		contour = {
			1,
			2
		}
	}
	pg.base.auction_collection[10] = {
		rarity = 5,
		name = "Witch's Broom",
		id = 10,
		value = 1561430,
		icon = "auctionicon/10",
		contour = {
			1,
			3
		}
	}
	pg.base.auction_collection[11] = {
		rarity = 5,
		name = "Med Station Scales",
		id = 11,
		value = 1635681,
		icon = "auctionicon/11",
		contour = {
			2,
			1
		}
	}
	pg.base.auction_collection[12] = {
		rarity = 5,
		name = "Special General Blueprint",
		id = 12,
		value = 706471,
		icon = "auctionicon/12",
		contour = {
			2,
			1
		}
	}
	pg.base.auction_collection[13] = {
		rarity = 5,
		name = "Ordnance Testing Report",
		id = 13,
		value = 489972,
		icon = "auctionicon/13",
		contour = {
			2,
			1
		}
	}
	pg.base.auction_collection[14] = {
		rarity = 5,
		name = "Comfy Pillow",
		id = 14,
		value = 2539483,
		icon = "auctionicon/14",
		contour = {
			2,
			2
		}
	}
	pg.base.auction_collection[15] = {
		rarity = 5,
		name = "Secret Magic Booster",
		id = 15,
		value = 1733281,
		icon = "auctionicon/15",
		contour = {
			2,
			2
		}
	}
	pg.base.auction_collection[16] = {
		rarity = 5,
		name = "Mysterious Hourglass",
		id = 16,
		value = 1293299,
		icon = "auctionicon/16",
		contour = {
			2,
			2
		}
	}
	pg.base.auction_collection[17] = {
		rarity = 5,
		name = "Grandmaster's Seat",
		id = 17,
		value = 1083805,
		icon = "auctionicon/17",
		contour = {
			2,
			2
		}
	}
	pg.base.auction_collection[18] = {
		rarity = 5,
		name = "Manjuu Toilet",
		id = 18,
		value = 776546,
		icon = "auctionicon/18",
		contour = {
			2,
			2
		}
	}
	pg.base.auction_collection[19] = {
		rarity = 5,
		name = "Giant Tumbleweed",
		id = 19,
		value = 630423,
		icon = "auctionicon/19",
		contour = {
			2,
			2
		}
	}
	pg.base.auction_collection[20] = {
		rarity = 5,
		name = "Manjuu and the Beanstalk",
		id = 20,
		value = 438654,
		icon = "auctionicon/20",
		contour = {
			2,
			2
		}
	}
	pg.base.auction_collection[21] = {
		rarity = 5,
		name = "Pirate Treasure Chest",
		id = 21,
		value = 284912,
		icon = "auctionicon/21",
		contour = {
			2,
			2
		}
	}
	pg.base.auction_collection[22] = {
		rarity = 5,
		name = "Manjuu Statue",
		id = 22,
		value = 202368,
		icon = "auctionicon/22",
		contour = {
			2,
			2
		}
	}
	pg.base.auction_collection[23] = {
		rarity = 5,
		name = "Artistic Bust Sculpture",
		id = 23,
		value = 2557820,
		icon = "auctionicon/23",
		contour = {
			2,
			3
		}
	}
	pg.base.auction_collection[24] = {
		rarity = 5,
		name = "Nutcracker Soldier - Sword",
		id = 24,
		value = 2394967,
		icon = "auctionicon/24",
		contour = {
			2,
			3
		}
	}
	pg.base.auction_collection[25] = {
		rarity = 5,
		name = "Mysterious Telephone Booth",
		id = 25,
		value = 1956574,
		icon = "auctionicon/25",
		contour = {
			2,
			3
		}
	}
	pg.base.auction_collection[26] = {
		rarity = 5,
		name = "Queen's Guard Manjuu",
		id = 26,
		value = 971708,
		icon = "auctionicon/26",
		contour = {
			2,
			3
		}
	}
	pg.base.auction_collection[27] = {
		rarity = 5,
		name = "Nutcracker Soldier - Rifle",
		id = 27,
		value = 385956,
		icon = "auctionicon/27",
		contour = {
			2,
			3
		}
	}
	pg.base.auction_collection[28] = {
		rarity = 5,
		name = "Aurora Wings",
		id = 28,
		value = 1680426,
		icon = "auctionicon/28",
		contour = {
			3,
			1
		}
	}
	pg.base.auction_collection[29] = {
		rarity = 5,
		name = "Prototype Twin 457mm Mk A Main Gun Mount",
		id = 29,
		value = 540336,
		icon = "auctionicon/29",
		contour = {
			3,
			1
		}
	}
	pg.base.auction_collection[30] = {
		rarity = 5,
		name = "Temple Portrait",
		id = 30,
		value = 2999999,
		icon = "auctionicon/30",
		contour = {
			3,
			2
		}
	}
	pg.base.auction_collection[31] = {
		rarity = 5,
		name = "Admiralty Fire Control Table",
		id = 31,
		value = 1878833,
		icon = "auctionicon/31",
		contour = {
			3,
			2
		}
	}
	pg.base.auction_collection[32] = {
		rarity = 5,
		name = "Famous Painting Carpet",
		id = 32,
		value = 1080961,
		icon = "auctionicon/32",
		contour = {
			3,
			2
		}
	}
	pg.base.auction_collection[33] = {
		rarity = 5,
		name = "Twin 138.6mm Mle 1934 Naval Gun",
		id = 33,
		value = 713390,
		icon = "auctionicon/33",
		contour = {
			3,
			2
		}
	}
	pg.base.auction_collection[34] = {
		rarity = 5,
		name = "Prototype Tenrai",
		id = 34,
		value = 499425,
		icon = "auctionicon/34",
		contour = {
			3,
			2
		}
	}
	pg.base.auction_collection[35] = {
		rarity = 5,
		name = "Beavers Forever",
		id = 35,
		value = 381262,
		icon = "auctionicon/35",
		contour = {
			3,
			2
		}
	}
	pg.base.auction_collection[36] = {
		rarity = 5,
		name = "Triple 460mm Main Gun Mount",
		id = 36,
		value = 3061687,
		icon = "auctionicon/36",
		contour = {
			3,
			3
		}
	}
	pg.base.auction_collection[37] = {
		rarity = 5,
		name = "Stargazy Pie",
		id = 37,
		value = 1587435,
		icon = "auctionicon/37",
		contour = {
			3,
			3
		}
	}
	pg.base.auction_collection[38] = {
		rarity = 5,
		name = "Upright Tower of Pisa",
		id = 38,
		value = 1486670,
		icon = "auctionicon/38",
		contour = {
			3,
			3
		}
	}
	pg.base.auction_collection[39] = {
		rarity = 5,
		name = "Exhibition Souvenir",
		id = 39,
		value = 992601,
		icon = "auctionicon/39",
		contour = {
			3,
			3
		}
	}
	pg.base.auction_collection[40] = {
		rarity = 5,
		name = "\"The Thinker\" Statue",
		id = 40,
		value = 659511,
		icon = "auctionicon/40",
		contour = {
			3,
			3
		}
	}
	pg.base.auction_collection[41] = {
		rarity = 4,
		name = "Beaver Squad Tag",
		id = 41,
		value = 226538,
		icon = "auctionicon/41",
		contour = {
			1,
			1
		}
	}
	pg.base.auction_collection[42] = {
		rarity = 4,
		name = "Pearl's Tears",
		id = 42,
		value = 183981,
		icon = "auctionicon/42",
		contour = {
			1,
			1
		}
	}
	pg.base.auction_collection[43] = {
		rarity = 4,
		name = "Fluffy Stuffed Animal",
		id = 43,
		value = 142861,
		icon = "auctionicon/43",
		contour = {
			1,
			1
		}
	}
	pg.base.auction_collection[44] = {
		rarity = 4,
		name = "Explorer's Eye",
		id = 44,
		value = 102347,
		icon = "auctionicon/44",
		contour = {
			1,
			1
		}
	}
	pg.base.auction_collection[45] = {
		rarity = 4,
		name = "Reverie Nightcap",
		id = 45,
		value = 51756,
		icon = "auctionicon/45",
		contour = {
			1,
			1
		}
	}
	pg.base.auction_collection[46] = {
		rarity = 4,
		name = "Fancy Bouquet",
		id = 46,
		value = 220529,
		icon = "auctionicon/46",
		contour = {
			1,
			2
		}
	}
	pg.base.auction_collection[47] = {
		rarity = 4,
		name = "Game Console Set",
		id = 47,
		value = 182546,
		icon = "auctionicon/47",
		contour = {
			1,
			2
		}
	}
	pg.base.auction_collection[48] = {
		rarity = 4,
		name = "AP Shell",
		id = 48,
		value = 124560,
		icon = "auctionicon/48",
		contour = {
			1,
			2
		}
	}
	pg.base.auction_collection[49] = {
		rarity = 4,
		name = "Ceremonial Sword",
		id = 49,
		value = 85093,
		icon = "auctionicon/49",
		contour = {
			1,
			2
		}
	}
	pg.base.auction_collection[50] = {
		rarity = 4,
		name = "Super Heavy Shell",
		id = 50,
		value = 60018,
		icon = "auctionicon/50",
		contour = {
			1,
			2
		}
	}
	pg.base.auction_collection[51] = {
		rarity = 4,
		name = "The Guardian's Bestowed Sword",
		id = 51,
		value = 221819,
		icon = "auctionicon/51",
		contour = {
			1,
			3
		}
	}
	pg.base.auction_collection[52] = {
		rarity = 4,
		name = "Explosion Scepter",
		id = 52,
		value = 175056,
		icon = "auctionicon/52",
		contour = {
			1,
			3
		}
	}
	pg.base.auction_collection[53] = {
		rarity = 4,
		name = "Sworn Knight's Sword",
		id = 53,
		value = 141764,
		icon = "auctionicon/53",
		contour = {
			1,
			3
		}
	}
	pg.base.auction_collection[54] = {
		rarity = 4,
		name = "Summoning Staff",
		id = 54,
		value = 70278,
		icon = "auctionicon/54",
		contour = {
			1,
			3
		}
	}
	pg.base.auction_collection[55] = {
		rarity = 4,
		name = "Corrosion-Resistant Alloys",
		id = 55,
		value = 247007,
		icon = "auctionicon/55",
		contour = {
			2,
			1
		}
	}
	pg.base.auction_collection[56] = {
		rarity = 4,
		name = "Superconductive Metals",
		id = 56,
		value = 188499,
		icon = "auctionicon/56",
		contour = {
			2,
			1
		}
	}
	pg.base.auction_collection[57] = {
		rarity = 4,
		name = "High Performance Air Radar",
		id = 57,
		value = 138522,
		icon = "auctionicon/57",
		contour = {
			2,
			1
		}
	}
	pg.base.auction_collection[58] = {
		rarity = 4,
		name = "Chest Full of Treasure",
		id = 58,
		value = 225664,
		icon = "auctionicon/58",
		contour = {
			2,
			2
		}
	}
	pg.base.auction_collection[59] = {
		rarity = 4,
		name = "Fargo Direct Drone",
		id = 59,
		value = 153238,
		icon = "auctionicon/59",
		contour = {
			2,
			2
		}
	}
	pg.base.auction_collection[60] = {
		rarity = 4,
		name = "High Performance Hydraulic Steering Gear",
		id = 60,
		value = 115115,
		icon = "auctionicon/60",
		contour = {
			2,
			2
		}
	}
	pg.base.auction_collection[61] = {
		rarity = 4,
		name = "Hero's Shield",
		id = 61,
		value = 240927,
		icon = "auctionicon/61",
		contour = {
			2,
			3
		}
	}
	pg.base.auction_collection[62] = {
		rarity = 4,
		name = "Violet Brush",
		id = 62,
		value = 136295,
		icon = "auctionicon/62",
		contour = {
			2,
			3
		}
	}
	pg.base.auction_collection[63] = {
		rarity = 4,
		name = "Rime Sword of the Great One",
		id = 63,
		value = 96819,
		icon = "auctionicon/63",
		contour = {
			2,
			3
		}
	}
	pg.base.auction_collection[64] = {
		rarity = 4,
		name = "Adventurer's Staff",
		id = 64,
		value = 281034,
		icon = "auctionicon/64",
		contour = {
			3,
			1
		}
	}
	pg.base.auction_collection[65] = {
		rarity = 4,
		name = "Staff of Machinery & Logic",
		id = 65,
		value = 198487,
		icon = "auctionicon/65",
		contour = {
			3,
			1
		}
	}
	pg.base.auction_collection[66] = {
		rarity = 4,
		name = "Auspicious Dragonfly",
		id = 66,
		value = 123460,
		icon = "auctionicon/66",
		contour = {
			3,
			1
		}
	}
	pg.base.auction_collection[67] = {
		rarity = 4,
		name = "Rudder of Fate",
		id = 67,
		value = 302326,
		icon = "auctionicon/67",
		contour = {
			3,
			2
		}
	}
	pg.base.auction_collection[68] = {
		rarity = 4,
		name = "Steam Catapult",
		id = 68,
		value = 224110,
		icon = "auctionicon/68",
		contour = {
			3,
			2
		}
	}
	pg.base.auction_collection[69] = {
		rarity = 4,
		name = "VH Armor Plating",
		id = 69,
		value = 168340,
		icon = "auctionicon/69",
		contour = {
			3,
			2
		}
	}
	pg.base.auction_collection[70] = {
		rarity = 4,
		name = "Crate of Super Heavy Shells",
		id = 70,
		value = 93012,
		icon = "auctionicon/70",
		contour = {
			3,
			2
		}
	}
	pg.base.auction_collection[71] = {
		rarity = 3,
		name = "Industrial-Grade Electronic Components",
		id = 71,
		value = 98067,
		icon = "auctionicon/71",
		contour = {
			1,
			1
		}
	}
	pg.base.auction_collection[72] = {
		rarity = 3,
		name = "Cross Brooch",
		id = 72,
		value = 61123,
		icon = "auctionicon/72",
		contour = {
			1,
			1
		}
	}
	pg.base.auction_collection[73] = {
		rarity = 3,
		name = "Fuel Filter",
		id = 73,
		value = 36824,
		icon = "auctionicon/73",
		contour = {
			1,
			1
		}
	}
	pg.base.auction_collection[74] = {
		rarity = 3,
		name = "Compressed Oxygen Cylinder",
		id = 74,
		value = 73106,
		icon = "auctionicon/74",
		contour = {
			1,
			2
		}
	}
	pg.base.auction_collection[75] = {
		rarity = 3,
		name = "Hero's Sword",
		id = 75,
		value = 110503,
		icon = "auctionicon/75",
		contour = {
			1,
			3
		}
	}
	pg.base.auction_collection[76] = {
		rarity = 3,
		name = "Lightweight Alloys",
		id = 76,
		value = 67435,
		icon = "auctionicon/76",
		contour = {
			1,
			3
		}
	}
	pg.base.auction_collection[77] = {
		rarity = 3,
		name = "Nautical Telescope",
		id = 77,
		value = 44974,
		icon = "auctionicon/77",
		contour = {
			1,
			3
		}
	}
	pg.base.auction_collection[78] = {
		rarity = 3,
		name = "Repair Toolkit",
		id = 78,
		value = 106949,
		icon = "auctionicon/78",
		contour = {
			2,
			1
		}
	}
	pg.base.auction_collection[79] = {
		rarity = 3,
		name = "Expedition Report",
		id = 79,
		value = 119697,
		icon = "auctionicon/79",
		contour = {
			2,
			2
		}
	}
	pg.base.auction_collection[80] = {
		rarity = 3,
		name = "Intel Report",
		id = 80,
		value = 69744,
		icon = "auctionicon/80",
		contour = {
			2,
			2
		}
	}
	pg.base.auction_collection[81] = {
		rarity = 3,
		name = "Improved Boiler",
		id = 81,
		value = 42261,
		icon = "auctionicon/81",
		contour = {
			2,
			2
		}
	}
	pg.base.auction_collection[82] = {
		rarity = 3,
		name = "Sail Components",
		id = 82,
		value = 92730,
		icon = "auctionicon/82",
		contour = {
			2,
			3
		}
	}
	pg.base.auction_collection[83] = {
		rarity = 3,
		name = "Hunting Bow",
		id = 83,
		value = 71497,
		icon = "auctionicon/83",
		contour = {
			2,
			3
		}
	}
	pg.base.auction_collection[84] = {
		rarity = 3,
		name = "Greatsword",
		id = 84,
		value = 47954,
		icon = "auctionicon/84",
		contour = {
			2,
			3
		}
	}
	pg.base.auction_collection[85] = {
		rarity = 3,
		name = "Officer's Sword",
		id = 85,
		value = 96008,
		icon = "auctionicon/85",
		contour = {
			3,
			1
		}
	}
	pg.base.auction_collection[86] = {
		rarity = 3,
		name = "Longsword",
		id = 86,
		value = 79737,
		icon = "auctionicon/86",
		contour = {
			3,
			1
		}
	}
	pg.base.auction_collection[87] = {
		rarity = 3,
		name = "Lance",
		id = 87,
		value = 36887,
		icon = "auctionicon/87",
		contour = {
			3,
			1
		}
	}
	pg.base.auction_collection[88] = {
		rarity = 3,
		name = "Drop Tank",
		id = 88,
		value = 131792,
		icon = "auctionicon/88",
		contour = {
			3,
			2
		}
	}
	pg.base.auction_collection[89] = {
		rarity = 3,
		name = "Fire Control Radar",
		id = 89,
		value = 109576,
		icon = "auctionicon/89",
		contour = {
			3,
			2
		}
	}
	pg.base.auction_collection[90] = {
		rarity = 3,
		name = "Autoloader",
		id = 90,
		value = 60614,
		icon = "auctionicon/90",
		contour = {
			3,
			2
		}
	}
	pg.base.auction_collection[91] = {
		rarity = 2,
		name = "Unbranded Gunpowder",
		id = 91,
		value = 24847,
		icon = "auctionicon/91",
		contour = {
			1,
			1
		}
	}
	pg.base.auction_collection[92] = {
		rarity = 2,
		name = "Limited-Edition Oxy-Cola",
		id = 92,
		value = 21495,
		icon = "auctionicon/92",
		contour = {
			1,
			1
		}
	}
	pg.base.auction_collection[93] = {
		rarity = 2,
		name = "Consumer-Grade Electronic Components",
		id = 93,
		value = 11916,
		icon = "auctionicon/93",
		contour = {
			1,
			1
		}
	}
	pg.base.auction_collection[94] = {
		rarity = 2,
		name = "General Parts",
		id = 94,
		value = 8661,
		icon = "auctionicon/94",
		contour = {
			1,
			1
		}
	}
	pg.base.auction_collection[95] = {
		rarity = 2,
		name = "High-Quality Cooking Oil",
		id = 95,
		value = 34181,
		icon = "auctionicon/95",
		contour = {
			1,
			2
		}
	}
	pg.base.auction_collection[96] = {
		rarity = 2,
		name = "Refined Metals",
		id = 96,
		value = 30819,
		icon = "auctionicon/96",
		contour = {
			1,
			2
		}
	}
	pg.base.auction_collection[97] = {
		rarity = 2,
		name = "Scepter",
		id = 97,
		value = 2446,
		icon = "auctionicon/97",
		contour = {
			1,
			3
		}
	}
	pg.base.auction_collection[98] = {
		rarity = 2,
		name = "Natural Rubber",
		id = 98,
		value = 28058,
		icon = "auctionicon/98",
		contour = {
			2,
			1
		}
	}
	pg.base.auction_collection[99] = {
		rarity = 2,
		name = "High-Quality Leather",
		id = 99,
		value = 12932,
		icon = "auctionicon/99",
		contour = {
			2,
			1
		}
	}
	pg.base.auction_collection[100] = {
		rarity = 2,
		name = "Gyroscope",
		id = 100,
		value = 16164,
		icon = "auctionicon/100",
		contour = {
			2,
			2
		}
	}
end)()
;(function()
	pg.base.auction_collection[101] = {
		rarity = 2,
		name = "Old Heavy Cannon",
		id = 101,
		value = 10078,
		icon = "auctionicon/101",
		contour = {
			2,
			2
		}
	}
	pg.base.auction_collection[102] = {
		rarity = 2,
		name = "12-Pounder Long Gun",
		id = 102,
		value = 11087,
		icon = "auctionicon/102",
		contour = {
			2,
			3
		}
	}
	pg.base.auction_collection[103] = {
		rarity = 2,
		name = "Twin 380mm SK C/34 Main Gun Mount",
		id = 103,
		value = 15862,
		icon = "auctionicon/103",
		contour = {
			3,
			1
		}
	}
	pg.base.auction_collection[104] = {
		rarity = 2,
		name = "Decorative Painting",
		id = 104,
		value = 28317,
		icon = "auctionicon/104",
		contour = {
			3,
			2
		}
	}
	pg.base.auction_collection[105] = {
		rarity = 2,
		name = "Wooden Desk and Chair",
		id = 105,
		value = 20376,
		icon = "auctionicon/105",
		contour = {
			3,
			2
		}
	}
	pg.base.auction_collection[106] = {
		rarity = 1,
		name = "Printer Ink Cartridge",
		id = 106,
		value = 9053,
		icon = "auctionicon/106",
		contour = {
			1,
			1
		}
	}
	pg.base.auction_collection[107] = {
		rarity = 1,
		name = "Blank Notebook",
		id = 107,
		value = 7279,
		icon = "auctionicon/107",
		contour = {
			1,
			1
		}
	}
	pg.base.auction_collection[108] = {
		rarity = 1,
		name = "Hex Nut",
		id = 108,
		value = 3844,
		icon = "auctionicon/108",
		contour = {
			1,
			1
		}
	}
	pg.base.auction_collection[109] = {
		rarity = 1,
		name = "Medicinal Sulfuric Acid",
		id = 109,
		value = 1814,
		icon = "auctionicon/109",
		contour = {
			1,
			1
		}
	}
	pg.base.auction_collection[110] = {
		rarity = 1,
		name = "Basic Depth Charge Projector",
		id = 110,
		value = 7982,
		icon = "auctionicon/110",
		contour = {
			1,
			2
		}
	}
	pg.base.auction_collection[111] = {
		rarity = 1,
		name = "Fire Extinguisher",
		id = 111,
		value = 1420,
		icon = "auctionicon/111",
		contour = {
			1,
			2
		}
	}
	pg.base.auction_collection[112] = {
		rarity = 1,
		name = "Seaside Seashell",
		id = 112,
		value = 8454,
		icon = "auctionicon/112",
		contour = {
			2,
			1
		}
	}
	pg.base.auction_collection[113] = {
		rarity = 1,
		name = "Blank Paper",
		id = 113,
		value = 6685,
		icon = "auctionicon/113",
		contour = {
			2,
			1
		}
	}
	pg.base.auction_collection[114] = {
		rarity = 1,
		name = "Iron Ingot",
		id = 114,
		value = 4507,
		icon = "auctionicon/114",
		contour = {
			2,
			1
		}
	}
	pg.base.auction_collection[115] = {
		rarity = 1,
		name = "Rammer",
		id = 115,
		value = 12171,
		icon = "auctionicon/115",
		contour = {
			2,
			2
		}
	}
	pg.base.auction_collection[116] = {
		rarity = 1,
		name = "Naval Camouflage",
		id = 116,
		value = 6271,
		icon = "auctionicon/116",
		contour = {
			2,
			2
		}
	}
	pg.base.auction_collection[117] = {
		rarity = 1,
		name = "Hydraulic Steering Gear",
		id = 117,
		value = 3797,
		icon = "auctionicon/117",
		contour = {
			2,
			2
		}
	}
	pg.base.auction_collection[118] = {
		rarity = 1,
		name = "Trumpet",
		id = 118,
		value = 5567,
		icon = "auctionicon/118",
		contour = {
			2,
			3
		}
	}
	pg.base.auction_collection[119] = {
		rarity = 1,
		name = "Violin",
		id = 119,
		value = 3747,
		icon = "auctionicon/119",
		contour = {
			2,
			3
		}
	}
	pg.base.auction_collection[120] = {
		rarity = 1,
		name = "Workable Wood",
		id = 120,
		value = 2360,
		icon = "auctionicon/120",
		contour = {
			3,
			2
		}
	}
end)()
