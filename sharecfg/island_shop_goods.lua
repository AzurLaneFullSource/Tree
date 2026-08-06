pg = pg or {}
pg.island_shop_goods = rawget(pg, "island_shop_goods") or setmetatable({
	__name = "island_shop_goods"
}, confNEO)
pg.island_shop_goods.__namecode__ = true
pg.island_shop_goods.all = {
	10000,
	10001,
	10002,
	10003,
	10004,
	10005,
	10006,
	10007,
	10008,
	10009,
	10010,
	10011,
	10012,
	10013,
	10014,
	10015,
	10016,
	10017,
	10018,
	10019,
	10020,
	10021,
	10022,
	10023,
	10024,
	10025,
	10026,
	10027,
	10028,
	10029,
	10030,
	10031,
	10032,
	10033,
	10034,
	10035,
	10036,
	10037,
	10038,
	10039,
	10040,
	10041,
	10042,
	10043,
	10044,
	10045,
	10046,
	10047,
	10048,
	10049,
	10050,
	10051,
	10052,
	10053,
	10054,
	10055,
	10056,
	10057,
	10058,
	10102,
	10103,
	10104,
	10105,
	10106,
	10107,
	10108,
	10109,
	10110,
	10111,
	10112,
	10113,
	10114,
	10115,
	10116,
	10117,
	10118,
	10119,
	10120,
	10121,
	10122,
	10123,
	10124,
	10125,
	10126,
	10127,
	10128,
	10129,
	10130,
	10131,
	10132,
	10133,
	10134,
	10135,
	10136,
	10137,
	10138,
	10139,
	10140,
	10141,
	10142,
	10143,
	10144,
	10145,
	10146,
	10147,
	10148,
	10149,
	10150,
	10151,
	10152,
	10153,
	10154,
	10155,
	10156,
	10157,
	10158,
	10201,
	10202,
	10203,
	10204,
	10205,
	10206,
	10207,
	10208,
	10209,
	10210,
	10211,
	10212,
	10213,
	10214,
	10215,
	10216,
	10217,
	10218,
	10219,
	10220,
	10221,
	10222,
	10223,
	10224,
	10225,
	10226,
	10227,
	10228,
	10229,
	10230,
	10231,
	10232,
	10233,
	10234,
	10235,
	10236,
	10237,
	10238,
	10239,
	10240,
	10241,
	10242,
	10243,
	10244,
	10245,
	10246,
	10247,
	10248,
	10249,
	10250,
	10251,
	10252,
	10253,
	10254,
	10255,
	10256,
	10257,
	10258,
	10259,
	10260,
	10261,
	10262,
	10263,
	10264,
	10265,
	10266,
	10267,
	10268,
	10269,
	10301,
	10302,
	10303,
	10304,
	10305,
	10306,
	10307,
	10308,
	10309,
	10310,
	10311,
	10312,
	10313,
	10314,
	10315,
	10316,
	10317,
	10318,
	10319,
	10320,
	10321,
	10322,
	10323,
	10324,
	10325,
	10326,
	10327,
	10328,
	10329,
	10330,
	10331,
	10332,
	10333,
	10334,
	10335,
	10336,
	10337,
	10338,
	10339,
	10340,
	10341,
	10342,
	10343,
	10344,
	10345,
	10346,
	10347,
	10348,
	10349,
	10350,
	10351,
	10352,
	10353,
	10354,
	10355,
	10356,
	10357,
	10358,
	10359,
	10360,
	10361,
	10362,
	10363,
	10364,
	10365,
	10366,
	10367,
	10368,
	10369,
	10401,
	10402,
	10403,
	10404,
	10405,
	10406,
	10407,
	10408,
	10409,
	10410,
	10411,
	10412,
	10413,
	10414,
	10415,
	10416,
	10417,
	10418,
	10419,
	10420,
	10421,
	10422,
	10423,
	10424,
	10425,
	10426,
	10427,
	10428,
	10429,
	10430,
	10431,
	10432,
	10433,
	10434,
	10435,
	10436,
	10437,
	10438,
	10439,
	10440,
	10441,
	10442,
	10443,
	10444,
	10445,
	10446,
	10447,
	10448,
	10449,
	10450,
	10451,
	10452,
	10453,
	10454,
	10455,
	10456,
	10457,
	10458,
	10459,
	10460,
	10461,
	10462,
	10463,
	10464,
	10465,
	10466,
	10467,
	10468,
	10469,
	10470,
	10471,
	10472,
	10473,
	10474,
	10475,
	103000,
	103001,
	103002,
	103003,
	103004,
	111500,
	111502,
	111503,
	111101,
	111102,
	111103,
	111104,
	111105,
	111106,
	111107,
	111108,
	111201,
	111202,
	111203,
	111204,
	111205,
	111206,
	111207,
	111208,
	411000,
	411001,
	411002,
	411003,
	411004,
	411005,
	411006,
	411007,
	411008,
	411009,
	411010,
	411011,
	411012,
	411014,
	411015,
	411016,
	411017,
	411018,
	411019,
	411020,
	411021,
	411022,
	411023,
	411024,
	411025,
	411026,
	411027,
	411028,
	412000,
	412001,
	412002,
	412003,
	4600001,
	4600002,
	4600003,
	4620004,
	4630005,
	4610003,
	4620007,
	4630008,
	4610006,
	4620008,
	4630009,
	4610008,
	5010001,
	5020001,
	5030001,
	5010002,
	5020002,
	5030002,
	5010003,
	5020003,
	5030003,
	5010004,
	5020004,
	5030004,
	471070301,
	473120101,
	471051701,
	471011001,
	475060101,
	474030301,
	471011701,
	472012101,
	473031101,
	472021201,
	479600011,
	99000101,
	99000102,
	99000201,
	99000202,
	99000301,
	99000302,
	461060015
}
pg.base = pg.base or {}
pg.base.island_shop_goods = {}

