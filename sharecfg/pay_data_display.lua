pg = pg or {}
pg.pay_data_display = rawget(pg, "pay_data_display") or setmetatable({
	__name = "pay_data_display"
}, confNEO)
pg.pay_data_display.__namecode__ = true
pg.pay_data_display.all = {
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
	9001,
	9007,
	9008,
	9009,
	9010,
	9011,
	9012,
	9013,
	9014,
	9015,
	9016,
	9017,
	9018,
	9019,
	9021,
	9022,
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
	154,
	155,
	156,
	157,
	158,
	159,
	160,
	161,
	162,
	163,
	164,
	165,
	166,
	167,
	168,
	169,
	170,
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
	1019,
	1020,
	1021,
	1022,
	1023,
	1024,
	1025,
	1026,
	1027,
	1028,
	1029,
	1301,
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
	2036,
	2037,
	2038,
	2039,
	2040,
	2041,
	2042,
	2043,
	2044,
	2045,
	2046,
	2047,
	2048,
	2049,
	2050,
	2051,
	2052,
	2053,
	2054,
	2055,
	2056,
	2057,
	2058,
	2059,
	2063,
	2064,
	2068,
	2069,
	2070,
	2071,
	2074,
	2075,
	2076,
	2078,
	2079,
	2080,
	2081,
	2085,
	2086,
	2087,
	2088,
	2089,
	2090,
	2091,
	2093,
	2094,
	2095,
	5011,
	5012,
	5013,
	5014,
	5015,
	5016,
	5017,
	70001
}
pg.pay_data_display.get_id_list_by_extra_service = {
	[0] = {
		3,
		4,
		5,
		6,
		7,
		8
	},
	[2] = {
		1
	},
	[3] = {
		2,
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
		9001,
		9007,
		9008,
		9009,
		9010,
		9011,
		9012,
		9013,
		9014,
		9015,
		9016,
		9017,
		9018,
		9019,
		9021,
		9022,
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
		154,
		155,
		156,
		157,
		158,
		159,
		160,
		161,
		162,
		163,
		164,
		165,
		166,
		167,
		168,
		169,
		170,
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
		2036,
		2037,
		2038,
		2039,
		2040,
		2041,
		2042,
		2043,
		2044,
		2045,
		2046,
		2047,
		2048,
		2049,
		2050,
		2051,
		2052,
		2053,
		2054,
		2055,
		2056,
		2057,
		2058,
		2059,
		2063,
		2064,
		2068,
		2069,
		2070,
		2071,
		2074,
		2075,
		2076,
		2078,
		2079,
		2080,
		2081,
		2085,
		2086,
		2087,
		2088,
		2089,
		2090,
		2091,
		2093,
		2094,
		2095,
		5011,
		5012,
		5013,
		5014,
		5015,
		5016,
		5017
	},
	[4] = {
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
		1019,
		1020,
		1021,
		1022,
		1023,
		1024,
		1025,
		1026,
		1027,
		1028,
		1029,
		1301
	},
	[6] = {
		70001
	}
}
pg.base = pg.base or {}
pg.base.pay_data_display = {}

