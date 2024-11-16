pg = pg or {}
pg.pay_data_display = setmetatable({
	__name = "pay_data_display",
	all = {
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8,
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
		55,
		56,
		57,
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
		1013,
		1014,
		1015,
		1016,
		1017,
		1018,
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
		120,
		121,
		122,
		123,
		124,
		125,
		126,
		127,
		128,
		129,
		130,
		131,
		132,
		133,
		134,
		135,
		136,
		137,
		138,
		2014,
		2015,
		2016,
		2017,
		2018,
		2019,
		2020,
		2022,
		2023,
		2024,
		2025,
		2026,
		2027,
		2028,
		2029,
		2030,
		2031,
		2032,
		2033,
		2034,
		2035,
		5011,
		5012,
		5013,
		5014,
		5015,
		5016,
		5017,
		139,
		140,
		141,
		142,
		143,
		144,
		145,
		146,
		147,
		148,
		149,
		150,
		151,
		152,
		153,
		154
	}
}, confHX)
pg.base = pg.base or {}
pg.base.pay_data_display = {
	{
		name = "Trade License (30 days)",
		limit_group = 0,
		descrip_extra = "",
		type = 0,
		subject = "Trade License",
		limit_arg = 7,
		name_display = "Trade License (30 days)",
		show_group = "",
		type_order = 0,
		extra_service = 2,
		money = 799,
		id = 1,
		tag = 2,
		gem = 500,
		limit_type = 1,
		time = "always",
		picture = "month",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.passport1",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Receive $1 Gems immediately and resources every day for \n30 days.",
		airijp_id = "com.yostaren.azurlane.passport1",
		extra_service_item = {
			{
				1,
				1,
				1000
			},
			{
				1,
				2,
				200
			},
			{
				2,
				20001,
				1
			}
		},
		display = {
			{
				1,
				1,
				1000
			},
			{
				1,
				2,
				200
			},
			{
				2,
				20001,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				1,
				1,
				1000
			},
			{
				1,
				2,
				200
			},
			{
				2,
				20001,
				1
			}
		}
	},
	{
		name = "Novice sailing supplies",
		limit_group = 0,
		descrip_extra = "",
		type = 0,
		subject = "Novice sailing supplies",
		limit_arg = 1,
		name_display = "Novice sailing supplies",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 99,
		id = 2,
		tag = 1,
		gem = 0,
		limit_type = 2,
		time = "always",
		picture = "boxNewplayer",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond101",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Three Supplies",
		airijp_id = "com.yostaren.azurlane.diamond101",
		extra_service_item = {
			{
				1,
				4,
				60
			},
			{
				2,
				15003,
				2
			},
			{
				2,
				20001,
				2
			}
		},
		display = {
			{
				1,
				4,
				60
			},
			{
				2,
				15003,
				2
			},
			{
				2,
				20001,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				15003,
				2
			},
			{
				2,
				20001,
				2
			}
		}
	},
	{
		name = "Handful of Gems",
		limit_group = 0,
		descrip_extra = "",
		type = 0,
		subject = "60 Gems",
		limit_arg = 10,
		name_display = "Handful of Gems",
		show_group = "",
		type_order = 0,
		extra_service_item = "0",
		money = 99,
		extra_service = 0,
		tag = 0,
		id = 3,
		gem = 60,
		limit_type = 99,
		time = "always",
		picture = "1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond1",
		first_pay_double = 1,
		extra_gem = 0,
		descrip = "Get $1 Gems as bonus",
		airijp_id = "com.yostaren.azurlane.diamond1",
		display = {},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	{
		name = "Pile of Gems",
		limit_group = 0,
		descrip_extra = "",
		type = 0,
		subject = "300 Gems",
		limit_arg = 10,
		name_display = "Pile of Gems",
		show_group = "",
		type_order = 0,
		extra_service_item = "0",
		money = 499,
		extra_service = 0,
		tag = 0,
		id = 4,
		gem = 300,
		limit_type = 99,
		time = "always",
		picture = "2",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond2",
		first_pay_double = 1,
		extra_gem = 30,
		descrip = "Get $1 Gems as bonus",
		airijp_id = "com.yostaren.azurlane.diamond2",
		display = {},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	{
		name = "Sack of Gems",
		limit_group = 0,
		descrip_extra = "",
		type = 0,
		subject = "980 Gems",
		limit_arg = 0,
		name_display = "Sack of Gems",
		show_group = "",
		type_order = 0,
		extra_service_item = "0",
		money = 999,
		extra_service = 0,
		tag = 0,
		id = 5,
		gem = 600,
		limit_type = 0,
		time = "always",
		picture = "3",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond3",
		first_pay_double = 1,
		extra_gem = 150,
		descrip = "Get $1 Gems as bonus",
		airijp_id = "com.yostaren.azurlane.diamond3",
		display = {},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	{
		name = "Box of Gems",
		limit_group = 0,
		descrip_extra = "",
		type = 0,
		subject = "1980 Gems",
		limit_arg = 0,
		name_display = "Box of Gems",
		show_group = "",
		type_order = 0,
		extra_service_item = "0",
		money = 1999,
		extra_service = 0,
		tag = 0,
		id = 6,
		gem = 1200,
		limit_type = 0,
		time = "always",
		picture = "4",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond4",
		first_pay_double = 1,
		extra_gem = 360,
		descrip = "Get $1 Gems as bonus",
		airijp_id = "com.yostaren.azurlane.diamond4",
		display = {},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	{
		name = "Chest of Gems",
		limit_group = 0,
		descrip_extra = "",
		type = 0,
		subject = "3280 Gems",
		limit_arg = 0,
		name_display = "Chest of Gems",
		show_group = "",
		type_order = 0,
		extra_service_item = "0",
		money = 3999,
		extra_service = 0,
		tag = 0,
		id = 7,
		gem = 2400,
		limit_type = 0,
		time = "always",
		picture = "5",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond5",
		first_pay_double = 1,
		extra_gem = 880,
		descrip = "Get $1 Gems as bonus",
		airijp_id = "com.yostaren.azurlane.diamond5",
		display = {},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	{
		name = "Ship of Gems",
		limit_group = 0,
		descrip_extra = "",
		type = 0,
		subject = "6480 Gems",
		limit_arg = 0,
		name_display = "Ship of Gems",
		show_group = "",
		type_order = 0,
		extra_service_item = "0",
		money = 7999,
		extra_service = 0,
		tag = 1,
		id = 8,
		gem = 4900,
		limit_type = 0,
		time = "always",
		picture = "6",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond6",
		first_pay_double = 1,
		extra_gem = 2500,
		descrip = "Get $1 Gems as bonus",
		airijp_id = "com.yostaren.azurlane.diamond6",
		display = {},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[24] = {
		name = "2020 Party Dress Lucky Bag",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		subject = "2020 Party Dress Lucky Bag",
		limit_arg = 1,
		name_display = "2020 Party Dress Lucky Bag",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 24,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "lihe3_l",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond138",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2020 Gems, and a large amount of supplies. ",
		airijp_id = "com.yostaren.azurlane.diamond138",
		extra_service_item = {
			{
				2,
				69911,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				42026,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2020,
					9,
					24
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2020,
					10,
					11
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69911,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				42026,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40911,
				1
			}
		}
	},
	[25] = {
		name = "Shougatsu Lucky Bag 2021 ",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		subject = "Shougatsu Lucky Bag 2021",
		limit_arg = 1,
		name_display = "Shougatsu Lucky Bag 2021 ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 25,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai3",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond142",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2021 Gems, and a large amount of supplies. ",
		airijp_id = "com.yostaren.azurlane.diamond142",
		extra_service_item = {
			{
				2,
				69912,
				1
			},
			{
				1,
				4,
				2021
			},
			{
				2,
				42026,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2020,
					12,
					29
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2021,
					1,
					13
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69912,
				1
			},
			{
				1,
				4,
				2021
			},
			{
				2,
				42026,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40912,
				1
			}
		}
	},
	[26] = {
		name = "Shougatsu Lucky Bag 2020 ",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		subject = "Shougatsu Lucky Bag 2020",
		limit_arg = 1,
		name_display = "Shougatsu Lucky Bag 2020 ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 26,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond126",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2020 Gems, and a large amount of supplies. ",
		airijp_id = "com.yostaren.azurlane.diamond126",
		extra_service_item = {
			{
				2,
				69908,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				42017,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2020,
					12,
					29
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2021,
					1,
					13
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69908,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				42017,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40908,
				1
			}
		}
	},
	[27] = {
		name = "Lunar New Year Lucky Bag (2021)",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		subject = "Lunar New Year Lucky Bag (2021)",
		limit_arg = 1,
		name_display = "Lunar New Year Lucky Bag (2021)",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 27,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai4",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond143",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2021 Gems, and a large amount of supplies. ",
		airijp_id = "com.yostaren.azurlane.diamond143",
		extra_service_item = {
			{
				2,
				69913,
				1
			},
			{
				1,
				4,
				2021
			},
			{
				2,
				42026,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2021,
					2,
					4
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2021,
					2,
					18
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69913,
				1
			},
			{
				1,
				4,
				2021
			},
			{
				2,
				42026,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40913,
				1
			}
		}
	},
	[28] = {
		name = "Lunar New Year Lucky Bag (2020)",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		subject = "Lunar New Year Lucky Bag (2020)",
		limit_arg = 1,
		name_display = "Lunar New Year Lucky Bag (2020)",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 28,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai2",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond128",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2020 Gems, and a large amount of supplies. ",
		airijp_id = "com.yostaren.azurlane.diamond128",
		extra_service_item = {
			{
				2,
				69909,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				42017,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2021,
					2,
					4
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2021,
					2,
					18
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69909,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				42017,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40909,
				1
			}
		}
	},
	[29] = {
		name = "Exquisite Lucky Box 2021 ",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Exquisite Lucky Box 2021 ",
		limit_arg = 1,
		name_display = "Exquisite Lucky Box 2021 ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 29,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "lihe6_l",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond146",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2021 Gems, and a large amount of supplies. ",
		airijp_id = "com.yostaren.azurlane.diamond146",
		extra_service_item = {
			{
				2,
				69914,
				1
			},
			{
				1,
				4,
				2021
			},
			{
				2,
				42026,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2021,
					5,
					18
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2021,
					6,
					16
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69914,
				1
			},
			{
				1,
				14,
				2021
			},
			{
				2,
				42026,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40914,
				1
			}
		}
	},
	[30] = {
		name = "Exquisite Lucky Bag 2020 ",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Exquisite Lucky Bag 2020 ",
		limit_arg = 1,
		name_display = "Exquisite Lucky Bag 2020 ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 30,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "lihe1_l",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond147",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2020 Gems, and a large amount of supplies. ",
		airijp_id = "com.yostaren.azurlane.diamond147",
		extra_service_item = {
			{
				2,
				69910,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				42017,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2021,
					5,
					18
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2021,
					6,
					16
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69910,
				1
			},
			{
				1,
				14,
				2020
			},
			{
				2,
				42017,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40910,
				1
			}
		}
	},
	[31] = {
		name = "New Commanders Support Pack IV ",
		limit_group = 0,
		descrip_extra = "The pack includes lots of material rewards. The Startup Pack will be sent to you via in-game mail, please check your mailbox to claim the pack. ",
		type = 1,
		subject = "New Commanders Support Pack IV ",
		limit_arg = 1,
		name_display = "New Commanders Support Pack IV ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 31,
		tag = 1,
		gem = 0,
		limit_type = 2,
		time = "always",
		picture = "support4",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond148",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1980 x Gems, 35x Universal T4 Plate, 1x Gear Lab Development Pack, and other rewards ",
		airijp_id = "com.yostaren.azurlane.diamond148",
		extra_service_item = {
			{
				1,
				14,
				1980
			},
			{
				2,
				30121,
				10
			},
			{
				2,
				30114,
				35
			},
			{
				2,
				30113,
				100
			},
			{
				2,
				14004,
				25
			},
			{
				2,
				30203,
				1
			},
			{
				2,
				42036,
				5
			},
			{
				2,
				16003,
				10
			},
			{
				2,
				16013,
				5
			},
			{
				2,
				16023,
				5
			},
			{
				2,
				15008,
				500
			},
			{
				4,
				100011,
				1
			}
		},
		display = {
			{
				1,
				14,
				1980
			},
			{
				2,
				30114,
				35
			},
			{
				2,
				30121,
				10
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40015,
				1
			}
		}
	},
	[32] = {
		name = "2021 Party Dress Lucky Box",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "2021 Party Dress Lucky Box",
		limit_arg = 1,
		name_display = "2021 Party Dress Lucky Box",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 32,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "lihe6_l",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond151",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2021 Gems, and a large amount of supplies. ",
		airijp_id = "com.yostaren.azurlane.diamond151",
		extra_service_item = {
			{
				2,
				69915,
				1
			},
			{
				1,
				4,
				2021
			},
			{
				2,
				42036,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2021,
					9,
					23
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2021,
					10,
					13
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69915,
				1
			},
			{
				1,
				4,
				2021
			},
			{
				2,
				42036,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40915,
				1
			}
		}
	},
	[33] = {
		name = "2020 Party Dress Lucky Box",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "2020 Party Dress Lucky Box",
		limit_arg = 1,
		name_display = "2020 Party Dress Lucky Box",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 33,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "lihe3_l",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond150",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2020 Gems, and a large amount of supplies. ",
		airijp_id = "com.yostaren.azurlane.diamond150",
		extra_service_item = {
			{
				2,
				69911,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				42026,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2021,
					9,
					23
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2021,
					10,
					13
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69911,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				42026,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40911,
				1
			}
		}
	},
	[34] = {
		name = "Shougatsu Lucky Box 2022 ",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Shougatsu Lucky Box 2022 ",
		limit_arg = 1,
		name_display = "Shougatsu Lucky Box 2022 ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 34,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai6",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond154",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2022 Gems, and a large amount of supplies. ",
		airijp_id = "com.yostaren.azurlane.diamond154",
		extra_service_item = {
			{
				2,
				69916,
				1
			},
			{
				1,
				14,
				2022
			},
			{
				2,
				42036,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2021,
					12,
					29
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					1,
					12
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69916,
				1
			},
			{
				1,
				14,
				2022
			},
			{
				2,
				42036,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40916,
				1
			}
		}
	},
	[35] = {
		name = "Shougatsu Lucky Bag 2021 ",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Shougatsu Lucky Bag 2021 ",
		limit_arg = 1,
		name_display = "Shougatsu Lucky Bag 2021 ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 35,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai3",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond153",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2021 Gems, and a large amount of supplies. ",
		airijp_id = "com.yostaren.azurlane.diamond153",
		extra_service_item = {
			{
				2,
				69912,
				1
			},
			{
				1,
				14,
				2021
			},
			{
				2,
				42026,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2021,
					12,
					29
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					1,
					12
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69912,
				1
			},
			{
				1,
				14,
				2021
			},
			{
				2,
				42026,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40912,
				1
			}
		}
	},
	[36] = {
		name = "Lunar New Year Lucky Bag (2022)",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Lunar New Year Lucky Bag (2022)",
		limit_arg = 1,
		name_display = "Lunar New Year Lucky Bag (2022)",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 36,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai7",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond156",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2022 Gems, and a large amount of supplies. ",
		airijp_id = "com.yostaren.azurlane.diamond156",
		extra_service_item = {
			{
				2,
				69917,
				1
			},
			{
				1,
				14,
				2022
			},
			{
				2,
				42036,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2022,
					1,
					27
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					2,
					9
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69917,
				1
			},
			{
				1,
				14,
				2022
			},
			{
				2,
				42036,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40917,
				1
			}
		}
	},
	[37] = {
		name = "Lunar New Year Lucky Bag (2021)",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Lunar New Year Lucky Bag (2021)",
		limit_arg = 1,
		name_display = "Lunar New Year Lucky Bag (2021)",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 37,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai4",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond155",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2021 Gems, and a large amount of supplies. ",
		airijp_id = "com.yostaren.azurlane.diamond155",
		extra_service_item = {
			{
				2,
				69913,
				1
			},
			{
				1,
				14,
				2021
			},
			{
				2,
				42026,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2022,
					1,
					27
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					2,
					9
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69913,
				1
			},
			{
				1,
				14,
				2021
			},
			{
				2,
				42026,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40913,
				1
			}
		}
	},
	[38] = {
		name = "Exquisite Lucky Box 2022 ",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Exquisite Lucky Box 2022 ",
		limit_arg = 1,
		name_display = "Exquisite Lucky Box 2022 ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 38,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "lihe8_l",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond167",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2022 Gems, and a large amount of supplies. ",
		airijp_id = "com.yostaren.azurlane.diamond167",
		extra_service_item = {
			{
				2,
				69919,
				1
			},
			{
				1,
				14,
				2022
			},
			{
				2,
				42036,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2022,
					6,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					6,
					15
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69919,
				1
			},
			{
				1,
				14,
				2022
			},
			{
				2,
				42036,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40919,
				1
			}
		}
	},
	[39] = {
		name = "Exquisite Lucky Box 2021 ",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Exquisite Lucky Box 2021 ",
		limit_arg = 1,
		name_display = "Exquisite Lucky Box 2021 ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 39,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "lihe6_l",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond168",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2021 Gems, and a large amount of supplies. ",
		airijp_id = "com.yostaren.azurlane.diamond168",
		extra_service_item = {
			{
				2,
				69914,
				1
			},
			{
				1,
				14,
				2021
			},
			{
				2,
				42026,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2022,
					6,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					6,
					15
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69914,
				1
			},
			{
				1,
				14,
				2021
			},
			{
				2,
				42026,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40914,
				1
			}
		}
	},
	[42] = {
		name = "Party Dress Lucky Box 2021 Rerun",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Party Dress Lucky Box 2021 Rerun",
		limit_arg = 1,
		name_display = "Party Dress Lucky Box 2021 Rerun",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 42,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "lihe6_l",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond175",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2021 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.diamond175",
		extra_service_item = {
			{
				2,
				69915,
				1
			},
			{
				1,
				14,
				2021
			},
			{
				2,
				42036,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2022,
					9,
					26
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					10,
					16
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69915,
				1
			},
			{
				1,
				14,
				2021
			},
			{
				2,
				42036,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40915,
				1
			}
		}
	},
	[43] = {
		name = "Party Dress Lucky Box 2022",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Party Dress Lucky Box 2022",
		limit_arg = 1,
		name_display = "Party Dress Lucky Box 2022",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 43,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "lihe8_l",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond176",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2022 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.diamond176",
		extra_service_item = {
			{
				2,
				69920,
				1
			},
			{
				1,
				14,
				2022
			},
			{
				2,
				42046,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2022,
					9,
					26
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					10,
					16
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69920,
				1
			},
			{
				1,
				14,
				2022
			},
			{
				2,
				42046,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40920,
				1
			}
		}
	},
	[44] = {
		name = "Welcome Back Pack",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 1,
		subject = "Welcome Back Pack",
		limit_arg = 1,
		name_display = "Welcome Back Pack",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 1799,
		id = 44,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "support6",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond179",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains loads of valuable rewads.",
		airijp_id = "com.yostaren.azurlane.diamond179",
		extra_service_item = {
			{
				2,
				20001,
				40
			},
			{
				2,
				15003,
				20
			},
			{
				1,
				1,
				30000
			},
			{
				2,
				16502,
				200
			},
			{
				2,
				15008,
				1000
			},
			{
				2,
				16004,
				1
			},
			{
				2,
				16014,
				1
			},
			{
				2,
				16024,
				1
			},
			{
				2,
				16003,
				3
			},
			{
				2,
				16013,
				3
			},
			{
				2,
				16023,
				3
			},
			{
				2,
				30114,
				15
			},
			{
				2,
				30113,
				60
			},
			{
				1,
				3,
				20000
			},
			{
				2,
				59900,
				1000
			}
		},
		time = {
			{
				{
					2022,
					11,
					17
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					12,
					8
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				20001,
				40
			},
			{
				2,
				30114,
				15
			},
			{
				2,
				16502,
				200
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40921,
				1
			}
		}
	},
	[45] = {
		name = "Winter Swimsuit Lucky Bag 2022 A",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Winter Swimsuit Lucky Bag 2022 A",
		limit_arg = 1,
		name_display = "Winter Swimsuit Lucky Bag 2022 A",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 45,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "lihe10_l",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.luckybag2",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag2",
		extra_service_item = {
			{
				2,
				69922,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42046,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2022,
					12,
					22
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					1,
					4
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69922,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42046,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40922,
				1
			}
		}
	},
	[46] = {
		name = "Winter Swimsuit Lucky Bag 2022 B",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Winter Swimsuit Lucky Bag 2022 B",
		limit_arg = 1,
		name_display = "Winter Swimsuit Lucky Bag 2022 B",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 46,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "lihe11_l",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.luckybag3",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag3",
		extra_service_item = {
			{
				2,
				69923,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42046,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2022,
					12,
					22
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					1,
					4
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69923,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42046,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40923,
				1
			}
		}
	},
	[47] = {
		name = "Shougatsu Lucky Box 2022 Rerun",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Shougatsu Lucky Box 2022 Rerun",
		limit_arg = 1,
		name_display = "Shougatsu Lucky Box 2022 Rerun",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 47,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai6",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.luckybag1",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2022 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag1",
		extra_service_item = {
			{
				2,
				69916,
				1
			},
			{
				1,
				14,
				2022
			},
			{
				2,
				42036,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2022,
					12,
					22
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					1,
					4
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69916,
				1
			},
			{
				1,
				14,
				2022
			},
			{
				2,
				42036,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40916,
				1
			}
		}
	},
	[48] = {
		name = "Spring Lucky Bag 2023 A",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Spring Lucky Bag 2023 A",
		limit_arg = 1,
		name_display = "Spring Lucky Bag 2023 A",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 48,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudaiqp1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.luckybag5",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag5",
		extra_service_item = {
			{
				2,
				69924,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42046,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2023,
					1,
					18
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					2,
					1
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69924,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42046,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40924,
				1
			}
		}
	},
	[49] = {
		name = "Spring Lucky Bag 2023 B",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Spring Lucky Bag 2023 B",
		limit_arg = 1,
		name_display = "Spring Lucky Bag 2023 B",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 49,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudaiqp2",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.luckybag7",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag7",
		extra_service_item = {
			{
				2,
				69925,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42046,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2023,
					1,
					18
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					2,
					1
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69925,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42046,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40925,
				1
			}
		}
	},
	[50] = {
		name = "Lunar New Year Lucky Bag 2022 Rerun",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Lunar New Year Lucky Bag 2022 Rerun",
		limit_arg = 1,
		name_display = "Lunar New Year Lucky Bag 2022 Rerun",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 50,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai7",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.luckybag6",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2022 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag6",
		extra_service_item = {
			{
				2,
				69917,
				1
			},
			{
				1,
				14,
				2022
			},
			{
				2,
				42036,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2023,
					1,
					18
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					2,
					1
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69917,
				1
			},
			{
				1,
				14,
				2022
			},
			{
				2,
				42036,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40917,
				1
			}
		}
	},
	[51] = {
		name = "Swimsuit Lucky Bag 2023",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Swimsuit Lucky Bag 2023",
		limit_arg = 1,
		name_display = "Swimsuit Lucky Bag 2023",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 51,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "lihecn6ss_l",
		skin_inquire_relation = 69926,
		id_str = "com.yostaren.azurlane.luckybag10",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains items, resources, and a random Summer 2023 swimsuit skin.",
		airijp_id = "com.yostaren.azurlane.luckybag10",
		extra_service_item = {
			{
				2,
				69926,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42046,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2023,
					5,
					25
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					6,
					14
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69926,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42046,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40926,
				1
			}
		}
	},
	[52] = {
		name = "Exquisite Lucky Box 2023",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Exquisite Lucky Box 2023",
		limit_arg = 1,
		name_display = "Exquisite Lucky Box 2023",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 52,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "liheus6lf_l",
		skin_inquire_relation = 69927,
		id_str = "com.yostaren.azurlane.luckybag11",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag11",
		extra_service_item = {
			{
				2,
				69927,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42046,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2023,
					6,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					6,
					14
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69927,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42046,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40927,
				1
			}
		}
	},
	[53] = {
		name = "Exquisite Lucky Box 2022 Rerun",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Exquisite Lucky Box 2022 Rerun",
		limit_arg = 1,
		name_display = "Exquisite Lucky Box 2022 Rerun",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 53,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "lihe8_l",
		skin_inquire_relation = 69919,
		id_str = "com.yostaren.azurlane.luckybag12",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2022 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag12",
		extra_service_item = {
			{
				2,
				69919,
				1
			},
			{
				1,
				14,
				2022
			},
			{
				2,
				42036,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2023,
					6,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					6,
					14
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69919,
				1
			},
			{
				1,
				14,
				2022
			},
			{
				2,
				42036,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40919,
				1
			}
		}
	},
	[55] = {
		name = "Autumn Classics Lucky Box ",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Autumn Classics Lucky Box ",
		limit_arg = 1,
		name_display = "Autumn Classics Lucky Box ",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 55,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "lihejp6lf_l",
		skin_inquire_relation = 69929,
		id_str = "com.yostaren.azurlane.luckybag16",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag16",
		extra_service_item = {
			{
				2,
				69929,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42056,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2023,
					9,
					21
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					10,
					4
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69929,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42056,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40929,
				1
			}
		}
	},
	[56] = {
		name = "Party Dress Lucky Box 2022 Rerun ",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Party Dress Lucky Box 2022 Rerun ",
		limit_arg = 1,
		name_display = "Party Dress Lucky Box 2022 Rerun ",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 56,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "lihe8_l",
		skin_inquire_relation = 69920,
		id_str = "com.yostaren.azurlane.luckybag17",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2022 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag17",
		extra_service_item = {
			{
				2,
				69920,
				1
			},
			{
				1,
				14,
				2022
			},
			{
				2,
				42046,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2023,
					9,
					21
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					10,
					4
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69920,
				1
			},
			{
				1,
				14,
				2022
			},
			{
				2,
				42046,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40920,
				1
			}
		}
	},
	[57] = {
		name = "Fashion Collection Lucky Bag ",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Fashion Collection Lucky Bag ",
		limit_arg = 1,
		name_display = "Fashion Collection Lucky Bag ",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 57,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "lihejp6ss_l",
		skin_inquire_relation = 69928,
		id_str = "com.yostaren.azurlane.luckybag15",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag15",
		extra_service_item = {
			{
				2,
				69928,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42056,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2023,
					9,
					14
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					10,
					4
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69928,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42056,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40928,
				1
			}
		}
	},
	[61] = {
		name = "Resplendent Night Lucky Bag I",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Resplendent Night Lucky Bag I",
		limit_arg = 1,
		name_display = "Resplendent Night Lucky Bag I",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 61,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai9",
		skin_inquire_relation = 86200,
		id_str = "com.yostaren.azurlane.luckybag21",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2024 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag21",
		extra_service_item = {
			{
				2,
				86200,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42056,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2023,
					12,
					21
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					1,
					3
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				86200,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42056,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81200,
				1
			}
		}
	},
	[62] = {
		name = "Winter Swimsuit Lucky Bag 2022 A Rerun",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Winter Swimsuit Lucky Bag 2022 A Rerun",
		limit_arg = 1,
		name_display = "Winter Swimsuit Lucky Bag 2022 A Rerun",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 62,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "lihe10_l",
		skin_inquire_relation = 69922,
		id_str = "com.yostaren.azurlane.luckybag20",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag20",
		extra_service_item = {
			{
				2,
				69922,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42046,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2023,
					12,
					21
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					1,
					3
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69922,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42046,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40922,
				1
			}
		}
	},
	[63] = {
		name = "Resplendent Night Lucky Bag II",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Resplendent Night Lucky Bag II",
		limit_arg = 1,
		name_display = "Resplendent Night Lucky Bag II",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 63,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai10",
		skin_inquire_relation = 86201,
		id_str = "com.yostaren.azurlane.luckybag23",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2024 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag23",
		extra_service_item = {
			{
				2,
				86201,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42056,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2023,
					12,
					28
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					1,
					10
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				86201,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42056,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81201,
				1
			}
		}
	},
	[64] = {
		name = "Winter Swimsuit Lucky Bag 2022 B Rerun",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Winter Swimsuit Lucky Bag 2022 B Rerun",
		limit_arg = 1,
		name_display = "Winter Swimsuit Lucky Bag 2022 B Rerun",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 64,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "lihe11_l",
		skin_inquire_relation = 69923,
		id_str = "com.yostaren.azurlane.luckybag22",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag22",
		extra_service_item = {
			{
				2,
				69923,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42046,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2023,
					12,
					28
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					1,
					10
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69923,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42046,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40923,
				1
			}
		}
	},
	[65] = {
		name = "Spring Lucky Box 2024 A",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Spring Lucky Box 2024 A",
		limit_arg = 1,
		name_display = "Spring Lucky Box 2024 A",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 65,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai11",
		skin_inquire_relation = 86202,
		id_str = "com.yostaren.azurlane.luckybag25",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2024 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag25",
		extra_service_item = {
			{
				2,
				86202,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42056,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2024,
					1,
					30
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					2,
					21
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				86202,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42056,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81202,
				1
			}
		}
	},
	[66] = {
		name = "Spring Lucky Bag 2023 A Rerun",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Spring Lucky Bag 2023 A Rerun",
		limit_arg = 1,
		name_display = "Spring Lucky Bag 2023 A Rerun",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 66,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudaiqp1",
		skin_inquire_relation = 69924,
		id_str = "com.yostaren.azurlane.luckybag24",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag24",
		extra_service_item = {
			{
				2,
				69924,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42046,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2024,
					1,
					30
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					2,
					21
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69924,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42046,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40924,
				1
			}
		}
	},
	[67] = {
		name = "Spring Lucky Box 2024 B",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Spring Lucky Box 2024 B",
		limit_arg = 1,
		name_display = "Spring Lucky Box 2024 B",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 67,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai12",
		skin_inquire_relation = 86203,
		id_str = "com.yostaren.azurlane.luckybag27",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2024 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag27",
		extra_service_item = {
			{
				2,
				86203,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42056,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2024,
					2,
					6
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					2,
					21
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				86203,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42056,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81203,
				1
			}
		}
	},
	[68] = {
		name = "Spring Lucky Bag 2023 B Rerun",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Spring Lucky Bag 2023 B Rerun",
		limit_arg = 1,
		name_display = "Spring Lucky Bag 2023 B Rerun",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 68,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudaiqp2",
		skin_inquire_relation = 69925,
		id_str = "com.yostaren.azurlane.luckybag26",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag26",
		extra_service_item = {
			{
				2,
				69925,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42046,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2024,
					2,
					6
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					2,
					21
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69925,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42046,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40925,
				1
			}
		}
	},
	[69] = {
		name = "Swimsuit Lucky Bag 2024",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Swimsuit Lucky Bag 2024",
		limit_arg = 1,
		name_display = "Swimsuit Lucky Bag 2024",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 69,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai13",
		skin_inquire_relation = 86204,
		id_str = "com.yostaren.azurlane.luckybag31",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2024 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag31",
		extra_service_item = {
			{
				2,
				86204,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42056,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2024,
					5,
					21
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					6,
					12
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				86204,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42056,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81204,
				1
			}
		}
	},
	[70] = {
		name = "Swimsuit Lucky Bag 2023 Rerun",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Swimsuit Lucky Bag 2023 Rerun",
		limit_arg = 1,
		name_display = "Swimsuit Lucky Bag 2023 Rerun",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 70,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "lihecn6ss_l",
		skin_inquire_relation = 69926,
		id_str = "com.yostaren.azurlane.luckybag32",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag32",
		extra_service_item = {
			{
				2,
				69926,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42046,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2024,
					5,
					21
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					6,
					12
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69926,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42046,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40926,
				1
			}
		}
	},
	[71] = {
		name = "Exquisite Lucky Envelope 2024",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Exquisite Lucky Envelope 2024",
		limit_arg = 1,
		name_display = "Exquisite Lucky Envelope 2024",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 71,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai14",
		skin_inquire_relation = 86205,
		id_str = "com.yostaren.azurlane.luckybag33",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2024 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag33",
		extra_service_item = {
			{
				2,
				86205,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42056,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2024,
					5,
					30
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					6,
					12
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				86205,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42056,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81205,
				1
			}
		}
	},
	[72] = {
		name = "Exquisite Lucky Box 2023 Rerun",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		subject = "Exquisite Lucky Box 2023 Rerun",
		limit_arg = 1,
		name_display = "Exquisite Lucky Box 2023 Rerun",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 72,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "lihecn6lf_l",
		skin_inquire_relation = 69927,
		id_str = "com.yostaren.azurlane.luckybag34",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag34",
		extra_service_item = {
			{
				2,
				69927,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42046,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2024,
					5,
					30
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					6,
					12
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69927,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42046,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40927,
				1
			}
		}
	},
	[73] = {
		name = "Dreamland Lucky Bag A",
		limit_group = 0,
		descrip_extra = "The pack includes lots of material rewards. The Startup Pack will be sent to you via in-game mail, please check your mailbox to claim the pack.",
		type = 1,
		subject = "Dreamland Lucky Bag A",
		limit_arg = 1,
		name_display = "Dreamland Lucky Bag A",
		show_group = "",
		type_order = 3,
		extra_service = 3,
		money = 2999,
		id = 73,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai15",
		skin_inquire_relation = 86206,
		id_str = "com.yostaren.azurlane.luckybag38",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2024 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag38",
		extra_service_item = {
			{
				2,
				86206,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42066,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2024,
					9,
					12
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					10,
					2
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				86206,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42066,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81206,
				1
			}
		}
	},
	[74] = {
		name = "Fashion Collection Lucky Bag Rerun",
		limit_group = 0,
		descrip_extra = "The pack includes lots of material rewards. The Startup Pack will be sent to you via in-game mail, please check your mailbox to claim the pack.",
		type = 1,
		subject = "Fashion Collection Lucky Bag Rerun",
		limit_arg = 1,
		name_display = "Fashion Collection Lucky Bag Rerun",
		show_group = "",
		type_order = 3,
		extra_service = 3,
		money = 2999,
		id = 74,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "lihejp6ss_l",
		skin_inquire_relation = 69928,
		id_str = "com.yostaren.azurlane.luckybag39",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag39",
		extra_service_item = {
			{
				2,
				69928,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42056,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2024,
					9,
					12
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					10,
					2
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69928,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42056,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40928,
				1
			}
		}
	},
	[75] = {
		name = "Dreamland Lucky Bag B",
		limit_group = 0,
		descrip_extra = "The pack includes lots of material rewards. The Startup Pack will be sent to you via in-game mail, please check your mailbox to claim the pack.",
		type = 1,
		subject = "Dreamland Lucky Bag B",
		limit_arg = 1,
		name_display = "Dreamland Lucky Bag B",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 75,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai16",
		skin_inquire_relation = 86207,
		id_str = "com.yostaren.azurlane.luckybag40",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2024 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag40",
		extra_service_item = {
			{
				2,
				86207,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42066,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2024,
					9,
					19
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					10,
					2
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				86207,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42066,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81207,
				1
			}
		}
	},
	[76] = {
		name = "Autumn Classics Lucky Box Rerun",
		limit_group = 0,
		descrip_extra = "The pack includes lots of material rewards. The Startup Pack will be sent to you via in-game mail, please check your mailbox to claim the pack.",
		type = 1,
		subject = "Autumn Classics Lucky Box Rerun",
		limit_arg = 1,
		name_display = "Autumn Classics Lucky Box Rerun",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 76,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "lihejp6lf_l",
		skin_inquire_relation = 69929,
		id_str = "com.yostaren.azurlane.luckybag41",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag41",
		extra_service_item = {
			{
				2,
				69929,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42056,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2024,
					9,
					19
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					10,
					2
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69929,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42056,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40929,
				1
			}
		}
	},
	[77] = {
		name = "Choose-Your-Own Gift Pack I",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Choose-Your-Own Gift Pack I",
		limit_arg = 1,
		name_display = "Choose-Your-Own Gift Pack I",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 1499,
		id = 77,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "pack_2024_98",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.bfchoosebag3",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 980x Gems, 1x Choose-Your-Own Gift Pack I, and loads of other valuable rewards.",
		airijp_id = "com.yostaren.azurlane.bfchoosebag3",
		extra_service_item = {
			{
				2,
				59555,
				1
			},
			{
				1,
				14,
				980
			},
			{
				2,
				16501,
				100
			},
			{
				2,
				59010,
				1000
			}
		},
		time = {
			{
				{
					2024,
					11,
					14
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					12,
					4
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				59555,
				1
			},
			{
				1,
				14,
				980
			},
			{
				2,
				16501,
				100
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81407,
				1
			}
		}
	},
	[78] = {
		name = "Choose-Your-Own Gift Pack II",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Choose-Your-Own Gift Pack II",
		limit_arg = 1,
		name_display = "Choose-Your-Own Gift Pack II",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 78,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "pack_2024_198",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.bfchoosebag4",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1980x Gems, 1x Choose-Your-Own Gift Pack II, and loads of other valuable rewards.",
		airijp_id = "com.yostaren.azurlane.bfchoosebag4",
		extra_service_item = {
			{
				2,
				59556,
				1
			},
			{
				1,
				14,
				1980
			},
			{
				2,
				15008,
				1000
			},
			{
				2,
				30114,
				30
			},
			{
				2,
				59010,
				2000
			}
		},
		time = {
			{
				{
					2024,
					11,
					14
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					12,
					4
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				59556,
				1
			},
			{
				1,
				14,
				1980
			},
			{
				2,
				15008,
				1000
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81408,
				1
			}
		}
	},
	[79] = {
		name = "Choose-Your-Own Gift Pack III",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Choose-Your-Own Gift Pack III",
		limit_arg = 1,
		name_display = "Choose-Your-Own Gift Pack III",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 4499,
		id = 79,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "pack_2024_328",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.bfchoosebag5",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 3280x Gems, 1x Choose-Your-Own Gift Pack III, and loads of other valuable rewards.",
		airijp_id = "com.yostaren.azurlane.bfchoosebag5",
		extra_service_item = {
			{
				2,
				59557,
				1
			},
			{
				1,
				14,
				3280
			},
			{
				2,
				15012,
				150
			},
			{
				2,
				15008,
				2000
			},
			{
				2,
				16004,
				2
			},
			{
				2,
				16014,
				2
			},
			{
				2,
				16024,
				2
			},
			{
				2,
				16032,
				30
			}
		},
		time = {
			{
				{
					2024,
					11,
					14
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					12,
					4
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				59557,
				1
			},
			{
				1,
				14,
				3280
			},
			{
				2,
				15012,
				150
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81409,
				1
			}
		}
	},
	[1000] = {
		name = "Fair Winds Cruise Pass",
		limit_group = 0,
		descrip_extra = "You must complete certain missions to obtain these rewards. ",
		type = 0,
		subject = "Fair Winds Cruise Pass",
		limit_arg = 1,
		name_display = "Fair Winds Cruise Pass",
		show_group = "",
		type_order = 0,
		extra_service = 4,
		money = 999,
		id = 1000,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "battlepass_1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.passport2",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Purchase to unlock additional Fair Winds Cruise rewards, including an exclusive outfit for Yorktown and more! ",
		airijp_id = "com.yostaren.azurlane.passport2",
		extra_service_item = {
			{
				1,
				4001,
				1500
			},
			{
				8,
				59242,
				1
			}
		},
		time = {
			{
				{
					2021,
					10,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2021,
					11,
					30
				},
				{
					22,
					59,
					59
				}
			}
		},
		display = {
			{
				1,
				4001,
				1500
			}
		},
		sub_display = {
			7001,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[1001] = {
		name = "Fair Winds Cruise Pass",
		limit_group = 0,
		descrip_extra = "You must complete certain missions to obtain these rewards. ",
		type = 0,
		subject = "Fair Winds Cruise Pass",
		limit_arg = 1,
		name_display = "Fair Winds Cruise Pass",
		show_group = "",
		type_order = 0,
		extra_service = 4,
		money = 999,
		id = 1001,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "battlepass_1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.passport3",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards. ",
		airijp_id = "com.yostaren.azurlane.passport3",
		extra_service_item = {
			{
				1,
				4002,
				1500
			},
			{
				8,
				59254,
				1
			}
		},
		time = {
			{
				{
					2021,
					12,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					1,
					31
				},
				{
					22,
					59,
					59
				}
			}
		},
		display = {
			{
				1,
				4002,
				1500
			}
		},
		sub_display = {
			7002,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[1002] = {
		name = "Fair Winds Cruise Pass",
		limit_group = 0,
		descrip_extra = "You must complete certain missions to obtain these rewards. ",
		type = 0,
		subject = "Fair Winds Cruise Pass",
		limit_arg = 1,
		name_display = "Fair Winds Cruise Pass",
		show_group = "",
		type_order = 0,
		extra_service = 4,
		money = 999,
		id = 1002,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "battlepass_1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.passport4",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards. ",
		airijp_id = "com.yostaren.azurlane.passport4",
		extra_service_item = {
			{
				1,
				4003,
				1500
			},
			{
				8,
				59270,
				1
			}
		},
		time = {
			{
				{
					2022,
					2,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					3,
					31
				},
				{
					22,
					59,
					59
				}
			}
		},
		display = {
			{
				1,
				4003,
				1500
			}
		},
		sub_display = {
			7003,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[1003] = {
		name = "Fair Winds Cruise Pass",
		limit_group = 0,
		descrip_extra = "You must complete certain missions to obtain these rewards. ",
		type = 0,
		subject = "Fair Winds Cruise Pass",
		limit_arg = 1,
		name_display = "Fair Winds Cruise Pass",
		show_group = "",
		type_order = 0,
		extra_service = 4,
		money = 999,
		id = 1003,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "battlepass_1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.passport5",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards. ",
		airijp_id = "com.yostaren.azurlane.passport5",
		extra_service_item = {
			{
				1,
				4004,
				1500
			},
			{
				8,
				59281,
				1
			}
		},
		time = {
			{
				{
					2022,
					4,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					5,
					31
				},
				{
					22,
					59,
					59
				}
			}
		},
		display = {
			{
				1,
				4004,
				1500
			}
		},
		sub_display = {
			7004,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[1004] = {
		name = "Fair Winds Cruise Pass",
		limit_group = 0,
		descrip_extra = "You must complete certain missions to obtain these rewards. ",
		type = 0,
		subject = "Fair Winds Cruise Pass",
		limit_arg = 1,
		name_display = "Fair Winds Cruise Pass",
		show_group = "",
		type_order = 0,
		extra_service = 4,
		money = 999,
		id = 1004,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "battlepass_1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.passport6",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards. ",
		airijp_id = "com.yostaren.azurlane.passport6",
		extra_service_item = {
			{
				1,
				4005,
				1500
			},
			{
				8,
				59291,
				1
			}
		},
		time = {
			{
				{
					2022,
					6,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					7,
					31
				},
				{
					22,
					59,
					59
				}
			}
		},
		display = {
			{
				1,
				4005,
				1500
			}
		},
		sub_display = {
			7005,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[1005] = {
		name = "Fair Winds Cruise Pass",
		limit_group = 0,
		descrip_extra = "You must complete certain missions to obtain these rewards. ",
		type = 0,
		subject = "Fair Winds Cruise Pass",
		limit_arg = 1,
		name_display = "Fair Winds Cruise Pass",
		show_group = "",
		type_order = 4,
		extra_service = 4,
		money = 999,
		id = 1005,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "battlepass_1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.passport7",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards. ",
		airijp_id = "com.yostaren.azurlane.passport7",
		extra_service_item = {
			{
				1,
				4006,
				1500
			},
			{
				8,
				59292,
				1
			}
		},
		time = {
			{
				{
					2022,
					8,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					9,
					30
				},
				{
					22,
					59,
					59
				}
			}
		},
		display = {
			{
				1,
				4006,
				1500
			}
		},
		sub_display = {
			7006,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[1006] = {
		name = "Fair Winds Cruise Pass",
		limit_group = 0,
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		subject = "Fair Winds Cruise Pass",
		limit_arg = 1,
		name_display = "Fair Winds Cruise Pass",
		show_group = "",
		type_order = 4,
		extra_service = 4,
		money = 999,
		id = 1006,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "battlepass_1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.passport8",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		airijp_id = "com.yostaren.azurlane.passport8",
		extra_service_item = {
			{
				1,
				4007,
				1500
			},
			{
				8,
				59294,
				1
			}
		},
		time = {
			{
				{
					2022,
					10,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					11,
					30
				},
				{
					22,
					59,
					59
				}
			}
		},
		display = {
			{
				1,
				4007,
				1500
			}
		},
		sub_display = {
			7007,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[1007] = {
		name = "Fair Winds Cruise Pass",
		limit_group = 0,
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		subject = "Fair Winds Cruise Pass",
		limit_arg = 1,
		name_display = "Fair Winds Cruise Pass",
		show_group = "",
		type_order = 4,
		extra_service = 4,
		money = 999,
		id = 1007,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "battlepass_1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.passport10",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		airijp_id = "com.yostaren.azurlane.passport10",
		extra_service_item = {
			{
				1,
				4008,
				1500
			},
			{
				8,
				59297,
				1
			}
		},
		time = {
			{
				{
					2022,
					12,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					1,
					31
				},
				{
					22,
					59,
					59
				}
			}
		},
		display = {
			{
				1,
				4008,
				1500
			}
		},
		sub_display = {
			7008,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[1008] = {
		name = "Fair Winds Cruise Pass",
		limit_group = 0,
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		subject = "Fair Winds Cruise Pass",
		limit_arg = 1,
		name_display = "Fair Winds Cruise Pass",
		show_group = "",
		type_order = 4,
		extra_service = 4,
		money = 999,
		id = 1008,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "battlepass_1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.passport11",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		airijp_id = "com.yostaren.azurlane.passport11",
		extra_service_item = {
			{
				1,
				4009,
				1500
			},
			{
				8,
				59299,
				1
			}
		},
		time = {
			{
				{
					2023,
					2,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					3,
					31
				},
				{
					22,
					59,
					59
				}
			}
		},
		display = {
			{
				1,
				4009,
				1500
			}
		},
		sub_display = {
			7009,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[1009] = {
		name = "Fair Winds Cruise Pass",
		limit_group = 0,
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		subject = "Fair Winds Cruise Pass",
		limit_arg = 1,
		name_display = "Fair Winds Cruise Pass",
		show_group = "",
		type_order = 4,
		extra_service = 4,
		money = 999,
		id = 1009,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "battlepass_1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.passport12",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		airijp_id = "com.yostaren.azurlane.passport12",
		extra_service_item = {
			{
				1,
				4010,
				1500
			},
			{
				8,
				59404,
				1
			}
		},
		time = {
			{
				{
					2023,
					4,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					5,
					31
				},
				{
					22,
					59,
					59
				}
			}
		},
		display = {
			{
				1,
				4010,
				1500
			}
		},
		sub_display = {
			7010,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[1010] = {
		name = "Fair Winds Cruise Pass (2023.6)",
		limit_group = 0,
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		subject = "Fair Winds Cruise Pass",
		limit_arg = 1,
		name_display = "Fair Winds Cruise Pass",
		show_group = "",
		type_order = 4,
		extra_service = 4,
		money = 999,
		id = 1010,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "battlepass_1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.passport13",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		airijp_id = "com.yostaren.azurlane.passport13",
		extra_service_item = {
			{
				1,
				4011,
				1500
			},
			{
				8,
				59456,
				1
			}
		},
		time = {
			{
				{
					2023,
					6,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					7,
					31
				},
				{
					22,
					59,
					59
				}
			}
		},
		display = {
			{
				1,
				4011,
				1500
			}
		},
		sub_display = {
			7011,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[1011] = {
		name = "Fair Winds Cruise Pass (2023.8)",
		limit_group = 0,
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		subject = "Fair Winds Cruise Pass",
		limit_arg = 1,
		name_display = "Fair Winds Cruise Pass",
		show_group = "",
		type_order = 4,
		extra_service = 4,
		money = 999,
		id = 1011,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "battlepass_1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.passport14",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		airijp_id = "com.yostaren.azurlane.passport14",
		extra_service_item = {
			{
				1,
				4012,
				1500
			},
			{
				8,
				59468,
				1
			}
		},
		time = {
			{
				{
					2023,
					8,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					9,
					30
				},
				{
					22,
					59,
					59
				}
			}
		},
		display = {
			{
				1,
				4012,
				1500
			}
		},
		sub_display = {
			7012,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[1012] = {
		name = "Fair Winds Cruise Pass (2023.10)",
		limit_group = 0,
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		subject = "Fair Winds Cruise Pass",
		limit_arg = 1,
		name_display = "Fair Winds Cruise Pass",
		show_group = "",
		type_order = 4,
		extra_service = 4,
		money = 999,
		id = 1012,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "battlepass_1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.passport15",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		airijp_id = "com.yostaren.azurlane.passport15",
		extra_service_item = {
			{
				1,
				4013,
				1500
			},
			{
				8,
				59494,
				1
			}
		},
		time = {
			{
				{
					2023,
					10,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					11,
					30
				},
				{
					22,
					59,
					59
				}
			}
		},
		display = {
			{
				1,
				4013,
				1500
			}
		},
		sub_display = {
			7013,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[1013] = {
		name = "Fair Winds Cruise Pass (2023.12)",
		limit_group = 0,
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		subject = "Fair Winds Cruise Pass",
		limit_arg = 1,
		name_display = "Fair Winds Cruise Pass",
		show_group = "",
		type_order = 4,
		extra_service = 4,
		money = 999,
		id = 1013,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "battlepass_1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.passport16",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		airijp_id = "com.yostaren.azurlane.passport16",
		extra_service_item = {
			{
				1,
				4014,
				1500
			},
			{
				8,
				59511,
				1
			}
		},
		time = {
			{
				{
					2023,
					12,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					1,
					31
				},
				{
					22,
					59,
					59
				}
			}
		},
		display = {
			{
				1,
				4014,
				1500
			}
		},
		sub_display = {
			7014,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[1014] = {
		name = "Fair Winds Cruise Pass (2024.2)",
		limit_group = 0,
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		subject = "Fair Winds Cruise Pass",
		limit_arg = 1,
		name_display = "Fair Winds Cruise Pass",
		show_group = "",
		type_order = 4,
		extra_service = 4,
		money = 999,
		id = 1014,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "battlepass_1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.passport17",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		airijp_id = "com.yostaren.azurlane.passport17",
		extra_service_item = {
			{
				1,
				4015,
				1500
			},
			{
				8,
				59526,
				1
			}
		},
		time = {
			{
				{
					2024,
					2,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					3,
					31
				},
				{
					22,
					59,
					59
				}
			}
		},
		display = {
			{
				1,
				4015,
				1500
			}
		},
		sub_display = {
			7015,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[1015] = {
		name = "Fair Winds Cruise Pass (2024.4)",
		limit_group = 0,
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		subject = "Fair Winds Cruise Pass",
		limit_arg = 1,
		name_display = "Fair Winds Cruise Pass",
		show_group = "",
		type_order = 4,
		extra_service = 4,
		money = 999,
		id = 1015,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "battlepass_1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.passport18",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		airijp_id = "com.yostaren.azurlane.passport18",
		extra_service_item = {
			{
				1,
				4016,
				1500
			},
			{
				8,
				59541,
				1
			}
		},
		time = {
			{
				{
					2024,
					4,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					5,
					31
				},
				{
					22,
					59,
					59
				}
			}
		},
		display = {
			{
				1,
				4016,
				1500
			}
		},
		sub_display = {
			7016,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[1016] = {
		name = "Fair Winds Cruise Pass (2024.6)",
		limit_group = 0,
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		subject = "Fair Winds Cruise Pass",
		limit_arg = 1,
		name_display = "Fair Winds Cruise Pass",
		show_group = "",
		type_order = 4,
		extra_service = 4,
		money = 999,
		id = 1016,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "battlepass_1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.passport19",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		airijp_id = "com.yostaren.azurlane.passport19",
		extra_service_item = {
			{
				1,
				4017,
				1500
			},
			{
				8,
				59584,
				1
			}
		},
		time = {
			{
				{
					2024,
					6,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					7,
					31
				},
				{
					22,
					59,
					59
				}
			}
		},
		display = {
			{
				1,
				4017,
				1500
			}
		},
		sub_display = {
			7017,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[1017] = {
		name = "Fair Winds Cruise Pass (2024.8)",
		limit_group = 0,
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		subject = "Fair Winds Cruise Pass",
		limit_arg = 1,
		name_display = "Fair Winds Cruise Pass",
		show_group = "",
		type_order = 4,
		extra_service = 4,
		money = 999,
		id = 1017,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "battlepass_1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.passport20",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		airijp_id = "com.yostaren.azurlane.passport20",
		extra_service_item = {
			{
				1,
				4018,
				1500
			},
			{
				8,
				65001,
				1
			}
		},
		time = {
			{
				{
					2024,
					8,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					9,
					30
				},
				{
					22,
					59,
					59
				}
			}
		},
		display = {
			{
				1,
				4018,
				1500
			}
		},
		sub_display = {
			7018,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[1018] = {
		name = "Fair Winds Cruise Pass (2024.10)",
		limit_group = 0,
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		subject = "Fair Winds Cruise Pass",
		limit_arg = 1,
		name_display = "Fair Winds Cruise Pass",
		show_group = "",
		type_order = 4,
		extra_service = 4,
		money = 999,
		id = 1018,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "battlepass_1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.passport21",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		airijp_id = "com.yostaren.azurlane.passport21",
		extra_service_item = {
			{
				1,
				4019,
				1500
			},
			{
				8,
				65028,
				1
			}
		},
		time = {
			{
				{
					2024,
					10,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					11,
					30
				},
				{
					22,
					59,
					59
				}
			}
		},
		display = {
			{
				1,
				4019,
				1500
			}
		},
		sub_display = {
			7019,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[2001] = {
		name = "PR Construction Pack - Series 1",
		limit_group = 1,
		descrip_extra = "",
		type = 0,
		subject = "PR Construction Pack - Series 1",
		limit_arg = 0,
		name_display = "PR Construction Pack - Series 1",
		show_group = "tech",
		type_order = 0,
		extra_service = 3,
		money = 1599,
		id = 2001,
		tag = 2,
		gem = 0,
		limit_type = 3,
		time = "always",
		picture = "tech1_display",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond158",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains one PR Voucher - Series 1 and 343 General Blueprints - Series 1.",
		airijp_id = "com.yostaren.azurlane.diamond158",
		extra_service_item = {
			{
				2,
				40124,
				1
			},
			{
				2,
				42000,
				343
			}
		},
		display = {
			{
				2,
				40124,
				1
			},
			{
				2,
				42000,
				343
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {
			{
				"level",
				30
			}
		},
		drop_item = {}
	},
	[2002] = {
		name = "PR Voucher & Blueprint Bundle - Series 1",
		limit_group = 1,
		descrip_extra = "If you've already built all Series 1 PRs, the contents will be exchanged for other items. Tap the icon to view the item table.",
		type = 0,
		subject = "Voucher & Blueprint Bundle",
		limit_arg = 1,
		name_display = "PR Voucher & Blueprint \n         Bundle - Series 1",
		show_group = "tech",
		type_order = 0,
		extra_service = 3,
		money = 1599,
		id = 2002,
		tag = 2,
		gem = 0,
		limit_type = 3,
		time = "always",
		picture = "tech1_promotion",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond158",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains:",
		airijp_id = "com.yostaren.azurlane.diamond158",
		extra_service_item = {
			{
				2,
				40124,
				1
			},
			{
				2,
				42000,
				343
			}
		},
		display = {
			{
				2,
				40124,
				1
			},
			{
				2,
				42000,
				343
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {
			{
				"level",
				30
			}
		},
		drop_item = {
			{
				2,
				40016,
				1
			}
		}
	},
	[2003] = {
		name = "PR Voucher - Series 1",
		limit_group = 1,
		descrip_extra = "If you've already built all Series 1 PRs, the contents will be exchanged for other items. Tap the icon to view the item table.",
		type = 0,
		subject = "Voucher",
		limit_arg = 2,
		name_display = "PR Voucher - Series 1",
		show_group = "tech",
		type_order = 0,
		extra_service = 3,
		money = 999,
		id = 2003,
		tag = 2,
		gem = 0,
		limit_type = 3,
		time = "always",
		picture = "tech1_normal",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond159",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains:",
		airijp_id = "com.yostaren.azurlane.diamond159",
		extra_service_item = {
			{
				2,
				40124,
				1
			}
		},
		display = {
			{
				2,
				40124,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {
			{
				"level",
				30
			}
		},
		drop_item = {
			{
				2,
				40017,
				1
			}
		}
	},
	[2004] = {
		name = "PR Blueprint Pack - Series 1",
		limit_group = 1,
		descrip_extra = "Buy to receive 343 General Blueprints - Series 1.",
		type = 0,
		subject = "Blueprints",
		limit_arg = 3,
		name_display = "PR Blueprint Pack - Series 1",
		show_group = "tech",
		type_order = 0,
		extra_service = 3,
		money = 699,
		id = 2004,
		tag = 2,
		gem = 0,
		limit_type = 3,
		time = "always",
		picture = "tech1_promotion",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond160",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains:",
		airijp_id = "com.yostaren.azurlane.diamond160",
		extra_service_item = {
			{
				2,
				42000,
				343
			}
		},
		display = {
			{
				2,
				42000,
				343
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {
			{
				"level",
				30
			}
		},
		drop_item = {
			{
				2,
				40018,
				1
			}
		}
	},
	[2005] = {
		name = "PR Construction Pack - Series 2",
		limit_group = 2,
		descrip_extra = "",
		type = 0,
		subject = "PR Construction Pack - Series 2",
		limit_arg = 0,
		name_display = "PR Construction Pack - Series 2",
		show_group = "tech",
		type_order = 0,
		extra_service = 3,
		money = 1599,
		id = 2005,
		tag = 2,
		gem = 0,
		limit_type = 3,
		time = "always",
		picture = "tech2_display",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond161",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains one PR Voucher - Series 2 and 343 General Blueprints - Series 2.",
		airijp_id = "com.yostaren.azurlane.diamond161",
		extra_service_item = {
			{
				2,
				40125,
				1
			},
			{
				2,
				42010,
				343
			}
		},
		display = {
			{
				2,
				40125,
				1
			},
			{
				2,
				42010,
				343
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {
			{
				"level",
				30
			}
		},
		drop_item = {}
	},
	[2006] = {
		name = "PR Voucher & Blueprint Bundle - Series 2",
		limit_group = 2,
		descrip_extra = "If you've already built all Series 2 PRs, the contents will be exchanged for other items. Tap the icon to view the item table.",
		type = 0,
		subject = "PR Voucher & Blueprint Bundle - Series 2",
		limit_arg = 1,
		name_display = "PR Voucher & Blueprint \n         Bundle - Series 2",
		show_group = "tech",
		type_order = 0,
		extra_service = 3,
		money = 1599,
		id = 2006,
		tag = 2,
		gem = 0,
		limit_type = 3,
		time = "always",
		picture = "tech2_promotion",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond161",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains:",
		airijp_id = "com.yostaren.azurlane.diamond161",
		extra_service_item = {
			{
				2,
				40125,
				1
			},
			{
				2,
				42010,
				343
			}
		},
		display = {
			{
				2,
				40125,
				1
			},
			{
				2,
				42010,
				343
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {
			{
				"level",
				30
			}
		},
		drop_item = {
			{
				2,
				40019,
				1
			}
		}
	},
	[2007] = {
		name = "PR Voucher - Series 2",
		limit_group = 2,
		descrip_extra = "If you've already built all Series 2 PRs, the contents will be exchanged for other items. Tap the icon to view the item table.",
		type = 0,
		subject = "Voucher",
		limit_arg = 2,
		name_display = "PR Voucher - Series 2",
		show_group = "tech",
		type_order = 0,
		extra_service = 3,
		money = 999,
		id = 2007,
		tag = 2,
		gem = 0,
		limit_type = 3,
		time = "always",
		picture = "tech2_normal",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond162",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains:",
		airijp_id = "com.yostaren.azurlane.diamond162",
		extra_service_item = {
			{
				2,
				40125,
				1
			}
		},
		display = {
			{
				2,
				40125,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {
			{
				"level",
				30
			}
		},
		drop_item = {
			{
				2,
				40020,
				1
			}
		}
	},
	[2008] = {
		name = "PR Blueprint Pack - Series 2",
		limit_group = 2,
		descrip_extra = "Buy to receive 343 General Blueprints - Series 2.",
		type = 0,
		subject = "Blueprints",
		limit_arg = 3,
		name_display = "PR Blueprint Pack - Series 2",
		show_group = "tech",
		type_order = 0,
		extra_service = 3,
		money = 699,
		id = 2008,
		tag = 2,
		gem = 0,
		limit_type = 3,
		time = "always",
		picture = "tech2_promotion",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond163",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains:",
		airijp_id = "com.yostaren.azurlane.diamond163",
		extra_service_item = {
			{
				2,
				42010,
				343
			}
		},
		display = {
			{
				2,
				42010,
				343
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {
			{
				"level",
				30
			}
		},
		drop_item = {
			{
				2,
				40021,
				1
			}
		}
	},
	[2009] = {
		name = "Commander Level Boost Pack",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Commander Level Boost Pack",
		limit_arg = 1,
		name_display = "Commander Level Boost Pack",
		show_group = "",
		type_order = 7,
		extra_service = 3,
		money = 499,
		id = 2009,
		tag = 2,
		gem = 0,
		limit_type = 2,
		time = "always",
		picture = "lv_70",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond164",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Buying this pack will raise your Commander Level to 70 and grant you many useful items.",
		airijp_id = "com.yostaren.azurlane.diamond164",
		extra_service_item = {
			{
				2,
				40126,
				1
			},
			{
				2,
				16502,
				200
			},
			{
				4,
				100011,
				4
			},
			{
				4,
				100001,
				4
			},
			{
				2,
				69001,
				1
			}
		},
		display = {
			{
				2,
				40126,
				1
			},
			{
				2,
				16502,
				200
			},
			{
				4,
				100011,
				4
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {
			{
				"lv_70",
				70
			}
		},
		drop_item = {
			{
				2,
				40022,
				1
			}
		}
	},
	[2010] = {
		name = "Skill Book Pack",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Skill Book Pack",
		limit_arg = 4,
		name_display = "Skill Book Pack",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 299,
		id = 2010,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "boxSkill",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond165",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Buy to receive a large amount of Skill Books.",
		airijp_id = "com.yostaren.azurlane.diamond165",
		extra_service_item = {
			{
				2,
				16004,
				1
			},
			{
				2,
				16014,
				1
			},
			{
				2,
				16024,
				1
			},
			{
				2,
				16003,
				3
			},
			{
				2,
				16013,
				3
			},
			{
				2,
				16023,
				3
			}
		},
		time = {
			{
				{
					2022,
					4,
					14
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					6,
					30
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				16004,
				1
			},
			{
				2,
				16014,
				1
			},
			{
				2,
				16024,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40023,
				1
			}
		}
	},
	[2011] = {
		name = "Skill Book Pack",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Skill Book Pack",
		limit_arg = 4,
		name_display = "Skill Book Pack",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 299,
		id = 2011,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "boxSkill",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond172",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Buy to receive a large amount of Skill Books.",
		airijp_id = "com.yostaren.azurlane.diamond172",
		extra_service_item = {
			{
				2,
				16004,
				1
			},
			{
				2,
				16014,
				1
			},
			{
				2,
				16024,
				1
			},
			{
				2,
				16003,
				3
			},
			{
				2,
				16013,
				3
			},
			{
				2,
				16023,
				3
			}
		},
		time = {
			{
				{
					2022,
					9,
					15
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					11,
					30
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				16004,
				1
			},
			{
				2,
				16014,
				1
			},
			{
				2,
				16024,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40023,
				1
			}
		}
	},
	[100] = {
		name = "Nep's Lucky Bag ",
		limit_group = 0,
		descrip_extra = "*Nep's Lucky Bag will appear in your mailbox. \n* If you draw an already owned ship skin, you will be refunded 80% of the gem cost.",
		type = 1,
		subject = "Nep's Lucky Bag",
		limit_arg = 1,
		name_display = "Nep's Lucky Bag ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 100,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "usfudai1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond110",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1 x Nep Ship skin, 3 x Nep Gear skins, and other rewards.",
		airijp_id = "com.yostaren.azurlane.diamond110",
		extra_service_item = {
			{
				2,
				69951,
				1
			},
			{
				1,
				4,
				2018
			},
			{
				2,
				30303,
				3
			},
			{
				2,
				15003,
				4
			},
			{
				2,
				20001,
				8
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2018,
					11,
					22
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2018,
					12,
					5
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69951,
				1
			},
			{
				1,
				4,
				2018
			},
			{
				2,
				30303,
				3
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[101] = {
		name = "Black Friday Lucky Bag ",
		limit_group = 0,
		descrip_extra = "*Black Friday Lucky Bag will appear in your mailbox. \n* If you draw an already owned ship skin, you will be refunded 100% of the gem cost.",
		type = 1,
		subject = "Black Friday Lucky Bag",
		limit_arg = 1,
		name_display = "Black Friday Lucky Bag ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 101,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "usfudai2",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond111",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1 x School Girl Ship skin, 3 x School Gear skins, and other rewards.",
		airijp_id = "com.yostaren.azurlane.diamond111",
		extra_service_item = {
			{
				2,
				69952,
				1
			},
			{
				1,
				4,
				2018
			},
			{
				2,
				30305,
				3
			},
			{
				2,
				15003,
				4
			},
			{
				2,
				20001,
				8
			},
			{
				1,
				6,
				100
			},
			{
				1,
				2,
				1000
			},
			{
				2,
				54035,
				1
			}
		},
		time = {
			{
				{
					2018,
					11,
					22
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2018,
					12,
					5
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69952,
				1
			},
			{
				1,
				4,
				2018
			},
			{
				2,
				30305,
				3
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[102] = {
		name = "Christmas Lucky Bag ",
		limit_group = 0,
		descrip_extra = "*Christmas Lucky Bag will appear in your mailbox. \n* If you drew a ship skin that you already have, you will be refunded 80% of the gem cost. ",
		type = 1,
		subject = "Christmas Lucky Bag ",
		limit_arg = 1,
		name_display = "Christmas Lucky Bag ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 102,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond112",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1 x Christmas Ship skin, 3 x Christmas Gear skins, and other rewards. ",
		airijp_id = "com.yostaren.azurlane.diamond112",
		extra_service_item = {
			{
				2,
				69953,
				1
			},
			{
				1,
				4,
				2018
			},
			{
				2,
				30306,
				3
			},
			{
				2,
				15003,
				4
			},
			{
				2,
				20001,
				8
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2018,
					12,
					13
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2018,
					12,
					30
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69953,
				1
			},
			{
				1,
				4,
				2018
			},
			{
				2,
				30306,
				3
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[103] = {
		name = "Heartthrob Pack",
		limit_group = 0,
		descrip_extra = "*The pack contains 1 x Promise Ring, 1 x Universal Bulin, 10 x Quick Finishers, and 5 x Full Courses",
		type = 1,
		subject = "Heartthrob Pack",
		limit_arg = 1,
		name_display = "Heartthrob Pack",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 999,
		id = 103,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai49",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond113",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1 x Promise Ring, 1 x Universal Bulin, 10 x Quick Finishers, and 5 x Full Courses",
		airijp_id = "com.yostaren.azurlane.diamond113",
		extra_service_item = {
			{
				2,
				15006,
				1
			},
			{
				4,
				100001,
				1
			},
			{
				2,
				15003,
				10
			},
			{
				2,
				50006,
				5
			}
		},
		time = {
			{
				{
					2018,
					12,
					21
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2018,
					12,
					30
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				15006,
				1
			},
			{
				2,
				15003,
				10
			},
			{
				2,
				50006,
				5
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[104] = {
		name = "Santa's Lucky Sack (Daily)",
		limit_group = 0,
		descrip_extra = "*The sack contains 1 x Mystery T4 Tech Pack, 6 x Wisdom Cubes, 3 x Quick Finishers, 100 x Gems, and 3000 x Coins",
		type = 1,
		subject = "Santa's Lucky Sack (Daily)",
		limit_arg = 1,
		name_display = "Santa's Lucky Sack (Daily)",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 499,
		id = 104,
		tag = 2,
		gem = 0,
		limit_type = 99,
		picture = "fudai50",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond114",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1 x Mystery T4 Tech Pack, 6 x Wisdom Cubes, 3 x Quick Finishers, 100 x Gems, and 3000 x Coins",
		airijp_id = "com.yostaren.azurlane.diamond114",
		extra_service_item = {
			{
				2,
				54039,
				1
			},
			{
				2,
				20001,
				6
			},
			{
				2,
				15003,
				3
			},
			{
				1,
				4,
				100
			},
			{
				1,
				1,
				3000
			}
		},
		time = {
			{
				{
					2018,
					12,
					21
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2018,
					12,
					31
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				54039,
				1
			},
			{
				1,
				4,
				100
			},
			{
				1,
				1,
				3000
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[105] = {
		name = "Shougatsu Lucky Bag (2019)",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		subject = "Shogatsu Lucky Bag ",
		limit_arg = 1,
		name_display = "Shougatsu Lucky Bag (2019)",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 105,
		tag = 1,
		gem = 0,
		limit_type = 2,
		picture = "fudai51",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond115",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1 x Kimono Ship skin, 2019 x Gems, and other rewards. ",
		airijp_id = "com.yostaren.azurlane.diamond115",
		extra_service_item = {
			{
				2,
				69903,
				1
			},
			{
				1,
				4,
				2019
			},
			{
				2,
				17003,
				20
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2019,
					1,
					10
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2019,
					1,
					31
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69903,
				1
			},
			{
				1,
				4,
				2019
			},
			{
				2,
				17003,
				20
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[106] = {
		name = "Lunar New Year Lucky Bag (2019)",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you’ve received a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		subject = "Lunar New Year Lucky Bag ",
		limit_arg = 1,
		name_display = "Lunar New Year Lucky Bag (2019)",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 106,
		tag = 1,
		gem = 0,
		limit_type = 2,
		picture = "fudai52",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond116",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1 x Ship skin, 2019 x Gems, and other rewards. ",
		airijp_id = "com.yostaren.azurlane.diamond116",
		extra_service_item = {
			{
				2,
				69904,
				1
			},
			{
				1,
				4,
				2019
			},
			{
				2,
				18013,
				1
			},
			{
				2,
				18012,
				5
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2019,
					1,
					31
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2019,
					2,
					13
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69904,
				1
			},
			{
				1,
				4,
				2019
			},
			{
				2,
				18013,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[107] = {
		name = "Glacier Blast ",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		subject = "Glacier Blast ",
		limit_arg = 1,
		name_display = "Glacier Blast ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 107,
		tag = 1,
		gem = 0,
		limit_type = 2,
		picture = "fudai53",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond117",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1 x random Ship skin (Winter‘s Crown), 3 x random Gear skins (Winter's Crown), and other rewards ",
		airijp_id = "com.yostaren.azurlane.diamond117",
		extra_service_item = {
			{
				2,
				69954,
				1
			},
			{
				1,
				4,
				2019
			},
			{
				2,
				30311,
				3
			},
			{
				2,
				15003,
				10
			},
			{
				2,
				20001,
				20
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2019,
					2,
					21
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2019,
					3,
					13
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69954,
				1
			},
			{
				1,
				4,
				2019
			},
			{
				2,
				30311,
				3
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[108] = {
		name = "Hanami Lucky Bag ",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems.",
		type = 1,
		subject = "Hanami Lucky Bag ",
		limit_arg = 1,
		name_display = "Hanami Lucky Bag ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 108,
		tag = 1,
		gem = 0,
		limit_type = 2,
		picture = "fudai54",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond118",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1 x random Ship skin (Hanami), 100 x Cognitive Chips, and other rewards",
		airijp_id = "com.yostaren.azurlane.diamond118",
		extra_service_item = {
			{
				2,
				69955,
				1
			},
			{
				1,
				4,
				2019
			},
			{
				2,
				15008,
				100
			},
			{
				2,
				15003,
				10
			},
			{
				2,
				20001,
				20
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2019,
					4,
					11
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2019,
					4,
					25
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69955,
				1
			},
			{
				1,
				4,
				2019
			},
			{
				2,
				15008,
				100
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[109] = {
		name = "Research Supply (daily) ",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox.",
		type = 1,
		subject = "Research Supply (daily) ",
		limit_arg = 1,
		name_display = "Research Supply (daily) ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 499,
		id = 109,
		tag = 2,
		gem = 0,
		limit_type = 99,
		picture = "fudai55",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond119",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1 x Random Blueprint, 6 x Wisdom Cubes, 3 x Quick Finishers, 100 x Gems, and 3000 x Coins ",
		airijp_id = "com.yostaren.azurlane.diamond119",
		extra_service_item = {
			{
				2,
				52001,
				1
			},
			{
				2,
				20001,
				6
			},
			{
				2,
				15003,
				3
			},
			{
				1,
				4,
				100
			},
			{
				1,
				1,
				3000
			}
		},
		time = {
			{
				{
					2019,
					5,
					5
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2019,
					5,
					15
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				52001,
				1
			},
			{
				1,
				4,
				100
			},
			{
				2,
				20001,
				6
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[110] = {
		name = "Scherzo Lucky Box ",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Lucky Box will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		subject = "Scherzo Lucky Box ",
		limit_arg = 1,
		name_display = "Scherzo Lucky Box ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 110,
		tag = 1,
		gem = 0,
		limit_type = 2,
		picture = "lihe1_l",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond120",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1 x random Ship skin, 2019 x Gems, and other rewards ",
		airijp_id = "com.yostaren.azurlane.diamond120",
		extra_service_item = {
			{
				2,
				69905,
				1
			},
			{
				1,
				4,
				2019
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2019,
					5,
					1
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2019,
					6,
					12
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69905,
				1
			},
			{
				1,
				4,
				2019
			},
			{
				2,
				15008,
				50
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[111] = {
		name = "1st Anniversary Lucky Bag ",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Lucky Box will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's on sale value in Gems. ",
		type = 1,
		subject = "1st Anniversary Lucky Bag ",
		limit_arg = 1,
		name_display = "1st Anniversary Lucky Bag ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 111,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai56",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond121",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1 x random Ship skin, 2019 x Gems, and other rewards ",
		airijp_id = "com.yostaren.azurlane.diamond121",
		extra_service_item = {
			{
				2,
				69956,
				1
			},
			{
				1,
				4,
				2019
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2019,
					8,
					15
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2019,
					9,
					4
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69905,
				1
			},
			{
				1,
				4,
				2019
			},
			{
				2,
				15008,
				50
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[112] = {
		name = "Yukata Lucky Bag",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Lucky Box will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		subject = "Yukata Lucky Bag",
		limit_arg = 1,
		name_display = "Yukata Lucky Bag",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 112,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai57",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond122",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1 x random Ship skin, 2019 x Gems, and other rewards ",
		airijp_id = "com.yostaren.azurlane.diamond122",
		extra_service_item = {
			{
				2,
				69957,
				1
			},
			{
				1,
				4,
				2019
			},
			{
				2,
				20013,
				1
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2019,
					8,
					29
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2019,
					9,
					4
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69905,
				1
			},
			{
				1,
				4,
				2019
			},
			{
				2,
				20013,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[113] = {
		name = "Full Dress Lucky Bag ",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Lucky Box will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		subject = "Full Dress Lucky Bag ",
		limit_arg = 1,
		name_display = "Full Dress Lucky Bag ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 113,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai58",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond123",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1 x random Ship skin, 2019 x Gems, and other rewards ",
		airijp_id = "com.yostaren.azurlane.diamond123",
		extra_service_item = {
			{
				2,
				69906,
				1
			},
			{
				1,
				4,
				2019
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2019,
					9,
					19
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2019,
					10,
					9
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69906,
				1
			},
			{
				1,
				4,
				2019
			},
			{
				2,
				15008,
				50
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[114] = {
		name = "Black Friday Lucky Box ",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Lucky Box will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		subject = "Black Friday Lucky Box ",
		limit_arg = 1,
		name_display = "Black Friday Lucky Box ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 114,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai59",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond124",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1 x random Ship skin, 2450 x Gems, and other rewards ",
		airijp_id = "com.yostaren.azurlane.diamond124",
		extra_service_item = {
			{
				2,
				69958,
				1
			},
			{
				1,
				4,
				2450
			},
			{
				2,
				54035,
				1
			},
			{
				2,
				54006,
				3
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2019,
					11,
					21
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2019,
					12,
					4
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69958,
				1
			},
			{
				1,
				4,
				2450
			},
			{
				2,
				54035,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[115] = {
		name = "Christmas Lucky Bag ",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		subject = "Christmas Lucky Bag ",
		limit_arg = 1,
		name_display = "Christmas Lucky Bag ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 115,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai60",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond125",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1 x random Ship skin, 2019 x Gems, and other rewards ",
		airijp_id = "com.yostaren.azurlane.diamond125",
		extra_service_item = {
			{
				2,
				69960,
				1
			},
			{
				1,
				4,
				2019
			},
			{
				1,
				2,
				2000
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2019,
					12,
					19
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2020,
					1,
					2
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69960,
				1
			},
			{
				1,
				4,
				2019
			},
			{
				1,
				2,
				2000
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[116] = {
		name = "Shougatsu Lucky Bag (2020)",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		subject = "Shougatsu Lucky Bag (2020)",
		limit_arg = 1,
		name_display = "Shougatsu Lucky Bag (2020)",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 116,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond126",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1 x random Ship skin, 2020 x Gems, and other rewards. ",
		airijp_id = "com.yostaren.azurlane.diamond126",
		extra_service_item = {
			{
				2,
				69908,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				42017,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2019,
					12,
					26
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2020,
					1,
					8
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69908,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				42017,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[117] = {
		name = "Shougatsu Lucky Bag (2019)",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		subject = "Shougatsu Lucky Bag (2019)",
		limit_arg = 1,
		name_display = "Shougatsu Lucky Bag (2019)",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 117,
		tag = 1,
		gem = 0,
		limit_type = 2,
		picture = "fudai",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond127",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1 x random Ship skin, 2019 x Gems, and other rewards. ",
		airijp_id = "com.yostaren.azurlane.diamond127",
		extra_service_item = {
			{
				2,
				69903,
				1
			},
			{
				1,
				4,
				2019
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2019,
					12,
					26
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2020,
					1,
					8
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69903,
				1
			},
			{
				1,
				4,
				2019
			},
			{
				2,
				15008,
				50
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[118] = {
		name = "Lunar New Year Lucky Bag (2020)",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		subject = "Lunar New Year Lucky Bag (2020)",
		limit_arg = 1,
		name_display = "Lunar New Year Lucky Bag (2020)",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 118,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai2",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond128",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1 x random Ship skin, 2020 x Gems, and other rewards. ",
		airijp_id = "com.yostaren.azurlane.diamond128",
		extra_service_item = {
			{
				2,
				69909,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				42017,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2020,
					1,
					15
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2020,
					2,
					5
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69909,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				42017,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[119] = {
		name = "Lunar New Year Lucky Bag (2019)",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		subject = "Lunar New Year Lucky Bag (2019)",
		limit_arg = 1,
		name_display = "Lunar New Year Lucky Bag (2019)",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 119,
		tag = 1,
		gem = 0,
		limit_type = 2,
		picture = "fudai",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond129",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1 x random Ship skin, 2019 x Gems, and other rewards. ",
		airijp_id = "com.yostaren.azurlane.diamond129",
		extra_service_item = {
			{
				2,
				69904,
				1
			},
			{
				1,
				4,
				2019
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2020,
					1,
					15
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2020,
					2,
					5
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69904,
				1
			},
			{
				1,
				4,
				2019
			},
			{
				2,
				15008,
				50
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[120] = {
		name = "New Commanders Support Pack I",
		limit_group = 0,
		descrip_extra = "The pack includes lots of material rewards. The Startup Pack will be sent to you via in-game mail, please check your mailbox to claim the pack. ",
		type = 1,
		subject = "New Commanders Support Pack I",
		limit_arg = 1,
		name_display = "New Commanders Support Pack I",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 299,
		id = 120,
		tag = 1,
		gem = 0,
		limit_type = 2,
		time = "always",
		picture = "support1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond130",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 180 Gems, 2x Oil Reserve Supply (1000) Packs, and more!",
		airijp_id = "com.yostaren.azurlane.diamond130",
		extra_service_item = {
			{
				1,
				14,
				180
			},
			{
				2,
				30121,
				2
			},
			{
				4,
				100001,
				1
			},
			{
				2,
				15001,
				30
			},
			{
				2,
				16002,
				4
			},
			{
				2,
				16012,
				4
			},
			{
				2,
				16022,
				4
			},
			{
				2,
				30112,
				30
			}
		},
		display = {
			{
				1,
				14,
				180
			},
			{
				2,
				30121,
				2
			},
			{
				4,
				100001,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40012,
				1
			}
		}
	},
	[121] = {
		name = "New Commanders Support Pack II",
		limit_group = 0,
		descrip_extra = "The pack includes lots of material rewards. The Startup Pack will be sent to you via in-game mail, please check your mailbox to claim the pack. ",
		type = 1,
		subject = "New Commanders Support Pack II",
		limit_arg = 1,
		name_display = "New Commanders Support Pack II",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 1199,
		id = 121,
		tag = 1,
		gem = 0,
		limit_type = 2,
		time = "always",
		picture = "support2",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond131",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 780 Gems, 2x T4 Gear Development Packs, 4x Oil Reserve Supply (1000) Packs, and more!",
		airijp_id = "com.yostaren.azurlane.diamond131",
		extra_service_item = {
			{
				1,
				14,
				780
			},
			{
				2,
				30202,
				2
			},
			{
				2,
				30121,
				4
			},
			{
				4,
				100001,
				1
			},
			{
				2,
				15001,
				50
			},
			{
				2,
				16003,
				3
			},
			{
				2,
				16013,
				3
			},
			{
				2,
				16023,
				3
			},
			{
				2,
				16002,
				3
			},
			{
				2,
				16012,
				3
			},
			{
				2,
				16022,
				3
			},
			{
				2,
				30113,
				30
			},
			{
				2,
				30112,
				50
			}
		},
		display = {
			{
				1,
				14,
				780
			},
			{
				2,
				30202,
				2
			},
			{
				2,
				30121,
				4
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40013,
				1
			}
		}
	},
	[122] = {
		name = "New Commanders Support Pack III",
		limit_group = 0,
		descrip_extra = "The pack includes lots of material rewards. The Startup Pack will be sent to you via in-game mail, please check your mailbox to claim the pack. ",
		type = 1,
		subject = "New Commanders Support Pack III",
		limit_arg = 1,
		name_display = "New Commanders Support Pack III",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2599,
		id = 122,
		tag = 1,
		gem = 0,
		limit_type = 2,
		time = "always",
		picture = "support3",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond132",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1680 Gems, 4x T4 Gear Development Packs, 8x Oil Reserve Supply (1000) Packs, and more!",
		airijp_id = "com.yostaren.azurlane.diamond132",
		extra_service_item = {
			{
				1,
				14,
				1680
			},
			{
				2,
				30202,
				4
			},
			{
				2,
				30121,
				8
			},
			{
				4,
				100011,
				1
			},
			{
				2,
				59900,
				1000
			},
			{
				2,
				15001,
				80
			},
			{
				2,
				16003,
				5
			},
			{
				2,
				16013,
				5
			},
			{
				2,
				16023,
				5
			},
			{
				2,
				16002,
				5
			},
			{
				2,
				16012,
				5
			},
			{
				2,
				16022,
				5
			},
			{
				2,
				30113,
				100
			},
			{
				2,
				30112,
				100
			}
		},
		display = {
			{
				1,
				14,
				1680
			},
			{
				2,
				30202,
				4
			},
			{
				2,
				30121,
				8
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40014,
				1
			}
		}
	},
	[123] = {
		name = "Crimson Echoes' Lucky Bag",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Crimson Echoes' Lucky Bag",
		limit_arg = 1,
		name_display = "Crimson Echoes' Lucky Bag",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 123,
		tag = 1,
		gem = 0,
		limit_type = 2,
		picture = "fudai61",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond133",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1 x random Ship skin, 2020 x Gems, and other rewards. ",
		airijp_id = "com.yostaren.azurlane.diamond133",
		extra_service_item = {
			{
				2,
				69961,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2020,
					4,
					23
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2020,
					5,
					6
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69961,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				15008,
				50
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[124] = {
		name = "Night Out Lucky Bag ",
		limit_group = 0,
		descrip_extra = "The pack includes lots of material rewards. The Startup Pack will be sent to you via in-game mail, please check your mailbox to claim the pack. ",
		type = 1,
		subject = "Night Out Lucky Bag ",
		limit_arg = 1,
		name_display = "Night Out Lucky Bag ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 124,
		tag = 1,
		gem = 0,
		limit_type = 2,
		picture = "lihe1_l",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond134",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1 x random Ship skin, 2020 x Gems, and other rewards. ",
		airijp_id = "com.yostaren.azurlane.diamond134",
		extra_service_item = {
			{
				2,
				69910,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				42017,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2020,
					5,
					28
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2020,
					6,
					17
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69910,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				42017,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[125] = {
		name = "Skybound Oratorio Lucky Bag",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Skybound Oratorio Lucky Bag ",
		limit_arg = 1,
		name_display = "Skybound Oratorio Lucky Bag",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 125,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai63",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond135",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.diamond135",
		extra_service_item = {
			{
				2,
				69962,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2020,
					6,
					11
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2020,
					6,
					25
				},
				{
					8,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69962,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				20001,
				20
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[126] = {
		name = "Aurora Noctis Lucky Bag ",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Aurora Noctis Lucky Bag ",
		limit_arg = 1,
		name_display = "Aurora Noctis Lucky Bag ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 126,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai64",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond136",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.diamond136",
		extra_service_item = {
			{
				2,
				69963,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2020,
					8,
					6
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2020,
					8,
					19
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69963,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				15008,
				50
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[127] = {
		name = "Summer Scherzo Lucky Bag ",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Summer Scherzo Lucky Bag ",
		limit_arg = 1,
		name_display = "Summer Scherzo Lucky Bag ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 127,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai65",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond137",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.diamond137",
		extra_service_item = {
			{
				2,
				69964,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2020,
					8,
					20
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2020,
					9,
					2
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69964,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				15008,
				50
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[128] = {
		name = "Shining Star Lucky Bag ",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Shining Star Lucky Bag ",
		limit_arg = 1,
		name_display = "Shining Star Lucky Bag ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 128,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai66",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond139",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.diamond139",
		extra_service_item = {
			{
				2,
				69965,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				42026,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2020,
					10,
					29
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2020,
					11,
					11
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69965,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				42026,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[129] = {
		name = "Azur Black Friday Lucky Box ",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Azur Black Friday Lucky Box ",
		limit_arg = 1,
		name_display = "Azur Black Friday Lucky Box ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 129,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai67",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond140",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.diamond140",
		extra_service_item = {
			{
				2,
				69966,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				42026,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				34
			},
			{
				2,
				15003,
				12
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2020,
					11,
					18
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2020,
					12,
					2
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69966,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				20001,
				34
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[130] = {
		name = "Crimson Black Friday Lucky Box ",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Crimson Black Friday Lucky Box ",
		limit_arg = 1,
		name_display = "Crimson Black Friday Lucky Box ",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 130,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai68",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond141",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.diamond141",
		extra_service_item = {
			{
				2,
				69967,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				42026,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				34
			},
			{
				2,
				15003,
				12
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2020,
					11,
					18
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2020,
					12,
					2
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69967,
				1
			},
			{
				1,
				4,
				2020
			},
			{
				2,
				20001,
				34
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[131] = {
		name = "Dawn's Rime Lucky Pack",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Dawn's Rime Lucky Pack",
		limit_arg = 1,
		name_display = "Dawn's Rime Lucky Pack",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 131,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai69",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond144",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.diamond144",
		extra_service_item = {
			{
				2,
				69968,
				1
			},
			{
				1,
				4,
				2021
			},
			{
				2,
				42026,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2021,
					2,
					25
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2021,
					3,
					11
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69968,
				1
			},
			{
				1,
				4,
				2021
			},
			{
				2,
				42026,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[132] = {
		name = "Daedalian Hymn's Lucky Bag",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Daedalian Hymn's Lucky Bag",
		limit_arg = 1,
		name_display = "Daedalian Hymn's Lucky Bag",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 132,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai70",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond145",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.diamond145",
		extra_service_item = {
			{
				2,
				69969,
				1
			},
			{
				1,
				4,
				2021
			},
			{
				2,
				42026,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2021,
					4,
					22
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2021,
					5,
					5
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69969,
				1
			},
			{
				1,
				4,
				2021
			},
			{
				2,
				42026,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[133] = {
		name = "Microlayer Medley Lucky Box 2021",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Microlayer Medley Lucky Box 2021",
		limit_arg = 1,
		name_display = "Microlayer Medley Lucky Box 2021",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 133,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai71",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond149",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.diamond149",
		extra_service_item = {
			{
				2,
				69970,
				1
			},
			{
				1,
				4,
				2021
			},
			{
				2,
				42036,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2021,
					8,
					19
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2021,
					9,
					1
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69970,
				1
			},
			{
				1,
				4,
				2021
			},
			{
				2,
				42036,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[134] = {
		name = "Black Friday Lucky Music Box",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Black Friday Lucky Music Box",
		limit_arg = 1,
		name_display = "Black Friday Lucky Music Box",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 134,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai72",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond152",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.diamond152",
		extra_service_item = {
			{
				2,
				69971,
				1
			},
			{
				1,
				4,
				2021
			},
			{
				2,
				42036,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				35
			},
			{
				2,
				15003,
				12
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2021,
					11,
					18
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2021,
					12,
					1
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69971,
				1
			},
			{
				1,
				4,
				2021
			},
			{
				2,
				42036,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[135] = {
		name = "Abyssal Refrain Lucky Pack",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Abyssal Refrain Lucky Pack",
		limit_arg = 1,
		name_display = "Abyssal Refrain Lucky Pack",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 135,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai73",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond157",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.diamond157",
		extra_service_item = {
			{
				2,
				69972,
				1
			},
			{
				1,
				4,
				2022
			},
			{
				2,
				42036,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2022,
					2,
					24
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					3,
					9
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69972,
				1
			},
			{
				1,
				4,
				2022
			},
			{
				2,
				42036,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[136] = {
		name = "Crimson Offering Lucky Chalice",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Crimson Offering Lucky Chalice",
		limit_arg = 1,
		name_display = "Crimson Offering Lucky Chalice",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 136,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai74",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond166",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.diamond166",
		extra_service_item = {
			{
				2,
				69973,
				1
			},
			{
				1,
				4,
				2022
			},
			{
				2,
				42036,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2022,
					4,
					28
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					5,
					12
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69973,
				1
			},
			{
				1,
				4,
				2022
			},
			{
				2,
				42036,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[137] = {
		name = "Aquilifer's Ballade Lucky Box",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Aquilifer's Ballade Lucky Box",
		limit_arg = 1,
		name_display = "Aquilifer's Ballade Lucky Box",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 137,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai75",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond169",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.diamond169",
		extra_service_item = {
			{
				2,
				69974,
				1
			},
			{
				1,
				4,
				2022
			},
			{
				2,
				42046,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2022,
					7,
					28
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					8,
					10
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69974,
				1
			},
			{
				1,
				4,
				2022
			},
			{
				2,
				42046,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[138] = {
		name = "4th Anniversary Lucky Box",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "4th Anniversary Lucky Box",
		limit_arg = 1,
		name_display = "4th Anniversary Lucky Box",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 2999,
		id = 138,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai76",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond171",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.diamond171",
		extra_service_item = {
			{
				2,
				69975,
				1
			},
			{
				1,
				4,
				2022
			},
			{
				2,
				42046,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2022,
					8,
					18
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					8,
					31
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69975,
				1
			},
			{
				1,
				4,
				2022
			},
			{
				2,
				42046,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[2014] = {
		name = "Skill Book Pack",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Skill Book Pack",
		limit_arg = 4,
		name_display = "Skill Book Pack",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 299,
		id = 2014,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "boxSkill",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.pack1",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Buy to receive a large amount of Skill Books.",
		airijp_id = "com.yostaren.azurlane.pack1",
		extra_service_item = {
			{
				2,
				16004,
				1
			},
			{
				2,
				16014,
				1
			},
			{
				2,
				16024,
				1
			},
			{
				2,
				16003,
				3
			},
			{
				2,
				16013,
				3
			},
			{
				2,
				16023,
				3
			}
		},
		time = {
			{
				{
					2023,
					4,
					27
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					7,
					12
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				16004,
				1
			},
			{
				2,
				16014,
				1
			},
			{
				2,
				16024,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40023,
				1
			}
		}
	},
	[2015] = {
		name = "PR Construction Pack - Series 3",
		limit_group = 3,
		descrip_extra = "",
		type = 0,
		subject = "PR Construction Pack - Series 3",
		limit_arg = 0,
		name_display = "PR Construction Pack - Series 3",
		show_group = "tech",
		type_order = 0,
		extra_service = 3,
		money = 1599,
		id = 2015,
		tag = 2,
		gem = 0,
		limit_type = 3,
		time = "always",
		picture = "tech3_display",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.pack4",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains one PR Voucher - Series 3 and 343 General Blueprints - Series 3.",
		airijp_id = "com.yostaren.azurlane.pack4",
		extra_service_item = {
			{
				2,
				40130,
				1
			},
			{
				2,
				42020,
				343
			}
		},
		display = {
			{
				2,
				40130,
				1
			},
			{
				2,
				42020,
				343
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {
			{
				"level",
				30
			}
		},
		drop_item = {}
	},
	[2016] = {
		name = "PR Voucher & Blueprint Bundle - Series 3",
		limit_group = 3,
		descrip_extra = "If you've already built all Series 3 PRs, the contents will be exchanged for other items. Tap the icon to view the item table.",
		type = 0,
		subject = "PR Voucher & Blueprint Bundle - Series 3",
		limit_arg = 1,
		name_display = "PR Voucher & Blueprint \n         Bundle - Series 3",
		show_group = "tech",
		type_order = 0,
		extra_service = 3,
		money = 1599,
		id = 2016,
		tag = 2,
		gem = 0,
		limit_type = 3,
		time = "always",
		picture = "tech3_promotion",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.pack4",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains:",
		airijp_id = "com.yostaren.azurlane.pack4",
		extra_service_item = {
			{
				2,
				40130,
				1
			},
			{
				2,
				42020,
				343
			}
		},
		display = {
			{
				2,
				40130,
				1
			},
			{
				2,
				42020,
				343
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {
			{
				"level",
				30
			}
		},
		drop_item = {
			{
				2,
				40026,
				1
			}
		}
	},
	[2017] = {
		name = "PR Voucher Pack - Series 3",
		limit_group = 3,
		descrip_extra = "If you've already built all Series 3 PRs, the contents will be exchanged for other items. Tap the icon to view the item table.",
		type = 0,
		subject = "Voucher",
		limit_arg = 2,
		name_display = "PR Voucher - Series 3",
		show_group = "tech",
		type_order = 0,
		extra_service = 3,
		money = 999,
		id = 2017,
		tag = 2,
		gem = 0,
		limit_type = 3,
		time = "always",
		picture = "tech3_normal",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.pack2",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains:",
		airijp_id = "com.yostaren.azurlane.pack2",
		extra_service_item = {
			{
				2,
				40130,
				1
			}
		},
		display = {
			{
				2,
				40130,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {
			{
				"level",
				30
			}
		},
		drop_item = {
			{
				2,
				40027,
				1
			}
		}
	},
	[2018] = {
		name = "PR Blueprint Pack - Series 3",
		limit_group = 3,
		descrip_extra = "Buy to receive 343 General Blueprints - Series 3.",
		type = 0,
		subject = "Blueprints",
		limit_arg = 3,
		name_display = "PR Voucher - Series 3",
		show_group = "tech",
		type_order = 0,
		extra_service = 3,
		money = 699,
		id = 2018,
		tag = 2,
		gem = 0,
		limit_type = 3,
		time = "always",
		picture = "tech3_promotion",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.pack3",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains:",
		airijp_id = "com.yostaren.azurlane.pack3",
		extra_service_item = {
			{
				2,
				42020,
				343
			}
		},
		display = {
			{
				2,
				42020,
				343
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {
			{
				"level",
				30
			}
		},
		drop_item = {
			{
				2,
				40028,
				1
			}
		}
	},
	[2019] = {
		name = "Skill Book Pack",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Skill Book Pack",
		limit_arg = 4,
		name_display = "Skill Book Pack",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 299,
		id = 2019,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "boxSkill",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.pack5",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Buy to receive a large amount of Skill Books.",
		airijp_id = "com.yostaren.azurlane.pack5",
		extra_service_item = {
			{
				2,
				16004,
				1
			},
			{
				2,
				16014,
				1
			},
			{
				2,
				16024,
				1
			},
			{
				2,
				16003,
				3
			},
			{
				2,
				16013,
				3
			},
			{
				2,
				16023,
				3
			}
		},
		time = {
			{
				{
					2023,
					11,
					23
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					4,
					3
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				16004,
				1
			},
			{
				2,
				16014,
				1
			},
			{
				2,
				16024,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40023,
				1
			}
		}
	},
	[2020] = {
		name = "Premium Winter Gift Pack",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Premium Winter Gift Pack",
		limit_arg = 1,
		name_display = "Premium Winter Gift Pack",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 3699,
		id = 2020,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "dongzhi3",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.winterpack1",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 3880 Gems, 1 Specialized Bulin Custom MKIII and other rewards.",
		airijp_id = "com.yostaren.azurlane.winterpack1",
		extra_service_item = {
			{
				1,
				14,
				3880
			},
			{
				4,
				100021,
				1
			},
			{
				4,
				100011,
				2
			},
			{
				2,
				15012,
				150
			},
			{
				2,
				16502,
				60
			},
			{
				2,
				30113,
				150
			}
		},
		time = {
			{
				{
					2024,
					1,
					18
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					2,
					21
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				1,
				14,
				3880
			},
			{
				4,
				100021,
				1
			},
			{
				4,
				100011,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40029,
				1
			}
		}
	},
	[2022] = {
		name = "Wisdom Cube Supply Pack I",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Wisdom Cube Supply Pack I",
		limit_arg = 2,
		name_display = "Wisdom Cube Supply Pack I",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 199,
		id = 2022,
		tag = 2,
		gem = 0,
		limit_type = 2,
		sub_display = "",
		picture = "mofangzhiyuan1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.cubepack1",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 10 Wisdom Cubes.",
		airijp_id = "com.yostaren.azurlane.cubepack1",
		extra_service_item = {
			{
				2,
				20001,
				10
			}
		},
		time = {
			{
				{
					2024,
					1,
					18
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					2,
					21
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				20001,
				10
			}
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40031,
				1
			}
		}
	},
	[2023] = {
		name = "Wisdom Cube Supply Pack II",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Wisdom Cube Supply Pack II",
		limit_arg = 2,
		name_display = "Wisdom Cube Supply Pack II",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 499,
		id = 2023,
		tag = 2,
		gem = 0,
		limit_type = 2,
		sub_display = "",
		picture = "mofangzhiyuan2",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.cubepack2",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 20 Wisdom Cubes.",
		airijp_id = "com.yostaren.azurlane.cubepack2",
		extra_service_item = {
			{
				2,
				20001,
				20
			}
		},
		time = {
			{
				{
					2024,
					1,
					18
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					2,
					21
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				20001,
				20
			}
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40032,
				1
			}
		}
	},
	[2024] = {
		name = "Wisdom Cube Supply Pack III",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Wisdom Cube Supply Pack III",
		limit_arg = 2,
		name_display = "Wisdom Cube Supply Pack III",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 799,
		id = 2024,
		tag = 2,
		gem = 0,
		limit_type = 2,
		sub_display = "",
		picture = "mofangzhiyuan3",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.cubepack3",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 30 Wisdom Cubes.",
		airijp_id = "com.yostaren.azurlane.cubepack3",
		extra_service_item = {
			{
				2,
				20001,
				30
			}
		},
		time = {
			{
				{
					2024,
					1,
					18
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					2,
					21
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				20001,
				30
			}
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40033,
				1
			}
		}
	},
	[2025] = {
		name = "Daily Sortie Refuel Pack",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Daily Sortie Refuel Pack",
		limit_arg = 1,
		name_display = "Daily Sortie Refuel Pack",
		show_group = "",
		type_order = 6,
		extra_service = 3,
		money = 99,
		id = 2025,
		tag = 2,
		gem = 0,
		limit_type = 4,
		time = "always",
		picture = "richang",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.dailybag1",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 1 Wisdom Cube and 1200 Oil.",
		airijp_id = "com.yostaren.azurlane.dailybag1",
		extra_service_item = {
			{
				1,
				2,
				1200
			},
			{
				2,
				20001,
				1
			}
		},
		display = {
			{
				1,
				2,
				1200
			},
			{
				2,
				20001,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40043,
				1
			}
		}
	},
	[2026] = {
		name = "Skill Book Pack",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Skill Book Pack",
		limit_arg = 4,
		name_display = "Skill Book Pack",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 299,
		id = 2026,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "boxSkill",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.pack6",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Buy to receive a large amount of Skill Books.",
		airijp_id = "com.yostaren.azurlane.pack6",
		extra_service_item = {
			{
				2,
				16004,
				1
			},
			{
				2,
				16014,
				1
			},
			{
				2,
				16024,
				1
			},
			{
				2,
				16003,
				3
			},
			{
				2,
				16013,
				3
			},
			{
				2,
				16023,
				3
			}
		},
		time = {
			{
				{
					2024,
					4,
					25
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					11,
					6
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				16004,
				1
			},
			{
				2,
				16014,
				1
			},
			{
				2,
				16024,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40023,
				1
			}
		}
	},
	[2027] = {
		name = "PR Construction Pack - Series 4",
		limit_group = 4,
		descrip_extra = "",
		type = 0,
		subject = "PR Construction Pack - Series 4",
		limit_arg = 0,
		name_display = "PR Construction Pack - Series 4",
		show_group = "tech",
		type_order = 0,
		extra_service = 3,
		money = 1599,
		id = 2027,
		tag = 2,
		gem = 0,
		limit_type = 3,
		time = "always",
		picture = "tech4_display",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.pack9",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains one PR Voucher - Series 4 and 343 General Blueprints - Series 4.",
		airijp_id = "com.yostaren.azurlane.pack9",
		extra_service_item = {
			{
				2,
				40139,
				1
			},
			{
				2,
				42030,
				343
			}
		},
		display = {
			{
				2,
				40139,
				1
			},
			{
				2,
				42030,
				343
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {
			{
				"level",
				30
			}
		},
		drop_item = {}
	},
	[2028] = {
		name = "PR Voucher & Blueprint Bundle - Series 4",
		limit_group = 4,
		descrip_extra = "If you've already built all Series 4 PRs, the contents will be exchanged for other items. Tap the icon to view the item table.",
		type = 0,
		subject = "PR Voucher & Blueprint Bundle - Series 4",
		limit_arg = 1,
		name_display = "PR Voucher & Blueprint \n         Bundle - Series 4",
		show_group = "tech",
		type_order = 0,
		extra_service = 3,
		money = 1599,
		id = 2028,
		tag = 2,
		gem = 0,
		limit_type = 3,
		time = "always",
		picture = "tech4_promotion",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.pack9",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains:",
		airijp_id = "com.yostaren.azurlane.pack9",
		extra_service_item = {
			{
				2,
				40139,
				1
			},
			{
				2,
				42030,
				343
			}
		},
		display = {
			{
				2,
				40139,
				1
			},
			{
				2,
				42030,
				343
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {
			{
				"level",
				30
			}
		},
		drop_item = {
			{
				2,
				40044,
				1
			}
		}
	},
	[2029] = {
		name = "PR Voucher - Series 4",
		limit_group = 4,
		descrip_extra = "If you've already built all Series 4 PRs, the contents will be exchanged for other items. Tap the icon to view the item table.",
		type = 0,
		subject = "PR Voucher - Series 4",
		limit_arg = 2,
		name_display = "PR Voucher Pack - Series 4",
		show_group = "tech",
		type_order = 0,
		extra_service = 3,
		money = 999,
		id = 2029,
		tag = 2,
		gem = 0,
		limit_type = 3,
		time = "always",
		picture = "tech4_normal",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.pack7",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains:",
		airijp_id = "com.yostaren.azurlane.pack7",
		extra_service_item = {
			{
				2,
				40139,
				1
			}
		},
		display = {
			{
				2,
				40139,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {
			{
				"level",
				30
			}
		},
		drop_item = {
			{
				2,
				40045,
				1
			}
		}
	},
	[2030] = {
		name = "PR Blueprint Pack - Series 4",
		limit_group = 4,
		descrip_extra = "Buy to receive 343 General Blueprints - Series 4.",
		type = 0,
		subject = "PR Blueprint Pack - Series 4",
		limit_arg = 3,
		name_display = "PR Blueprint Pack - Series 4",
		show_group = "tech",
		type_order = 0,
		extra_service = 3,
		money = 699,
		id = 2030,
		tag = 2,
		gem = 0,
		limit_type = 3,
		time = "always",
		picture = "tech4_promotion",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.pack8",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains:",
		airijp_id = "com.yostaren.azurlane.pack8",
		extra_service_item = {
			{
				2,
				42030,
				343
			}
		},
		display = {
			{
				2,
				42030,
				343
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {
			{
				"level",
				30
			}
		},
		drop_item = {
			{
				2,
				40046,
				1
			}
		}
	},
	[2031] = {
		name = "Outfit Selection Pack (Shimakaze)",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Outfit Selection Pack (Shimakaze)",
		limit_arg = 1,
		name_display = "Outfit Selection Pack (Shimakaze)",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 1799,
		id = 2031,
		tag = 2,
		gem = 0,
		limit_type = 2,
		sub_display = "",
		picture = "daofeng_package",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.pack11",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains an Outfit Selection Voucher, Wisdom Cubes, T2 EXP Data Packs, and more.",
		airijp_id = "com.yostaren.azurlane.pack11",
		extra_service_item = {
			{
				2,
				59553,
				1
			},
			{
				2,
				20001,
				40
			},
			{
				1,
				1,
				30000
			},
			{
				2,
				16502,
				50
			}
		},
		time = {
			{
				{
					2024,
					7,
					18
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					8,
					14
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				59553,
				1
			},
			{
				2,
				20001,
				40
			},
			{
				2,
				16502,
				50
			}
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40047,
				1
			}
		}
	},
	[2032] = {
		name = "Iridescent Fantasy Pack",
		limit_group = 101,
		descrip_extra = "",
		type = 0,
		subject = "Iridescent Fantasy Pack",
		limit_arg = 0,
		name_display = "Iridescent Fantasy Pack",
		show_group = "uigift",
		type_order = 4,
		extra_service = 3,
		money = 1199,
		id = 2032,
		tag = 2,
		gem = 0,
		limit_type = 5,
		picture = "ui1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.pack12",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a new combat UI theme.",
		airijp_id = "com.yostaren.azurlane.pack12",
		extra_service_item = {
			{
				31,
				103,
				1
			}
		},
		time = {
			{
				{
					2024,
					9,
					12
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					10,
					2
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				31,
				103,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	},
	[2033] = {
		name = "Iridescent Fantasy Pack (Basic)",
		limit_group = 101,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Iridescent Fantasy Pack (Basic)",
		limit_arg = 1,
		name_display = "Iridescent Fantasy Pack (Basic)",
		show_group = "uigift",
		type_order = 4,
		extra_service = 3,
		money = 1199,
		id = 2033,
		tag = 2,
		gem = 0,
		limit_type = 5,
		picture = "ui1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.pack12",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a new combat UI theme.",
		airijp_id = "com.yostaren.azurlane.pack12",
		extra_service_item = {
			{
				31,
				103,
				1
			}
		},
		time = {
			{
				{
					2024,
					9,
					12
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					10,
					2
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				31,
				103,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40048,
				1
			}
		}
	},
	[2034] = {
		name = "Iridescent Fantasy Pack (Premium)",
		limit_group = 101,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Iridescent Fantasy Pack (Premium)",
		limit_arg = 1,
		name_display = "Iridescent Fantasy Pack (Premium)",
		show_group = "uigift",
		type_order = 4,
		extra_service = 3,
		money = 3699,
		id = 2034,
		tag = 2,
		gem = 0,
		limit_type = 5,
		picture = "ui1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.pack13",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a new combat UI theme and Gems x 3,060.",
		airijp_id = "com.yostaren.azurlane.pack13",
		extra_service_item = {
			{
				31,
				103,
				1
			},
			{
				1,
				14,
				3060
			}
		},
		time = {
			{
				{
					2024,
					9,
					12
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					10,
					2
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				31,
				103,
				1
			},
			{
				1,
				14,
				3060
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40049,
				1
			}
		}
	},
	[2035] = {
		name = "Outfit Selection Pack (Ulrich von Hutten)",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Outfit Selection Pack (Ulrich von Hutten)",
		limit_arg = 1,
		name_display = "Outfit Selection Pack (Ulrich von Hutten)",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 1799,
		id = 2035,
		tag = 2,
		gem = 0,
		limit_type = 2,
		sub_display = "",
		picture = "huteng_package",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.pack14",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains an Outfit Selection Voucher, Wisdom Cubes, T2 EXP Data Packs, and more.",
		airijp_id = "com.yostaren.azurlane.pack14",
		extra_service_item = {
			{
				2,
				59554,
				1
			},
			{
				2,
				20001,
				40
			},
			{
				1,
				1,
				30000
			},
			{
				2,
				16502,
				50
			}
		},
		time = {
			{
				{
					2024,
					10,
					17
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					11,
					13
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				59554,
				1
			},
			{
				2,
				20001,
				40
			},
			{
				2,
				16502,
				50
			}
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40050,
				1
			}
		}
	},
	[5011] = {
		name = "Daily Paid Pack (Day 1)",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Daily Paid Pack (Day 1)",
		limit_arg = 1,
		name_display = "Daily Paid Pack (Day 1)",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 99,
		id = 5011,
		tag = 2,
		gem = 0,
		limit_type = 2,
		sub_display = "",
		picture = "pack_day1",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.bfdailybag8",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 60x Gems, 2x Special General Blueprints - Series 6.",
		airijp_id = "com.yostaren.azurlane.bfdailybag8",
		extra_service_item = {
			{
				2,
				42056,
				2
			},
			{
				1,
				14,
				60
			}
		},
		time = {
			{
				{
					2024,
					11,
					14
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					12,
					4
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				42056,
				2
			},
			{
				1,
				14,
				60
			}
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81410,
				1
			}
		}
	},
	[5012] = {
		name = "Daily Paid Pack (Day 2)",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Daily Paid Pack (Day 2)",
		limit_arg = 1,
		name_display = "Daily Paid Pack (Day 2)",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 99,
		id = 5012,
		tag = 2,
		gem = 0,
		limit_type = 2,
		sub_display = "",
		picture = "pack_day2",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.bfdailybag9",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 200x Gems.",
		airijp_id = "com.yostaren.azurlane.bfdailybag9",
		extra_service_item = {
			{
				1,
				14,
				200
			}
		},
		time = {
			{
				{
					2024,
					11,
					15
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					12,
					4
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				1,
				14,
				200
			}
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81411,
				1
			}
		}
	},
	[5013] = {
		name = "Daily Paid Pack (Day 3)",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Daily Paid Pack (Day 3)",
		limit_arg = 1,
		name_display = "Daily Paid Pack (Day 3)",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 99,
		id = 5013,
		tag = 2,
		gem = 0,
		limit_type = 2,
		sub_display = "",
		picture = "pack_day3",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.bfdailybag10",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 200x Cognitive Chips, 5x Universal T4 Parts.",
		airijp_id = "com.yostaren.azurlane.bfdailybag10",
		extra_service_item = {
			{
				2,
				30114,
				5
			},
			{
				2,
				15008,
				200
			}
		},
		time = {
			{
				{
					2024,
					11,
					16
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					12,
					4
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				30114,
				5
			},
			{
				2,
				15008,
				200
			}
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81412,
				1
			}
		}
	},
	[5014] = {
		name = "Daily Paid Pack (Day 4)",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Daily Paid Pack (Day 4)",
		limit_arg = 1,
		name_display = "Daily Paid Pack (Day 4)",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 99,
		id = 5014,
		tag = 2,
		gem = 0,
		limit_type = 2,
		sub_display = "",
		picture = "pack_day4",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.bfdailybag11",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 60x Gems, 1x Prototype Bulin MKII.",
		airijp_id = "com.yostaren.azurlane.bfdailybag11",
		extra_service_item = {
			{
				4,
				100011,
				1
			},
			{
				1,
				14,
				60
			}
		},
		time = {
			{
				{
					2024,
					11,
					17
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					12,
					4
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				4,
				100011,
				1
			},
			{
				1,
				14,
				60
			}
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81413,
				1
			}
		}
	},
	[5015] = {
		name = "Daily Paid Pack (Day 5)",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Daily Paid Pack (Day 5)",
		limit_arg = 1,
		name_display = "Daily Paid Pack (Day 5)",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 99,
		id = 5015,
		tag = 2,
		gem = 0,
		limit_type = 2,
		sub_display = "",
		picture = "pack_day5",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.bfdailybag12",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 60x T2 EXP Data Packs.",
		airijp_id = "com.yostaren.azurlane.bfdailybag12",
		extra_service_item = {
			{
				2,
				16502,
				60
			}
		},
		time = {
			{
				{
					2024,
					11,
					18
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					12,
					4
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				16502,
				60
			}
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81414,
				1
			}
		}
	},
	[5016] = {
		name = "Daily Paid Pack (Day 6)",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Daily Paid Pack (Day 6)",
		limit_arg = 1,
		name_display = "Daily Paid Pack (Day 6)",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 99,
		id = 5016,
		tag = 2,
		gem = 0,
		limit_type = 2,
		sub_display = "",
		picture = "pack_day6",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.bfdailybag13",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 10x Wisdom Cubes, 5x Quick Finishers.",
		airijp_id = "com.yostaren.azurlane.bfdailybag13",
		extra_service_item = {
			{
				2,
				20001,
				10
			},
			{
				2,
				15003,
				5
			}
		},
		time = {
			{
				{
					2024,
					11,
					19
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					12,
					4
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				20001,
				10
			},
			{
				2,
				15003,
				5
			}
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81415,
				1
			}
		}
	},
	[5017] = {
		name = "Daily Paid Pack (Day 7)",
		limit_group = 0,
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		subject = "Daily Paid Pack (Day 7)",
		limit_arg = 1,
		name_display = "Daily Paid Pack (Day 7)",
		show_group = "",
		type_order = 0,
		extra_service = 3,
		money = 99,
		id = 5017,
		tag = 2,
		gem = 0,
		limit_type = 2,
		sub_display = "",
		picture = "pack_day7",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.bfdailybag14",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains 60x Gems, 2x Special General Blueprints - Series 7.",
		airijp_id = "com.yostaren.azurlane.bfdailybag14",
		extra_service_item = {
			{
				2,
				42066,
				2
			},
			{
				1,
				14,
				60
			}
		},
		time = {
			{
				{
					2024,
					11,
					20
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					12,
					4
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				42066,
				2
			},
			{
				1,
				14,
				60
			}
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81416,
				1
			}
		}
	},
	[139] = {
		name = "Black Friday Lucky Bag (2022)",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Black Friday Lucky Bag (2022)",
		limit_arg = 1,
		name_display = "Black Friday Lucky Bag (2022)",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 139,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai77",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.diamond177",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.diamond177",
		extra_service_item = {
			{
				2,
				69976,
				1
			},
			{
				1,
				4,
				2022
			},
			{
				2,
				42046,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				35
			},
			{
				2,
				15003,
				12
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2022,
					11,
					17
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					11,
					30
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69976,
				1
			},
			{
				1,
				4,
				2022
			},
			{
				2,
				42046,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40024,
				1
			}
		}
	},
	[140] = {
		name = "New Semester Lucky Pack",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "New Semester Lucky Pack",
		limit_arg = 1,
		name_display = "New Semester Lucky Pack",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 140,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai78",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.luckybag8",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.luckybag8",
		extra_service_item = {
			{
				2,
				69978,
				1
			},
			{
				1,
				4,
				2023
			},
			{
				2,
				42046,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2023,
					2,
					23
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					3,
					8
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69978,
				1
			},
			{
				1,
				4,
				2023
			},
			{
				2,
				42046,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40025,
				1
			}
		}
	},
	[141] = {
		name = "Onsen Souvenir Lucky Bag",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Onsen Souvenir Lucky Bag",
		limit_arg = 1,
		name_display = "Onsen Souvenir Lucky Bag",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 141,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai79",
		skin_inquire_relation = 0,
		id_str = "com.yostaren.azurlane.luckybag9",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.luckybag9",
		extra_service_item = {
			{
				2,
				69979,
				1
			},
			{
				1,
				4,
				2023
			},
			{
				2,
				42046,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2023,
					3,
					23
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					4,
					5
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69979,
				1
			},
			{
				1,
				4,
				2023
			},
			{
				2,
				42046,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				70052,
				1
			}
		}
	},
	[142] = {
		name = "Office Hour Lucky Box",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Office Hour Lucky Box",
		limit_arg = 1,
		name_display = "Office Hour Lucky Box",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 142,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai80",
		skin_inquire_relation = 69980,
		id_str = "com.yostaren.azurlane.luckybag13",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.luckybag13",
		extra_service_item = {
			{
				2,
				69980,
				1
			},
			{
				1,
				4,
				2023
			},
			{
				2,
				42046,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2023,
					6,
					29
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					7,
					12
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69980,
				1
			},
			{
				1,
				4,
				2023
			},
			{
				2,
				42046,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40985,
				1
			}
		}
	},
	[143] = {
		name = "5th Anniversary Lucky Box",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "5th Anniversary Lucky Box",
		limit_arg = 1,
		name_display = "5th Anniversary Lucky Box",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 143,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai81",
		skin_inquire_relation = 69981,
		id_str = "com.yostaren.azurlane.luckybag14",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.luckybag14",
		extra_service_item = {
			{
				2,
				69981,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42056,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2023,
					8,
					17
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					8,
					30
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69981,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42056,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40986,
				1
			}
		}
	},
	[144] = {
		name = "Halloween Lucky Box 2023",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Halloween Lucky Box 2023",
		limit_arg = 1,
		name_display = "Halloween Lucky Box 2023",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 144,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai82",
		skin_inquire_relation = 69982,
		id_str = "com.yostaren.azurlane.luckybag18",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.luckybag18",
		extra_service_item = {
			{
				2,
				69982,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42056,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2023,
					10,
					26
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					11,
					8
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69982,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42056,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40987,
				1
			}
		}
	},
	[145] = {
		name = "Black Friday Lucky Bag (2023)",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 2,
		subject = "Black Friday Lucky Bag (2023)",
		limit_arg = 1,
		name_display = "Black Friday Lucky Bag (2023)",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 145,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai82",
		skin_inquire_relation = 69983,
		id_str = "com.yostaren.azurlane.luckybag19",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.luckybag19",
		extra_service_item = {
			{
				2,
				69983,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42056,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				35
			},
			{
				2,
				15003,
				12
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2023,
					11,
					16
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2023,
					11,
					30
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				69983,
				1
			},
			{
				1,
				14,
				2023
			},
			{
				2,
				42056,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40997,
				1
			}
		}
	},
	[146] = {
		name = "Cyber City Lucky Box",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Cyber City Lucky Box",
		limit_arg = 1,
		name_display = "Cyber City Lucky Box",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 146,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai84",
		skin_inquire_relation = 86400,
		id_str = "com.yostaren.azurlane.luckybag28",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit, 2024 Gems, and a large amount of supplies.",
		airijp_id = "com.yostaren.azurlane.luckybag28",
		extra_service_item = {
			{
				2,
				86400,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42056,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2024,
					2,
					29
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					3,
					13
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				86400,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42056,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81400,
				1
			}
		}
	},
	[147] = {
		name = "Adventurer's Lucky Chest",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Adventurer's Lucky Chest",
		limit_arg = 1,
		name_display = "Adventurer's Lucky Chest",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 147,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai85",
		skin_inquire_relation = 86401,
		id_str = "com.yostaren.azurlane.luckybag29",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.luckybag29",
		extra_service_item = {
			{
				2,
				86401,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42056,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2024,
					3,
					28
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					4,
					10
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				86401,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42056,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81401,
				1
			}
		}
	},
	[148] = {
		name = "Lavish Lucky Boombox",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Lavish Lucky Boombox",
		limit_arg = 1,
		name_display = "Lavish Lucky Boombox",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 148,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai86",
		skin_inquire_relation = 86402,
		id_str = "com.yostaren.azurlane.luckybag30",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.luckybag30",
		extra_service_item = {
			{
				2,
				86402,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42056,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2024,
					4,
					25
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					5,
					8
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				86402,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42056,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81402,
				1
			}
		}
	},
	[149] = {
		name = "School Time Lucky Bag",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "School Time Lucky Bag",
		limit_arg = 1,
		name_display = "School Time Lucky Bag",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 149,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai87",
		skin_inquire_relation = 86403,
		id_str = "com.yostaren.azurlane.luckybag35",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.luckybag35",
		extra_service_item = {
			{
				2,
				86403,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42056,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2024,
					6,
					27
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					7,
					10
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				86403,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42056,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81403,
				1
			}
		}
	},
	[150] = {
		name = "High Speed Lucky Bag",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "High Speed Lucky Bag",
		limit_arg = 1,
		name_display = "High Speed Lucky Bag",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 150,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai88",
		skin_inquire_relation = 86404,
		id_str = "com.yostaren.azurlane.luckybag36",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.luckybag36",
		extra_service_item = {
			{
				2,
				86404,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42066,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2024,
					7,
					25
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					8,
					7
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				86404,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42066,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81404,
				1
			}
		}
	},
	[151] = {
		name = "6th Anniversary Lucky Barrel",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "6th Anniversary Lucky Barrel",
		limit_arg = 1,
		name_display = "6th Anniversary Lucky Barrel",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 151,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai89",
		skin_inquire_relation = 86405,
		id_str = "com.yostaren.azurlane.luckybag37",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.luckybag37",
		extra_service_item = {
			{
				2,
				86405,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42066,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2024,
					8,
					15
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					8,
					28
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				86405,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42066,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81405,
				1
			}
		}
	},
	[152] = {
		name = "Halloween Lucky Box 2024",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Halloween Lucky Box 2024",
		limit_arg = 1,
		name_display = "Halloween Lucky Box 2024",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 152,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai90",
		skin_inquire_relation = 86406,
		id_str = "com.yostaren.azurlane.luckybag42",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.luckybag42",
		extra_service_item = {
			{
				2,
				86406,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42066,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				20
			},
			{
				2,
				15003,
				10
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2024,
					10,
					24
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					11,
					6
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				86406,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42066,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81406,
				1
			}
		}
	},
	[153] = {
		name = "Live2D Surprise Lucky Bag (2024)",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Black Friday Lucky Bag (2024)",
		limit_arg = 2,
		name_display = "Live2D Surprise Lucky Bag (2024)",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 999,
		id = 153,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai_L2d_new",
		skin_inquire_relation = 86407,
		id_str = "com.yostaren.azurlane.luckybag44",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random unowned rerun L2D outfit and other supplies",
		airijp_id = "com.yostaren.azurlane.luckybag44",
		extra_service_item = {
			{
				2,
				86407,
				1
			},
			{
				1,
				1,
				2000
			},
			{
				1,
				2,
				1000
			},
			{
				2,
				15008,
				20
			}
		},
		time = {
			{
				{
					2024,
					11,
					14
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					12,
					4
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				86407,
				1
			},
			{
				1,
				2,
				1000
			},
			{
				2,
				15008,
				20
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81417,
				1
			}
		}
	},
	[154] = {
		name = "Black Friday Lucky Bag (2024)",
		limit_group = 0,
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		subject = "Black Friday Lucky Bag (2024)",
		limit_arg = 1,
		name_display = "Black Friday Lucky Bag (2024)",
		show_group = "",
		type_order = 2,
		extra_service = 3,
		money = 2999,
		id = 154,
		tag = 2,
		gem = 0,
		limit_type = 2,
		picture = "fudai92",
		skin_inquire_relation = 86408,
		id_str = "com.yostaren.azurlane.luckybag43",
		first_pay_double = 0,
		extra_gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		airijp_id = "com.yostaren.azurlane.luckybag43",
		extra_service_item = {
			{
				2,
				86408,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42066,
				2
			},
			{
				2,
				15008,
				50
			},
			{
				2,
				20001,
				35
			},
			{
				2,
				15003,
				12
			},
			{
				1,
				6,
				100
			}
		},
		time = {
			{
				{
					2024,
					11,
					14
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2024,
					12,
					4
				},
				{
					23,
					59,
					59
				}
			}
		},
		display = {
			{
				2,
				86408,
				1
			},
			{
				1,
				14,
				2024
			},
			{
				2,
				42066,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81418,
				1
			}
		}
	}
}