;(function()
	pg.base.island_shop_goods[10000] = {
		desc = "Purchase to receive Floating Gun, a floating Commander outfit.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Floating Gun",
		icon = "IslandDressIcon/dress_1020001",
		goods_detail_type = 2,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10000,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				46,
				1020001,
				1
			}
		}
	}
	pg.base.island_shop_goods[10001] = {
		desc = "Cooperation and trust begins with a friendly handshake.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Shake Hands",
		icon = "IslandActionIcon/handshake",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 500,
		discount = 0,
		groups_detail_type = "",
		id = 10001,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			5000
		},
		items = {
			{
				51,
				2001,
				1
			}
		}
	}
	pg.base.island_shop_goods[10002] = {
		desc = "Nothing screams \"victory\" like an excited jump.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Excited Jump",
		icon = "IslandActionIcon/vjump",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 500,
		discount = 0,
		groups_detail_type = "",
		id = 10002,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			5000
		},
		items = {
			{
				51,
				1008,
				1
			}
		}
	}
	pg.base.island_shop_goods[10003] = {
		desc = "You've worked hard for these gains. They deserve to be showed to the whole world.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Flaunt Muscles",
		icon = "IslandActionIcon/muscle",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 500,
		discount = 0,
		groups_detail_type = "",
		id = 10003,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			5000
		},
		items = {
			{
				51,
				1011,
				1
			}
		}
	}
	pg.base.island_shop_goods[10004] = {
		desc = "Tickets that glitter like the stars. Can be used to draw prizes in the Stellar Prize Draw. When the current run of the Stellar Prize Draw ends, any Stellar Tickets left over will be automatically used to draw prizes or be converted to Gems.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Stellar Tickets",
		icon = "IslandGoodsIcon/170000",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10004,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				8,
				170000,
				1
			}
		}
	}
	pg.base.island_shop_goods[10005] = {
		desc = "Fresh wheat straight from the fields. The base ingredient needed to make flour.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Wheat",
		icon = "IslandProps/item_2000",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10005,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2000,
				10
			}
		}
	}
	pg.base.island_shop_goods[10006] = {
		desc = "Ripe, golden corn. It lends a sweet smell to the fields.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Corn",
		icon = "IslandProps/item_2001",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10006,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2001,
				10
			}
		}
	}
	pg.base.island_shop_goods[10007] = {
		desc = "High-quality grass. Provides life in abundance to the farm!",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Grass",
		icon = "IslandProps/item_2008",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10007,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2008,
				10
			}
		}
	}
	pg.base.island_shop_goods[10008] = {
		desc = "White, high-quality rice. Contains plentiful starch and granular protein.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Rice",
		icon = "IslandProps/item_2002",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10008,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2002,
				10
			}
		}
	}
	pg.base.island_shop_goods[10009] = {
		desc = "Crisp and delicious napa cabbage. It's straight from the farm!",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Napa Cabbage",
		icon = "IslandProps/item_2003",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10009,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2003,
				10
			}
		}
	}
	pg.base.island_shop_goods[10010] = {
		desc = "Round, fluffy, and filled with protein. Has all sorts of uses, not just in cooking, but in manufacturing as well.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Soy Beans",
		icon = "IslandProps/item_2006",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10010,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2006,
				10
			}
		}
	}
	pg.base.island_shop_goods[10011] = {
		desc = "The king of starch in the vegetable world. Can be prepared in all kinds of ways.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Potato",
		icon = "IslandProps/item_2005",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 40,
		discount = 0,
		groups_detail_type = "",
		id = 10011,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			400
		},
		items = {
			{
				41,
				2005,
				10
			}
		}
	}
	pg.base.island_shop_goods[10012] = {
		desc = "A book containing fundamental knowledge on island living. Used to slightly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 25,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T1",
		icon = "IslandProps/item_100001",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10012,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				100001,
				1
			}
		}
	}
	pg.base.island_shop_goods[10013] = {
		desc = "A book containing detailed knowledge on island living. Used to moderately increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T2",
		icon = "IslandProps/item_100002",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10013,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10014] = {
		desc = "A book containing abundant knowledge on island living. Used to greatly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T3",
		icon = "IslandProps/item_100003",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1600,
		discount = 0,
		groups_detail_type = "",
		id = 10014,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			16000
		},
		items = {
			{
				41,
				100003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10015] = {
		desc = "A book containing fundamental knowledge on production techniques. Used to slightly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T1",
		icon = "IslandProps/item_100101",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 200,
		discount = 0,
		groups_detail_type = "",
		id = 10015,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				100101,
				1
			}
		}
	}
	pg.base.island_shop_goods[10016] = {
		desc = "A book containing detailed knowledge on production techniques. Used to moderately increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T2",
		icon = "IslandProps/item_100102",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10016,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100102,
				1
			}
		}
	}
	pg.base.island_shop_goods[10017] = {
		desc = "A book containing abundant knowledge on production techniques. Used to greatly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 6,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T3",
		icon = "IslandProps/item_100103",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1500,
		discount = 0,
		groups_detail_type = "",
		id = 10017,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			15000
		},
		items = {
			{
				41,
				100103,
				1
			}
		}
	}
	pg.base.island_shop_goods[10018] = {
		desc = "A crystal of island development experience. Required to Limit Break characters.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Island Development Gem",
		icon = "IslandProps/item_100201",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10018,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_shop_goods[10019] = {
		desc = "A hardcover book that smells of ink and sports a classic vibe. It's worthy of going on your table and being reread time and time again.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Hardcover Book",
		icon = "IslandGoodsIcon/gift02",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10019,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10020] = {
		desc = "A gorgeous, fresh bouquet. Its flowers are brimming with color and life, and they promise joy for the days to come.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Bouquet",
		icon = "IslandGoodsIcon/gift03",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10020,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10021] = {
		desc = "This ceremonial sword with a flowing silhouette gives off the cold brilliance of steel. It silently speaks of order and majesty.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Ceremonial Sword",
		icon = "IslandGoodsIcon/gift04",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10021,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180004,
				1
			}
		}
	}
	pg.base.island_shop_goods[10022] = {
		desc = "An adorable stuffed animal that's soft to the touch. Give it a hug, and its fluffy warmth and innocent smile will soften your heart.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Fluffy Stuffed Animal",
		icon = "IslandGoodsIcon/gift05",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10022,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180005,
				1
			}
		}
	}
	pg.base.island_shop_goods[10023] = {
		desc = "The sands of time have poured over this ornament, turning it into an elegant antique. Quietly, it lends an air of tranquility to a room.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Antique Ornament",
		icon = "IslandGoodsIcon/gift06",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10023,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180006,
				1
			}
		}
	}
	pg.base.island_shop_goods[10024] = {
		desc = "An accessory that, although understated, glimmers with exceptional craftsmanship. It adds just a little light to every moment of one's life.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Exquisite Accessory",
		icon = "IslandGoodsIcon/gift07",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10024,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180007,
				1
			}
		}
	}
	pg.base.island_shop_goods[10025] = {
		desc = "A wonderfully pure aroma hides inside this modest flask. Just one spray of this fragrance brings out tones of refined class.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Premium Perfume",
		icon = "IslandGoodsIcon/gift08",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10025,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180008,
				1
			}
		}
	}
	pg.base.island_shop_goods[10026] = {
		desc = "An entertainment system that will fill up every moment of your spare time. This thoughtful gift contains just about all the content you need for a fun play session.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Game Console Set",
		icon = "IslandGoodsIcon/gift09",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10026,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180009,
				1
			}
		}
	}
	pg.base.island_shop_goods[10027] = {
		desc = "Tickets that glitter like the stars. Can be used to draw prizes in the Stellar Prize Draw. When the current run of the Stellar Prize Draw ends, any Stellar Tickets left over will be automatically used to draw prizes or be converted to Gems.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Stellar Tickets",
		icon = "IslandGoodsIcon/170000",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10027,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				8,
				170000,
				1
			}
		}
	}
	pg.base.island_shop_goods[10028] = {
		desc = "A book containing fundamental knowledge on island living. Used to slightly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 25,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T1",
		icon = "IslandProps/item_100001",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10028,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				100001,
				1
			}
		}
	}
	pg.base.island_shop_goods[10029] = {
		desc = "A book containing detailed knowledge on island living. Used to moderately increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T2",
		icon = "IslandProps/item_100002",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10029,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10030] = {
		desc = "A book containing abundant knowledge on island living. Used to greatly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T3",
		icon = "IslandProps/item_100003",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1600,
		discount = 0,
		groups_detail_type = "",
		id = 10030,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			16000
		},
		items = {
			{
				41,
				100003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10031] = {
		desc = "A book containing fundamental knowledge on production techniques. Used to slightly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T1",
		icon = "IslandProps/item_100101",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 200,
		discount = 0,
		groups_detail_type = "",
		id = 10031,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				100101,
				1
			}
		}
	}
	pg.base.island_shop_goods[10032] = {
		desc = "A book containing detailed knowledge on production techniques. Used to moderately increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T2",
		icon = "IslandProps/item_100102",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10032,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100102,
				1
			}
		}
	}
	pg.base.island_shop_goods[10033] = {
		desc = "A book containing abundant knowledge on production techniques. Used to greatly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 8,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T3",
		icon = "IslandProps/item_100103",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1500,
		discount = 0,
		groups_detail_type = "",
		id = 10033,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			15000
		},
		items = {
			{
				41,
				100103,
				1
			}
		}
	}
	pg.base.island_shop_goods[10034] = {
		desc = "A crystal of island development experience. Required to Limit Break characters.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 3,
		limited_show = 1,
		unlock = "",
		goods_name = "Island Development Gem",
		icon = "IslandProps/item_100201",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10034,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_shop_goods[10035] = {
		desc = "A hardcover book that smells of ink and sports a classic vibe. It's worthy of going on your table and being reread time and time again.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Hardcover Book",
		icon = "IslandGoodsIcon/gift02",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10035,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10036] = {
		desc = "A gorgeous, fresh bouquet. Its flowers are brimming with color and life, and they promise joy for the days to come.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Bouquet",
		icon = "IslandGoodsIcon/gift03",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10036,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10037] = {
		desc = "This ceremonial sword with a flowing silhouette gives off the cold brilliance of steel. It silently speaks of order and majesty.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Ceremonial Sword",
		icon = "IslandGoodsIcon/gift04",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10037,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180004,
				1
			}
		}
	}
	pg.base.island_shop_goods[10038] = {
		desc = "An adorable stuffed animal that's soft to the touch. Give it a hug, and its fluffy warmth and innocent smile will soften your heart.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Fluffy Stuffed Animal",
		icon = "IslandGoodsIcon/gift05",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10038,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180005,
				1
			}
		}
	}
	pg.base.island_shop_goods[10039] = {
		desc = "The sands of time have poured over this ornament, turning it into an elegant antique. Quietly, it lends an air of tranquility to a room.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Antique Ornament",
		icon = "IslandGoodsIcon/gift06",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10039,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180006,
				1
			}
		}
	}
	pg.base.island_shop_goods[10040] = {
		desc = "An accessory that, although understated, glimmers with exceptional craftsmanship. It adds just a little light to every moment of one's life.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Exquisite Accessory",
		icon = "IslandGoodsIcon/gift07",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10040,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180007,
				1
			}
		}
	}
	pg.base.island_shop_goods[10041] = {
		desc = "A wonderfully pure aroma hides inside this modest flask. Just one spray of this fragrance brings out tones of refined class.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Premium Perfume",
		icon = "IslandGoodsIcon/gift08",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10041,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180008,
				1
			}
		}
	}
	pg.base.island_shop_goods[10042] = {
		desc = "An entertainment system that will fill up every moment of your spare time. This thoughtful gift contains just about all the content you need for a fun play session.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Game Console Set",
		icon = "IslandGoodsIcon/gift09",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10042,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180009,
				1
			}
		}
	}
	pg.base.island_shop_goods[10043] = {
		desc = "Tickets that glitter like the stars. Can be used to draw prizes in the Stellar Prize Draw. When the current run of the Stellar Prize Draw ends, any Stellar Tickets left over will be automatically used to draw prizes or be converted to Gems.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Stellar Tickets",
		icon = "IslandGoodsIcon/170000",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10043,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				8,
				170000,
				1
			}
		}
	}
	pg.base.island_shop_goods[10044] = {
		desc = "A book containing fundamental knowledge on island living. Used to slightly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 50,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T1",
		icon = "IslandProps/item_100001",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10044,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				100001,
				1
			}
		}
	}
	pg.base.island_shop_goods[10045] = {
		desc = "A book containing detailed knowledge on island living. Used to moderately increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 15,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T2",
		icon = "IslandProps/item_100002",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10045,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10046] = {
		desc = "A book containing abundant knowledge on island living. Used to greatly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T3",
		icon = "IslandProps/item_100003",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1600,
		discount = 0,
		groups_detail_type = "",
		id = 10046,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			16000
		},
		items = {
			{
				41,
				100003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10047] = {
		desc = "A book containing fundamental knowledge on production techniques. Used to slightly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T1",
		icon = "IslandProps/item_100101",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 200,
		discount = 0,
		groups_detail_type = "",
		id = 10047,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				100101,
				1
			}
		}
	}
	pg.base.island_shop_goods[10048] = {
		desc = "A book containing detailed knowledge on production techniques. Used to moderately increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T2",
		icon = "IslandProps/item_100102",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10048,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100102,
				1
			}
		}
	}
	pg.base.island_shop_goods[10049] = {
		desc = "A book containing abundant knowledge on production techniques. Used to greatly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T3",
		icon = "IslandProps/item_100103",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1500,
		discount = 0,
		groups_detail_type = "",
		id = 10049,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			15000
		},
		items = {
			{
				41,
				100103,
				1
			}
		}
	}
	pg.base.island_shop_goods[10050] = {
		desc = "A crystal of island development experience. Required to Limit Break characters.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Island Development Gem",
		icon = "IslandProps/item_100201",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10050,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_shop_goods[10051] = {
		desc = "A hardcover book that smells of ink and sports a classic vibe. It's worthy of going on your table and being reread time and time again.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Hardcover Book",
		icon = "IslandGoodsIcon/gift02",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10051,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10052] = {
		desc = "A gorgeous, fresh bouquet. Its flowers are brimming with color and life, and they promise joy for the days to come.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Bouquet",
		icon = "IslandGoodsIcon/gift03",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10052,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10053] = {
		desc = "This ceremonial sword with a flowing silhouette gives off the cold brilliance of steel. It silently speaks of order and majesty.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Ceremonial Sword",
		icon = "IslandGoodsIcon/gift04",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10053,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180004,
				1
			}
		}
	}
	pg.base.island_shop_goods[10054] = {
		desc = "An adorable stuffed animal that's soft to the touch. Give it a hug, and its fluffy warmth and innocent smile will soften your heart.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Fluffy Stuffed Animal",
		icon = "IslandGoodsIcon/gift05",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10054,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180005,
				1
			}
		}
	}
	pg.base.island_shop_goods[10055] = {
		desc = "The sands of time have poured over this ornament, turning it into an elegant antique. Quietly, it lends an air of tranquility to a room.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Antique Ornament",
		icon = "IslandGoodsIcon/gift06",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10055,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180006,
				1
			}
		}
	}
	pg.base.island_shop_goods[10056] = {
		desc = "An accessory that, although understated, glimmers with exceptional craftsmanship. It adds just a little light to every moment of one's life.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Exquisite Accessory",
		icon = "IslandGoodsIcon/gift07",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10056,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180007,
				1
			}
		}
	}
	pg.base.island_shop_goods[10057] = {
		desc = "A wonderfully pure aroma hides inside this modest flask. Just one spray of this fragrance brings out tones of refined class.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Premium Perfume",
		icon = "IslandGoodsIcon/gift08",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10057,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180008,
				1
			}
		}
	}
	pg.base.island_shop_goods[10058] = {
		desc = "An entertainment system that will fill up every moment of your spare time. This thoughtful gift contains just about all the content you need for a fun play session.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Game Console Set",
		icon = "IslandGoodsIcon/gift09",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10058,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180009,
				1
			}
		}
	}
	pg.base.island_shop_goods[10102] = {
		desc = "Purchase to receive Hay Bale Shadow, a floating Commander outfit.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Hay Bale Shadow",
		icon = "IslandDressIcon/dress_1010007",
		goods_detail_type = 2,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10102,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				46,
				1010007,
				1
			}
		}
	}
	pg.base.island_shop_goods[10103] = {
		desc = "The hero is here! Express your style and enthusiasm to the world.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "The Hero is Here",
		icon = "IslandActionIcon/herocoming",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 500,
		discount = 0,
		groups_detail_type = "",
		id = 10103,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			5000
		},
		items = {
			{
				51,
				1013,
				1
			}
		}
	}
	pg.base.island_shop_goods[10104] = {
		desc = "Tickets that glitter like the stars. Can be used to draw prizes in the Stellar Prize Draw.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Stellar Tickets",
		icon = "IslandGoodsIcon/170000",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10104,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				8,
				170000,
				1
			}
		}
	}
	pg.base.island_shop_goods[10105] = {
		desc = "Fresh wheat straight from the fields. The base ingredient needed to make flour.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Wheat",
		icon = "IslandProps/item_2000",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10105,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2000,
				10
			}
		}
	}
	pg.base.island_shop_goods[10106] = {
		desc = "Ripe, golden corn. It lends a sweet smell to the fields.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Corn",
		icon = "IslandProps/item_2001",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10106,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2001,
				10
			}
		}
	}
	pg.base.island_shop_goods[10107] = {
		desc = "High-quality grass. Provides life in abundance to the farm!",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Grass",
		icon = "IslandProps/item_2008",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10107,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2008,
				10
			}
		}
	}
	pg.base.island_shop_goods[10108] = {
		desc = "White, high-quality rice. Contains plentiful starch and granular protein.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Rice",
		icon = "IslandProps/item_2002",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10108,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2002,
				10
			}
		}
	}
	pg.base.island_shop_goods[10109] = {
		desc = "Crisp and delicious napa cabbage. It's straight from the farm!",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Napa Cabbage",
		icon = "IslandProps/item_2003",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10109,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2003,
				10
			}
		}
	}
	pg.base.island_shop_goods[10110] = {
		desc = "Round, fluffy, and filled with protein. Has all sorts of uses, not just in cooking, but in manufacturing as well.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Soy Beans",
		icon = "IslandProps/item_2006",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10110,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2006,
				10
			}
		}
	}
	pg.base.island_shop_goods[10111] = {
		desc = "The king of starch in the vegetable world. Can be prepared in all kinds of ways.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Potato",
		icon = "IslandProps/item_2005",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 40,
		discount = 0,
		groups_detail_type = "",
		id = 10111,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			400
		},
		items = {
			{
				41,
				2005,
				10
			}
		}
	}
	pg.base.island_shop_goods[10112] = {
		desc = "A book containing fundamental knowledge on island living. Used to slightly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 25,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T1",
		icon = "IslandProps/item_100001",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10112,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				100001,
				1
			}
		}
	}
	pg.base.island_shop_goods[10113] = {
		desc = "A book containing detailed knowledge on island living. Used to moderately increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T2",
		icon = "IslandProps/item_100002",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10113,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10114] = {
		desc = "A book containing abundant knowledge on island living. Used to greatly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T3",
		icon = "IslandProps/item_100003",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1600,
		discount = 0,
		groups_detail_type = "",
		id = 10114,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			16000
		},
		items = {
			{
				41,
				100003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10115] = {
		desc = "A book containing fundamental knowledge on production techniques. Used to slightly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T1",
		icon = "IslandProps/item_100101",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 200,
		discount = 0,
		groups_detail_type = "",
		id = 10115,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				100101,
				1
			}
		}
	}
	pg.base.island_shop_goods[10116] = {
		desc = "A book containing detailed knowledge on production techniques. Used to moderately increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T2",
		icon = "IslandProps/item_100102",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10116,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100102,
				1
			}
		}
	}
	pg.base.island_shop_goods[10117] = {
		desc = "A book containing abundant knowledge on production techniques. Used to greatly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 6,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T3",
		icon = "IslandProps/item_100103",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1500,
		discount = 0,
		groups_detail_type = "",
		id = 10117,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			15000
		},
		items = {
			{
				41,
				100103,
				1
			}
		}
	}
	pg.base.island_shop_goods[10118] = {
		desc = "A crystal of island development experience. Required to Limit Break characters.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Island Development Gem",
		icon = "IslandProps/item_100201",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10118,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_shop_goods[10119] = {
		desc = "A hardcover book that smells of ink and sports a classic vibe. It's worthy of going on your table and being reread time and time again.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Hardcover Book",
		icon = "IslandGoodsIcon/gift02",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10119,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10120] = {
		desc = "A gorgeous, fresh bouquet. Its flowers are brimming with color and life, and they promise joy for the days to come.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Bouquet",
		icon = "IslandGoodsIcon/gift03",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10120,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10121] = {
		desc = "This ceremonial sword with a flowing silhouette gives off the cold brilliance of steel. It silently speaks of order and majesty.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Ceremonial Sword",
		icon = "IslandGoodsIcon/gift04",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10121,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180004,
				1
			}
		}
	}
	pg.base.island_shop_goods[10122] = {
		desc = "An adorable stuffed animal that's soft to the touch. Give it a hug, and its fluffy warmth and innocent smile will soften your heart.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Fluffy Stuffed Animal",
		icon = "IslandGoodsIcon/gift05",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10122,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180005,
				1
			}
		}
	}
	pg.base.island_shop_goods[10123] = {
		desc = "The sands of time have poured over this ornament, turning it into an elegant antique. Quietly, it lends an air of tranquility to a room.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Antique Ornament",
		icon = "IslandGoodsIcon/gift06",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10123,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180006,
				1
			}
		}
	}
	pg.base.island_shop_goods[10124] = {
		desc = "An accessory that, although understated, glimmers with exceptional craftsmanship. It adds just a little light to every moment of one's life.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Exquisite Accessory",
		icon = "IslandGoodsIcon/gift07",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10124,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180007,
				1
			}
		}
	}
	pg.base.island_shop_goods[10125] = {
		desc = "A wonderfully pure aroma hides inside this modest flask. Just one spray of this fragrance brings out tones of refined class.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Premium Perfume",
		icon = "IslandGoodsIcon/gift08",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10125,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180008,
				1
			}
		}
	}
	pg.base.island_shop_goods[10126] = {
		desc = "An entertainment system that will fill up every moment of your spare time. This thoughtful gift contains just about all the content you need for a fun play session.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Game Console Set",
		icon = "IslandGoodsIcon/gift09",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10126,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180009,
				1
			}
		}
	}
	pg.base.island_shop_goods[10127] = {
		desc = "Tickets that glitter like the stars. Can be used to draw prizes in the Stellar Prize Draw.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Stellar Tickets",
		icon = "IslandGoodsIcon/170000",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10127,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				8,
				170000,
				1
			}
		}
	}
	pg.base.island_shop_goods[10128] = {
		desc = "A book containing fundamental knowledge on island living. Used to slightly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 25,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T1",
		icon = "IslandProps/item_100001",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10128,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				100001,
				1
			}
		}
	}
	pg.base.island_shop_goods[10129] = {
		desc = "A book containing detailed knowledge on island living. Used to moderately increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T2",
		icon = "IslandProps/item_100002",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10129,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10130] = {
		desc = "A book containing abundant knowledge on island living. Used to greatly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T3",
		icon = "IslandProps/item_100003",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1600,
		discount = 0,
		groups_detail_type = "",
		id = 10130,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			16000
		},
		items = {
			{
				41,
				100003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10131] = {
		desc = "A book containing fundamental knowledge on production techniques. Used to slightly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T1",
		icon = "IslandProps/item_100101",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 200,
		discount = 0,
		groups_detail_type = "",
		id = 10131,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				100101,
				1
			}
		}
	}
	pg.base.island_shop_goods[10132] = {
		desc = "A book containing detailed knowledge on production techniques. Used to moderately increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T2",
		icon = "IslandProps/item_100102",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10132,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100102,
				1
			}
		}
	}
	pg.base.island_shop_goods[10133] = {
		desc = "A book containing abundant knowledge on production techniques. Used to greatly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 8,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T3",
		icon = "IslandProps/item_100103",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1500,
		discount = 0,
		groups_detail_type = "",
		id = 10133,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			15000
		},
		items = {
			{
				41,
				100103,
				1
			}
		}
	}
	pg.base.island_shop_goods[10134] = {
		desc = "A crystal of island development experience. Required to Limit Break characters.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 3,
		limited_show = 1,
		unlock = "",
		goods_name = "Island Development Gem",
		icon = "IslandProps/item_100201",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10134,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_shop_goods[10135] = {
		desc = "A hardcover book that smells of ink and sports a classic vibe. It's worthy of going on your table and being reread time and time again.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Hardcover Book",
		icon = "IslandGoodsIcon/gift02",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10135,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10136] = {
		desc = "A gorgeous, fresh bouquet. Its flowers are brimming with color and life, and they promise joy for the days to come.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Bouquet",
		icon = "IslandGoodsIcon/gift03",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10136,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10137] = {
		desc = "This ceremonial sword with a flowing silhouette gives off the cold brilliance of steel. It silently speaks of order and majesty.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Ceremonial Sword",
		icon = "IslandGoodsIcon/gift04",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10137,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180004,
				1
			}
		}
	}
	pg.base.island_shop_goods[10138] = {
		desc = "An adorable stuffed animal that's soft to the touch. Give it a hug, and its fluffy warmth and innocent smile will soften your heart.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Fluffy Stuffed Animal",
		icon = "IslandGoodsIcon/gift05",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10138,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180005,
				1
			}
		}
	}
	pg.base.island_shop_goods[10139] = {
		desc = "The sands of time have poured over this ornament, turning it into an elegant antique. Quietly, it lends an air of tranquility to a room.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Antique Ornament",
		icon = "IslandGoodsIcon/gift06",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10139,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180006,
				1
			}
		}
	}
	pg.base.island_shop_goods[10140] = {
		desc = "An accessory that, although understated, glimmers with exceptional craftsmanship. It adds just a little light to every moment of one's life.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Exquisite Accessory",
		icon = "IslandGoodsIcon/gift07",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10140,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180007,
				1
			}
		}
	}
	pg.base.island_shop_goods[10141] = {
		desc = "A wonderfully pure aroma hides inside this modest flask. Just one spray of this fragrance brings out tones of refined class.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Premium Perfume",
		icon = "IslandGoodsIcon/gift08",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10141,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180008,
				1
			}
		}
	}
	pg.base.island_shop_goods[10142] = {
		desc = "An entertainment system that will fill up every moment of your spare time. This thoughtful gift contains just about all the content you need for a fun play session.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Game Console Set",
		icon = "IslandGoodsIcon/gift09",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10142,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180009,
				1
			}
		}
	}