;(function()
	pg.base.pay_data_display[1] = {
		limit_group = 0,
		name = "Trade License (30 days)",
		descrip_extra = "",
		type = 0,
		second_text = "Get Every Day for 30 Days",
		id = 1,
		subject = "Trade License",
		first_text = "Get Now",
		package_sort_id = 0,
		tip = "",
		money = 799,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 500,
		descrip = "Receive $1 Gems immediately and resources every day for \n30 days.",
		name_display = "Trade License (30 days)",
		limit_type = 1,
		time = "always",
		akashi_pick = 0,
		package_tag = "",
		picture = "month",
		type_order = 0,
		skin_inquire_relation = 0,
		extra_service = 2,
		id_str = "com.yostaren.azurlane.passport1",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 7,
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				1,
				14,
				500
			}
		}
	}
	pg.base.pay_data_display[2] = {
		limit_group = 0,
		name = "Novice sailing supplies",
		descrip_extra = "",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "Novice sailing supplies",
		package_sort_id = 1,
		tip = "",
		tip_open = 0,
		money = 99,
		cash_show = 0,
		descrip = "Contains Gems and shipbuilding materials.",
		name_display = "Novice sailing supplies",
		gem = 0,
		limit_arg = 1,
		limit_type = 2,
		package_tag = "For\nNovice",
		picture = "boxNewplayer",
		id_str = "com.yostaren.azurlane.diamond101",
		extra_gem = 0,
		id = 2,
		airijp_id = "com.yostaren.azurlane.diamond101",
		first_icon = "",
		first_text = "",
		tag = 1,
		akashi_pick = 1,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "",
		package_tag_open = 1,
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
	}
	pg.base.pay_data_display[3] = {
		limit_group = 0,
		name = "Handful of Gems",
		descrip_extra = "",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "60 Gems",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 99,
		cash_show = 0,
		descrip = "Get $1 Gems as bonus",
		name_display = "Handful of Gems",
		gem = 60,
		extra_service_item = "0",
		limit_arg = 10,
		limit_type = 99,
		package_tag = "",
		picture = "1",
		id_str = "com.yostaren.azurlane.diamond1",
		extra_gem = 0,
		id = 3,
		airijp_id = "com.yostaren.azurlane.diamond1",
		first_icon = "",
		first_text = "",
		tag = 0,
		akashi_pick = 0,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 1,
		extra_service = 0,
		show_group = "",
		package_tag_open = 0,
		display = {},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[4] = {
		limit_group = 0,
		name = "Pile of Gems",
		descrip_extra = "",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "300 Gems",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 499,
		cash_show = 0,
		descrip = "Get $1 Gems as bonus",
		name_display = "Pile of Gems",
		gem = 300,
		extra_service_item = "0",
		limit_arg = 10,
		limit_type = 99,
		package_tag = "",
		picture = "2",
		id_str = "com.yostaren.azurlane.diamond2",
		extra_gem = 30,
		id = 4,
		airijp_id = "com.yostaren.azurlane.diamond2",
		first_icon = "",
		first_text = "",
		tag = 0,
		akashi_pick = 0,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 1,
		extra_service = 0,
		show_group = "",
		package_tag_open = 0,
		display = {},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[5] = {
		limit_group = 0,
		name = "Sack of Gems",
		descrip_extra = "",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "980 Gems",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 999,
		cash_show = 0,
		descrip = "Get $1 Gems as bonus",
		name_display = "Sack of Gems",
		gem = 600,
		extra_service_item = "0",
		limit_arg = 0,
		limit_type = 0,
		package_tag = "",
		picture = "3",
		id_str = "com.yostaren.azurlane.diamond3",
		extra_gem = 150,
		id = 5,
		airijp_id = "com.yostaren.azurlane.diamond3",
		first_icon = "",
		first_text = "",
		tag = 0,
		akashi_pick = 0,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 1,
		extra_service = 0,
		show_group = "",
		package_tag_open = 0,
		display = {},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[6] = {
		limit_group = 0,
		name = "Box of Gems",
		descrip_extra = "",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "1980 Gems",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 1999,
		cash_show = 0,
		descrip = "Get $1 Gems as bonus",
		name_display = "Box of Gems",
		gem = 1200,
		extra_service_item = "0",
		limit_arg = 0,
		limit_type = 0,
		package_tag = "",
		picture = "4",
		id_str = "com.yostaren.azurlane.diamond4",
		extra_gem = 360,
		id = 6,
		airijp_id = "com.yostaren.azurlane.diamond4",
		first_icon = "",
		first_text = "",
		tag = 0,
		akashi_pick = 0,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 1,
		extra_service = 0,
		show_group = "",
		package_tag_open = 0,
		display = {},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[7] = {
		limit_group = 0,
		name = "Chest of Gems",
		descrip_extra = "",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "3280 Gems",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 3999,
		cash_show = 0,
		descrip = "Get $1 Gems as bonus",
		name_display = "Chest of Gems",
		gem = 2400,
		extra_service_item = "0",
		limit_arg = 0,
		limit_type = 0,
		package_tag = "",
		picture = "5",
		id_str = "com.yostaren.azurlane.diamond5",
		extra_gem = 880,
		id = 7,
		airijp_id = "com.yostaren.azurlane.diamond5",
		first_icon = "",
		first_text = "",
		tag = 0,
		akashi_pick = 0,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 1,
		extra_service = 0,
		show_group = "",
		package_tag_open = 0,
		display = {},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[8] = {
		limit_group = 0,
		name = "Ship of Gems",
		descrip_extra = "",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "6480 Gems",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 7999,
		cash_show = 0,
		descrip = "Get $1 Gems as bonus",
		name_display = "Ship of Gems",
		gem = 4900,
		extra_service_item = "0",
		limit_arg = 0,
		limit_type = 0,
		package_tag = "",
		picture = "6",
		id_str = "com.yostaren.azurlane.diamond6",
		extra_gem = 2500,
		id = 8,
		airijp_id = "com.yostaren.azurlane.diamond6",
		first_icon = "",
		first_text = "",
		tag = 1,
		akashi_pick = 0,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 1,
		extra_service = 0,
		show_group = "",
		package_tag_open = 0,
		display = {},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[24] = {
		limit_group = 0,
		name = "2020 Party Dress Lucky Bag",
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		second_text = "",
		id = 24,
		subject = "2020 Party Dress Lucky Bag",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit, 2020 Gems, and a large amount of supplies. ",
		limit_type = 2,
		name_display = "2020 Party Dress Lucky Bag",
		type_order = 0,
		package_tag = "",
		picture = "lihe3_l",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond138",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[25] = {
		limit_group = 0,
		name = "Shougatsu Lucky Bag 2021 ",
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		second_text = "",
		id = 25,
		subject = "Shougatsu Lucky Bag 2021",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit, 2021 Gems, and a large amount of supplies. ",
		limit_type = 2,
		name_display = "Shougatsu Lucky Bag 2021 ",
		type_order = 0,
		package_tag = "",
		picture = "fudai3",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond142",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[26] = {
		limit_group = 0,
		name = "Shougatsu Lucky Bag 2020 ",
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		second_text = "",
		id = 26,
		subject = "Shougatsu Lucky Bag 2020",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit, 2020 Gems, and a large amount of supplies. ",
		limit_type = 2,
		name_display = "Shougatsu Lucky Bag 2020 ",
		type_order = 0,
		package_tag = "",
		picture = "fudai1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond126",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[27] = {
		limit_group = 0,
		name = "Lunar New Year Lucky Bag (2021)",
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		second_text = "",
		id = 27,
		subject = "Lunar New Year Lucky Bag (2021)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit, 2021 Gems, and a large amount of supplies. ",
		limit_type = 2,
		name_display = "Lunar New Year Lucky Bag (2021)",
		type_order = 0,
		package_tag = "",
		picture = "fudai4",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond143",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[28] = {
		limit_group = 0,
		name = "Lunar New Year Lucky Bag (2020)",
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		second_text = "",
		id = 28,
		subject = "Lunar New Year Lucky Bag (2020)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit, 2020 Gems, and a large amount of supplies. ",
		limit_type = 2,
		name_display = "Lunar New Year Lucky Bag (2020)",
		type_order = 0,
		package_tag = "",
		picture = "fudai2",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond128",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[29] = {
		limit_group = 0,
		name = "Exquisite Lucky Box 2021 ",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 29,
		subject = "Exquisite Lucky Box 2021 ",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit, 2021 Gems, and a large amount of supplies. ",
		limit_type = 2,
		name_display = "Exquisite Lucky Box 2021 ",
		type_order = 0,
		package_tag = "",
		picture = "lihe6_l",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond146",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[30] = {
		limit_group = 0,
		name = "Exquisite Lucky Bag 2020 ",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 30,
		subject = "Exquisite Lucky Bag 2020 ",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit, 2020 Gems, and a large amount of supplies. ",
		limit_type = 2,
		name_display = "Exquisite Lucky Bag 2020 ",
		type_order = 0,
		package_tag = "",
		picture = "lihe1_l",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond147",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[31] = {
		limit_group = 0,
		name = "New Commanders Support Pack IV ",
		descrip_extra = "The pack includes lots of material rewards. The Startup Pack will be sent to you via in-game mail, please check your mailbox to claim the pack. ",
		type = 1,
		second_text = "+Resources",
		id = 31,
		subject = "New Commanders Support Pack IV ",
		first_text = "Get Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 1,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1980 x Gems, 35x Universal T4 Plate, 1x Gear Lab Development Pack, and other rewards ",
		name_display = "New Commanders Support Pack IV ",
		limit_type = 2,
		time = "always",
		akashi_pick = 1,
		package_tag = "",
		picture = "support4",
		type_order = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond148",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
				2,
				14004,
				25
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
		},
		first_icon = {
			{
				1,
				14,
				1980
			}
		}
	}
	pg.base.pay_data_display[32] = {
		limit_group = 0,
		name = "2021 Party Dress Lucky Box",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 32,
		subject = "2021 Party Dress Lucky Box",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit, 2021 Gems, and a large amount of supplies. ",
		limit_type = 2,
		name_display = "2021 Party Dress Lucky Box",
		type_order = 0,
		package_tag = "",
		picture = "lihe6_l",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond151",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[33] = {
		limit_group = 0,
		name = "2020 Party Dress Lucky Box",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 33,
		subject = "2020 Party Dress Lucky Box",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit, 2020 Gems, and a large amount of supplies. ",
		limit_type = 2,
		name_display = "2020 Party Dress Lucky Box",
		type_order = 0,
		package_tag = "",
		picture = "lihe3_l",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond150",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[34] = {
		limit_group = 0,
		name = "Shougatsu Lucky Box 2022 ",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 34,
		subject = "Shougatsu Lucky Box 2022 ",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit, 2022 Gems, and a large amount of supplies. ",
		limit_type = 2,
		name_display = "Shougatsu Lucky Box 2022 ",
		type_order = 0,
		package_tag = "",
		picture = "fudai6",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond154",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[35] = {
		limit_group = 0,
		name = "Shougatsu Lucky Bag 2021 ",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 35,
		subject = "Shougatsu Lucky Bag 2021 ",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit, 2021 Gems, and a large amount of supplies. ",
		limit_type = 2,
		name_display = "Shougatsu Lucky Bag 2021 ",
		type_order = 0,
		package_tag = "",
		picture = "fudai3",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond153",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[36] = {
		limit_group = 0,
		name = "Lunar New Year Lucky Bag (2022)",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 36,
		subject = "Lunar New Year Lucky Bag (2022)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit, 2022 Gems, and a large amount of supplies. ",
		limit_type = 2,
		name_display = "Lunar New Year Lucky Bag (2022)",
		type_order = 0,
		package_tag = "",
		picture = "fudai7",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond156",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[37] = {
		limit_group = 0,
		name = "Lunar New Year Lucky Bag (2021)",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 37,
		subject = "Lunar New Year Lucky Bag (2021)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit, 2021 Gems, and a large amount of supplies. ",
		limit_type = 2,
		name_display = "Lunar New Year Lucky Bag (2021)",
		type_order = 0,
		package_tag = "",
		picture = "fudai4",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond155",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[38] = {
		limit_group = 0,
		name = "Exquisite Lucky Box 2022 ",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 38,
		subject = "Exquisite Lucky Box 2022 ",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit, 2022 Gems, and a large amount of supplies. ",
		limit_type = 2,
		name_display = "Exquisite Lucky Box 2022 ",
		type_order = 0,
		package_tag = "",
		picture = "lihe8_l",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond167",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[39] = {
		limit_group = 0,
		name = "Exquisite Lucky Box 2021 ",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 39,
		subject = "Exquisite Lucky Box 2021 ",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit, 2021 Gems, and a large amount of supplies. ",
		limit_type = 2,
		name_display = "Exquisite Lucky Box 2021 ",
		type_order = 0,
		package_tag = "",
		picture = "lihe6_l",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond168",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[42] = {
		limit_group = 0,
		name = "Party Dress Lucky Box 2021 Rerun",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "",
		id = 42,
		subject = "Party Dress Lucky Box 2021 Rerun",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit, 2021 Gems, and a large amount of supplies.",
		limit_type = 2,
		name_display = "Party Dress Lucky Box 2021 Rerun",
		type_order = 2,
		package_tag = "",
		picture = "lihe6_l",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond175",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[43] = {
		limit_group = 0,
		name = "Party Dress Lucky Box 2022",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "",
		id = 43,
		subject = "Party Dress Lucky Box 2022",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit, 2022 Gems, and a large amount of supplies.",
		limit_type = 2,
		name_display = "Party Dress Lucky Box 2022",
		type_order = 2,
		package_tag = "",
		picture = "lihe8_l",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond176",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[44] = {
		limit_group = 0,
		name = "Welcome Back Pack",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 1,
		second_text = "",
		id = 44,
		subject = "Welcome Back Pack",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1799,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains loads of valuable rewads.",
		limit_type = 2,
		name_display = "Welcome Back Pack",
		type_order = 2,
		package_tag = "",
		picture = "support6",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond179",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[45] = {
		limit_group = 0,
		name = "Winter Swimsuit Lucky Bag 2022 A",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "",
		id = 45,
		subject = "Winter Swimsuit Lucky Bag 2022 A",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		limit_type = 2,
		name_display = "Winter Swimsuit Lucky Bag 2022 A",
		type_order = 2,
		package_tag = "",
		picture = "lihe10_l",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.luckybag2",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[46] = {
		limit_group = 0,
		name = "Winter Swimsuit Lucky Bag 2022 B",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "",
		id = 46,
		subject = "Winter Swimsuit Lucky Bag 2022 B",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		limit_type = 2,
		name_display = "Winter Swimsuit Lucky Bag 2022 B",
		type_order = 2,
		package_tag = "",
		picture = "lihe11_l",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.luckybag3",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[47] = {
		limit_group = 0,
		name = "Shougatsu Lucky Box 2022 Rerun",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "",
		id = 47,
		subject = "Shougatsu Lucky Box 2022 Rerun",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit, 2022 Gems, and a large amount of supplies.",
		limit_type = 2,
		name_display = "Shougatsu Lucky Box 2022 Rerun",
		type_order = 2,
		package_tag = "",
		picture = "fudai6",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.luckybag1",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[48] = {
		limit_group = 0,
		name = "Spring Lucky Bag 2023 A",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "",
		id = 48,
		subject = "Spring Lucky Bag 2023 A",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		limit_type = 2,
		name_display = "Spring Lucky Bag 2023 A",
		type_order = 2,
		package_tag = "",
		picture = "fudaiqp1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.luckybag5",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[49] = {
		limit_group = 0,
		name = "Spring Lucky Bag 2023 B",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "",
		id = 49,
		subject = "Spring Lucky Bag 2023 B",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		limit_type = 2,
		name_display = "Spring Lucky Bag 2023 B",
		type_order = 2,
		package_tag = "",
		picture = "fudaiqp2",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.luckybag7",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[50] = {
		limit_group = 0,
		name = "Lunar New Year Lucky Bag 2022 Rerun",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "",
		id = 50,
		subject = "Lunar New Year Lucky Bag 2022 Rerun",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit, 2022 Gems, and a large amount of supplies.",
		limit_type = 2,
		name_display = "Lunar New Year Lucky Bag 2022 Rerun",
		type_order = 2,
		package_tag = "",
		picture = "fudai7",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.luckybag6",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[51] = {
		limit_group = 0,
		name = "Swimsuit Lucky Bag 2023",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 51,
		subject = "Swimsuit Lucky Bag 2023",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains items, resources, and a random Summer 2023 swimsuit skin.",
		name_display = "Swimsuit Lucky Bag 2023",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "lihecn6ss_l",
		extra_service = 3,
		skin_inquire_relation = 69926,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag10",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				69926,
				1
			},
			{
				1,
				4,
				2023
			}
		}
	}
	pg.base.pay_data_display[52] = {
		limit_group = 0,
		name = "Exquisite Lucky Box 2023",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 52,
		subject = "Exquisite Lucky Box 2023",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		name_display = "Exquisite Lucky Box 2023",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "liheus6lf_l",
		extra_service = 3,
		skin_inquire_relation = 69927,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag11",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				69927,
				1
			},
			{
				1,
				4,
				2023
			}
		}
	}
	pg.base.pay_data_display[53] = {
		limit_group = 0,
		name = "Exquisite Lucky Box 2022 Rerun",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 53,
		subject = "Exquisite Lucky Box 2022 Rerun",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2022 Gems, and a large amount of supplies.",
		name_display = "Exquisite Lucky Box 2022 Rerun",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "lihe8_l",
		extra_service = 3,
		skin_inquire_relation = 69919,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag12",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				69919,
				1
			},
			{
				1,
				4,
				2022
			}
		}
	}
	pg.base.pay_data_display[55] = {
		limit_group = 0,
		name = "Autumn Classics Lucky Box ",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 55,
		subject = "Autumn Classics Lucky Box ",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		name_display = "Autumn Classics Lucky Box ",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "lihejp6lf_l",
		extra_service = 3,
		skin_inquire_relation = 69929,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag16",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				69929,
				1
			},
			{
				1,
				4,
				2023
			}
		}
	}
	pg.base.pay_data_display[56] = {
		limit_group = 0,
		name = "Party Dress Lucky Box 2022 Rerun ",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 56,
		subject = "Party Dress Lucky Box 2022 Rerun ",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2022 Gems, and a large amount of supplies.",
		name_display = "Party Dress Lucky Box 2022 Rerun ",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "lihe8_l",
		extra_service = 3,
		skin_inquire_relation = 69920,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag17",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				69920,
				1
			},
			{
				1,
				4,
				2022
			}
		}
	}
	pg.base.pay_data_display[57] = {
		limit_group = 0,
		name = "Fashion Collection Lucky Bag ",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 57,
		subject = "Fashion Collection Lucky Bag ",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		name_display = "Fashion Collection Lucky Bag ",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "lihejp6ss_l",
		extra_service = 3,
		skin_inquire_relation = 69928,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag15",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				69928,
				1
			},
			{
				1,
				4,
				2023
			}
		}
	}
	pg.base.pay_data_display[61] = {
		limit_group = 0,
		name = "Resplendent Night Lucky Bag I",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 61,
		subject = "Resplendent Night Lucky Bag I",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2024 Gems, and a large amount of supplies.",
		name_display = "Resplendent Night Lucky Bag I",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai9",
		extra_service = 3,
		skin_inquire_relation = 86200,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag21",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				86200,
				1
			},
			{
				1,
				4,
				2024
			}
		}
	}
	pg.base.pay_data_display[62] = {
		limit_group = 0,
		name = "Winter Swimsuit Lucky Bag 2022 A Rerun",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 62,
		subject = "Winter Swimsuit Lucky Bag 2022 A Rerun",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		name_display = "Winter Swimsuit Lucky Bag 2022 A Rerun",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "lihe10_l",
		extra_service = 3,
		skin_inquire_relation = 69922,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag20",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				69922,
				1
			},
			{
				1,
				4,
				2023
			}
		}
	}
	pg.base.pay_data_display[63] = {
		limit_group = 0,
		name = "Resplendent Night Lucky Bag II",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 63,
		subject = "Resplendent Night Lucky Bag II",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2024 Gems, and a large amount of supplies.",
		name_display = "Resplendent Night Lucky Bag II",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai10",
		extra_service = 3,
		skin_inquire_relation = 86201,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag23",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				86201,
				1
			},
			{
				1,
				4,
				2024
			}
		}
	}
	pg.base.pay_data_display[64] = {
		limit_group = 0,
		name = "Winter Swimsuit Lucky Bag 2022 B Rerun",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 64,
		subject = "Winter Swimsuit Lucky Bag 2022 B Rerun",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		name_display = "Winter Swimsuit Lucky Bag 2022 B Rerun",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "lihe11_l",
		extra_service = 3,
		skin_inquire_relation = 69923,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag22",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				69923,
				1
			},
			{
				1,
				4,
				2023
			}
		}
	}
	pg.base.pay_data_display[65] = {
		limit_group = 0,
		name = "Spring Lucky Box 2024 A",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 65,
		subject = "Spring Lucky Box 2024 A",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2024 Gems, and a large amount of supplies.",
		name_display = "Spring Lucky Box 2024 A",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai11",
		extra_service = 3,
		skin_inquire_relation = 86202,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag25",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				86202,
				1
			},
			{
				1,
				4,
				2024
			}
		}
	}
	pg.base.pay_data_display[66] = {
		limit_group = 0,
		name = "Spring Lucky Bag 2023 A Rerun",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 66,
		subject = "Spring Lucky Bag 2023 A Rerun",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		name_display = "Spring Lucky Bag 2023 A Rerun",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudaiqp1",
		extra_service = 3,
		skin_inquire_relation = 69924,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag24",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				69924,
				1
			},
			{
				1,
				4,
				2023
			}
		}
	}
	pg.base.pay_data_display[67] = {
		limit_group = 0,
		name = "Spring Lucky Box 2024 B",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 67,
		subject = "Spring Lucky Box 2024 B",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2024 Gems, and a large amount of supplies.",
		name_display = "Spring Lucky Box 2024 B",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai12",
		extra_service = 3,
		skin_inquire_relation = 86203,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag27",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				86203,
				1
			},
			{
				1,
				4,
				2024
			}
		}
	}
	pg.base.pay_data_display[68] = {
		limit_group = 0,
		name = "Spring Lucky Bag 2023 B Rerun",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 68,
		subject = "Spring Lucky Bag 2023 B Rerun",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		name_display = "Spring Lucky Bag 2023 B Rerun",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudaiqp2",
		extra_service = 3,
		skin_inquire_relation = 69925,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag26",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				69925,
				1
			},
			{
				1,
				4,
				2023
			}
		}
	}
	pg.base.pay_data_display[69] = {
		limit_group = 0,
		name = "Swimsuit Lucky Bag 2024",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 69,
		subject = "Swimsuit Lucky Bag 2024",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2024 Gems, and a large amount of supplies.",
		name_display = "Swimsuit Lucky Bag 2024",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai13",
		extra_service = 3,
		skin_inquire_relation = 86204,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag31",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				86204,
				1
			},
			{
				1,
				14,
				2024
			}
		}
	}
	pg.base.pay_data_display[70] = {
		limit_group = 0,
		name = "Swimsuit Lucky Bag 2023 Rerun",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 70,
		subject = "Swimsuit Lucky Bag 2023 Rerun",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		name_display = "Swimsuit Lucky Bag 2023 Rerun",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "lihecn6ss_l",
		extra_service = 3,
		skin_inquire_relation = 69926,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag32",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				69926,
				1
			},
			{
				1,
				4,
				2023
			}
		}
	}
	pg.base.pay_data_display[71] = {
		limit_group = 0,
		name = "Exquisite Lucky Envelope 2024",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 71,
		subject = "Exquisite Lucky Envelope 2024",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2024 Gems, and a large amount of supplies.",
		name_display = "Exquisite Lucky Envelope 2024",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai14",
		extra_service = 3,
		skin_inquire_relation = 86205,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag33",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				86205,
				1
			},
			{
				1,
				14,
				2024
			}
		}
	}
	pg.base.pay_data_display[72] = {
		limit_group = 0,
		name = "Exquisite Lucky Box 2023 Rerun",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 72,
		subject = "Exquisite Lucky Box 2023 Rerun",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		name_display = "Exquisite Lucky Box 2023 Rerun",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "lihecn6lf_l",
		extra_service = 3,
		skin_inquire_relation = 69927,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag34",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				69927,
				1
			},
			{
				1,
				4,
				2023
			}
		}
	}
	pg.base.pay_data_display[73] = {
		limit_group = 0,
		name = "Dreamland Lucky Bag A",
		descrip_extra = "The pack includes lots of material rewards. The Startup Pack will be sent to you via in-game mail, please check your mailbox to claim the pack.",
		type = 1,
		second_text = "Many Rewards",
		id = 73,
		subject = "Dreamland Lucky Bag A",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2024 Gems, and a large amount of supplies.",
		name_display = "Dreamland Lucky Bag A",
		limit_type = 2,
		type_order = 3,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai15",
		extra_service = 3,
		skin_inquire_relation = 86206,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag38",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				86206,
				1
			},
			{
				1,
				14,
				2024
			}
		}
	}
	pg.base.pay_data_display[74] = {
		limit_group = 0,
		name = "Fashion Collection Lucky Bag Rerun",
		descrip_extra = "The pack includes lots of material rewards. The Startup Pack will be sent to you via in-game mail, please check your mailbox to claim the pack.",
		type = 1,
		second_text = "Many Rewards",
		id = 74,
		subject = "Fashion Collection Lucky Bag Rerun",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		name_display = "Fashion Collection Lucky Bag Rerun",
		limit_type = 2,
		type_order = 3,
		akashi_pick = 1,
		package_tag = "",
		picture = "lihejp6ss_l",
		extra_service = 3,
		skin_inquire_relation = 69928,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag39",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				69928,
				1
			},
			{
				1,
				4,
				2023
			}
		}
	}
	pg.base.pay_data_display[75] = {
		limit_group = 0,
		name = "Dreamland Lucky Bag B",
		descrip_extra = "The pack includes lots of material rewards. The Startup Pack will be sent to you via in-game mail, please check your mailbox to claim the pack.",
		type = 1,
		second_text = "Many Rewards",
		id = 75,
		subject = "Dreamland Lucky Bag B",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2024 Gems, and a large amount of supplies.",
		name_display = "Dreamland Lucky Bag B",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai16",
		extra_service = 3,
		skin_inquire_relation = 86207,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag40",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				86207,
				1
			},
			{
				1,
				14,
				2024
			}
		}
	}
	pg.base.pay_data_display[76] = {
		limit_group = 0,
		name = "Autumn Classics Lucky Box Rerun",
		descrip_extra = "The pack includes lots of material rewards. The Startup Pack will be sent to you via in-game mail, please check your mailbox to claim the pack.",
		type = 1,
		second_text = "Many Rewards",
		id = 76,
		subject = "Autumn Classics Lucky Box Rerun",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2023 Gems, and a large amount of supplies.",
		name_display = "Autumn Classics Lucky Box Rerun",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "lihejp6lf_l",
		extra_service = 3,
		skin_inquire_relation = 69929,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag41",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				69929,
				1
			},
			{
				1,
				4,
				2023
			}
		}
	}
	pg.base.pay_data_display[77] = {
		limit_group = 0,
		name = "Choose-Your-Own Gift Pack I",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 77,
		subject = "Choose-Your-Own Gift Pack I",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1499,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 980x Gems, 1x Choose-Your-Own Gift Pack I, and loads of other valuable rewards.",
		limit_type = 2,
		name_display = "Choose-Your-Own Gift Pack I",
		type_order = 2,
		package_tag = "",
		picture = "pack_2024_98",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.bfchoosebag3",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[78] = {
		limit_group = 0,
		name = "Choose-Your-Own Gift Pack II",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 78,
		subject = "Choose-Your-Own Gift Pack II",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 1980x Gems, 1x Choose-Your-Own Gift Pack II, and loads of other valuable rewards.",
		limit_type = 2,
		name_display = "Choose-Your-Own Gift Pack II",
		type_order = 2,
		package_tag = "",
		picture = "pack_2024_198",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.bfchoosebag4",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[79] = {
		limit_group = 0,
		name = "Choose-Your-Own Gift Pack III",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 79,
		subject = "Choose-Your-Own Gift Pack III",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 4499,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 3280x Gems, 1x Choose-Your-Own Gift Pack III, and loads of other valuable rewards.",
		limit_type = 2,
		name_display = "Choose-Your-Own Gift Pack III",
		type_order = 2,
		package_tag = "",
		picture = "pack_2024_328",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.bfchoosebag5",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[82] = {
		limit_group = 0,
		name = "Game Night Lucky Bag A",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 82,
		subject = "Game Night Lucky Bag A",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains items, resources, and a random skin.",
		name_display = "Game Night Lucky Bag A",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai19",
		extra_service = 3,
		skin_inquire_relation = 86208,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag45",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag45",
		extra_service_item = {
			{
				2,
				86208,
				1
			},
			{
				1,
				14,
				2025
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
					2025,
					1,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81208,
				1
			}
		},
		first_icon = {
			{
				2,
				86208,
				1
			},
			{
				1,
				14,
				2025
			}
		}
	}
	pg.base.pay_data_display[83] = {
		limit_group = 0,
		name = "Resplendent Night Lucky Bag I Rerun",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 83,
		subject = "Resplendent Night Lucky Bag I Rerun",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains items, resources, and a random skin.",
		name_display = "Resplendent Night Lucky Bag I Rerun",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai9",
		extra_service = 3,
		skin_inquire_relation = 86200,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag46",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag46",
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
					2024,
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
					2025,
					1,
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
		},
		first_icon = {
			{
				2,
				86200,
				1
			},
			{
				1,
				4,
				2024
			}
		}
	}
	pg.base.pay_data_display[84] = {
		limit_group = 0,
		name = "Game Night Lucky Bag B",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 84,
		subject = "Game Night Lucky Bag B",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains items, resources, and a random skin.",
		name_display = "Game Night Lucky Bag B",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai20",
		extra_service = 3,
		skin_inquire_relation = 86209,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag47",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag47",
		extra_service_item = {
			{
				2,
				86209,
				1
			},
			{
				1,
				14,
				2025
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
					2025,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81209,
				1
			}
		},
		first_icon = {
			{
				2,
				86209,
				1
			},
			{
				1,
				14,
				2025
			}
		}
	}
	pg.base.pay_data_display[85] = {
		limit_group = 0,
		name = "Resplendent Night Lucky Bag II Rerun",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 85,
		subject = "Resplendent Night Lucky Bag II Rerun",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains items, resources, and a random skin.",
		name_display = "Resplendent Night Lucky Bag II Rerun",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai10",
		extra_service = 3,
		skin_inquire_relation = 86201,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag48",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag48",
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
					2024,
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
					2025,
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
		},
		first_icon = {
			{
				2,
				86201,
				1
			},
			{
				1,
				4,
				2024
			}
		}
	}
	pg.base.pay_data_display[86] = {
		limit_group = 0,
		name = "Spring Lucky Bag 2025 A",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 86,
		subject = "Spring Lucky Bag 2025 A",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2025 Gems, and a large amount of supplies.",
		name_display = "Spring Lucky Bag 2025 A",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai21",
		extra_service = 3,
		skin_inquire_relation = 86210,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag49",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag49",
		extra_service_item = {
			{
				2,
				86210,
				1
			},
			{
				1,
				14,
				2025
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
					2025,
					1,
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
					2025,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81210,
				1
			}
		},
		first_icon = {
			{
				2,
				86210,
				1
			},
			{
				1,
				14,
				2025
			}
		}
	}
	pg.base.pay_data_display[87] = {
		limit_group = 0,
		name = "Spring Lucky Bag 2025 B",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 87,
		subject = "Spring Lucky Bag 2025 B",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2025 Gems, and a large amount of supplies.",
		name_display = "Spring Lucky Bag 2025 B",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai22",
		extra_service = 3,
		skin_inquire_relation = 86211,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag51",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag51",
		extra_service_item = {
			{
				2,
				86211,
				1
			},
			{
				1,
				14,
				2025
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
					2025,
					1,
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
					2025,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81211,
				1
			}
		},
		first_icon = {
			{
				2,
				86211,
				1
			},
			{
				1,
				14,
				2025
			}
		}
	}
	pg.base.pay_data_display[88] = {
		limit_group = 0,
		name = "Spring Lucky Box 2024 A (Rerun)",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 88,
		subject = "Spring Lucky Box 2024 A (Rerun)",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2024 Gems, and a large amount of supplies.",
		name_display = "Spring Lucky Box 2024 A (Rerun)",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai11",
		extra_service = 3,
		skin_inquire_relation = 86202,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag50",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag50",
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
					2025,
					1,
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
					2025,
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
		},
		first_icon = {
			{
				2,
				86202,
				1
			},
			{
				1,
				4,
				2024
			}
		}
	}
	pg.base.pay_data_display[89] = {
		limit_group = 0,
		name = "Spring Lucky Box 2024 B (Rerun)",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 89,
		subject = "Spring Lucky Box 2024 B (Rerun)",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2024 Gems, and a large amount of supplies.",
		name_display = "Spring Lucky Box 2024 B (Rerun)",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai12",
		extra_service = 3,
		skin_inquire_relation = 86203,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag52",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag52",
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
					2025,
					1,
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
					2025,
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
		},
		first_icon = {
			{
				2,
				86203,
				1
			},
			{
				1,
				4,
				2024
			}
		}
	}
	pg.base.pay_data_display[90] = {
		limit_group = 0,
		name = "School Return Lucky Box",
		descrip_extra = "* The Lucky Box will be sent to your ingame Mail.\n* If you already own all the listed skins, you will receive Gems x680 instead.",
		type = 1,
		second_text = "Many Rewards",
		id = 90,
		subject = "School Return Lucky Box",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 699,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1 of the following skins you do not yet own, chosen at random (if you already own all the listed skins, you will receive Gems instead), as well as other items.",
		name_display = "School Return Lucky Box",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai23",
		extra_service = 3,
		skin_inquire_relation = 86212,
		limit_arg = 2,
		id_str = "com.yostaren.azurlane.luckybag55",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag55",
		extra_service_item = {
			{
				2,
				86212,
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
					2025,
					3,
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
					2025,
					4,
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
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81212,
				1
			}
		},
		first_icon = {
			{
				2,
				86212,
				1
			}
		}
	}
	pg.base.pay_data_display[91] = {
		limit_group = 0,
		name = "Swimsuit Lucky Bag 2025 A",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 91,
		subject = "Swimsuit Lucky Bag 2025 A",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1 random skin, 2025 Gems, and supplies.",
		name_display = "Swimsuit Lucky Bag 2025 A",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai24",
		extra_service = 3,
		skin_inquire_relation = 86213,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag57",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag57",
		extra_service_item = {
			{
				2,
				86213,
				1
			},
			{
				1,
				14,
				2025
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
					2025,
					5,
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
					2025,
					6,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81213,
				1
			}
		},
		first_icon = {
			{
				2,
				86213,
				1
			},
			{
				1,
				14,
				2025
			}
		}
	}
	pg.base.pay_data_display[92] = {
		limit_group = 0,
		name = "Swimsuit Lucky Bag 2024 Rerun",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 92,
		subject = "Swimsuit Lucky Bag 2024 Rerun",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1 random skin, 2024 Gems, and supplies.",
		name_display = "Swimsuit Lucky Bag 2024 Rerun",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai13",
		extra_service = 3,
		skin_inquire_relation = 86204,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag58",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag58",
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
					2025,
					5,
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
					2025,
					6,
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
		},
		first_icon = {
			{
				2,
				86204,
				1
			},
			{
				1,
				14,
				2024
			}
		}
	}
	pg.base.pay_data_display[93] = {
		limit_group = 0,
		name = "Swimsuit Lucky Bag 2025 B",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 93,
		subject = "Swimsuit Lucky Bag 2025 B",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1 random skin, 2025 Gems, and supplies.",
		name_display = "Swimsuit Lucky Bag 2025 B",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai25",
		extra_service = 3,
		skin_inquire_relation = 86214,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag59",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag59",
		extra_service_item = {
			{
				2,
				86214,
				1
			},
			{
				1,
				14,
				2025
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
					2025,
					5,
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
					2025,
					6,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81214,
				1
			}
		},
		first_icon = {
			{
				2,
				86214,
				1
			},
			{
				1,
				14,
				2025
			}
		}
	}
	pg.base.pay_data_display[94] = {
		limit_group = 0,
		name = "Exquisite Lucky Envelope 2024 Rerun",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 94,
		subject = "Exquisite Lucky Envelope 2024 Rerun",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1 random skin, 2024 Gems, and supplies.",
		name_display = "Exquisite Lucky Envelope 2024 Rerun",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai14",
		extra_service = 3,
		skin_inquire_relation = 86205,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag60",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag60",
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
					2025,
					5,
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
					2025,
					6,
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
		},
		first_icon = {
			{
				2,
				86205,
				1
			},
			{
				1,
				14,
				2024
			}
		}
	}
	pg.base.pay_data_display[95] = {
		limit_group = 0,
		name = "Bunny Girl Return Lucky Box",
		descrip_extra = "* The Lucky Box will be sent to your ingame Mail.\n* If you already own all the listed skins, you will receive Gems x680 instead.",
		type = 1,
		second_text = "Many Rewards",
		id = 95,
		subject = "Bunny Girl Return Lucky Box",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 699,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1 of the following skins you do not yet own, chosen at random (if you already own all the listed skins, you will receive Gems instead), as well as other items.",
		name_display = "Bunny Girl Return Lucky Box",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai26",
		extra_service = 3,
		skin_inquire_relation = 86215,
		limit_arg = 2,
		id_str = "com.yostaren.azurlane.luckybag62",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag62",
		extra_service_item = {
			{
				2,
				86215,
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
					2025,
					7,
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
					2025,
					8,
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
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81215,
				1
			}
		},
		first_icon = {
			{
				2,
				86215,
				1
			}
		}
	}
	pg.base.pay_data_display[96] = {
		limit_group = 0,
		name = "Ninja Castle Lucky Box A",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 96,
		subject = "Ninja Castle Lucky Box A",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1 random skin, 2025 Gems, and supplies.",
		name_display = "Ninja Castle Lucky Box A",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai27",
		extra_service = 3,
		skin_inquire_relation = 86217,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag64",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag64",
		extra_service_item = {
			{
				2,
				86217,
				1
			},
			{
				1,
				14,
				2025
			},
			{
				2,
				42076,
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
					2025,
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
					2025,
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
				42076,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81217,
				1
			}
		},
		first_icon = {
			{
				2,
				86217,
				1
			},
			{
				1,
				14,
				2025
			}
		}
	}
	pg.base.pay_data_display[97] = {
		limit_group = 0,
		name = "Dreamland Lucky Bag A Rerun",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 97,
		subject = "Dreamland Lucky Bag A Rerun",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1 random skin, 2024 Gems, and supplies.",
		name_display = "Dreamland Lucky Bag A Rerun",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai15",
		extra_service = 3,
		skin_inquire_relation = 86206,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag65",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag65",
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
					2025,
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
					2025,
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
		},
		first_icon = {
			{
				2,
				86206,
				1
			},
			{
				1,
				14,
				2024
			}
		}
	}
	pg.base.pay_data_display[98] = {
		limit_group = 0,
		name = "Ninja Castle Lucky Box B",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 98,
		subject = "Ninja Castle Lucky Box B",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1 random skin, 2025 Gems, and supplies.",
		name_display = "Ninja Castle Lucky Box B",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai28",
		extra_service = 3,
		skin_inquire_relation = 86218,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag66",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag66",
		extra_service_item = {
			{
				2,
				86218,
				1
			},
			{
				1,
				14,
				2025
			},
			{
				2,
				42076,
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
					2025,
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
					2025,
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
				42076,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81218,
				1
			}
		},
		first_icon = {
			{
				2,
				86218,
				1
			},
			{
				1,
				14,
				2025
			}
		}
	}
	pg.base.pay_data_display[99] = {
		limit_group = 0,
		name = "Dreamland Lucky Bag B Rerun",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 99,
		subject = "Dreamland Lucky Bag B Rerun",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1 random skin, 2024 Gems, and supplies.",
		name_display = "Dreamland Lucky Bag B Rerun",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai16",
		extra_service = 3,
		skin_inquire_relation = 86207,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag67",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag67",
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
					2025,
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
					2025,
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
		},
		first_icon = {
			{
				2,
				86207,
				1
			},
			{
				1,
				14,
				2024
			}
		}
	}
	pg.base.pay_data_display[9001] = {
		limit_group = 0,
		name = "Sports & Race Return Lucky Box",
		descrip_extra = "* The Lucky Box will be sent to your in-game Mail.\n* If you already own all the listed skins, you will receive Gems x680 instead.",
		type = 1,
		second_text = "Many Rewards",
		id = 9001,
		subject = "Sports & Race Return Lucky Box",
		first_text = "Random Skin",
		package_sort_id = 0,
		tip = "",
		money = 699,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1 of the following skins you do not yet own, chosen at random (if you already own all the listed skins, you will receive Gems instead), as well as other items.",
		name_display = "Sports & Race Return Lucky Box",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai29",
		extra_service = 3,
		skin_inquire_relation = 86219,
		limit_arg = 2,
		id_str = "com.yostaren.azurlane.luckybag68",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag68",
		extra_service_item = {
			{
				2,
				86219,
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
					2025,
					9,
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
					2025,
					10,
					22
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
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81219,
				1
			}
		},
		first_icon = {
			{
				2,
				86219,
				1
			}
		}
	}
	pg.base.pay_data_display[9007] = {
		limit_group = 0,
		name = "Maidly Service Lucky Box A",
		descrip_extra = "*The contents of the Lucky Box will be sent to your in-game inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 9007,
		subject = "Maidly Service Lucky Box A",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1 random skin, 2026 Gems, and supplies.",
		name_display = "Maidly Service Lucky Box A",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai30",
		extra_service = 3,
		skin_inquire_relation = 86222,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag73",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag73",
		extra_service_item = {
			{
				2,
				86222,
				1
			},
			{
				1,
				14,
				2026
			},
			{
				2,
				42076,
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
					2025,
					12,
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
					2026,
					1,
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
				42076,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81230,
				1
			}
		},
		first_icon = {
			{
				2,
				86222,
				1
			},
			{
				1,
				14,
				2026
			}
		}
	}
	pg.base.pay_data_display[9008] = {
		limit_group = 0,
		name = "Game Night Lucky Bag A Rerun",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your in-game inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 9008,
		subject = "Game Night Lucky Bag A Rerun",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1 random skin, 2025 Gems, and supplies.",
		name_display = "Game Night Lucky Bag A Rerun",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai19",
		extra_service = 3,
		skin_inquire_relation = 86208,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag74",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag74",
		extra_service_item = {
			{
				2,
				86208,
				1
			},
			{
				1,
				14,
				2025
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
					2025,
					12,
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
					2026,
					1,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81208,
				1
			}
		},
		first_icon = {
			{
				2,
				86208,
				1
			},
			{
				1,
				14,
				2025
			}
		}
	}
	pg.base.pay_data_display[9009] = {
		limit_group = 0,
		name = "Maidly Service Lucky Box B",
		descrip_extra = "*The contents of the Lucky Box will be sent to your in-game inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 9009,
		subject = "Maidly Service Lucky Box B",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1 random skin, 2026 Gems, and supplies.",
		name_display = "Maidly Service Lucky Box B",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai31",
		extra_service = 3,
		skin_inquire_relation = 86223,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag75",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag75",
		extra_service_item = {
			{
				2,
				86223,
				1
			},
			{
				1,
				14,
				2026
			},
			{
				2,
				42076,
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
					2025,
					12,
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
					2026,
					1,
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
				42076,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81231,
				1
			}
		},
		first_icon = {
			{
				2,
				86223,
				1
			},
			{
				1,
				14,
				2026
			}
		}
	}
	pg.base.pay_data_display[9010] = {
		limit_group = 0,
		name = "Game Night Lucky Bag B Rerun",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your in-game inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 9010,
		subject = "Game Night Lucky Bag B Rerun",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1 random skin, 2025 Gems, and supplies.",
		name_display = "Game Night Lucky Bag B Rerun",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai20",
		extra_service = 3,
		skin_inquire_relation = 86209,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag76",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag76",
		extra_service_item = {
			{
				2,
				86209,
				1
			},
			{
				1,
				14,
				2025
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
					2025,
					12,
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
					2026,
					1,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81209,
				1
			}
		},
		first_icon = {
			{
				2,
				86209,
				1
			},
			{
				1,
				14,
				2025
			}
		}
	}
	pg.base.pay_data_display[9011] = {
		limit_group = 0,
		name = "Spring Lucky Box 2026 A",
		descrip_extra = "*The contents of the Lucky Box will be sent to your in-game inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 9011,
		subject = "Spring Lucky Box 2026 A",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1 random skin, 2026 Gems, and supplies.",
		name_display = "Spring Lucky Box 2026 A",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai32",
		extra_service = 3,
		skin_inquire_relation = 86224,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag79",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag79",
		extra_service_item = {
			{
				2,
				86224,
				1
			},
			{
				1,
				14,
				2026
			},
			{
				2,
				42076,
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
					2026,
					2,
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
					2026,
					3,
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
				42076,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81232,
				1
			}
		},
		first_icon = {
			{
				2,
				86224,
				1
			},
			{
				1,
				14,
				2026
			}
		}
	}
	pg.base.pay_data_display[9012] = {
		limit_group = 0,
		name = "Spring Lucky Bag 2025 A Rerun",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your in-game inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 9012,
		subject = "Spring Lucky Bag 2025 A Rerun",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1 random skin, 2025 Gems, and supplies.",
		name_display = "Spring Lucky Bag 2025 A Rerun",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai21",
		extra_service = 3,
		skin_inquire_relation = 86210,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag80",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag80",
		extra_service_item = {
			{
				2,
				86210,
				1
			},
			{
				1,
				14,
				2025
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
					2026,
					2,
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
					2026,
					3,
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
				2,
				15008,
				50
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
		drop_item = {
			{
				2,
				81210,
				1
			}
		},
		first_icon = {
			{
				2,
				86210,
				1
			},
			{
				1,
				14,
				2025
			}
		}
	}
	pg.base.pay_data_display[9013] = {
		limit_group = 0,
		name = "Spring Lucky Box 2026 B",
		descrip_extra = "*The contents of the Lucky Box will be sent to your in-game inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 9013,
		subject = "Spring Lucky Box 2026 B",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1 random skin, 2026 Gems, and supplies.",
		name_display = "Spring Lucky Box 2026 B",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai33",
		extra_service = 3,
		skin_inquire_relation = 86225,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag81",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag81",
		extra_service_item = {
			{
				2,
				86225,
				1
			},
			{
				1,
				14,
				2026
			},
			{
				2,
				42076,
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
					2026,
					2,
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
					2026,
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
				42076,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81233,
				1
			}
		},
		first_icon = {
			{
				2,
				86225,
				1
			},
			{
				1,
				14,
				2026
			}
		}
	}
	pg.base.pay_data_display[9014] = {
		limit_group = 0,
		name = "Spring Lucky Box 2025 B Rerun",
		descrip_extra = "*The contents of the Lucky Box will be sent to your in-game inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 9014,
		subject = "Spring Lucky Box 2025 B Rerun",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a skin, Gems x2025, and more.",
		name_display = "Spring Lucky Box 2025 B Rerun",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai22",
		extra_service = 3,
		skin_inquire_relation = 86211,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag82",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag82",
		extra_service_item = {
			{
				2,
				86211,
				1
			},
			{
				1,
				14,
				2025
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
					2026,
					2,
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
					2026,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81211,
				1
			}
		},
		first_icon = {
			{
				2,
				86211,
				1
			},
			{
				1,
				14,
				2025
			}
		}
	}
	pg.base.pay_data_display[9015] = {
		limit_group = 0,
		name = "Party Dress Return Lucky Box",
		descrip_extra = "* The Lucky Box will be sent to your in-game Mail.\n* If you already own all the listed skins, you will receive Gems x680 instead.",
		type = 1,
		second_text = "Many Rewards",
		id = 9015,
		subject = "Party Dress Return Lucky Box",
		first_text = "Random Skin",
		package_sort_id = 0,
		tip = "",
		money = 699,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1 of the following skins you do not yet own, chosen at random (if you already own all the listed skins, you will receive Gems instead), as well as other items.",
		name_display = "Party Dress Return Lucky Box",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai34",
		extra_service = 3,
		skin_inquire_relation = 86226,
		limit_arg = 2,
		id_str = "com.yostaren.azurlane.luckybag84",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag84",
		extra_service_item = {
			{
				2,
				86226,
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
					2026,
					3,
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
					2026,
					4,
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
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81234,
				1
			}
		},
		first_icon = {
			{
				2,
				86226,
				1
			}
		}
	}
	pg.base.pay_data_display[9016] = {
		limit_group = 0,
		name = "Swimsuit Lucky Bag 2026 A",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your in-game inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 9016,
		subject = "Swimsuit Lucky Bag 2026 A",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1 random skin, 2026 Gems, and supplies.",
		name_display = "Swimsuit Lucky Bag 2026 A",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai35",
		extra_service = 3,
		skin_inquire_relation = 86227,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag85",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag85",
		extra_service_item = {
			{
				2,
				86227,
				1
			},
			{
				1,
				14,
				2026
			},
			{
				2,
				42076,
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
					2026,
					5,
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
					2026,
					6,
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
				42076,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81235,
				1
			}
		},
		first_icon = {
			{
				2,
				86227,
				1
			},
			{
				1,
				14,
				2026
			}
		}
	}
	pg.base.pay_data_display[9017] = {
		limit_group = 0,
		name = "Swimsuit Lucky Bag 2025 A Rerun",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your in-game inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 9017,
		subject = "Swimsuit Lucky Bag 2025 A Rerun",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random Swimsuit Lucky Bag 2025 A skin, 2025 Gems, and a large amount of supplies.",
		name_display = "Swimsuit Lucky Bag 2025 A Rerun",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai24",
		extra_service = 3,
		skin_inquire_relation = 86213,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag86",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag86",
		extra_service_item = {
			{
				2,
				86213,
				1
			},
			{
				1,
				14,
				2025
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
					2026,
					5,
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
					2026,
					6,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81213,
				1
			}
		},
		first_icon = {
			{
				2,
				86213,
				1
			},
			{
				1,
				14,
				2025
			}
		}
	}
	pg.base.pay_data_display[9018] = {
		limit_group = 0,
		name = "Swimsuit Lucky Bag 2026 B",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your in-game inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 9018,
		subject = "Swimsuit Lucky Bag 2026 B",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1 random skin, 2026 Gems, and supplies.",
		name_display = "Swimsuit Lucky Bag 2026 B",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai36",
		extra_service = 3,
		skin_inquire_relation = 86228,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag87",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag87",
		extra_service_item = {
			{
				2,
				86228,
				1
			},
			{
				1,
				14,
				2026
			},
			{
				2,
				42076,
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
					2026,
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
					2026,
					6,
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
				42076,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81236,
				1
			}
		},
		first_icon = {
			{
				2,
				86228,
				1
			},
			{
				1,
				14,
				2026
			}
		}
	}
	pg.base.pay_data_display[9019] = {
		limit_group = 0,
		name = "Swimsuit Lucky Bag 2025 B Rerun",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your in-game inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 9019,
		subject = "Swimsuit Lucky Bag 2025 B Rerun",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random Swimsuit Lucky Bag 2025 A skin, 2025 Gems, and a large amount of supplies.",
		name_display = "Swimsuit Lucky Bag 2025 B Rerun",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai25",
		extra_service = 3,
		skin_inquire_relation = 86214,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag88",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag88",
		extra_service_item = {
			{
				2,
				86214,
				1
			},
			{
				1,
				14,
				2025
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
					2026,
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
					2026,
					6,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81214,
				1
			}
		},
		first_icon = {
			{
				2,
				86214,
				1
			},
			{
				1,
				14,
				2025
			}
		}
	}
	pg.base.pay_data_display[9021] = {
		limit_group = 0,
		name = "Eerie Talismans Lucky Bag A",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your in-game inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 9021,
		subject = "Eerie Talismans Lucky Bag A",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1 random skin, 2026 Gems, and supplies.",
		name_display = "Eerie Talismans Lucky Bag A",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai38",
		extra_service = 3,
		skin_inquire_relation = 86230,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag93",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag93",
		extra_service_item = {
			{
				2,
				86230,
				1
			},
			{
				1,
				14,
				2026
			},
			{
				2,
				42086,
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
					2026,
					9,
					8
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2026,
					9,
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
				42086,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81238,
				1
			}
		},
		first_icon = {
			{
				2,
				86230,
				1
			},
			{
				1,
				14,
				2026
			}
		}
	}
	pg.base.pay_data_display[9022] = {
		limit_group = 0,
		name = "Ninja Castle Lucky Box A Rerun",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your in-game inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 9022,
		subject = "Ninja Castle Lucky Box A Rerun",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1 random skin, 2025 Gems, and supplies.",
		name_display = "Ninja Castle Lucky Box A Rerun",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai27",
		extra_service = 3,
		skin_inquire_relation = 86217,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag94",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag94",
		extra_service_item = {
			{
				2,
				86217,
				1
			},
			{
				1,
				14,
				2025
			},
			{
				2,
				42076,
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
					2026,
					9,
					8
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2026,
					9,
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
				42076,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81217,
				1
			}
		},
		first_icon = {
			{
				2,
				86217,
				1
			},
			{
				1,
				14,
				2025
			}
		}
	}
	pg.base.pay_data_display[100] = {
		limit_group = 0,
		name = "Nep's Lucky Bag ",
		descrip_extra = "*Nep's Lucky Bag will appear in your mailbox. \n* If you draw an already owned ship skin, you will be refunded 80% of the gem cost.",
		type = 1,
		second_text = "",
		id = 100,
		subject = "Nep's Lucky Bag",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 1 x Nep Ship skin, 3 x Nep Gear skins, and other rewards.",
		limit_type = 2,
		name_display = "Nep's Lucky Bag ",
		type_order = 0,
		package_tag = "",
		picture = "usfudai1",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond110",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[101] = {
		limit_group = 0,
		name = "Black Friday Lucky Bag ",
		descrip_extra = "*Black Friday Lucky Bag will appear in your mailbox. \n* If you draw an already owned ship skin, you will be refunded 100% of the gem cost.",
		type = 1,
		second_text = "",
		id = 101,
		subject = "Black Friday Lucky Bag",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 1 x School Girl Ship skin, 3 x School Gear skins, and other rewards.",
		limit_type = 2,
		name_display = "Black Friday Lucky Bag ",
		type_order = 0,
		package_tag = "",
		picture = "usfudai2",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond111",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[102] = {
		limit_group = 0,
		name = "Christmas Lucky Bag ",
		descrip_extra = "*Christmas Lucky Bag will appear in your mailbox. \n* If you drew a ship skin that you already have, you will be refunded 80% of the gem cost. ",
		type = 1,
		second_text = "",
		id = 102,
		subject = "Christmas Lucky Bag ",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 1 x Christmas Ship skin, 3 x Christmas Gear skins, and other rewards. ",
		limit_type = 2,
		name_display = "Christmas Lucky Bag ",
		type_order = 0,
		package_tag = "",
		picture = "fudai",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond112",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[103] = {
		limit_group = 0,
		name = "Heartthrob Pack",
		descrip_extra = "*The pack contains 1 x Promise Ring, 1 x Universal Bulin, 10 x Quick Finishers, and 5 x Full Courses",
		type = 1,
		second_text = "",
		id = 103,
		subject = "Heartthrob Pack",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 1 x Promise Ring, 1 x Universal Bulin, 10 x Quick Finishers, and 5 x Full Courses",
		limit_type = 2,
		name_display = "Heartthrob Pack",
		type_order = 0,
		package_tag = "",
		picture = "fudai49",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond113",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[104] = {
		limit_group = 0,
		name = "Santa's Lucky Sack (Daily)",
		descrip_extra = "*The sack contains 1 x Mystery T4 Tech Pack, 6 x Wisdom Cubes, 3 x Quick Finishers, 100 x Gems, and 3000 x Coins",
		type = 1,
		second_text = "",
		id = 104,
		subject = "Santa's Lucky Sack (Daily)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 499,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 1 x Mystery T4 Tech Pack, 6 x Wisdom Cubes, 3 x Quick Finishers, 100 x Gems, and 3000 x Coins",
		limit_type = 99,
		name_display = "Santa's Lucky Sack (Daily)",
		type_order = 0,
		package_tag = "",
		picture = "fudai50",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond114",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[105] = {
		limit_group = 0,
		name = "Shougatsu Lucky Bag (2019)",
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		second_text = "",
		id = 105,
		subject = "Shogatsu Lucky Bag ",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 1,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 1 x Kimono Ship skin, 2019 x Gems, and other rewards. ",
		limit_type = 2,
		name_display = "Shougatsu Lucky Bag (2019)",
		type_order = 0,
		package_tag = "",
		picture = "fudai51",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond115",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[106] = {
		limit_group = 0,
		name = "Lunar New Year Lucky Bag (2019)",
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you’ve received a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		second_text = "",
		id = 106,
		subject = "Lunar New Year Lucky Bag ",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 1,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 1 x Ship skin, 2019 x Gems, and other rewards. ",
		limit_type = 2,
		name_display = "Lunar New Year Lucky Bag (2019)",
		type_order = 0,
		package_tag = "",
		picture = "fudai52",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond116",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[107] = {
		limit_group = 0,
		name = "Glacier Blast ",
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		second_text = "",
		id = 107,
		subject = "Glacier Blast ",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 1,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 1 x random Ship skin (Winter‘s Crown), 3 x random Gear skins (Winter's Crown), and other rewards ",
		limit_type = 2,
		name_display = "Glacier Blast ",
		type_order = 0,
		package_tag = "",
		picture = "fudai53",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond117",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
end)()
;(function()
	pg.base.pay_data_display[108] = {
		limit_group = 0,
		name = "Hanami Lucky Bag ",
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems.",
		type = 1,
		second_text = "",
		id = 108,
		subject = "Hanami Lucky Bag ",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 1,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 1 x random Ship skin (Hanami), 100 x Cognitive Chips, and other rewards",
		limit_type = 2,
		name_display = "Hanami Lucky Bag ",
		type_order = 0,
		package_tag = "",
		picture = "fudai54",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond118",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[109] = {
		limit_group = 0,
		name = "Research Supply (daily) ",
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox.",
		type = 1,
		second_text = "",
		id = 109,
		subject = "Research Supply (daily) ",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 499,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 1 x Random Blueprint, 6 x Wisdom Cubes, 3 x Quick Finishers, 100 x Gems, and 3000 x Coins ",
		limit_type = 99,
		name_display = "Research Supply (daily) ",
		type_order = 0,
		package_tag = "",
		picture = "fudai55",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond119",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[110] = {
		limit_group = 0,
		name = "Scherzo Lucky Box ",
		descrip_extra = "*After your purchase, the Lucky Box will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		second_text = "",
		id = 110,
		subject = "Scherzo Lucky Box ",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 1,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 1 x random Ship skin, 2019 x Gems, and other rewards ",
		limit_type = 2,
		name_display = "Scherzo Lucky Box ",
		type_order = 0,
		package_tag = "",
		picture = "lihe1_l",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond120",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[111] = {
		limit_group = 0,
		name = "1st Anniversary Lucky Bag ",
		descrip_extra = "*After your purchase, the Lucky Box will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's on sale value in Gems. ",
		type = 1,
		second_text = "",
		id = 111,
		subject = "1st Anniversary Lucky Bag ",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 1 x random Ship skin, 2019 x Gems, and other rewards ",
		limit_type = 2,
		name_display = "1st Anniversary Lucky Bag ",
		type_order = 0,
		package_tag = "",
		picture = "fudai56",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond121",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[112] = {
		limit_group = 0,
		name = "Yukata Lucky Bag",
		descrip_extra = "*After your purchase, the Lucky Box will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		second_text = "",
		id = 112,
		subject = "Yukata Lucky Bag",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 1 x random Ship skin, 2019 x Gems, and other rewards ",
		limit_type = 2,
		name_display = "Yukata Lucky Bag",
		type_order = 0,
		package_tag = "",
		picture = "fudai57",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond122",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[113] = {
		limit_group = 0,
		name = "Full Dress Lucky Bag ",
		descrip_extra = "*After your purchase, the Lucky Box will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		second_text = "",
		id = 113,
		subject = "Full Dress Lucky Bag ",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 1 x random Ship skin, 2019 x Gems, and other rewards ",
		limit_type = 2,
		name_display = "Full Dress Lucky Bag ",
		type_order = 0,
		package_tag = "",
		picture = "fudai58",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond123",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[114] = {
		limit_group = 0,
		name = "Black Friday Lucky Box ",
		descrip_extra = "*After your purchase, the Lucky Box will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		second_text = "",
		id = 114,
		subject = "Black Friday Lucky Box ",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 1 x random Ship skin, 2450 x Gems, and other rewards ",
		limit_type = 2,
		name_display = "Black Friday Lucky Box ",
		type_order = 0,
		package_tag = "",
		picture = "fudai59",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond124",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[115] = {
		limit_group = 0,
		name = "Christmas Lucky Bag ",
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		second_text = "",
		id = 115,
		subject = "Christmas Lucky Bag ",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 1 x random Ship skin, 2019 x Gems, and other rewards ",
		limit_type = 2,
		name_display = "Christmas Lucky Bag ",
		type_order = 0,
		package_tag = "",
		picture = "fudai60",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond125",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[116] = {
		limit_group = 0,
		name = "Shougatsu Lucky Bag (2020)",
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		second_text = "",
		id = 116,
		subject = "Shougatsu Lucky Bag (2020)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 1 x random Ship skin, 2020 x Gems, and other rewards. ",
		limit_type = 2,
		name_display = "Shougatsu Lucky Bag (2020)",
		type_order = 0,
		package_tag = "",
		picture = "fudai1",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond126",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[117] = {
		limit_group = 0,
		name = "Shougatsu Lucky Bag (2019)",
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		second_text = "",
		id = 117,
		subject = "Shougatsu Lucky Bag (2019)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 1,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 1 x random Ship skin, 2019 x Gems, and other rewards. ",
		limit_type = 2,
		name_display = "Shougatsu Lucky Bag (2019)",
		type_order = 0,
		package_tag = "",
		picture = "fudai",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond127",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[118] = {
		limit_group = 0,
		name = "Lunar New Year Lucky Bag (2020)",
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		second_text = "",
		id = 118,
		subject = "Lunar New Year Lucky Bag (2020)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 1 x random Ship skin, 2020 x Gems, and other rewards. ",
		limit_type = 2,
		name_display = "Lunar New Year Lucky Bag (2020)",
		type_order = 0,
		package_tag = "",
		picture = "fudai2",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond128",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[119] = {
		limit_group = 0,
		name = "Lunar New Year Lucky Bag (2019)",
		descrip_extra = "*After your purchase, the Lucky Bag will be sent to your mailbox. \n*If you receive a ship skin that you already own, you will instead be given the corresponding skin's value in Gems. ",
		type = 1,
		second_text = "",
		id = 119,
		subject = "Lunar New Year Lucky Bag (2019)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 1,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 1 x random Ship skin, 2019 x Gems, and other rewards. ",
		limit_type = 2,
		name_display = "Lunar New Year Lucky Bag (2019)",
		type_order = 0,
		package_tag = "",
		picture = "fudai",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond129",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[120] = {
		limit_group = 0,
		name = "New Commanders Support Pack I",
		descrip_extra = "The pack includes lots of material rewards. The Startup Pack will be sent to you via in-game mail, please check your mailbox to claim the pack. ",
		type = 1,
		second_text = "",
		type_order = 0,
		subject = "New Commanders Support Pack I",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 299,
		cash_show = 0,
		descrip = "Contains 180 Gems, 2x Oil Reserve Supply (1000) Packs, and more!",
		name_display = "New Commanders Support Pack I",
		gem = 0,
		limit_arg = 1,
		limit_type = 2,
		package_tag = "",
		picture = "support1",
		id_str = "com.yostaren.azurlane.diamond130",
		extra_gem = 0,
		id = 120,
		airijp_id = "com.yostaren.azurlane.diamond130",
		first_icon = "",
		first_text = "",
		tag = 1,
		akashi_pick = 0,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[121] = {
		limit_group = 0,
		name = "New Commanders Support Pack II",
		descrip_extra = "The pack includes lots of material rewards. The Startup Pack will be sent to you via in-game mail, please check your mailbox to claim the pack. ",
		type = 1,
		second_text = "",
		type_order = 0,
		subject = "New Commanders Support Pack II",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 1199,
		cash_show = 0,
		descrip = "Contains 780 Gems, 2x T4 Gear Development Packs, 4x Oil Reserve Supply (1000) Packs, and more!",
		name_display = "New Commanders Support Pack II",
		gem = 0,
		limit_arg = 1,
		limit_type = 2,
		package_tag = "",
		picture = "support2",
		id_str = "com.yostaren.azurlane.diamond131",
		extra_gem = 0,
		id = 121,
		airijp_id = "com.yostaren.azurlane.diamond131",
		first_icon = "",
		first_text = "",
		tag = 1,
		akashi_pick = 0,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[122] = {
		limit_group = 0,
		name = "New Commanders Support Pack III",
		descrip_extra = "The pack includes lots of material rewards. The Startup Pack will be sent to you via in-game mail, please check your mailbox to claim the pack. ",
		type = 1,
		second_text = "",
		type_order = 0,
		subject = "New Commanders Support Pack III",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 2599,
		cash_show = 0,
		descrip = "Contains 1680 Gems, 4x T4 Gear Development Packs, 8x Oil Reserve Supply (1000) Packs, and more!",
		name_display = "New Commanders Support Pack III",
		gem = 0,
		limit_arg = 1,
		limit_type = 2,
		package_tag = "",
		picture = "support3",
		id_str = "com.yostaren.azurlane.diamond132",
		extra_gem = 0,
		id = 122,
		airijp_id = "com.yostaren.azurlane.diamond132",
		first_icon = "",
		first_text = "",
		tag = 1,
		akashi_pick = 0,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[123] = {
		limit_group = 0,
		name = "Crimson Echoes' Lucky Bag",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 123,
		subject = "Crimson Echoes' Lucky Bag",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 1,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 1 x random Ship skin, 2020 x Gems, and other rewards. ",
		limit_type = 2,
		name_display = "Crimson Echoes' Lucky Bag",
		type_order = 0,
		package_tag = "",
		picture = "fudai61",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond133",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[124] = {
		limit_group = 0,
		name = "Night Out Lucky Bag ",
		descrip_extra = "The pack includes lots of material rewards. The Startup Pack will be sent to you via in-game mail, please check your mailbox to claim the pack. ",
		type = 1,
		second_text = "",
		id = 124,
		subject = "Night Out Lucky Bag ",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 1,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 1 x random Ship skin, 2020 x Gems, and other rewards. ",
		limit_type = 2,
		name_display = "Night Out Lucky Bag ",
		type_order = 0,
		package_tag = "",
		picture = "lihe1_l",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond134",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[125] = {
		limit_group = 0,
		name = "Skybound Oratorio Lucky Bag",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 125,
		subject = "Skybound Oratorio Lucky Bag ",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		limit_type = 2,
		name_display = "Skybound Oratorio Lucky Bag",
		type_order = 0,
		package_tag = "",
		picture = "fudai63",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond135",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[126] = {
		limit_group = 0,
		name = "Aurora Noctis Lucky Bag ",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 126,
		subject = "Aurora Noctis Lucky Bag ",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		limit_type = 2,
		name_display = "Aurora Noctis Lucky Bag ",
		type_order = 0,
		package_tag = "",
		picture = "fudai64",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond136",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[127] = {
		limit_group = 0,
		name = "Summer Scherzo Lucky Bag ",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 127,
		subject = "Summer Scherzo Lucky Bag ",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		limit_type = 2,
		name_display = "Summer Scherzo Lucky Bag ",
		type_order = 0,
		package_tag = "",
		picture = "fudai65",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond137",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[128] = {
		limit_group = 0,
		name = "Shining Star Lucky Bag ",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 128,
		subject = "Shining Star Lucky Bag ",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		limit_type = 2,
		name_display = "Shining Star Lucky Bag ",
		type_order = 0,
		package_tag = "",
		picture = "fudai66",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond139",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[129] = {
		limit_group = 0,
		name = "Azur Black Friday Lucky Box ",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 129,
		subject = "Azur Black Friday Lucky Box ",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		limit_type = 2,
		name_display = "Azur Black Friday Lucky Box ",
		type_order = 0,
		package_tag = "",
		picture = "fudai67",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond140",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[130] = {
		limit_group = 0,
		name = "Crimson Black Friday Lucky Box ",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 130,
		subject = "Crimson Black Friday Lucky Box ",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		limit_type = 2,
		name_display = "Crimson Black Friday Lucky Box ",
		type_order = 0,
		package_tag = "",
		picture = "fudai68",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond141",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[131] = {
		limit_group = 0,
		name = "Dawn's Rime Lucky Pack",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 131,
		subject = "Dawn's Rime Lucky Pack",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		limit_type = 2,
		name_display = "Dawn's Rime Lucky Pack",
		type_order = 0,
		package_tag = "",
		picture = "fudai69",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond144",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[132] = {
		limit_group = 0,
		name = "Daedalian Hymn's Lucky Bag",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 132,
		subject = "Daedalian Hymn's Lucky Bag",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		limit_type = 2,
		name_display = "Daedalian Hymn's Lucky Bag",
		type_order = 0,
		package_tag = "",
		picture = "fudai70",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond145",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[133] = {
		limit_group = 0,
		name = "Microlayer Medley Lucky Box 2021",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 133,
		subject = "Microlayer Medley Lucky Box 2021",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		limit_type = 2,
		name_display = "Microlayer Medley Lucky Box 2021",
		type_order = 0,
		package_tag = "",
		picture = "fudai71",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond149",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[134] = {
		limit_group = 0,
		name = "Black Friday Lucky Music Box",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 134,
		subject = "Black Friday Lucky Music Box",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		limit_type = 2,
		name_display = "Black Friday Lucky Music Box",
		type_order = 0,
		package_tag = "",
		picture = "fudai72",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond152",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[135] = {
		limit_group = 0,
		name = "Abyssal Refrain Lucky Pack",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 135,
		subject = "Abyssal Refrain Lucky Pack",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		limit_type = 2,
		name_display = "Abyssal Refrain Lucky Pack",
		type_order = 0,
		package_tag = "",
		picture = "fudai73",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond157",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[136] = {
		limit_group = 0,
		name = "Crimson Offering Lucky Chalice",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 136,
		subject = "Crimson Offering Lucky Chalice",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		limit_type = 2,
		name_display = "Crimson Offering Lucky Chalice",
		type_order = 0,
		package_tag = "",
		picture = "fudai74",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond166",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[137] = {
		limit_group = 0,
		name = "Aquilifer's Ballade Lucky Box",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 137,
		subject = "Aquilifer's Ballade Lucky Box",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		limit_type = 2,
		name_display = "Aquilifer's Ballade Lucky Box",
		type_order = 0,
		package_tag = "",
		picture = "fudai75",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond169",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[138] = {
		limit_group = 0,
		name = "4th Anniversary Lucky Box",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 138,
		subject = "4th Anniversary Lucky Box",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		limit_type = 2,
		name_display = "4th Anniversary Lucky Box",
		type_order = 0,
		package_tag = "",
		picture = "fudai76",
		akashi_pick = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond171",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[139] = {
		limit_group = 0,
		name = "",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 139,
		subject = "Black Friday Lucky Bag (2022)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		limit_type = 2,
		name_display = "",
		type_order = 2,
		package_tag = "",
		picture = "fudai77",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond177",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
				40024,
				1
			}
		}
	}
	pg.base.pay_data_display[140] = {
		limit_group = 0,
		name = "New Semester Lucky Pack",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 140,
		subject = "New Semester Lucky Pack",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		limit_type = 2,
		name_display = "New Semester Lucky Pack",
		type_order = 2,
		package_tag = "",
		picture = "fudai78",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.luckybag8",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[141] = {
		limit_group = 0,
		name = "Onsen Souvenir Lucky Bag",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "",
		id = 141,
		subject = "Onsen Souvenir Lucky Bag",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		limit_type = 2,
		name_display = "Onsen Souvenir Lucky Bag",
		type_order = 2,
		package_tag = "",
		picture = "fudai79",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.luckybag9",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[142] = {
		limit_group = 0,
		name = "Office Hour Lucky Box",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "Many Rewards",
		id = 142,
		subject = "Office Hour Lucky Box",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		name_display = "Office Hour Lucky Box",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai80",
		extra_service = 3,
		skin_inquire_relation = 69980,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag13",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				69980,
				1
			},
			{
				1,
				4,
				2023
			}
		}
	}
	pg.base.pay_data_display[143] = {
		limit_group = 0,
		name = "5th Anniversary Lucky Box",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "Many Rewards",
		id = 143,
		subject = "5th Anniversary Lucky Box",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		name_display = "5th Anniversary Lucky Box",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai81",
		extra_service = 3,
		skin_inquire_relation = 69981,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag14",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				69981,
				1
			},
			{
				1,
				4,
				2023
			}
		}
	}
	pg.base.pay_data_display[144] = {
		limit_group = 0,
		name = "Halloween Lucky Box 2023",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "Many Rewards",
		id = 144,
		subject = "Halloween Lucky Box 2023",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		name_display = "Halloween Lucky Box 2023",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai82",
		extra_service = 3,
		skin_inquire_relation = 69982,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag18",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				69982,
				1
			},
			{
				1,
				4,
				2023
			}
		}
	}
	pg.base.pay_data_display[145] = {
		limit_group = 0,
		name = "Black Friday Lucky Bag (2023)",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 2,
		second_text = "Many Rewards",
		id = 145,
		subject = "Black Friday Lucky Bag (2023)",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		name_display = "Black Friday Lucky Bag (2023)",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai82",
		extra_service = 3,
		skin_inquire_relation = 69983,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag19",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				69983,
				1
			},
			{
				1,
				4,
				2023
			}
		}
	}
	pg.base.pay_data_display[146] = {
		limit_group = 0,
		name = "Cyber City Lucky Box",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "Many Rewards",
		id = 146,
		subject = "Cyber City Lucky Box",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit, 2024 Gems, and a large amount of supplies.",
		name_display = "Cyber City Lucky Box",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai84",
		extra_service = 3,
		skin_inquire_relation = 86400,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag28",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				86400,
				1
			},
			{
				1,
				4,
				2024
			}
		}
	}
	pg.base.pay_data_display[147] = {
		limit_group = 0,
		name = "Adventurer's Lucky Chest",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "Many Rewards",
		id = 147,
		subject = "Adventurer's Lucky Chest",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		name_display = "Adventurer's Lucky Chest",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai85",
		extra_service = 3,
		skin_inquire_relation = 86401,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag29",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				86401,
				1
			},
			{
				1,
				14,
				2024
			}
		}
	}
	pg.base.pay_data_display[148] = {
		limit_group = 0,
		name = "Lavish Lucky Boombox",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "Many Rewards",
		id = 148,
		subject = "Lavish Lucky Boombox",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		name_display = "Lavish Lucky Boombox",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai86",
		extra_service = 3,
		skin_inquire_relation = 86402,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag30",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				86402,
				1
			},
			{
				1,
				14,
				2024
			}
		}
	}
	pg.base.pay_data_display[149] = {
		limit_group = 0,
		name = "School Time Lucky Bag",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "Many Rewards",
		id = 149,
		subject = "School Time Lucky Bag",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		name_display = "School Time Lucky Bag",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai87",
		extra_service = 3,
		skin_inquire_relation = 86403,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag35",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				86403,
				1
			},
			{
				1,
				14,
				2024
			}
		}
	}
	pg.base.pay_data_display[150] = {
		limit_group = 0,
		name = "High Speed Lucky Bag",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "Many Rewards",
		id = 150,
		subject = "High Speed Lucky Bag",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		name_display = "High Speed Lucky Bag",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai88",
		extra_service = 3,
		skin_inquire_relation = 86404,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag36",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				86404,
				1
			},
			{
				1,
				14,
				2024
			}
		}
	}
	pg.base.pay_data_display[151] = {
		limit_group = 0,
		name = "6th Anniversary Lucky Barrel",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "Many Rewards",
		id = 151,
		subject = "6th Anniversary Lucky Barrel",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		name_display = "6th Anniversary Lucky Barrel",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai89",
		extra_service = 3,
		skin_inquire_relation = 86405,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag37",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				86405,
				1
			},
			{
				1,
				14,
				2024
			}
		}
	}
	pg.base.pay_data_display[152] = {
		limit_group = 0,
		name = "Halloween Lucky Box 2024",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "Many Rewards",
		id = 152,
		subject = "Halloween Lucky Box 2024",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		name_display = "Halloween Lucky Box 2024",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai90",
		extra_service = 3,
		skin_inquire_relation = 86406,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag42",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				86406,
				1
			},
			{
				1,
				14,
				2024
			}
		}
	}
	pg.base.pay_data_display[153] = {
		limit_group = 0,
		name = "Live2D Surprise Lucky Bag (2024)",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "Many Rewards",
		id = 153,
		subject = "Black Friday Lucky Bag (2024)",
		first_text = "Random Skin",
		package_sort_id = 0,
		tip = "",
		money = 999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random unowned rerun L2D outfit and other supplies",
		name_display = "Live2D Surprise Lucky Bag (2024)",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai_L2d_new",
		extra_service = 3,
		skin_inquire_relation = 86407,
		limit_arg = 2,
		id_str = "com.yostaren.azurlane.luckybag44",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81417,
				1
			}
		},
		first_icon = {
			{
				2,
				86407,
				1
			}
		}
	}
	pg.base.pay_data_display[154] = {
		limit_group = 0,
		name = "Black Friday Lucky Bag (2024)",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "Many Rewards",
		id = 154,
		subject = "Black Friday Lucky Bag (2024)",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		name_display = "Black Friday Lucky Bag (2024)",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai92",
		extra_service = 3,
		skin_inquire_relation = 86408,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag43",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				86408,
				1
			},
			{
				1,
				14,
				2024
			}
		}
	}
	pg.base.pay_data_display[155] = {
		limit_group = 0,
		name = "Nile Colors Lucky Box",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "Many Rewards",
		id = 155,
		subject = "Nile Colors Lucky Box",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		name_display = "Nile Colors Lucky Box",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai93",
		extra_service = 3,
		skin_inquire_relation = 86413,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag53",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag53",
		extra_service_item = {
			{
				2,
				86413,
				1
			},
			{
				1,
				14,
				2025
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
					2025,
					2,
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
					2025,
					3,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81422,
				1
			}
		},
		first_icon = {
			{
				2,
				86413,
				1
			},
			{
				1,
				14,
				2025
			}
		}
	}
	pg.base.pay_data_display[156] = {
		limit_group = 0,
		name = "Hospital Adventure Lucky Bag",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "Many Rewards",
		id = 156,
		subject = "Hospital Adventure Lucky Bag",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		name_display = "Hospital Adventure Lucky Bag",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai94",
		extra_service = 3,
		skin_inquire_relation = 86414,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag54",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag54",
		extra_service_item = {
			{
				2,
				86414,
				1
			},
			{
				1,
				14,
				2025
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
					2025,
					3,
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
					2025,
					4,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81423,
				1
			}
		},
		first_icon = {
			{
				2,
				86414,
				1
			},
			{
				1,
				14,
				2025
			}
		}
	}
	pg.base.pay_data_display[157] = {
		limit_group = 0,
		name = "Pajama Party Lucky Bag",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "Many Rewards",
		id = 157,
		subject = "Pajama Party Lucky Bag",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		name_display = "Pajama Party Lucky Bag",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai95",
		extra_service = 3,
		skin_inquire_relation = 86415,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag56",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag56",
		extra_service_item = {
			{
				2,
				86415,
				1
			},
			{
				1,
				14,
				2025
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
					2025,
					4,
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
					2025,
					5,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81424,
				1
			}
		},
		first_icon = {
			{
				2,
				86415,
				1
			},
			{
				1,
				14,
				2025
			}
		}
	}
	pg.base.pay_data_display[158] = {
		limit_group = 0,
		name = "Office Cabinet Lucky Box",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "Many Rewards",
		id = 158,
		subject = "Office Cabinet Lucky Box",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		name_display = "Office Cabinet Lucky Box",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai96",
		extra_service = 3,
		skin_inquire_relation = 86416,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag61",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag61",
		extra_service_item = {
			{
				2,
				86416,
				1
			},
			{
				1,
				14,
				2025
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
					2025,
					6,
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
					2025,
					7,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81426,
				1
			}
		},
		first_icon = {
			{
				2,
				86416,
				1
			},
			{
				1,
				14,
				2025
			}
		}
	}
	pg.base.pay_data_display[159] = {
		limit_group = 0,
		name = "7th Anniversary Lucky bag",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "Many Rewards",
		id = 159,
		subject = "7th Anniversary Lucky bag",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		name_display = "7th Anniversary Lucky bag",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai97",
		extra_service = 3,
		skin_inquire_relation = 86417,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag63",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag63",
		extra_service_item = {
			{
				2,
				86417,
				1
			},
			{
				1,
				14,
				2025
			},
			{
				2,
				42076,
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
					2025,
					8,
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
					2025,
					8,
					27
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
				2,
				15008,
				50
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
		drop_item = {
			{
				2,
				81427,
				1
			}
		},
		first_icon = {
			{
				2,
				86417,
				1
			},
			{
				1,
				14,
				2025
			}
		}
	}
	pg.base.pay_data_display[160] = {
		limit_group = 0,
		name = "Halloween Lucky Box 2025",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "Many Rewards",
		id = 160,
		subject = "Halloween Lucky Box 2025",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		name_display = "Halloween Lucky Box 2025",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai98",
		extra_service = 3,
		skin_inquire_relation = 86418,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag69",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag69",
		extra_service_item = {
			{
				2,
				86418,
				1
			},
			{
				1,
				14,
				2025
			},
			{
				2,
				42076,
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
					2025,
					10,
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
					2025,
					11,
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
				42076,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81428,
				1
			}
		},
		first_icon = {
			{
				2,
				86418,
				1
			},
			{
				1,
				14,
				2025
			}
		}
	}
	pg.base.pay_data_display[161] = {
		limit_group = 0,
		name = "Choose-Your-Own Gift Pack I 2025",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 161,
		subject = "Choose-Your-Own Gift Pack I",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1499,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 980x Gems, 1x Choose-Your-Own Gift Pack I, and loads of other valuable rewards.",
		limit_type = 2,
		name_display = "Choose-Your-Own Gift Pack I 2025",
		type_order = 3,
		package_tag = "",
		picture = "pack_2024_98",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.bfchoosebag6",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.bfchoosebag6",
		extra_service_item = {
			{
				2,
				81429,
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
					2025,
					11,
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
					2025,
					12,
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
				81429,
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
				81433,
				1
			}
		}
	}
	pg.base.pay_data_display[162] = {
		limit_group = 0,
		name = "Choose-Your-Own Gift Pack II 2025",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 162,
		subject = "Choose-Your-Own Gift Pack II",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 2999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 1980x Gems, 1x Choose-Your-Own Gift Pack II, and loads of other valuable rewards.",
		limit_type = 2,
		name_display = "Choose-Your-Own Gift Pack II 2025",
		type_order = 3,
		package_tag = "",
		picture = "pack_2024_198",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.bfchoosebag7",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.bfchoosebag7",
		extra_service_item = {
			{
				2,
				81430,
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
					2025,
					11,
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
					2025,
					12,
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
				81430,
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
				81434,
				1
			}
		}
	}
	pg.base.pay_data_display[163] = {
		limit_group = 0,
		name = "Choose-Your-Own Gift Pack III 2025",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 163,
		subject = "Choose-Your-Own Gift Pack III",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 4499,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 3280x Gems, 1x Choose-Your-Own Gift Pack III, and loads of other valuable rewards.",
		limit_type = 2,
		name_display = "Choose-Your-Own Gift Pack III 2025",
		type_order = 3,
		package_tag = "",
		picture = "pack_2024_328",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.bfchoosebag8",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.bfchoosebag8",
		extra_service_item = {
			{
				2,
				81431,
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
					2025,
					11,
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
					2025,
					12,
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
				81431,
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
				81435,
				1
			}
		}
	}
	pg.base.pay_data_display[164] = {
		limit_group = 0,
		name = "Black Friday Lucky Bag (2025)",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "Many Rewards",
		id = 164,
		subject = "Black Friday Lucky Bag (2025)",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		name_display = "Black Friday Lucky Bag (2025)",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai99",
		extra_service = 3,
		skin_inquire_relation = 86419,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag71",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag71",
		extra_service_item = {
			{
				2,
				86419,
				1
			},
			{
				1,
				14,
				2025
			},
			{
				2,
				42076,
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
					2025,
					11,
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
					2025,
					12,
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
				42076,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81436,
				1
			}
		},
		first_icon = {
			{
				2,
				86419,
				1
			},
			{
				1,
				14,
				2025
			}
		}
	}
	pg.base.pay_data_display[165] = {
		limit_group = 0,
		name = "Live2D Surprise Lucky Bag (2025)",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "Many Rewards",
		id = 165,
		subject = "Live2D Surprise Lucky Bag (2025)",
		first_text = "Random Skin",
		package_sort_id = 0,
		tip = "",
		money = 999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random unowned rerun L2D outfit and other supplies",
		name_display = "Live2D Surprise Lucky Bag (2025)",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai_L2d_new",
		extra_service = 3,
		skin_inquire_relation = 86420,
		limit_arg = 2,
		id_str = "com.yostaren.azurlane.luckybag72",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag72",
		extra_service_item = {
			{
				2,
				86420,
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
					2025,
					11,
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
					2025,
					12,
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
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81437,
				1
			}
		},
		first_icon = {
			{
				2,
				86420,
				1
			}
		}
	}
	pg.base.pay_data_display[166] = {
		limit_group = 0,
		name = "Photoshoot Lucky Bag",
		descrip_extra = "*The contents of the Lucky Bag will be sent to your in-game inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit.",
		type = 1,
		second_text = "Many Rewards",
		id = 166,
		subject = "Photoshoot Lucky Bag",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains 1 random skin, 2026 Gems, and supplies.",
		name_display = "Photoshoot Lucky Bag",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai100",
		extra_service = 3,
		skin_inquire_relation = 86421,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag15v2",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag15v2",
		extra_service_item = {
			{
				2,
				86421,
				1
			},
			{
				1,
				14,
				2026
			},
			{
				2,
				42076,
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
				1,
				6,
				100
			},
			{
				2,
				15003,
				10
			}
		},
		time = {
			{
				{
					2026,
					1,
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
					2026,
					2,
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
				42076,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81438,
				1
			}
		},
		first_icon = {
			{
				2,
				86421,
				1
			},
			{
				1,
				14,
				2026
			}
		}
	}
	pg.base.pay_data_display[167] = {
		limit_group = 0,
		name = "Night City Lucky Box",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "Many Rewards",
		id = 167,
		subject = "Night City Lucky Box",
		first_text = "Random Skin",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		name_display = "Night City Lucky Box",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai101",
		sub_display = "",
		skin_inquire_relation = 86422,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.luckybag83",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag83",
		extra_service_item = {
			{
				2,
				86422,
				1
			},
			{
				1,
				14,
				2026
			},
			{
				2,
				42076,
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
					2026,
					3,
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
					2026,
					4,
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
				86422,
				1
			},
			{
				1,
				14,
				2026
			},
			{
				2,
				42076,
				2
			}
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81441,
				1
			}
		},
		first_icon = {
			{
				2,
				86422,
				1
			},
			{
				1,
				14,
				2026
			}
		}
	}
	pg.base.pay_data_display[168] = {
		limit_group = 0,
		name = "Sparkling Dreams Lucky Box",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "Many Rewards",
		id = 168,
		subject = "Sparkling Dreams Lucky Box",
		first_text = "Random Skin",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		name_display = "Sparkling Dreams Lucky Box",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai102",
		extra_service = 3,
		skin_inquire_relation = 86423,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag89",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag89",
		extra_service_item = {
			{
				2,
				86423,
				1
			},
			{
				1,
				14,
				2026
			},
			{
				2,
				42076,
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
					2026,
					6,
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
					2026,
					7,
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
				86423,
				1
			},
			{
				1,
				14,
				2026
			},
			{
				2,
				42076,
				2
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81442,
				1
			}
		},
		first_icon = {
			{
				2,
				86423,
				1
			},
			{
				1,
				14,
				2026
			}
		}
	}
	pg.base.pay_data_display[169] = {
		limit_group = 0,
		name = "Loving Care Lucky Box",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "Many Rewards",
		id = 169,
		subject = "Loving Care Lucky Box",
		first_text = "Random Skin & Abundant Gems",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		name_display = "Loving Care Lucky Box",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai103",
		extra_service = 3,
		skin_inquire_relation = 86424,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag90",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag90",
		extra_service_item = {
			{
				2,
				86424,
				1
			},
			{
				1,
				14,
				2026
			},
			{
				2,
				42086,
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
					2026,
					7,
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
					2026,
					8,
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
				42086,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81443,
				1
			}
		},
		first_icon = {
			{
				2,
				86424,
				1
			},
			{
				1,
				14,
				2026
			}
		}
	}
	pg.base.pay_data_display[170] = {
		limit_group = 0,
		name = "8th Anniversary Lucky Bag",
		descrip_extra = "*The contents of the Lucky Box will be sent to your ingame inbox. Please remember to check it. \n*It is possible to obtain an outfit you already own. In such cases, you will instead receive Gems equivalent to the value of that outfit. ",
		type = 1,
		second_text = "Many Rewards",
		id = 170,
		subject = "8th Anniversary Lucky Bag",
		first_text = "Random Skin",
		package_sort_id = 0,
		tip = "",
		money = 2999,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains a random character outfit and a large amount of supplies ",
		name_display = "8th Anniversary Lucky Bag",
		limit_type = 2,
		type_order = 2,
		akashi_pick = 1,
		package_tag = "",
		picture = "fudai104",
		extra_service = 3,
		skin_inquire_relation = 86425,
		limit_arg = 1,
		id_str = "com.yostaren.azurlane.luckybag91",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.luckybag91",
		extra_service_item = {
			{
				2,
				86425,
				1
			},
			{
				1,
				14,
				2026
			},
			{
				2,
				42086,
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
					2026,
					8,
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
					2026,
					8,
					26
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
				42086,
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
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				81444,
				1
			}
		},
		first_icon = {
			{
				2,
				86425,
				1
			},
			{
				1,
				14,
				2026
			}
		}
	}
	pg.base.pay_data_display[1000] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass",
		descrip_extra = "You must complete certain missions to obtain these rewards. ",
		type = 0,
		second_text = "",
		id = 1000,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to unlock additional Fair Winds Cruise rewards, including an exclusive outfit for Yorktown and more! ",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 0,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport2",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[1001] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass",
		descrip_extra = "You must complete certain missions to obtain these rewards. ",
		type = 0,
		second_text = "",
		id = 1001,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards. ",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 0,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport3",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[1002] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass",
		descrip_extra = "You must complete certain missions to obtain these rewards. ",
		type = 0,
		second_text = "",
		id = 1002,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards. ",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 0,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport4",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[1003] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass",
		descrip_extra = "You must complete certain missions to obtain these rewards. ",
		type = 0,
		second_text = "",
		id = 1003,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards. ",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 0,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport5",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[1004] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass",
		descrip_extra = "You must complete certain missions to obtain these rewards. ",
		type = 0,
		second_text = "",
		id = 1004,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards. ",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 0,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport6",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[1005] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass",
		descrip_extra = "You must complete certain missions to obtain these rewards. ",
		type = 0,
		second_text = "",
		id = 1005,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards. ",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 4,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport7",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[1006] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "",
		id = 1006,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 4,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport8",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[1007] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "",
		id = 1007,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 4,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport10",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[1008] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "",
		id = 1008,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 4,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport11",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[1009] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "",
		id = 1009,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 4,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport12",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[1010] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass (2023.6)",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "",
		id = 1010,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 4,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport13",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[1011] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass (2023.8)",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "",
		id = 1011,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 4,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport14",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[1012] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass (2023.10)",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "",
		id = 1012,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 4,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport15",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[1013] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass (2023.12)",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "",
		id = 1013,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 4,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport16",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[1014] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass (2024.2)",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "",
		id = 1014,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 4,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport17",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[1015] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass (2024.4)",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "",
		id = 1015,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 4,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport18",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[1016] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass (2024.6)",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "",
		id = 1016,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 4,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport19",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[1017] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass (2024.8)",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "",
		id = 1017,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 4,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport20",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[1018] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass (2024.10)",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "",
		id = 1018,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 4,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport21",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[1019] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass (2024.12)",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "",
		id = 1019,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 6,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport22",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.passport22",
		extra_service_item = {
			{
				1,
				4020,
				1500
			},
			{
				8,
				65057,
				1
			}
		},
		time = {
			{
				{
					2024,
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
					2025,
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
				8,
				59599,
				1500
			}
		},
		sub_display = {
			7020,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[1020] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass (2025.2)",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "",
		id = 1020,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 6,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport23",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.passport23",
		extra_service_item = {
			{
				1,
				4021,
				1500
			},
			{
				8,
				65074,
				1
			}
		},
		time = {
			{
				{
					2025,
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
					2025,
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
				8,
				59599,
				1500
			}
		},
		sub_display = {
			7021,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[1021] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass 2025.4",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "",
		id = 1021,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 6,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport24",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.passport24",
		extra_service_item = {
			{
				1,
				4022,
				1500
			},
			{
				8,
				65086,
				1
			}
		},
		time = {
			{
				{
					2025,
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
					2025,
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
				8,
				59599,
				1500
			}
		},
		sub_display = {
			7022,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[1022] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass (2025.6)",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "",
		id = 1022,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 6,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport25",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.passport25",
		extra_service_item = {
			{
				1,
				4023,
				1500
			},
			{
				8,
				65100,
				1
			}
		},
		time = {
			{
				{
					2025,
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
					2025,
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
				8,
				59599,
				1500
			}
		},
		sub_display = {
			7023,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[1023] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass (2025.8)",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "Unlock Special Rewards",
		id = 1023,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 6,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport26",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.passport26",
		extra_service_item = {
			{
				1,
				4024,
				1500
			},
			{
				8,
				65101,
				1
			}
		},
		time = {
			{
				{
					2025,
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
					2025,
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
				8,
				59599,
				1500
			}
		},
		sub_display = {
			7024,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[1024] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass (2025.10)",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "Unlock Special Rewards",
		id = 1024,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 6,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport27",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.passport27",
		extra_service_item = {
			{
				1,
				4025,
				1500
			},
			{
				8,
				65106,
				1
			}
		},
		time = {
			{
				{
					2025,
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
					2025,
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
				8,
				59599,
				1500
			}
		},
		sub_display = {
			7025,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[1025] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass (2025.12)",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "Unlock Special Rewards",
		id = 1025,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 6,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport29",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.passport29",
		extra_service_item = {
			{
				1,
				4026,
				1500
			},
			{
				8,
				65108,
				1
			}
		},
		time = {
			{
				{
					2025,
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
					2026,
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
				8,
				59599,
				1500
			}
		},
		sub_display = {
			7026,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[1026] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass (2026.2)",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "Unlock Special Rewards",
		id = 1026,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 6,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport30",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.passport30",
		extra_service_item = {
			{
				1,
				4027,
				1500
			},
			{
				8,
				65113,
				1
			}
		},
		time = {
			{
				{
					2026,
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
					2026,
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
				8,
				59599,
				1500
			}
		},
		sub_display = {
			7027,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[1027] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass (2026.4)",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "Unlock Special Rewards",
		id = 1027,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 6,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport31",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.passport31",
		extra_service_item = {
			{
				1,
				4028,
				1500
			},
			{
				8,
				65116,
				1
			}
		},
		time = {
			{
				{
					2026,
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
					2026,
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
				8,
				59599,
				1500
			}
		},
		sub_display = {
			7028,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[1028] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass (2026.6)",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "Unlock Special Rewards",
		id = 1028,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 6,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport32",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.passport32",
		extra_service_item = {
			{
				1,
				4029,
				1500
			},
			{
				8,
				65117,
				1
			}
		},
		time = {
			{
				{
					2026,
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
					2026,
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
				8,
				59599,
				1500
			}
		},
		sub_display = {
			7029,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[1029] = {
		limit_group = 0,
		name = "Fair Winds Cruise Pass (2026.8)",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "Unlock Special Rewards",
		id = 1029,
		subject = "Fair Winds Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 999,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 1,500 Progress Points, and also unlock additional Fair Winds Cruise rewards.",
		limit_type = 2,
		name_display = "Fair Winds Cruise Pass",
		type_order = 6,
		package_tag = "",
		picture = "battlepass_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport33",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.passport33",
		extra_service_item = {
			{
				1,
				4030,
				1500
			},
			{
				8,
				65118,
				1
			}
		},
		time = {
			{
				{
					2026,
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
					2026,
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
				8,
				59599,
				1500
			}
		},
		sub_display = {
			7030,
			1500
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[1301] = {
		limit_group = 0,
		name = "Black Friday Cruise Pass",
		descrip_extra = "You must complete certain missions to obtain these rewards.",
		type = 0,
		second_text = "",
		id = 1301,
		subject = "Black Friday Cruise Pass",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 799,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Purchase to immediately gain 200 Progress Points, and also unlock additional Black Friday Cruise Missions rewards.",
		limit_type = 2,
		name_display = "Black Friday Cruise Pass",
		type_order = 3,
		package_tag = "",
		picture = "battlepass_blackfriday_1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 4,
		id_str = "com.yostaren.azurlane.passport28",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.passport28",
		extra_service_item = {
			{
				1,
				4101,
				200
			},
			{
				8,
				65107,
				1
			}
		},
		time = {
			{
				{
					2025,
					11,
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
					2025,
					12,
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
				8,
				65107,
				200
			}
		},
		sub_display = {
			7301,
			200
		},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[2001] = {
		limit_group = 1,
		name = "PR Construction Pack - Series 1",
		descrip_extra = "",
		type = 0,
		second_text = "+Blueprints",
		id = 2001,
		subject = "PR Construction Pack - Series 1",
		first_text = "Development Ship",
		package_sort_id = 3,
		tip = "",
		money = 1599,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains one PR Voucher - Series 1 and 343 General Blueprints - Series 1.",
		name_display = "PR Construction Pack - Series 1",
		limit_type = 3,
		time = "always",
		akashi_pick = 1,
		package_tag = "",
		picture = "tech1_display",
		type_order = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "tech",
		limit_arg = 0,
		package_tag_open = 0,
		airijp_id = "",
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
		drop_item = {},
		first_icon = {
			{
				2,
				40124,
				1
			}
		}
	}
	pg.base.pay_data_display[2002] = {
		limit_group = 1,
		name = "PR Voucher & Blueprint Bundle - Series 1",
		descrip_extra = "If you've already built all Series 1 PRs, the contents will be exchanged for other items. Tap the icon to view the item table.",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "Voucher & Blueprint Bundle",
		package_sort_id = 3,
		tip = "",
		tip_open = 0,
		money = 1599,
		cash_show = 0,
		descrip = "Contains:",
		name_display = "PR Voucher & Blueprint \n         Bundle - Series 1",
		gem = 0,
		limit_arg = 1,
		limit_type = 3,
		package_tag = "",
		picture = "tech1_promotion",
		id_str = "com.yostaren.azurlane.diamond158",
		extra_gem = 0,
		id = 2002,
		airijp_id = "com.yostaren.azurlane.diamond158",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "tech",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[2003] = {
		limit_group = 1,
		name = "PR Voucher - Series 1",
		descrip_extra = "If you've already built all Series 1 PRs, the contents will be exchanged for other items. Tap the icon to view the item table.",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "Voucher",
		package_sort_id = 3,
		tip = "",
		tip_open = 0,
		money = 999,
		cash_show = 0,
		descrip = "Contains:",
		name_display = "PR Voucher - Series 1",
		gem = 0,
		limit_arg = 2,
		limit_type = 3,
		package_tag = "",
		picture = "tech1_normal",
		id_str = "com.yostaren.azurlane.diamond159",
		extra_gem = 0,
		id = 2003,
		airijp_id = "com.yostaren.azurlane.diamond159",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "tech",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[2004] = {
		limit_group = 1,
		name = "PR Blueprint Pack - Series 1",
		descrip_extra = "Buy to receive 343 General Blueprints - Series 1.",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "Blueprints",
		package_sort_id = 3,
		tip = "",
		tip_open = 0,
		money = 699,
		cash_show = 0,
		descrip = "Contains:",
		name_display = "PR Blueprint Pack - Series 1",
		gem = 0,
		limit_arg = 3,
		limit_type = 3,
		package_tag = "",
		picture = "tech1_promotion",
		id_str = "com.yostaren.azurlane.diamond160",
		extra_gem = 0,
		id = 2004,
		airijp_id = "com.yostaren.azurlane.diamond160",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "tech",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[2005] = {
		limit_group = 2,
		name = "PR Construction Pack - Series 2",
		descrip_extra = "",
		type = 0,
		second_text = "+Blueprints",
		id = 2005,
		subject = "PR Construction Pack - Series 2",
		first_text = "Development Ship",
		package_sort_id = 3,
		tip = "",
		money = 1599,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains one PR Voucher - Series 2 and 343 General Blueprints - Series 2.",
		name_display = "PR Construction Pack - Series 2",
		limit_type = 3,
		time = "always",
		akashi_pick = 1,
		package_tag = "",
		picture = "tech2_display",
		type_order = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "tech",
		limit_arg = 0,
		package_tag_open = 0,
		airijp_id = "",
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
		drop_item = {},
		first_icon = {
			{
				2,
				40125,
				1
			}
		}
	}
	pg.base.pay_data_display[2006] = {
		limit_group = 2,
		name = "PR Voucher & Blueprint Bundle - Series 2",
		descrip_extra = "If you've already built all Series 2 PRs, the contents will be exchanged for other items. Tap the icon to view the item table.",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "PR Voucher & Blueprint Bundle - Series 2",
		package_sort_id = 3,
		tip = "",
		tip_open = 0,
		money = 1599,
		cash_show = 0,
		descrip = "Contains:",
		name_display = "PR Voucher & Blueprint \n         Bundle - Series 2",
		gem = 0,
		limit_arg = 1,
		limit_type = 3,
		package_tag = "",
		picture = "tech2_promotion",
		id_str = "com.yostaren.azurlane.diamond161",
		extra_gem = 0,
		id = 2006,
		airijp_id = "com.yostaren.azurlane.diamond161",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "tech",
		package_tag_open = 0,
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
	}
end)()
;(function()
	pg.base.pay_data_display[2007] = {
		limit_group = 2,
		name = "PR Voucher - Series 2",
		descrip_extra = "If you've already built all Series 2 PRs, the contents will be exchanged for other items. Tap the icon to view the item table.",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "Voucher",
		package_sort_id = 3,
		tip = "",
		tip_open = 0,
		money = 999,
		cash_show = 0,
		descrip = "Contains:",
		name_display = "PR Voucher - Series 2",
		gem = 0,
		limit_arg = 2,
		limit_type = 3,
		package_tag = "",
		picture = "tech2_normal",
		id_str = "com.yostaren.azurlane.diamond162",
		extra_gem = 0,
		id = 2007,
		airijp_id = "com.yostaren.azurlane.diamond162",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "tech",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[2008] = {
		limit_group = 2,
		name = "PR Blueprint Pack - Series 2",
		descrip_extra = "Buy to receive 343 General Blueprints - Series 2.",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "Blueprints",
		package_sort_id = 3,
		tip = "",
		tip_open = 0,
		money = 699,
		cash_show = 0,
		descrip = "Contains:",
		name_display = "PR Blueprint Pack - Series 2",
		gem = 0,
		limit_arg = 3,
		limit_type = 3,
		package_tag = "",
		picture = "tech2_promotion",
		id_str = "com.yostaren.azurlane.diamond163",
		extra_gem = 0,
		id = 2008,
		airijp_id = "com.yostaren.azurlane.diamond163",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "tech",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[2009] = {
		limit_group = 0,
		name = "Commander Level Boost Pack",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "In Addition",
		id = 2009,
		subject = "Commander Level Boost Pack",
		first_text = "Upgrade to Commander Lv. 70",
		package_sort_id = 1,
		tip = "",
		money = 499,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Buying this pack will raise your Commander Level to 70 and grant you many useful items.",
		name_display = "Commander Level Boost Pack",
		limit_type = 2,
		time = "always",
		akashi_pick = 1,
		package_tag = "",
		picture = "lv_70",
		type_order = 7,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond164",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
		},
		first_icon = {
			{
				2,
				40126,
				1
			}
		}
	}
	pg.base.pay_data_display[2010] = {
		limit_group = 0,
		name = "Skill Book Pack",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2010,
		subject = "Skill Book Pack",
		first_text = "",
		package_sort_id = 1,
		first_icon = "",
		money = 299,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Buy to receive a large amount of Skill Books.",
		limit_type = 2,
		name_display = "Skill Book Pack",
		type_order = 0,
		package_tag = "",
		picture = "boxSkill",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond165",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 4,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[2011] = {
		limit_group = 0,
		name = "Skill Book Pack",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2011,
		subject = "Skill Book Pack",
		first_text = "",
		package_sort_id = 1,
		first_icon = "",
		money = 299,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Buy to receive a large amount of Skill Books.",
		limit_type = 2,
		name_display = "Skill Book Pack",
		type_order = 0,
		package_tag = "",
		picture = "boxSkill",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.diamond172",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 4,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[2014] = {
		limit_group = 0,
		name = "Skill Book Pack",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2014,
		subject = "Skill Book Pack",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 299,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Buy to receive a large amount of Skill Books.",
		limit_type = 2,
		name_display = "Skill Book Pack",
		type_order = 0,
		package_tag = "",
		picture = "boxSkill",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack1",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 4,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[2015] = {
		limit_group = 3,
		name = "PR Construction Pack - Series 3",
		descrip_extra = "",
		type = 0,
		second_text = "+Blueprints",
		id = 2015,
		subject = "PR Construction Pack - Series 3",
		first_text = "Development Ship",
		package_sort_id = 3,
		tip = "",
		money = 1599,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains one PR Voucher - Series 3 and 343 General Blueprints - Series 3.",
		name_display = "PR Construction Pack - Series 3",
		limit_type = 3,
		time = "always",
		akashi_pick = 1,
		package_tag = "",
		picture = "tech3_display",
		type_order = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "tech",
		limit_arg = 0,
		package_tag_open = 0,
		airijp_id = "",
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
		drop_item = {},
		first_icon = {
			{
				2,
				40130,
				1
			}
		}
	}
	pg.base.pay_data_display[2016] = {
		limit_group = 3,
		name = "PR Voucher & Blueprint Bundle - Series 3",
		descrip_extra = "If you've already built all Series 3 PRs, the contents will be exchanged for other items. Tap the icon to view the item table.",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "PR Voucher & Blueprint Bundle - Series 3",
		package_sort_id = 3,
		tip = "",
		tip_open = 0,
		money = 1599,
		cash_show = 0,
		descrip = "Contains:",
		name_display = "PR Voucher & Blueprint \n         Bundle - Series 3",
		gem = 0,
		limit_arg = 1,
		limit_type = 3,
		package_tag = "",
		picture = "tech3_promotion",
		id_str = "com.yostaren.azurlane.pack4",
		extra_gem = 0,
		id = 2016,
		airijp_id = "com.yostaren.azurlane.pack4",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "tech",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[2017] = {
		limit_group = 3,
		name = "PR Voucher Pack - Series 3",
		descrip_extra = "If you've already built all Series 3 PRs, the contents will be exchanged for other items. Tap the icon to view the item table.",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "Voucher",
		package_sort_id = 3,
		tip = "",
		tip_open = 0,
		money = 999,
		cash_show = 0,
		descrip = "Contains:",
		name_display = "PR Voucher - Series 3",
		gem = 0,
		limit_arg = 2,
		limit_type = 3,
		package_tag = "",
		picture = "tech3_normal",
		id_str = "com.yostaren.azurlane.pack2",
		extra_gem = 0,
		id = 2017,
		airijp_id = "com.yostaren.azurlane.pack2",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "tech",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[2018] = {
		limit_group = 3,
		name = "PR Blueprint Pack - Series 3",
		descrip_extra = "Buy to receive 343 General Blueprints - Series 3.",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "Blueprints",
		package_sort_id = 3,
		tip = "",
		tip_open = 0,
		money = 699,
		cash_show = 0,
		descrip = "Contains:",
		name_display = "PR Voucher - Series 3",
		gem = 0,
		limit_arg = 3,
		limit_type = 3,
		package_tag = "",
		picture = "tech3_promotion",
		id_str = "com.yostaren.azurlane.pack3",
		extra_gem = 0,
		id = 2018,
		airijp_id = "com.yostaren.azurlane.pack3",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "tech",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[2019] = {
		limit_group = 0,
		name = "Skill Book Pack",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2019,
		subject = "Skill Book Pack",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 299,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Buy to receive a large amount of Skill Books.",
		limit_type = 2,
		name_display = "Skill Book Pack",
		type_order = 0,
		package_tag = "",
		picture = "boxSkill",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack5",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 4,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[2020] = {
		limit_group = 0,
		name = "Premium Winter Gift Pack",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2020,
		subject = "Premium Winter Gift Pack",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 3699,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 3880 Gems, 1 Specialized Bulin Custom MKIII and other rewards.",
		limit_type = 2,
		name_display = "Premium Winter Gift Pack",
		type_order = 0,
		package_tag = "",
		picture = "dongzhi3",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.winterpack1",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[2022] = {
		limit_group = 0,
		name = "Wisdom Cube Supply Pack I",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "Wisdom Cube Supply Pack I",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 199,
		cash_show = 0,
		descrip = "Contains 10 Wisdom Cubes.",
		name_display = "Wisdom Cube Supply Pack I",
		gem = 0,
		limit_arg = 2,
		limit_type = 2,
		package_tag = "",
		picture = "mofangzhiyuan1",
		id_str = "com.yostaren.azurlane.cubepack1",
		extra_gem = 0,
		id = 2022,
		airijp_id = "com.yostaren.azurlane.cubepack1",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		sub_display = "",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[2023] = {
		limit_group = 0,
		name = "Wisdom Cube Supply Pack II",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "Wisdom Cube Supply Pack II",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 499,
		cash_show = 0,
		descrip = "Contains 20 Wisdom Cubes.",
		name_display = "Wisdom Cube Supply Pack II",
		gem = 0,
		limit_arg = 2,
		limit_type = 2,
		package_tag = "",
		picture = "mofangzhiyuan2",
		id_str = "com.yostaren.azurlane.cubepack2",
		extra_gem = 0,
		id = 2023,
		airijp_id = "com.yostaren.azurlane.cubepack2",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		sub_display = "",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[2024] = {
		limit_group = 0,
		name = "Wisdom Cube Supply Pack III",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "Wisdom Cube Supply Pack III",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 799,
		cash_show = 0,
		descrip = "Contains 30 Wisdom Cubes.",
		name_display = "Wisdom Cube Supply Pack III",
		gem = 0,
		limit_arg = 2,
		limit_type = 2,
		package_tag = "",
		picture = "mofangzhiyuan3",
		id_str = "com.yostaren.azurlane.cubepack3",
		extra_gem = 0,
		id = 2024,
		airijp_id = "com.yostaren.azurlane.cubepack3",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		sub_display = "",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[2025] = {
		limit_group = 0,
		name = "Daily Sortie Refuel Pack",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "Buyable Daily",
		type_order = 6,
		subject = "Daily Sortie Refuel Pack",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 99,
		cash_show = 0,
		descrip = "Contains 1 Wisdom Cube and 1200 Oil.",
		name_display = "Daily Sortie Refuel Pack",
		gem = 0,
		limit_arg = 1,
		limit_type = 4,
		package_tag = "",
		picture = "richang",
		id_str = "com.yostaren.azurlane.dailybag1",
		extra_gem = 0,
		id = 2025,
		airijp_id = "com.yostaren.azurlane.dailybag1",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[2026] = {
		limit_group = 0,
		name = "Skill Book Pack",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2026,
		subject = "Skill Book Pack",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 299,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Buy to receive a large amount of Skill Books.",
		limit_type = 2,
		name_display = "Skill Book Pack",
		type_order = 0,
		package_tag = "",
		picture = "boxSkill",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack6",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 4,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[2027] = {
		limit_group = 4,
		name = "PR Construction Pack - Series 4",
		descrip_extra = "",
		type = 0,
		second_text = "+Blueprints",
		id = 2027,
		subject = "PR Construction Pack - Series 4",
		first_text = "Development Ship",
		package_sort_id = 3,
		tip = "",
		money = 1599,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains one PR Voucher - Series 4 and 343 General Blueprints - Series 4.",
		name_display = "PR Construction Pack - Series 4",
		limit_type = 3,
		time = "always",
		akashi_pick = 1,
		package_tag = "",
		picture = "tech4_display",
		type_order = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "tech",
		limit_arg = 0,
		package_tag_open = 0,
		airijp_id = "",
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
		drop_item = {},
		first_icon = {
			{
				2,
				40139,
				1
			}
		}
	}
	pg.base.pay_data_display[2028] = {
		limit_group = 4,
		name = "PR Voucher & Blueprint Bundle - Series 4",
		descrip_extra = "If you've already built all Series 4 PRs, the contents will be exchanged for other items. Tap the icon to view the item table.",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "PR Voucher & Blueprint Bundle - Series 4",
		package_sort_id = 3,
		tip = "",
		tip_open = 0,
		money = 1599,
		cash_show = 0,
		descrip = "Contains:",
		name_display = "PR Voucher & Blueprint \n         Bundle - Series 4",
		gem = 0,
		limit_arg = 1,
		limit_type = 3,
		package_tag = "",
		picture = "tech4_promotion",
		id_str = "com.yostaren.azurlane.pack9",
		extra_gem = 0,
		id = 2028,
		airijp_id = "com.yostaren.azurlane.pack9",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "tech",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[2029] = {
		limit_group = 4,
		name = "PR Voucher - Series 4",
		descrip_extra = "If you've already built all Series 4 PRs, the contents will be exchanged for other items. Tap the icon to view the item table.",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "PR Voucher - Series 4",
		package_sort_id = 3,
		tip = "",
		tip_open = 0,
		money = 999,
		cash_show = 0,
		descrip = "Contains:",
		name_display = "PR Voucher Pack - Series 4",
		gem = 0,
		limit_arg = 2,
		limit_type = 3,
		package_tag = "",
		picture = "tech4_normal",
		id_str = "com.yostaren.azurlane.pack7",
		extra_gem = 0,
		id = 2029,
		airijp_id = "com.yostaren.azurlane.pack7",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "tech",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[2030] = {
		limit_group = 4,
		name = "PR Blueprint Pack - Series 4",
		descrip_extra = "Buy to receive 343 General Blueprints - Series 4.",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "PR Blueprint Pack - Series 4",
		package_sort_id = 3,
		tip = "",
		tip_open = 0,
		money = 699,
		cash_show = 0,
		descrip = "Contains:",
		name_display = "PR Blueprint Pack - Series 4",
		gem = 0,
		limit_arg = 3,
		limit_type = 3,
		package_tag = "",
		picture = "tech4_promotion",
		id_str = "com.yostaren.azurlane.pack8",
		extra_gem = 0,
		id = 2030,
		airijp_id = "com.yostaren.azurlane.pack8",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "tech",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[2031] = {
		limit_group = 0,
		name = "Outfit Selection Pack (Shimakaze)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "Outfit Selection Pack (Shimakaze)",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 1799,
		cash_show = 0,
		descrip = "Contains an Outfit Selection Voucher, Wisdom Cubes, T2 EXP Data Packs, and more.",
		name_display = "Outfit Selection Pack (Shimakaze)",
		gem = 0,
		limit_arg = 1,
		limit_type = 2,
		package_tag = "Great\nDeal",
		picture = "daofeng_package",
		id_str = "com.yostaren.azurlane.pack11",
		extra_gem = 0,
		id = 2031,
		airijp_id = "com.yostaren.azurlane.pack11",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		sub_display = "",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "",
		package_tag_open = 1,
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
	}
	pg.base.pay_data_display[2032] = {
		limit_group = 101,
		name = "Iridescent Fantasy Pack",
		descrip_extra = "",
		type = 0,
		second_text = "",
		id = 2032,
		subject = "Iridescent Fantasy Pack",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1199,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a new combat UI theme.",
		limit_type = 5,
		name_display = "Iridescent Fantasy Pack",
		type_order = 4,
		package_tag = "",
		picture = "ui1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 0,
		package_tag_open = 0,
		airijp_id = "",
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
	}
	pg.base.pay_data_display[2033] = {
		limit_group = 101,
		name = "Iridescent Fantasy Pack (Basic)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2033,
		subject = "Iridescent Fantasy Pack (Basic)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1199,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a new combat UI theme.",
		limit_type = 5,
		name_display = "Iridescent Fantasy Pack (Basic)",
		type_order = 4,
		package_tag = "",
		picture = "ui1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack12",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[2034] = {
		limit_group = 101,
		name = "Iridescent Fantasy Pack (Premium)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2034,
		subject = "Iridescent Fantasy Pack (Premium)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 3699,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a new combat UI theme and Gems x 3,060.",
		limit_type = 5,
		name_display = "Iridescent Fantasy Pack (Premium)",
		type_order = 4,
		package_tag = "",
		picture = "ui1",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack13",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 1,
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[2035] = {
		limit_group = 0,
		name = "Outfit Selection Pack (Ulrich von Hutten)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		type_order = 2,
		subject = "Outfit Selection Pack (Ulrich von Hutten)",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 1799,
		cash_show = 0,
		descrip = "Contains an Outfit Selection Voucher, Wisdom Cubes, T2 EXP Data Packs, and more.",
		name_display = "Outfit Selection Pack (Ulrich von Hutten)",
		gem = 0,
		limit_arg = 1,
		limit_type = 2,
		package_tag = "",
		picture = "huteng_package",
		id_str = "com.yostaren.azurlane.pack14",
		extra_gem = 0,
		id = 2035,
		airijp_id = "com.yostaren.azurlane.pack14",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		sub_display = "",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[2036] = {
		limit_group = 0,
		name = "Skill Book Pack (2024.11)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2036,
		subject = "Skill Book Pack",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 299,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Buy to receive a large amount of Skill Books.",
		limit_type = 2,
		name_display = "Skill Book Pack",
		type_order = 0,
		package_tag = "",
		picture = "boxSkill",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack15",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 4,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack15",
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
					2025,
					4,
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
	}
	pg.base.pay_data_display[2037] = {
		limit_group = 102,
		name = "Battle UI Pack - Christmas",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2037,
		subject = "Battle UI Pack - Christmas",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1199,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a new combat UI theme.",
		limit_type = 5,
		name_display = "Battle UI Pack - Christmas",
		type_order = 4,
		package_tag = "",
		picture = "ui2",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 0,
		package_tag_open = 0,
		airijp_id = "",
		extra_service_item = {
			{
				31,
				201,
				1
			}
		},
		time = {
			{
				{
					2024,
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
					2025,
					1,
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
				31,
				201,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[2038] = {
		limit_group = 102,
		name = "Battle UI Pack - Christmas (Basic)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2038,
		subject = "Battle UI Pack - Christmas (Basic)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1199,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a new combat UI theme.",
		limit_type = 5,
		name_display = "Battle UI Pack - Christmas (Basic)",
		type_order = 4,
		package_tag = "",
		picture = "ui2",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack17",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack17",
		extra_service_item = {
			{
				31,
				201,
				1
			}
		},
		time = {
			{
				{
					2024,
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
					2025,
					1,
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
				31,
				201,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40051,
				1
			}
		}
	}
	pg.base.pay_data_display[2039] = {
		limit_group = 102,
		name = "Battle UI Pack - Christmas (Premium)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2039,
		subject = "Battle UI Pack - Christmas (Premium)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 3699,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a new combat UI theme and Gems x 3,060.",
		limit_type = 5,
		name_display = "Battle UI Pack - Christmas (Premium)",
		type_order = 4,
		package_tag = "",
		picture = "ui2",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack18",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack18",
		extra_service_item = {
			{
				31,
				201,
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
					2025,
					1,
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
				31,
				201,
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
				40052,
				1
			}
		}
	}
	pg.base.pay_data_display[2040] = {
		limit_group = 0,
		name = "Premium Winter Gift Pack",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2040,
		subject = "Premium Winter Gift Pack",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 3699,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 3880 Gems, 1 Specialized Bulin Custom MKIII and other rewards.",
		limit_type = 2,
		name_display = "Premium Winter Gift Pack",
		type_order = 4,
		package_tag = "",
		picture = "dongzhi3",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack16",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack16",
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
					2025,
					1,
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
				40053,
				1
			}
		}
	}
	pg.base.pay_data_display[2041] = {
		limit_group = 0,
		name = "Outfit Pack (Kronshtadt)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		type_order = 5,
		subject = "Outfit Pack (Kronshtadt)",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 1799,
		cash_show = 0,
		descrip = "Contains an Outfit Voucher, Wisdom Cubes, T2 EXP Data Packs, and more.",
		name_display = "Outfit Pack (Kronshtadt)",
		gem = 0,
		limit_arg = 1,
		limit_type = 2,
		package_tag = "Great\nDeal",
		picture = "huteng_package",
		id_str = "com.yostaren.azurlane.pack19",
		extra_gem = 0,
		id = 2041,
		airijp_id = "com.yostaren.azurlane.pack19",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		sub_display = "",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "",
		package_tag_open = 1,
		extra_service_item = {
			{
				2,
				59561,
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
					2025,
					1,
					9
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2025,
					1,
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
				59561,
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
	}
	pg.base.pay_data_display[2042] = {
		limit_group = 103,
		name = "Battle UI Pack – Pharaoh",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2042,
		subject = "Battle UI Pack – Pharaoh",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1199,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a new combat UI theme.",
		limit_type = 5,
		name_display = "Battle UI Pack – Pharaoh",
		type_order = 4,
		package_tag = "",
		picture = "ui3",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 0,
		package_tag_open = 0,
		airijp_id = "",
		extra_service_item = {
			{
				31,
				202,
				1
			}
		},
		time = {
			{
				{
					2025,
					2,
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
					2025,
					3,
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
				31,
				202,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[2043] = {
		limit_group = 103,
		name = "Battle UI Pack - Pharaoh (Basic)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2043,
		subject = " Battle UI Pack - Pharaoh (Basic)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1199,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a new combat UI theme.",
		limit_type = 5,
		name_display = "Battle UI Pack - Pharaoh (Basic)",
		type_order = 4,
		package_tag = "",
		picture = "ui3",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack20",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack20",
		extra_service_item = {
			{
				31,
				202,
				1
			}
		},
		time = {
			{
				{
					2025,
					2,
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
					2025,
					3,
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
				31,
				202,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40055,
				1
			}
		}
	}
	pg.base.pay_data_display[2044] = {
		limit_group = 103,
		name = "Battle UI Pack - Pharaoh (Premium)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2044,
		subject = "Battle UI Pack - Pharaoh (Premium)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 3699,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a new combat UI theme and Gems x 3,060.",
		limit_type = 5,
		name_display = "Battle UI Pack - Pharaoh (Premium)",
		type_order = 4,
		package_tag = "",
		picture = "ui3",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack21",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack21",
		extra_service_item = {
			{
				31,
				202,
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
					2025,
					2,
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
					2025,
					3,
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
				31,
				202,
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
				40056,
				1
			}
		}
	}
	pg.base.pay_data_display[2045] = {
		limit_group = 104,
		name = "Battle UI Pack - Genetic Origin",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2045,
		subject = "Battle UI Pack - Genetic Origin",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1199,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a new combat UI theme.",
		limit_type = 5,
		name_display = "Battle UI Pack - Genetic Origin",
		type_order = 4,
		package_tag = "",
		picture = "ui4",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 0,
		package_tag_open = 0,
		airijp_id = "",
		extra_service_item = {
			{
				31,
				203,
				1
			}
		},
		time = {
			{
				{
					2025,
					3,
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
					2025,
					4,
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
				31,
				203,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[2046] = {
		limit_group = 104,
		name = "Battle UI Pack - Genetic Origin (Basic)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2046,
		subject = "Battle UI Pack - Genetic Origin (Basic)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1199,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a new combat UI theme.",
		limit_type = 5,
		name_display = "Battle UI Pack - Genetic Origin (Basic)",
		type_order = 4,
		package_tag = "",
		picture = "ui4",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack22",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack22",
		extra_service_item = {
			{
				31,
				203,
				1
			}
		},
		time = {
			{
				{
					2025,
					3,
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
					2025,
					4,
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
				31,
				203,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40057,
				1
			}
		}
	}
	pg.base.pay_data_display[2047] = {
		limit_group = 104,
		name = "Battle UI Pack - Genetic Origin (Premium)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2047,
		subject = "Battle UI Pack - Genetic Origin (Premium)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 3699,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a new combat UI theme and Gems x 3,060.",
		limit_type = 5,
		name_display = "Battle UI Pack - Genetic Origin (Premium)",
		type_order = 4,
		package_tag = "",
		picture = "ui4",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack23",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack23",
		extra_service_item = {
			{
				31,
				203,
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
					2025,
					3,
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
					2025,
					4,
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
				31,
				203,
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
				40058,
				1
			}
		}
	}
	pg.base.pay_data_display[2048] = {
		limit_group = 0,
		name = "Outfit Pack (Vanguard)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		type_order = 5,
		subject = "Outfit Pack (Vanguard)",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 1799,
		cash_show = 0,
		descrip = "Contains an Outfit Voucher, Wisdom Cubes, T2 EXP Data Packs, and more.",
		name_display = "Outfit Pack (Vanguard)",
		gem = 0,
		limit_arg = 1,
		limit_type = 2,
		package_tag = "Great\nDeal",
		picture = "huteng_package",
		id_str = "com.yostaren.azurlane.pack24",
		extra_gem = 0,
		id = 2048,
		airijp_id = "com.yostaren.azurlane.pack24",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		sub_display = "",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "",
		package_tag_open = 1,
		extra_service_item = {
			{
				2,
				59564,
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
					2025,
					4,
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
					2025,
					4,
					23
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
				59564,
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
				40059,
				1
			}
		}
	}
	pg.base.pay_data_display[2049] = {
		limit_group = 0,
		name = "Skill Book Pack",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2049,
		subject = "Skill Book Pack",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 299,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Buy to receive a large amount of Skill Books.",
		limit_type = 2,
		name_display = "Skill Book Pack",
		type_order = 0,
		package_tag = "",
		picture = "boxSkill",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack25",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 4,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack25",
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
					2025,
					4,
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
					2025,
					11,
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
	}
	pg.base.pay_data_display[2050] = {
		limit_group = 105,
		name = "Battle UI Pack - Seaside Splash",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2050,
		subject = "Battle UI Pack - Seaside Splash",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1199,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a new combat UI theme.",
		limit_type = 5,
		name_display = "Battle UI Pack - Seaside Splash",
		type_order = 4,
		package_tag = "",
		picture = "ui5",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 0,
		package_tag_open = 0,
		airijp_id = "",
		extra_service_item = {
			{
				31,
				204,
				1
			}
		},
		time = {
			{
				{
					2025,
					5,
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
					2025,
					6,
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
				31,
				204,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[2051] = {
		limit_group = 105,
		name = "Battle UI Pack - Seaside Splash (Basic)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2051,
		subject = "Battle UI Pack - Seaside Splash (Basic)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1199,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains the Battle UI - Seaside Splash theme and 1,000 Coins.",
		limit_type = 5,
		name_display = "Battle UI Pack - Seaside Splash (Basic)",
		type_order = 4,
		package_tag = "",
		picture = "ui5",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack26",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack26",
		extra_service_item = {
			{
				31,
				204,
				1
			},
			{
				1,
				1,
				1000
			}
		},
		time = {
			{
				{
					2025,
					5,
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
					2025,
					6,
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
				31,
				204,
				1
			},
			{
				1,
				1,
				1000
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40060,
				1
			}
		}
	}
	pg.base.pay_data_display[2052] = {
		limit_group = 105,
		name = "Battle UI Pack - Seaside Splash (Premium)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2052,
		subject = "Battle UI Pack - Seaside Splash (Premium)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 3699,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains the Battle UI - Seaside Splash theme and 3,060 Gems.",
		limit_type = 5,
		name_display = "Battle UI Pack - Seaside Splash (Premium)",
		type_order = 4,
		package_tag = "",
		picture = "ui5",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack27",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack27",
		extra_service_item = {
			{
				31,
				204,
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
					2025,
					5,
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
					2025,
					6,
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
				31,
				204,
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
				40061,
				1
			}
		}
	}
	pg.base.pay_data_display[2053] = {
		limit_group = 5,
		name = "PR Construction Pack - Series 5",
		descrip_extra = "",
		type = 0,
		second_text = "+Blueprints",
		id = 2053,
		subject = "PR Construction Pack - Series 5",
		first_text = "Development Ship",
		package_sort_id = 3,
		tip = "",
		money = 1599,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains one PR Voucher - Series 5 and 343 General Blueprints - Series 5.",
		name_display = "PR Construction Pack - Series 5",
		limit_type = 3,
		time = "always",
		akashi_pick = 1,
		package_tag = "",
		picture = "tech5_display",
		type_order = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "tech",
		limit_arg = 0,
		package_tag_open = 0,
		airijp_id = "",
		extra_service_item = {
			{
				2,
				40140,
				1
			},
			{
				2,
				42040,
				343
			}
		},
		display = {
			{
				2,
				42040,
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
		drop_item = {},
		first_icon = {
			{
				2,
				40140,
				1
			}
		}
	}
	pg.base.pay_data_display[2054] = {
		limit_group = 5,
		name = "PR Voucher & Blueprint Bundle - Series 5",
		descrip_extra = "If you've already built all Series 5 PRs, the contents will be exchanged for other items. Tap the icon to view the item table.",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "PR Voucher & Blueprint Bundle - Series 5",
		package_sort_id = 3,
		tip = "",
		tip_open = 0,
		money = 1599,
		cash_show = 0,
		descrip = "Contains:",
		name_display = "PR Voucher & Blueprint \n         Bundle - Series 5",
		gem = 0,
		limit_arg = 1,
		limit_type = 3,
		package_tag = "",
		picture = "tech5_promotion",
		id_str = "com.yostaren.azurlane.pack30",
		extra_gem = 0,
		id = 2054,
		airijp_id = "com.yostaren.azurlane.pack30",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "tech",
		package_tag_open = 0,
		extra_service_item = {
			{
				2,
				40140,
				1
			},
			{
				2,
				42040,
				343
			}
		},
		display = {
			{
				2,
				40140,
				1
			},
			{
				2,
				42040,
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
				40062,
				1
			}
		}
	}
	pg.base.pay_data_display[2055] = {
		limit_group = 5,
		name = "PR Voucher - Series 5",
		descrip_extra = "If you've already built all Series 5 PRs, the contents will be exchanged for other items. Tap the icon to view the item table.",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "PR Voucher - Series 5",
		package_sort_id = 3,
		tip = "",
		tip_open = 0,
		money = 999,
		cash_show = 0,
		descrip = "Contains:",
		name_display = "PR Voucher Pack - Series 5",
		gem = 0,
		limit_arg = 2,
		limit_type = 3,
		package_tag = "",
		picture = "tech5_normal",
		id_str = "com.yostaren.azurlane.pack28",
		extra_gem = 0,
		id = 2055,
		airijp_id = "com.yostaren.azurlane.pack28",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "tech",
		package_tag_open = 0,
		extra_service_item = {
			{
				2,
				40140,
				1
			}
		},
		display = {
			{
				2,
				40140,
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
				40063,
				1
			}
		}
	}
	pg.base.pay_data_display[2056] = {
		limit_group = 5,
		name = "PR Blueprint Pack - Series 5",
		descrip_extra = "Buy to receive 343 General Blueprints - Series 5.",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "PR Blueprint Pack - Series 5",
		package_sort_id = 3,
		tip = "",
		tip_open = 0,
		money = 699,
		cash_show = 0,
		descrip = "Contains:",
		name_display = "PR Blueprint Pack - Series 5",
		gem = 0,
		limit_arg = 3,
		limit_type = 3,
		package_tag = "",
		picture = "tech5_promotion",
		id_str = "com.yostaren.azurlane.pack29",
		extra_gem = 0,
		id = 2056,
		airijp_id = "com.yostaren.azurlane.pack29",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "tech",
		package_tag_open = 0,
		extra_service_item = {
			{
				2,
				42040,
				343
			}
		},
		display = {
			{
				2,
				42040,
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
				40064,
				1
			}
		}
	}
	pg.base.pay_data_display[2057] = {
		limit_group = 106,
		name = "Battle UI Pack - Ninja Castle",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2057,
		subject = "Battle UI Pack - Ninja Castle",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1199,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a new combat UI theme.",
		limit_type = 5,
		name_display = "Battle UI Pack - Ninja Castle",
		type_order = 4,
		package_tag = "",
		picture = "ui6",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 0,
		package_tag_open = 0,
		airijp_id = "",
		extra_service_item = {
			{
				31,
				205,
				1
			}
		},
		time = {
			{
				{
					2025,
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
					2025,
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
				205,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[2058] = {
		limit_group = 106,
		name = "Battle UI Pack - Ninja Castle (Basic)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2058,
		subject = "Battle UI Pack - Ninja Castle (Basic)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1199,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains the Battle UI - Ninja Castle theme and 1,000 Coins.",
		limit_type = 5,
		name_display = "Battle UI Pack - Ninja Castle (Basic)",
		type_order = 4,
		package_tag = "",
		picture = "ui6",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack31",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack31",
		extra_service_item = {
			{
				31,
				205,
				1
			},
			{
				1,
				1,
				1000
			}
		},
		time = {
			{
				{
					2025,
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
					2025,
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
				205,
				1
			},
			{
				1,
				1,
				1000
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40065,
				1
			}
		}
	}
	pg.base.pay_data_display[2059] = {
		limit_group = 106,
		name = "Battle UI Pack - Ninja Castle (Premium)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2059,
		subject = "Battle UI Pack - Ninja Castle (Premium)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 3699,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains the Battle UI - Ninja Castle theme and 3,060 Gems.",
		limit_type = 5,
		name_display = "Battle UI Pack - Ninja Castle (Premium)",
		type_order = 4,
		package_tag = "",
		picture = "ui6",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack32",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack32",
		extra_service_item = {
			{
				31,
				205,
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
					2025,
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
					2025,
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
				205,
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
				40066,
				1
			}
		}
	}
	pg.base.pay_data_display[2063] = {
		limit_group = 0,
		name = "Outfit Selection Pack (Musashi)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		type_order = 5,
		subject = "Outfit Selection Pack (Musashi)",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 1799,
		cash_show = 0,
		descrip = "Contains an Outfit Voucher, Wisdom Cubes, T2 EXP Data Packs, and more.",
		name_display = "Outfit Selection Pack (Musashi)",
		gem = 0,
		limit_arg = 1,
		limit_type = 2,
		package_tag = "Great\nDeal",
		picture = "huteng_package",
		id_str = "com.yostaren.azurlane.pack33",
		extra_gem = 0,
		id = 2063,
		airijp_id = "com.yostaren.azurlane.pack33",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		sub_display = "",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "",
		package_tag_open = 1,
		extra_service_item = {
			{
				2,
				59565,
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
					2025,
					11,
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
					2025,
					11,
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
				59565,
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
				40070,
				1
			}
		}
	}
	pg.base.pay_data_display[2064] = {
		limit_group = 0,
		name = "Skill Book Pack",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2064,
		subject = "Skill Book Pack",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 299,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Buy to receive a large amount of Skill Books.",
		limit_type = 2,
		name_display = "Skill Book Pack",
		type_order = 0,
		package_tag = "",
		picture = "boxSkill",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack34",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 4,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack34",
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
					2025,
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
					2026,
					4,
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
	}
	pg.base.pay_data_display[2068] = {
		limit_group = 107,
		name = "Battle UI Pack – Maid Café",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2068,
		subject = "Battle UI Pack – Maid Café",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1199,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a new combat UI theme.",
		limit_type = 5,
		name_display = "Battle UI Pack – Maid Café",
		type_order = 4,
		package_tag = "",
		picture = "ui7",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 0,
		package_tag_open = 0,
		airijp_id = "",
		extra_service_item = {
			{
				31,
				206,
				1
			}
		},
		time = {
			{
				{
					2025,
					12,
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
					2026,
					1,
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
				31,
				206,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[2069] = {
		limit_group = 107,
		name = "Battle UI Pack – Maid Café (Basic)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2069,
		subject = "Battle UI Pack – Maid Café (Basic)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1199,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains the Battle UI - Maid Café theme and 1,000 Coins.",
		limit_type = 5,
		name_display = "Battle UI Pack – Maid Café (Basic)",
		type_order = 4,
		package_tag = "",
		picture = "ui7",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack36",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack36",
		extra_service_item = {
			{
				31,
				206,
				1
			},
			{
				1,
				1,
				1000
			}
		},
		time = {
			{
				{
					2025,
					12,
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
					2026,
					1,
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
				31,
				206,
				1
			},
			{
				1,
				1,
				1000
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40074,
				1
			}
		}
	}
	pg.base.pay_data_display[2070] = {
		limit_group = 107,
		name = "Battle UI Pack – Maid Café (Premium)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2070,
		subject = "Battle UI Pack – Maid Café (Premium)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 3699,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains the Battle UI - Maid Café theme and 3,060 Gems.",
		limit_type = 5,
		name_display = "Battle UI Pack – Maid Café (Premium)",
		type_order = 4,
		package_tag = "",
		picture = "ui7",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack37",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack37",
		extra_service_item = {
			{
				31,
				206,
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
					2025,
					12,
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
					2026,
					1,
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
				31,
				206,
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
				40075,
				1
			}
		}
	}
	pg.base.pay_data_display[2071] = {
		limit_group = 0,
		name = "Premium Winter Gift Pack",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2071,
		subject = "Premium Winter Gift Pack",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 3699,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains 3880 Gems, 1 Specialized Bulin Custom MKIII and other rewards.",
		limit_type = 2,
		name_display = "Premium Winter Gift Pack",
		type_order = 4,
		package_tag = "",
		picture = "dongzhi3",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack35",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack35",
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
					2025,
					12,
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
					2026,
					1,
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
				40076,
				1
			}
		}
	}
	pg.base.pay_data_display[2074] = {
		limit_group = 108,
		name = "Battle UI Pack - Springtide Inn",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2074,
		subject = "Battle UI Pack - Springtide Inn",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1199,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a new combat UI theme.",
		limit_type = 5,
		name_display = "Battle UI Pack - Springtide Inn",
		type_order = 4,
		package_tag = "",
		picture = "ui8",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 0,
		package_tag_open = 0,
		airijp_id = "",
		extra_service_item = {
			{
				31,
				207,
				1
			}
		},
		time = {
			{
				{
					2026,
					2,
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
					2026,
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
				31,
				207,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[2075] = {
		limit_group = 108,
		name = "Battle UI Pack – Springtide Inn (Basic)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2075,
		subject = "Battle UI Pack – Springtide Inn (Basic)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1199,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains the Battle UI - Springtide Inn theme and 1,000 Coins.",
		limit_type = 5,
		name_display = "Battle UI Pack – Springtide Inn (Basic)",
		type_order = 4,
		package_tag = "",
		picture = "ui8",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack38",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack38",
		extra_service_item = {
			{
				31,
				207,
				1
			},
			{
				1,
				1,
				1000
			}
		},
		time = {
			{
				{
					2026,
					2,
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
					2026,
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
				31,
				207,
				1
			},
			{
				1,
				1,
				1000
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40077,
				1
			}
		}
	}
	pg.base.pay_data_display[2076] = {
		limit_group = 108,
		name = "Battle UI Pack – Springtide Inn (Premium)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2076,
		subject = "Battle UI Pack – Springtide Inn (Premium)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 3699,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains the Battle UI - Springtide Inn theme and 3,060 Gems.",
		limit_type = 5,
		name_display = "Battle UI Pack – Springtide Inn (Premium)",
		type_order = 4,
		package_tag = "",
		picture = "ui8",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack39",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack39",
		extra_service_item = {
			{
				31,
				207,
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
					2026,
					2,
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
					2026,
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
				31,
				207,
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
				40078,
				1
			}
		}
	}
	pg.base.pay_data_display[2078] = {
		limit_group = 0,
		name = "Skill Book Pack",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2078,
		subject = "Skill Book Pack",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 299,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Buy to receive a large amount of Skill Books.",
		limit_type = 2,
		name_display = "Skill Book Pack",
		type_order = 0,
		package_tag = "",
		picture = "boxSkill",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack40",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "",
		limit_arg = 4,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack40",
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
					2026,
					4,
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
					2026,
					11,
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
	}
	pg.base.pay_data_display[2079] = {
		limit_group = 109,
		name = "Battle UI Pack - Gilded Reverie",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2079,
		subject = "Battle UI Pack - Gilded Reverie",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1199,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains the Battle UI - Gilded Reverie theme.",
		limit_type = 5,
		name_display = "Battle UI Pack - Gilded Reverie",
		type_order = 4,
		package_tag = "",
		picture = "ui9",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 0,
		package_tag_open = 0,
		airijp_id = "",
		extra_service_item = {
			{
				31,
				208,
				1
			}
		},
		time = {
			{
				{
					2026,
					5,
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
					2026,
					6,
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
				31,
				208,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[2080] = {
		limit_group = 109,
		name = "Battle UI Pack - Gilded Reverie (Basic)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2080,
		subject = "Battle UI Pack - Gilded Reverie (Basic)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1199,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains the Battle UI - Gilded Reverie theme and 1,000 Coins.",
		limit_type = 5,
		name_display = "Battle UI Pack - Gilded Reverie (Basic)",
		type_order = 4,
		package_tag = "",
		picture = "ui9",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack41",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack41",
		extra_service_item = {
			{
				31,
				208,
				1
			},
			{
				1,
				1,
				1000
			}
		},
		time = {
			{
				{
					2026,
					5,
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
					2026,
					6,
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
				31,
				208,
				1
			},
			{
				1,
				1,
				1000
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40080,
				1
			}
		}
	}
	pg.base.pay_data_display[2081] = {
		limit_group = 109,
		name = "Battle UI Pack - Gilded Reverie (Premium)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2081,
		subject = "Battle UI Pack - Gilded Reverie (Premium)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 3699,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains the Battle UI - Gilded Reverie theme and 3,060 Gems.",
		limit_type = 5,
		name_display = "Battle UI Pack - Gilded Reverie (Premium)",
		type_order = 4,
		package_tag = "",
		picture = "ui9",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack42",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack42",
		extra_service_item = {
			{
				31,
				208,
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
					2026,
					5,
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
					2026,
					6,
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
				31,
				208,
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
				40081,
				1
			}
		}
	}
	pg.base.pay_data_display[2085] = {
		limit_group = 110,
		name = "Battle UI Pack – YoRHa",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2085,
		subject = "Battle UI Pack – YoRHa",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1199,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a new combat UI theme.",
		limit_type = 5,
		name_display = "Battle UI Pack – YoRHa",
		type_order = 4,
		package_tag = "",
		picture = "ui10",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 0,
		package_tag_open = 0,
		airijp_id = "",
		extra_service_item = {
			{
				31,
				209,
				1
			}
		},
		time = {
			{
				{
					2026,
					7,
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
					2026,
					7,
					29
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
				209,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[2086] = {
		limit_group = 110,
		name = "Battle UI Pack – YoRHa (Basic)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2086,
		subject = "Battle UI Pack – YoRHa (Basic)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1199,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains the Battle UI - YoRHa theme and 1,000 Coins.",
		limit_type = 5,
		name_display = "Battle UI Pack – YoRHa (Basic)",
		type_order = 4,
		package_tag = "",
		picture = "ui10",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack46",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack46",
		extra_service_item = {
			{
				31,
				209,
				1
			},
			{
				1,
				1,
				1000
			}
		},
		time = {
			{
				{
					2026,
					7,
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
					2026,
					7,
					29
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
				209,
				1
			},
			{
				1,
				1,
				1000
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40084,
				1
			}
		}
	}
	pg.base.pay_data_display[2087] = {
		limit_group = 110,
		name = "Battle UI Pack – YoRHa (Premium)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2087,
		subject = "Battle UI Pack – YoRHa (Premium)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 3699,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains the Battle UI - YoRHa theme and 3,060 Gems.",
		limit_type = 5,
		name_display = "Battle UI Pack – YoRHa (Premium)",
		type_order = 4,
		package_tag = "",
		picture = "ui10",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack47",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack47",
		extra_service_item = {
			{
				31,
				209,
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
					2026,
					7,
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
					2026,
					7,
					29
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
				209,
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
				40085,
				1
			}
		}
	}
	pg.base.pay_data_display[2088] = {
		limit_group = 6,
		name = "PR Construction Pack - Series 6",
		descrip_extra = "",
		type = 0,
		second_text = "+Blueprints",
		id = 2088,
		subject = "PR Construction Pack - Series 6",
		first_text = "Development Ship",
		package_sort_id = 3,
		tip = "",
		money = 1599,
		tip_open = 0,
		tag = 2,
		cash_show = 0,
		gem = 0,
		descrip = "Contains one PR Voucher - Series 6 and 343 General Blueprints - Series 6.",
		name_display = "PR Construction Pack - Series 6",
		limit_type = 3,
		time = "always",
		akashi_pick = 1,
		package_tag = "",
		picture = "tech6_display",
		type_order = 0,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "tech",
		limit_arg = 0,
		package_tag_open = 0,
		airijp_id = "",
		extra_service_item = {
			{
				2,
				40145,
				1
			},
			{
				2,
				42050,
				343
			}
		},
		display = {
			{
				2,
				42050,
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
		drop_item = {},
		first_icon = {
			{
				2,
				40145,
				1
			}
		}
	}
	pg.base.pay_data_display[2089] = {
		limit_group = 6,
		name = "PR Voucher & Blueprint Bundle - Series 6",
		descrip_extra = "If you've already built all Series 6 PRs, the contents will be exchanged for other items. Tap the icon to view the item table.",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "PR Voucher & Blueprint Bundle - Series 6",
		package_sort_id = 3,
		tip = "",
		tip_open = 0,
		money = 1599,
		cash_show = 0,
		descrip = "Contains:",
		name_display = "PR Voucher & Blueprint \n         Bundle - Series 6",
		gem = 0,
		limit_arg = 1,
		limit_type = 3,
		package_tag = "",
		picture = "tech6_promotion",
		id_str = "com.yostaren.azurlane.pack45",
		extra_gem = 0,
		id = 2089,
		airijp_id = "com.yostaren.azurlane.pack45",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "tech",
		package_tag_open = 0,
		extra_service_item = {
			{
				2,
				40145,
				1
			},
			{
				2,
				42050,
				343
			}
		},
		display = {
			{
				2,
				40145,
				1
			},
			{
				2,
				42050,
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
				40086,
				1
			}
		}
	}
	pg.base.pay_data_display[2090] = {
		limit_group = 6,
		name = "PR Voucher Pack - Series 6",
		descrip_extra = "If you've already built all Series 6 PRs, the contents will be exchanged for other items. Tap the icon to view the item table.",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "PR Voucher Pack - Series 6",
		package_sort_id = 3,
		tip = "",
		tip_open = 0,
		money = 999,
		cash_show = 0,
		descrip = "Contains:",
		name_display = "PR Voucher Pack - Series 6",
		gem = 0,
		limit_arg = 2,
		limit_type = 3,
		package_tag = "",
		picture = "tech6_normal",
		id_str = "com.yostaren.azurlane.pack43",
		extra_gem = 0,
		id = 2090,
		airijp_id = "com.yostaren.azurlane.pack43",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "tech",
		package_tag_open = 0,
		extra_service_item = {
			{
				2,
				40145,
				1
			}
		},
		display = {
			{
				2,
				40145,
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
				40087,
				1
			}
		}
	}
	pg.base.pay_data_display[2091] = {
		limit_group = 6,
		name = "PR Blueprint Pack - Series 6",
		descrip_extra = "Purchase to obtain 343 General Blueprint - Series 6.",
		type = 0,
		second_text = "",
		type_order = 0,
		subject = "PR Blueprint Pack - Series 6",
		package_sort_id = 3,
		tip = "",
		tip_open = 0,
		money = 699,
		cash_show = 0,
		descrip = "Contains:",
		name_display = "PR Blueprint Pack - Series 6",
		gem = 0,
		limit_arg = 3,
		limit_type = 3,
		package_tag = "",
		picture = "tech6_promotion",
		id_str = "com.yostaren.azurlane.pack44",
		extra_gem = 0,
		id = 2091,
		airijp_id = "com.yostaren.azurlane.pack44",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		time = "always",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "tech",
		package_tag_open = 0,
		extra_service_item = {
			{
				2,
				42050,
				343
			}
		},
		display = {
			{
				2,
				42050,
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
				40088,
				1
			}
		}
	}
	pg.base.pay_data_display[2093] = {
		limit_group = 111,
		name = "Battle UI Pack - Candlelit Ritual",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2093,
		subject = "Battle UI Pack - Candlelit Ritual",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1199,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains a new combat UI theme.",
		limit_type = 5,
		name_display = "Battle UI Pack - Candlelit Ritual",
		type_order = 4,
		package_tag = "",
		picture = "ui11",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 0,
		package_tag_open = 0,
		airijp_id = "",
		extra_service_item = {
			{
				31,
				210,
				1
			}
		},
		time = {
			{
				{
					2026,
					9,
					8
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2026,
					9,
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
				31,
				210,
				1
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {}
	}
	pg.base.pay_data_display[2094] = {
		limit_group = 111,
		name = "Battle UI Pack - Candlelit Ritual (Basic)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2094,
		subject = "Battle UI Pack - Candlelit Ritual (Basic)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 1199,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains the Battle UI - Candlelit Ritual theme and 1,000 Coins.",
		limit_type = 5,
		name_display = "Battle UI Pack - Candlelit Ritual (Basic)",
		type_order = 4,
		package_tag = "",
		picture = "ui11",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack48",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack48",
		extra_service_item = {
			{
				31,
				210,
				1
			},
			{
				1,
				1,
				1000
			}
		},
		time = {
			{
				{
					2026,
					9,
					8
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2026,
					9,
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
				31,
				210,
				1
			},
			{
				1,
				1,
				1000
			}
		},
		sub_display = {},
		ignorePlatform = {},
		limit_args = {},
		drop_item = {
			{
				2,
				40089,
				1
			}
		}
	}
	pg.base.pay_data_display[2095] = {
		limit_group = 111,
		name = "Battle UI Pack - Candlelit Ritual (Premium)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		id = 2095,
		subject = "Battle UI Pack - Candlelit Ritual (Premium)",
		first_text = "",
		package_sort_id = 0,
		first_icon = "",
		money = 3699,
		tip = "",
		tag = 2,
		tip_open = 0,
		gem = 0,
		cash_show = 0,
		descrip = "Contains the Battle UI - Candlelit Ritual theme and 3,060 Coins.",
		limit_type = 5,
		name_display = "Battle UI Pack - Candlelit Ritual (Premium)",
		type_order = 4,
		package_tag = "",
		picture = "ui11",
		akashi_pick = 1,
		skin_inquire_relation = 0,
		extra_service = 3,
		id_str = "com.yostaren.azurlane.pack49",
		first_pay_double = 0,
		extra_gem = 0,
		show_group = "uigift",
		limit_arg = 1,
		package_tag_open = 0,
		airijp_id = "com.yostaren.azurlane.pack49",
		extra_service_item = {
			{
				31,
				210,
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
					2026,
					9,
					8
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2026,
					9,
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
				31,
				210,
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
				40090,
				1
			}
		}
	}
	pg.base.pay_data_display[5011] = {
		limit_group = 0,
		name = "Daily Paid Pack (Day 1)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		type_order = 5,
		subject = "Daily Paid Pack (Day 1)",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 99,
		cash_show = 0,
		descrip = "Contains 60x Gems, 2x Special General Blueprints - Series 6.",
		name_display = "Daily Paid Pack (Day 1)",
		gem = 0,
		limit_arg = 1,
		limit_type = 2,
		package_tag = "",
		picture = "pack_day1",
		id_str = "com.yostaren.azurlane.bfdailybag8",
		extra_gem = 0,
		id = 5011,
		airijp_id = "com.yostaren.azurlane.bfdailybag8",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		sub_display = "",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[5012] = {
		limit_group = 0,
		name = "Daily Paid Pack (Day 2)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		type_order = 5,
		subject = "Daily Paid Pack (Day 2)",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 99,
		cash_show = 0,
		descrip = "Contains 200x Gems.",
		name_display = "Daily Paid Pack (Day 2)",
		gem = 0,
		limit_arg = 1,
		limit_type = 2,
		package_tag = "",
		picture = "pack_day2",
		id_str = "com.yostaren.azurlane.bfdailybag9",
		extra_gem = 0,
		id = 5012,
		airijp_id = "com.yostaren.azurlane.bfdailybag9",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		sub_display = "",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[5013] = {
		limit_group = 0,
		name = "Daily Paid Pack (Day 3)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		type_order = 5,
		subject = "Daily Paid Pack (Day 3)",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 99,
		cash_show = 0,
		descrip = "Contains 200x Cognitive Chips, 5x Universal T4 Parts.",
		name_display = "Daily Paid Pack (Day 3)",
		gem = 0,
		limit_arg = 1,
		limit_type = 2,
		package_tag = "",
		picture = "pack_day3",
		id_str = "com.yostaren.azurlane.bfdailybag10",
		extra_gem = 0,
		id = 5013,
		airijp_id = "com.yostaren.azurlane.bfdailybag10",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		sub_display = "",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[5014] = {
		limit_group = 0,
		name = "Daily Paid Pack (Day 4)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		type_order = 5,
		subject = "Daily Paid Pack (Day 4)",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 99,
		cash_show = 0,
		descrip = "Contains 60x Gems, 1x Prototype Bulin MKII.",
		name_display = "Daily Paid Pack (Day 4)",
		gem = 0,
		limit_arg = 1,
		limit_type = 2,
		package_tag = "",
		picture = "pack_day4",
		id_str = "com.yostaren.azurlane.bfdailybag11",
		extra_gem = 0,
		id = 5014,
		airijp_id = "com.yostaren.azurlane.bfdailybag11",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		sub_display = "",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[5015] = {
		limit_group = 0,
		name = "Daily Paid Pack (Day 5)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		type_order = 5,
		subject = "Daily Paid Pack (Day 5)",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 99,
		cash_show = 0,
		descrip = "Contains 60x T2 EXP Data Packs.",
		name_display = "Daily Paid Pack (Day 5)",
		gem = 0,
		limit_arg = 1,
		limit_type = 2,
		package_tag = "",
		picture = "pack_day5",
		id_str = "com.yostaren.azurlane.bfdailybag12",
		extra_gem = 0,
		id = 5015,
		airijp_id = "com.yostaren.azurlane.bfdailybag12",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		sub_display = "",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[5016] = {
		limit_group = 0,
		name = "Daily Paid Pack (Day 6)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		type_order = 5,
		subject = "Daily Paid Pack (Day 6)",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 99,
		cash_show = 0,
		descrip = "Contains 10x Wisdom Cubes, 5x Quick Finishers.",
		name_display = "Daily Paid Pack (Day 6)",
		gem = 0,
		limit_arg = 1,
		limit_type = 2,
		package_tag = "",
		picture = "pack_day6",
		id_str = "com.yostaren.azurlane.bfdailybag13",
		extra_gem = 0,
		id = 5016,
		airijp_id = "com.yostaren.azurlane.bfdailybag13",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		sub_display = "",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[5017] = {
		limit_group = 0,
		name = "Daily Paid Pack (Day 7)",
		descrip_extra = "*After your purchase, the Pack will be sent to your mailbox.",
		type = 0,
		second_text = "",
		type_order = 5,
		subject = "Daily Paid Pack (Day 7)",
		package_sort_id = 0,
		tip = "",
		tip_open = 0,
		money = 99,
		cash_show = 0,
		descrip = "Contains 60x Gems, 2x Special General Blueprints - Series 7.",
		name_display = "Daily Paid Pack (Day 7)",
		gem = 0,
		limit_arg = 1,
		limit_type = 2,
		package_tag = "",
		picture = "pack_day7",
		id_str = "com.yostaren.azurlane.bfdailybag14",
		extra_gem = 0,
		id = 5017,
		airijp_id = "com.yostaren.azurlane.bfdailybag14",
		first_icon = "",
		first_text = "",
		tag = 2,
		akashi_pick = 1,
		sub_display = "",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 3,
		show_group = "",
		package_tag_open = 0,
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
	}
	pg.base.pay_data_display[70001] = {
		descrip_extra = "Dual-Form Skin Purchase (Azuchi)",
		name = "Testing Courage in Crimson",
		ignorePlatform = "",
		type = 0,
		second_text = "",
		limit_group = 0,
		subject = "Testing Courage in Crimson",
		type_order = 0,
		package_sort_id = 0,
		tip = "",
		money = 1999,
		tip_open = 0,
		cash_show = 2799,
		descrip = "Testing Courage in Crimson",
		gem = 0,
		name_display = "Testing Courage in Crimson",
		limit_arg = 1,
		limit_type = 2,
		package_tag = "",
		picture = "",
		id_str = "com.yostaren.azurlane.pack50",
		extra_gem = 0,
		id = 70001,
		airijp_id = "com.yostaren.azurlane.pack50",
		display = "",
		first_icon = "",
		first_text = "",
		tag = 0,
		akashi_pick = 1,
		sub_display = "",
		skin_inquire_relation = 0,
		first_pay_double = 0,
		extra_service = 6,
		show_group = "",
		package_tag_open = 0,
		extra_service_item = {
			{
				7,
				304091,
				1
			}
		},
		time = {
			{
				{
					2026,
					9,
					8
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2026,
					9,
					30
				},
				{
					23,
					59,
					59
				}
			}
		},
		limit_args = {},
		drop_item = {}
	}
end)()
