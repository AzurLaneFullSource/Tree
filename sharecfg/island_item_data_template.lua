pg = pg or {}
pg.island_item_data_template = setmetatable({
	__name = "island_item_data_template",
	get_id_list_by_usage = {
		usage_undefined = {
			1,
			2,
			3,
			4,
			5,
			6,
			7,
			8,
			9,
			1000,
			1001,
			1002,
			1003,
			1004,
			1005,
			1006,
			1007,
			1008,
			1009,
			1010,
			1011,
			1012,
			1014,
			1015,
			1016,
			1017,
			1018,
			1019,
			1020,
			1021,
			1022,
			1501,
			2000,
			2001,
			2002,
			2003,
			2004,
			2005,
			2006,
			2007,
			2008,
			2009,
			2010,
			2011,
			2012,
			2014,
			2015,
			2016,
			2017,
			2018,
			2019,
			2020,
			2021,
			2022,
			2600,
			2601,
			2602,
			2603,
			2604,
			2605,
			2606,
			2700,
			2701,
			2702,
			2703,
			2704,
			2705,
			2800,
			2801,
			2802,
			2803,
			3000,
			3001,
			3002,
			3003,
			3004,
			3005,
			3006,
			3007,
			3008,
			3009,
			3010,
			3011,
			3012,
			3013,
			3014,
			3015,
			3016,
			3017,
			3018,
			3019,
			3020,
			3021,
			3022,
			3023,
			3024,
			3025,
			3026,
			3028,
			3029,
			3030,
			3031,
			3032,
			3033,
			3034,
			3035,
			3036,
			3037,
			3038,
			3039,
			3040,
			3041,
			3042,
			3043,
			3044,
			3045,
			3046,
			3047,
			3048,
			3049,
			3050,
			3051,
			3052,
			3053,
			3054,
			3055,
			3056,
			3059,
			3101,
			3102,
			3103,
			3104,
			3105,
			3106,
			3107,
			3108,
			3109,
			3110,
			3111,
			3112,
			3113,
			4001,
			4002,
			4003,
			4004,
			4005,
			4006,
			4007,
			4008,
			4009,
			4010,
			4011,
			4012,
			4013,
			4014,
			100000,
			100001,
			100002,
			100003,
			100011,
			100012,
			100013,
			100021,
			100022,
			100023,
			100031,
			100032,
			100033,
			100041,
			100042,
			100043,
			100051,
			100052,
			100053,
			100061,
			100062,
			100063,
			100101,
			100102,
			100103,
			100201,
			200001,
			200002,
			200003,
			200004,
			200005,
			200006,
			200007,
			200008,
			200009,
			200010,
			200011,
			200012,
			200013,
			200014,
			200015
		},
		usage_island_gift = {
			110001,
			110002,
			110003,
			110004,
			110005,
			110006
		}
	},
	get_id_list_by_type = {
		[3] = {
			1,
			5,
			6,
			7,
			8,
			9
		},
		[4] = {
			2
		},
		[2] = {
			3,
			4,
			100000,
			100011,
			100012,
			100013,
			100021,
			100022,
			100023,
			100031,
			100032,
			100033,
			100041,
			100042,
			100043,
			100051,
			100052,
			100053,
			100061,
			100062,
			100063,
			100101,
			100102,
			100103,
			100201,
			110001,
			110002,
			110003,
			110004,
			110005,
			110006,
			200001,
			200002,
			200003,
			200004,
			200005,
			200006,
			200007,
			200008,
			200009,
			200010,
			200011,
			200012,
			200013,
			200014,
			200015
		},
		{
			1000,
			1001,
			1002,
			1003,
			1004,
			1005,
			1006,
			1007,
			1008,
			1009,
			1010,
			1011,
			1012,
			1014,
			1015,
			1016,
			1017,
			1018,
			1019,
			1020,
			1021,
			1022,
			1501,
			2000,
			2001,
			2002,
			2003,
			2004,
			2005,
			2006,
			2007,
			2008,
			2009,
			2010,
			2011,
			2012,
			2014,
			2015,
			2016,
			2017,
			2018,
			2019,
			2020,
			2021,
			2022,
			2600,
			2601,
			2602,
			2603,
			2604,
			2605,
			2606,
			2700,
			2701,
			2702,
			2703,
			2704,
			2705,
			2800,
			2801,
			2802,
			2803,
			3000,
			3001,
			3002,
			3003,
			3004,
			3005,
			3006,
			3007,
			3008,
			3009,
			3010,
			3011,
			3012,
			3013,
			3014,
			3015,
			3016,
			3017,
			3018,
			3019,
			3020,
			3021,
			3022,
			3023,
			3024,
			3025,
			3026,
			3028,
			3029,
			3030,
			3031,
			3032,
			3033,
			3034,
			3035,
			3036,
			3037,
			3038,
			3039,
			3040,
			3041,
			3042,
			3043,
			3044,
			3045,
			3046,
			3047,
			3048,
			3049,
			3050,
			3051,
			3052,
			3053,
			3054,
			3055,
			3056,
			3059,
			3101,
			3102,
			3103,
			3104,
			3105,
			3106,
			3107,
			3108,
			3109,
			3110,
			3111,
			3112,
			3113,
			4001,
			4002,
			4003,
			4004,
			4005,
			4006,
			4007,
			4008,
			4009,
			4010,
			4011,
			4012,
			4013,
			4014
		},
		[5] = {
			100001,
			100002,
			100003
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
		1000,
		1001,
		1002,
		1003,
		1004,
		1005,
		1006,
		1007,
		1008,
		1009,
		1010,
		1011,
		1012,
		1014,
		1015,
		1016,
		1017,
		1018,
		1019,
		1020,
		1021,
		1022,
		1501,
		2000,
		2001,
		2002,
		2003,
		2004,
		2005,
		2006,
		2007,
		2008,
		2009,
		2010,
		2011,
		2012,
		2014,
		2015,
		2016,
		2017,
		2018,
		2019,
		2020,
		2021,
		2022,
		2600,
		2601,
		2602,
		2603,
		2604,
		2605,
		2606,
		2700,
		2701,
		2702,
		2703,
		2704,
		2705,
		2800,
		2801,
		2802,
		2803,
		3000,
		3001,
		3002,
		3003,
		3004,
		3005,
		3006,
		3007,
		3008,
		3009,
		3010,
		3011,
		3012,
		3013,
		3014,
		3015,
		3016,
		3017,
		3018,
		3019,
		3020,
		3021,
		3022,
		3023,
		3024,
		3025,
		3026,
		3028,
		3029,
		3030,
		3031,
		3032,
		3033,
		3034,
		3035,
		3036,
		3037,
		3038,
		3039,
		3040,
		3041,
		3042,
		3043,
		3044,
		3045,
		3046,
		3047,
		3048,
		3049,
		3050,
		3051,
		3052,
		3053,
		3054,
		3055,
		3056,
		3059,
		3101,
		3102,
		3103,
		3104,
		3105,
		3106,
		3107,
		3108,
		3109,
		3110,
		3111,
		3112,
		3113,
		4001,
		4002,
		4003,
		4004,
		4005,
		4006,
		4007,
		4008,
		4009,
		4010,
		4011,
		4012,
		4013,
		4014,
		100000,
		100001,
		100002,
		100003,
		100011,
		100012,
		100013,
		100021,
		100022,
		100023,
		100031,
		100032,
		100033,
		100041,
		100042,
		100043,
		100051,
		100052,
		100053,
		100061,
		100062,
		100063,
		100101,
		100102,
		100103,
		100201,
		110001,
		110002,
		110003,
		110004,
		110005,
		110006,
		200001,
		200002,
		200003,
		200004,
		200005,
		200006,
		200007,
		200008,
		200009,
		200010,
		200011,
		200012,
		200013,
		200014,
		200015
	}
}, confHX)
pg.base = pg.base or {}
pg.base.island_item_data_template = {
	{
		group_max = 0,
		name = "Development Funds",
		manage_influence = 0,
		type = 3,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "Currency used around the development area. The foundation of continued development.",
		usage = "usage_undefined",
		order_price = 1,
		icon = "Islandprops/1",
		price = 0,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 1,
		have_max = 0,
		filter = {
			10312
		},
		sub_attribute = {},
		jump_page = {}
	},
	{
		group_max = 0,
		name = "Development EXP",
		manage_influence = 0,
		type = 4,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "Island development experience. Accumulate it to increase your development level.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "Islandprops/2",
		price = 0,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2,
		have_max = 0,
		filter = {
			10312
		},
		sub_attribute = {},
		jump_page = {}
	},
	{
		group_max = 0,
		name = "Outfit Colors",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A palette containing various dyes. Allows you to recolor outfits and give yourself a truly unique look!",
		usage = "usage_undefined",
		order_price = 0,
		icon = "Islandprops/3",
		price = 0,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3,
		have_max = 0,
		filter = {
			10312
		},
		sub_attribute = {},
		jump_page = {}
	},
	{
		group_max = 0,
		name = "Building Permit",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A building permit for Get-Together Island. Use it to rebuild the island just the way you like it.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "islandprops/4",
		price = 0,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 4,
		have_max = 0,
		filter = {
			10312
		},
		sub_attribute = {},
		jump_page = {}
	},
	{
		group_max = 0,
		name = "Map Fragment - 1",
		manage_influence = 0,
		type = 3,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A mysterious piece of paper. Its crooked lines seem to conceal some sort of secret.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "islandprops/Item_5",
		price = 0,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 5,
		have_max = 5,
		filter = {
			10311
		},
		sub_attribute = {},
		jump_page = {}
	},
	{
		group_max = 0,
		name = "Map Fragment - 2",
		manage_influence = 0,
		type = 3,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A mysterious piece of paper. Its crooked lines seem to conceal some sort of secret.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "islandprops/Item_5",
		price = 0,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 6,
		have_max = 0,
		filter = {
			10311
		},
		sub_attribute = {},
		jump_page = {}
	},
	{
		group_max = 0,
		name = "Map Fragment - 3",
		manage_influence = 0,
		type = 3,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A mysterious piece of paper. Its crooked lines seem to conceal some sort of secret.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "islandprops/Item_5",
		price = 0,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 7,
		have_max = 0,
		filter = {
			10311
		},
		sub_attribute = {},
		jump_page = {}
	},
	{
		group_max = 0,
		name = "Map Fragment - 4",
		manage_influence = 0,
		type = 3,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A mysterious piece of paper. Its crooked lines seem to conceal some sort of secret.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "islandprops/Item_5",
		price = 0,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 8,
		have_max = 0,
		filter = {
			10311
		},
		sub_attribute = {},
		jump_page = {}
	},
	{
		group_max = 0,
		name = "Map Fragment - 5",
		manage_influence = 0,
		type = 3,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A mysterious piece of paper. Its crooked lines seem to conceal some sort of secret.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "islandprops/Item_5",
		price = 0,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 9,
		have_max = 0,
		filter = {
			10311
		},
		sub_attribute = {},
		jump_page = {}
	},
	[1000] = {
		group_max = 0,
		name = "Wheat Seeds",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "A bunch of the port's premium wheat seeds. Can be used to grow quality wheat.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_1000",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 1000,
		have_max = 0,
		filter = {
			10114,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[1001] = {
		group_max = 0,
		name = "Corn Seeds",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "A bunch of the port's premium corn seeds. They're filled with the power of a bountiful harvest.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_1001",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 1001,
		have_max = 0,
		filter = {
			10114,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[1002] = {
		group_max = 0,
		name = "Upland Rice Seeds",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "A bunch of the port's premium upland rice seeds. Just plant and wait for the harvest.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_1002",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 1002,
		have_max = 0,
		filter = {
			10114,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[1003] = {
		group_max = 0,
		name = "Napa Cabbage Seeds",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "A bunch of the port's premium napa cabbage seeds. Can be used to grow crisp and large cabbages.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_1003",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 1003,
		have_max = 0,
		filter = {
			10114,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[1004] = {
		group_max = 0,
		name = "Carrot Seeds",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "A bunch of the port's premium carrot seeds. Can be used to grow sweet carrots.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_1004",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 1004,
		have_max = 0,
		filter = {
			10114,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[1005] = {
		group_max = 0,
		name = "Potato Seeds",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "A bunch of the port's premium potato seeds. Can be used to grow a large harvest of potatoes.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_1005",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 1005,
		have_max = 0,
		filter = {
			10114,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[1006] = {
		group_max = 0,
		name = "Soy Bean Seeds",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "A bunch of the port's premium soy bean seeds. Can be used to grow quality soy beans.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_1006",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 1006,
		have_max = 0,
		filter = {
			10114,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[1007] = {
		group_max = 0,
		name = "Onion Seeds",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "A bunch of the port's premium onion seeds. Can be used to grow luscious onions.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_1007",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 1007,
		have_max = 0,
		filter = {
			10114,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[1008] = {
		group_max = 0,
		name = "Grass Seeds",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "A bunch of the port's premium grass seeds. Can be used to grow loads of grass.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_1008",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 1008,
		have_max = 0,
		filter = {
			10114,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[1009] = {
		group_max = 0,
		name = "Coffee Tree Seeds",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "A bunch of the port's premium coffee tree seeds. Can be used to grow flavorful coffee beans.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_1009",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 1009,
		have_max = 0,
		filter = {
			10114,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[1010] = {
		group_max = 0,
		name = "Flax Seeds",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "A bunch of the port's premium flax seeds. Grows fast and yields long, sturdy fibers. A great material for spinning thread.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_1010",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 1010,
		have_max = 0,
		filter = {
			10114,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[1011] = {
		group_max = 0,
		name = "Strawberry Seeds",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "A bunch of the port's premium strawberry seeds. Can be used to grow brilliantly red strawberries.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_1011",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 1011,
		have_max = 0,
		filter = {
			10114,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[1012] = {
		group_max = 0,
		name = "Cotton Seeds",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "A bunch of the port's premium cotton seeds. Can be used to grow soft cotton.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_1012",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 1012,
		have_max = 0,
		filter = {
			10114,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[1014] = {
		group_max = 0,
		name = "Tea Tree Seeds",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "A bunch of the port's premium tea tree seeds. Can be used to grow quality tea leaves.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_1014",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 1014,
		have_max = 0,
		filter = {
			10114,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[1015] = {
		group_max = 0,
		name = "Lavender Seeds",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "A bunch of the port's premium lavender seeds. Can be used to grow purple flowers.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_1015",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 1015,
		have_max = 0,
		filter = {
			10114,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[1016] = {
		group_max = 0,
		name = "Apple Tree Seeds",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "Seeds from the excellent apple trees grown at the port. Can be used to grow crisp and delicious apples.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_1016",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 1016,
		have_max = 0,
		filter = {
			10114,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[1017] = {
		group_max = 0,
		name = "Citrus Fruit Tree Seeds",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "Seeds from the excellent citrus trees grown at the port. Can be used to grow sweet and juicy citrus fruits.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_1017",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 1017,
		have_max = 0,
		filter = {
			10114,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[1018] = {
		group_max = 0,
		name = "Banana Tree Seed",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "Seeds from the excellent banana trees grown at the port. Can be used to grow tender bananas.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_1018",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 1018,
		have_max = 0,
		filter = {
			10114,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[1019] = {
		group_max = 0,
		name = "Mango Tree Seeds",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "Seeds from the excellent mango trees grown at the port. Can be used to grow sweet mangos.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_1019",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 1019,
		have_max = 0,
		filter = {
			10114,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[1020] = {
		group_max = 0,
		name = "Lemon Tree Seed",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "Seeds from the excellent lemon trees grown at the port. Can be used to grow refreshing lemons.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_1020",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 1020,
		have_max = 0,
		filter = {
			10114,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[1021] = {
		group_max = 0,
		name = "Avocado Tree Seeds",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "Seeds from the excellent avocado trees grown at the port. Can be used to grow nutritious avocados.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_1021",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 1021,
		have_max = 0,
		filter = {
			10114,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[1022] = {
		group_max = 0,
		name = "Rubber Tree Seeds",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "Can be cultivated and harvested at any time. It's available all year round!",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_1022",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 1022,
		have_max = 0,
		filter = {
			10114,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[1501] = {
		group_max = 0,
		name = "Corn",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 0,
		desc = "Ripe, golden corn. It lends a sweet smell to the fields.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_1501",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 1501,
		have_max = 0,
		filter = {
			10114,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2000] = {
		group_max = 0,
		name = "Wheat",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "Fresh wheat straight from the fields. The base ingredient needed to make flour.",
		usage = "usage_undefined",
		order_price = 35,
		icon = "IslandProps/item_2000",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2000,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2001] = {
		group_max = 0,
		name = "Corn",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "Ripe, golden corn. It lends a sweet smell to the fields.",
		usage = "usage_undefined",
		order_price = 210,
		icon = "IslandProps/item_2001",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2001,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2002] = {
		group_max = 0,
		name = "Rice",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "White, high-quality rice. Contains plentiful starch and granular protein.",
		usage = "usage_undefined",
		order_price = 155,
		icon = "IslandProps/item_2002",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2002,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2003] = {
		group_max = 0,
		name = "Napa Cabbage",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "Crisp and delicious napa cabbage. It's straight from the farm!",
		usage = "usage_undefined",
		order_price = 170,
		icon = "IslandProps/item_2003",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2003,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2004] = {
		group_max = 0,
		name = "Carrot",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "A common household vegetable. Sweet and full of nutrients.",
		usage = "usage_undefined",
		order_price = 130,
		icon = "IslandProps/item_2004",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2004,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2005] = {
		group_max = 0,
		name = "Potato",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "The king of starch in the vegetable world. Can be prepared in all kinds of ways.",
		usage = "usage_undefined",
		order_price = 250,
		icon = "IslandProps/item_2005",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2005,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2006] = {
		group_max = 0,
		name = "Soy Beans",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "Round, fluffy, and filled with protein. Has all sorts of uses, not just in cooking, but in manufacturing as well.",
		usage = "usage_undefined",
		order_price = 72,
		icon = "IslandProps/item_2006",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2006,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2007] = {
		group_max = 0,
		name = "Onion",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 24,
		desc = "Try not to cry when you peel it!",
		usage = "usage_undefined",
		order_price = 480,
		icon = "IslandProps/item_2007",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2007,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2008] = {
		group_max = 0,
		name = "Grass",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "High-quality grass. Provides life in abundance to the farm!",
		usage = "usage_undefined",
		order_price = 45,
		icon = "IslandProps/item_2008",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2008,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2009] = {
		group_max = 0,
		name = "Coffee Beans",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 6,
		desc = "Fragrant and reinvigorating. Care for a cup?",
		usage = "usage_undefined",
		order_price = 640,
		icon = "IslandProps/item_2009",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2009,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2010] = {
		group_max = 0,
		name = "Flax",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 6,
		desc = "A flower with long fibers suited for making threads and textiles. Perfect for your workshop!",
		usage = "usage_undefined",
		order_price = 4,
		icon = "IslandProps/item_2010",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2010,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2011] = {
		group_max = 0,
		name = "Strawberries",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 5,
		desc = "Deep red, juicy, and sweet and sour at the same time. Pairs wonderfully with desserts.",
		usage = "usage_undefined",
		order_price = 6,
		icon = "IslandProps/item_2011",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2011,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2012] = {
		group_max = 0,
		name = "Cotton",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 6,
		desc = "White and soft cotton. An essential ingredient in thread-spinning.",
		usage = "usage_undefined",
		order_price = 8,
		icon = "IslandProps/item_2012",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2012,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2014] = {
		group_max = 0,
		name = "Tea Leaves",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 14,
		desc = "They give off a bitter yet clean aroma. Savor a taste of nature.",
		usage = "usage_undefined",
		order_price = 12,
		icon = "IslandProps/item_2014",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2014,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2015] = {
		group_max = 0,
		name = "Lavender",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 35,
		desc = "Not only do these aromatic flowers add color to your garden, but you can also extract essential oils from them.",
		usage = "usage_undefined",
		order_price = 2,
		icon = "IslandProps/item_2015",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2015,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2016] = {
		group_max = 0,
		name = "Apple",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "Sour, juicy, and loaded with all kinds of vitamins, it can be turned into juice or eaten as it is.",
		usage = "usage_undefined",
		order_price = 4,
		icon = "IslandProps/item_2016",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2016,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2017] = {
		group_max = 0,
		name = "Citrus Fruit",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "Cheap and long-lasting fruit with a fresh fragrance.",
		usage = "usage_undefined",
		order_price = 6,
		icon = "IslandProps/item_2017",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2017,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2018] = {
		group_max = 0,
		name = "Banana",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "A tropical fruit that's sweet, soft, and rich in dietary fiber.",
		usage = "usage_undefined",
		order_price = 8,
		icon = "IslandProps/item_2018",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2018,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2019] = {
		group_max = 0,
		name = "Mango",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 18,
		desc = "A summer fruit with smooth flesh. Very sweet, juicy, and delicious.",
		usage = "usage_undefined",
		order_price = 10,
		icon = "IslandProps/item_2019",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2019,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2020] = {
		group_max = 0,
		name = "Lemon",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 3,
		desc = "Its skin has a fresh aroma and its flesh is perfectly sour. Used in cooking to adjust the flavor.",
		usage = "usage_undefined",
		order_price = 12,
		icon = "IslandProps/item_2020",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2020,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2021] = {
		group_max = 0,
		name = "Avocado",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 45,
		desc = "Its flesh is smooth and creamy. Being low in calories, it's both tasty and healthy.",
		usage = "usage_undefined",
		order_price = 2,
		icon = "IslandProps/item_2021",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2021,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2022] = {
		group_max = 0,
		name = "Rubber",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 30,
		desc = "A highly elastic ingredient commonly used in manufacturing. Its uses are many!",
		usage = "usage_undefined",
		order_price = 4,
		icon = "IslandProps/item_2022",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2022,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2600] = {
		group_max = 0,
		name = "Fresh Meat",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 2,
		desc = "Meat freshly harvested from an animal. It's a high-quality source of protein.",
		usage = "usage_undefined",
		order_price = 450,
		icon = "IslandProps/item_2600",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2600,
		have_max = 0,
		filter = {
			10111,
			10122
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2601] = {
		group_max = 0,
		name = "Eggs",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "Brown eggs. Often used in cooking.",
		usage = "usage_undefined",
		order_price = 240,
		icon = "IslandProps/item_2601",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2601,
		have_max = 0,
		filter = {
			10111,
			10122
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2602] = {
		group_max = 0,
		name = "Poultry",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "Meat high in protein and low in fat. Suited for all kinds of dishes.",
		usage = "usage_undefined",
		order_price = 350,
		icon = "IslandProps/item_2602",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2602,
		have_max = 0,
		filter = {
			10111,
			10122
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2603] = {
		group_max = 0,
		name = "Milk",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "An all-natural drink. Can be processed into yogurt or cheese.",
		usage = "usage_undefined",
		order_price = 450,
		icon = "IslandProps/item_2603",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2603,
		have_max = 0,
		filter = {
			10111,
			10122
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2604] = {
		group_max = 0,
		name = "Pelt",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 10,
		desc = "Simply prepared animal pelt. Can be tanned and turned into leather.",
		usage = "usage_undefined",
		order_price = 1800,
		icon = "IslandProps/item_2604",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2604,
		have_max = 0,
		filter = {
			10111,
			10122
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2605] = {
		group_max = 0,
		name = "Wool",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 72,
		desc = "Harvested animal hair. A core ingredient in the production of fabrics.",
		usage = "usage_undefined",
		order_price = 1400,
		icon = "IslandProps/item_2605",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2605,
		have_max = 0,
		filter = {
			10111,
			10122
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2606] = {
		group_max = 0,
		name = "Fresh Honey",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 2,
		desc = "Honey straight from the hive. It's full of natural, rich aroma.",
		usage = "usage_undefined",
		order_price = 8,
		icon = "IslandProps/item_2606",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2606,
		have_max = 0,
		filter = {
			10111,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2700] = {
		group_max = 0,
		name = "Coal",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "A fundamental type of fuel. It burns very efficiently and is often used in heating and manufacturing.",
		usage = "usage_undefined",
		order_price = 12,
		icon = "IslandProps/item_2700",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2700,
		have_max = 0,
		filter = {
			10111,
			10123
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2701] = {
		group_max = 0,
		name = "Copper Ore",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "Ore that's rich in copper. Once refined, it's often used in the production of electronics.",
		usage = "usage_undefined",
		order_price = 400,
		icon = "IslandProps/item_2701",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2701,
		have_max = 0,
		filter = {
			10111,
			10123
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2702] = {
		group_max = 0,
		name = "Bauxite Ore",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 30,
		desc = "Ore that's rich in aluminum. Once refined, it's often used in the manufacturing of aircraft and ships.",
		usage = "usage_undefined",
		order_price = 580,
		icon = "IslandProps/item_2702",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2702,
		have_max = 0,
		filter = {
			10111,
			10123
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2703] = {
		group_max = 0,
		name = "Iron Ore",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 18,
		desc = "Ore that's rich in iron. Once refined, it's often used in the construction of buildings and structures.",
		usage = "usage_undefined",
		order_price = 760,
		icon = "IslandProps/item_2703",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2703,
		have_max = 0,
		filter = {
			10111,
			10123
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2704] = {
		group_max = 0,
		name = "Sulfur",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 80,
		desc = "A deposit that's rich in sulfur. Once refined, it's often used in the manufacturing of fertilizers and insecticides.",
		usage = "usage_undefined",
		order_price = 920,
		icon = "IslandProps/item_2704",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2704,
		have_max = 0,
		filter = {
			10111,
			10123
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2705] = {
		group_max = 0,
		name = "Silver Ore",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 240,
		desc = "Ore that's rich in silver. Once refined, it's often used in the manufacturing of alloys and chemical instruments.",
		usage = "usage_undefined",
		order_price = 1100,
		icon = "IslandProps/item_2705",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2705,
		have_max = 0,
		filter = {
			10111,
			10123
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2800] = {
		group_max = 0,
		name = "Raw Timber",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "A basic material. It has many applications, ranging from construction to making paper.",
		usage = "usage_undefined",
		order_price = 12,
		icon = "IslandProps/item_2800",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2800,
		have_max = 0,
		filter = {
			10111,
			10124
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2801] = {
		group_max = 0,
		name = "Workable Wood",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "With its beautiful grain, it's perfect for creating furniture or flooring.",
		usage = "usage_undefined",
		order_price = 400,
		icon = "IslandProps/item_2801",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2801,
		have_max = 0,
		filter = {
			10111,
			10124
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2802] = {
		group_max = 0,
		name = "Premium Wood",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 36,
		desc = "Solid and durable, it's used in the making of high-end furniture and traditional shipbuilding.",
		usage = "usage_undefined",
		order_price = 760,
		icon = "IslandProps/item_2802",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2802,
		have_max = 0,
		filter = {
			10111,
			10124
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[2803] = {
		group_max = 0,
		name = "Elegant Wood",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 180,
		desc = "Pretty and durable. Suited for making luxury decorations and furniture.",
		usage = "usage_undefined",
		order_price = 1200,
		icon = "IslandProps/item_2803",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 2803,
		have_max = 0,
		filter = {
			10111,
			10124
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3000] = {
		group_max = 0,
		name = "Clucky Clucky Bird Feed",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "High-protein feed for the clucky clucky bird. Provides it with all the energy it needs.",
		usage = "usage_undefined",
		order_price = 290,
		icon = "IslandProps/item_3000",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3000,
		have_max = 0,
		filter = {
			10112,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3001] = {
		group_max = 0,
		name = "Oinky Oinky Pig Feed",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "Fattening feed for the oinky oinky pig. Perfect for a growing animal.",
		usage = "usage_undefined",
		order_price = 400,
		icon = "IslandProps/item_3001",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3001,
		have_max = 0,
		filter = {
			10112,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3002] = {
		group_max = 0,
		name = "Moo Moo Cow Feed",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 4,
		desc = "Nutritional feed for the moo moo cow. Fragrant and aids in the production of rich milk.",
		usage = "usage_undefined",
		order_price = 350,
		icon = "IslandProps/item_3002",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3002,
		have_max = 0,
		filter = {
			10112,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3003] = {
		group_max = 0,
		name = "Baa Baa Sheep Feed",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 4,
		desc = "Cornmeal feed for the baa baa sheep. Helps promote the growth of softer wool.",
		usage = "usage_undefined",
		order_price = 400,
		icon = "IslandProps/item_3003",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3003,
		have_max = 0,
		filter = {
			10112,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3004] = {
		group_max = 0,
		name = "Flour",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "White flour made from grinding wheat. Needed to make bread, cakes, and pizzas.",
		usage = "usage_undefined",
		order_price = 400,
		icon = "IslandProps/item_3004",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3004,
		have_max = 0,
		filter = {
			10112,
			10127
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3005] = {
		group_max = 0,
		name = "Iced Coffee",
		manage_influence = 560,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "A refreshing flavor that's sure to top up your batteries!",
		usage = "usage_undefined",
		order_price = 1400,
		icon = "IslandProps/item_3005",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3005,
		have_max = 0,
		filter = {
			10113,
			10126
		},
		sub_attribute = {
			5,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3006] = {
		group_max = 0,
		name = "Cheese",
		manage_influence = 560,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 55,
		desc = "Made from milk, it contains loads of protein and fat. Frequently combined with bread.",
		usage = "usage_undefined",
		order_price = 1400,
		icon = "IslandProps/item_3006",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3006,
		have_max = 0,
		filter = {
			10113,
			10126
		},
		sub_attribute = {
			3,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3007] = {
		group_max = 0,
		name = "Latte",
		manage_influence = 1000,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 25,
		desc = "An espresso combined with milk. Very aromatic and smooth, it's a favorite among coffee lovers.",
		usage = "usage_undefined",
		order_price = 2500,
		icon = "IslandProps/item_3007",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3007,
		have_max = 0,
		filter = {
			10113,
			10126
		},
		sub_attribute = {
			4,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3008] = {
		group_max = 0,
		name = "Citrus Coffee",
		manage_influence = 110,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 20,
		desc = "A coffee beverage with citrus juice added. Its pleasant acidity and fruity smell are its standout traits.",
		usage = "usage_undefined",
		order_price = 10,
		icon = "IslandProps/item_3008",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3008,
		have_max = 0,
		filter = {
			10113,
			10126
		},
		sub_attribute = {
			5,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3009] = {
		group_max = 0,
		name = "Apple Pie",
		manage_influence = 400,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 35,
		desc = "A sweet pie consisting of candied apples put inside the crust. A commonplace dessert.",
		usage = "usage_undefined",
		order_price = 1000,
		icon = "IslandProps/item_3009",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3009,
		have_max = 0,
		filter = {
			10113,
			10126
		},
		sub_attribute = {
			3,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3010] = {
		group_max = 0,
		name = "Strawberry Milkshake",
		manage_influence = 120,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 25,
		desc = "It's smooth as velvet, cool, and airy, with a rich flavor.",
		usage = "usage_undefined",
		order_price = 2,
		icon = "IslandProps/item_3010",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3010,
		have_max = 0,
		filter = {
			10113,
			10126
		},
		sub_attribute = {
			4,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3011] = {
		group_max = 0,
		name = "Tofu",
		manage_influence = 220,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 35,
		desc = "White and soft. Made from soy beans, it contains plant-based proteins in abundance.",
		usage = "usage_undefined",
		order_price = 550,
		icon = "IslandProps/item_3011",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3011,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			5,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3012] = {
		group_max = 0,
		name = "Tofu with Minced Meat",
		manage_influence = 840,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 155,
		desc = "A traditional Dragon Empery dish. The texture is silky-smooth, and the sauce is rich and delicious.",
		usage = "usage_undefined",
		order_price = 2100,
		icon = "IslandProps/item_3012",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3012,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			3,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3013] = {
		group_max = 0,
		name = "Omurice",
		manage_influence = 760,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 35,
		desc = "Fluffy rice wrapped in a thin, golden omelette. A surprise awaits in each bite!",
		usage = "usage_undefined",
		order_price = 1900,
		icon = "IslandProps/item_3013",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3013,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			4,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3014] = {
		group_max = 0,
		name = "Cabbage and Tofu Soup",
		manage_influence = 1040,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 40,
		desc = "The sweetness of napa cabbage and the umami flavor of tofu. A light and healthy dish.",
		usage = "usage_undefined",
		order_price = 2600,
		icon = "IslandProps/item_3014",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3014,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			5,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3015] = {
		group_max = 0,
		name = "Vegetable Salad",
		manage_influence = 580,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 10,
		desc = "Fresh veggies combined with a nice dressing. Crisp and delicious!",
		usage = "usage_undefined",
		order_price = 1450,
		icon = "IslandProps/item_3015",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3015,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			3,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3016] = {
		group_max = 0,
		name = "Fish and Chips",
		manage_influence = 120,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 0,
		desc = "The fish is crunchy on the outside and soft on the inside while the chips are aromatic and delectable. A dish loved by many people!",
		usage = "usage_undefined",
		order_price = 2,
		icon = "IslandProps/item_3016",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3016,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			4,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3017] = {
		group_max = 0,
		name = "Apple Juice",
		manage_influence = 100,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 10,
		desc = "Freshly squeezed juice with a pronounced fruity aroma. A popular and healthy drink!",
		usage = "usage_undefined",
		order_price = 4,
		icon = "IslandProps/item_3017",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3017,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			5,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3018] = {
		group_max = 0,
		name = "Banana and Mango Juice",
		manage_influence = 100,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 20,
		desc = "The perfect combination of banana and mango. It's pure, concentrated tropical flavor!",
		usage = "usage_undefined",
		order_price = 6,
		icon = "IslandProps/item_3018",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3018,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			3,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3019] = {
		group_max = 0,
		name = "Honey and Lemon Water",
		manage_influence = 100,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 15,
		desc = "A sublime pairing of sweet honey and refreshing lemon. A good source of vitamin C.",
		usage = "usage_undefined",
		order_price = 8,
		icon = "IslandProps/item_3019",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3019,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			4,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3020] = {
		group_max = 0,
		name = "Strawberry Lemon Drink",
		manage_influence = 100,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 25,
		desc = "A fruity combination of strawberries and lemons. Cooling and great for blowing off the summer heat!",
		usage = "usage_undefined",
		order_price = 8,
		icon = "IslandProps/item_3020",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3020,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			4,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3021] = {
		group_max = 0,
		name = "Lavender Tea",
		manage_influence = 120,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 240,
		desc = "It soothes your heart, relieves stress, and clears your mind and body.",
		usage = "usage_undefined",
		order_price = 12,
		icon = "IslandProps/item_3021",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3021,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			3,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3022] = {
		group_max = 0,
		name = "Strawberry Honey Frappé",
		manage_influence = 120,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 95,
		desc = "A sweet coffee. The sweet and sour flavor of the strawberries melds perfectly with the mellowness of the honey.",
		usage = "usage_undefined",
		order_price = 2,
		icon = "IslandProps/item_3022",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3022,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			4,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3023] = {
		group_max = 0,
		name = "Corn Cup",
		manage_influence = 100,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 4,
		desc = "Lightly steamed, golden corn kernels put into a cup. A common and yummy snack.",
		usage = "usage_undefined",
		order_price = 4,
		icon = "IslandProps/item_3023",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3023,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			5,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3024] = {
		group_max = 0,
		name = "Orange Pie",
		manage_influence = 100,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 35,
		desc = "A classic dessert. Tastes even better when you have it with afternoon tea.",
		usage = "usage_undefined",
		order_price = 6,
		icon = "IslandProps/item_3024",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3024,
		have_max = 0,
		filter = {
			10113,
			10126
		},
		sub_attribute = {
			3,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3025] = {
		group_max = 0,
		name = "Sticky Rice with Mango",
		manage_influence = 100,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 60,
		desc = "A homely dish brimming with tropical taste. Great for when you don't have an appetite.",
		usage = "usage_undefined",
		order_price = 8,
		icon = "IslandProps/item_3025",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3025,
		have_max = 0,
		filter = {
			10113,
			10126
		},
		sub_attribute = {
			4,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3026] = {
		group_max = 0,
		name = "Banana Crêpe",
		manage_influence = 110,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 30,
		desc = "A classic breakfast item. It's crunchy and loved by men and women of all ages.",
		usage = "usage_undefined",
		order_price = 10,
		icon = "IslandProps/item_3026",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3026,
		have_max = 0,
		filter = {
			10113,
			10126
		},
		sub_attribute = {
			5,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3028] = {
		group_max = 0,
		name = "Strawberry Charlotte",
		manage_influence = 120,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 200,
		desc = "A beloved food among dessert lovers, this cake is made with crispy meringue dough and sweet strawberry mousse.",
		usage = "usage_undefined",
		order_price = 2,
		icon = "IslandProps/item_3028",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3028,
		have_max = 0,
		filter = {
			10113,
			10126
		},
		sub_attribute = {
			4,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3029] = {
		group_max = 0,
		name = "Coal-Roasted Skewer",
		manage_influence = 100,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 40,
		desc = "Crispy on the outside and tender on the inside, with a fragrant aroma. An indispensable dish at barbecue parties!",
		usage = "usage_undefined",
		order_price = 950,
		icon = "IslandProps/item_3029",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3029,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			4,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3030] = {
		group_max = 0,
		name = "Chicken and Potato Hors d'Oeuvre",
		manage_influence = 110,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 36,
		desc = "A straightforward and delicious meal that's often seen on the dinner table at home!",
		usage = "usage_undefined",
		order_price = 1600,
		icon = "IslandProps/item_3030",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3030,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			5,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3031] = {
		group_max = 0,
		name = "Lemon Shrimp",
		manage_influence = 120,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 0,
		desc = "The tenderness of the shrimp and the sourness of the lemons play well with each other. A refreshing dish that stimulates your appetite.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_3031",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3031,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			4,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3032] = {
		group_max = 0,
		name = "Stir-Fried Chicken",
		manage_influence = 100,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 70,
		desc = "A dish of chicken stir-fried with spices. Its fragrance makes you hungry!",
		usage = "usage_undefined",
		order_price = 2200,
		icon = "IslandProps/item_3032",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3032,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			4,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3033] = {
		group_max = 0,
		name = "Rolled Carrot Omelette",
		manage_influence = 110,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 16,
		desc = "A thin omelette wrapped with sweet carrots resulting in a complex flavor. A great choice for breakfast or as an afternoon snack!",
		usage = "usage_undefined",
		order_price = 980,
		icon = "IslandProps/item_3033",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3033,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			5,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3034] = {
		group_max = 0,
		name = "Steak Bowl",
		manage_influence = 120,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 100,
		desc = "Filling and quick to prepare, this is a dish for those who like to be efficient!",
		usage = "usage_undefined",
		order_price = 1200,
		icon = "IslandProps/item_3034",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3034,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			4,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3035] = {
		group_max = 0,
		name = "Cloth",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 34,
		desc = "Basic cloth made from material containing fiber. A base material in many day-to-day products and industrial goods.",
		usage = "usage_undefined",
		order_price = 4,
		icon = "IslandProps/item_3035",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3035,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3036] = {
		group_max = 0,
		name = "Leather",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 60,
		desc = "Processed animal pelts. Often used in the production of clothing and furniture.",
		usage = "usage_undefined",
		order_price = 6,
		icon = "IslandProps/item_3036",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3036,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3037] = {
		group_max = 0,
		name = "Rope",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 72,
		desc = "Firm and strong. Can be used to tie things up, of course, but also helps to hold scaffoldings in place.",
		usage = "usage_undefined",
		order_price = 8,
		icon = "IslandProps/item_3037",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3037,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3038] = {
		group_max = 0,
		name = "Gloves",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 105,
		desc = "An essential household item for keeping warm. You don't want to go out on a cold day without these.",
		usage = "usage_undefined",
		order_price = 10,
		icon = "IslandProps/item_3038",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3038,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3039] = {
		group_max = 0,
		name = "Aroma Sachet",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 130,
		desc = "A sachet filled with herbs and spices. Bring the freshness with you wherever you go!",
		usage = "usage_undefined",
		order_price = 12,
		icon = "IslandProps/item_3039",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3039,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3040] = {
		group_max = 0,
		name = "Shoes",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 350,
		desc = "A leather product. Worn to protect your feet.",
		usage = "usage_undefined",
		order_price = 2,
		icon = "IslandProps/item_3040",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3040,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3041] = {
		group_max = 0,
		name = "Wound Dressings",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 350,
		desc = "An indispensable medical item. Whether you have a gash or a bruise, this provides immediate treatment.",
		usage = "usage_undefined",
		order_price = 4,
		icon = "IslandProps/item_3041",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3041,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3042] = {
		group_max = 0,
		name = "Charcoal Brush",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 30,
		desc = "An art product often used for sketching and designing on paper.",
		usage = "usage_undefined",
		order_price = 6,
		icon = "IslandProps/item_3042",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3042,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3043] = {
		group_max = 0,
		name = "Cable",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 92,
		desc = "A symbol of modernity used to provide electricity to lots of machinery.",
		usage = "usage_undefined",
		order_price = 8,
		icon = "IslandProps/item_3043",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3043,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3044] = {
		group_max = 0,
		name = "Nails",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 66,
		desc = "An item commonly seen in construction, often being used to fix signs in place or construct furniture.",
		usage = "usage_undefined",
		order_price = 10,
		icon = "IslandProps/item_3044",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3044,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3045] = {
		group_max = 0,
		name = "Chemicals",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 84,
		desc = "Chemicals that are highly corrosive. Used in herbicides and detergents.",
		usage = "usage_undefined",
		order_price = 12,
		icon = "IslandProps/item_3045",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3045,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3046] = {
		group_max = 0,
		name = "Gunpowder",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 150,
		desc = "An essential component in modern weaponry. Must be handled with care.",
		usage = "usage_undefined",
		order_price = 2,
		icon = "IslandProps/item_3046",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3046,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3047] = {
		group_max = 0,
		name = "Utensils",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 380,
		desc = "Tableware that's a must-have in any home.",
		usage = "usage_undefined",
		order_price = 4,
		icon = "IslandProps/item_3047",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3047,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3048] = {
		group_max = 0,
		name = "Paper",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "Often made out of cheap plant fiber. Easy to preserve and write on.",
		usage = "usage_undefined",
		order_price = 6,
		icon = "IslandProps/item_3048",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3048,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3049] = {
		group_max = 0,
		name = "Notebook",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 120,
		desc = "A book filled with descriptions of daily tasks and errands. Can also be used as a diary.",
		usage = "usage_undefined",
		order_price = 8,
		icon = "IslandProps/item_3049",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3049,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3050] = {
		group_max = 0,
		name = "Chair and Desk",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 80,
		desc = "The most common types of furniture. They provide a place to stop and rest.",
		usage = "usage_undefined",
		order_price = 10,
		icon = "IslandProps/item_3050",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3050,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3051] = {
		group_max = 0,
		name = "Choice Wooden Barrel",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 190,
		desc = "A multipurpose barrel used for storing wine, honey, and the like.",
		usage = "usage_undefined",
		order_price = 12,
		icon = "IslandProps/item_3051",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3051,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3052] = {
		group_max = 0,
		name = "Filing Cabinet",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 430,
		desc = "Every self-respecting office has some of these. Nice to have for storing and managing documents of all kinds.",
		usage = "usage_undefined",
		order_price = 2,
		icon = "IslandProps/item_3052",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3052,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3053] = {
		group_max = 0,
		name = "Ink Cartridge",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 55,
		desc = "Stores printing ink. A core part of any printer.",
		usage = "usage_undefined",
		order_price = 4,
		icon = "IslandProps/item_3053",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3053,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3054] = {
		group_max = 0,
		name = "Clock",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 310,
		desc = "Used to tell the time. Usually hung on walls.",
		usage = "usage_undefined",
		order_price = 6,
		icon = "IslandProps/item_3054",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3054,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3055] = {
		group_max = 0,
		name = "Battery",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 210,
		desc = "A reusable and stable power source for motors, lights, and things like that.",
		usage = "usage_undefined",
		order_price = 8,
		icon = "IslandProps/item_3055",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3055,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3056] = {
		group_max = 0,
		name = "Water Filter",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 360,
		desc = "Removes impurities from water and makes it clean!",
		usage = "usage_undefined",
		order_price = 10,
		icon = "IslandProps/item_3056",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3056,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3059] = {
		group_max = 0,
		name = "Omelette",
		manage_influence = 560,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "Tender filling covered with a fluffy egg skin. Golden and tempting, it's a simple but satisfying delicacy.",
		usage = "usage_undefined",
		order_price = 1400,
		icon = "IslandProps/item_3059",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3059,
		have_max = 0,
		filter = {
			10113,
			10126
		},
		sub_attribute = {
			5,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3101] = {
		group_max = 0,
		name = "Classic Tofu Combo",
		manage_influence = 100,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 200,
		desc = "A serving of minced meat with tofu and a soup with napa cabbage and tofu. Straightforward and tasty.",
		usage = "usage_undefined",
		order_price = 10,
		icon = "IslandProps/item_3101",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3101,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			5,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3102] = {
		group_max = 0,
		name = "Hearty Meal",
		manage_influence = 100,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 100,
		desc = "Hearty in more ways than one, this meal consists of fluffy omurice and some warm and smooth tofu. Simple but satisfying flavors.",
		usage = "usage_undefined",
		order_price = 10,
		icon = "IslandProps/item_3102",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3102,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			5,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3103] = {
		group_max = 0,
		name = "Floral and Fruity",
		manage_influence = 100,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 200,
		desc = "The soothing scent of the lavender and the fresh sweetness of the apple come together exquisitely, providing a double-layered kind of enjoyment.",
		usage = "usage_undefined",
		order_price = 10,
		icon = "IslandProps/item_3103",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3103,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			3,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3104] = {
		group_max = 0,
		name = "Colorful Fruit Paradise",
		manage_influence = 100,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 120,
		desc = "A shaved ice set with banana and mango juice and strawberry honey flavor. A fresh and fruity experience you won't forget.",
		usage = "usage_undefined",
		order_price = 10,
		icon = "IslandProps/item_3104",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3104,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			5,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3105] = {
		group_max = 0,
		name = "Sunny Honey",
		manage_influence = 100,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 60,
		desc = "A combination of sweet strawberry honey and honey-lemon water. Its sunny flavor will fill you with energy.",
		usage = "usage_undefined",
		order_price = 10,
		icon = "IslandProps/item_3105",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3105,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			5,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3106] = {
		group_max = 0,
		name = "Succulently Sweet",
		manage_influence = 100,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 65,
		desc = "Fragrant and tropical mango meets a sweet and crispy corn cup. It lets you taste two types of happiness at once.",
		usage = "usage_undefined",
		order_price = 10,
		icon = "IslandProps/item_3106",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3106,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			3,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3107] = {
		group_max = 0,
		name = "Orchard Duo",
		manage_influence = 100,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 70,
		desc = "The softness of the banana crêpe combines with the crunchiness of the golden apple pie into a layered, fruity sweetness.",
		usage = "usage_undefined",
		order_price = 10,
		icon = "IslandProps/item_3107",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3107,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			5,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3108] = {
		group_max = 0,
		name = "Berry and Orange Dessert",
		manage_influence = 100,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 260,
		desc = "The romantic encounter of strawberry and the sunny scent of orange come together for an ecstatic dessert time.",
		usage = "usage_undefined",
		order_price = 10,
		icon = "IslandProps/item_3108",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3108,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			5,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3109] = {
		group_max = 0,
		name = "The Carne-val",
		manage_influence = 100,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 90,
		desc = "Fragrant skewers, soft chicken, and crunchy fries. There's enough here to satisfy anyone's stomach.",
		usage = "usage_undefined",
		order_price = 10,
		icon = "IslandProps/item_3109",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3109,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			3,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3110] = {
		group_max = 0,
		name = "Double Energy Combo",
		manage_influence = 100,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 210,
		desc = "A steak bowl with spicy, stir-fried chicken. If this won't provide you with enough energy and protein for a whole day, nothing will.",
		usage = "usage_undefined",
		order_price = 10,
		icon = "IslandProps/item_3110",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3110,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			5,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3111] = {
		group_max = 0,
		name = "Morning Light Energy Combo",
		manage_influence = 100,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 36,
		desc = "Fluffy omurice and a luxury latte. The perfect start to your day.",
		usage = "usage_undefined",
		order_price = 10,
		icon = "IslandProps/item_3111",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3111,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			5,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3112] = {
		group_max = 0,
		name = "The Wake-Up Call",
		manage_influence = 100,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 80,
		desc = "Iced coffee and rich cheese. This mix of sweet and bitter will give you a classic wake-up call of a breakfast.",
		usage = "usage_undefined",
		order_price = 10,
		icon = "IslandProps/item_3112",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3112,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			3,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[3113] = {
		group_max = 0,
		name = "Fruity & Fruitier",
		manage_influence = 100,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 65,
		desc = "Citrus coffee and a strawberry milkshake. This one-two punch of delicious drinks is sure to satisfy you.",
		usage = "usage_undefined",
		order_price = 10,
		icon = "IslandProps/item_3113",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 3113,
		have_max = 0,
		filter = {
			10113,
			10125
		},
		sub_attribute = {
			3,
			35
		},
		jump_page = {
			{
				"Buy in Shop",
				{
					"IslandShopScene",
					"page = 1"
				}
			}
		}
	},
	[4001] = {
		group_max = 0,
		name = "Autumn Chrysanthemum",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 40,
		desc = "Golden autumn chrysanthemums that sway in the wind. They can be relished both in tea and as ornamental flowers.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_4001",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 4001,
		have_max = 0,
		filter = {
			10111
		},
		sub_attribute = {},
		jump_page = {}
	},
	[4002] = {
		group_max = 0,
		name = "Reed Flowers",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 2,
		desc = "The light, pure white flowers of the common reed, which grow in abundance near water. Often dried and used as an ornament.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_4002",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 4002,
		have_max = 0,
		filter = {
			10111
		},
		sub_attribute = {},
		jump_page = {}
	},
	[4003] = {
		group_max = 0,
		name = "Peanut",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "Peanut seeds are fragrant and delicious, and they're rich in protein and healthy fats.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_4003",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 4003,
		have_max = 0,
		filter = {
			10111
		},
		sub_attribute = {},
		jump_page = {}
	},
	[4004] = {
		group_max = 0,
		name = "Matsutake",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 95,
		desc = "Fresh matsutake mushrooms. A rare treat from the mountains. They have a unique aroma, and are often used as a top-tier flavor enhancer in soups.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_4004",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 4004,
		have_max = 0,
		filter = {
			10111
		},
		sub_attribute = {},
		jump_page = {}
	},
	[4005] = {
		group_max = 0,
		name = "Yoizuki Pear",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 5,
		desc = "A sweet and juicy pear. Its texture is very smooth, and it has the thirst-quenching taste of autumn.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_4005",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 4005,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {}
	},
	[4006] = {
		group_max = 0,
		name = "Yoizuki Pear Seeds",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "Yoizuki pear seeds that hold a sweet future in them. Can be used to grow a high-quality pear tree.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_4006",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 4006,
		have_max = 0,
		filter = {
			10114
		},
		sub_attribute = {},
		jump_page = {}
	},
	[4007] = {
		group_max = 0,
		name = "Kaki Persimmon",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 24,
		desc = "Kaki persimmon that's ripened into a vivid red color. This autumn fruit is soft, sweet, and full of vitamins.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_4007",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 4007,
		have_max = 0,
		filter = {
			10111,
			10121
		},
		sub_attribute = {},
		jump_page = {}
	},
	[4008] = {
		group_max = 0,
		name = "Kaki Persimmon Seeds",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 1,
		desc = "Plant these seeds and pray for a life so healthy, your doctor will be left pale with awe.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_4008",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 4008,
		have_max = 0,
		filter = {
			10114
		},
		sub_attribute = {},
		jump_page = {}
	},
	[4009] = {
		group_max = 0,
		name = "Dried Persimmon",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 25,
		desc = "Sweet and doughy dried persimmon. Made from fresh persimmon.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_4009",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 4009,
		have_max = 0,
		filter = {
			10113,
			10129
		},
		sub_attribute = {},
		jump_page = {}
	},
	[4010] = {
		group_max = 0,
		name = "Matsutake and Chicken Soup",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 135,
		desc = "A soup made with highly fragrant and rich matsutake and chicken that have been slowly simmered together. It's warming and nutritious.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_4010",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 4010,
		have_max = 0,
		filter = {
			10113,
			10129
		},
		sub_attribute = {},
		jump_page = {}
	},
	[4011] = {
		group_max = 0,
		name = "Autumn Bouquet",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 70,
		desc = "A bouquet with warm, orange colors. Consisting of the finest seasonal flowers, like reed and chrysanthemum, it presents the essence of autumn.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_4011",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 4011,
		have_max = 0,
		filter = {
			10113,
			10131
		},
		sub_attribute = {},
		jump_page = {}
	},
	[4012] = {
		group_max = 0,
		name = "Peanut Oil",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 100,
		desc = "A healthy, mild cooking oil extracted from high-quality peanuts.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_4012",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 4012,
		have_max = 0,
		filter = {
			10113,
			10131
		},
		sub_attribute = {},
		jump_page = {}
	},
	[4013] = {
		group_max = 0,
		name = "Carrot and Pear Juice",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 20,
		desc = "A fresh and sweet juice made with carrots and pears. The nutrients from the carrots and the sour flavor of the pears come together into an invigorating drink.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_4013",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 4013,
		have_max = 0,
		filter = {
			10113,
			10128
		},
		sub_attribute = {},
		jump_page = {}
	},
	[4014] = {
		group_max = 0,
		name = "Chrysanthemum Tea",
		manage_influence = 0,
		type = 1,
		convert = 1,
		resource_type = 1,
		pt_num = 100,
		desc = "A tea with a refined, clean aroma. Made with the petals of the chrysanthemum flower, it has a mild aftertaste that clears your head.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_4014",
		price = 1,
		rarity = 1,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 4014,
		have_max = 0,
		filter = {
			10113,
			10128
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100000] = {
		group_max = 0,
		name = "Profession Star",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A star that unlocks endless possibilities. Use on a character to raise their stat limits to the maximum.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100000",
		price = 0,
		rarity = 4,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 100000,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100001] = {
		group_max = 0,
		name = "Island EXP Textbook T1",
		manage_influence = 0,
		type = 5,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A book containing fundamental knowledge on island living. Used to slightly increase a character's Island EXP.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100001",
		price = 0,
		rarity = 2,
		drop_after_use = 0,
		usage_arg = "100",
		id = 100001,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100002] = {
		group_max = 0,
		name = "Island EXP Textbook T2",
		manage_influence = 0,
		type = 5,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A book containing detailed knowledge on island living. Used to moderately increase a character's Island EXP.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100002",
		price = 0,
		rarity = 3,
		drop_after_use = 0,
		usage_arg = "2000",
		id = 100002,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100003] = {
		group_max = 0,
		name = "Island EXP Textbook T3",
		manage_influence = 0,
		type = 5,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A book containing abundant knowledge on island living. Used to greatly increase a character's Island EXP.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100003",
		price = 0,
		rarity = 4,
		drop_after_use = 0,
		usage_arg = "8000",
		id = 100003,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100011] = {
		group_max = 0,
		name = "Management Textbook T1",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A book containing fundamental knowledge on management techniques. Used to slightly increase a character's Management stat.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100011",
		price = 0,
		rarity = 2,
		drop_after_use = 0,
		usage_arg = "1",
		id = 100011,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100012] = {
		group_max = 0,
		name = "Management Textbook T2",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A book containing detailed knowledge on management techniques. Used to moderately increase a character's Management stat.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100012",
		price = 0,
		rarity = 3,
		drop_after_use = 0,
		usage_arg = "2",
		id = 100012,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100013] = {
		group_max = 0,
		name = "Management Textbook T3",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A book containing abundant knowledge on management techniques. Used to greatly increase a character's Management stat.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100013",
		price = 0,
		rarity = 4,
		drop_after_use = 0,
		usage_arg = "5",
		id = 100013,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100021] = {
		group_max = 0,
		name = "Farming Textbook T1",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A book containing fundamental knowledge on farming techniques. Used to slightly increase a character's Farming stat.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100021",
		price = 0,
		rarity = 2,
		drop_after_use = 0,
		usage_arg = "1",
		id = 100021,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100022] = {
		group_max = 0,
		name = "Farming Textbook T2",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A book containing detailed knowledge on farming techniques. Used to moderately increase a character's Farming stat.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100022",
		price = 0,
		rarity = 3,
		drop_after_use = 0,
		usage_arg = "2",
		id = 100022,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100023] = {
		group_max = 0,
		name = "Farming Textbook T3",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A book containing abundant knowledge on farming techniques. Used to greatly increase a character's Farming stat.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100023",
		price = 0,
		rarity = 4,
		drop_after_use = 0,
		usage_arg = "5",
		id = 100023,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100031] = {
		group_max = 0,
		name = "Production Textbook T1",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A book containing fundamental knowledge on production techniques. Used to slightly increase a character's Production stat.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100031",
		price = 0,
		rarity = 2,
		drop_after_use = 0,
		usage_arg = "1",
		id = 100031,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100032] = {
		group_max = 0,
		name = "Production Textbook T2",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A book containing detailed knowledge on production techniques. Used to moderately increase a character's Production stat.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100032",
		price = 0,
		rarity = 3,
		drop_after_use = 0,
		usage_arg = "2",
		id = 100032,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100033] = {
		group_max = 0,
		name = "Production Textbook T3",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A book containing abundant knowledge on production techniques. Used to greatly increase a character's Production stat.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100033",
		price = 0,
		rarity = 4,
		drop_after_use = 0,
		usage_arg = "5",
		id = 100033,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100041] = {
		group_max = 0,
		name = "Gathering Textbook T1",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A book containing fundamental knowledge on gathering techniques. Used to slightly increase a character's Gathering stat.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100041",
		price = 0,
		rarity = 2,
		drop_after_use = 0,
		usage_arg = "1",
		id = 100041,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100042] = {
		group_max = 0,
		name = "Gathering Textbook T2",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A book containing detailed knowledge on gathering techniques. Used to moderately increase a character's Gathering stat.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100042",
		price = 0,
		rarity = 3,
		drop_after_use = 0,
		usage_arg = "2",
		id = 100042,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100043] = {
		group_max = 0,
		name = "Gathering Textbook T3",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A book containing abundant knowledge on gathering techniques. Used to greatly increase a character's Gathering stat.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100043",
		price = 0,
		rarity = 4,
		drop_after_use = 0,
		usage_arg = "5",
		id = 100043,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100051] = {
		group_max = 0,
		name = "Husbandry Textbook T1",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A book containing fundamental knowledge on husbandry techniques. Used to slightly increase a character's Husbandry stat.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100051",
		price = 0,
		rarity = 2,
		drop_after_use = 0,
		usage_arg = "1",
		id = 100051,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100052] = {
		group_max = 0,
		name = "Husbandry Textbook T2",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A book containing detailed knowledge on husbandry techniques. Used to moderately increase a character's Husbandry stat.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100052",
		price = 0,
		rarity = 3,
		drop_after_use = 0,
		usage_arg = "2",
		id = 100052,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100053] = {
		group_max = 0,
		name = "Husbandry Textbook T3",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A book containing abundant knowledge on husbandry techniques. Used to greatly increase a character's Husbandry stat.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100053",
		price = 0,
		rarity = 4,
		drop_after_use = 0,
		usage_arg = "5",
		id = 100053,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100061] = {
		group_max = 0,
		name = "Cooking Textbook T1",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A book containing fundamental knowledge on cooking techniques. Used to slightly increase a character's Cooking stat.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100061",
		price = 0,
		rarity = 2,
		drop_after_use = 0,
		usage_arg = "1",
		id = 100061,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100062] = {
		group_max = 0,
		name = "Cooking Textbook T2",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A book containing detailed knowledge on cooking techniques. Used to moderately increase a character's Cooking stat.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100062",
		price = 0,
		rarity = 3,
		drop_after_use = 0,
		usage_arg = "2",
		id = 100062,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100063] = {
		group_max = 0,
		name = "Cooking Textbook T3",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A book containing abundant knowledge on cooking techniques. Used to greatly increase a character's Cooking stat.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100063",
		price = 0,
		rarity = 4,
		drop_after_use = 0,
		usage_arg = "5",
		id = 100063,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100101] = {
		group_max = 0,
		name = "Manufacturing Textbook T1",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A book containing fundamental knowledge on manufacturing techniques. Used to slightly increase a character's Manufacturing stat.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100101",
		price = 0,
		rarity = 2,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 100101,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100102] = {
		group_max = 0,
		name = "Manufacturing Textbook T2",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A book containing detailed knowledge on manufacturing techniques. Used to moderately increase a character's Manufacturing stat.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100102",
		price = 0,
		rarity = 3,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 100102,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100103] = {
		group_max = 0,
		name = "Manufacturing Textbook T3",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A book containing abundant knowledge on manufacturing techniques. Used to greatly increase a character's Manufacturing stat.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100103",
		price = 0,
		rarity = 4,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 100103,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[100201] = {
		group_max = 0,
		name = "Island Development Gem",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "A crystal of island development experience. Required to Limit Break characters.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_100201",
		price = 0,
		rarity = 3,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 100201,
		have_max = 0,
		filter = {
			10211
		},
		sub_attribute = {},
		jump_page = {}
	},
	[110001] = {
		group_max = 0,
		name = "Sea Salt Drink",
		manage_influence = 0,
		type = 2,
		drop_after_use = 0,
		rarity = 2,
		pt_num = 0,
		desc = "Recovers 50 stamina. Characters who like it also gain a buff. This drink feels like a salty breeze rolling over the tip of your tongue. It's salty, sweet, and unique.",
		usage = "usage_island_gift",
		convert = 0,
		resource_type = 0,
		order_price = 0,
		id = 110001,
		icon = "IslandProps/item_110001",
		price = 0,
		have_max = 0,
		filter = {
			10212
		},
		sub_attribute = {},
		usage_arg = {
			{
				50,
				{}
			},
			{
				50,
				{}
			}
		},
		jump_page = {}
	},
	[110002] = {
		group_max = 0,
		name = "Green Verdure Drink",
		manage_influence = 0,
		type = 2,
		drop_after_use = 0,
		rarity = 2,
		pt_num = 0,
		desc = "Recovers 50 stamina. Characters who like it also gain a buff. This drink's verdant, fresh aroma clears your head.",
		usage = "usage_island_gift",
		convert = 0,
		resource_type = 0,
		order_price = 0,
		id = 110002,
		icon = "IslandProps/item_110002",
		price = 0,
		have_max = 0,
		filter = {
			10212
		},
		sub_attribute = {},
		usage_arg = {
			{
				50,
				{
					1
				}
			},
			{
				50,
				{}
			}
		},
		jump_page = {}
	},
	[110003] = {
		group_max = 0,
		name = "Strawberry Drink",
		manage_influence = 0,
		type = 2,
		drop_after_use = 0,
		rarity = 2,
		pt_num = 0,
		desc = "Recovers 50 stamina. Characters who like it also gain a buff. Its sweet strawberry fragrance fills you with joy and energy.",
		usage = "usage_island_gift",
		convert = 0,
		resource_type = 0,
		order_price = 0,
		id = 110003,
		icon = "IslandProps/item_110003",
		price = 0,
		have_max = 0,
		filter = {
			10212
		},
		sub_attribute = {},
		usage_arg = {
			{
				50,
				{
					2
				}
			},
			{
				50,
				{}
			}
		},
		jump_page = {}
	},
	[110004] = {
		group_max = 0,
		name = "Kumquat Drink",
		manage_influence = 0,
		type = 2,
		drop_after_use = 0,
		rarity = 2,
		pt_num = 0,
		desc = "Recovers 50 stamina. Characters who like it also gain a buff. While the kumquat is a bit sour, its aftertaste is sweet and uplifting.",
		usage = "usage_island_gift",
		convert = 0,
		resource_type = 0,
		order_price = 0,
		id = 110004,
		icon = "IslandProps/item_110004",
		price = 0,
		have_max = 0,
		filter = {
			10212
		},
		sub_attribute = {},
		usage_arg = {
			{
				50,
				{
					3
				}
			},
			{
				50,
				{}
			}
		},
		jump_page = {}
	},
	[110005] = {
		group_max = 0,
		name = "Berry Drink",
		manage_influence = 0,
		type = 2,
		drop_after_use = 0,
		rarity = 2,
		pt_num = 0,
		desc = "Recovers 50 stamina. Characters who like it also gain a buff. Sweet and sour, it's brimming with the joyful and fruity flavor of berries.",
		usage = "usage_island_gift",
		convert = 0,
		resource_type = 0,
		order_price = 0,
		id = 110005,
		icon = "IslandProps/item_110005",
		price = 0,
		have_max = 0,
		filter = {
			10212
		},
		sub_attribute = {},
		usage_arg = {
			{
				50,
				{
					4
				}
			},
			{
				50,
				{}
			}
		},
		jump_page = {}
	},
	[110006] = {
		group_max = 0,
		name = "Grape Drink",
		manage_influence = 0,
		type = 2,
		drop_after_use = 0,
		rarity = 2,
		pt_num = 0,
		desc = "Recovers 50 stamina. Characters who like it also gain a buff. Its smooth and sweet flavor is impossible to get enough of.",
		usage = "usage_island_gift",
		convert = 0,
		resource_type = 0,
		order_price = 0,
		id = 110006,
		icon = "IslandProps/item_110006",
		price = 0,
		have_max = 0,
		filter = {
			10212
		},
		sub_attribute = {},
		usage_arg = {
			{
				50,
				{}
			},
			{
				50,
				{}
			}
		},
		jump_page = {}
	},
	[200001] = {
		group_max = 0,
		name = "Island Authority Permit: Cheshire",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "An Island Authority Permit for Cheshire. Use it to give the character the credentials to visit the island freely.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_200001",
		price = 0,
		rarity = 4,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 200001,
		have_max = 0,
		filter = {
			10213
		},
		sub_attribute = {},
		jump_page = {}
	},
	[200002] = {
		group_max = 0,
		name = "Island Authority Permit: Saratoga",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "An Island Authority Permit for Saratoga. Use it to give the character credentials to visit the island freely.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_200002",
		price = 0,
		rarity = 4,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 200002,
		have_max = 0,
		filter = {
			10213
		},
		sub_attribute = {},
		jump_page = {}
	},
	[200003] = {
		group_max = 0,
		name = "Island Authority Permit: Akashi",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "An Island Authority Permit for Akashi. Use it to give the character the credentials to visit the island freely.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_200003",
		price = 0,
		rarity = 4,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 200003,
		have_max = 0,
		filter = {
			10213
		},
		sub_attribute = {},
		jump_page = {}
	},
	[200004] = {
		group_max = 0,
		name = "Island Authority Permit: Taihou",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "An Island Authority Permit for Taihou. Use it to give the character the credentials to visit the island freely.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_200004",
		price = 0,
		rarity = 4,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 200004,
		have_max = 0,
		filter = {
			10213
		},
		sub_attribute = {},
		jump_page = {}
	},
	[200005] = {
		group_max = 0,
		name = "Island Authority Permit: New Jersey",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "An Island Authority Permit for New Jersey. Use it to give the character the credentials to visit the island freely.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_200005",
		price = 0,
		rarity = 4,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 200005,
		have_max = 0,
		filter = {
			10213
		},
		sub_attribute = {},
		jump_page = {}
	},
	[200006] = {
		group_max = 0,
		name = "Island Authority Permit: Shimakaze",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "An Island Authority Permit for Shimakaze. Use it to give the character the credentials to visit the island freely.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_200006",
		price = 0,
		rarity = 4,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 200006,
		have_max = 0,
		filter = {
			10213
		},
		sub_attribute = {},
		jump_page = {}
	},
	[200007] = {
		group_max = 0,
		name = "Island Authority Permit: Ying Swei",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "An Island Authority Permit for Ying Swei. Use it to give the character the credentials to visit the island freely.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_200007",
		price = 0,
		rarity = 4,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 200007,
		have_max = 0,
		filter = {
			10213
		},
		sub_attribute = {},
		jump_page = {}
	},
	[200008] = {
		group_max = 0,
		name = "Island Authority Permit: Le Malin",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "An Island Authority Permit for Le Malin. Use it to give the character the credentials to visit the island freely.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_200008",
		price = 0,
		rarity = 4,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 200008,
		have_max = 0,
		filter = {
			10213
		},
		sub_attribute = {},
		jump_page = {}
	},
	[200009] = {
		group_max = 0,
		name = "Island Authority Permit: Unicorn",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "An Island Authority Permit for Unicorn. Use it to give the character the credentials to visit the island freely.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_200009",
		price = 0,
		rarity = 4,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 200009,
		have_max = 0,
		filter = {
			10213
		},
		sub_attribute = {},
		jump_page = {}
	},
	[200010] = {
		group_max = 0,
		name = "Island Authority Permit: Tashkent",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "An Island Authority Permit for Tashkent. Use it to give the character the credentials to visit the island freely.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_200010",
		price = 0,
		rarity = 4,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 200010,
		have_max = 0,
		filter = {
			10213
		},
		sub_attribute = {},
		jump_page = {}
	},
	[200011] = {
		group_max = 0,
		name = "Island Authority Permit: Hood",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "An Island Authority Permit for Hood. Use it to give the character the credentials to visit the island freely.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_200011",
		price = 0,
		rarity = 4,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 200011,
		have_max = 0,
		filter = {
			10213
		},
		sub_attribute = {},
		jump_page = {}
	},
	[200012] = {
		group_max = 0,
		name = "Island Authority Permit: Amagi-chan",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "An Island Authority Permit for Amagi-chan. Use it to give the character the credentials to visit the island freely.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_200012",
		price = 0,
		rarity = 4,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 200012,
		have_max = 0,
		filter = {
			10213
		},
		sub_attribute = {},
		jump_page = {}
	},
	[200013] = {
		group_max = 0,
		name = "Island Authority Permit: Prinz Eugen",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "An Island Authority Permit for Prinz Eugen. Use it to give the character the credentials to visit the island freely.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_200013",
		price = 0,
		rarity = 4,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 200013,
		have_max = 0,
		filter = {
			10213
		},
		sub_attribute = {},
		jump_page = {}
	},
	[200014] = {
		group_max = 0,
		name = "Island Authority Permit: Chao Ho",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "An Island Authority Permit for Chao Ho. Use it to give the character the credentials to visit the island freely.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_200014",
		price = 0,
		rarity = 4,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 200014,
		have_max = 0,
		filter = {
			10213
		},
		sub_attribute = {},
		jump_page = {}
	},
	[200015] = {
		group_max = 0,
		name = "Island Authority Permit: Leonardo da Vinci",
		manage_influence = 0,
		type = 2,
		convert = 0,
		resource_type = 0,
		pt_num = 0,
		desc = "An Island Authority Permit for Leonardo da Vinci. Use it to give the character the credentials to visit the island freely.",
		usage = "usage_undefined",
		order_price = 0,
		icon = "IslandProps/item_200015",
		price = 0,
		rarity = 4,
		drop_after_use = 0,
		usage_arg = "[]",
		id = 200015,
		have_max = 0,
		filter = {
			10213
		},
		sub_attribute = {},
		jump_page = {}
	}
}