end)()
;(function()
	pg.base.island_shop_goods[10143] = {
		desc = "Tickets that glitter like the stars. Can be used to draw prizes in the Stellar Prize Draw.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Stellar Tickets",
		icon = "IslandGoodsIcon/170000",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10143,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				8,
				170000,
				1
			}
		}
	}
	pg.base.island_shop_goods[10144] = {
		desc = "A book containing fundamental knowledge on island living. Used to slightly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 50,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T1",
		icon = "IslandProps/item_100001",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10144,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				100001,
				1
			}
		}
	}
	pg.base.island_shop_goods[10145] = {
		desc = "A book containing detailed knowledge on island living. Used to moderately increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 15,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T2",
		icon = "IslandProps/item_100002",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10145,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10146] = {
		desc = "A book containing abundant knowledge on island living. Used to greatly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T3",
		icon = "IslandProps/item_100003",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1600,
		discount = 0,
		groups_detail_type = "",
		id = 10146,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			16000
		},
		items = {
			{
				41,
				100003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10147] = {
		desc = "A book containing fundamental knowledge on production techniques. Used to slightly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T1",
		icon = "IslandProps/item_100101",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 200,
		discount = 0,
		groups_detail_type = "",
		id = 10147,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				100101,
				1
			}
		}
	}
	pg.base.island_shop_goods[10148] = {
		desc = "A book containing detailed knowledge on production techniques. Used to moderately increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T2",
		icon = "IslandProps/item_100102",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10148,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100102,
				1
			}
		}
	}
	pg.base.island_shop_goods[10149] = {
		desc = "A book containing abundant knowledge on production techniques. Used to greatly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T3",
		icon = "IslandProps/item_100103",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1500,
		discount = 0,
		groups_detail_type = "",
		id = 10149,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			15000
		},
		items = {
			{
				41,
				100103,
				1
			}
		}
	}
	pg.base.island_shop_goods[10150] = {
		desc = "A crystal of island development experience. Required to Limit Break characters.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Island Development Gem",
		icon = "IslandProps/item_100201",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10150,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_shop_goods[10151] = {
		desc = "A hardcover book that smells of ink and sports a classic vibe. It's worthy of going on your table and being reread time and time again.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Hardcover Book",
		icon = "IslandGoodsIcon/gift02",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10151,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10152] = {
		desc = "A gorgeous, fresh bouquet. Its flowers are brimming with color and life, and they promise joy for the days to come.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Bouquet",
		icon = "IslandGoodsIcon/gift03",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10152,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10153] = {
		desc = "This ceremonial sword with a flowing silhouette gives off the cold brilliance of steel. It silently speaks of order and majesty.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Ceremonial Sword",
		icon = "IslandGoodsIcon/gift04",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10153,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180004,
				1
			}
		}
	}
	pg.base.island_shop_goods[10154] = {
		desc = "An adorable stuffed animal that's soft to the touch. Give it a hug, and its fluffy warmth and innocent smile will soften your heart.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Fluffy Stuffed Animal",
		icon = "IslandGoodsIcon/gift05",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10154,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180005,
				1
			}
		}
	}
	pg.base.island_shop_goods[10155] = {
		desc = "The sands of time have poured over this ornament, turning it into an elegant antique. Quietly, it lends an air of tranquility to a room.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Antique Ornament",
		icon = "IslandGoodsIcon/gift06",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10155,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180006,
				1
			}
		}
	}
	pg.base.island_shop_goods[10156] = {
		desc = "An accessory that, although understated, glimmers with exceptional craftsmanship. It adds just a little light to every moment of one's life.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Exquisite Accessory",
		icon = "IslandGoodsIcon/gift07",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10156,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180007,
				1
			}
		}
	}
	pg.base.island_shop_goods[10157] = {
		desc = "A wonderfully pure aroma hides inside this modest flask. Just one spray of this fragrance brings out tones of refined class.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Premium Perfume",
		icon = "IslandGoodsIcon/gift08",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10157,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180008,
				1
			}
		}
	}
	pg.base.island_shop_goods[10158] = {
		desc = "An entertainment system that will fill up every moment of your spare time. This thoughtful gift contains just about all the content you need for a fun play session.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Game Console Set",
		icon = "IslandGoodsIcon/gift09",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10158,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180009,
				1
			}
		}
	}
	pg.base.island_shop_goods[10201] = {
		desc = "Purchase to receive Ribbon Wings of Purity, a character outfit that goes on the back.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Ribbon Wings of Purity",
		icon = "IslandDressIcon/dress_2010004",
		goods_detail_type = 2,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10201,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				46,
				2010004,
				1
			}
		}
	}
	pg.base.island_shop_goods[10202] = {
		desc = "Purchase to receive White Duster, a floating character outfit.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "White Duster",
		icon = "IslandDressIcon/dress_2020005",
		goods_detail_type = 2,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10202,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				46,
				2020005,
				1
			}
		}
	}
	pg.base.island_shop_goods[10203] = {
		desc = "Purchase to receive Laced Imprints, a character outfit that goes in the trail slot.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Laced Imprints",
		icon = "IslandDressIcon/dress_2030006",
		goods_detail_type = 2,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10203,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				46,
				2030006,
				1
			}
		}
	}
	pg.base.island_shop_goods[10204] = {
		desc = "Action – Stretch",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Stretch",
		icon = "IslandActionIcon/stretch",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 500,
		discount = 0,
		groups_detail_type = "",
		id = 10204,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			5000
		},
		items = {
			{
				51,
				1014,
				1
			}
		}
	}
	pg.base.island_shop_goods[10205] = {
		desc = "Action – Cower",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Cower",
		icon = "IslandActionIcon/fearshake",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 500,
		discount = 0,
		groups_detail_type = "",
		id = 10205,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			5000
		},
		items = {
			{
				51,
				1015,
				1
			}
		}
	}
	pg.base.island_shop_goods[10206] = {
		desc = "Action - Clench Fists",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Clench Fists",
		icon = "IslandActionIcon/holdfist",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 500,
		discount = 0,
		groups_detail_type = "",
		id = 10206,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			5000
		},
		items = {
			{
				51,
				1016,
				1
			}
		}
	}
	pg.base.island_shop_goods[10207] = {
		desc = "Action – Smug",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Smug",
		icon = "IslandActionIcon/vouch",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 500,
		discount = 0,
		groups_detail_type = "",
		id = 10207,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			5000
		},
		items = {
			{
				51,
				1017,
				1
			}
		}
	}
	pg.base.island_shop_goods[10208] = {
		desc = "An Island Authority Permit for William D. Porter. Use it to give the character the credentials to visit the island freely.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Island Authority Permit: William D. Porter",
		icon = "IslandProps/item_200016",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20000,
		discount = 0,
		groups_detail_type = "",
		id = 10208,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200000
		},
		items = {
			{
				44,
				10110,
				1
			}
		}
	}
	pg.base.island_shop_goods[10209] = {
		desc = "Tickets that glitter like the stars. Can be used to draw prizes in the Stellar Prize Draw. When the current run of the Stellar Prize Draw ends, any Stellar Tickets left over will be automatically used to draw prizes or be converted to Gems.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Stellar Tickets",
		icon = "IslandGoodsIcon/170000",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10209,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				8,
				170002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10210] = {
		desc = "Fresh wheat straight from the fields. The base ingredient needed to make flour.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Wheat",
		icon = "IslandProps/item_2000",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10210,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2000,
				10
			}
		}
	}
	pg.base.island_shop_goods[10211] = {
		desc = "Ripe, golden corn. It lends a sweet smell to the fields.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Corn",
		icon = "IslandProps/item_2001",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10211,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2001,
				10
			}
		}
	}
	pg.base.island_shop_goods[10212] = {
		desc = "High-quality grass. Provides life in abundance to the farm!",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Grass",
		icon = "IslandProps/item_2008",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10212,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2008,
				10
			}
		}
	}
	pg.base.island_shop_goods[10213] = {
		desc = "White, high-quality rice. Contains plentiful starch and granular protein.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Rice",
		icon = "IslandProps/item_2002",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10213,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2002,
				10
			}
		}
	}
	pg.base.island_shop_goods[10214] = {
		desc = "Crisp and delicious napa cabbage. It's straight from the farm!",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Napa Cabbage",
		icon = "IslandProps/item_2003",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10214,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2003,
				10
			}
		}
	}
	pg.base.island_shop_goods[10215] = {
		desc = "Round, fluffy, and filled with protein. Has all sorts of uses, not just in cooking, but in manufacturing as well.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Soy Beans",
		icon = "IslandProps/item_2006",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10215,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2006,
				10
			}
		}
	}
	pg.base.island_shop_goods[10216] = {
		desc = "The king of starch in the vegetable world. Can be prepared in all kinds of ways.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Potato",
		icon = "IslandProps/item_2005",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 40,
		discount = 0,
		groups_detail_type = "",
		id = 10216,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			400
		},
		items = {
			{
				41,
				2005,
				10
			}
		}
	}
	pg.base.island_shop_goods[10217] = {
		desc = "A book containing fundamental knowledge on island living. Used to slightly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 25,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T1",
		icon = "IslandProps/item_100001",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10217,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				100001,
				1
			}
		}
	}
	pg.base.island_shop_goods[10218] = {
		desc = "A book containing detailed knowledge on island living. Used to moderately increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T2",
		icon = "IslandProps/item_100002",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10218,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10219] = {
		desc = "A book containing abundant knowledge on island living. Used to greatly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T3",
		icon = "IslandProps/item_100003",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1600,
		discount = 0,
		groups_detail_type = "",
		id = 10219,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			16000
		},
		items = {
			{
				41,
				100003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10220] = {
		desc = "A book containing fundamental knowledge on production techniques. Used to slightly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T1",
		icon = "IslandProps/item_100101",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 200,
		discount = 0,
		groups_detail_type = "",
		id = 10220,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			2000
		},
		items = {
			{
				41,
				100101,
				1
			}
		}
	}
	pg.base.island_shop_goods[10221] = {
		desc = "A book containing detailed knowledge on production techniques. Used to moderately increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T2",
		icon = "IslandProps/item_100102",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10221,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100102,
				1
			}
		}
	}
	pg.base.island_shop_goods[10222] = {
		desc = "A book containing abundant knowledge on production techniques. Used to greatly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 6,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T3",
		icon = "IslandProps/item_100103",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1500,
		discount = 0,
		groups_detail_type = "",
		id = 10222,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			15000
		},
		items = {
			{
				41,
				100103,
				1
			}
		}
	}
	pg.base.island_shop_goods[10223] = {
		desc = "A crystal of island development experience. Required to Limit Break characters.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Island Development Gem",
		icon = "IslandProps/item_100201",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10223,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_shop_goods[10224] = {
		desc = "A book containing fundamental knowledge on management techniques. Used to slightly increase a character's Management stat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 3,
		limited_show = 1,
		unlock = "",
		goods_name = "Management Textbook T1",
		icon = "IslandProps/item_100011",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10224,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				41,
				100011,
				1
			}
		}
	}
	pg.base.island_shop_goods[10225] = {
		desc = "A book containing fundamental knowledge on farming techniques. Used to slightly increase a character's Farming stat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 3,
		limited_show = 1,
		unlock = "",
		goods_name = "Farming Textbook T1",
		icon = "IslandProps/item_100021",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10225,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				41,
				100021,
				1
			}
		}
	}
	pg.base.island_shop_goods[10226] = {
		desc = "A book containing fundamental knowledge on manufacturing techniques. Used to slightly increase a character's Manufacturing stat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 3,
		limited_show = 1,
		unlock = "",
		goods_name = "Manufacturing Textbook T1",
		icon = "IslandProps/item_100031",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10226,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				41,
				100031,
				1
			}
		}
	}
	pg.base.island_shop_goods[10227] = {
		desc = "A book containing fundamental knowledge on gathering techniques. Used to slightly increase a character's Gathering stat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 3,
		limited_show = 1,
		unlock = "",
		goods_name = "Gathering Textbook T1",
		icon = "IslandProps/item_100041",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10227,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				41,
				100041,
				1
			}
		}
	}
	pg.base.island_shop_goods[10228] = {
		desc = "A book containing fundamental knowledge on husbandry techniques. Used to slightly increase a character's Husbandry stat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 3,
		limited_show = 1,
		unlock = "",
		goods_name = "Husbandry Textbook T1",
		icon = "IslandProps/item_100051",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10228,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				41,
				100051,
				1
			}
		}
	}
	pg.base.island_shop_goods[10229] = {
		desc = "A book containing fundamental knowledge on cooking techniques. Used to slightly increase a character's Cooking stat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 3,
		limited_show = 1,
		unlock = "",
		goods_name = "Cooking Textbook T1",
		icon = "IslandProps/item_100061",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10229,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				41,
				100061,
				1
			}
		}
	}
	pg.base.island_shop_goods[10230] = {
		desc = "A hardcover book that smells of ink and sports a classic vibe. It's worthy of going on your table and being reread time and time again.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Hardcover Book",
		icon = "IslandGoodsIcon/gift02",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10230,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10231] = {
		desc = "A gorgeous, fresh bouquet. Its flowers are brimming with color and life, and they promise joy for the days to come.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Bouquet",
		icon = "IslandGoodsIcon/gift03",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10231,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10232] = {
		desc = "This ceremonial sword with a flowing silhouette gives off the cold brilliance of steel. It silently speaks of order and majesty.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Ceremonial Sword",
		icon = "IslandGoodsIcon/gift04",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10232,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180004,
				1
			}
		}
	}
	pg.base.island_shop_goods[10233] = {
		desc = "An adorable stuffed animal that's soft to the touch. Give it a hug, and its fluffy warmth and innocent smile will soften your heart.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Fluffy Stuffed Animal",
		icon = "IslandGoodsIcon/gift05",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10233,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180005,
				1
			}
		}
	}
	pg.base.island_shop_goods[10234] = {
		desc = "The sands of time have poured over this ornament, turning it into an elegant antique. Quietly, it lends an air of tranquility to a room.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Antique Ornament",
		icon = "IslandGoodsIcon/gift06",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10234,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180006,
				1
			}
		}
	}
	pg.base.island_shop_goods[10235] = {
		desc = "An accessory that, although understated, glimmers with exceptional craftsmanship. It adds just a little light to every moment of one's life.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Exquisite Accessory",
		icon = "IslandGoodsIcon/gift07",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10235,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180007,
				1
			}
		}
	}
	pg.base.island_shop_goods[10236] = {
		desc = "A wonderfully pure aroma hides inside this modest flask. Just one spray of this fragrance brings out tones of refined class.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Premium Perfume",
		icon = "IslandGoodsIcon/gift08",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10236,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180008,
				1
			}
		}
	}
	pg.base.island_shop_goods[10237] = {
		desc = "Tickets that glitter like the stars. Can be used to draw prizes in the Stellar Prize Draw. When the current run of the Stellar Prize Draw ends, any Stellar Tickets left over will be automatically used to draw prizes or be converted to Gems.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Stellar Tickets",
		icon = "IslandGoodsIcon/170000",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10237,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				8,
				170002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10238] = {
		desc = "A book containing fundamental knowledge on island living. Used to slightly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 25,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T1",
		icon = "IslandProps/item_100001",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10238,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				100001,
				1
			}
		}
	}
	pg.base.island_shop_goods[10239] = {
		desc = "A book containing detailed knowledge on island living. Used to moderately increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T2",
		icon = "IslandProps/item_100002",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10239,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10240] = {
		desc = "A book containing abundant knowledge on island living. Used to greatly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T3",
		icon = "IslandProps/item_100003",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1600,
		discount = 0,
		groups_detail_type = "",
		id = 10240,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			16000
		},
		items = {
			{
				41,
				100003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10241] = {
		desc = "A book containing fundamental knowledge on production techniques. Used to slightly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T1",
		icon = "IslandProps/item_100101",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 200,
		discount = 0,
		groups_detail_type = "",
		id = 10241,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			2000
		},
		items = {
			{
				41,
				100101,
				1
			}
		}
	}
	pg.base.island_shop_goods[10242] = {
		desc = "A book containing detailed knowledge on production techniques. Used to moderately increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T2",
		icon = "IslandProps/item_100102",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10242,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100102,
				1
			}
		}
	}
	pg.base.island_shop_goods[10243] = {
		desc = "A book containing abundant knowledge on production techniques. Used to greatly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 8,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T3",
		icon = "IslandProps/item_100103",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1500,
		discount = 0,
		groups_detail_type = "",
		id = 10243,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			15000
		},
		items = {
			{
				41,
				100103,
				1
			}
		}
	}
	pg.base.island_shop_goods[10244] = {
		desc = "A crystal of island development experience. Required to Limit Break characters.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 3,
		limited_show = 1,
		unlock = "",
		goods_name = "Island Development Gem",
		icon = "IslandProps/item_100201",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10244,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_shop_goods[10245] = {
		desc = "A hardcover book that smells of ink and sports a classic vibe. It's worthy of going on your table and being reread time and time again.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Hardcover Book",
		icon = "IslandGoodsIcon/gift02",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10245,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10246] = {
		desc = "A gorgeous, fresh bouquet. Its flowers are brimming with color and life, and they promise joy for the days to come.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Bouquet",
		icon = "IslandGoodsIcon/gift03",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10246,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10247] = {
		desc = "This ceremonial sword with a flowing silhouette gives off the cold brilliance of steel. It silently speaks of order and majesty.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Ceremonial Sword",
		icon = "IslandGoodsIcon/gift04",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10247,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180004,
				1
			}
		}
	}
	pg.base.island_shop_goods[10248] = {
		desc = "An adorable stuffed animal that's soft to the touch. Give it a hug, and its fluffy warmth and innocent smile will soften your heart.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Fluffy Stuffed Animal",
		icon = "IslandGoodsIcon/gift05",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10248,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180005,
				1
			}
		}
	}
	pg.base.island_shop_goods[10249] = {
		desc = "The sands of time have poured over this ornament, turning it into an elegant antique. Quietly, it lends an air of tranquility to a room.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Antique Ornament",
		icon = "IslandGoodsIcon/gift06",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10249,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180006,
				1
			}
		}
	}
	pg.base.island_shop_goods[10250] = {
		desc = "An accessory that, although understated, glimmers with exceptional craftsmanship. It adds just a little light to every moment of one's life.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Exquisite Accessory",
		icon = "IslandGoodsIcon/gift07",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10250,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180007,
				1
			}
		}
	}
	pg.base.island_shop_goods[10251] = {
		desc = "A wonderfully pure aroma hides inside this modest flask. Just one spray of this fragrance brings out tones of refined class.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Premium Perfume",
		icon = "IslandGoodsIcon/gift08",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10251,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180008,
				1
			}
		}
	}
	pg.base.island_shop_goods[10252] = {
		desc = "An entertainment system that will fill up every moment of your spare time. This thoughtful gift contains just about all the content you need for a fun play session.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Game Console Set",
		icon = "IslandGoodsIcon/gift09",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10252,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180009,
				1
			}
		}
	}
	pg.base.island_shop_goods[10253] = {
		desc = "Tickets that glitter like the stars. Can be used to draw prizes in the Stellar Prize Draw. When the current run of the Stellar Prize Draw ends, any Stellar Tickets left over will be automatically used to draw prizes or be converted to Gems.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Stellar Tickets",
		icon = "IslandGoodsIcon/170000",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10253,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				8,
				170002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10254] = {
		desc = "A book containing fundamental knowledge on island living. Used to slightly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 50,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T1",
		icon = "IslandProps/item_100001",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10254,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				100001,
				1
			}
		}
	}
	pg.base.island_shop_goods[10255] = {
		desc = "A book containing detailed knowledge on island living. Used to moderately increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 15,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T2",
		icon = "IslandProps/item_100002",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10255,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10256] = {
		desc = "A book containing abundant knowledge on island living. Used to greatly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T3",
		icon = "IslandProps/item_100003",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1600,
		discount = 0,
		groups_detail_type = "",
		id = 10256,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			16000
		},
		items = {
			{
				41,
				100003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10257] = {
		desc = "A book containing fundamental knowledge on production techniques. Used to slightly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T1",
		icon = "IslandProps/item_100101",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 200,
		discount = 0,
		groups_detail_type = "",
		id = 10257,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			2000
		},
		items = {
			{
				41,
				100101,
				1
			}
		}
	}
	pg.base.island_shop_goods[10258] = {
		desc = "A book containing detailed knowledge on production techniques. Used to moderately increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T2",
		icon = "IslandProps/item_100102",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10258,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100102,
				1
			}
		}
	}
	pg.base.island_shop_goods[10259] = {
		desc = "A book containing abundant knowledge on production techniques. Used to greatly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T3",
		icon = "IslandProps/item_100103",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1500,
		discount = 0,
		groups_detail_type = "",
		id = 10259,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			15000
		},
		items = {
			{
				41,
				100103,
				1
			}
		}
	}
	pg.base.island_shop_goods[10260] = {
		desc = "A crystal of island development experience. Required to Limit Break characters.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Island Development Gem",
		icon = "IslandProps/item_100201",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10260,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_shop_goods[10261] = {
		desc = "A hardcover book that smells of ink and sports a classic vibe. It's worthy of going on your table and being reread time and time again.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Hardcover Book",
		icon = "IslandGoodsIcon/gift02",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10261,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10262] = {
		desc = "A gorgeous, fresh bouquet. Its flowers are brimming with color and life, and they promise joy for the days to come.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Bouquet",
		icon = "IslandGoodsIcon/gift03",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10262,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10263] = {
		desc = "This ceremonial sword with a flowing silhouette gives off the cold brilliance of steel. It silently speaks of order and majesty.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Ceremonial Sword",
		icon = "IslandGoodsIcon/gift04",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10263,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180004,
				1
			}
		}
	}
	pg.base.island_shop_goods[10264] = {
		desc = "An adorable stuffed animal that's soft to the touch. Give it a hug, and its fluffy warmth and innocent smile will soften your heart.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Fluffy Stuffed Animal",
		icon = "IslandGoodsIcon/gift05",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10264,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180005,
				1
			}
		}
	}
	pg.base.island_shop_goods[10265] = {
		desc = "The sands of time have poured over this ornament, turning it into an elegant antique. Quietly, it lends an air of tranquility to a room.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Antique Ornament",
		icon = "IslandGoodsIcon/gift06",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10265,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180006,
				1
			}
		}
	}
	pg.base.island_shop_goods[10266] = {
		desc = "An accessory that, although understated, glimmers with exceptional craftsmanship. It adds just a little light to every moment of one's life.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Exquisite Accessory",
		icon = "IslandGoodsIcon/gift07",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10266,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180007,
				1
			}
		}
	}
	pg.base.island_shop_goods[10267] = {
		desc = "A wonderfully pure aroma hides inside this modest flask. Just one spray of this fragrance brings out tones of refined class.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Premium Perfume",
		icon = "IslandGoodsIcon/gift08",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10267,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180008,
				1
			}
		}
	}
	pg.base.island_shop_goods[10268] = {
		desc = "An entertainment system that will fill up every moment of your spare time. This thoughtful gift contains just about all the content you need for a fun play session.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Game Console Set",
		icon = "IslandGoodsIcon/gift09",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10268,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180009,
				1
			}
		}
	}
	pg.base.island_shop_goods[10269] = {
		desc = "An entertainment system that will fill up every moment of your spare time. This thoughtful gift contains just about all the content you need for a fun play session.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Game Console Set",
		icon = "IslandGoodsIcon/gift09",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10269,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180009,
				1
			}
		}
	}
	pg.base.island_shop_goods[10301] = {
		desc = "Purchase to receive Lunar Light, a floating character outfit.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Lunar Light",
		icon = "IslandDressIcon/dress_2020006",
		goods_detail_type = 2,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10301,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				46,
				2020006,
				1
			}
		}
	}
	pg.base.island_shop_goods[10302] = {
		desc = "Purchase to receive Stardust Prints, a character outfit that goes in the trail slot.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Stardust Prints",
		icon = "IslandDressIcon/dress_2030007",
		goods_detail_type = 2,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10302,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				46,
				2030007,
				1
			}
		}
	}
	pg.base.island_shop_goods[10303] = {
		desc = "Purchase to receive Mystical Dreamcatcher, a character outfit that goes on the back.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Mystical Dreamcatcher",
		icon = "IslandDressIcon/dress_2010005",
		goods_detail_type = 2,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10303,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				46,
				2010005,
				1
			}
		}
	}
	pg.base.island_shop_goods[10304] = {
		desc = "Action - Refuse",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Refuse",
		icon = "IslandActionIcon/refuse",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 500,
		discount = 0,
		groups_detail_type = "",
		id = 10304,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			5000
		},
		items = {
			{
				51,
				1019,
				1
			}
		}
	}
	pg.base.island_shop_goods[10305] = {
		desc = "Action - Yawn",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Yawn",
		icon = "IslandActionIcon/yawn",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 500,
		discount = 0,
		groups_detail_type = "",
		id = 10305,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			5000
		},
		items = {
			{
				51,
				1020,
				1
			}
		}
	}
	pg.base.island_shop_goods[10306] = {
		desc = "Action - Wipe Sweat",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Wipe Sweat",
		icon = "IslandActionIcon/wipingsweat",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 500,
		discount = 0,
		groups_detail_type = "",
		id = 10306,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			5000
		},
		items = {
			{
				51,
				1021,
				1
			}
		}
	}
	pg.base.island_shop_goods[10307] = {
		desc = "Action - Scratch Head",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Scratch Head",
		icon = "IslandActionIcon/scratchinghead",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 500,
		discount = 0,
		groups_detail_type = "",
		id = 10307,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			5000
		},
		items = {
			{
				51,
				1022,
				1
			}
		}
	}
	pg.base.island_shop_goods[10308] = {
		desc = "An Island Authority Permit for Javelin. Use it to give the character the credentials to visit the island freely.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Island Authority Permit: Javelin",
		icon = "IslandProps/item_200024",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20000,
		discount = 0,
		groups_detail_type = "",
		id = 10308,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200000
		},
		items = {
			{
				44,
				20121,
				1
			}
		}
	}
	pg.base.island_shop_goods[10309] = {
		desc = "Tickets that glitter like the stars. Can be used to draw prizes in the Stellar Prize Draw. When the current run of the Stellar Prize Draw ends, any Stellar Tickets left over will be automatically used to draw prizes or be converted to Gems.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Stellar Tickets",
		icon = "IslandGoodsIcon/170000",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10309,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				8,
				170004,
				1
			}
		}
	}
	pg.base.island_shop_goods[10310] = {
		desc = "Fresh wheat straight from the fields. The base ingredient needed to make flour.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Wheat",
		icon = "IslandProps/item_2000",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10310,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2000,
				10
			}
		}
	}
	pg.base.island_shop_goods[10311] = {
		desc = "Ripe, golden corn. It lends a sweet smell to the fields.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Corn",
		icon = "IslandProps/item_2001",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10311,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2001,
				10
			}
		}
	}
	pg.base.island_shop_goods[10312] = {
		desc = "High-quality grass. Provides life in abundance to the farm!",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Grass",
		icon = "IslandProps/item_2008",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10312,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2008,
				10
			}
		}
	}
	pg.base.island_shop_goods[10313] = {
		desc = "White, high-quality rice. Contains plentiful starch and granular protein.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Rice",
		icon = "IslandProps/item_2002",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10313,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2002,
				10
			}
		}
	}
	pg.base.island_shop_goods[10314] = {
		desc = "Crisp and delicious napa cabbage. It's straight from the farm!",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Napa Cabbage",
		icon = "IslandProps/item_2003",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10314,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2003,
				10
			}
		}
	}
	pg.base.island_shop_goods[10315] = {
		desc = "Round, fluffy, and filled with protein. Has all sorts of uses, not just in cooking, but in manufacturing as well.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Soy Beans",
		icon = "IslandProps/item_2006",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10315,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2006,
				10
			}
		}
	}
