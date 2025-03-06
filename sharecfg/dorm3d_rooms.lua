pg = pg or {}
pg.dorm3d_rooms = {
	{
		invite_cost = "",
		room_des = "",
		type = 2,
		resource_name = "Tianlangxing_DB",
		assets_prefix = "Tianlangxing",
		tag = "",
		invite_banner = "",
		scene_info = "map_siriushostel_01|Tianlangxing_DB/SiriusHostel",
		in_map = "floor_1",
		room = "Sirius",
		invite_mark = "",
		id = 1,
		room_bgm = "story-room-sirius",
		character = {
			20220
		},
		character_pay = {},
		character_welcome = {
			{
				20220,
				2000
			}
		},
		character_range = {
			1
		},
		unlock_item = {},
		default_zone = {
			{
				20220,
				"Chair"
			}
		},
		furniture_zones = {
			1001,
			1002,
			1003
		},
		recall_list = {
			1,
			2,
			3,
			4,
			5,
			6,
			7
		},
		ar_anim = {
			{
				20220,
				{
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
					1101,
					1102,
					1103,
					1104,
					1201,
					1202,
					1203,
					1301,
					1302,
					1303
				}
			}
		}
	},
	{
		invite_cost = "",
		room_des = "",
		type = 2,
		resource_name = "Nengdai_DB",
		assets_prefix = "Nengdai",
		tag = "",
		invite_banner = "",
		scene_info = "map_noshirohostel_01|Nengdai_DB/Noshirohostel",
		in_map = "floor_1",
		room = "Noshiro",
		invite_mark = "",
		id = 2,
		room_bgm = "story-room-noshiro",
		character = {
			30221
		},
		character_pay = {},
		character_welcome = {
			{
				30221,
				0
			}
		},
		character_range = {
			1
		},
		unlock_item = {},
		default_zone = {
			{
				30221,
				"Chair"
			}
		},
		furniture_zones = {
			2001,
			2002,
			2003
		},
		recall_list = {
			21,
			22,
			23,
			31
		},
		ar_anim = {
			{
				30221,
				{
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
					2013,
					2101,
					2102,
					2103,
					2104,
					2201,
					2202,
					2203,
					2204,
					2301,
					2302,
					2303,
					2304
				}
			}
		}
	},
	{
		invite_cost = "",
		room_des = "",
		type = 2,
		resource_name = "Ankeleiqi_DB",
		assets_prefix = "Ankeleiqi",
		tag = "",
		invite_banner = "",
		scene_info = "map_anchoragehostel_01|Ankeleiqi_DB/Anchoragehostel",
		in_map = "floor_1",
		room = "Anchorage",
		invite_mark = "",
		id = 3,
		room_bgm = "story-room-anchorage",
		character = {
			19903
		},
		character_pay = {},
		character_welcome = {
			{
				19903,
				0
			}
		},
		character_range = {
			1
		},
		unlock_item = {},
		default_zone = {
			{
				19903,
				"Chair"
			}
		},
		furniture_zones = {
			3001,
			3002,
			3003
		},
		recall_list = {
			41,
			42,
			43,
			51
		},
		ar_anim = {
			{
				19903,
				{
					3001,
					3002,
					3003,
					3005,
					3006,
					3007,
					3008,
					3010,
					3011,
					3012,
					3013,
					3014,
					3015,
					3016,
					3017,
					3018
				}
			}
		}
	},
	{
		tag = "beach",
		room_des = "The seaside, swimsuits, beach volleyball... Enjoy the beach sunshine!",
		type = 1,
		resource_name = "Beach",
		assets_prefix = "Beach",
		scene_info = "map_beach_02|Beach",
		in_map = "floor_1",
		room = "Beach",
		id = 4,
		room_bgm = "story-room-sirius",
		character = {},
		character_pay = {
			20220,
			30221,
			19903
		},
		character_welcome = {
			{
				20220,
				1000
			},
			{
				30221,
				0
			},
			{
				19903,
				0
			}
		},
		character_range = {
			0,
			3
		},
		unlock_item = {
			{
				2,
				15022,
				1
			}
		},
		default_zone = {
			{
				20220,
				"Tianlangxing"
			},
			{
				30221,
				"Nengdai"
			},
			{
				19903,
				"Ankeleiqi"
			}
		},
		furniture_zones = {},
		recall_list = {},
		invite_cost = {
			{
				20220,
				270110
			},
			{
				30221,
				270111
			},
			{
				19903,
				270112
			}
		},
		invite_banner = {
			{
				20220,
				{
					"banner_beach1",
					"banner_beach2"
				}
			},
			{
				30221,
				{
					"banner_beach3"
				}
			},
			{
				19903,
				{
					"banner_beach4"
				}
			}
		},
		invite_mark = {
			{
				20220,
				{
					1,
					5,
					6
				}
			},
			{
				30221,
				{
					1,
					5,
					6
				}
			},
			{
				19903,
				{
					1,
					5,
					6
				}
			}
		},
		ar_anim = {
			{
				20220,
				{
					4001,
					4002,
					4003,
					4004,
					4005
				}
			},
			{
				30221,
				{
					4201,
					4202,
					4203,
					4204,
					4205
				}
			},
			{
				19903,
				{
					4401,
					4402,
					4403,
					4404,
					4405
				}
			}
		}
	},
	{
		invite_cost = "",
		recall_list = "",
		default_zone = "",
		resource_name = "Bathroom",
		type = 1,
		ar_anim = "",
		room_bgm = "story-room-sirius",
		invite_banner = "",
		scene_info = "",
		in_map = "floor_1",
		room = "Bath",
		invite_mark = "",
		tag = "",
		furniture_zones = "",
		room_des = "",
		assets_prefix = "Bathroom",
		id = 5,
		character = {
			20220
		},
		character_pay = {},
		character_welcome = {
			{
				20220,
				1000
			}
		},
		character_range = {
			0,
			0
		},
		unlock_item = {
			{
				2,
				15022,
				1
			}
		}
	},
	get_id_list_by_in_map = {
		floor_1 = {
			1,
			2,
			3,
			4,
			5
		}
	},
	all = {
		1,
		2,
		3,
		4,
		5
	}
}