end)()
;(function()
	pg.base.island_shop_goods[10316] = {
		desc = "The king of starch in the vegetable world. Can be prepared in all kinds of ways.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Potato",
		icon = "IslandProps/item_2005",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 40,
		discount = 0,
		groups_detail_type = "",
		id = 10316,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			400
		},
		items = {
			{
				41,
				2005,
				10
			}
		}
	}
	pg.base.island_shop_goods[10317] = {
		desc = "A book containing fundamental knowledge on island living. Used to slightly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 25,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T1",
		icon = "IslandProps/item_100001",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10317,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				100001,
				1
			}
		}
	}
	pg.base.island_shop_goods[10318] = {
		desc = "A book containing detailed knowledge on island living. Used to moderately increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T2",
		icon = "IslandProps/item_100002",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10318,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10319] = {
		desc = "A book containing abundant knowledge on island living. Used to greatly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T3",
		icon = "IslandProps/item_100003",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1600,
		discount = 0,
		groups_detail_type = "",
		id = 10319,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			16000
		},
		items = {
			{
				41,
				100003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10320] = {
		desc = "A book containing fundamental knowledge on production techniques. Used to slightly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T1",
		icon = "IslandProps/item_100101",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 200,
		discount = 0,
		groups_detail_type = "",
		id = 10320,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			2000
		},
		items = {
			{
				41,
				100101,
				1
			}
		}
	}
	pg.base.island_shop_goods[10321] = {
		desc = "A book containing detailed knowledge on production techniques. Used to moderately increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T2",
		icon = "IslandProps/item_100102",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10321,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100102,
				1
			}
		}
	}
	pg.base.island_shop_goods[10322] = {
		desc = "A book containing abundant knowledge on production techniques. Used to greatly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 6,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T3",
		icon = "IslandProps/item_100103",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1500,
		discount = 0,
		groups_detail_type = "",
		id = 10322,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			15000
		},
		items = {
			{
				41,
				100103,
				1
			}
		}
	}
	pg.base.island_shop_goods[10323] = {
		desc = "A crystal of island development experience. Required to Limit Break characters.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Island Development Gem",
		icon = "IslandProps/item_100201",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10323,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_shop_goods[10324] = {
		desc = "A book containing fundamental knowledge on management techniques. Used to slightly increase a character's Management stat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 3,
		limited_show = 1,
		unlock = "",
		goods_name = "Management Textbook T1",
		icon = "IslandProps/item_100011",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10324,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				41,
				100011,
				1
			}
		}
	}
	pg.base.island_shop_goods[10325] = {
		desc = "A book containing fundamental knowledge on farming techniques. Used to slightly increase a character's Farming stat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 3,
		limited_show = 1,
		unlock = "",
		goods_name = "Farming Textbook T1",
		icon = "IslandProps/item_100021",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10325,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				41,
				100021,
				1
			}
		}
	}
	pg.base.island_shop_goods[10326] = {
		desc = "A book containing fundamental knowledge on manufacturing techniques. Used to slightly increase a character's Manufacturing stat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 3,
		limited_show = 1,
		unlock = "",
		goods_name = "Manufacturing Textbook T1",
		icon = "IslandProps/item_100031",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10326,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				41,
				100031,
				1
			}
		}
	}
	pg.base.island_shop_goods[10327] = {
		desc = "A book containing fundamental knowledge on gathering techniques. Used to slightly increase a character's Gathering stat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 3,
		limited_show = 1,
		unlock = "",
		goods_name = "Gathering Textbook T1",
		icon = "IslandProps/item_100041",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10327,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				41,
				100041,
				1
			}
		}
	}
	pg.base.island_shop_goods[10328] = {
		desc = "A book containing fundamental knowledge on husbandry techniques. Used to slightly increase a character's Husbandry stat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 3,
		limited_show = 1,
		unlock = "",
		goods_name = "Husbandry Textbook T1",
		icon = "IslandProps/item_100051",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10328,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				41,
				100051,
				1
			}
		}
	}
	pg.base.island_shop_goods[10329] = {
		desc = "A book containing fundamental knowledge on cooking techniques. Used to slightly increase a character's Cooking stat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 3,
		limited_show = 1,
		unlock = "",
		goods_name = "Cooking Textbook T1",
		icon = "IslandProps/item_100061",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10329,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				41,
				100061,
				1
			}
		}
	}
	pg.base.island_shop_goods[10330] = {
		desc = "A hardcover book that smells of ink and sports a classic vibe. It's worthy of going on your table and being reread time and time again.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Hardcover Book",
		icon = "IslandGoodsIcon/gift02",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10330,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10331] = {
		desc = "A gorgeous, fresh bouquet. Its flowers are brimming with color and life, and they promise joy for the days to come.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Bouquet",
		icon = "IslandGoodsIcon/gift03",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10331,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10332] = {
		desc = "This ceremonial sword with a flowing silhouette gives off the cold brilliance of steel. It silently speaks of order and majesty.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Ceremonial Sword",
		icon = "IslandGoodsIcon/gift04",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10332,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180004,
				1
			}
		}
	}
	pg.base.island_shop_goods[10333] = {
		desc = "An adorable stuffed animal that's soft to the touch. Give it a hug, and its fluffy warmth and innocent smile will soften your heart.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Fluffy Stuffed Animal",
		icon = "IslandGoodsIcon/gift05",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10333,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180005,
				1
			}
		}
	}
	pg.base.island_shop_goods[10334] = {
		desc = "The sands of time have poured over this ornament, turning it into an elegant antique. Quietly, it lends an air of tranquility to a room.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Antique Ornament",
		icon = "IslandGoodsIcon/gift06",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10334,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180006,
				1
			}
		}
	}
	pg.base.island_shop_goods[10335] = {
		desc = "An accessory that, although understated, glimmers with exceptional craftsmanship. It adds just a little light to every moment of one's life.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Exquisite Accessory",
		icon = "IslandGoodsIcon/gift07",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10335,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180007,
				1
			}
		}
	}
	pg.base.island_shop_goods[10336] = {
		desc = "A wonderfully pure aroma hides inside this modest flask. Just one spray of this fragrance brings out tones of refined class.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Premium Perfume",
		icon = "IslandGoodsIcon/gift08",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10336,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180008,
				1
			}
		}
	}
	pg.base.island_shop_goods[10337] = {
		desc = "An entertainment system that will fill up every moment of your spare time. This thoughtful gift contains just about all the content you need for a fun play session.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Game Console Set",
		icon = "IslandGoodsIcon/gift09",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10337,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180009,
				1
			}
		}
	}
	pg.base.island_shop_goods[10338] = {
		desc = "Tickets that glitter like the stars. Can be used to draw prizes in the Stellar Prize Draw. When the current run of the Stellar Prize Draw ends, any Stellar Tickets left over will be automatically used to draw prizes or be converted to Gems.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Stellar Tickets",
		icon = "IslandGoodsIcon/170000",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10338,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				8,
				170004,
				1
			}
		}
	}
	pg.base.island_shop_goods[10339] = {
		desc = "A book containing fundamental knowledge on island living. Used to slightly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 25,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T1",
		icon = "IslandProps/item_100001",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10339,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				100001,
				1
			}
		}
	}
	pg.base.island_shop_goods[10340] = {
		desc = "A book containing detailed knowledge on island living. Used to moderately increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T2",
		icon = "IslandProps/item_100002",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10340,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10341] = {
		desc = "A book containing abundant knowledge on island living. Used to greatly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T3",
		icon = "IslandProps/item_100003",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1600,
		discount = 0,
		groups_detail_type = "",
		id = 10341,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			16000
		},
		items = {
			{
				41,
				100003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10342] = {
		desc = "A book containing fundamental knowledge on production techniques. Used to slightly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T1",
		icon = "IslandProps/item_100101",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 200,
		discount = 0,
		groups_detail_type = "",
		id = 10342,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			2000
		},
		items = {
			{
				41,
				100101,
				1
			}
		}
	}
	pg.base.island_shop_goods[10343] = {
		desc = "A book containing detailed knowledge on production techniques. Used to moderately increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T2",
		icon = "IslandProps/item_100102",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10343,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100102,
				1
			}
		}
	}
	pg.base.island_shop_goods[10344] = {
		desc = "A book containing abundant knowledge on production techniques. Used to greatly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 8,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T3",
		icon = "IslandProps/item_100103",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1500,
		discount = 0,
		groups_detail_type = "",
		id = 10344,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			15000
		},
		items = {
			{
				41,
				100103,
				1
			}
		}
	}
	pg.base.island_shop_goods[10345] = {
		desc = "A crystal of island development experience. Required to Limit Break characters.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 3,
		limited_show = 1,
		unlock = "",
		goods_name = "Island Development Gem",
		icon = "IslandProps/item_100201",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10345,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_shop_goods[10346] = {
		desc = "A hardcover book that smells of ink and sports a classic vibe. It's worthy of going on your table and being reread time and time again.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Hardcover Book",
		icon = "IslandGoodsIcon/gift02",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10346,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10347] = {
		desc = "A gorgeous, fresh bouquet. Its flowers are brimming with color and life, and they promise joy for the days to come.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Bouquet",
		icon = "IslandGoodsIcon/gift03",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10347,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10348] = {
		desc = "This ceremonial sword with a flowing silhouette gives off the cold brilliance of steel. It silently speaks of order and majesty.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Ceremonial Sword",
		icon = "IslandGoodsIcon/gift04",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10348,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180004,
				1
			}
		}
	}
	pg.base.island_shop_goods[10349] = {
		desc = "An adorable stuffed animal that's soft to the touch. Give it a hug, and its fluffy warmth and innocent smile will soften your heart.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Fluffy Stuffed Animal",
		icon = "IslandGoodsIcon/gift05",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10349,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180005,
				1
			}
		}
	}
	pg.base.island_shop_goods[10350] = {
		desc = "The sands of time have poured over this ornament, turning it into an elegant antique. Quietly, it lends an air of tranquility to a room.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Antique Ornament",
		icon = "IslandGoodsIcon/gift06",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10350,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180006,
				1
			}
		}
	}
	pg.base.island_shop_goods[10351] = {
		desc = "An accessory that, although understated, glimmers with exceptional craftsmanship. It adds just a little light to every moment of one's life.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Exquisite Accessory",
		icon = "IslandGoodsIcon/gift07",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10351,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180007,
				1
			}
		}
	}
	pg.base.island_shop_goods[10352] = {
		desc = "A wonderfully pure aroma hides inside this modest flask. Just one spray of this fragrance brings out tones of refined class.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Premium Perfume",
		icon = "IslandGoodsIcon/gift08",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10352,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180008,
				1
			}
		}
	}
	pg.base.island_shop_goods[10353] = {
		desc = "An entertainment system that will fill up every moment of your spare time. This thoughtful gift contains just about all the content you need for a fun play session.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Game Console Set",
		icon = "IslandGoodsIcon/gift09",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10353,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180009,
				1
			}
		}
	}
	pg.base.island_shop_goods[10354] = {
		desc = "Tickets that glitter like the stars. Can be used to draw prizes in the Stellar Prize Draw. When the current run of the Stellar Prize Draw ends, any Stellar Tickets left over will be automatically used to draw prizes or be converted to Gems.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Stellar Tickets",
		icon = "IslandGoodsIcon/170000",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10354,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				8,
				170004,
				1
			}
		}
	}
	pg.base.island_shop_goods[10355] = {
		desc = "A book containing fundamental knowledge on island living. Used to slightly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 50,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T1",
		icon = "IslandProps/item_100001",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10355,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				100001,
				1
			}
		}
	}
	pg.base.island_shop_goods[10356] = {
		desc = "A book containing detailed knowledge on island living. Used to moderately increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 15,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T2",
		icon = "IslandProps/item_100002",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10356,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10357] = {
		desc = "A book containing abundant knowledge on island living. Used to greatly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T3",
		icon = "IslandProps/item_100003",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1600,
		discount = 0,
		groups_detail_type = "",
		id = 10357,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			16000
		},
		items = {
			{
				41,
				100003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10358] = {
		desc = "A book containing fundamental knowledge on production techniques. Used to slightly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T1",
		icon = "IslandProps/item_100101",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 200,
		discount = 0,
		groups_detail_type = "",
		id = 10358,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			2000
		},
		items = {
			{
				41,
				100101,
				1
			}
		}
	}
	pg.base.island_shop_goods[10359] = {
		desc = "A book containing detailed knowledge on production techniques. Used to moderately increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T2",
		icon = "IslandProps/item_100102",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10359,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100102,
				1
			}
		}
	}
	pg.base.island_shop_goods[10360] = {
		desc = "A book containing abundant knowledge on production techniques. Used to greatly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T3",
		icon = "IslandProps/item_100103",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1500,
		discount = 0,
		groups_detail_type = "",
		id = 10360,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			15000
		},
		items = {
			{
				41,
				100103,
				1
			}
		}
	}
	pg.base.island_shop_goods[10361] = {
		desc = "A crystal of island development experience. Required to Limit Break characters.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Island Development Gem",
		icon = "IslandProps/item_100201",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10361,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_shop_goods[10362] = {
		desc = "A hardcover book that smells of ink and sports a classic vibe. It's worthy of going on your table and being reread time and time again.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Hardcover Book",
		icon = "IslandGoodsIcon/gift02",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10362,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10363] = {
		desc = "A gorgeous, fresh bouquet. Its flowers are brimming with color and life, and they promise joy for the days to come.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Bouquet",
		icon = "IslandGoodsIcon/gift03",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10363,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10364] = {
		desc = "This ceremonial sword with a flowing silhouette gives off the cold brilliance of steel. It silently speaks of order and majesty.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Ceremonial Sword",
		icon = "IslandGoodsIcon/gift04",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10364,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180004,
				1
			}
		}
	}
	pg.base.island_shop_goods[10365] = {
		desc = "An adorable stuffed animal that's soft to the touch. Give it a hug, and its fluffy warmth and innocent smile will soften your heart.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Fluffy Stuffed Animal",
		icon = "IslandGoodsIcon/gift05",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10365,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180005,
				1
			}
		}
	}
	pg.base.island_shop_goods[10366] = {
		desc = "The sands of time have poured over this ornament, turning it into an elegant antique. Quietly, it lends an air of tranquility to a room.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Antique Ornament",
		icon = "IslandGoodsIcon/gift06",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10366,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180006,
				1
			}
		}
	}
	pg.base.island_shop_goods[10367] = {
		desc = "An accessory that, although understated, glimmers with exceptional craftsmanship. It adds just a little light to every moment of one's life.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Exquisite Accessory",
		icon = "IslandGoodsIcon/gift07",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10367,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180007,
				1
			}
		}
	}
	pg.base.island_shop_goods[10368] = {
		desc = "A wonderfully pure aroma hides inside this modest flask. Just one spray of this fragrance brings out tones of refined class.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Premium Perfume",
		icon = "IslandGoodsIcon/gift08",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10368,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180008,
				1
			}
		}
	}
	pg.base.island_shop_goods[10369] = {
		desc = "An entertainment system that will fill up every moment of your spare time. This thoughtful gift contains just about all the content you need for a fun play session.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Game Console Set",
		icon = "IslandGoodsIcon/gift09",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10369,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180009,
				1
			}
		}
	}
	pg.base.island_shop_goods[10401] = {
		desc = "Purchase to receive Compact Kitty Mirror, a floating character outfit.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Compact Kitty Mirror",
		icon = "IslandDressIcon/dress_2020009",
		goods_detail_type = 2,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10401,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				46,
				2020009,
				1
			}
		}
	}
	pg.base.island_shop_goods[10402] = {
		desc = "Purchase to receive Kitty Lip Balm, a character outfit that goes on the back.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Kitty Lip Balm",
		icon = "IslandDressIcon/dress_2010007",
		goods_detail_type = 2,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10402,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				46,
				2010007,
				1
			}
		}
	}
	pg.base.island_shop_goods[10403] = {
		desc = "Purchase to receive Trail of Balmy Gloss, a character outfit that goes in the trail slot.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Trail of Balmy Gloss",
		icon = "IslandDressIcon/dress_2030010",
		goods_detail_type = 2,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10403,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				46,
				2030010,
				1
			}
		}
	}
	pg.base.island_shop_goods[10404] = {
		desc = "Action - Point",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Point",
		icon = "IslandActionIcon/point",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 500,
		discount = 0,
		groups_detail_type = "",
		id = 10404,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			5000
		},
		items = {
			{
				51,
				1025,
				1
			}
		}
	}
	pg.base.island_shop_goods[10405] = {
		desc = "Action - Greet",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Greet",
		icon = "IslandActionIcon/welcome",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 500,
		discount = 0,
		groups_detail_type = "",
		id = 10405,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			5000
		},
		items = {
			{
				51,
				1026,
				1
			}
		}
	}
	pg.base.island_shop_goods[10406] = {
		desc = "Action - Stare",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Stare",
		icon = "IslandActionIcon/lookover",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 500,
		discount = 0,
		groups_detail_type = "",
		id = 10406,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			5000
		},
		items = {
			{
				51,
				1027,
				1
			}
		}
	}
	pg.base.island_shop_goods[10407] = {
		desc = "Action - Stuffed",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Stuffed",
		icon = "IslandActionIcon/slapbelly",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 500,
		discount = 0,
		groups_detail_type = "",
		id = 10407,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			5000
		},
		items = {
			{
				51,
				1028,
				1
			}
		}
	}
	pg.base.island_shop_goods[10408] = {
		desc = "An Island Authority Permit for Belfast. Use it to give the character the credentials to visit the island freely.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Island Authority Permit: Belfast",
		icon = "IslandProps/item_200034",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20000,
		discount = 0,
		groups_detail_type = "",
		id = 10408,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200000
		},
		items = {
			{
				44,
				20212,
				1
			}
		}
	}
	pg.base.island_shop_goods[10409] = {
		desc = "Tickets that glitter like the stars. Can be used to draw prizes in the Stellar Prize Draw. When the current run of the Stellar Prize Draw ends, any Stellar Tickets left over will be automatically used to draw prizes or be converted to Gems.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Stellar Tickets",
		icon = "IslandGoodsIcon/170000",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10409,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				8,
				170006,
				1
			}
		}
	}
	pg.base.island_shop_goods[10410] = {
		desc = "Fresh wheat straight from the fields. The base ingredient needed to make flour.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Wheat",
		icon = "IslandProps/item_2000",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10410,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2000,
				10
			}
		}
	}
	pg.base.island_shop_goods[10411] = {
		desc = "Ripe, golden corn. It lends a sweet smell to the fields.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Corn",
		icon = "IslandProps/item_2001",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10411,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2001,
				10
			}
		}
	}
	pg.base.island_shop_goods[10412] = {
		desc = "High-quality grass. Provides life in abundance to the farm!",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Grass",
		icon = "IslandProps/item_2008",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10412,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2008,
				10
			}
		}
	}
	pg.base.island_shop_goods[10413] = {
		desc = "White, high-quality rice. Contains plentiful starch and granular protein.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Rice",
		icon = "IslandProps/item_2002",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10413,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2002,
				10
			}
		}
	}
	pg.base.island_shop_goods[10414] = {
		desc = "Crisp and delicious napa cabbage. It's straight from the farm!",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Napa Cabbage",
		icon = "IslandProps/item_2003",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10414,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2003,
				10
			}
		}
	}
	pg.base.island_shop_goods[10415] = {
		desc = "Round, fluffy, and filled with protein. Has all sorts of uses, not just in cooking, but in manufacturing as well.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Soy Bean",
		icon = "IslandProps/item_2006",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10415,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				2006,
				10
			}
		}
	}
	pg.base.island_shop_goods[10416] = {
		desc = "The king of starch in the vegetable world. Can be prepared in all kinds of ways.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Potato",
		icon = "IslandProps/item_2005",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 40,
		discount = 0,
		groups_detail_type = "",
		id = 10416,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			400
		},
		items = {
			{
				41,
				2005,
				10
			}
		}
	}
	pg.base.island_shop_goods[10417] = {
		desc = "A book containing fundamental knowledge on island living. Used to slightly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 25,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T1",
		icon = "IslandProps/item_100001",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10417,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				100001,
				1
			}
		}
	}
	pg.base.island_shop_goods[10418] = {
		desc = "A book containing detailed knowledge on island living. Used to moderately increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T2",
		icon = "IslandProps/item_100002",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10418,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10419] = {
		desc = "A book containing abundant knowledge on island living. Used to greatly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T3",
		icon = "IslandProps/item_100003",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1600,
		discount = 0,
		groups_detail_type = "",
		id = 10419,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			16000
		},
		items = {
			{
				41,
				100003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10420] = {
		desc = "A book containing fundamental knowledge on production techniques. Used to slightly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T1",
		icon = "IslandProps/item_100101",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 200,
		discount = 0,
		groups_detail_type = "",
		id = 10420,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			2000
		},
		items = {
			{
				41,
				100101,
				1
			}
		}
	}
	pg.base.island_shop_goods[10421] = {
		desc = "A book containing detailed knowledge on production techniques. Used to moderately increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T2",
		icon = "IslandProps/item_100102",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10421,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100102,
				1
			}
		}
	}
	pg.base.island_shop_goods[10422] = {
		desc = "A book containing abundant knowledge on production techniques. Used to greatly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 6,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T3",
		icon = "IslandProps/item_100103",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1500,
		discount = 0,
		groups_detail_type = "",
		id = 10422,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			15000
		},
		items = {
			{
				41,
				100103,
				1
			}
		}
	}
	pg.base.island_shop_goods[10423] = {
		desc = "A crystal of island development experience. Required to Limit Break characters.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Island Development Gem",
		icon = "IslandProps/item_100201",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10423,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_shop_goods[10424] = {
		desc = "A book containing fundamental knowledge on management techniques. Used to slightly increase a character's Management stat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Management Textbook T1",
		icon = "IslandProps/item_100011",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10424,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				41,
				100011,
				1
			}
		}
	}
	pg.base.island_shop_goods[10425] = {
		desc = "A book containing fundamental knowledge on farming techniques. Used to slightly increase a character's Farming stat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Farming Textbook T1",
		icon = "IslandProps/item_100021",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10425,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				41,
				100021,
				1
			}
		}
	}
	pg.base.island_shop_goods[10426] = {
		desc = "A book containing fundamental knowledge on manufacturing techniques. Used to slightly increase a character's Manufacturing stat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Manufacturing Textbook T1",
		icon = "IslandProps/item_100031",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10426,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				41,
				100031,
				1
			}
		}
	}
	pg.base.island_shop_goods[10427] = {
		desc = "A book containing fundamental knowledge on gathering techniques. Used to slightly increase a character's Gathering stat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Gathering Textbook T1",
		icon = "IslandProps/item_100041",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10427,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				41,
				100041,
				1
			}
		}
	}
	pg.base.island_shop_goods[10428] = {
		desc = "A book containing fundamental knowledge on husbandry techniques. Used to slightly increase a character's Husbandry stat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Husbandry Textbook T1",
		icon = "IslandProps/item_100051",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10428,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				41,
				100051,
				1
			}
		}
	}
	pg.base.island_shop_goods[10429] = {
		desc = "A book containing fundamental knowledge on cooking techniques. Used to slightly increase a character's Cooking stat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Cooking Textbook T1",
		icon = "IslandProps/item_100061",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1000,
		discount = 0,
		groups_detail_type = "",
		id = 10429,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				41,
				100061,
				1
			}
		}
	}
	pg.base.island_shop_goods[10430] = {
		desc = "A book containing detailed knowledge on management techniques. Used to moderately increase a character's Management stat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Management Textbook T2",
		icon = "IslandProps/item_100012",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 4000,
		discount = 0,
		groups_detail_type = "",
		id = 10430,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			40000
		},
		items = {
			{
				41,
				100012,
				1
			}
		}
	}
	pg.base.island_shop_goods[10431] = {
		desc = "A book containing detailed knowledge on farming techniques. Used to moderately increase a character's Farming stat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Farming Textbook T2",
		icon = "IslandProps/item_100022",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 4000,
		discount = 0,
		groups_detail_type = "",
		id = 10431,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			40000
		},
		items = {
			{
				41,
				100022,
				1
			}
		}
	}
	pg.base.island_shop_goods[10432] = {
		desc = "A book containing detailed knowledge on manufacturing techniques. Used to moderately increase a character's Manufacturing stat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Manufacturing Textbook T2",
		icon = "IslandProps/item_100032",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 4000,
		discount = 0,
		groups_detail_type = "",
		id = 10432,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			40000
		},
		items = {
			{
				41,
				100032,
				1
			}
		}
	}
	pg.base.island_shop_goods[10433] = {
		desc = "A book containing detailed knowledge on gathering techniques. Used to moderately increase a character's Gathering stat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Gathering Textbook T2",
		icon = "IslandProps/item_100042",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 4000,
		discount = 0,
		groups_detail_type = "",
		id = 10433,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			40000
		},
		items = {
			{
				41,
				100042,
				1
			}
		}
	}
	pg.base.island_shop_goods[10434] = {
		desc = "A book containing detailed knowledge on husbandry techniques. Used to moderately increase a character's Husbandry stat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Husbandry Textbook T2",
		icon = "IslandProps/item_100052",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 4000,
		discount = 0,
		groups_detail_type = "",
		id = 10434,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			40000
		},
		items = {
			{
				41,
				100052,
				1
			}
		}
	}
	pg.base.island_shop_goods[10435] = {
		desc = "A book containing detailed knowledge on cooking techniques. Used to moderately increase a character's Cooking stat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Cooking Textbook T2",
		icon = "IslandProps/item_100062",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 4000,
		discount = 0,
		groups_detail_type = "",
		id = 10435,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			40000
		},
		items = {
			{
				41,
				100062,
				1
			}
		}
	}
	pg.base.island_shop_goods[10436] = {
		desc = "A hardcover book that smells of ink and sports a classic vibe. It's worthy of going on your table and being reread time and time again.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Hardcover Book",
		icon = "IslandGoodsIcon/gift02",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10436,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10437] = {
		desc = "A gorgeous, fresh bouquet. Its flowers are brimming with color and life, and they promise joy for the days to come.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Bouquet",
		icon = "IslandGoodsIcon/gift03",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10437,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10438] = {
		desc = "This ceremonial sword with a flowing silhouette gives off the cold brilliance of steel. It silently speaks of order and majesty.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Ceremonial Sword",
		icon = "IslandGoodsIcon/gift04",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10438,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180004,
				1
			}
		}
	}
	pg.base.island_shop_goods[10439] = {
		desc = "An adorable stuffed animal that's soft to the touch. Give it a hug, and its fluffy warmth and innocent smile will soften your heart.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Fluffy Stuffed Animal",
		icon = "IslandGoodsIcon/gift05",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10439,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180005,
				1
			}
		}
	}
	pg.base.island_shop_goods[10440] = {
		desc = "The sands of time have poured over this ornament, turning it into an elegant antique. Quietly, it lends an air of tranquility to a room.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Antique Ornament",
		icon = "IslandGoodsIcon/gift06",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10440,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180006,
				1
			}
		}
	}
	pg.base.island_shop_goods[10441] = {
		desc = "An accessory that, although understated, glimmers with exceptional craftsmanship. It adds just a little light to every moment of one's life.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Exquisite Accessory",
		icon = "IslandGoodsIcon/gift07",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10441,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180007,
				1
			}
		}
	}
	pg.base.island_shop_goods[10442] = {
		desc = "A wonderfully pure aroma hides inside this modest flask. Just one spray of this fragrance brings out tones of refined class.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Premium Perfume",
		icon = "IslandGoodsIcon/gift08",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10442,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180008,
				1
			}
		}
	}
	pg.base.island_shop_goods[10443] = {
		desc = "An entertainment system that will fill up every moment of your spare time. This thoughtful gift contains just about all the content you need for a fun play session.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Game Console Set",
		icon = "IslandGoodsIcon/gift09",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10443,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180009,
				1
			}
		}
	}
	pg.base.island_shop_goods[10444] = {
		desc = "Tickets that glitter like the stars. Can be used to draw prizes in the Stellar Prize Draw. When the current run of the Stellar Prize Draw ends, any Stellar Tickets left over will be automatically used to draw prizes or be converted to Gems.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Stellar Tickets",
		icon = "IslandGoodsIcon/170000",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10444,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				8,
				170006,
				1
			}
		}
	}
	pg.base.island_shop_goods[10445] = {
		desc = "A book containing fundamental knowledge on island living. Used to slightly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 25,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T1",
		icon = "IslandProps/item_100001",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10445,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				100001,
				1
			}
		}
	}
	pg.base.island_shop_goods[10446] = {
		desc = "A book containing detailed knowledge on island living. Used to moderately increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T2",
		icon = "IslandProps/item_100002",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10446,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100002,
				1
			}
		}
	}
end)()
;(function()
	pg.base.island_shop_goods[10447] = {
		desc = "A book containing abundant knowledge on island living. Used to greatly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T3",
		icon = "IslandProps/item_100003",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1600,
		discount = 0,
		groups_detail_type = "",
		id = 10447,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			16000
		},
		items = {
			{
				41,
				100003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10448] = {
		desc = "A book containing fundamental knowledge on production techniques. Used to slightly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T1",
		icon = "IslandProps/item_100101",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 200,
		discount = 0,
		groups_detail_type = "",
		id = 10448,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			2000
		},
		items = {
			{
				41,
				100101,
				1
			}
		}
	}
	pg.base.island_shop_goods[10449] = {
		desc = "A book containing detailed knowledge on production techniques. Used to moderately increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T2",
		icon = "IslandProps/item_100102",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10449,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100102,
				1
			}
		}
	}
	pg.base.island_shop_goods[10450] = {
		desc = "A book containing abundant knowledge on production techniques. Used to greatly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 8,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T3",
		icon = "IslandProps/item_100103",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1500,
		discount = 0,
		groups_detail_type = "",
		id = 10450,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			15000
		},
		items = {
			{
				41,
				100103,
				1
			}
		}
	}
	pg.base.island_shop_goods[10451] = {
		desc = "A crystal of island development experience. Required to Limit Break characters.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 3,
		limited_show = 1,
		unlock = "",
		goods_name = "Island Development Gem",
		icon = "IslandProps/item_100201",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10451,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_shop_goods[10452] = {
		desc = "A hardcover book that smells of ink and sports a classic vibe. It's worthy of going on your table and being reread time and time again.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Hardcover Book",
		icon = "IslandGoodsIcon/gift02",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10452,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10453] = {
		desc = "A gorgeous, fresh bouquet. Its flowers are brimming with color and life, and they promise joy for the days to come.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Bouquet",
		icon = "IslandGoodsIcon/gift03",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10453,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10454] = {
		desc = "This ceremonial sword with a flowing silhouette gives off the cold brilliance of steel. It silently speaks of order and majesty.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Ceremonial Sword",
		icon = "IslandGoodsIcon/gift04",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10454,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180004,
				1
			}
		}
	}
	pg.base.island_shop_goods[10455] = {
		desc = "An adorable stuffed animal that's soft to the touch. Give it a hug, and its fluffy warmth and innocent smile will soften your heart.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Fluffy Stuffed Animal",
		icon = "IslandGoodsIcon/gift05",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10455,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180005,
				1
			}
		}
	}
	pg.base.island_shop_goods[10456] = {
		desc = "The sands of time have poured over this ornament, turning it into an elegant antique. Quietly, it lends an air of tranquility to a room.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Antique Ornament",
		icon = "IslandGoodsIcon/gift06",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10456,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180006,
				1
			}
		}
	}
	pg.base.island_shop_goods[10457] = {
		desc = "An accessory that, although understated, glimmers with exceptional craftsmanship. It adds just a little light to every moment of one's life.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Exquisite Accessory",
		icon = "IslandGoodsIcon/gift07",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10457,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180007,
				1
			}
		}
	}
	pg.base.island_shop_goods[10458] = {
		desc = "A wonderfully pure aroma hides inside this modest flask. Just one spray of this fragrance brings out tones of refined class.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Premium Perfume",
		icon = "IslandGoodsIcon/gift08",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10458,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180008,
				1
			}
		}
	}
	pg.base.island_shop_goods[10459] = {
		desc = "An entertainment system that will fill up every moment of your spare time. This thoughtful gift contains just about all the content you need for a fun play session.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 2,
		limited_show = 1,
		unlock = "",
		goods_name = "Game Console Set",
		icon = "IslandGoodsIcon/gift09",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10459,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180009,
				1
			}
		}
	}
	pg.base.island_shop_goods[10460] = {
		desc = "Tickets that glitter like the stars. Can be used to draw prizes in the Stellar Prize Draw. When the current run of the Stellar Prize Draw ends, any Stellar Tickets left over will be automatically used to draw prizes or be converted to Gems.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Stellar Tickets",
		icon = "IslandGoodsIcon/170000",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10460,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				8,
				170006,
				1
			}
		}
	}
	pg.base.island_shop_goods[10461] = {
		desc = "A book containing fundamental knowledge on island living. Used to slightly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 50,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T1",
		icon = "IslandProps/item_100001",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 20,
		discount = 0,
		groups_detail_type = "",
		id = 10461,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				100001,
				1
			}
		}
	}
	pg.base.island_shop_goods[10462] = {
		desc = "A book containing detailed knowledge on island living. Used to moderately increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 15,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T2",
		icon = "IslandProps/item_100002",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10462,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10463] = {
		desc = "A book containing abundant knowledge on island living. Used to greatly increase a character's Island EXP.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Island EXP Textbook T3",
		icon = "IslandProps/item_100003",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1600,
		discount = 0,
		groups_detail_type = "",
		id = 10463,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			16000
		},
		items = {
			{
				41,
				100003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10464] = {
		desc = "A book containing fundamental knowledge on production techniques. Used to slightly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T1",
		icon = "IslandProps/item_100101",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 200,
		discount = 0,
		groups_detail_type = "",
		id = 10464,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			2000
		},
		items = {
			{
				41,
				100101,
				1
			}
		}
	}
	pg.base.island_shop_goods[10465] = {
		desc = "A book containing detailed knowledge on production techniques. Used to moderately increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T2",
		icon = "IslandProps/item_100102",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 400,
		discount = 0,
		groups_detail_type = "",
		id = 10465,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			4000
		},
		items = {
			{
				41,
				100102,
				1
			}
		}
	}
	pg.base.island_shop_goods[10466] = {
		desc = "A book containing abundant knowledge on production techniques. Used to greatly increase a character's Production stats.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "Production Textbook T3",
		icon = "IslandProps/item_100103",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 1500,
		discount = 0,
		groups_detail_type = "",
		id = 10466,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			15000
		},
		items = {
			{
				41,
				100103,
				1
			}
		}
	}
	pg.base.island_shop_goods[10467] = {
		desc = "A crystal of island development experience. Required to Limit Break characters.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 5,
		limited_show = 1,
		unlock = "",
		goods_name = "Island Development Gem",
		icon = "IslandProps/item_100201",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 2000,
		discount = 0,
		groups_detail_type = "",
		id = 10467,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20000
		},
		items = {
			{
				41,
				100201,
				1
			}
		}
	}
	pg.base.island_shop_goods[10468] = {
		desc = "A hardcover book that smells of ink and sports a classic vibe. It's worthy of going on your table and being reread time and time again.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Hardcover Book",
		icon = "IslandGoodsIcon/gift02",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10468,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180002,
				1
			}
		}
	}
	pg.base.island_shop_goods[10469] = {
		desc = "A gorgeous, fresh bouquet. Its flowers are brimming with color and life, and they promise joy for the days to come.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Bouquet",
		icon = "IslandGoodsIcon/gift03",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10469,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180003,
				1
			}
		}
	}
	pg.base.island_shop_goods[10470] = {
		desc = "This ceremonial sword with a flowing silhouette gives off the cold brilliance of steel. It silently speaks of order and majesty.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Ceremonial Sword",
		icon = "IslandGoodsIcon/gift04",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10470,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180004,
				1
			}
		}
	}
	pg.base.island_shop_goods[10471] = {
		desc = "An adorable stuffed animal that's soft to the touch. Give it a hug, and its fluffy warmth and innocent smile will soften your heart.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Fluffy Stuffed Animal",
		icon = "IslandGoodsIcon/gift05",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10471,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180005,
				1
			}
		}
	}
	pg.base.island_shop_goods[10472] = {
		desc = "The sands of time have poured over this ornament, turning it into an elegant antique. Quietly, it lends an air of tranquility to a room.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Antique Ornament",
		icon = "IslandGoodsIcon/gift06",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10472,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180006,
				1
			}
		}
	}
	pg.base.island_shop_goods[10473] = {
		desc = "An accessory that, although understated, glimmers with exceptional craftsmanship. It adds just a little light to every moment of one's life.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Exquisite Accessory",
		icon = "IslandGoodsIcon/gift07",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10473,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180007,
				1
			}
		}
	}
	pg.base.island_shop_goods[10474] = {
		desc = "A wonderfully pure aroma hides inside this modest flask. Just one spray of this fragrance brings out tones of refined class.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Premium Perfume",
		icon = "IslandGoodsIcon/gift08",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10474,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180008,
				1
			}
		}
	}
	pg.base.island_shop_goods[10475] = {
		desc = "An entertainment system that will fill up every moment of your spare time. This thoughtful gift contains just about all the content you need for a fun play session.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 4,
		limited_show = 1,
		unlock = "",
		goods_name = "Game Console Set",
		icon = "IslandGoodsIcon/gift09",
		goods_detail_type = 1,
		time = "always",
		remian_show = 1,
		pt_award = 300,
		discount = 0,
		groups_detail_type = "",
		id = 10475,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			3000
		},
		items = {
			{
				2,
				180009,
				1
			}
		}
	}
	pg.base.island_shop_goods[103000] = {
		desc = "Feed for the Clucky Clucky Bird. Made by processing wheat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 0,
		limited_show = 0,
		unlock = "",
		goods_name = "Clucky Clucky Bird Feed",
		icon = "IslandProps/item_3000",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 103000,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			2000,
			30
		},
		items = {
			{
				41,
				3000,
				10
			}
		}
	}
	pg.base.island_shop_goods[103001] = {
		desc = "Feed for the Oinky Oinky Pig. Made by processing corn.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 0,
		limited_show = 0,
		unlock = "",
		goods_name = "Oinky Oinky Pig Feed",
		icon = "IslandProps/item_3001",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 103001,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			2001,
			30
		},
		items = {
			{
				41,
				3001,
				10
			}
		}
	}
	pg.base.island_shop_goods[103002] = {
		desc = "Feed for the Moo Moo Cow. Made by processing grass.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 0,
		limited_show = 0,
		unlock = "",
		goods_name = "Moo Moo Cow Feed",
		icon = "IslandProps/item_3002",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 103002,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			2008,
			30
		},
		items = {
			{
				41,
				3002,
				10
			}
		}
	}
	pg.base.island_shop_goods[103003] = {
		desc = "Feed for the Baa Baa Sheep. Made by processing grass.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 0,
		limited_show = 0,
		unlock = "",
		goods_name = "Baa Baa Sheep Feed",
		icon = "IslandProps/item_3003",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 103003,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			2008,
			30
		},
		items = {
			{
				41,
				3003,
				10
			}
		}
	}
	pg.base.island_shop_goods[103004] = {
		desc = "Flour made from ground wheat.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 0,
		limited_show = 0,
		unlock = "",
		goods_name = "Flour",
		icon = "IslandProps/item_3004",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 103004,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			2000,
			6
		},
		items = {
			{
				41,
				3004,
				1
			}
		}
	}
	pg.base.island_shop_goods[111500] = {
		desc = "A lure shaped like an earthworm. Fish are likely to go for it on account of its realistic appearance.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Earthworm",
		icon = "IslandProps/item_1500",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 111500,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				41,
				1500,
				1
			}
		}
	}
	pg.base.island_shop_goods[111502] = {
		desc = "A lure carefully made to look like a shelled shrimp.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Shelled Shrimp",
		icon = "IslandProps/item_1502",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 111502,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			25000
		},
		items = {
			{
				41,
				1502,
				1
			}
		}
	}
	pg.base.island_shop_goods[111503] = {
		desc = "A lure with a distinctive shape.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Octopus Arm",
		icon = "IslandProps/item_1503",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 111503,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			25000
		},
		items = {
			{
				41,
				1503,
				1
			}
		}
	}
	pg.base.island_shop_goods[111101] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "A juvenile bivalve. It exhibits stable growth, with good cultivation techniques in place.",
		goods_name = "Shellfish Spat",
		icon = "IslandProps/item_1101",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 111101,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			100
		},
		items = {
			{
				41,
				1101,
				1
			}
		},
		unlock = {
			3201003
		}
	}
	pg.base.island_shop_goods[111102] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "A juvenile benthic freshwater fish. It's resilient to low-oxygen environments and is suited for high-density cultivation in fish pens with muddy bottoms.",
		goods_name = "Catfish Fry",
		icon = "IslandProps/item_1102",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 111102,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			100
		},
		items = {
			{
				41,
				1102,
				1
			}
		},
		unlock = {
			3201012
		}
	}
	pg.base.island_shop_goods[111103] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "A juvenile omnivorous freshwater fish. It's highly adaptable to its environment, and exhibits stable growth in all kinds of water conditions.",
		goods_name = "Koi Carp Fry",
		icon = "IslandProps/item_1103",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 111103,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			150
		},
		items = {
			{
				41,
				1103,
				1
			}
		},
		unlock = {
			3201002
		}
	}
	pg.base.island_shop_goods[111104] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "A juvenile freshwater fish. It mainly eats algae and organic matter, contributing to the ecosystem's maintenance.",
		goods_name = "Common Carp Fry",
		icon = "IslandProps/item_1104",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 111104,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			150
		},
		items = {
			{
				41,
				1104,
				1
			}
		},
		unlock = {
			3201013
		}
	}
	pg.base.island_shop_goods[111105] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "A juvenile freshwater shrimp. It eats leftover feed and some species of algae, functioning as a natural cleaner.",
		goods_name = "Freshwater Shrimp Fry",
		icon = "IslandProps/item_1105",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 111105,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				1105,
				1
			}
		},
		unlock = {
			3201001
		}
	}
	pg.base.island_shop_goods[111106] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "A juvenile crustacean. Its shell turns red and becomes hard as it grows. Its mature form is traded as a popular marine product.",
		goods_name = "Crayfish Fry",
		icon = "IslandProps/item_1106",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 111106,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				1106,
				1
			}
		},
		unlock = {
			3201004
		}
	}
	pg.base.island_shop_goods[111107] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "A juvenile carnivorous fish. Its meat is tender, and it's cultivated as a high-quality edible fish.",
		goods_name = "Sea Bass Fry",
		icon = "IslandProps/item_1107",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 111107,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			200
		},
		items = {
			{
				41,
				1107,
				1
			}
		},
		unlock = {
			3201014
		}
	}
	pg.base.island_shop_goods[111108] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "A juvenile crab that frequently molts. It needs to be raised in a clean water environment.",
		goods_name = "Juvenile Crab",
		icon = "IslandProps/item_1108",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 111108,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			300
		},
		items = {
			{
				41,
				1108,
				1
			}
		},
		unlock = {
			3201008
		}
	}
	pg.base.island_shop_goods[111201] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "A juvenile cephalopod. After undergoing several transformations during its growth process, it develops tender flesh.",
		goods_name = "Squid Fry",
		icon = "IslandProps/item_1201",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 111201,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			120
		},
		items = {
			{
				41,
				1201,
				1
			}
		},
		unlock = {
			3201007
		}
	}
	pg.base.island_shop_goods[111202] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "A juvenile carnivorous fish. It's often found in the middle water layers and boasts good growth potential.",
		goods_name = "Mackerel Fry",
		icon = "IslandProps/item_1202",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 111202,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			180
		},
		items = {
			{
				41,
				1202,
				1
			}
		},
		unlock = {
			3201009
		}
	}
	pg.base.island_shop_goods[111203] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "A juvenile large palegic fish. It grows quickly and demands an aquatic environment with ample oxygen supply.",
		goods_name = "Tuna Fry",
		icon = "IslandProps/item_1203",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 111203,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			240
		},
		items = {
			{
				41,
				1203,
				1
			}
		},
		unlock = {
			3201010
		}
	}
	pg.base.island_shop_goods[111204] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "A juvenile migratory fish. It loves cooler waters and develops a delectable flesh through gentle care.",
		goods_name = "Salmon Fry",
		icon = "IslandProps/item_1204",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 111204,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			240
		},
		items = {
			{
				41,
				1204,
				1
			}
		},
		unlock = {
			3201005
		}
	}
	pg.base.island_shop_goods[111205] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "A juvenile warm saltwater fish. It gains a vibrant body color after finishing its growth, making it a prized ornamental fish.",
		goods_name = "Red Sea Bream Fry",
		icon = "IslandProps/item_1205",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 111205,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			120
		},
		items = {
			{
				41,
				1205,
				1
			}
		},
		unlock = {
			3201015
		}
	}
	pg.base.island_shop_goods[111206] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "A juvenile fish that lives in coral reefs. Its robust constitution makes it easy to cultivate.",
		goods_name = "Black Porgy Fry",
		icon = "IslandProps/item_1206",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 111206,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			180
		},
		items = {
			{
				41,
				1206,
				1
			}
		},
		unlock = {
			3201016
		}
	}
	pg.base.island_shop_goods[111207] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "A juvenile yellowfin tuna. It's a quick swimmer and demands oxygen-rich waters for successful cultivation.",
		goods_name = "Yellowfin Tuna Fry",
		icon = "IslandProps/item_1207",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 111207,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			360
		},
		items = {
			{
				41,
				1207,
				1
			}
		},
		unlock = {
			3201011
		}
	}
	pg.base.island_shop_goods[111208] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "A juvenile benthic echinoderm. It subsists on accumulated organic matter, so it cleans the bottom of the fish pen efficiently.",
		goods_name = "Sea Cucumber Fry",
		icon = "IslandProps/item_1208",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 111208,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			360
		},
		items = {
			{
				41,
				1208,
				1
			}
		},
		unlock = {
			3201006
		}
	}
	pg.base.island_shop_goods[411000] = {
		desc = "Purchase to receive Wheat Seeds.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 0,
		limited_show = 0,
		unlock = "",
		goods_name = "Wheat Seeds",
		icon = "IslandProps/item_1000",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411000,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20
		},
		items = {
			{
				41,
				1000,
				1
			}
		}
	}
	pg.base.island_shop_goods[411001] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "Purchase to receive Corn Seeds.",
		goods_name = "Corn Seeds",
		icon = "IslandProps/item_1001",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411001,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			40
		},
		items = {
			{
				41,
				1001,
				1
			}
		},
		unlock = {
			3101002
		}
	}
	pg.base.island_shop_goods[411002] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "Purchase to receive Upland Rice Seeds",
		goods_name = "Upland Rice Seeds",
		icon = "IslandProps/item_1002",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411002,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			40
		},
		items = {
			{
				41,
				1002,
				1
			}
		},
		unlock = {
			3101005
		}
	}
	pg.base.island_shop_goods[411003] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "Purchase to receive Napa Cabbage Seeds.",
		goods_name = "Napa Cabbage Seeds",
		icon = "IslandProps/item_1003",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411003,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			60
		},
		items = {
			{
				41,
				1003,
				1
			}
		},
		unlock = {
			3101006
		}
	}
	pg.base.island_shop_goods[411004] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "Purchase to receive Carrot Seeds.",
		goods_name = "Carrot Seeds",
		icon = "IslandProps/item_1004",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411004,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			100
		},
		items = {
			{
				41,
				1004,
				1
			}
		},
		unlock = {
			3502006
		}
	}
	pg.base.island_shop_goods[411005] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "Purchase to receive Potato Seeds.",
		goods_name = "Potato Seeds",
		icon = "IslandProps/item_1005",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411005,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20
		},
		items = {
			{
				41,
				1005,
				1
			}
		},
		unlock = {
			3101008
		}
	}
	pg.base.island_shop_goods[411006] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "Purchase to receive Soy Bean Seeds.",
		goods_name = "Soy Bean Seeds",
		icon = "IslandProps/item_1006",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411006,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			60
		},
		items = {
			{
				41,
				1006,
				1
			}
		},
		unlock = {
			3101007
		}
	}
	pg.base.island_shop_goods[411007] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "Purchase to receive Onion Seeds.",
		goods_name = "Onion Seeds",
		icon = "IslandProps/item_1007",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411007,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			120
		},
		items = {
			{
				41,
				1007,
				1
			}
		},
		unlock = {
			3502007
		}
	}
	pg.base.island_shop_goods[411008] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "Purchase to receive Grass Seeds.",
		goods_name = "Grass Seeds",
		icon = "IslandProps/item_1008",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411008,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			20
		},
		items = {
			{
				41,
				1008,
				1
			}
		},
		unlock = {
			3101003
		}
	}
	pg.base.island_shop_goods[411009] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "Purchase to receive Coffee Tree Seeds.",
		goods_name = "Coffee Tree Seeds",
		icon = "IslandProps/item_1009",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411009,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			120
		},
		items = {
			{
				41,
				1009,
				1
			}
		},
		unlock = {
			3101004
		}
	}
	pg.base.island_shop_goods[411010] = {
		desc = "Purchase to receive Flax Seeds.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 0,
		limited_show = 0,
		unlock = "",
		goods_name = "Flax Seeds",
		icon = "IslandProps/item_1010",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411010,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			60
		},
		items = {
			{
				41,
				1010,
				1
			}
		}
	}
	pg.base.island_shop_goods[411011] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "Purchase to receive Strawberry Seeds.",
		goods_name = "Strawberry Seeds",
		icon = "IslandProps/item_1011",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411011,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			120
		},
		items = {
			{
				41,
				1011,
				1
			}
		},
		unlock = {
			3502002
		}
	}
	pg.base.island_shop_goods[411012] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "Purchase to receive Cotton Seeds.",
		goods_name = "Cotton Seeds",
		icon = "IslandProps/item_1012",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411012,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			80
		},
		items = {
			{
				41,
				1012,
				1
			}
		},
		unlock = {
			3502003
		}
	}
	pg.base.island_shop_goods[411014] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "Purchase to receive Tea Tree Seeds.",
		goods_name = "Tea Tree Seeds",
		icon = "IslandProps/item_1014",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411014,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			150
		},
		items = {
			{
				41,
				1014,
				1
			}
		},
		unlock = {
			3502004
		}
	}
	pg.base.island_shop_goods[411015] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "Purchase to receive Lavender Seeds.",
		goods_name = "Lavender Seeds",
		icon = "IslandProps/item_1015",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411015,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			160
		},
		items = {
			{
				41,
				1015,
				1
			}
		},
		unlock = {
			3502005
		}
	}
	pg.base.island_shop_goods[411016] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "Purchase to receive Apple Tree Seeds.",
		goods_name = "Apple Tree Seeds",
		icon = "IslandProps/item_1016",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411016,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			100
		},
		items = {
			{
				41,
				1016,
				1
			}
		},
		unlock = {
			3501001
		}
	}
	pg.base.island_shop_goods[411017] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "Purchase to receive Citrus Fruit Tree Seeds.",
		goods_name = "Citrus Fruit Tree Seeds",
		icon = "IslandProps/item_1017",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411017,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			120
		},
		items = {
			{
				41,
				1017,
				1
			}
		},
		unlock = {
			3501002
		}
	}
	pg.base.island_shop_goods[411018] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "Purchase to receive Banana Tree Seeds.",
		goods_name = "Banana Tree Seed",
		icon = "IslandProps/item_1018",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411018,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			140
		},
		items = {
			{
				41,
				1018,
				1
			}
		},
		unlock = {
			3501003
		}
	}
	pg.base.island_shop_goods[411019] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "Purchase to receive Mango tree Seeds.",
		goods_name = "Mango Tree Seeds",
		icon = "IslandProps/item_1019",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411019,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			180
		},
		items = {
			{
				41,
				1019,
				1
			}
		},
		unlock = {
			3501004
		}
	}
	pg.base.island_shop_goods[411020] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "Purchase to receive Lemon Tree Seeds.",
		goods_name = "Lemon Tree Seed",
		icon = "IslandProps/item_1020",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411020,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			80
		},
		items = {
			{
				41,
				1020,
				1
			}
		},
		unlock = {
			3501005
		}
	}
	pg.base.island_shop_goods[411021] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "Purchase to receive Avocado Tree Seeds.",
		goods_name = "Avocado Tree Seeds",
		icon = "IslandProps/item_1021",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411021,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			240
		},
		items = {
			{
				41,
				1021,
				1
			}
		},
		unlock = {
			3501006
		}
	}
	pg.base.island_shop_goods[411022] = {
		pay_id = 0,
		goods_have = 0,
		items_model = "",
		have_show = 0,
		limited_show = 0,
		limited_num = 0,
		desc = "Purchase to receive Rubber Tree Seeds.",
		goods_name = "Rubber Tree Seeds",
		icon = "IslandProps/item_1022",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411022,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			280
		},
		items = {
			{
				41,
				1022,
				1
			}
		},
		unlock = {
			3501007
		}
	}
	pg.base.island_shop_goods[411023] = {
		desc = "Purchase to receive Yoizuki Pear Seeds.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 0,
		limited_show = 0,
		unlock = "",
		goods_name = "Yoizuki Pear Seeds",
		icon = "IslandProps/item_4006",
		goods_detail_type = 1,
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411023,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			120
		},
		items = {
			{
				41,
				4006,
				1
			}
		},
		time = {
			{
				{
					2026,
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
					2026,
					11,
					4
				},
				{
					23,
					59,
					59
				}
			}
		}
	}
	pg.base.island_shop_goods[411024] = {
		desc = "Purchase to receive Kaki Persimmon Seeds.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 0,
		limited_show = 0,
		unlock = "",
		goods_name = "Kaki Persimmon Seeds",
		icon = "IslandProps/item_4008",
		goods_detail_type = 1,
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411024,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			180
		},
		items = {
			{
				41,
				4008,
				1
			}
		},
		time = {
			{
				{
					2026,
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
					2026,
					11,
					4
				},
				{
					23,
					59,
					59
				}
			}
		}
	}
	pg.base.island_shop_goods[411025] = {
		desc = "Purchase to receive Asparagus Seeds.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 0,
		limited_show = 0,
		unlock = "",
		goods_name = "Asparagus Seeds",
		icon = "IslandProps/item_4020",
		goods_detail_type = 1,
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411025,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			120
		},
		items = {
			{
				41,
				4020,
				1
			}
		},
		time = {
			{
				{
					2026,
					2,
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
					2026,
					5,
					6
				},
				{
					23,
					59,
					59
				}
			}
		}
	}
	pg.base.island_shop_goods[411026] = {
		desc = "Purchase to receive Pineapple Seeds.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 0,
		limited_show = 0,
		unlock = "",
		goods_name = "Pineapple Seeds",
		icon = "IslandProps/item_4022",
		goods_detail_type = 1,
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411026,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			180
		},
		items = {
			{
				41,
				4022,
				1
			}
		},
		time = {
			{
				{
					2026,
					2,
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
					2026,
					5,
					6
				},
				{
					23,
					59,
					59
				}
			}
		}
	}
	pg.base.island_shop_goods[411027] = {
		desc = "Purchase to receive Tomato Seeds.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 0,
		limited_show = 0,
		unlock = "",
		goods_name = "Tomato Seeds",
		icon = "IslandProps/item_4034",
		goods_detail_type = 1,
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411027,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			120
		},
		items = {
			{
				41,
				4034,
				1
			}
		},
		time = {
			{
				{
					2026,
					5,
					7
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
		}
	}
	pg.base.island_shop_goods[411028] = {
		desc = "Purchase to receive Cucumber Seeds.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 0,
		limited_show = 0,
		unlock = "",
		goods_name = "Cucumber Seeds",
		icon = "IslandProps/item_4036",
		goods_detail_type = 1,
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 411028,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			80
		},
		items = {
			{
				41,
				4036,
				1
			}
		},
		time = {
			{
				{
					2026,
					5,
					7
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
		}
	}
	pg.base.island_shop_goods[412000] = {
		desc = "Purchase to receive Outfit Colors.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 0,
		limited_show = 0,
		unlock = "",
		goods_name = "Outfit Colors",
		icon = "IslandGoodsIcon/3",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 412000,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			100
		},
		items = {
			{
				41,
				3,
				1
			}
		}
	}
	pg.base.island_shop_goods[412001] = {
		desc = "An Island Authority Permit for Chen Hai. Use it to give the character the credentials to visit the island freely.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Island Authority Permit: Chen Hai",
		icon = "IslandProps/item_200017",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 412001,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			500000
		},
		items = {
			{
				44,
				50601,
				1
			}
		}
	}
	pg.base.island_shop_goods[412002] = {
		desc = "An Island Authority Permit for Laffey. Use it to give the character the credentials to visit the island freely.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Island Authority Permit: Laffey",
		icon = "IslandProps/item_200025",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 412002,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			500000
		},
		items = {
			{
				44,
				10117,
				1
			}
		}
	}
	pg.base.island_shop_goods[412003] = {
		desc = "An Island Authority Permit for Royal Fortune. Use it to give the character the credentials to visit the island freely.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 1,
		limited_show = 1,
		unlock = "",
		goods_name = "Island Authority Permit: Royal Fortune",
		icon = "IslandProps/item_200033",
		goods_detail_type = 1,
		time = "always",
		remian_show = 0,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 412003,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			500000
		},
		items = {
			{
				44,
				960001,
				1
			}
		}
	}
	pg.base.island_shop_goods[4600001] = {
		desc = "Purchase to receive Cotton Candy Clouds, a floating character outfit.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Cotton Candy Clouds",
		icon = "IslandDressIcon/dress_2020001",
		goods_detail_type = 2,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 4600001,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			200
		},
		items = {
			{
				46,
				2020001,
				1
			}
		}
	}
	pg.base.island_shop_goods[4600002] = {
		desc = "Purchase to receive Trail of Dancing Cherry Blossoms, a character outfit that goes in the trail slot.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Trail of Dancing Cherry Blossoms",
		icon = "IslandDressIcon/dress_2030004",
		goods_detail_type = 2,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 4600002,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			200
		},
		items = {
			{
				46,
				2030004,
				1
			}
		}
	}
	pg.base.island_shop_goods[4600003] = {
		desc = "Purchase to receive Rocket Pack, a character outfit that goes on the back.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Rocket Pack",
		icon = "IslandDressIcon/dress_2010001",
		goods_detail_type = 2,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 4600003,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			200
		},
		items = {
			{
				46,
				2010001,
				1
			}
		}
	}
	pg.base.island_shop_goods[4620004] = {
		desc = "Purchase to receive Trail of Dream Bubbles, a floating character outfit.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Trail of Dream Bubbles",
		icon = "IslandDressIcon/dress_2020004",
		goods_detail_type = 2,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 4620004,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			200
		},
		items = {
			{
				46,
				2020004,
				1
			}
		}
	}
	pg.base.island_shop_goods[4630005] = {
		desc = "Purchase to receive Trail of Ephemeral Splashes, a character outfit that goes in the trail slot.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Trail of Ephemeral Splashes",
		icon = "IslandDressIcon/dress_2030005",
		goods_detail_type = 2,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 4630005,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			200
		},
		items = {
			{
				46,
				2030005,
				1
			}
		}
	}
	pg.base.island_shop_goods[4610003] = {
		desc = "Purchase to receive The Joys of Fishing, a character outfit that goes on the back.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "The Joys of Fishing",
		icon = "IslandDressIcon/dress_2010003",
		goods_detail_type = 2,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 4610003,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			200
		},
		items = {
			{
				46,
				2010003,
				1
			}
		}
	}
	pg.base.island_shop_goods[4620007] = {
		desc = "Purchase to receive Sea Salt Ice Cream, a floating character outfit.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Sea Salt Ice Cream",
		icon = "IslandDressIcon/dress_2020007",
		goods_detail_type = 2,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 4620007,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			200
		},
		items = {
			{
				46,
				2020007,
				1
			}
		}
	}
	pg.base.island_shop_goods[4630008] = {
		desc = "Purchase to receive Fruity Bubbles, a character outfit that goes in the trail slot.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Fruity Bubbles",
		icon = "IslandDressIcon/dress_2030008",
		goods_detail_type = 2,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 4630008,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			200
		},
		items = {
			{
				46,
				2030008,
				1
			}
		}
	}
	pg.base.island_shop_goods[4610006] = {
		desc = "Purchase to receive Shaved Ice Treat, a character outfit that goes on the back.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Shaved Ice Treat",
		icon = "IslandDressIcon/dress_2010006",
		goods_detail_type = 2,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 4610006,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			200
		},
		items = {
			{
				46,
				2010006,
				1
			}
		}
	}
	pg.base.island_shop_goods[4620008] = {
		desc = "Purchase to receive Kitty Play Toy, a floating character outfit.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Kitty Play Toy",
		icon = "IslandDressIcon/dress_2020008",
		goods_detail_type = 2,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 4620008,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			200
		},
		items = {
			{
				46,
				2020008,
				1
			}
		}
	}
	pg.base.island_shop_goods[4630009] = {
		desc = "Purchase to receive Kitty Pawprints, a character outfit that goes in the trail slot.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Kitty Pawprints",
		icon = "IslandDressIcon/dress_2030009",
		goods_detail_type = 2,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 4630009,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			200
		},
		items = {
			{
				46,
				2030009,
				1
			}
		}
	}
	pg.base.island_shop_goods[4610008] = {
		desc = "Purchase to receive Fluffy Kitty Tail, a character outfit that goes on the back.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Fluffy Kitty Tail",
		icon = "IslandDressIcon/dress_2010008",
		goods_detail_type = 2,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 4610008,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			200
		},
		items = {
			{
				46,
				2010008,
				1
			}
		}
	}
	pg.base.island_shop_goods[5010001] = {
		desc = "Can be used to shorten an active task by 1 minute. Make tomorrow's developments into today's!",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 100,
		limited_show = 1,
		unlock = "",
		goods_name = "1 Min. Express Ticket (Seasonal)",
		icon = "IslandGoodsIcon/item_speedup_ticket1",
		goods_detail_type = 1,
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 5010001,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			1000
		},
		items = {
			{
				50,
				10001,
				1
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
		}
	}
	pg.base.island_shop_goods[5020001] = {
		desc = "Can be used to shorten an active task by 10 minutes. Make tomorrow's developments into today's!",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 30,
		limited_show = 1,
		unlock = "",
		goods_name = "10 Min. Express Ticket (Seasonal)",
		icon = "IslandGoodsIcon/item_speedup_ticket2",
		goods_detail_type = 1,
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 5020001,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				50,
				20001,
				1
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
		}
	}
	pg.base.island_shop_goods[5030001] = {
		desc = "Can be used to shorten an active task by 60 minutes. Make tomorrow's developments into today's!",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "60 Min. Express Ticket (Seasonal)",
		icon = "IslandGoodsIcon/item_speedup_ticket3",
		goods_detail_type = 1,
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 5030001,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			60000
		},
		items = {
			{
				50,
				30001,
				1
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
		}
	}
end)()
;(function()
	pg.base.island_shop_goods[5010002] = {
		desc = "Can be used to shorten an active task by 1 minute. Make tomorrow's developments into today's!",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 100,
		limited_show = 1,
		unlock = "",
		goods_name = "1 Min. Express Ticket (Seasonal)",
		icon = "IslandGoodsIcon/item_speedup_ticket1",
		goods_detail_type = 1,
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 5010002,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			1000
		},
		items = {
			{
				50,
				10005,
				1
			}
		},
		time = {
			{
				{
					2026,
					2,
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
					2026,
					5,
					6
				},
				{
					23,
					59,
					59
				}
			}
		}
	}
	pg.base.island_shop_goods[5020002] = {
		desc = "Can be used to shorten an active task by 10 minutes. Make tomorrow's developments into today's!",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 30,
		limited_show = 1,
		unlock = "",
		goods_name = "10 Min. Express Ticket (Seasonal)",
		icon = "IslandGoodsIcon/item_speedup_ticket2",
		goods_detail_type = 1,
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 5020002,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				50,
				20005,
				1
			}
		},
		time = {
			{
				{
					2026,
					2,
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
					2026,
					5,
					6
				},
				{
					23,
					59,
					59
				}
			}
		}
	}
	pg.base.island_shop_goods[5030002] = {
		desc = "Can be used to shorten an active task by 60 minutes. Make tomorrow's developments into today's!",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "60 Min. Express Ticket (Seasonal)",
		icon = "IslandGoodsIcon/item_speedup_ticket3",
		goods_detail_type = 1,
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 5030002,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			60000
		},
		items = {
			{
				50,
				30005,
				1
			}
		},
		time = {
			{
				{
					2026,
					2,
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
					2026,
					5,
					6
				},
				{
					23,
					59,
					59
				}
			}
		}
	}
	pg.base.island_shop_goods[5010003] = {
		desc = "Can be used to shorten an active task by 1 minute. Make tomorrow's developments into today's!",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 100,
		limited_show = 1,
		unlock = "",
		goods_name = "1 Min. Express Ticket (Seasonal)",
		icon = "IslandGoodsIcon/item_speedup_ticket1",
		goods_detail_type = 1,
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 5010003,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			1000
		},
		items = {
			{
				50,
				10006,
				1
			}
		},
		time = {
			{
				{
					2026,
					5,
					7
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
		}
	}
	pg.base.island_shop_goods[5020003] = {
		desc = "Can be used to shorten an active task by 10 minutes. Make tomorrow's developments into today's!",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 30,
		limited_show = 1,
		unlock = "",
		goods_name = "10 Min. Express Ticket (Seasonal)",
		icon = "IslandGoodsIcon/item_speedup_ticket2",
		goods_detail_type = 1,
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 5020003,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				50,
				20006,
				1
			}
		},
		time = {
			{
				{
					2026,
					5,
					7
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
		}
	}
	pg.base.island_shop_goods[5030003] = {
		desc = "Can be used to shorten an active task by 60 minutes. Make tomorrow's developments into today's!",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "60 Min. Express Ticket (Seasonal)",
		icon = "IslandGoodsIcon/item_speedup_ticket3",
		goods_detail_type = 1,
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 5030003,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			60000
		},
		items = {
			{
				50,
				30006,
				1
			}
		},
		time = {
			{
				{
					2026,
					5,
					7
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
		}
	}
	pg.base.island_shop_goods[5010004] = {
		desc = "Can be used to shorten an active task by 1 minute. Make tomorrow's developments into today's!",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 100,
		limited_show = 1,
		unlock = "",
		goods_name = "1 Min. Express Ticket (Seasonal)",
		icon = "IslandGoodsIcon/item_speedup_ticket1",
		goods_detail_type = 1,
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 5010004,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			1000
		},
		items = {
			{
				50,
				10007,
				1
			}
		},
		time = {
			{
				{
					2026,
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
					2026,
					11,
					4
				},
				{
					23,
					59,
					59
				}
			}
		}
	}
	pg.base.island_shop_goods[5020004] = {
		desc = "Can be used to shorten an active task by 10 minutes. Make tomorrow's developments into today's!",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 30,
		limited_show = 1,
		unlock = "",
		goods_name = "10 Min. Express Ticket (Seasonal)",
		icon = "IslandGoodsIcon/item_speedup_ticket2",
		goods_detail_type = 1,
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 5020004,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			10000
		},
		items = {
			{
				50,
				20007,
				1
			}
		},
		time = {
			{
				{
					2026,
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
					2026,
					11,
					4
				},
				{
					23,
					59,
					59
				}
			}
		}
	}
	pg.base.island_shop_goods[5030004] = {
		desc = "Can be used to shorten an active task by 60 minutes. Make tomorrow's developments into today's!",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 0,
		limited_num = 10,
		limited_show = 1,
		unlock = "",
		goods_name = "60 Min. Express Ticket (Seasonal)",
		icon = "IslandGoodsIcon/item_speedup_ticket3",
		goods_detail_type = 1,
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 5030004,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			60000
		},
		items = {
			{
				50,
				30007,
				1
			}
		},
		time = {
			{
				{
					2026,
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
					2026,
					11,
					4
				},
				{
					23,
					59,
					59
				}
			}
		}
	}
	pg.base.island_shop_goods[471070301] = {
		desc = "Purchase to receive Canvas Day, an island costume for Saratoga.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Canvas Day",
		icon = "IslandGoodsIcon/skin_1070301",
		goods_detail_type = 4,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 471070301,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			900
		},
		items = {
			{
				47,
				1070301,
				1
			}
		}
	}
	pg.base.island_shop_goods[473120101] = {
		desc = "Purchase to receive Night of the Empty Bell, an island costume for Akashi.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Night of the Empty Bell",
		icon = "IslandGoodsIcon/skin_3120101",
		goods_detail_type = 4,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 473120101,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			900
		},
		items = {
			{
				47,
				3120101,
				1
			}
		}
	}
	pg.base.island_shop_goods[471051701] = {
		desc = "Purchase to receive Daily Steps, an island costume for New Jersey.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Daily Steps",
		icon = "IslandGoodsIcon/skin_1051701",
		goods_detail_type = 4,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 471051701,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			900
		},
		items = {
			{
				47,
				1051701,
				1
			}
		}
	}
	pg.base.island_shop_goods[471011001] = {
		desc = "Purchase to receive Limitless Energy!, a character outfit for William D. Porter.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Limitless Energy!",
		icon = "IslandGoodsIcon/skin_1011001",
		goods_detail_type = 4,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 471011001,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			900
		},
		items = {
			{
				47,
				1011001,
				1
			}
		}
	}
	pg.base.island_shop_goods[475060101] = {
		desc = "Purchase to receive Planning Comes Later, a character outfit for Chen Hai.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Planning Comes Later",
		icon = "IslandGoodsIcon/skin_5060101",
		goods_detail_type = 4,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 475060101,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			900
		},
		items = {
			{
				47,
				5060101,
				1
			}
		}
	}
	pg.base.island_shop_goods[474030301] = {
		desc = "Purchase to receive Lazy Service, a character outfit for Prinz Eugen.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Lazy Service",
		icon = "IslandGoodsIcon/skin_4030301",
		goods_detail_type = 4,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 474030301,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			900
		},
		items = {
			{
				47,
				4030301,
				1
			}
		}
	}
	pg.base.island_shop_goods[471011701] = {
		desc = "Purchase to receive Bunny Sleepwear, a character outfit for Laffey.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Bunny Sleepwear",
		icon = "IslandGoodsIcon/skin_1011701",
		goods_detail_type = 4,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 471011701,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			900
		},
		items = {
			{
				47,
				1011701,
				1
			}
		}
	}
	pg.base.island_shop_goods[472012101] = {
		desc = "Purchase to receive Operation: Pillow Fight, a character outfit for Javelin.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Operation: Pillow Fight",
		icon = "IslandGoodsIcon/skin_2012101",
		goods_detail_type = 4,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 472012101,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			900
		},
		items = {
			{
				47,
				2012101,
				1
			}
		}
	}
	pg.base.island_shop_goods[473031101] = {
		desc = "Purchase to receive Bedside Bared Hearts, a character outfit for Takao.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Bedside Bared Hearts",
		icon = "IslandGoodsIcon/skin_3031101",
		goods_detail_type = 4,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 473031101,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			900
		},
		items = {
			{
				47,
				3031101,
				1
			}
		}
	}
	pg.base.island_shop_goods[472021201] = {
		desc = "Purchase to receive One Afternoon's Page, a character outfit for Belfast.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "One Afternoon's Page",
		icon = "IslandGoodsIcon/skin_2021201",
		goods_detail_type = 4,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 472021201,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			900
		},
		items = {
			{
				47,
				2021201,
				1
			}
		}
	}
	pg.base.island_shop_goods[479600011] = {
		desc = "Purchase to receive Prologue to School, a character outfit for Royal Fortune.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Prologue to School",
		icon = "IslandGoodsIcon/skin_96000101",
		goods_detail_type = 4,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 479600011,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			900
		},
		items = {
			{
				47,
				96000101,
				1
			}
		}
	}
	pg.base.island_shop_goods[99000101] = {
		desc = "Purchase to receive Cheerful Route to School, a character outfit for Oceana.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Cheerful Route to School",
		icon = "IslandGoodsIcon/skin_99000101",
		goods_detail_type = 4,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 99000101,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			2000000
		},
		items = {
			{
				47,
				99000101,
				1
			}
		}
	}
	pg.base.island_shop_goods[99000102] = {
		desc = "Purchase to receive Honor Student's Demeanor, a character outfit for Oceana.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Honor Student's Demeanor",
		icon = "IslandGoodsIcon/skin_99000102",
		goods_detail_type = 4,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 99000102,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			2000000
		},
		items = {
			{
				47,
				99000102,
				1
			}
		}
	}
	pg.base.island_shop_goods[99000201] = {
		desc = "Purchase to receive Time of Innocence, a character outfit for TB.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Time of Innocence",
		icon = "IslandGoodsIcon/skin_99000201",
		goods_detail_type = 4,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 99000201,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			2000000
		},
		items = {
			{
				47,
				99000201,
				1
			}
		}
	}
	pg.base.island_shop_goods[99000202] = {
		desc = "Purchase to receive Inexperienced Observer, a character outfit for TB.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Inexperienced Observer",
		icon = "IslandGoodsIcon/skin_99000202",
		goods_detail_type = 4,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 99000202,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			2000000
		},
		items = {
			{
				47,
				99000202,
				1
			}
		}
	}
	pg.base.island_shop_goods[99000301] = {
		desc = "Purchase to receive Pure White Whisper, a character outfit for Explorer.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Pure White Whisper",
		icon = "IslandGoodsIcon/skin_99000301",
		goods_detail_type = 4,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 99000301,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			2000000
		},
		items = {
			{
				47,
				99000301,
				1
			}
		}
	}
	pg.base.island_shop_goods[99000302] = {
		desc = "Purchase to receive Serene Dress, a character outfit for Explorer.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Serene Dress",
		icon = "IslandGoodsIcon/skin_99000302",
		goods_detail_type = 4,
		time = "always",
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 99000302,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			41,
			1,
			2000000
		},
		items = {
			{
				47,
				99000302,
				1
			}
		}
	}
	pg.base.island_shop_goods[461060015] = {
		desc = "Purchase to obtain the \"Power Suit\" Commander skin.",
		goods_have = 0,
		items_model = "",
		pay_id = 0,
		have_show = 1,
		limited_num = 1,
		limited_show = 0,
		unlock = "",
		goods_name = "Power Suit",
		icon = "IslandDressIcon/dress_1060015",
		goods_detail_type = 2,
		remian_show = 1,
		pt_award = 0,
		discount = 0,
		groups_detail_type = "",
		id = 461060015,
		weight = 0,
		discount_time = "",
		model_param = {
			{
				0,
				0
			},
			0,
			1
		},
		resource_consume = {
			1,
			14,
			1100
		},
		items = {
			{
				46,
				1060015,
				1
			},
			{
				46,
				1060014,
				1
			},
			{
				46,
				1070015,
				1
			}
		},
		time = {
			{
				{
					2026,
					6,
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
					2026,
					6,
					17
				},
				{
					23,
					59,
					59
				}
			}
		}
	}
end)()
