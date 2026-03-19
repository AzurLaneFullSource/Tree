pg = pg or {}
pg.gametip = setmetatable({
	__name = "gametip"
}, confMT)
pg.base = pg.base or {}
pg.base.gametip = pg.base.gametip or {}
cs = cs or {}
cs.gametip = {
	["new_airi_error_code_-1"] = {
		0,
		99,
		true
	},
	new_airi_error_code_0 = {
		99,
		92,
		true
	},
	new_airi_error_code_100100 = {
		191,
		109,
		true
	},
	new_airi_error_code_100110 = {
		300,
		109,
		true
	},
	new_airi_error_code_100111 = {
		409,
		113,
		true
	},
	new_airi_error_code_100112 = {
		522,
		139,
		true
	},
	new_airi_error_code_100113 = {
		661,
		135,
		true
	},
	new_airi_error_code_100114 = {
		796,
		128,
		true
	},
	new_airi_error_code_100115 = {
		924,
		132,
		true
	},
	new_airi_error_code_100116 = {
		1056,
		125,
		true
	},
	new_airi_error_code_100117 = {
		1181,
		108,
		true
	},
	new_airi_error_code_100120 = {
		1289,
		120,
		true
	},
	new_airi_error_code_100130 = {
		1409,
		117,
		true
	},
	new_airi_error_code_100140 = {
		1526,
		122,
		true
	},
	new_airi_error_code_100150 = {
		1648,
		123,
		true
	},
	new_airi_error_code_100160 = {
		1771,
		126,
		true
	},
	new_airi_error_code_100170 = {
		1897,
		113,
		true
	},
	new_airi_error_code_100180 = {
		2010,
		149,
		true
	},
	new_airi_error_code_100190 = {
		2159,
		133,
		true
	},
	new_airi_error_code_100200 = {
		2292,
		148,
		true
	},
	new_airi_error_code_100210 = {
		2440,
		164,
		true
	},
	new_airi_error_code_100211 = {
		2604,
		112,
		true
	},
	new_airi_error_code_100212 = {
		2716,
		114,
		true
	},
	new_airi_error_code_100213 = {
		2830,
		118,
		true
	},
	new_airi_error_code_100220 = {
		2948,
		112,
		true
	},
	new_airi_error_code_100221 = {
		3060,
		113,
		true
	},
	new_airi_error_code_100222 = {
		3173,
		113,
		true
	},
	new_airi_error_code_100223 = {
		3286,
		117,
		true
	},
	new_airi_error_code_100224 = {
		3403,
		118,
		true
	},
	new_airi_error_code_100225 = {
		3521,
		132,
		true
	},
	new_airi_error_code_100226 = {
		3653,
		135,
		true
	},
	new_airi_error_code_100227 = {
		3788,
		131,
		true
	},
	new_airi_error_code_100228 = {
		3919,
		130,
		true
	},
	new_airi_error_code_100229 = {
		4049,
		138,
		true
	},
	new_airi_error_code_100231 = {
		4187,
		144,
		true
	},
	new_airi_error_code_100232 = {
		4331,
		144,
		true
	},
	new_airi_error_code_100233 = {
		4475,
		131,
		true
	},
	new_airi_error_code_100234 = {
		4606,
		128,
		true
	},
	new_airi_error_code_100230 = {
		4734,
		111,
		true
	},
	new_airi_error_code_100240 = {
		4845,
		137,
		true
	},
	new_airi_error_code_100241 = {
		4982,
		133,
		true
	},
	new_airi_error_code_100242 = {
		5115,
		124,
		true
	},
	new_airi_error_code_100243 = {
		5239,
		140,
		true
	},
	new_airi_error_code_100244 = {
		5379,
		136,
		true
	},
	new_airi_error_code_100245 = {
		5515,
		144,
		true
	},
	new_airi_error_code_100246 = {
		5659,
		142,
		true
	},
	new_airi_error_code_100300 = {
		5801,
		118,
		true
	},
	new_airi_error_code_100301 = {
		5919,
		118,
		true
	},
	new_airi_error_code_100302 = {
		6037,
		132,
		true
	},
	new_airi_error_code_100303 = {
		6169,
		109,
		true
	},
	new_airi_error_code_100304 = {
		6278,
		124,
		true
	},
	new_airi_error_code_100305 = {
		6402,
		111,
		true
	},
	new_airi_error_code_100306 = {
		6513,
		123,
		true
	},
	new_airi_error_code_100404 = {
		6636,
		103,
		true
	},
	new_airi_error_code_200100 = {
		6739,
		115,
		true
	},
	new_airi_error_code_200110 = {
		6854,
		121,
		true
	},
	new_airi_error_code_200120 = {
		6975,
		131,
		true
	},
	new_airi_error_code_200130 = {
		7106,
		119,
		true
	},
	new_airi_error_code_200140 = {
		7225,
		114,
		true
	},
	new_airi_error_code_200150 = {
		7339,
		125,
		true
	},
	new_airi_error_code_200160 = {
		7464,
		114,
		true
	},
	new_airi_error_code_200170 = {
		7578,
		128,
		true
	},
	new_airi_error_code_200180 = {
		7706,
		145,
		true
	},
	new_airi_error_code_200190 = {
		7851,
		113,
		true
	},
	new_airi_error_code_200200 = {
		7964,
		121,
		true
	},
	new_airi_error_code_200210 = {
		8085,
		134,
		true
	},
	new_airi_error_code_200220 = {
		8219,
		132,
		true
	},
	new_airi_error_code_200230 = {
		8351,
		134,
		true
	},
	new_airi_error_code_200240 = {
		8485,
		139,
		true
	},
	new_airi_error_code_200250 = {
		8624,
		124,
		true
	},
	new_airi_error_code_200260 = {
		8748,
		122,
		true
	},
	new_airi_error_code_200270 = {
		8870,
		155,
		true
	},
	new_airi_error_code_200280 = {
		9025,
		140,
		true
	},
	new_airi_error_code_200290 = {
		9165,
		141,
		true
	},
	new_airi_error_code_200300 = {
		9306,
		127,
		true
	},
	new_airi_error_code_200310 = {
		9433,
		131,
		true
	},
	new_airi_error_code_200320 = {
		9564,
		169,
		true
	},
	new_airi_error_code_200330 = {
		9733,
		122,
		true
	},
	new_airi_error_code_200340 = {
		9855,
		114,
		true
	},
	new_airi_error_code_200350 = {
		9969,
		111,
		true
	},
	new_airi_error_code_200360 = {
		10080,
		124,
		true
	},
	new_airi_error_code_300100 = {
		10204,
		111,
		true
	},
	new_airi_error_code_100121 = {
		10315,
		132,
		true
	},
	new_airi_error_code_100201 = {
		10447,
		241,
		true
	},
	new_airi_error_code_100202 = {
		10688,
		254,
		true
	},
	new_airi_error_code_100203 = {
		10942,
		263,
		true
	},
	new_airi_error_code_100204 = {
		11205,
		347,
		true
	},
	new_airi_error_code_100205 = {
		11552,
		174,
		true
	},
	new_airi_error_code_100206 = {
		11726,
		241,
		true
	},
	new_airi_error_code_100207 = {
		11967,
		91,
		true
	},
	new_airi_error_code_100214 = {
		12058,
		301,
		true
	},
	new_airi_error_code_100218 = {
		12359,
		142,
		true
	},
	new_airi_error_code_100235 = {
		12501,
		131,
		true
	},
	new_airi_error_code_100307 = {
		12632,
		91,
		true
	},
	new_airi_error_code_100310 = {
		12723,
		137,
		true
	},
	new_airi_error_code_100311 = {
		12860,
		144,
		true
	},
	new_airi_error_code_100401 = {
		13004,
		116,
		true
	},
	new_airi_error_code_100600 = {
		13120,
		131,
		true
	},
	new_airi_error_code_100802 = {
		13251,
		91,
		true
	},
	new_airi_error_code_100803 = {
		13342,
		134,
		true
	},
	new_airi_error_code_200141 = {
		13476,
		148,
		true
	},
	new_airi_error_code_200145 = {
		13624,
		145,
		true
	},
	new_airi_error_code_200231 = {
		13769,
		91,
		true
	},
	new_airi_error_code_200232 = {
		13860,
		132,
		true
	},
	new_airi_error_code_200235 = {
		13992,
		115,
		true
	},
	new_airi_error_code_200236 = {
		14107,
		107,
		true
	},
	new_airi_error_code_200370 = {
		14214,
		91,
		true
	},
	new_airi_error_code_200380 = {
		14305,
		91,
		true
	},
	new_airi_error_code_200390 = {
		14396,
		91,
		true
	},
	new_airi_error_code_200400 = {
		14487,
		91,
		true
	},
	new_airi_error_code_200410 = {
		14578,
		124,
		true
	},
	new_airi_error_code_200420 = {
		14702,
		108,
		true
	},
	new_airi_error_code_200430 = {
		14810,
		120,
		true
	},
	new_airi_error_code_300101 = {
		14930,
		91,
		true
	},
	new_airi_error_code_300102 = {
		15021,
		91,
		true
	},
	new_airi_error_code_300200 = {
		15112,
		91,
		true
	},
	new_airi_error_code_300210 = {
		15203,
		117,
		true
	},
	new_airi_error_code_300220 = {
		15320,
		115,
		true
	},
	new_airi_error_code_300300 = {
		15435,
		119,
		true
	},
	new_airi_error_code_400010 = {
		15554,
		113,
		true
	},
	new_airi_error_code_400020 = {
		15667,
		119,
		true
	},
	new_airi_error_code_400030 = {
		15786,
		121,
		true
	},
	new_airi_error_code_400040 = {
		15907,
		118,
		true
	},
	new_airi_error_code_400050 = {
		16025,
		150,
		true
	},
	new_airi_error_code_400060 = {
		16175,
		125,
		true
	},
	new_airi_error_code_400070 = {
		16300,
		123,
		true
	},
	new_airi_error_code_400080 = {
		16423,
		150,
		true
	},
	new_airi_error_code_400090 = {
		16573,
		150,
		true
	},
	new_airi_error_code_400100 = {
		16723,
		150,
		true
	},
	new_airi_error_code_400460 = {
		16873,
		133,
		true
	},
	ad_0 = {
		17006,
		68,
		true
	},
	ad_1 = {
		17074,
		304,
		true
	},
	ad_2 = {
		17378,
		298,
		true
	},
	ad_3 = {
		17676,
		298,
		true
	},
	word_back = {
		17974,
		77,
		true
	},
	word_backyardMoney = {
		18051,
		94,
		true
	},
	word_cancel = {
		18145,
		81,
		true
	},
	word_cmdClose = {
		18226,
		89,
		true
	},
	word_delete = {
		18315,
		81,
		true
	},
	word_dockyard = {
		18396,
		81,
		true
	},
	word_dockyardUpgrade = {
		18477,
		95,
		true
	},
	word_dockyardDestroy = {
		18572,
		90,
		true
	},
	word_shipInfoScene_equip = {
		18662,
		97,
		true
	},
	word_shipInfoScene_reinfomation = {
		18759,
		106,
		true
	},
	word_shipInfoScene_infomation = {
		18865,
		105,
		true
	},
	word_editFleet = {
		18970,
		92,
		true
	},
	word_exp = {
		19062,
		75,
		true
	},
	word_expAdd = {
		19137,
		82,
		true
	},
	word_exp_chinese = {
		19219,
		83,
		true
	},
	word_exist = {
		19302,
		78,
		true
	},
	word_equip = {
		19380,
		78,
		true
	},
	word_equipDestory = {
		19458,
		88,
		true
	},
	word_food = {
		19546,
		79,
		true
	},
	word_get = {
		19625,
		79,
		true
	},
	word_got = {
		19704,
		79,
		true
	},
	word_not_get = {
		19783,
		86,
		true
	},
	word_next_level = {
		19869,
		89,
		true
	},
	word_intimacy = {
		19958,
		85,
		true
	},
	word_is = {
		20043,
		74,
		true
	},
	word_date = {
		20117,
		74,
		true
	},
	word_hour = {
		20191,
		74,
		true
	},
	word_minute = {
		20265,
		76,
		true
	},
	word_second = {
		20341,
		76,
		true
	},
	word_lv = {
		20417,
		74,
		true
	},
	word_proficiency = {
		20491,
		91,
		true
	},
	word_material = {
		20582,
		82,
		true
	},
	word_notExist = {
		20664,
		91,
		true
	},
	word_ok = {
		20755,
		78,
		true
	},
	word_preview = {
		20833,
		83,
		true
	},
	word_rarity = {
		20916,
		81,
		true
	},
	word_speedUp = {
		20997,
		85,
		true
	},
	word_succeed = {
		21082,
		83,
		true
	},
	word_start = {
		21165,
		79,
		true
	},
	word_kiss = {
		21244,
		80,
		true
	},
	word_take = {
		21324,
		79,
		true
	},
	word_takeOk = {
		21403,
		84,
		true
	},
	word_many = {
		21487,
		77,
		true
	},
	word_normal_2 = {
		21564,
		82,
		true
	},
	word_simple = {
		21646,
		79,
		true
	},
	word_save = {
		21725,
		77,
		true
	},
	word_levelup = {
		21802,
		84,
		true
	},
	word_serverLoadVindicate = {
		21886,
		122,
		true
	},
	word_serverLoadNormal = {
		22008,
		167,
		true
	},
	word_serverLoadFull = {
		22175,
		112,
		true
	},
	word_registerFull = {
		22287,
		114,
		true
	},
	word_synthesize = {
		22401,
		84,
		true
	},
	word_synthesize_power = {
		22485,
		96,
		true
	},
	word_achieved_item = {
		22581,
		93,
		true
	},
	word_formation = {
		22674,
		84,
		true
	},
	word_teach = {
		22758,
		79,
		true
	},
	word_study = {
		22837,
		79,
		true
	},
	word_destroy = {
		22916,
		82,
		true
	},
	word_upgrade = {
		22998,
		87,
		true
	},
	word_train = {
		23085,
		78,
		true
	},
	word_rest = {
		23163,
		77,
		true
	},
	word_capacity = {
		23240,
		88,
		true
	},
	word_operation = {
		23328,
		88,
		true
	},
	word_intensify_phase = {
		23416,
		97,
		true
	},
	word_systemClose = {
		23513,
		130,
		true
	},
	word_attr_antisub = {
		23643,
		85,
		true
	},
	word_attr_cannon = {
		23728,
		83,
		true
	},
	word_attr_torpedo = {
		23811,
		85,
		true
	},
	word_attr_antiaircraft = {
		23896,
		89,
		true
	},
	word_attr_air = {
		23985,
		81,
		true
	},
	word_attr_durability = {
		24066,
		86,
		true
	},
	word_attr_armor = {
		24152,
		84,
		true
	},
	word_attr_reload = {
		24236,
		84,
		true
	},
	word_attr_speed = {
		24320,
		84,
		true
	},
	word_attr_luck = {
		24404,
		82,
		true
	},
	word_attr_range = {
		24486,
		84,
		true
	},
	word_attr_range_view = {
		24570,
		89,
		true
	},
	word_attr_hit = {
		24659,
		80,
		true
	},
	word_attr_dodge = {
		24739,
		83,
		true
	},
	word_attr_luck1 = {
		24822,
		83,
		true
	},
	word_attr_damage = {
		24905,
		83,
		true
	},
	word_attr_healthy = {
		24988,
		88,
		true
	},
	word_attr_cd = {
		25076,
		78,
		true
	},
	word_attr_speciality = {
		25154,
		91,
		true
	},
	word_attr_level = {
		25245,
		88,
		true
	},
	word_shipState_npc = {
		25333,
		120,
		true
	},
	word_shipState_fight = {
		25453,
		110,
		true
	},
	word_shipState_world = {
		25563,
		137,
		true
	},
	word_shipState_rest = {
		25700,
		109,
		true
	},
	word_shipState_study = {
		25809,
		109,
		true
	},
	word_shipState_tactics = {
		25918,
		111,
		true
	},
	word_shipState_collect = {
		26029,
		116,
		true
	},
	word_shipState_event = {
		26145,
		121,
		true
	},
	word_shipState_activity = {
		26266,
		138,
		true
	},
	word_shipState_sham = {
		26404,
		119,
		true
	},
	word_shipState_support = {
		26523,
		130,
		true
	},
	word_shipType_quZhu = {
		26653,
		92,
		true
	},
	word_shipType_qinXun = {
		26745,
		97,
		true
	},
	word_shipType_zhongXun = {
		26842,
		99,
		true
	},
	word_shipType_zhanLie = {
		26941,
		95,
		true
	},
	word_shipType_hangMu = {
		27036,
		91,
		true
	},
	word_shipType_weiXiu = {
		27127,
		90,
		true
	},
	word_shipType_other = {
		27217,
		87,
		true
	},
	word_shipType_all = {
		27304,
		90,
		true
	},
	word_gem = {
		27394,
		76,
		true
	},
	word_freeGem = {
		27470,
		80,
		true
	},
	word_gem_icon = {
		27550,
		109,
		true
	},
	word_freeGem_icon = {
		27659,
		113,
		true
	},
	word_exploit = {
		27772,
		81,
		true
	},
	word_rankScore = {
		27853,
		84,
		true
	},
	word_battery = {
		27937,
		91,
		true
	},
	word_oil = {
		28028,
		75,
		true
	},
	word_gold = {
		28103,
		78,
		true
	},
	word_oilField = {
		28181,
		85,
		true
	},
	word_goldField = {
		28266,
		88,
		true
	},
	word_ema = {
		28354,
		76,
		true
	},
	word_ema1 = {
		28430,
		77,
		true
	},
	word_pt = {
		28507,
		77,
		true
	},
	word_omamori = {
		28584,
		89,
		true
	},
	word_yisegefuke_pt = {
		28673,
		88,
		true
	},
	word_faxipt = {
		28761,
		84,
		true
	},
	word_count_2 = {
		28845,
		99,
		true
	},
	word_clear = {
		28944,
		78,
		true
	},
	word_buy = {
		29022,
		75,
		true
	},
	word_happy = {
		29097,
		102,
		true
	},
	word_normal = {
		29199,
		104,
		true
	},
	word_tired = {
		29303,
		102,
		true
	},
	word_angry = {
		29405,
		102,
		true
	},
	word_max_page = {
		29507,
		80,
		true
	},
	word_least_page = {
		29587,
		82,
		true
	},
	word_week = {
		29669,
		74,
		true
	},
	word_day = {
		29743,
		73,
		true
	},
	word_use = {
		29816,
		75,
		true
	},
	word_use_batch = {
		29891,
		84,
		true
	},
	word_discount = {
		29975,
		85,
		true
	},
	word_threaten_exclude = {
		30060,
		101,
		true
	},
	word_threaten = {
		30161,
		83,
		true
	},
	word_comingSoon = {
		30244,
		90,
		true
	},
	word_lightArmor = {
		30334,
		84,
		true
	},
	word_mediumArmor = {
		30418,
		86,
		true
	},
	word_heavyarmor = {
		30504,
		84,
		true
	},
	word_level_upperLimit = {
		30588,
		94,
		true
	},
	word_level_require = {
		30682,
		92,
		true
	},
	word_materal_no_enough = {
		30774,
		118,
		true
	},
	word_default = {
		30892,
		83,
		true
	},
	word_count = {
		30975,
		80,
		true
	},
	word_kind = {
		31055,
		77,
		true
	},
	word_piece = {
		31132,
		75,
		true
	},
	word_main_fleet = {
		31207,
		89,
		true
	},
	word_vanguard_fleet = {
		31296,
		91,
		true
	},
	word_theme = {
		31387,
		79,
		true
	},
	word_recommend = {
		31466,
		82,
		true
	},
	word_wallpaper = {
		31548,
		88,
		true
	},
	word_furniture = {
		31636,
		83,
		true
	},
	word_decorate = {
		31719,
		88,
		true
	},
	word_special = {
		31807,
		83,
		true
	},
	word_expand = {
		31890,
		81,
		true
	},
	word_wall = {
		31971,
		77,
		true
	},
	word_floorpaper = {
		32048,
		87,
		true
	},
	word_collection = {
		32135,
		89,
		true
	},
	word_mat = {
		32224,
		78,
		true
	},
	word_comfort_level = {
		32302,
		89,
		true
	},
	word_room = {
		32391,
		80,
		true
	},
	word_equipment_all = {
		32471,
		85,
		true
	},
	word_equipment_cannon = {
		32556,
		94,
		true
	},
	word_equipment_torpedo = {
		32650,
		93,
		true
	},
	word_equipment_aircraft = {
		32743,
		95,
		true
	},
	word_equipment_small_cannon = {
		32838,
		102,
		true
	},
	word_equipment_medium_cannon = {
		32940,
		103,
		true
	},
	word_equipment_big_cannon = {
		33043,
		100,
		true
	},
	word_equipment_warship_torpedo = {
		33143,
		109,
		true
	},
	word_equipment_submarine_torpedo = {
		33252,
		107,
		true
	},
	word_equipment_antiaircraft = {
		33359,
		99,
		true
	},
	word_equipment_fighter = {
		33458,
		93,
		true
	},
	word_equipment_bomber = {
		33551,
		96,
		true
	},
	word_equipment_torpedo_bomber = {
		33647,
		104,
		true
	},
	word_equipment_equip = {
		33751,
		93,
		true
	},
	word_equipment_type = {
		33844,
		87,
		true
	},
	word_equipment_rarity = {
		33931,
		91,
		true
	},
	word_equipment_intensify = {
		34022,
		95,
		true
	},
	word_equipment_special = {
		34117,
		90,
		true
	},
	word_primary_weapons = {
		34207,
		95,
		true
	},
	word_main_cannons = {
		34302,
		90,
		true
	},
	word_shipboard_aircraft = {
		34392,
		95,
		true
	},
	word_sub_cannons = {
		34487,
		94,
		true
	},
	word_sub_weapons = {
		34581,
		96,
		true
	},
	word_torpedo = {
		34677,
		83,
		true
	},
	["word_ air_defense_artillery"] = {
		34760,
		99,
		true
	},
	word_air_defense_artillery = {
		34859,
		98,
		true
	},
	word_device = {
		34957,
		84,
		true
	},
	word_cannon = {
		35041,
		84,
		true
	},
	word_fighter = {
		35125,
		83,
		true
	},
	word_bomber = {
		35208,
		86,
		true
	},
	word_attacker = {
		35294,
		91,
		true
	},
	word_seaplane = {
		35385,
		91,
		true
	},
	word_submarine_torpedo = {
		35476,
		103,
		true
	},
	word_missile = {
		35579,
		83,
		true
	},
	word_online = {
		35662,
		81,
		true
	},
	word_apply = {
		35743,
		79,
		true
	},
	word_star = {
		35822,
		78,
		true
	},
	word_level = {
		35900,
		77,
		true
	},
	word_mod_value = {
		35977,
		89,
		true
	},
	word_wait = {
		36066,
		73,
		true
	},
	word_consume = {
		36139,
		80,
		true
	},
	word_sell_out = {
		36219,
		85,
		true
	},
	word_sell_lock = {
		36304,
		89,
		true
	},
	word_diamond_tip = {
		36393,
		493,
		true
	},
	word_contribution = {
		36886,
		87,
		true
	},
	word_guild_res = {
		36973,
		90,
		true
	},
	word_fit = {
		37063,
		80,
		true
	},
	word_equipment_skin = {
		37143,
		92,
		true
	},
	word_activity = {
		37235,
		83,
		true
	},
	word_urgency_event = {
		37318,
		94,
		true
	},
	word_shop = {
		37412,
		77,
		true
	},
	word_facility = {
		37489,
		83,
		true
	},
	word_cv_key_main = {
		37572,
		92,
		true
	},
	channel_name_1 = {
		37664,
		81,
		true
	},
	channel_name_2 = {
		37745,
		83,
		true
	},
	channel_name_3 = {
		37828,
		84,
		true
	},
	channel_name_4 = {
		37912,
		85,
		true
	},
	channel_name_5 = {
		37997,
		83,
		true
	},
	channel_name_6 = {
		38080,
		84,
		true
	},
	common_wait = {
		38164,
		107,
		true
	},
	common_ship_type = {
		38271,
		89,
		true
	},
	common_dont_remind_dur_login = {
		38360,
		108,
		true
	},
	common_activity_end = {
		38468,
		135,
		true
	},
	common_activity_notStartOrEnd = {
		38603,
		191,
		true
	},
	common_activity_not_start = {
		38794,
		143,
		true
	},
	common_error = {
		38937,
		90,
		true
	},
	common_no_gold = {
		39027,
		130,
		true
	},
	common_no_oil = {
		39157,
		126,
		true
	},
	common_no_rmb = {
		39283,
		127,
		true
	},
	common_count_noenough = {
		39410,
		101,
		true
	},
	common_no_dorm_gold = {
		39511,
		142,
		true
	},
	common_no_resource = {
		39653,
		114,
		true
	},
	common_no_item = {
		39767,
		128,
		true
	},
	common_no_item_1 = {
		39895,
		96,
		true
	},
	common_no_x = {
		39991,
		123,
		true
	},
	common_limit_cmd = {
		40114,
		134,
		true
	},
	common_limit_type = {
		40248,
		159,
		true
	},
	common_limit_equip = {
		40407,
		97,
		true
	},
	common_buy_success = {
		40504,
		91,
		true
	},
	common_limit_level = {
		40595,
		134,
		true
	},
	common_shopId_noFound = {
		40729,
		102,
		true
	},
	common_today_buy_limit = {
		40831,
		106,
		true
	},
	common_not_enter_room = {
		40937,
		96,
		true
	},
	common_test_ship = {
		41033,
		108,
		true
	},
	common_entry_inhibited = {
		41141,
		101,
		true
	},
	common_refresh_count_insufficient = {
		41242,
		113,
		true
	},
	common_get_player_info_erro = {
		41355,
		121,
		true
	},
	common_no_open = {
		41476,
		90,
		true
	},
	["common_already owned"] = {
		41566,
		88,
		true
	},
	common_not_get_ship = {
		41654,
		101,
		true
	},
	common_sale_out = {
		41755,
		87,
		true
	},
	common_skin_out_of_stock = {
		41842,
		99,
		true
	},
	common_go_home = {
		41941,
		121,
		true
	},
	dont_remind_today = {
		42062,
		89,
		true
	},
	dont_remind_session = {
		42151,
		91,
		true
	},
	battle_no_oil = {
		42242,
		144,
		true
	},
	battle_emptyBlock = {
		42386,
		116,
		true
	},
	battle_duel_main_rage = {
		42502,
		171,
		true
	},
	battle_main_emergent = {
		42673,
		163,
		true
	},
	battle_battleMediator_goOnFight = {
		42836,
		103,
		true
	},
	battle_battleMediator_existFight = {
		42939,
		101,
		true
	},
	battle_battleMediator_remainTime = {
		43040,
		110,
		true
	},
	battle_battleMediator_clear_warning = {
		43150,
		251,
		true
	},
	battle_battleMediator_quest_exist = {
		43401,
		233,
		true
	},
	battle_levelMediator_ok_takeResource = {
		43634,
		119,
		true
	},
	battle_result_time_limit = {
		43753,
		125,
		true
	},
	battle_result_sink_limit = {
		43878,
		111,
		true
	},
	battle_result_undefeated = {
		43989,
		101,
		true
	},
	battle_result_victory = {
		44090,
		98,
		true
	},
	battle_result_defeat_all_enemys = {
		44188,
		117,
		true
	},
	battle_result_base_score = {
		44305,
		102,
		true
	},
	battle_result_dead_score = {
		44407,
		104,
		true
	},
	battle_result_score = {
		44511,
		105,
		true
	},
	battle_result_score_total = {
		44616,
		95,
		true
	},
	battle_result_total_damage = {
		44711,
		103,
		true
	},
	battle_result_contribution = {
		44814,
		111,
		true
	},
	battle_result_total_score = {
		44925,
		101,
		true
	},
	battle_result_max_combo = {
		45026,
		97,
		true
	},
	battle_result_boss_hp_lower = {
		45123,
		125,
		true
	},
	battle_levelScene_0Oil = {
		45248,
		105,
		true
	},
	battle_levelScene_0Gold = {
		45353,
		108,
		true
	},
	battle_levelScene_noRaderCount = {
		45461,
		106,
		true
	},
	battle_levelScene_lock = {
		45567,
		185,
		true
	},
	battle_levelScene_hard_lock = {
		45752,
		245,
		true
	},
	battle_levelScene_close = {
		45997,
		130,
		true
	},
	battle_levelScene_chapter_lock = {
		46127,
		193,
		true
	},
	battle_preCombatLayer_changeFormationError = {
		46320,
		160,
		true
	},
	battle_preCombatLayer_changeFormationNumberError = {
		46480,
		197,
		true
	},
	battle_preCombatLayer_ready = {
		46677,
		141,
		true
	},
	battle_preCombatLayer_quest_leaveFleet = {
		46818,
		151,
		true
	},
	battle_preCombatLayer_clear_confirm = {
		46969,
		154,
		true
	},
	battle_preCombatLayer_auto_confirm = {
		47123,
		176,
		true
	},
	battle_preCombatLayer_save_confirm = {
		47299,
		124,
		true
	},
	battle_preCombatLayer_save_march = {
		47423,
		126,
		true
	},
	battle_preCombatLayer_save_success = {
		47549,
		114,
		true
	},
	battle_preCombatLayer_time_limit = {
		47663,
		123,
		true
	},
	battle_preCombatLayer_sink_limit = {
		47786,
		119,
		true
	},
	battle_preCombatLayer_undefeated = {
		47905,
		119,
		true
	},
	battle_preCombatLayer_victory = {
		48024,
		111,
		true
	},
	battle_preCombatLayer_time_hold = {
		48135,
		119,
		true
	},
	battle_preCombatLayer_damage_before_end = {
		48254,
		158,
		true
	},
	battle_preCombatLayer_destory_transport_ship = {
		48412,
		138,
		true
	},
	battle_preCombatMediator_leastLimit = {
		48550,
		124,
		true
	},
	battle_preCombatMediator_timeout = {
		48674,
		184,
		true
	},
	battle_preCombatMediator_activity_timeout = {
		48858,
		203,
		true
	},
	battle_resourceSiteLayer_collecTimeDefault = {
		49061,
		155,
		true
	},
	battle_resourceSiteLayer_collecTime = {
		49216,
		142,
		true
	},
	battle_resourceSiteLayer_maxLv = {
		49358,
		139,
		true
	},
	battle_resourceSiteLayer_avgLv = {
		49497,
		139,
		true
	},
	battle_resourceSiteLayer_shipTypeCount = {
		49636,
		108,
		true
	},
	battle_resourceSiteLayer_no_maxLv = {
		49744,
		157,
		true
	},
	battle_resourceSiteLayer_no_avgLv = {
		49901,
		157,
		true
	},
	battle_resourceSiteLayer_no_shipTypeCount = {
		50058,
		151,
		true
	},
	battle_resourceSiteLayer_startError_collecting = {
		50209,
		123,
		true
	},
	battle_resourceSiteLayer_startError_not5Ship = {
		50332,
		162,
		true
	},
	battle_resourceSiteLayer_startError_limit = {
		50494,
		153,
		true
	},
	battle_resourceSiteLayer_endError_notStar = {
		50647,
		131,
		true
	},
	battle_resourceSiteLayer_quest_end = {
		50778,
		182,
		true
	},
	battle_resourceSiteMediator_noSite = {
		50960,
		127,
		true
	},
	battle_resourceSiteMediator_shipState_fight = {
		51087,
		157,
		true
	},
	battle_resourceSiteMediator_shipState_rest = {
		51244,
		133,
		true
	},
	battle_resourceSiteMediator_shipState_study = {
		51377,
		133,
		true
	},
	battle_resourceSiteMediator_shipState_event = {
		51510,
		138,
		true
	},
	battle_resourceSiteMediator_shipState_same = {
		51648,
		140,
		true
	},
	battle_resourceSiteMediator_ok_end = {
		51788,
		112,
		true
	},
	battle_autobot_unlock = {
		51900,
		106,
		true
	},
	tips_confirm_teleport_sub = {
		52006,
		335,
		true
	},
	backyard_addExp_Info = {
		52341,
		280,
		true
	},
	backyard_extendCapacity_error = {
		52621,
		111,
		true
	},
	backyard_extendCapacity_ok = {
		52732,
		174,
		true
	},
	backyard_addShip_error = {
		52906,
		106,
		true
	},
	backyard_buyFurniture_error = {
		53012,
		122,
		true
	},
	backyard_extendBackYard_error = {
		53134,
		122,
		true
	},
	backyard_addFood_error = {
		53256,
		108,
		true
	},
	backyard_addFood_ok = {
		53364,
		141,
		true
	},
	backyard_putFurniture_ok = {
		53505,
		94,
		true
	},
	backyard_backyardGranaryLayer_foodCountLimit = {
		53599,
		138,
		true
	},
	backyard_shipAddInimacy_ok = {
		53737,
		161,
		true
	},
	backyard_shipAddInimacy_error = {
		53898,
		119,
		true
	},
	backyard_shipAddMoney_ok = {
		54017,
		185,
		true
	},
	backyard_shipAddMoney_error = {
		54202,
		116,
		true
	},
	backyard_shipExit_error = {
		54318,
		109,
		true
	},
	backyard_shipSpeedUpEnergy_error = {
		54427,
		112,
		true
	},
	backyard_shipAlreadyExit = {
		54539,
		111,
		true
	},
	backyard_backyardGranaryLayer_full = {
		54650,
		163,
		true
	},
	backyard_backyardGranaryLayer_buyCountLimit = {
		54813,
		152,
		true
	},
	backyard_backyardGranaryLayer_error_noResource = {
		54965,
		181,
		true
	},
	backyard_backyardGranaryLayer_noFood = {
		55146,
		151,
		true
	},
	backyard_backyardGranaryLayer_noTimer = {
		55297,
		188,
		true
	},
	backyard_backyardGranaryLayer_word = {
		55485,
		147,
		true
	},
	backyard_backyardGranaryLayer_noShip = {
		55632,
		168,
		true
	},
	backyard_backyardGranaryLayer_foodTimeNotice_top = {
		55800,
		144,
		true
	},
	backyard_backyardGranaryLayer_foodTimeNotice_bottom = {
		55944,
		133,
		true
	},
	backyard_backyardGranaryLayer_foodMaxIncreaseNotice = {
		56077,
		199,
		true
	},
	backyard_backyardGranaryLayer_error_entendFail = {
		56276,
		190,
		true
	},
	backyard_backyardGranaryLayer_buy_max_count = {
		56466,
		154,
		true
	},
	backyard_backyardScene_comforChatContent1 = {
		56620,
		291,
		true
	},
	backyard_backyardScene_comforChatContent2 = {
		56911,
		275,
		true
	},
	backyard_buyExtendItem_question = {
		57186,
		172,
		true
	},
	backyard_backyardScene_expression_label_1 = {
		57358,
		108,
		true
	},
	backyard_backyardScene_expression_label_2 = {
		57466,
		111,
		true
	},
	backyard_backyardScene_expression_label_3 = {
		57577,
		116,
		true
	},
	backyard_backyardScene_quest_clearButton = {
		57693,
		154,
		true
	},
	backyard_backyardScene_quest_saveFurniture = {
		57847,
		152,
		true
	},
	backyard_backyardScene_restSuccess = {
		57999,
		127,
		true
	},
	backyard_backyardScene_clearSuccess = {
		58126,
		131,
		true
	},
	backyard_backyardScene_name = {
		58257,
		123,
		true
	},
	backyard_backyardScene_exitShipAfterAddEnergy = {
		58380,
		154,
		true
	},
	backyard_backyardScene_showAddExpInfo = {
		58534,
		180,
		true
	},
	backyard_backyardScene_error_noPosPutFurniture = {
		58714,
		137,
		true
	},
	backyard_backyardScene_error_noFurniture = {
		58851,
		146,
		true
	},
	backyard_backyardScene_error_canNotRotate = {
		58997,
		158,
		true
	},
	backyard_backyardShipInfoLayer_quest_openPos = {
		59155,
		160,
		true
	},
	backyard_backyardShipInfoLayer_quest_addShipNoFood = {
		59315,
		182,
		true
	},
	backyard_backyardShipInfoLayer_quest_quickAddEnergy = {
		59497,
		196,
		true
	},
	backyard_backyardShipInfoLayer_error_noQuickItem = {
		59693,
		151,
		true
	},
	backyard_backyardShipInfoMediator_shipState_rest = {
		59844,
		149,
		true
	},
	backyard_backyardShipInfoMediator_shipState_fight = {
		59993,
		150,
		true
	},
	backyard_backyardShipInfoMediator_shipState_study = {
		60143,
		139,
		true
	},
	backyard_backyardShipInfoMediator_shipState_collect = {
		60282,
		146,
		true
	},
	backyard_backyardShipInfoMediator_shipState_event = {
		60428,
		150,
		true
	},
	backyard_backyardShipInfoMediator_quest_moveOutFleet = {
		60578,
		228,
		true
	},
	backyard_backyardShipInfoMediator_error_vanguardFleetOnlyOneShip = {
		60806,
		174,
		true
	},
	backyard_backyardShipInfoMediator_error_mainFleetOnlyOneShip = {
		60980,
		172,
		true
	},
	backyard_backyardShipInfoMediator_ok_addShip = {
		61152,
		119,
		true
	},
	backyard_backyardShipInfoMediator_ok_unlock = {
		61271,
		116,
		true
	},
	backyard_backyardShipInfoMediator_error_noFood = {
		61387,
		140,
		true
	},
	backyard_backyardShipInfoMediator_error_fullEnergy = {
		61527,
		142,
		true
	},
	backyard_backyardShipInfoMediator_error_fleetOnlyOneShip = {
		61669,
		188,
		true
	},
	backyard_open_2floor = {
		61857,
		224,
		true
	},
	backyarad_theme_replace = {
		62081,
		168,
		true
	},
	backyard_extendArea_ok = {
		62249,
		100,
		true
	},
	backyard_extendArea_erro = {
		62349,
		137,
		true
	},
	backyard_extendArea_tip = {
		62486,
		141,
		true
	},
	backyard_notPosition_shipExit = {
		62627,
		131,
		true
	},
	backyard_no_ship_tip = {
		62758,
		104,
		true
	},
	backyard_energy_qiuck_up_tip = {
		62862,
		225,
		true
	},
	backyard_cant_put_tip = {
		63087,
		101,
		true
	},
	backyard_cant_buy_tip = {
		63188,
		104,
		true
	},
	backyard_theme_lock_tip = {
		63292,
		138,
		true
	},
	backyard_theme_open_tip = {
		63430,
		144,
		true
	},
	backyard_theme_furniture_buy_tip = {
		63574,
		272,
		true
	},
	backyard_cannot_repeat_purchase = {
		63846,
		118,
		true
	},
	backyard_theme_bought = {
		63964,
		94,
		true
	},
	backyard_interAction_no_open = {
		64058,
		132,
		true
	},
	backyard_theme_no_exist = {
		64190,
		108,
		true
	},
	backayrd_theme_delete_sucess = {
		64298,
		106,
		true
	},
	backayrd_theme_delete_erro = {
		64404,
		113,
		true
	},
	backyard_ship_on_furnitrue = {
		64517,
		141,
		true
	},
	backyard_save_empty_theme = {
		64658,
		117,
		true
	},
	backyard_theme_name_forbid = {
		64775,
		130,
		true
	},
	backyard_getResource_emptry = {
		64905,
		111,
		true
	},
	backyard_no_pos_for_ship = {
		65016,
		161,
		true
	},
	equipment_destroyEquipments_error_noEquip = {
		65177,
		125,
		true
	},
	equipment_destroyEquipments_error_notEnoughEquip = {
		65302,
		128,
		true
	},
	equipment_equipDevUI_error_noPos = {
		65430,
		122,
		true
	},
	equipment_equipmentInfoLayer_error_canNotEquip = {
		65552,
		153,
		true
	},
	equipment_equipmentScene_selectError_more = {
		65705,
		163,
		true
	},
	equipment_newEquipLayer_getNewEquip = {
		65868,
		140,
		true
	},
	equipment_select_materials_tip = {
		66008,
		95,
		true
	},
	equipment_select_device_tip = {
		66103,
		119,
		true
	},
	equipment_cant_unload = {
		66222,
		159,
		true
	},
	equipment_max_level = {
		66381,
		97,
		true
	},
	equipment_upgrade_costcheck_error = {
		66478,
		164,
		true
	},
	equipment_upgrade_feedback_lack_of_fragment = {
		66642,
		148,
		true
	},
	exercise_count_insufficient = {
		66790,
		147,
		true
	},
	exercise_clear_fleet_tip = {
		66937,
		203,
		true
	},
	exercise_fleet_exit_tip = {
		67140,
		205,
		true
	},
	exercise_replace_rivals_ok_tip = {
		67345,
		112,
		true
	},
	exercise_replace_rivals_question = {
		67457,
		163,
		true
	},
	exercise_count_recover_tip = {
		67620,
		128,
		true
	},
	exercise_shop_refresh_tip = {
		67748,
		152,
		true
	},
	exercise_shop_buy_tip = {
		67900,
		141,
		true
	},
	exercise_formation_title = {
		68041,
		112,
		true
	},
	exercise_time_tip = {
		68153,
		99,
		true
	},
	exercise_rule_tip = {
		68252,
		1371,
		true
	},
	exercise_award_tip = {
		69623,
		190,
		true
	},
	dock_yard_left_tips = {
		69813,
		132,
		true
	},
	fleet_error_no_fleet = {
		69945,
		105,
		true
	},
	fleet_repairShips_error_fullEnergy = {
		70050,
		138,
		true
	},
	fleet_repairShips_error_noResource = {
		70188,
		126,
		true
	},
	fleet_repairShips_quest = {
		70314,
		157,
		true
	},
	fleet_fleetRaname_error = {
		70471,
		105,
		true
	},
	fleet_updateFleet_error = {
		70576,
		111,
		true
	},
	friend_acceptFriendRequest_error = {
		70687,
		130,
		true
	},
	friend_deleteFriend_error = {
		70817,
		114,
		true
	},
	friend_fetchFriendMsg_error = {
		70931,
		119,
		true
	},
	friend_rejectFriendRequest_error = {
		71050,
		130,
		true
	},
	friend_searchFriend_noPlayer = {
		71180,
		120,
		true
	},
	friend_sendFriendMsg_error = {
		71300,
		114,
		true
	},
	friend_sendFriendMsg_error_noFriend = {
		71414,
		137,
		true
	},
	friend_sendFriendRequest_error = {
		71551,
		118,
		true
	},
	friend_addblacklist_error = {
		71669,
		110,
		true
	},
	friend_relieveblacklist_error = {
		71779,
		126,
		true
	},
	friend_sendFriendRequest_success = {
		71905,
		116,
		true
	},
	friend_relieveblacklist_success = {
		72021,
		118,
		true
	},
	friend_addblacklist_success = {
		72139,
		110,
		true
	},
	friend_confirm_add_blacklist = {
		72249,
		199,
		true
	},
	friend_relieve_backlist_tip = {
		72448,
		171,
		true
	},
	friend_player_is_friend_tip = {
		72619,
		133,
		true
	},
	friend_searchFriend_wait_time = {
		72752,
		123,
		true
	},
	lesson_classOver_error = {
		72875,
		113,
		true
	},
	lesson_endToLearn_error = {
		72988,
		101,
		true
	},
	lesson_startToLearn_error = {
		73089,
		112,
		true
	},
	tactics_lesson_cancel = {
		73201,
		227,
		true
	},
	tactics_lesson_system_introduce = {
		73428,
		287,
		true
	},
	tactics_lesson_start_tip = {
		73715,
		243,
		true
	},
	tactics_noskill_erro = {
		73958,
		101,
		true
	},
	tactics_max_level = {
		74059,
		120,
		true
	},
	tactics_end_to_learn = {
		74179,
		206,
		true
	},
	tactics_continue_to_learn = {
		74385,
		127,
		true
	},
	tactics_should_exist_skill = {
		74512,
		107,
		true
	},
	tactics_skill_level_up = {
		74619,
		128,
		true
	},
	tactics_no_lesson = {
		74747,
		100,
		true
	},
	tactics_lesson_full = {
		74847,
		100,
		true
	},
	tactics_lesson_repeated = {
		74947,
		110,
		true
	},
	login_gate_not_ready = {
		75057,
		100,
		true
	},
	login_game_not_ready = {
		75157,
		105,
		true
	},
	login_game_rigister_full = {
		75262,
		128,
		true
	},
	login_game_login_full = {
		75390,
		158,
		true
	},
	login_game_banned = {
		75548,
		130,
		true
	},
	login_game_frequence = {
		75678,
		138,
		true
	},
	login_createNewPlayer_full = {
		75816,
		138,
		true
	},
	login_createNewPlayer_error = {
		75954,
		112,
		true
	},
	login_createNewPlayer_error_nameNull = {
		76066,
		128,
		true
	},
	login_newPlayerScene_word_lingBo = {
		76194,
		179,
		true
	},
	login_newPlayerScene_word_yingHuoChong = {
		76373,
		210,
		true
	},
	login_newPlayerScene_word_laFei = {
		76583,
		200,
		true
	},
	login_newPlayerScene_word_biaoqiang = {
		76783,
		187,
		true
	},
	login_newPlayerScene_word_z23 = {
		76970,
		194,
		true
	},
	login_newPlayerScene_randomName = {
		77164,
		106,
		true
	},
	login_newPlayerScene_error_notChoiseShip = {
		77270,
		125,
		true
	},
	login_newPlayerScene_inputName = {
		77395,
		104,
		true
	},
	login_loginMediator_kickOtherLogin = {
		77499,
		143,
		true
	},
	login_loginMediator_kickServerClose = {
		77642,
		117,
		true
	},
	login_loginMediator_kickIntError = {
		77759,
		109,
		true
	},
	login_loginMediator_kickTimeError = {
		77868,
		118,
		true
	},
	login_loginMediator_vertifyFail = {
		77986,
		118,
		true
	},
	login_loginMediator_dataExpired = {
		78104,
		113,
		true
	},
	login_loginMediator_kickLoginOut = {
		78217,
		112,
		true
	},
	login_loginMediator_serverLoginErro = {
		78329,
		125,
		true
	},
	login_loginMediator_kickUndefined = {
		78454,
		120,
		true
	},
	login_loginMediator_loginSuccess = {
		78574,
		113,
		true
	},
	login_loginMediator_quest_RegisterSuccess = {
		78687,
		151,
		true
	},
	login_loginMediator_registerFail_error = {
		78838,
		123,
		true
	},
	login_loginMediator_userLoginFail_error = {
		78961,
		124,
		true
	},
	login_loginMediator_serverLoginFail_error = {
		79085,
		123,
		true
	},
	login_loginScene_error_noUserName = {
		79208,
		123,
		true
	},
	login_loginScene_error_noPassword = {
		79331,
		123,
		true
	},
	login_loginScene_error_diffPassword = {
		79454,
		122,
		true
	},
	login_loginScene_error_noMailBox = {
		79576,
		119,
		true
	},
	login_loginScene_choiseServer = {
		79695,
		116,
		true
	},
	login_loginScene_server_vindicate = {
		79811,
		125,
		true
	},
	login_loginScene_server_full = {
		79936,
		107,
		true
	},
	login_loginScene_server_disabled = {
		80043,
		108,
		true
	},
	login_register_full = {
		80151,
		111,
		true
	},
	system_database_busy = {
		80262,
		125,
		true
	},
	mail_getMailList_error_noNewMail = {
		80387,
		108,
		true
	},
	mail_takeAttachment_error_noMail = {
		80495,
		119,
		true
	},
	mail_takeAttachment_error_noAttach = {
		80614,
		124,
		true
	},
	mail_takeAttachment_error_noWorld = {
		80738,
		161,
		true
	},
	mail_takeAttachment_error_reWorld = {
		80899,
		205,
		true
	},
	mail_count = {
		81104,
		118,
		true
	},
	mail_takeAttachment_error_magazine_full = {
		81222,
		215,
		true
	},
	mail_takeAttachment_error_dockYrad_full = {
		81437,
		208,
		true
	},
	mail_confirm_set_important_flag = {
		81645,
		112,
		true
	},
	mail_confirm_cancel_important_flag = {
		81757,
		117,
		true
	},
	mail_confirm_delete_important_flag = {
		81874,
		132,
		true
	},
	mail_mail_page = {
		82006,
		82,
		true
	},
	mail_storeroom_page = {
		82088,
		90,
		true
	},
	mail_boxroom_page = {
		82178,
		88,
		true
	},
	mail_all_page = {
		82266,
		80,
		true
	},
	mail_important_page = {
		82346,
		92,
		true
	},
	mail_rare_page = {
		82438,
		85,
		true
	},
	mail_reward_got = {
		82523,
		86,
		true
	},
	mail_reward_tips = {
		82609,
		139,
		true
	},
	mail_boxroom_extend_title = {
		82748,
		103,
		true
	},
	mail_boxroom_extend_tips = {
		82851,
		113,
		true
	},
	mail_buy_button = {
		82964,
		82,
		true
	},
	mail_manager_title = {
		83046,
		93,
		true
	},
	mail_manager_tips_2 = {
		83139,
		142,
		true
	},
	mail_manager_all = {
		83281,
		98,
		true
	},
	mail_manager_rare = {
		83379,
		113,
		true
	},
	mail_get_oneclick = {
		83492,
		92,
		true
	},
	mail_read_oneclick = {
		83584,
		92,
		true
	},
	mail_delete_oneclick = {
		83676,
		96,
		true
	},
	mail_search_new = {
		83772,
		92,
		true
	},
	mail_receive_time = {
		83864,
		92,
		true
	},
	mail_move_oneclick = {
		83956,
		92,
		true
	},
	mail_deleteread_button = {
		84048,
		97,
		true
	},
	mail_manage_button = {
		84145,
		93,
		true
	},
	mail_move_button = {
		84238,
		90,
		true
	},
	mail_delet_button = {
		84328,
		87,
		true
	},
	mail_delet_button_1 = {
		84415,
		94,
		true
	},
	mail_moveone_button = {
		84509,
		92,
		true
	},
	mail_getone_button = {
		84601,
		95,
		true
	},
	mail_take_all_mail_msgbox = {
		84696,
		147,
		true
	},
	mail_take_maildetail_msgbox = {
		84843,
		103,
		true
	},
	mail_take_canget_msgbox = {
		84946,
		117,
		true
	},
	mail_getbox_title = {
		85063,
		91,
		true
	},
	mail_title_new = {
		85154,
		82,
		true
	},
	mail_boxtitle_information = {
		85236,
		93,
		true
	},
	mail_box_confirm = {
		85329,
		87,
		true
	},
	mail_box_cancel = {
		85416,
		85,
		true
	},
	mail_title_English = {
		85501,
		89,
		true
	},
	mail_toggle_on = {
		85590,
		80,
		true
	},
	mail_toggle_off = {
		85670,
		82,
		true
	},
	main_mailLayer_mailBoxClear = {
		85752,
		115,
		true
	},
	main_mailLayer_noNewMail = {
		85867,
		100,
		true
	},
	main_mailLayer_takeAttach = {
		85967,
		104,
		true
	},
	main_mailLayer_noAttach = {
		86071,
		97,
		true
	},
	main_mailLayer_attachTaken = {
		86168,
		107,
		true
	},
	main_mailLayer_quest_clear = {
		86275,
		207,
		true
	},
	main_mailLayer_quest_clear_choice = {
		86482,
		218,
		true
	},
	main_mailLayer_quest_deleteNotTakeAttach = {
		86700,
		204,
		true
	},
	main_mailLayer_quest_deleteNotRead = {
		86904,
		203,
		true
	},
	main_mailMediator_mailDelete = {
		87107,
		104,
		true
	},
	main_mailMediator_attachTaken = {
		87211,
		110,
		true
	},
	main_mailMediator_mailread = {
		87321,
		121,
		true
	},
	main_mailMediator_mailmove = {
		87442,
		126,
		true
	},
	main_mailMediator_notingToTake = {
		87568,
		115,
		true
	},
	main_mailMediator_takeALot = {
		87683,
		101,
		true
	},
	main_navalAcademyScene_systemClose = {
		87784,
		148,
		true
	},
	main_navalAcademyScene_quest_startClass = {
		87932,
		170,
		true
	},
	main_navalAcademyScene_quest_stopClass = {
		88102,
		248,
		true
	},
	main_navalAcademyScene_quest_Classover_long = {
		88350,
		226,
		true
	},
	main_navalAcademyScene_quest_Classover_short = {
		88576,
		196,
		true
	},
	main_navalAcademyScene_upgrade_complete = {
		88772,
		182,
		true
	},
	main_navalAcademyScene_class_upgrade_complete = {
		88954,
		131,
		true
	},
	main_navalAcademyScene_work_done = {
		89085,
		118,
		true
	},
	main_notificationLayer_searchInput = {
		89203,
		130,
		true
	},
	main_notificationLayer_noInput = {
		89333,
		117,
		true
	},
	main_notificationLayer_noFriend = {
		89450,
		122,
		true
	},
	main_notificationLayer_deleteFriend = {
		89572,
		112,
		true
	},
	main_notificationLayer_sendButton = {
		89684,
		122,
		true
	},
	main_notificationLayer_addFriendError_addSelf = {
		89806,
		136,
		true
	},
	main_notificationLayer_addFriendError_friendAlready = {
		89942,
		156,
		true
	},
	main_notificationLayer_quest_deletFriend = {
		90098,
		163,
		true
	},
	main_notificationLayer_quest_request = {
		90261,
		166,
		true
	},
	main_notificationLayer_enter_room = {
		90427,
		137,
		true
	},
	main_notificationLayer_not_roomId = {
		90564,
		121,
		true
	},
	main_notificationLayer_roomId_invaild = {
		90685,
		124,
		true
	},
	main_notificationMediator_sendFriendRequest = {
		90809,
		127,
		true
	},
	main_notificationMediator_beFriend = {
		90936,
		150,
		true
	},
	main_notificationMediator_deleteFriend = {
		91086,
		160,
		true
	},
	main_notificationMediator_room_max_number = {
		91246,
		122,
		true
	},
	main_playerInfoLayer_inputName = {
		91368,
		104,
		true
	},
	main_playerInfoLayer_inputManifesto = {
		91472,
		123,
		true
	},
	main_playerInfoLayer_quest_changeName = {
		91595,
		159,
		true
	},
	main_playerInfoLayer_error_changeNameNoGem = {
		91754,
		134,
		true
	},
	main_settingsScene_quest_exist = {
		91888,
		126,
		true
	},
	coloring_color_missmatch = {
		92014,
		128,
		true
	},
	coloring_color_not_enough = {
		92142,
		117,
		true
	},
	coloring_erase_all_warning = {
		92259,
		200,
		true
	},
	coloring_erase_warning = {
		92459,
		231,
		true
	},
	coloring_lock = {
		92690,
		88,
		true
	},
	coloring_wait_open = {
		92778,
		91,
		true
	},
	coloring_help_tip = {
		92869,
		1235,
		true
	},
	link_link_help_tip = {
		94104,
		1207,
		true
	},
	player_changeManifesto_ok = {
		95311,
		103,
		true
	},
	player_changeManifesto_error = {
		95414,
		116,
		true
	},
	player_changePlayerIcon_ok = {
		95530,
		108,
		true
	},
	player_changePlayerIcon_error = {
		95638,
		121,
		true
	},
	player_changePlayerName_ok = {
		95759,
		103,
		true
	},
	player_changePlayerName_error = {
		95862,
		116,
		true
	},
	player_changePlayerName_error_2015 = {
		95978,
		136,
		true
	},
	player_harvestResource_error = {
		96114,
		121,
		true
	},
	player_harvestResource_error_fullBag = {
		96235,
		145,
		true
	},
	player_change_chat_room_erro = {
		96380,
		123,
		true
	},
	prop_destroyProp_error_noItem = {
		96503,
		118,
		true
	},
	prop_destroyProp_error_canNotSell = {
		96621,
		123,
		true
	},
	prop_destroyProp_error_notEnoughItem = {
		96744,
		151,
		true
	},
	prop_destroyProp_error = {
		96895,
		108,
		true
	},
	resourceSite_error_noSite = {
		97003,
		118,
		true
	},
	resourceSite_beginScanMap_ok = {
		97121,
		108,
		true
	},
	resourceSite_beginScanMap_error = {
		97229,
		114,
		true
	},
	resourceSite_collectResource_error = {
		97343,
		134,
		true
	},
	resourceSite_finishResourceSite_error = {
		97477,
		133,
		true
	},
	resourceSite_startResourceSite_error = {
		97610,
		134,
		true
	},
	ship_error_noShip = {
		97744,
		133,
		true
	},
	ship_addStarExp_error = {
		97877,
		109,
		true
	},
	ship_buildShip_error = {
		97986,
		106,
		true
	},
	ship_buildShip_error_noTemplate = {
		98092,
		150,
		true
	},
	ship_buildShip_error_notEnoughItem = {
		98242,
		131,
		true
	},
	ship_buildShipImmediately_error = {
		98373,
		115,
		true
	},
	ship_buildShipImmediately_error_noSHip = {
		98488,
		119,
		true
	},
	ship_buildShipImmediately_error_finished = {
		98607,
		126,
		true
	},
	ship_buildShipImmediately_error_noItem = {
		98733,
		138,
		true
	},
	ship_buildShip_not_position = {
		98871,
		143,
		true
	},
	ship_buildBatchShip = {
		99014,
		181,
		true
	},
	ship_buildSingleShip = {
		99195,
		181,
		true
	},
	ship_buildShip_succeed = {
		99376,
		100,
		true
	},
	ship_buildShip_list_empty = {
		99476,
		117,
		true
	},
	ship_buildship_tip = {
		99593,
		191,
		true
	},
	ship_destoryShips_error = {
		99784,
		110,
		true
	},
	ship_equipToShip_ok = {
		99894,
		118,
		true
	},
	ship_equipToShip_error = {
		100012,
		103,
		true
	},
	ship_equipToShip_error_noEquip = {
		100115,
		114,
		true
	},
	ship_equip_check = {
		100229,
		138,
		true
	},
	ship_getShip_error = {
		100367,
		105,
		true
	},
	ship_getShip_error_noShip = {
		100472,
		106,
		true
	},
	ship_getShip_error_notFinish = {
		100578,
		122,
		true
	},
	ship_getShip_error_full = {
		100700,
		153,
		true
	},
	ship_modShip_error = {
		100853,
		106,
		true
	},
	ship_modShip_error_notEnoughGold = {
		100959,
		136,
		true
	},
	ship_remouldShip_error = {
		101095,
		106,
		true
	},
	ship_unequipFromShip_ok = {
		101201,
		126,
		true
	},
	ship_unequipFromShip_error = {
		101327,
		114,
		true
	},
	ship_unequipFromShip_error_noEquip = {
		101441,
		119,
		true
	},
	ship_unequip_all_tip = {
		101560,
		126,
		true
	},
	ship_unequip_all_success = {
		101686,
		127,
		true
	},
	ship_updateShipLock_ok_lock = {
		101813,
		124,
		true
	},
	ship_updateShipLock_ok_unlock = {
		101937,
		128,
		true
	},
	ship_updateShipLock_error = {
		102065,
		119,
		true
	},
	ship_upgradeStar_error = {
		102184,
		106,
		true
	},
	ship_upgradeStar_error_4010 = {
		102290,
		152,
		true
	},
	ship_upgradeStar_error_lvLimit = {
		102442,
		155,
		true
	},
	ship_upgradeStar_error_noEnoughMatrail = {
		102597,
		125,
		true
	},
	ship_upgradeStar_notConfig = {
		102722,
		151,
		true
	},
	ship_upgradeStar_maxLevel = {
		102873,
		121,
		true
	},
	ship_upgradeStar_select_material_tip = {
		102994,
		124,
		true
	},
	ship_exchange_question = {
		103118,
		159,
		true
	},
	ship_exchange_medalCount_noEnough = {
		103277,
		126,
		true
	},
	ship_exchange_erro = {
		103403,
		124,
		true
	},
	ship_exchange_confirm = {
		103527,
		111,
		true
	},
	ship_exchange_tip = {
		103638,
		289,
		true
	},
	ship_vo_fighting = {
		103927,
		120,
		true
	},
	ship_vo_event = {
		104047,
		123,
		true
	},
	ship_vo_isCharacter = {
		104170,
		153,
		true
	},
	ship_vo_inBackyardRest = {
		104323,
		126,
		true
	},
	ship_vo_inClass = {
		104449,
		110,
		true
	},
	ship_vo_moveout_backyard = {
		104559,
		103,
		true
	},
	ship_vo_moveout_formation = {
		104662,
		111,
		true
	},
	ship_vo_mainFleet_must_hasShip = {
		104773,
		146,
		true
	},
	ship_vo_vanguardFleet_must_hasShip = {
		104919,
		148,
		true
	},
	ship_vo_getWordsUndefined = {
		105067,
		142,
		true
	},
	ship_vo_locked = {
		105209,
		98,
		true
	},
	ship_vo_mainFleet_exist_same_ship = {
		105307,
		146,
		true
	},
	ship_vo_vanguardFleet_exist_same_ship = {
		105453,
		148,
		true
	},
	ship_buildShipMediator_startBuild = {
		105601,
		108,
		true
	},
	ship_buildShipMediator_finishBuild = {
		105709,
		120,
		true
	},
	ship_buildShipScene_quest_quickFinish = {
		105829,
		235,
		true
	},
	ship_dockyardMediator_destroy = {
		106064,
		106,
		true
	},
	ship_dockyardScene_capacity = {
		106170,
		105,
		true
	},
	ship_dockyardScene_noRole = {
		106275,
		123,
		true
	},
	ship_dockyardScene_error_choiseRoleMore = {
		106398,
		163,
		true
	},
	ship_dockyardScene_error_choiseRoleLess = {
		106561,
		157,
		true
	},
	ship_formationMediator_leastLimit = {
		106718,
		122,
		true
	},
	ship_formationMediator_changeNameSuccess = {
		106840,
		123,
		true
	},
	ship_formationMediator_changeNameError_sameShip = {
		106963,
		173,
		true
	},
	ship_formationMediator_addShipError_overlimit = {
		107136,
		182,
		true
	},
	ship_formationMediator_replaceError_onlyShip = {
		107318,
		212,
		true
	},
	ship_formationMediator_quest_replace = {
		107530,
		188,
		true
	},
	ship_formationMediaror_trash_warning = {
		107718,
		264,
		true
	},
	ship_formationUI_fleetName1 = {
		107982,
		98,
		true
	},
	ship_formationUI_fleetName2 = {
		108080,
		98,
		true
	},
	ship_formationUI_fleetName3 = {
		108178,
		98,
		true
	},
	ship_formationUI_fleetName4 = {
		108276,
		98,
		true
	},
	ship_formationUI_fleetName5 = {
		108374,
		98,
		true
	},
	ship_formationUI_fleetName6 = {
		108472,
		98,
		true
	},
	ship_formationUI_fleetName11 = {
		108570,
		103,
		true
	},
	ship_formationUI_fleetName12 = {
		108673,
		103,
		true
	},
	ship_formationUI_fleetName13 = {
		108776,
		105,
		true
	},
	ship_formationUI_exercise_fleetName = {
		108881,
		113,
		true
	},
	ship_formationUI_fleetName_world = {
		108994,
		117,
		true
	},
	ship_formationUI_changeFormationError_flag = {
		109111,
		160,
		true
	},
	ship_formationUI_changeFormationError_countError = {
		109271,
		139,
		true
	},
	ship_formationUI_removeError_onlyShip = {
		109410,
		190,
		true
	},
	ship_formationUI_quest_remove = {
		109600,
		152,
		true
	},
	ship_newShipLayer_get = {
		109752,
		147,
		true
	},
	ship_newSkinLayer_get = {
		109899,
		152,
		true
	},
	ship_newSkin_name = {
		110051,
		83,
		true
	},
	ship_shipInfoMediator_destory = {
		110134,
		106,
		true
	},
	ship_shipInfoScene_equipUnlockSlostContent = {
		110240,
		166,
		true
	},
	ship_shipInfoScene_equipUnlockSlostYesText = {
		110406,
		118,
		true
	},
	ship_shipInfoScene_effect = {
		110524,
		132,
		true
	},
	ship_shipInfoScene_effect1or2 = {
		110656,
		134,
		true
	},
	ship_shipInfoScene_modLvMax = {
		110790,
		135,
		true
	},
	ship_shipInfoScene_choiseMod = {
		110925,
		132,
		true
	},
	ship_shipModLayer_effect = {
		111057,
		131,
		true
	},
	ship_shipModLayer_effect1or2 = {
		111188,
		133,
		true
	},
	ship_shipModLayer_modSuccess = {
		111321,
		101,
		true
	},
	ship_mod_no_addition_tip = {
		111422,
		145,
		true
	},
	ship_shipModMediator_choiseMaterial = {
		111567,
		150,
		true
	},
	ship_shipModMediator_noticeLvOver1 = {
		111717,
		111,
		true
	},
	ship_shipModMediator_noticeStarOver4 = {
		111828,
		112,
		true
	},
	ship_shipModMediator_noticeSameButLargerStar = {
		111940,
		131,
		true
	},
	ship_shipModMediator_quest = {
		112071,
		168,
		true
	},
	ship_shipUpgradeLayer2_levelError = {
		112239,
		114,
		true
	},
	ship_shipUpgradeLayer2_noMaterail = {
		112353,
		120,
		true
	},
	ship_shipUpgradeLayer2_ok = {
		112473,
		110,
		true
	},
	ship_shipUpgradeLayer2_effect = {
		112583,
		136,
		true
	},
	ship_shipUpgradeLayer2_effect1or2 = {
		112719,
		138,
		true
	},
	ship_shipUpgradeLayer2_mod_uncommon_tip = {
		112857,
		221,
		true
	},
	ship_shipUpgradeLayer2_uncommon_tip = {
		113078,
		217,
		true
	},
	ship_shipUpgradeLayer2_mod_advanced_tip = {
		113295,
		220,
		true
	},
	ship_shipUpgradeLayer2_advanced_tip = {
		113515,
		222,
		true
	},
	ship_mod_exp_to_attr_tip = {
		113737,
		145,
		true
	},
	ship_max_star = {
		113882,
		144,
		true
	},
	ship_skill_unlock_tip = {
		114026,
		106,
		true
	},
	ship_lock_tip = {
		114132,
		131,
		true
	},
	ship_destroy_uncommon_tip = {
		114263,
		186,
		true
	},
	ship_destroy_advanced_tip = {
		114449,
		162,
		true
	},
	ship_energy_mid_desc = {
		114611,
		132,
		true
	},
	ship_energy_low_desc = {
		114743,
		133,
		true
	},
	ship_energy_low_warn = {
		114876,
		169,
		true
	},
	ship_energy_low_warn_no_exp = {
		115045,
		274,
		true
	},
	test_ship_intensify_tip = {
		115319,
		115,
		true
	},
	test_ship_upgrade_tip = {
		115434,
		126,
		true
	},
	shop_buyItem_ok = {
		115560,
		138,
		true
	},
	shop_buyItem_error = {
		115698,
		102,
		true
	},
	shop_extendMagazine_error = {
		115800,
		115,
		true
	},
	shop_entendShipYard_error = {
		115915,
		112,
		true
	},
	spweapon_attr_effect = {
		116027,
		96,
		true
	},
	spweapon_attr_skillupgrade = {
		116123,
		103,
		true
	},
	spweapon_help_storage = {
		116226,
		3345,
		true
	},
	spweapon_tip_upgrade = {
		119571,
		120,
		true
	},
	spweapon_tip_attr_modify = {
		119691,
		148,
		true
	},
	spweapon_tip_materal_no_enough = {
		119839,
		126,
		true
	},
	spweapon_tip_gold_no_enough = {
		119965,
		119,
		true
	},
	spweapon_tip_pt_no_enough = {
		120084,
		143,
		true
	},
	spweapon_tip_creatept_no_enough = {
		120227,
		180,
		true
	},
	spweapon_tip_bag_no_enough = {
		120407,
		148,
		true
	},
	spweapon_tip_create_sussess = {
		120555,
		151,
		true
	},
	spweapon_tip_group_error = {
		120706,
		125,
		true
	},
	spweapon_tip_breakout_overflow = {
		120831,
		172,
		true
	},
	spweapon_tip_breakout_materal_check = {
		121003,
		144,
		true
	},
	spweapon_tip_transform_materal_check = {
		121147,
		146,
		true
	},
	spweapon_tip_transform_attrmax = {
		121293,
		148,
		true
	},
	spweapon_tip_locked = {
		121441,
		180,
		true
	},
	spweapon_tip_unload = {
		121621,
		135,
		true
	},
	spweapon_tip_sail_locked = {
		121756,
		157,
		true
	},
	spweapon_ui_level = {
		121913,
		94,
		true
	},
	spweapon_ui_levelmax = {
		122007,
		93,
		true
	},
	spweapon_ui_levelmax2 = {
		122100,
		126,
		true
	},
	spweapon_ui_need_resource = {
		122226,
		108,
		true
	},
	spweapon_ui_ptitem = {
		122334,
		96,
		true
	},
	spweapon_ui_spweapon = {
		122430,
		98,
		true
	},
	spweapon_ui_transform = {
		122528,
		105,
		true
	},
	spweapon_ui_transform_attr_text = {
		122633,
		197,
		true
	},
	spweapon_ui_keep_attr = {
		122830,
		93,
		true
	},
	spweapon_ui_change_attr = {
		122923,
		94,
		true
	},
	spweapon_ui_autoselect = {
		123017,
		97,
		true
	},
	spweapon_ui_cancelselect = {
		123114,
		94,
		true
	},
	spweapon_ui_index_shipType_quZhu = {
		123208,
		98,
		true
	},
	spweapon_ui_index_shipType_qinXun = {
		123306,
		99,
		true
	},
	spweapon_ui_index_shipType_zhongXun = {
		123405,
		101,
		true
	},
	spweapon_ui_index_shipType_zhanLie = {
		123506,
		100,
		true
	},
	spweapon_ui_index_shipType_hangMu = {
		123606,
		99,
		true
	},
	spweapon_ui_index_shipType_weiXiu = {
		123705,
		99,
		true
	},
	spweapon_ui_index_shipType_qianTing = {
		123804,
		101,
		true
	},
	spweapon_ui_index_shipType_other = {
		123905,
		100,
		true
	},
	spweapon_ui_keep_attr_text1 = {
		124005,
		206,
		true
	},
	spweapon_ui_keep_attr_text2 = {
		124211,
		150,
		true
	},
	spweapon_ui_change_attr_text1 = {
		124361,
		176,
		true
	},
	spweapon_ui_change_attr_text2 = {
		124537,
		214,
		true
	},
	spweapon_ui_create_exp = {
		124751,
		115,
		true
	},
	spweapon_ui_upgrade_exp = {
		124866,
		118,
		true
	},
	spweapon_ui_breakout_exp = {
		124984,
		117,
		true
	},
	spweapon_ui_create = {
		125101,
		87,
		true
	},
	spweapon_ui_storage = {
		125188,
		88,
		true
	},
	spweapon_ui_empty = {
		125276,
		106,
		true
	},
	spweapon_ui_create_button = {
		125382,
		94,
		true
	},
	spweapon_ui_helptext = {
		125476,
		295,
		true
	},
	spweapon_ui_effect_tag = {
		125771,
		98,
		true
	},
	spweapon_ui_skill_tag = {
		125869,
		98,
		true
	},
	spweapon_activity_ui_text1 = {
		125967,
		174,
		true
	},
	spweapon_activity_ui_text2 = {
		126141,
		165,
		true
	},
	spweapon_tip_skill_locked = {
		126306,
		98,
		true
	},
	spweapon_tip_owned = {
		126404,
		91,
		true
	},
	spweapon_tip_view = {
		126495,
		145,
		true
	},
	spweapon_tip_ship = {
		126640,
		93,
		true
	},
	spweapon_tip_type = {
		126733,
		90,
		true
	},
	stage_beginStage_error = {
		126823,
		109,
		true
	},
	stage_beginStage_error_fleetEmpty = {
		126932,
		120,
		true
	},
	stage_beginStage_error_teamEmpty = {
		127052,
		173,
		true
	},
	stage_beginStage_error_noEnergy = {
		127225,
		143,
		true
	},
	stage_beginStage_error_noResource = {
		127368,
		147,
		true
	},
	stage_beginStage_error_noTicket = {
		127515,
		148,
		true
	},
	stage_finishStage_error = {
		127663,
		115,
		true
	},
	levelScene_map_lock = {
		127778,
		157,
		true
	},
	levelScene_chapter_lock = {
		127935,
		146,
		true
	},
	levelScene_chapter_strategying = {
		128081,
		141,
		true
	},
	levelScene_threat_to_rule_out = {
		128222,
		112,
		true
	},
	levelScene_whether_to_retreat = {
		128334,
		168,
		true
	},
	levelScene_who_to_retreat = {
		128502,
		165,
		true
	},
	levelScene_who_to_exchange = {
		128667,
		138,
		true
	},
	levelScene_time_out = {
		128805,
		104,
		true
	},
	levelScene_nothing = {
		128909,
		103,
		true
	},
	levelScene_notCargo = {
		129012,
		107,
		true
	},
	levelScene_openCargo_erro = {
		129119,
		119,
		true
	},
	levelScene_chapter_notInStrategy = {
		129238,
		114,
		true
	},
	levelScene_retreat_erro = {
		129352,
		105,
		true
	},
	levelScene_strategying = {
		129457,
		100,
		true
	},
	levelScene_tracking_erro = {
		129557,
		94,
		true
	},
	levelScene_tracking_error_3001 = {
		129651,
		150,
		true
	},
	levelScene_chapter_unlock_tip = {
		129801,
		163,
		true
	},
	levelScene_chapter_win = {
		129964,
		116,
		true
	},
	levelScene_sham_win = {
		130080,
		110,
		true
	},
	levelScene_escort_win = {
		130190,
		154,
		true
	},
	levelScene_escort_lose = {
		130344,
		155,
		true
	},
	levelScene_escort_help_tip = {
		130499,
		1412,
		true
	},
	levelScene_escort_retreat = {
		131911,
		225,
		true
	},
	levelScene_oni_retreat = {
		132136,
		204,
		true
	},
	levelScene_oni_win = {
		132340,
		115,
		true
	},
	levelScene_oni_lose = {
		132455,
		123,
		true
	},
	levelScene_bomb_retreat = {
		132578,
		97,
		true
	},
	levelScene_sphunt_help_tip = {
		132675,
		493,
		true
	},
	levelScene_bomb_help_tip = {
		133168,
		341,
		true
	},
	levelScene_chapter_timeout = {
		133509,
		142,
		true
	},
	levelScene_chapter_level_limit = {
		133651,
		162,
		true
	},
	levelScene_chapter_count_tip = {
		133813,
		115,
		true
	},
	levelScene_tracking_error_retry = {
		133928,
		139,
		true
	},
	levelScene_destroy_torpedo = {
		134067,
		123,
		true
	},
	levelScene_new_chapter_coming = {
		134190,
		109,
		true
	},
	levelScene_chapter_open_count_down = {
		134299,
		108,
		true
	},
	levelScene_chapter_not_open = {
		134407,
		103,
		true
	},
	levelScene_activate_remaster = {
		134510,
		194,
		true
	},
	levelScene_remaster_tickets_not_enough = {
		134704,
		136,
		true
	},
	levelScene_remaster_do_not_open = {
		134840,
		121,
		true
	},
	levelScene_remaster_help_tip = {
		134961,
		1192,
		true
	},
	levelScene_activate_loop_mode_failed = {
		136153,
		168,
		true
	},
	levelScene_coastalgun_help_tip = {
		136321,
		359,
		true
	},
	levelScene_select_SP_OP = {
		136680,
		98,
		true
	},
	levelScene_unselect_SP_OP = {
		136778,
		96,
		true
	},
	levelScene_select_SP_OP_reminder = {
		136874,
		415,
		true
	},
	tack_tickets_max_warning = {
		137289,
		281,
		true
	},
	world_battle_count = {
		137570,
		112,
		true
	},
	world_fleetName1 = {
		137682,
		89,
		true
	},
	world_fleetName2 = {
		137771,
		89,
		true
	},
	world_fleetName3 = {
		137860,
		89,
		true
	},
	world_fleetName4 = {
		137949,
		89,
		true
	},
	world_fleetName5 = {
		138038,
		89,
		true
	},
	world_ship_repair_1 = {
		138127,
		162,
		true
	},
	world_ship_repair_2 = {
		138289,
		165,
		true
	},
	world_ship_repair_all = {
		138454,
		168,
		true
	},
	world_ship_repair_no_need = {
		138622,
		111,
		true
	},
	world_event_teleport_alter = {
		138733,
		175,
		true
	},
	world_transport_battle_alter = {
		138908,
		152,
		true
	},
	world_transport_locked = {
		139060,
		200,
		true
	},
	world_target_count = {
		139260,
		105,
		true
	},
	world_target_filter_tip1 = {
		139365,
		91,
		true
	},
	world_target_filter_tip2 = {
		139456,
		98,
		true
	},
	world_target_get_all = {
		139554,
		112,
		true
	},
	world_target_goto = {
		139666,
		92,
		true
	},
	world_help_tip = {
		139758,
		90,
		true
	},
	world_dangerbattle_confirm = {
		139848,
		190,
		true
	},
	world_stamina_exchange = {
		140038,
		177,
		true
	},
	world_stamina_not_enough = {
		140215,
		104,
		true
	},
	world_stamina_recover = {
		140319,
		206,
		true
	},
	world_stamina_text = {
		140525,
		216,
		true
	},
	world_stamina_text2 = {
		140741,
		160,
		true
	},
	world_stamina_resetwarning = {
		140901,
		287,
		true
	},
	world_ship_healthy = {
		141188,
		169,
		true
	},
	world_map_dangerous = {
		141357,
		119,
		true
	},
	world_map_not_open = {
		141476,
		102,
		true
	},
	world_map_locked_stage = {
		141578,
		106,
		true
	},
	world_map_locked_border = {
		141684,
		106,
		true
	},
	world_item_allocate_panel_fleet_info_text = {
		141790,
		163,
		true
	},
	world_redeploy_not_change = {
		141953,
		159,
		true
	},
	world_redeploy_warn = {
		142112,
		187,
		true
	},
	world_redeploy_cost_tip = {
		142299,
		270,
		true
	},
	world_redeploy_tip = {
		142569,
		104,
		true
	},
	world_fleet_choose = {
		142673,
		173,
		true
	},
	world_fleet_formation_not_valid = {
		142846,
		133,
		true
	},
	world_fleet_in_vortex = {
		142979,
		156,
		true
	},
	world_stage_help = {
		143135,
		218,
		true
	},
	world_transport_disable = {
		143353,
		131,
		true
	},
	world_ap = {
		143484,
		74,
		true
	},
	world_resource_tip_1 = {
		143558,
		96,
		true
	},
	world_resource_tip_2 = {
		143654,
		96,
		true
	},
	world_instruction_all_1 = {
		143750,
		127,
		true
	},
	world_instruction_help_1 = {
		143877,
		1467,
		true
	},
	world_instruction_redeploy_1 = {
		145344,
		147,
		true
	},
	world_instruction_redeploy_2 = {
		145491,
		159,
		true
	},
	world_instruction_redeploy_3 = {
		145650,
		166,
		true
	},
	world_instruction_morale_1 = {
		145816,
		187,
		true
	},
	world_instruction_morale_2 = {
		146003,
		120,
		true
	},
	world_instruction_morale_3 = {
		146123,
		113,
		true
	},
	world_instruction_morale_4 = {
		146236,
		160,
		true
	},
	world_instruction_submarine_1 = {
		146396,
		137,
		true
	},
	world_instruction_submarine_2 = {
		146533,
		136,
		true
	},
	world_instruction_submarine_3 = {
		146669,
		135,
		true
	},
	world_instruction_submarine_4 = {
		146804,
		163,
		true
	},
	world_instruction_submarine_5 = {
		146967,
		132,
		true
	},
	world_instruction_submarine_6 = {
		147099,
		209,
		true
	},
	world_instruction_submarine_7 = {
		147308,
		155,
		true
	},
	world_instruction_submarine_8 = {
		147463,
		182,
		true
	},
	world_instruction_submarine_9 = {
		147645,
		190,
		true
	},
	world_instruction_submarine_10 = {
		147835,
		106,
		true
	},
	world_instruction_submarine_11 = {
		147941,
		118,
		true
	},
	world_instruction_detect_1 = {
		148059,
		128,
		true
	},
	world_instruction_detect_2 = {
		148187,
		122,
		true
	},
	world_instruction_supply_1 = {
		148309,
		102,
		true
	},
	world_instruction_supply_2 = {
		148411,
		133,
		true
	},
	world_instruction_port_goods_locked = {
		148544,
		120,
		true
	},
	world_port_inbattle = {
		148664,
		141,
		true
	},
	world_item_recycle_1 = {
		148805,
		151,
		true
	},
	world_item_recycle_2 = {
		148956,
		146,
		true
	},
	world_item_origin = {
		149102,
		132,
		true
	},
	world_shop_bag_unactivated = {
		149234,
		170,
		true
	},
	world_shop_preview_tip = {
		149404,
		119,
		true
	},
	world_shop_init_notice = {
		149523,
		147,
		true
	},
	world_map_title_tips_en = {
		149670,
		101,
		true
	},
	world_map_title_tips = {
		149771,
		99,
		true
	},
	world_mapbuff_attrtxt_1 = {
		149870,
		101,
		true
	},
	world_mapbuff_attrtxt_2 = {
		149971,
		102,
		true
	},
	world_mapbuff_attrtxt_3 = {
		150073,
		107,
		true
	},
	world_mapbuff_compare_txt = {
		150180,
		104,
		true
	},
	world_wind_move = {
		150284,
		171,
		true
	},
	world_battle_pause = {
		150455,
		91,
		true
	},
	world_battle_pause2 = {
		150546,
		99,
		true
	},
	world_task_samemap = {
		150645,
		171,
		true
	},
	world_task_maplock = {
		150816,
		215,
		true
	},
	world_task_goto0 = {
		151031,
		115,
		true
	},
	world_task_goto3 = {
		151146,
		136,
		true
	},
	world_task_view1 = {
		151282,
		99,
		true
	},
	world_task_view2 = {
		151381,
		99,
		true
	},
	world_task_view3 = {
		151480,
		88,
		true
	},
	world_task_refuse1 = {
		151568,
		125,
		true
	},
	world_daily_task_lock = {
		151693,
		148,
		true
	},
	world_daily_task_none = {
		151841,
		117,
		true
	},
	world_daily_task_none_2 = {
		151958,
		87,
		true
	},
	world_sairen_title = {
		152045,
		99,
		true
	},
	world_sairen_description1 = {
		152144,
		131,
		true
	},
	world_sairen_description2 = {
		152275,
		131,
		true
	},
	world_sairen_description3 = {
		152406,
		131,
		true
	},
	world_low_morale = {
		152537,
		241,
		true
	},
	world_recycle_notice = {
		152778,
		142,
		true
	},
	world_recycle_item_transform = {
		152920,
		188,
		true
	},
	world_exit_tip = {
		153108,
		105,
		true
	},
	world_consume_carry_tips = {
		153213,
		100,
		true
	},
	world_boss_help_meta = {
		153313,
		3227,
		true
	},
	world_close = {
		156540,
		120,
		true
	},
	world_catsearch_success = {
		156660,
		139,
		true
	},
	world_catsearch_stop = {
		156799,
		236,
		true
	},
	world_catsearch_fleetcheck = {
		157035,
		240,
		true
	},
	world_catsearch_leavemap = {
		157275,
		242,
		true
	},
	world_catsearch_help_1 = {
		157517,
		315,
		true
	},
	world_catsearch_help_2 = {
		157832,
		105,
		true
	},
	world_catsearch_help_3 = {
		157937,
		278,
		true
	},
	world_catsearch_help_4 = {
		158215,
		100,
		true
	},
	world_catsearch_help_5 = {
		158315,
		144,
		true
	},
	world_catsearch_help_6 = {
		158459,
		125,
		true
	},
	world_level_prefix = {
		158584,
		87,
		true
	},
	world_map_level = {
		158671,
		232,
		true
	},
	world_movelimit_event_text = {
		158903,
		158,
		true
	},
	world_mapbuff_tip = {
		159061,
		127,
		true
	},
	world_sametask_tip = {
		159188,
		152,
		true
	},
	world_expedition_reward_display = {
		159340,
		102,
		true
	},
	world_expedition_reward_display2 = {
		159442,
		102,
		true
	},
	world_complete_item_tip = {
		159544,
		167,
		true
	},
	task_notfound_error = {
		159711,
		149,
		true
	},
	task_submitTask_error = {
		159860,
		111,
		true
	},
	task_submitTask_error_client = {
		159971,
		118,
		true
	},
	task_submitTask_error_notFinish = {
		160089,
		136,
		true
	},
	task_taskMediator_getItem = {
		160225,
		158,
		true
	},
	task_taskMediator_getResource = {
		160383,
		166,
		true
	},
	task_taskMediator_getEquip = {
		160549,
		158,
		true
	},
	task_target_chapter_in_progress = {
		160707,
		178,
		true
	},
	task_level_notenough = {
		160885,
		119,
		true
	},
	loading_tip_ShaderMgr = {
		161004,
		105,
		true
	},
	loading_tip_FontMgr = {
		161109,
		100,
		true
	},
	loading_tip_TipsMgr = {
		161209,
		102,
		true
	},
	loading_tip_MsgboxMgr = {
		161311,
		103,
		true
	},
	loading_tip_GuideMgr = {
		161414,
		111,
		true
	},
	loading_tip_PoolMgr = {
		161525,
		98,
		true
	},
	loading_tip_FModMgr = {
		161623,
		98,
		true
	},
	loading_tip_StoryMgr = {
		161721,
		102,
		true
	},
	energy_desc_happy = {
		161823,
		136,
		true
	},
	energy_desc_normal = {
		161959,
		148,
		true
	},
	energy_desc_tired = {
		162107,
		139,
		true
	},
	energy_desc_angry = {
		162246,
		121,
		true
	},
	create_player_success = {
		162367,
		103,
		true
	},
	login_newPlayerScene_invalideName = {
		162470,
		141,
		true
	},
	login_newPlayerScene_name_tooShort = {
		162611,
		116,
		true
	},
	login_newPlayerScene_name_existOtherChar = {
		162727,
		140,
		true
	},
	login_newPlayerScene_name_tooLong = {
		162867,
		114,
		true
	},
	equipment_updateGrade_tip = {
		162981,
		143,
		true
	},
	equipment_upgrade_ok = {
		163124,
		98,
		true
	},
	equipment_cant_upgrade = {
		163222,
		113,
		true
	},
	equipment_upgrade_erro = {
		163335,
		111,
		true
	},
	collection_nostar = {
		163446,
		98,
		true
	},
	collection_getResource_error = {
		163544,
		119,
		true
	},
	collection_hadAward = {
		163663,
		109,
		true
	},
	collection_lock = {
		163772,
		85,
		true
	},
	collection_fetched = {
		163857,
		114,
		true
	},
	buyProp_noResource_error = {
		163971,
		137,
		true
	},
	refresh_shopStreet_ok = {
		164108,
		109,
		true
	},
	refresh_shopStreet_erro = {
		164217,
		114,
		true
	},
	shopStreet_upgrade_done = {
		164331,
		103,
		true
	},
	shopStreet_refresh_max_count = {
		164434,
		122,
		true
	},
	buy_countLimit = {
		164556,
		105,
		true
	},
	buy_item_quest = {
		164661,
		117,
		true
	},
	refresh_shopStreet_question = {
		164778,
		276,
		true
	},
	quota_shop_title = {
		165054,
		96,
		true
	},
	quota_shop_description = {
		165150,
		183,
		true
	},
	quota_shop_owned = {
		165333,
		85,
		true
	},
	quota_shop_good_limit = {
		165418,
		98,
		true
	},
	quota_shop_limit_error = {
		165516,
		145,
		true
	},
	item_assigned_type_limit_error = {
		165661,
		153,
		true
	},
	event_start_success = {
		165814,
		104,
		true
	},
	event_start_fail = {
		165918,
		107,
		true
	},
	event_finish_success = {
		166025,
		104,
		true
	},
	event_finish_fail = {
		166129,
		111,
		true
	},
	event_giveup_success = {
		166240,
		114,
		true
	},
	event_giveup_fail = {
		166354,
		110,
		true
	},
	event_flush_success = {
		166464,
		107,
		true
	},
	event_flush_fail = {
		166571,
		107,
		true
	},
	event_flush_not_enough = {
		166678,
		110,
		true
	},
	event_start = {
		166788,
		80,
		true
	},
	event_finish = {
		166868,
		84,
		true
	},
	event_giveup = {
		166952,
		82,
		true
	},
	event_minimus_ship_numbers = {
		167034,
		184,
		true
	},
	event_confirm_giveup = {
		167218,
		131,
		true
	},
	event_confirm_flush = {
		167349,
		172,
		true
	},
	event_fleet_busy = {
		167521,
		146,
		true
	},
	event_same_type_not_allowed = {
		167667,
		127,
		true
	},
	event_condition_ship_level = {
		167794,
		165,
		true
	},
	event_condition_ship_count = {
		167959,
		145,
		true
	},
	event_condition_ship_type = {
		168104,
		119,
		true
	},
	event_level_unreached = {
		168223,
		108,
		true
	},
	event_type_unreached = {
		168331,
		119,
		true
	},
	event_oil_consume = {
		168450,
		168,
		true
	},
	event_type_unlimit = {
		168618,
		90,
		true
	},
	dailyLevel_restCount_notEnough = {
		168708,
		133,
		true
	},
	dailyLevel_unopened = {
		168841,
		91,
		true
	},
	dailyLevel_opened = {
		168932,
		85,
		true
	},
	dailyLevel_bonus_activity = {
		169017,
		102,
		true
	},
	playerinfo_ship_is_already_flagship = {
		169119,
		128,
		true
	},
	playerinfo_mask_word = {
		169247,
		107,
		true
	},
	just_now = {
		169354,
		80,
		true
	},
	several_minutes_before = {
		169434,
		116,
		true
	},
	several_hours_before = {
		169550,
		115,
		true
	},
	several_days_before = {
		169665,
		113,
		true
	},
	long_time_offline = {
		169778,
		89,
		true
	},
	dont_send_message_frequently = {
		169867,
		114,
		true
	},
	no_activity = {
		169981,
		95,
		true
	},
	which_day = {
		170076,
		102,
		true
	},
	which_day_2 = {
		170178,
		81,
		true
	},
	invalidate_evaluation = {
		170259,
		118,
		true
	},
	chapter_no = {
		170377,
		107,
		true
	},
	reconnect_tip = {
		170484,
		123,
		true
	},
	like_ship_success = {
		170607,
		97,
		true
	},
	eva_ship_success = {
		170704,
		98,
		true
	},
	zan_ship_eva_success = {
		170802,
		100,
		true
	},
	zan_ship_eva_error_7 = {
		170902,
		121,
		true
	},
	eva_count_limit = {
		171023,
		119,
		true
	},
	attribute_durability = {
		171142,
		86,
		true
	},
	attribute_cannon = {
		171228,
		83,
		true
	},
	attribute_torpedo = {
		171311,
		85,
		true
	},
	attribute_antiaircraft = {
		171396,
		89,
		true
	},
	attribute_air = {
		171485,
		81,
		true
	},
	attribute_reload = {
		171566,
		84,
		true
	},
	attribute_cd = {
		171650,
		79,
		true
	},
	attribute_armor_type = {
		171729,
		94,
		true
	},
	attribute_armor = {
		171823,
		84,
		true
	},
	attribute_hit = {
		171907,
		80,
		true
	},
	attribute_speed = {
		171987,
		84,
		true
	},
	attribute_luck = {
		172071,
		82,
		true
	},
	attribute_dodge = {
		172153,
		83,
		true
	},
	attribute_expend = {
		172236,
		84,
		true
	},
	attribute_damage = {
		172320,
		83,
		true
	},
	attribute_healthy = {
		172403,
		88,
		true
	},
	attribute_speciality = {
		172491,
		91,
		true
	},
	attribute_range = {
		172582,
		84,
		true
	},
	attribute_angle = {
		172666,
		91,
		true
	},
	attribute_scatter = {
		172757,
		93,
		true
	},
	attribute_ammo = {
		172850,
		82,
		true
	},
	attribute_antisub = {
		172932,
		85,
		true
	},
	attribute_sonarRange = {
		173017,
		88,
		true
	},
	attribute_sonarInterval = {
		173105,
		92,
		true
	},
	attribute_oxy_max = {
		173197,
		85,
		true
	},
	attribute_dodge_limit = {
		173282,
		99,
		true
	},
	attribute_intimacy = {
		173381,
		90,
		true
	},
	attribute_max_distance_damage = {
		173471,
		111,
		true
	},
	attribute_anti_siren = {
		173582,
		101,
		true
	},
	attribute_add_new = {
		173683,
		85,
		true
	},
	skill = {
		173768,
		75,
		true
	},
	cd_normal = {
		173843,
		75,
		true
	},
	intensify = {
		173918,
		80,
		true
	},
	change = {
		173998,
		76,
		true
	},
	formation_switch_failed = {
		174074,
		111,
		true
	},
	formation_switch_success = {
		174185,
		102,
		true
	},
	formation_switch_tip = {
		174287,
		161,
		true
	},
	formation_reform_tip = {
		174448,
		145,
		true
	},
	formation_invalide = {
		174593,
		120,
		true
	},
	chapter_ap_not_enough = {
		174713,
		110,
		true
	},
	formation_forbid_when_in_chapter = {
		174823,
		159,
		true
	},
	military_forbid_when_in_chapter = {
		174982,
		158,
		true
	},
	confirm_app_exit = {
		175140,
		119,
		true
	},
	friend_info_page_tip = {
		175259,
		109,
		true
	},
	friend_search_page_tip = {
		175368,
		135,
		true
	},
	friend_request_page_tip = {
		175503,
		152,
		true
	},
	friend_id_copy_ok = {
		175655,
		106,
		true
	},
	friend_inpout_key_tip = {
		175761,
		106,
		true
	},
	remove_friend_tip = {
		175867,
		126,
		true
	},
	friend_request_msg_placeholder = {
		175993,
		109,
		true
	},
	friend_request_msg_title = {
		176102,
		105,
		true
	},
	friend_max_count = {
		176207,
		147,
		true
	},
	friend_add_ok = {
		176354,
		90,
		true
	},
	friend_max_count_1 = {
		176444,
		117,
		true
	},
	friend_no_request = {
		176561,
		99,
		true
	},
	reject_all_friend_ok = {
		176660,
		113,
		true
	},
	reject_friend_ok = {
		176773,
		104,
		true
	},
	friend_offline = {
		176877,
		96,
		true
	},
	friend_msg_forbid = {
		176973,
		151,
		true
	},
	dont_add_self = {
		177124,
		114,
		true
	},
	friend_already_add = {
		177238,
		122,
		true
	},
	friend_not_add = {
		177360,
		114,
		true
	},
	friend_send_msg_erro_tip = {
		177474,
		131,
		true
	},
	friend_send_msg_null_tip = {
		177605,
		111,
		true
	},
	friend_search_succeed = {
		177716,
		101,
		true
	},
	friend_request_msg_sent = {
		177817,
		100,
		true
	},
	friend_resume_ship_count = {
		177917,
		100,
		true
	},
	friend_resume_title_metal = {
		178017,
		103,
		true
	},
	friend_resume_collection_rate = {
		178120,
		104,
		true
	},
	friend_resume_attack_count = {
		178224,
		99,
		true
	},
	friend_resume_attack_win_rate = {
		178323,
		100,
		true
	},
	friend_resume_manoeuvre_count = {
		178423,
		104,
		true
	},
	friend_resume_manoeuvre_win_rate = {
		178527,
		104,
		true
	},
	friend_resume_fleet_gs = {
		178631,
		98,
		true
	},
	friend_event_count = {
		178729,
		95,
		true
	},
	firend_relieve_blacklist_ok = {
		178824,
		99,
		true
	},
	firend_relieve_blacklist_tip = {
		178923,
		148,
		true
	},
	word_shipNation_all = {
		179071,
		95,
		true
	},
	word_shipNation_baiYing = {
		179166,
		98,
		true
	},
	word_shipNation_huangJia = {
		179264,
		98,
		true
	},
	word_shipNation_chongYing = {
		179362,
		102,
		true
	},
	word_shipNation_tieXue = {
		179464,
		96,
		true
	},
	word_shipNation_dongHuang = {
		179560,
		102,
		true
	},
	word_shipNation_saDing = {
		179662,
		103,
		true
	},
	word_shipNation_beiLian = {
		179765,
		106,
		true
	},
	word_shipNation_other = {
		179871,
		89,
		true
	},
	word_shipNation_np = {
		179960,
		89,
		true
	},
	word_shipNation_ziyou = {
		180049,
		95,
		true
	},
	word_shipNation_weixi = {
		180144,
		100,
		true
	},
	word_shipNation_yuanwei = {
		180244,
		101,
		true
	},
	word_shipNation_bili = {
		180345,
		96,
		true
	},
	word_shipNation_um = {
		180441,
		96,
		true
	},
	word_shipNation_ai = {
		180537,
		90,
		true
	},
	word_shipNation_holo = {
		180627,
		92,
		true
	},
	word_shipNation_doa = {
		180719,
		98,
		true
	},
	word_shipNation_imas = {
		180817,
		99,
		true
	},
	word_shipNation_link = {
		180916,
		91,
		true
	},
	word_shipNation_ssss = {
		181007,
		88,
		true
	},
	word_shipNation_mot = {
		181095,
		91,
		true
	},
	word_shipNation_ryza = {
		181186,
		96,
		true
	},
	word_shipNation_meta_index = {
		181282,
		94,
		true
	},
	word_shipNation_senran = {
		181376,
		99,
		true
	},
	word_shipNation_tolove = {
		181475,
		96,
		true
	},
	word_shipNation_yujinwangguo = {
		181571,
		98,
		true
	},
	word_shipNation_brs = {
		181669,
		103,
		true
	},
	word_shipNation_yumia = {
		181772,
		98,
		true
	},
	word_shipNation_danmachi = {
		181870,
		96,
		true
	},
	word_shipNation_dal = {
		181966,
		94,
		true
	},
	word_reset = {
		182060,
		79,
		true
	},
	word_asc = {
		182139,
		81,
		true
	},
	word_desc = {
		182220,
		83,
		true
	},
	word_own = {
		182303,
		78,
		true
	},
	word_own1 = {
		182381,
		79,
		true
	},
	oil_buy_limit_tip = {
		182460,
		150,
		true
	},
	friend_resume_title = {
		182610,
		89,
		true
	},
	friend_resume_data_title = {
		182699,
		92,
		true
	},
	batch_destroy = {
		182791,
		90,
		true
	},
	equipment_select_device_destroy_tip = {
		182881,
		123,
		true
	},
	equipment_select_device_destroy_bonus_tip = {
		183004,
		120,
		true
	},
	equipment_select_device_destroy_nobonus_tip = {
		183124,
		119,
		true
	},
	ship_equip_profiiency = {
		183243,
		100,
		true
	},
	no_open_system_tip = {
		183343,
		165,
		true
	},
	open_system_tip = {
		183508,
		98,
		true
	},
	charge_start_tip = {
		183606,
		102,
		true
	},
	charge_double_gem_tip = {
		183708,
		104,
		true
	},
	charge_month_card_lefttime_tip = {
		183812,
		122,
		true
	},
	charge_title = {
		183934,
		98,
		true
	},
	charge_extra_gem_tip = {
		184032,
		103,
		true
	},
	charge_month_card_title = {
		184135,
		143,
		true
	},
	charge_items_title = {
		184278,
		96,
		true
	},
	setting_interface_save_success = {
		184374,
		116,
		true
	},
	setting_interface_revert_check = {
		184490,
		148,
		true
	},
	setting_interface_cancel_check = {
		184638,
		115,
		true
	},
	event_special_update = {
		184753,
		106,
		true
	},
	no_notice_tip = {
		184859,
		116,
		true
	},
	energy_desc_1 = {
		184975,
		165,
		true
	},
	energy_desc_2 = {
		185140,
		134,
		true
	},
	energy_desc_3 = {
		185274,
		115,
		true
	},
	energy_desc_4 = {
		185389,
		148,
		true
	},
	intimacy_desc_1 = {
		185537,
		100,
		true
	},
	intimacy_desc_2 = {
		185637,
		107,
		true
	},
	intimacy_desc_3 = {
		185744,
		120,
		true
	},
	intimacy_desc_4 = {
		185864,
		124,
		true
	},
	intimacy_desc_5 = {
		185988,
		118,
		true
	},
	intimacy_desc_6 = {
		186106,
		120,
		true
	},
	intimacy_desc_7 = {
		186226,
		120,
		true
	},
	intimacy_desc_1_buff = {
		186346,
		102,
		true
	},
	intimacy_desc_2_buff = {
		186448,
		102,
		true
	},
	intimacy_desc_3_buff = {
		186550,
		141,
		true
	},
	intimacy_desc_4_buff = {
		186691,
		141,
		true
	},
	intimacy_desc_5_buff = {
		186832,
		141,
		true
	},
	intimacy_desc_6_buff = {
		186973,
		141,
		true
	},
	intimacy_desc_7_buff = {
		187114,
		142,
		true
	},
	intimacy_desc_propose = {
		187256,
		323,
		true
	},
	intimacy_desc_1_detail = {
		187579,
		157,
		true
	},
	intimacy_desc_2_detail = {
		187736,
		164,
		true
	},
	intimacy_desc_3_detail = {
		187900,
		196,
		true
	},
	intimacy_desc_4_detail = {
		188096,
		200,
		true
	},
	intimacy_desc_5_detail = {
		188296,
		194,
		true
	},
	intimacy_desc_6_detail = {
		188490,
		324,
		true
	},
	intimacy_desc_7_detail = {
		188814,
		324,
		true
	},
	intimacy_desc_ring = {
		189138,
		96,
		true
	},
	intimacy_desc_tiara = {
		189234,
		96,
		true
	},
	intimacy_desc_day = {
		189330,
		81,
		true
	},
	word_propose_cost_tip1 = {
		189411,
		340,
		true
	},
	word_propose_cost_tip2 = {
		189751,
		318,
		true
	},
	word_propose_tiara_tip = {
		190069,
		153,
		true
	},
	charge_title_getitem = {
		190222,
		117,
		true
	},
	charge_title_getitem_soon = {
		190339,
		113,
		true
	},
	charge_title_getitem_month = {
		190452,
		120,
		true
	},
	charge_limit_all = {
		190572,
		96,
		true
	},
	charge_limit_daily = {
		190668,
		101,
		true
	},
	charge_limit_weekly = {
		190769,
		106,
		true
	},
	charge_limit_monthly = {
		190875,
		108,
		true
	},
	charge_error = {
		190983,
		92,
		true
	},
	charge_success = {
		191075,
		89,
		true
	},
	charge_level_limit = {
		191164,
		99,
		true
	},
	ship_drop_desc_default = {
		191263,
		101,
		true
	},
	charge_limit_lv = {
		191364,
		93,
		true
	},
	charge_time_out = {
		191457,
		144,
		true
	},
	help_shipinfo_equip = {
		191601,
		628,
		true
	},
	help_shipinfo_detail = {
		192229,
		679,
		true
	},
	help_shipinfo_intensify = {
		192908,
		632,
		true
	},
	help_shipinfo_upgrate = {
		193540,
		630,
		true
	},
	help_shipinfo_maxlevel = {
		194170,
		631,
		true
	},
	help_shipinfo_actnpc = {
		194801,
		1323,
		true
	},
	help_backyard = {
		196124,
		590,
		true
	},
	help_shipinfo_fashion = {
		196714,
		168,
		true
	},
	help_shipinfo_attr = {
		196882,
		3917,
		true
	},
	help_equipment = {
		200799,
		1884,
		true
	},
	help_equipment_skin = {
		202683,
		912,
		true
	},
	help_daily_task = {
		203595,
		3705,
		true
	},
	help_build = {
		207300,
		281,
		true
	},
	help_build_1 = {
		207581,
		551,
		true
	},
	help_build_2 = {
		208132,
		283,
		true
	},
	help_build_4 = {
		208415,
		573,
		true
	},
	help_build_5 = {
		208988,
		792,
		true
	},
	help_shipinfo_hunting = {
		209780,
		1244,
		true
	},
	shop_extendship_success = {
		211024,
		101,
		true
	},
	shop_extendequip_success = {
		211125,
		110,
		true
	},
	shop_spweapon_success = {
		211235,
		137,
		true
	},
	naval_academy_res_desc_cateen = {
		211372,
		240,
		true
	},
	naval_academy_res_desc_shop = {
		211612,
		211,
		true
	},
	naval_academy_res_desc_class = {
		211823,
		270,
		true
	},
	number_1 = {
		212093,
		73,
		true
	},
	number_2 = {
		212166,
		73,
		true
	},
	number_3 = {
		212239,
		73,
		true
	},
	number_4 = {
		212312,
		73,
		true
	},
	number_5 = {
		212385,
		73,
		true
	},
	number_6 = {
		212458,
		73,
		true
	},
	number_7 = {
		212531,
		73,
		true
	},
	number_8 = {
		212604,
		73,
		true
	},
	number_9 = {
		212677,
		73,
		true
	},
	number_10 = {
		212750,
		75,
		true
	},
	military_shop_no_open_tip = {
		212825,
		188,
		true
	},
	switch_to_shop_tip_1 = {
		213013,
		149,
		true
	},
	switch_to_shop_tip_2 = {
		213162,
		142,
		true
	},
	switch_to_shop_tip_3 = {
		213304,
		127,
		true
	},
	switch_to_shop_tip_noPos = {
		213431,
		123,
		true
	},
	text_noPos_clear = {
		213554,
		84,
		true
	},
	text_noPos_buy = {
		213638,
		84,
		true
	},
	text_noPos_intensify = {
		213722,
		92,
		true
	},
	switch_to_shop_tip_noDockyard = {
		213814,
		125,
		true
	},
	commission_no_open = {
		213939,
		83,
		true
	},
	commission_open_tip = {
		214022,
		107,
		true
	},
	commission_idle = {
		214129,
		86,
		true
	},
	commission_urgency = {
		214215,
		101,
		true
	},
	commission_normal = {
		214316,
		93,
		true
	},
	commission_get_award = {
		214409,
		109,
		true
	},
	activity_build_end_tip = {
		214518,
		127,
		true
	},
	event_over_time_expired = {
		214645,
		106,
		true
	},
	mail_sender_default = {
		214751,
		95,
		true
	},
	exchangecode_title = {
		214846,
		95,
		true
	},
	exchangecode_use_placeholder = {
		214941,
		116,
		true
	},
	exchangecode_use_ok = {
		215057,
		132,
		true
	},
	exchangecode_use_error = {
		215189,
		110,
		true
	},
	exchangecode_use_error_3 = {
		215299,
		105,
		true
	},
	exchangecode_use_error_6 = {
		215404,
		122,
		true
	},
	exchangecode_use_error_7 = {
		215526,
		115,
		true
	},
	exchangecode_use_error_8 = {
		215641,
		108,
		true
	},
	exchangecode_use_error_9 = {
		215749,
		108,
		true
	},
	exchangecode_use_error_16 = {
		215857,
		108,
		true
	},
	exchangecode_use_error_20 = {
		215965,
		109,
		true
	},
	text_noRes_tip = {
		216074,
		92,
		true
	},
	text_noRes_info_tip = {
		216166,
		111,
		true
	},
	text_noRes_info_tip_link = {
		216277,
		93,
		true
	},
	text_noRes_info_tip2 = {
		216370,
		137,
		true
	},
	text_shop_noRes_tip = {
		216507,
		112,
		true
	},
	text_shop_enoughRes_tip = {
		216619,
		128,
		true
	},
	text_buy_fashion_tip = {
		216747,
		108,
		true
	},
	equip_part_title = {
		216855,
		83,
		true
	},
	equip_part_main_title = {
		216938,
		95,
		true
	},
	equip_part_sub_title = {
		217033,
		99,
		true
	},
	equipment_upgrade_overlimit = {
		217132,
		133,
		true
	},
	err_name_existOtherChar = {
		217265,
		117,
		true
	},
	help_battle_rule = {
		217382,
		511,
		true
	},
	help_battle_warspite = {
		217893,
		300,
		true
	},
	help_battle_defense = {
		218193,
		588,
		true
	},
	backyard_theme_set_tip = {
		218781,
		147,
		true
	},
	backyard_theme_save_tip = {
		218928,
		172,
		true
	},
	backyard_theme_defaultname = {
		219100,
		102,
		true
	},
	backyard_rename_success = {
		219202,
		105,
		true
	},
	ship_set_skin_success = {
		219307,
		98,
		true
	},
	ship_set_skin_error = {
		219405,
		107,
		true
	},
	equip_part_tip = {
		219512,
		109,
		true
	},
	help_battle_auto = {
		219621,
		334,
		true
	},
	gold_buy_tip = {
		219955,
		247,
		true
	},
	oil_buy_tip = {
		220202,
		387,
		true
	},
	text_iknow = {
		220589,
		80,
		true
	},
	help_oil_buy_limit = {
		220669,
		299,
		true
	},
	text_nofood_yes = {
		220968,
		88,
		true
	},
	text_nofood_no = {
		221056,
		84,
		true
	},
	tip_add_task = {
		221140,
		91,
		true
	},
	collection_award_ship = {
		221231,
		134,
		true
	},
	guild_create_sucess = {
		221365,
		97,
		true
	},
	guild_create_error = {
		221462,
		105,
		true
	},
	guild_create_error_noname = {
		221567,
		117,
		true
	},
	guild_create_error_nofaction = {
		221684,
		131,
		true
	},
	guild_create_error_nopolicy = {
		221815,
		121,
		true
	},
	guild_create_error_nomanifesto = {
		221936,
		123,
		true
	},
	guild_create_error_nomoney = {
		222059,
		117,
		true
	},
	guild_tip_dissolve = {
		222176,
		347,
		true
	},
	guild_tip_quit = {
		222523,
		119,
		true
	},
	guild_create_confirm = {
		222642,
		144,
		true
	},
	guild_apply_erro = {
		222786,
		113,
		true
	},
	guild_dissolve_erro = {
		222899,
		108,
		true
	},
	guild_fire_erro = {
		223007,
		107,
		true
	},
	guild_impeach_erro = {
		223114,
		114,
		true
	},
	guild_quit_erro = {
		223228,
		101,
		true
	},
	guild_accept_erro = {
		223329,
		110,
		true
	},
	guild_reject_erro = {
		223439,
		110,
		true
	},
	guild_modify_erro = {
		223549,
		103,
		true
	},
	guild_setduty_erro = {
		223652,
		106,
		true
	},
	guild_apply_sucess = {
		223758,
		108,
		true
	},
	guild_no_exist = {
		223866,
		99,
		true
	},
	guild_dissolve_sucess = {
		223965,
		110,
		true
	},
	guild_commder_in_impeach_time = {
		224075,
		126,
		true
	},
	guild_impeach_sucess = {
		224201,
		107,
		true
	},
	guild_quit_sucess = {
		224308,
		105,
		true
	},
	guild_member_max_count = {
		224413,
		104,
		true
	},
	guild_new_member_join = {
		224517,
		119,
		true
	},
	guild_player_in_cd_time = {
		224636,
		185,
		true
	},
	guild_player_already_join = {
		224821,
		123,
		true
	},
	guild_rejecet_apply_sucess = {
		224944,
		111,
		true
	},
	guild_should_input_keyword = {
		225055,
		117,
		true
	},
	guild_search_sucess = {
		225172,
		99,
		true
	},
	guild_list_refresh_sucess = {
		225271,
		123,
		true
	},
	guild_info_update = {
		225394,
		100,
		true
	},
	guild_duty_id_is_null = {
		225494,
		108,
		true
	},
	guild_player_is_null = {
		225602,
		109,
		true
	},
	guild_duty_commder_max_count = {
		225711,
		126,
		true
	},
	guild_set_duty_sucess = {
		225837,
		107,
		true
	},
	guild_policy_power = {
		225944,
		86,
		true
	},
	guild_policy_relax = {
		226030,
		88,
		true
	},
	guild_faction_blhx = {
		226118,
		91,
		true
	},
	guild_faction_cszz = {
		226209,
		94,
		true
	},
	guild_faction_unknown = {
		226303,
		89,
		true
	},
	guild_faction_meta = {
		226392,
		86,
		true
	},
	guild_word_commder = {
		226478,
		89,
		true
	},
	guild_word_deputy_commder = {
		226567,
		101,
		true
	},
	guild_word_picked = {
		226668,
		86,
		true
	},
	guild_word_ordinary = {
		226754,
		89,
		true
	},
	guild_word_home = {
		226843,
		83,
		true
	},
	guild_word_member = {
		226926,
		88,
		true
	},
	guild_word_apply = {
		227014,
		85,
		true
	},
	guild_faction_change_tip = {
		227099,
		197,
		true
	},
	guild_msg_is_null = {
		227296,
		111,
		true
	},
	guild_log_new_guild_join = {
		227407,
		192,
		true
	},
	guild_log_duty_change = {
		227599,
		178,
		true
	},
	guild_log_quit = {
		227777,
		180,
		true
	},
	guild_log_fire = {
		227957,
		187,
		true
	},
	guild_leave_cd_time = {
		228144,
		148,
		true
	},
	guild_sort_time = {
		228292,
		83,
		true
	},
	guild_sort_level = {
		228375,
		83,
		true
	},
	guild_sort_duty = {
		228458,
		83,
		true
	},
	guild_fire_tip = {
		228541,
		120,
		true
	},
	guild_impeach_tip = {
		228661,
		126,
		true
	},
	guild_set_duty_title = {
		228787,
		99,
		true
	},
	guild_search_list_max_count = {
		228886,
		107,
		true
	},
	guild_sort_all = {
		228993,
		81,
		true
	},
	guild_sort_blhx = {
		229074,
		88,
		true
	},
	guild_sort_cszz = {
		229162,
		91,
		true
	},
	guild_sort_power = {
		229253,
		84,
		true
	},
	guild_sort_relax = {
		229337,
		86,
		true
	},
	guild_join_cd = {
		229423,
		142,
		true
	},
	guild_name_invaild = {
		229565,
		110,
		true
	},
	guild_apply_full = {
		229675,
		117,
		true
	},
	guild_member_full = {
		229792,
		101,
		true
	},
	guild_fire_duty_limit = {
		229893,
		142,
		true
	},
	guild_fire_succeed = {
		230035,
		89,
		true
	},
	guild_duty_tip_1 = {
		230124,
		115,
		true
	},
	guild_duty_tip_2 = {
		230239,
		116,
		true
	},
	battle_repair_special_tip = {
		230355,
		168,
		true
	},
	battle_repair_normal_name = {
		230523,
		109,
		true
	},
	battle_repair_special_name = {
		230632,
		111,
		true
	},
	oil_max_tip_title = {
		230743,
		110,
		true
	},
	gold_max_tip_title = {
		230853,
		113,
		true
	},
	expbook_max_tip_title = {
		230966,
		121,
		true
	},
	resource_max_tip_shop = {
		231087,
		108,
		true
	},
	resource_max_tip_event = {
		231195,
		122,
		true
	},
	resource_max_tip_battle = {
		231317,
		162,
		true
	},
	resource_max_tip_collect = {
		231479,
		124,
		true
	},
	resource_max_tip_mail = {
		231603,
		121,
		true
	},
	resource_max_tip_eventstart = {
		231724,
		118,
		true
	},
	resource_max_tip_destroy = {
		231842,
		111,
		true
	},
	resource_max_tip_retire = {
		231953,
		104,
		true
	},
	resource_max_tip_retire_1 = {
		232057,
		163,
		true
	},
	new_version_tip = {
		232220,
		165,
		true
	},
	guild_request_msg_title = {
		232385,
		115,
		true
	},
	guild_request_msg_placeholder = {
		232500,
		147,
		true
	},
	ship_upgrade_unequip_tip = {
		232647,
		223,
		true
	},
	destination_can_not_reach = {
		232870,
		121,
		true
	},
	destination_can_not_reach_safety = {
		232991,
		136,
		true
	},
	destination_not_in_range = {
		233127,
		123,
		true
	},
	level_ammo_enough = {
		233250,
		146,
		true
	},
	level_ammo_supply = {
		233396,
		120,
		true
	},
	level_ammo_empty = {
		233516,
		132,
		true
	},
	level_ammo_supply_p1 = {
		233648,
		108,
		true
	},
	level_flare_supply = {
		233756,
		209,
		true
	},
	chat_level_not_enough = {
		233965,
		136,
		true
	},
	chat_msg_inform = {
		234101,
		143,
		true
	},
	chat_msg_ban = {
		234244,
		182,
		true
	},
	month_card_set_ratio_success = {
		234426,
		115,
		true
	},
	month_card_set_ratio_not_change = {
		234541,
		125,
		true
	},
	charge_ship_bag_max = {
		234666,
		117,
		true
	},
	charge_equip_bag_max = {
		234783,
		121,
		true
	},
	login_wait_tip = {
		234904,
		141,
		true
	},
	ship_equip_exchange_tip = {
		235045,
		189,
		true
	},
	ship_rename_success = {
		235234,
		109,
		true
	},
	formation_chapter_lock = {
		235343,
		122,
		true
	},
	elite_disable_unsatisfied = {
		235465,
		127,
		true
	},
	elite_disable_ship_escort = {
		235592,
		158,
		true
	},
	elite_disable_formation_unsatisfied = {
		235750,
		149,
		true
	},
	elite_disable_no_fleet = {
		235899,
		135,
		true
	},
	elite_disable_property_unsatisfied = {
		236034,
		146,
		true
	},
	elite_disable_unusable = {
		236180,
		131,
		true
	},
	elite_warp_to_latest_map = {
		236311,
		111,
		true
	},
	elite_fleet_confirm = {
		236422,
		189,
		true
	},
	elite_condition_level = {
		236611,
		98,
		true
	},
	elite_condition_durability = {
		236709,
		98,
		true
	},
	elite_condition_cannon = {
		236807,
		94,
		true
	},
	elite_condition_torpedo = {
		236901,
		96,
		true
	},
	elite_condition_antiaircraft = {
		236997,
		100,
		true
	},
	elite_condition_air = {
		237097,
		92,
		true
	},
	elite_condition_antisub = {
		237189,
		96,
		true
	},
	elite_condition_dodge = {
		237285,
		94,
		true
	},
	elite_condition_reload = {
		237379,
		95,
		true
	},
	elite_condition_fleet_totle_level = {
		237474,
		134,
		true
	},
	common_compare_larger = {
		237608,
		86,
		true
	},
	common_compare_equal = {
		237694,
		85,
		true
	},
	common_compare_smaller = {
		237779,
		87,
		true
	},
	common_compare_not_less_than = {
		237866,
		95,
		true
	},
	common_compare_not_more_than = {
		237961,
		95,
		true
	},
	level_scene_formation_active_already = {
		238056,
		133,
		true
	},
	level_scene_not_enough = {
		238189,
		120,
		true
	},
	level_scene_full_hp = {
		238309,
		148,
		true
	},
	level_click_to_move = {
		238457,
		115,
		true
	},
	common_hardmode = {
		238572,
		83,
		true
	},
	common_elite_no_quota = {
		238655,
		135,
		true
	},
	common_food = {
		238790,
		81,
		true
	},
	common_no_limit = {
		238871,
		88,
		true
	},
	common_proficiency = {
		238959,
		92,
		true
	},
	backyard_food_remind = {
		239051,
		178,
		true
	},
	backyard_food_count = {
		239229,
		109,
		true
	},
	sham_ship_level_limit = {
		239338,
		114,
		true
	},
	sham_count_limit = {
		239452,
		115,
		true
	},
	sham_count_reset = {
		239567,
		126,
		true
	},
	sham_team_limit = {
		239693,
		175,
		true
	},
	sham_formation_invalid = {
		239868,
		154,
		true
	},
	sham_my_assist_ship_level_limit = {
		240022,
		132,
		true
	},
	sham_reset_confirm = {
		240154,
		160,
		true
	},
	sham_battle_help_tip = {
		240314,
		84,
		true
	},
	sham_reset_err_limit = {
		240398,
		130,
		true
	},
	sham_ship_equip_forbid_1 = {
		240528,
		207,
		true
	},
	sham_ship_equip_forbid_2 = {
		240735,
		183,
		true
	},
	sham_enter_error_friend_ship_expired = {
		240918,
		156,
		true
	},
	sham_can_not_change_ship = {
		241074,
		140,
		true
	},
	sham_friend_ship_tip = {
		241214,
		213,
		true
	},
	inform_sueecss = {
		241427,
		95,
		true
	},
	inform_failed = {
		241522,
		101,
		true
	},
	inform_player = {
		241623,
		94,
		true
	},
	inform_select_type = {
		241717,
		114,
		true
	},
	inform_chat_msg = {
		241831,
		101,
		true
	},
	inform_sueecss_tip = {
		241932,
		161,
		true
	},
	ship_remould_max_level = {
		242093,
		137,
		true
	},
	ship_remould_material_ship_no_enough = {
		242230,
		139,
		true
	},
	ship_remould_material_ship_on_exist = {
		242369,
		138,
		true
	},
	ship_remould_material_unlock_skill = {
		242507,
		112,
		true
	},
	ship_remould_prev_lock = {
		242619,
		93,
		true
	},
	ship_remould_need_level = {
		242712,
		94,
		true
	},
	ship_remould_need_star = {
		242806,
		94,
		true
	},
	ship_remould_finished = {
		242900,
		94,
		true
	},
	ship_remould_no_item = {
		242994,
		101,
		true
	},
	ship_remould_no_gold = {
		243095,
		112,
		true
	},
	ship_remould_no_material = {
		243207,
		120,
		true
	},
	ship_remould_selecte_exceed = {
		243327,
		124,
		true
	},
	ship_remould_sueecss = {
		243451,
		93,
		true
	},
	ship_remould_warning_101994 = {
		243544,
		582,
		true
	},
	ship_remould_warning_102174 = {
		244126,
		200,
		true
	},
	ship_remould_warning_102284 = {
		244326,
		205,
		true
	},
	ship_remould_warning_102304 = {
		244531,
		356,
		true
	},
	ship_remould_warning_105214 = {
		244887,
		222,
		true
	},
	ship_remould_warning_105224 = {
		245109,
		221,
		true
	},
	ship_remould_warning_105234 = {
		245330,
		235,
		true
	},
	ship_remould_warning_107974 = {
		245565,
		470,
		true
	},
	ship_remould_warning_107984 = {
		246035,
		238,
		true
	},
	ship_remould_warning_201514 = {
		246273,
		249,
		true
	},
	ship_remould_warning_201524 = {
		246522,
		208,
		true
	},
	ship_remould_warning_203114 = {
		246730,
		361,
		true
	},
	ship_remould_warning_203124 = {
		247091,
		352,
		true
	},
	ship_remould_warning_205124 = {
		247443,
		204,
		true
	},
	ship_remould_warning_205154 = {
		247647,
		228,
		true
	},
	ship_remould_warning_206134 = {
		247875,
		329,
		true
	},
	ship_remould_warning_301534 = {
		248204,
		183,
		true
	},
	ship_remould_warning_301874 = {
		248387,
		551,
		true
	},
	ship_remould_warning_301934 = {
		248938,
		268,
		true
	},
	ship_remould_warning_310014 = {
		249206,
		470,
		true
	},
	ship_remould_warning_310024 = {
		249676,
		470,
		true
	},
	ship_remould_warning_310034 = {
		250146,
		470,
		true
	},
	ship_remould_warning_310044 = {
		250616,
		470,
		true
	},
	ship_remould_warning_303154 = {
		251086,
		604,
		true
	},
	ship_remould_warning_402134 = {
		251690,
		264,
		true
	},
	ship_remould_warning_702124 = {
		251954,
		492,
		true
	},
	ship_remould_warning_520014 = {
		252446,
		280,
		true
	},
	ship_remould_warning_521014 = {
		252726,
		282,
		true
	},
	ship_remould_warning_520034 = {
		253008,
		280,
		true
	},
	ship_remould_warning_521034 = {
		253288,
		282,
		true
	},
	ship_remould_warning_520044 = {
		253570,
		280,
		true
	},
	ship_remould_warning_521044 = {
		253850,
		282,
		true
	},
	ship_remould_warning_502114 = {
		254132,
		186,
		true
	},
	ship_remould_warning_506114 = {
		254318,
		399,
		true
	},
	ship_remould_warning_506124 = {
		254717,
		290,
		true
	},
	ship_remould_warning_520024 = {
		255007,
		280,
		true
	},
	ship_remould_warning_521024 = {
		255287,
		282,
		true
	},
	word_soundfiles_download_title = {
		255569,
		116,
		true
	},
	word_soundfiles_download = {
		255685,
		102,
		true
	},
	word_soundfiles_checking_title = {
		255787,
		105,
		true
	},
	word_soundfiles_checking = {
		255892,
		99,
		true
	},
	word_soundfiles_checkend_title = {
		255991,
		131,
		true
	},
	word_soundfiles_checkend = {
		256122,
		101,
		true
	},
	word_soundfiles_noneedupdate = {
		256223,
		98,
		true
	},
	word_soundfiles_checkfailed = {
		256321,
		122,
		true
	},
	word_soundfiles_retry = {
		256443,
		97,
		true
	},
	word_soundfiles_update = {
		256540,
		97,
		true
	},
	word_soundfiles_update_end_title = {
		256637,
		118,
		true
	},
	word_soundfiles_update_end = {
		256755,
		106,
		true
	},
	word_soundfiles_update_failed = {
		256861,
		124,
		true
	},
	word_soundfiles_update_retry = {
		256985,
		104,
		true
	},
	word_live2dfiles_download_title = {
		257089,
		125,
		true
	},
	word_live2dfiles_download = {
		257214,
		109,
		true
	},
	word_live2dfiles_checking_title = {
		257323,
		107,
		true
	},
	word_live2dfiles_checking = {
		257430,
		98,
		true
	},
	word_live2dfiles_checkend_title = {
		257528,
		140,
		true
	},
	word_live2dfiles_checkend = {
		257668,
		102,
		true
	},
	word_live2dfiles_noneedupdate = {
		257770,
		99,
		true
	},
	word_live2dfiles_checkfailed = {
		257869,
		134,
		true
	},
	word_live2dfiles_retry = {
		258003,
		98,
		true
	},
	word_live2dfiles_update = {
		258101,
		98,
		true
	},
	word_live2dfiles_update_end_title = {
		258199,
		136,
		true
	},
	word_live2dfiles_update_end = {
		258335,
		107,
		true
	},
	word_live2dfiles_update_failed = {
		258442,
		130,
		true
	},
	word_live2dfiles_update_retry = {
		258572,
		105,
		true
	},
	word_live2dfiles_main_update_tip = {
		258677,
		149,
		true
	},
	achieve_propose_tip = {
		258826,
		101,
		true
	},
	mingshi_get_tip = {
		258927,
		105,
		true
	},
	mingshi_task_tip_1 = {
		259032,
		217,
		true
	},
	mingshi_task_tip_2 = {
		259249,
		221,
		true
	},
	mingshi_task_tip_3 = {
		259470,
		220,
		true
	},
	mingshi_task_tip_4 = {
		259690,
		221,
		true
	},
	mingshi_task_tip_5 = {
		259911,
		216,
		true
	},
	mingshi_task_tip_6 = {
		260127,
		215,
		true
	},
	mingshi_task_tip_7 = {
		260342,
		228,
		true
	},
	mingshi_task_tip_8 = {
		260570,
		223,
		true
	},
	mingshi_task_tip_9 = {
		260793,
		221,
		true
	},
	mingshi_task_tip_10 = {
		261014,
		229,
		true
	},
	mingshi_task_tip_11 = {
		261243,
		215,
		true
	},
	word_propose_changename_title = {
		261458,
		163,
		true
	},
	word_propose_changename_tip1 = {
		261621,
		136,
		true
	},
	word_propose_changename_tip2 = {
		261757,
		113,
		true
	},
	word_propose_ring_tip = {
		261870,
		109,
		true
	},
	word_rename_time_tip = {
		261979,
		147,
		true
	},
	word_rename_switch_tip = {
		262126,
		151,
		true
	},
	word_ssr = {
		262277,
		74,
		true
	},
	word_sr = {
		262351,
		76,
		true
	},
	word_r = {
		262427,
		71,
		true
	},
	ship_renameShip_error = {
		262498,
		107,
		true
	},
	ship_renameShip_error_4 = {
		262605,
		125,
		true
	},
	ship_renameShip_error_2011 = {
		262730,
		107,
		true
	},
	ship_proposeShip_error = {
		262837,
		104,
		true
	},
	ship_proposeShip_error_1 = {
		262941,
		106,
		true
	},
	word_rename_time_warning = {
		263047,
		236,
		true
	},
	word_propose_cost_tip = {
		263283,
		453,
		true
	},
	word_propose_switch_tip = {
		263736,
		102,
		true
	},
	evaluate_too_loog = {
		263838,
		101,
		true
	},
	evaluate_ban_word = {
		263939,
		112,
		true
	},
	activity_level_easy_tip = {
		264051,
		181,
		true
	},
	activity_level_difficulty_tip = {
		264232,
		210,
		true
	},
	activity_level_limit_tip = {
		264442,
		174,
		true
	},
	activity_level_inwarime_tip = {
		264616,
		221,
		true
	},
	activity_level_pass_easy_tip = {
		264837,
		187,
		true
	},
	activity_level_is_closed = {
		265024,
		114,
		true
	},
	activity_switch_tip = {
		265138,
		255,
		true
	},
	reduce_sp3_pass_count = {
		265393,
		103,
		true
	},
	qiuqiu_count = {
		265496,
		85,
		true
	},
	qiuqiu_total_count = {
		265581,
		91,
		true
	},
	npcfriendly_count = {
		265672,
		98,
		true
	},
	npcfriendly_total_count = {
		265770,
		97,
		true
	},
	longxiang_count = {
		265867,
		98,
		true
	},
	longxiang_total_count = {
		265965,
		103,
		true
	},
	pt_count = {
		266068,
		82,
		true
	},
	pt_total_count = {
		266150,
		94,
		true
	},
	remould_ship_ok = {
		266244,
		88,
		true
	},
	remould_ship_count_more = {
		266332,
		120,
		true
	},
	word_should_input = {
		266452,
		108,
		true
	},
	simulation_advantage_counting = {
		266560,
		126,
		true
	},
	simulation_disadvantage_counting = {
		266686,
		130,
		true
	},
	simulation_enhancing = {
		266816,
		144,
		true
	},
	simulation_enhanced = {
		266960,
		121,
		true
	},
	word_skill_desc_get = {
		267081,
		94,
		true
	},
	word_skill_desc_learn = {
		267175,
		89,
		true
	},
	chapter_tip_aovid_succeed = {
		267264,
		96,
		true
	},
	chapter_tip_aovid_failed = {
		267360,
		104,
		true
	},
	chapter_tip_change = {
		267464,
		103,
		true
	},
	chapter_tip_use = {
		267567,
		98,
		true
	},
	chapter_tip_with_npc = {
		267665,
		285,
		true
	},
	chapter_tip_bp_ammo = {
		267950,
		137,
		true
	},
	build_ship_tip = {
		268087,
		190,
		true
	},
	auto_battle_limit_tip = {
		268277,
		123,
		true
	},
	build_ship_quickly_buy_stone = {
		268400,
		190,
		true
	},
	build_ship_quickly_buy_tool = {
		268590,
		205,
		true
	},
	ship_profile_voice_locked = {
		268795,
		121,
		true
	},
	ship_profile_skin_locked = {
		268916,
		110,
		true
	},
	ship_profile_words = {
		269026,
		88,
		true
	},
	ship_profile_action_words = {
		269114,
		102,
		true
	},
	ship_profile_label_common = {
		269216,
		96,
		true
	},
	ship_profile_label_diff = {
		269312,
		98,
		true
	},
	level_fleet_lease_one_ship = {
		269410,
		133,
		true
	},
	level_fleet_not_enough = {
		269543,
		131,
		true
	},
	level_fleet_outof_limit = {
		269674,
		125,
		true
	},
	vote_success = {
		269799,
		82,
		true
	},
	vote_not_enough = {
		269881,
		111,
		true
	},
	vote_love_not_enough = {
		269992,
		125,
		true
	},
	vote_love_limit = {
		270117,
		143,
		true
	},
	vote_love_confirm = {
		270260,
		125,
		true
	},
	vote_primary_rule = {
		270385,
		81,
		true
	},
	vote_final_title1 = {
		270466,
		88,
		true
	},
	vote_final_rule1 = {
		270554,
		231,
		true
	},
	vote_final_title2 = {
		270785,
		94,
		true
	},
	vote_final_rule2 = {
		270879,
		240,
		true
	},
	vote_vote_time = {
		271119,
		100,
		true
	},
	vote_vote_count = {
		271219,
		87,
		true
	},
	vote_vote_group = {
		271306,
		87,
		true
	},
	vote_rank_refresh_time = {
		271393,
		120,
		true
	},
	vote_rank_in_current_server = {
		271513,
		128,
		true
	},
	words_auto_battle_label = {
		271641,
		105,
		true
	},
	words_show_ship_name_label = {
		271746,
		106,
		true
	},
	words_rare_ship_vibrate = {
		271852,
		100,
		true
	},
	words_display_ship_get_effect = {
		271952,
		108,
		true
	},
	words_show_touch_effect = {
		272060,
		102,
		true
	},
	words_bg_fit_mode = {
		272162,
		121,
		true
	},
	words_battle_hide_bg = {
		272283,
		116,
		true
	},
	words_battle_expose_line = {
		272399,
		123,
		true
	},
	words_autoFight_battery_savemode = {
		272522,
		121,
		true
	},
	words_autoFight_battery_savemode_des = {
		272643,
		182,
		true
	},
	words_autoFIght_down_frame = {
		272825,
		115,
		true
	},
	words_autoFIght_down_frame_des = {
		272940,
		163,
		true
	},
	words_autoFight_tips = {
		273103,
		131,
		true
	},
	words_autoFight_right = {
		273234,
		175,
		true
	},
	activity_puzzle_get1 = {
		273409,
		132,
		true
	},
	activity_puzzle_get2 = {
		273541,
		143,
		true
	},
	activity_puzzle_get3 = {
		273684,
		143,
		true
	},
	activity_puzzle_get4 = {
		273827,
		143,
		true
	},
	activity_puzzle_get5 = {
		273970,
		143,
		true
	},
	activity_puzzle_get6 = {
		274113,
		143,
		true
	},
	activity_puzzle_get7 = {
		274256,
		143,
		true
	},
	activity_puzzle_get8 = {
		274399,
		143,
		true
	},
	activity_puzzle_get9 = {
		274542,
		143,
		true
	},
	activity_puzzle_get10 = {
		274685,
		133,
		true
	},
	activity_puzzle_get11 = {
		274818,
		133,
		true
	},
	activity_puzzle_get12 = {
		274951,
		133,
		true
	},
	activity_puzzle_get13 = {
		275084,
		133,
		true
	},
	activity_puzzle_get14 = {
		275217,
		133,
		true
	},
	activity_puzzle_get15 = {
		275350,
		133,
		true
	},
	word_stopremain_build = {
		275483,
		102,
		true
	},
	word_stopremain_default = {
		275585,
		104,
		true
	},
	transcode_desc = {
		275689,
		359,
		true
	},
	transcode_empty_tip = {
		276048,
		117,
		true
	},
	set_birth_title = {
		276165,
		91,
		true
	},
	set_birth_confirm_tip = {
		276256,
		110,
		true
	},
	set_birth_empty_tip = {
		276366,
		105,
		true
	},
	set_birth_success = {
		276471,
		107,
		true
	},
	clear_transcode_cache_confirm = {
		276578,
		143,
		true
	},
	clear_transcode_cache_success = {
		276721,
		115,
		true
	},
	exchange_item_success = {
		276836,
		94,
		true
	},
	give_up_cloth_change = {
		276930,
		120,
		true
	},
	err_cloth_change_noship = {
		277050,
		103,
		true
	},
	need_break_tip = {
		277153,
		99,
		true
	},
	max_level_notice = {
		277252,
		152,
		true
	},
	new_skin_no_choose = {
		277404,
		156,
		true
	},
	sure_resume_volume = {
		277560,
		114,
		true
	},
	course_class_not_ready = {
		277674,
		165,
		true
	},
	course_student_max_level = {
		277839,
		152,
		true
	},
	course_stop_confirm = {
		277991,
		103,
		true
	},
	course_class_help = {
		278094,
		1480,
		true
	},
	course_class_name = {
		279574,
		100,
		true
	},
	course_proficiency_not_enough = {
		279674,
		128,
		true
	},
	course_state_rest = {
		279802,
		91,
		true
	},
	course_state_lession = {
		279893,
		97,
		true
	},
	course_energy_not_enough = {
		279990,
		156,
		true
	},
	course_proficiency_tip = {
		280146,
		382,
		true
	},
	course_sunday_tip = {
		280528,
		145,
		true
	},
	course_exit_confirm = {
		280673,
		158,
		true
	},
	course_learning = {
		280831,
		111,
		true
	},
	time_remaining_tip = {
		280942,
		93,
		true
	},
	propose_intimacy_tip = {
		281035,
		119,
		true
	},
	no_found_record_equipment = {
		281154,
		196,
		true
	},
	sec_floor_limit_tip = {
		281350,
		130,
		true
	},
	guild_shop_flash_success = {
		281480,
		98,
		true
	},
	destroy_high_rarity_tip = {
		281578,
		125,
		true
	},
	destroy_high_level_tip = {
		281703,
		133,
		true
	},
	destroy_importantequipment_tip = {
		281836,
		126,
		true
	},
	destroy_eliteequipment_tip = {
		281962,
		117,
		true
	},
	destroy_high_intensify_tip = {
		282079,
		124,
		true
	},
	destroy_inHardFormation_tip = {
		282203,
		126,
		true
	},
	destroy_equip_rarity_tip = {
		282329,
		161,
		true
	},
	ship_quick_change_noequip = {
		282490,
		116,
		true
	},
	ship_quick_change_nofreeequip = {
		282606,
		134,
		true
	},
	word_nowenergy = {
		282740,
		84,
		true
	},
	word_energy_recov_speed = {
		282824,
		101,
		true
	},
	destroy_eliteship_tip = {
		282925,
		111,
		true
	},
	err_resloveequip_nochoice = {
		283036,
		120,
		true
	},
	take_nothing = {
		283156,
		103,
		true
	},
	take_all_mail = {
		283259,
		171,
		true
	},
	buy_furniture_overtime = {
		283430,
		135,
		true
	},
	twitter_login_tips = {
		283565,
		166,
		true
	},
	data_erro = {
		283731,
		121,
		true
	},
	login_failed = {
		283852,
		94,
		true
	},
	["not yet completed"] = {
		283946,
		93,
		true
	},
	escort_less_count_to_combat = {
		284039,
		127,
		true
	},
	ten_even_draw = {
		284166,
		94,
		true
	},
	ten_even_draw_confirm = {
		284260,
		111,
		true
	},
	level_risk_level_desc = {
		284371,
		90,
		true
	},
	level_risk_level_mitigation_rate = {
		284461,
		239,
		true
	},
	level_diffcult_chapter_state_safety = {
		284700,
		229,
		true
	},
	level_chapter_state_high_risk = {
		284929,
		137,
		true
	},
	level_chapter_state_risk = {
		285066,
		128,
		true
	},
	level_chapter_state_low_risk = {
		285194,
		133,
		true
	},
	level_chapter_state_safety = {
		285327,
		132,
		true
	},
	open_skill_class_success = {
		285459,
		121,
		true
	},
	backyard_sort_tag_default = {
		285580,
		91,
		true
	},
	backyard_sort_tag_price = {
		285671,
		93,
		true
	},
	backyard_sort_tag_comfortable = {
		285764,
		100,
		true
	},
	backyard_sort_tag_size = {
		285864,
		90,
		true
	},
	backyard_filter_tag_other = {
		285954,
		93,
		true
	},
	word_status_inFight = {
		286047,
		90,
		true
	},
	word_status_inPVP = {
		286137,
		91,
		true
	},
	word_status_inEvent = {
		286228,
		92,
		true
	},
	word_status_inEventFinished = {
		286320,
		100,
		true
	},
	word_status_inTactics = {
		286420,
		93,
		true
	},
	word_status_inClass = {
		286513,
		91,
		true
	},
	word_status_rest = {
		286604,
		87,
		true
	},
	word_status_train = {
		286691,
		89,
		true
	},
	word_status_world = {
		286780,
		97,
		true
	},
	word_status_inHardFormation = {
		286877,
		103,
		true
	},
	word_status_series_enemy = {
		286980,
		103,
		true
	},
	challenge_rule = {
		287083,
		101,
		true
	},
	challenge_exit_warning = {
		287184,
		241,
		true
	},
	challenge_fleet_type_fail = {
		287425,
		141,
		true
	},
	challenge_current_level = {
		287566,
		110,
		true
	},
	challenge_current_score = {
		287676,
		104,
		true
	},
	challenge_total_score = {
		287780,
		99,
		true
	},
	challenge_current_progress = {
		287879,
		113,
		true
	},
	challenge_count_unlimit = {
		287992,
		99,
		true
	},
	challenge_no_fleet = {
		288091,
		118,
		true
	},
	equipment_skin_unload = {
		288209,
		147,
		true
	},
	equipment_skin_no_old_ship = {
		288356,
		119,
		true
	},
	equipment_skin_no_old_skinorequipment = {
		288475,
		162,
		true
	},
	equipment_skin_no_new_ship = {
		288637,
		113,
		true
	},
	equipment_skin_no_new_equipment = {
		288750,
		126,
		true
	},
	equipment_skin_count_noenough = {
		288876,
		115,
		true
	},
	equipment_skin_replace_done = {
		288991,
		120,
		true
	},
	equipment_skin_unload_failed = {
		289111,
		128,
		true
	},
	equipment_skin_unmatch_equipment = {
		289239,
		180,
		true
	},
	equipment_skin_no_equipment_tip = {
		289419,
		156,
		true
	},
	activity_pool_awards_empty = {
		289575,
		119,
		true
	},
	activity_switch_award_pool_failed = {
		289694,
		183,
		true
	},
	shop_street_activity_tip = {
		289877,
		300,
		true
	},
	shop_street_Equipment_skin_box_help = {
		290177,
		166,
		true
	},
	twitter_link_title = {
		290343,
		100,
		true
	},
	commander_material_noenough = {
		290443,
		122,
		true
	},
	battle_result_boss_destruct = {
		290565,
		132,
		true
	},
	battle_preCombatLayer_boss_destruct = {
		290697,
		140,
		true
	},
	destory_important_equipment_tip = {
		290837,
		198,
		true
	},
	destory_important_equipment_input_erro = {
		291035,
		121,
		true
	},
	activity_hit_monster_nocount = {
		291156,
		112,
		true
	},
	activity_hit_monster_death = {
		291268,
		124,
		true
	},
	activity_hit_monster_help = {
		291392,
		119,
		true
	},
	activity_hit_monster_erro = {
		291511,
		103,
		true
	},
	activity_xiaotiane_progress = {
		291614,
		107,
		true
	},
	activity_hit_monster_reset_tip = {
		291721,
		228,
		true
	},
	answer_help_tip = {
		291949,
		182,
		true
	},
	answer_answer_role = {
		292131,
		172,
		true
	},
	answer_exit_tip = {
		292303,
		112,
		true
	},
	equip_skin_detail_tip = {
		292415,
		121,
		true
	},
	emoji_type_0 = {
		292536,
		82,
		true
	},
	emoji_type_1 = {
		292618,
		83,
		true
	},
	emoji_type_2 = {
		292701,
		84,
		true
	},
	emoji_type_3 = {
		292785,
		82,
		true
	},
	emoji_type_4 = {
		292867,
		84,
		true
	},
	card_pairs_help_tip = {
		292951,
		943,
		true
	},
	card_pairs_tips = {
		293894,
		162,
		true
	},
	["card_battle_card details_deck"] = {
		294056,
		105,
		true
	},
	["card_battle_card details_hand"] = {
		294161,
		109,
		true
	},
	["card_battle_card details"] = {
		294270,
		100,
		true
	},
	["card_battle_card details_switchto_deck"] = {
		294370,
		111,
		true
	},
	["card_battle_card details_switchto_hand"] = {
		294481,
		115,
		true
	},
	card_battle_card_empty_en = {
		294596,
		106,
		true
	},
	card_battle_card_empty_ch = {
		294702,
		130,
		true
	},
	card_puzzel_goal_ch = {
		294832,
		93,
		true
	},
	card_puzzel_goal_en = {
		294925,
		89,
		true
	},
	card_puzzle_deck = {
		295014,
		84,
		true
	},
	upgrade_to_next_maxlevel_failed = {
		295098,
		181,
		true
	},
	upgrade_to_next_maxlevel_tip = {
		295279,
		240,
		true
	},
	upgrade_to_next_maxlevel_succeed = {
		295519,
		198,
		true
	},
	extra_chapter_socre_tip = {
		295717,
		173,
		true
	},
	extra_chapter_record_updated = {
		295890,
		102,
		true
	},
	extra_chapter_record_not_updated = {
		295992,
		112,
		true
	},
	extra_chapter_locked_tip = {
		296104,
		120,
		true
	},
	extra_chapter_locked_tip_1 = {
		296224,
		167,
		true
	},
	player_name_change_time_lv_tip = {
		296391,
		172,
		true
	},
	player_name_change_time_limit_tip = {
		296563,
		174,
		true
	},
	player_name_change_windows_tip = {
		296737,
		234,
		true
	},
	player_name_change_warning = {
		296971,
		247,
		true
	},
	player_name_change_success = {
		297218,
		116,
		true
	},
	player_name_change_failed = {
		297334,
		111,
		true
	},
	same_player_name_tip = {
		297445,
		109,
		true
	},
	task_is_not_existence = {
		297554,
		112,
		true
	},
	cannot_build_multiple_printblue = {
		297666,
		366,
		true
	},
	printblue_build_success = {
		298032,
		107,
		true
	},
	printblue_build_erro = {
		298139,
		103,
		true
	},
	blueprint_mod_success = {
		298242,
		107,
		true
	},
	blueprint_mod_erro = {
		298349,
		100,
		true
	},
	technology_refresh_sucess = {
		298449,
		133,
		true
	},
	technology_refresh_erro = {
		298582,
		126,
		true
	},
	change_technology_refresh_sucess = {
		298708,
		136,
		true
	},
	change_technology_refresh_erro = {
		298844,
		130,
		true
	},
	technology_start_up = {
		298974,
		100,
		true
	},
	technology_start_erro = {
		299074,
		101,
		true
	},
	technology_stop_success = {
		299175,
		119,
		true
	},
	technology_stop_erro = {
		299294,
		111,
		true
	},
	technology_finish_success = {
		299405,
		121,
		true
	},
	technology_finish_erro = {
		299526,
		114,
		true
	},
	blueprint_stop_success = {
		299640,
		121,
		true
	},
	blueprint_stop_erro = {
		299761,
		113,
		true
	},
	blueprint_destory_tip = {
		299874,
		119,
		true
	},
	blueprint_task_update_tip = {
		299993,
		172,
		true
	},
	blueprint_mod_addition_lock = {
		300165,
		125,
		true
	},
	blueprint_mod_word_unlock = {
		300290,
		111,
		true
	},
	blueprint_mod_skin_unlock = {
		300401,
		106,
		true
	},
	blueprint_build_consume = {
		300507,
		120,
		true
	},
	blueprint_stop_tip = {
		300627,
		180,
		true
	},
	technology_canot_refresh = {
		300807,
		153,
		true
	},
	technology_refresh_tip = {
		300960,
		138,
		true
	},
	technology_is_actived = {
		301098,
		125,
		true
	},
	technology_stop_tip = {
		301223,
		178,
		true
	},
	technology_help_text = {
		301401,
		2742,
		true
	},
	blueprint_build_time_tip = {
		304143,
		209,
		true
	},
	blueprint_cannot_build_tip = {
		304352,
		147,
		true
	},
	technology_task_none_tip = {
		304499,
		97,
		true
	},
	technology_task_build_tip = {
		304596,
		161,
		true
	},
	blueprint_commit_tip = {
		304757,
		165,
		true
	},
	buleprint_need_level_tip = {
		304922,
		141,
		true
	},
	blueprint_max_level_tip = {
		305063,
		132,
		true
	},
	ship_profile_voice_locked_intimacy = {
		305195,
		133,
		true
	},
	ship_profile_voice_locked_propose = {
		305328,
		115,
		true
	},
	ship_profile_voice_locked_propose_imas = {
		305443,
		120,
		true
	},
	ship_profile_voice_locked_design = {
		305563,
		140,
		true
	},
	ship_profile_voice_locked_meta = {
		305703,
		106,
		true
	},
	help_technolog0 = {
		305809,
		350,
		true
	},
	help_technolog = {
		306159,
		513,
		true
	},
	hide_chat_warning = {
		306672,
		115,
		true
	},
	show_chat_warning = {
		306787,
		117,
		true
	},
	help_shipblueprintui = {
		306904,
		4396,
		true
	},
	help_shipblueprintui_luck = {
		311300,
		734,
		true
	},
	anniversary_task_title_1 = {
		312034,
		175,
		true
	},
	anniversary_task_title_2 = {
		312209,
		206,
		true
	},
	anniversary_task_title_3 = {
		312415,
		177,
		true
	},
	anniversary_task_title_4 = {
		312592,
		210,
		true
	},
	anniversary_task_title_5 = {
		312802,
		184,
		true
	},
	anniversary_task_title_6 = {
		312986,
		204,
		true
	},
	anniversary_task_title_7 = {
		313190,
		202,
		true
	},
	anniversary_task_title_8 = {
		313392,
		169,
		true
	},
	anniversary_task_title_9 = {
		313561,
		193,
		true
	},
	anniversary_task_title_10 = {
		313754,
		176,
		true
	},
	anniversary_task_title_11 = {
		313930,
		160,
		true
	},
	anniversary_task_title_12 = {
		314090,
		178,
		true
	},
	anniversary_task_title_13 = {
		314268,
		195,
		true
	},
	anniversary_task_title_14 = {
		314463,
		179,
		true
	},
	charge_scene_buy_confirm = {
		314642,
		163,
		true
	},
	charge_scene_buy_confirm_gold = {
		314805,
		168,
		true
	},
	charge_scene_batch_buy_tip = {
		314973,
		189,
		true
	},
	help_level_ui = {
		315162,
		911,
		true
	},
	guild_modify_info_tip = {
		316073,
		193,
		true
	},
	ai_change_1 = {
		316266,
		118,
		true
	},
	ai_change_2 = {
		316384,
		117,
		true
	},
	activity_shop_lable = {
		316501,
		126,
		true
	},
	word_bilibili = {
		316627,
		90,
		true
	},
	levelScene_tracking_error_pre = {
		316717,
		143,
		true
	},
	ship_limit_notice = {
		316860,
		157,
		true
	},
	idle = {
		317017,
		73,
		true
	},
	main_1 = {
		317090,
		81,
		true
	},
	main_2 = {
		317171,
		81,
		true
	},
	main_3 = {
		317252,
		81,
		true
	},
	complete = {
		317333,
		84,
		true
	},
	login = {
		317417,
		74,
		true
	},
	home = {
		317491,
		74,
		true
	},
	mail = {
		317565,
		77,
		true
	},
	mission = {
		317642,
		83,
		true
	},
	mission_complete = {
		317725,
		96,
		true
	},
	wedding = {
		317821,
		77,
		true
	},
	touch_head = {
		317898,
		84,
		true
	},
	touch_body = {
		317982,
		82,
		true
	},
	touch_special = {
		318064,
		84,
		true
	},
	gold = {
		318148,
		73,
		true
	},
	oil = {
		318221,
		70,
		true
	},
	diamond = {
		318291,
		75,
		true
	},
	word_photo_mode = {
		318366,
		84,
		true
	},
	word_video_mode = {
		318450,
		82,
		true
	},
	word_save_ok = {
		318532,
		114,
		true
	},
	word_save_video = {
		318646,
		120,
		true
	},
	reflux_help_tip = {
		318766,
		974,
		true
	},
	reflux_pt_not_enough = {
		319740,
		121,
		true
	},
	reflux_word_1 = {
		319861,
		87,
		true
	},
	reflux_word_2 = {
		319948,
		85,
		true
	},
	ship_hunting_level_tips = {
		320033,
		190,
		true
	},
	acquisitionmode_is_not_open = {
		320223,
		123,
		true
	},
	collect_chapter_is_activation = {
		320346,
		140,
		true
	},
	levelScene_chapter_is_activation = {
		320486,
		189,
		true
	},
	resource_verify_warn = {
		320675,
		245,
		true
	},
	resource_verify_fail = {
		320920,
		191,
		true
	},
	resource_verify_success = {
		321111,
		122,
		true
	},
	resource_clear_all = {
		321233,
		178,
		true
	},
	resource_clear_manga = {
		321411,
		228,
		true
	},
	resource_clear_gallery = {
		321639,
		236,
		true
	},
	resource_clear_3ddorm = {
		321875,
		256,
		true
	},
	resource_clear_tbchild = {
		322131,
		257,
		true
	},
	resource_clear_3disland = {
		322388,
		254,
		true
	},
	resource_clear_generaltext = {
		322642,
		103,
		true
	},
	acl_oil_count = {
		322745,
		87,
		true
	},
	acl_oil_total_count = {
		322832,
		99,
		true
	},
	word_take_video_tip = {
		322931,
		141,
		true
	},
	word_snapshot_share_title = {
		323072,
		118,
		true
	},
	word_snapshot_share_agreement = {
		323190,
		540,
		true
	},
	skin_remain_time = {
		323730,
		91,
		true
	},
	word_museum_1 = {
		323821,
		120,
		true
	},
	word_museum_help = {
		323941,
		734,
		true
	},
	goldship_help_tip = {
		324675,
		787,
		true
	},
	metalgearsub_help_tip = {
		325462,
		1847,
		true
	},
	acl_gold_count = {
		327309,
		91,
		true
	},
	acl_gold_total_count = {
		327400,
		102,
		true
	},
	discount_time = {
		327502,
		146,
		true
	},
	commander_talent_not_exist = {
		327648,
		132,
		true
	},
	commander_replace_talent_not_exist = {
		327780,
		154,
		true
	},
	commander_talent_learned = {
		327934,
		121,
		true
	},
	commander_talent_learn_erro = {
		328055,
		133,
		true
	},
	commander_not_exist = {
		328188,
		114,
		true
	},
	commander_fleet_not_exist = {
		328302,
		115,
		true
	},
	commander_fleet_pos_not_exist = {
		328417,
		128,
		true
	},
	commander_equip_to_fleet_erro = {
		328545,
		140,
		true
	},
	commander_acquire_erro = {
		328685,
		138,
		true
	},
	commander_lock_erro = {
		328823,
		121,
		true
	},
	commander_reset_talent_time_no_rearch = {
		328944,
		157,
		true
	},
	commander_reset_talent_is_not_need = {
		329101,
		125,
		true
	},
	commander_reset_talent_success = {
		329226,
		118,
		true
	},
	commander_reset_talent_erro = {
		329344,
		136,
		true
	},
	commander_can_not_be_upgrade = {
		329480,
		133,
		true
	},
	commander_anyone_is_in_fleet = {
		329613,
		139,
		true
	},
	commander_is_in_fleet = {
		329752,
		133,
		true
	},
	commander_play_erro = {
		329885,
		104,
		true
	},
	ship_equip_same_group_equipment = {
		329989,
		136,
		true
	},
	summary_page_un_rearch = {
		330125,
		96,
		true
	},
	player_summary_from = {
		330221,
		97,
		true
	},
	player_summary_data = {
		330318,
		95,
		true
	},
	commander_exp_overflow_tip = {
		330413,
		192,
		true
	},
	commander_reset_talent_tip = {
		330605,
		141,
		true
	},
	commander_reset_talent = {
		330746,
		96,
		true
	},
	commander_select_min_cnt = {
		330842,
		127,
		true
	},
	commander_select_max = {
		330969,
		123,
		true
	},
	commander_lock_done = {
		331092,
		101,
		true
	},
	commander_unlock_done = {
		331193,
		105,
		true
	},
	commander_get_1 = {
		331298,
		127,
		true
	},
	commander_get = {
		331425,
		139,
		true
	},
	commander_build_done = {
		331564,
		114,
		true
	},
	commander_build_erro = {
		331678,
		117,
		true
	},
	commander_get_skills_done = {
		331795,
		132,
		true
	},
	collection_way_is_unopen = {
		331927,
		115,
		true
	},
	commander_can_not_select_same_group = {
		332042,
		162,
		true
	},
	commander_capcity_is_max = {
		332204,
		115,
		true
	},
	commander_reserve_count_is_max = {
		332319,
		128,
		true
	},
	commander_build_pool_tip = {
		332447,
		143,
		true
	},
	commander_select_matiral_erro = {
		332590,
		212,
		true
	},
	commander_material_is_rarity = {
		332802,
		156,
		true
	},
	commander_material_is_maxLevel = {
		332958,
		200,
		true
	},
	charge_commander_bag_max = {
		333158,
		161,
		true
	},
	shop_extendcommander_success = {
		333319,
		148,
		true
	},
	commander_skill_point_noengough = {
		333467,
		144,
		true
	},
	buildship_new_tip = {
		333611,
		160,
		true
	},
	buildship_heavy_tip = {
		333771,
		138,
		true
	},
	buildship_light_tip = {
		333909,
		127,
		true
	},
	buildship_special_tip = {
		334036,
		136,
		true
	},
	Normalbuild_URexchange_help = {
		334172,
		615,
		true
	},
	Normalbuild_URexchange_text1 = {
		334787,
		103,
		true
	},
	Normalbuild_URexchange_text2 = {
		334890,
		97,
		true
	},
	Normalbuild_URexchange_text3 = {
		334987,
		103,
		true
	},
	Normalbuild_URexchange_text4 = {
		335090,
		100,
		true
	},
	Normalbuild_URexchange_warning1 = {
		335190,
		128,
		true
	},
	Normalbuild_URexchange_warning3 = {
		335318,
		207,
		true
	},
	Normalbuild_URexchange_confirm = {
		335525,
		121,
		true
	},
	open_skill_pos = {
		335646,
		236,
		true
	},
	open_skill_pos_discount = {
		335882,
		239,
		true
	},
	event_recommend_fail = {
		336121,
		124,
		true
	},
	newplayer_help_tip = {
		336245,
		988,
		true
	},
	newplayer_notice_1 = {
		337233,
		125,
		true
	},
	newplayer_notice_2 = {
		337358,
		125,
		true
	},
	newplayer_notice_3 = {
		337483,
		117,
		true
	},
	newplayer_notice_4 = {
		337600,
		121,
		true
	},
	newplayer_notice_5 = {
		337721,
		119,
		true
	},
	newplayer_notice_6 = {
		337840,
		171,
		true
	},
	newplayer_notice_7 = {
		338011,
		124,
		true
	},
	newplayer_notice_8 = {
		338135,
		149,
		true
	},
	tec_catchup_1 = {
		338284,
		85,
		true
	},
	tec_catchup_2 = {
		338369,
		85,
		true
	},
	tec_catchup_3 = {
		338454,
		85,
		true
	},
	tec_catchup_4 = {
		338539,
		85,
		true
	},
	tec_catchup_5 = {
		338624,
		85,
		true
	},
	tec_catchup_6 = {
		338709,
		85,
		true
	},
	tec_catchup_7 = {
		338794,
		85,
		true
	},
	tec_notice = {
		338879,
		124,
		true
	},
	tec_notice_not_open_tip = {
		339003,
		141,
		true
	},
	apply_permission_camera_tip1 = {
		339144,
		181,
		true
	},
	apply_permission_camera_tip2 = {
		339325,
		187,
		true
	},
	apply_permission_camera_tip3 = {
		339512,
		177,
		true
	},
	apply_permission_record_audio_tip1 = {
		339689,
		163,
		true
	},
	apply_permission_record_audio_tip2 = {
		339852,
		197,
		true
	},
	apply_permission_record_audio_tip3 = {
		340049,
		183,
		true
	},
	nine_choose_one = {
		340232,
		269,
		true
	},
	help_commander_info = {
		340501,
		810,
		true
	},
	help_commander_play = {
		341311,
		810,
		true
	},
	help_commander_ability = {
		342121,
		813,
		true
	},
	story_skip_confirm = {
		342934,
		215,
		true
	},
	commander_ability_replace_warning = {
		343149,
		205,
		true
	},
	help_command_room = {
		343354,
		808,
		true
	},
	commander_build_rate_tip = {
		344162,
		154,
		true
	},
	help_activity_bossbattle = {
		344316,
		1040,
		true
	},
	commander_is_in_fleet_already = {
		345356,
		141,
		true
	},
	commander_material_is_in_fleet_tip = {
		345497,
		167,
		true
	},
	commander_main_pos = {
		345664,
		93,
		true
	},
	commander_assistant_pos = {
		345757,
		96,
		true
	},
	comander_repalce_tip = {
		345853,
		200,
		true
	},
	commander_lock_tip = {
		346053,
		121,
		true
	},
	commander_is_in_battle = {
		346174,
		125,
		true
	},
	commander_rename_warning = {
		346299,
		143,
		true
	},
	commander_rename_coldtime_tip = {
		346442,
		154,
		true
	},
	commander_rename_success_tip = {
		346596,
		115,
		true
	},
	amercian_notice_1 = {
		346711,
		170,
		true
	},
	amercian_notice_2 = {
		346881,
		131,
		true
	},
	amercian_notice_3 = {
		347012,
		104,
		true
	},
	amercian_notice_4 = {
		347116,
		92,
		true
	},
	amercian_notice_5 = {
		347208,
		112,
		true
	},
	amercian_notice_6 = {
		347320,
		222,
		true
	},
	ranking_word_1 = {
		347542,
		89,
		true
	},
	ranking_word_2 = {
		347631,
		93,
		true
	},
	ranking_word_3 = {
		347724,
		91,
		true
	},
	ranking_word_4 = {
		347815,
		93,
		true
	},
	ranking_word_5 = {
		347908,
		89,
		true
	},
	ranking_word_6 = {
		347997,
		91,
		true
	},
	ranking_word_7 = {
		348088,
		90,
		true
	},
	ranking_word_8 = {
		348178,
		82,
		true
	},
	ranking_word_9 = {
		348260,
		83,
		true
	},
	ranking_word_10 = {
		348343,
		94,
		true
	},
	spece_illegal_tip = {
		348437,
		99,
		true
	},
	utaware_warmup_notice = {
		348536,
		902,
		true
	},
	utaware_formal_notice = {
		349438,
		648,
		true
	},
	npc_learn_skill_tip = {
		350086,
		250,
		true
	},
	npc_upgrade_max_level = {
		350336,
		147,
		true
	},
	npc_propse_tip = {
		350483,
		113,
		true
	},
	npc_strength_tip = {
		350596,
		206,
		true
	},
	npc_breakout_tip = {
		350802,
		210,
		true
	},
	word_chuansong = {
		351012,
		95,
		true
	},
	npc_evaluation_tip = {
		351107,
		145,
		true
	},
	map_event_skip = {
		351252,
		90,
		true
	},
	map_event_stop_tip = {
		351342,
		163,
		true
	},
	map_event_stop_battle_tip = {
		351505,
		172,
		true
	},
	map_event_stop_battle_tip_2 = {
		351677,
		151,
		true
	},
	map_event_stop_story_tip = {
		351828,
		167,
		true
	},
	map_event_save_nekone = {
		351995,
		136,
		true
	},
	map_event_save_rurutie = {
		352131,
		139,
		true
	},
	map_event_memory_collected = {
		352270,
		152,
		true
	},
	map_event_save_kizuna = {
		352422,
		140,
		true
	},
	five_choose_one = {
		352562,
		201,
		true
	},
	ship_preference_common = {
		352763,
		107,
		true
	},
	draw_big_luck_1 = {
		352870,
		116,
		true
	},
	draw_big_luck_2 = {
		352986,
		127,
		true
	},
	draw_big_luck_3 = {
		353113,
		131,
		true
	},
	draw_medium_luck_1 = {
		353244,
		124,
		true
	},
	draw_medium_luck_2 = {
		353368,
		122,
		true
	},
	draw_medium_luck_3 = {
		353490,
		133,
		true
	},
	draw_little_luck_1 = {
		353623,
		128,
		true
	},
	draw_little_luck_2 = {
		353751,
		124,
		true
	},
	draw_little_luck_3 = {
		353875,
		134,
		true
	},
	ship_preference_non = {
		354009,
		106,
		true
	},
	school_title_dajiangtang = {
		354115,
		101,
		true
	},
	school_title_zhihuimiao = {
		354216,
		95,
		true
	},
	school_title_shitang = {
		354311,
		92,
		true
	},
	school_title_xiaomaibu = {
		354403,
		95,
		true
	},
	school_title_shangdian = {
		354498,
		94,
		true
	},
	school_title_xueyuan = {
		354592,
		98,
		true
	},
	school_title_shoucang = {
		354690,
		95,
		true
	},
	school_title_xiaoyouxiting = {
		354785,
		96,
		true
	},
	tag_level_fighting = {
		354881,
		93,
		true
	},
	tag_level_oni = {
		354974,
		89,
		true
	},
	tag_level_bomb = {
		355063,
		90,
		true
	},
	ui_word_levelui2_inevent = {
		355153,
		97,
		true
	},
	exit_backyard_exp_display = {
		355250,
		125,
		true
	},
	help_monopoly = {
		355375,
		1634,
		true
	},
	md5_error = {
		357009,
		120,
		true
	},
	world_boss_help = {
		357129,
		4705,
		true
	},
	world_boss_tip = {
		361834,
		193,
		true
	},
	world_boss_award_limit = {
		362027,
		157,
		true
	},
	backyard_is_loading = {
		362184,
		104,
		true
	},
	levelScene_loop_help_tip = {
		362288,
		2782,
		true
	},
	no_airspace_competition = {
		365070,
		104,
		true
	},
	air_supremacy_value = {
		365174,
		101,
		true
	},
	read_the_user_agreement = {
		365275,
		146,
		true
	},
	award_max_warning = {
		365421,
		175,
		true
	},
	sub_item_warning = {
		365596,
		140,
		true
	},
	select_award_warning = {
		365736,
		126,
		true
	},
	no_item_selected_tip = {
		365862,
		119,
		true
	},
	backyard_traning_tip = {
		365981,
		160,
		true
	},
	backyard_rest_tip = {
		366141,
		122,
		true
	},
	backyard_class_tip = {
		366263,
		122,
		true
	},
	medal_notice_1 = {
		366385,
		95,
		true
	},
	medal_notice_2 = {
		366480,
		86,
		true
	},
	medal_help_tip = {
		366566,
		1522,
		true
	},
	trophy_achieved = {
		368088,
		94,
		true
	},
	text_shop = {
		368182,
		77,
		true
	},
	text_confirm = {
		368259,
		83,
		true
	},
	text_cancel = {
		368342,
		81,
		true
	},
	text_cancel_fight = {
		368423,
		93,
		true
	},
	text_goon_fight = {
		368516,
		87,
		true
	},
	text_exit = {
		368603,
		77,
		true
	},
	text_clear = {
		368680,
		79,
		true
	},
	text_apply = {
		368759,
		83,
		true
	},
	text_buy = {
		368842,
		75,
		true
	},
	text_forward = {
		368917,
		78,
		true
	},
	text_prepage = {
		368995,
		80,
		true
	},
	text_nextpage = {
		369075,
		81,
		true
	},
	text_exchange = {
		369156,
		85,
		true
	},
	text_retreat = {
		369241,
		83,
		true
	},
	text_goto = {
		369324,
		80,
		true
	},
	level_scene_title_word_1 = {
		369404,
		100,
		true
	},
	level_scene_title_word_2 = {
		369504,
		108,
		true
	},
	level_scene_title_word_3 = {
		369612,
		100,
		true
	},
	level_scene_title_word_4 = {
		369712,
		97,
		true
	},
	level_scene_title_word_5 = {
		369809,
		97,
		true
	},
	ambush_display_0 = {
		369906,
		89,
		true
	},
	ambush_display_1 = {
		369995,
		84,
		true
	},
	ambush_display_2 = {
		370079,
		85,
		true
	},
	ambush_display_3 = {
		370164,
		83,
		true
	},
	ambush_display_4 = {
		370247,
		86,
		true
	},
	ambush_display_5 = {
		370333,
		84,
		true
	},
	ambush_display_6 = {
		370417,
		86,
		true
	},
	black_white_grid_notice = {
		370503,
		1416,
		true
	},
	black_white_grid_reset = {
		371919,
		104,
		true
	},
	black_white_grid_switch_tip = {
		372023,
		122,
		true
	},
	no_way_to_escape = {
		372145,
		93,
		true
	},
	word_attr_ac = {
		372238,
		92,
		true
	},
	help_battle_ac = {
		372330,
		2193,
		true
	},
	help_attribute_dodge_limit = {
		374523,
		388,
		true
	},
	refuse_friend = {
		374911,
		105,
		true
	},
	refuse_and_add_into_bl = {
		375016,
		108,
		true
	},
	tech_simulate_closed = {
		375124,
		141,
		true
	},
	tech_simulate_quit = {
		375265,
		126,
		true
	},
	technology_uplevel_error_no_res = {
		375391,
		244,
		true
	},
	help_technologytree = {
		375635,
		2458,
		true
	},
	tech_change_version_mark = {
		378093,
		108,
		true
	},
	technology_uplevel_error_studying = {
		378201,
		196,
		true
	},
	fate_attr_word = {
		378397,
		105,
		true
	},
	fate_phase_word = {
		378502,
		98,
		true
	},
	blueprint_simulation_confirm = {
		378600,
		245,
		true
	},
	blueprint_simulation_confirm_19901 = {
		378845,
		416,
		true
	},
	blueprint_simulation_confirm_19902 = {
		379261,
		397,
		true
	},
	blueprint_simulation_confirm_39903 = {
		379658,
		398,
		true
	},
	blueprint_simulation_confirm_39904 = {
		380056,
		415,
		true
	},
	blueprint_simulation_confirm_49902 = {
		380471,
		413,
		true
	},
	blueprint_simulation_confirm_99901 = {
		380884,
		412,
		true
	},
	blueprint_simulation_confirm_29903 = {
		381296,
		374,
		true
	},
	blueprint_simulation_confirm_29904 = {
		381670,
		381,
		true
	},
	blueprint_simulation_confirm_49903 = {
		382051,
		374,
		true
	},
	blueprint_simulation_confirm_49904 = {
		382425,
		384,
		true
	},
	blueprint_simulation_confirm_89902 = {
		382809,
		380,
		true
	},
	blueprint_simulation_confirm_19903 = {
		383189,
		406,
		true
	},
	blueprint_simulation_confirm_39905 = {
		383595,
		349,
		true
	},
	blueprint_simulation_confirm_49905 = {
		383944,
		409,
		true
	},
	blueprint_simulation_confirm_49906 = {
		384353,
		339,
		true
	},
	blueprint_simulation_confirm_69901 = {
		384692,
		421,
		true
	},
	blueprint_simulation_confirm_29905 = {
		385113,
		398,
		true
	},
	blueprint_simulation_confirm_49907 = {
		385511,
		406,
		true
	},
	blueprint_simulation_confirm_59901 = {
		385917,
		396,
		true
	},
	blueprint_simulation_confirm_79901 = {
		386313,
		347,
		true
	},
	blueprint_simulation_confirm_89903 = {
		386660,
		416,
		true
	},
	blueprint_simulation_confirm_19904 = {
		387076,
		423,
		true
	},
	blueprint_simulation_confirm_39906 = {
		387499,
		430,
		true
	},
	blueprint_simulation_confirm_49908 = {
		387929,
		441,
		true
	},
	blueprint_simulation_confirm_49909 = {
		388370,
		440,
		true
	},
	blueprint_simulation_confirm_99902 = {
		388810,
		431,
		true
	},
	blueprint_simulation_confirm_19905 = {
		389241,
		379,
		true
	},
	blueprint_simulation_confirm_39907 = {
		389620,
		399,
		true
	},
	blueprint_simulation_confirm_69902 = {
		390019,
		441,
		true
	},
	blueprint_simulation_confirm_89904 = {
		390460,
		408,
		true
	},
	blueprint_simulation_confirm_79902 = {
		390868,
		385,
		true
	},
	blueprint_simulation_confirm_19906 = {
		391253,
		418,
		true
	},
	blueprint_simulation_confirm_49910 = {
		391671,
		414,
		true
	},
	blueprint_simulation_confirm_69903 = {
		392085,
		437,
		true
	},
	blueprint_simulation_confirm_79903 = {
		392522,
		431,
		true
	},
	blueprint_simulation_confirm_119901 = {
		392953,
		429,
		true
	},
	electrotherapy_wanning = {
		393382,
		125,
		true
	},
	siren_chase_warning = {
		393507,
		104,
		true
	},
	memorybook_get_award_tip = {
		393611,
		173,
		true
	},
	memorybook_notice = {
		393784,
		548,
		true
	},
	word_votes = {
		394332,
		79,
		true
	},
	number_0 = {
		394411,
		73,
		true
	},
	intimacy_desc_propose_vertical = {
		394484,
		340,
		true
	},
	without_selected_ship = {
		394824,
		101,
		true
	},
	index_all = {
		394925,
		76,
		true
	},
	index_fleetfront = {
		395001,
		89,
		true
	},
	index_fleetrear = {
		395090,
		84,
		true
	},
	index_shipType_quZhu = {
		395174,
		86,
		true
	},
	index_shipType_qinXun = {
		395260,
		87,
		true
	},
	index_shipType_zhongXun = {
		395347,
		89,
		true
	},
	index_shipType_zhanLie = {
		395436,
		88,
		true
	},
	index_shipType_hangMu = {
		395524,
		87,
		true
	},
	index_shipType_weiXiu = {
		395611,
		87,
		true
	},
	index_shipType_qianTing = {
		395698,
		89,
		true
	},
	index_other = {
		395787,
		79,
		true
	},
	index_rare2 = {
		395866,
		81,
		true
	},
	index_rare3 = {
		395947,
		79,
		true
	},
	index_rare4 = {
		396026,
		80,
		true
	},
	index_rare5 = {
		396106,
		85,
		true
	},
	index_rare6 = {
		396191,
		80,
		true
	},
	warning_mail_max_1 = {
		396271,
		197,
		true
	},
	warning_mail_max_2 = {
		396468,
		103,
		true
	},
	warning_mail_max_3 = {
		396571,
		196,
		true
	},
	warning_mail_max_4 = {
		396767,
		209,
		true
	},
	warning_mail_max_5 = {
		396976,
		141,
		true
	},
	mail_moveto_markroom_1 = {
		397117,
		223,
		true
	},
	mail_moveto_markroom_2 = {
		397340,
		233,
		true
	},
	mail_moveto_markroom_max = {
		397573,
		186,
		true
	},
	mail_markroom_delete = {
		397759,
		153,
		true
	},
	mail_markroom_tip = {
		397912,
		135,
		true
	},
	mail_manage_1 = {
		398047,
		80,
		true
	},
	mail_manage_2 = {
		398127,
		109,
		true
	},
	mail_manage_3 = {
		398236,
		116,
		true
	},
	mail_manage_tip_1 = {
		398352,
		156,
		true
	},
	mail_storeroom_tips = {
		398508,
		139,
		true
	},
	mail_storeroom_noextend = {
		398647,
		168,
		true
	},
	mail_storeroom_extend = {
		398815,
		111,
		true
	},
	mail_storeroom_extend_1 = {
		398926,
		104,
		true
	},
	mail_storeroom_taken_1 = {
		399030,
		104,
		true
	},
	mail_storeroom_max_1 = {
		399134,
		185,
		true
	},
	mail_storeroom_max_2 = {
		399319,
		136,
		true
	},
	mail_storeroom_max_3 = {
		399455,
		139,
		true
	},
	mail_storeroom_max_4 = {
		399594,
		142,
		true
	},
	mail_storeroom_addgold = {
		399736,
		103,
		true
	},
	mail_storeroom_addoil = {
		399839,
		100,
		true
	},
	mail_storeroom_collect = {
		399939,
		139,
		true
	},
	mail_search = {
		400078,
		87,
		true
	},
	mail_storeroom_resourcetaken = {
		400165,
		107,
		true
	},
	resource_max_tip_storeroom = {
		400272,
		131,
		true
	},
	mail_tip = {
		400403,
		1328,
		true
	},
	mail_page_1 = {
		401731,
		79,
		true
	},
	mail_page_2 = {
		401810,
		82,
		true
	},
	mail_page_3 = {
		401892,
		82,
		true
	},
	mail_gold_res = {
		401974,
		82,
		true
	},
	mail_oil_res = {
		402056,
		79,
		true
	},
	mail_all_price = {
		402135,
		84,
		true
	},
	return_award_bind_success = {
		402219,
		110,
		true
	},
	return_award_bind_erro = {
		402329,
		106,
		true
	},
	rename_commander_erro = {
		402435,
		111,
		true
	},
	change_display_medal_success = {
		402546,
		123,
		true
	},
	limit_skin_time_day = {
		402669,
		103,
		true
	},
	limit_skin_time_day_min = {
		402772,
		108,
		true
	},
	limit_skin_time_min = {
		402880,
		106,
		true
	},
	limit_skin_time_overtime = {
		402986,
		136,
		true
	},
	limit_skin_time_before_maintenance = {
		403122,
		119,
		true
	},
	award_window_pt_title = {
		403241,
		101,
		true
	},
	return_have_participated_in_act = {
		403342,
		140,
		true
	},
	input_returner_code = {
		403482,
		92,
		true
	},
	dress_up_success = {
		403574,
		115,
		true
	},
	already_have_the_skin = {
		403689,
		111,
		true
	},
	exchange_limit_skin_tip = {
		403800,
		188,
		true
	},
	returner_help = {
		403988,
		1925,
		true
	},
	attire_time_stamp = {
		405913,
		90,
		true
	},
	pray_build_select_ship_instruction = {
		406003,
		117,
		true
	},
	warning_pray_build_pool = {
		406120,
		212,
		true
	},
	error_pray_select_ship_max = {
		406332,
		113,
		true
	},
	tip_pray_build_pool_success = {
		406445,
		118,
		true
	},
	tip_pray_build_pool_fail = {
		406563,
		116,
		true
	},
	pray_build_help = {
		406679,
		2296,
		true
	},
	pray_build_UR_warning = {
		408975,
		161,
		true
	},
	bismarck_award_tip = {
		409136,
		118,
		true
	},
	bismarck_chapter_desc = {
		409254,
		171,
		true
	},
	returner_push_success = {
		409425,
		115,
		true
	},
	returner_max_count = {
		409540,
		126,
		true
	},
	returner_push_tip = {
		409666,
		240,
		true
	},
	returner_match_tip = {
		409906,
		232,
		true
	},
	return_lock_tip = {
		410138,
		134,
		true
	},
	challenge_help = {
		410272,
		1901,
		true
	},
	challenge_casual_reset = {
		412173,
		138,
		true
	},
	challenge_infinite_reset = {
		412311,
		153,
		true
	},
	challenge_normal_reset = {
		412464,
		132,
		true
	},
	challenge_casual_click_switch = {
		412596,
		184,
		true
	},
	challenge_infinite_click_switch = {
		412780,
		189,
		true
	},
	challenge_season_update = {
		412969,
		126,
		true
	},
	challenge_season_update_casual_clear = {
		413095,
		240,
		true
	},
	challenge_season_update_infinite_clear = {
		413335,
		245,
		true
	},
	challenge_season_update_casual_switch = {
		413580,
		274,
		true
	},
	challenge_season_update_infinite_switch = {
		413854,
		286,
		true
	},
	challenge_combat_score = {
		414140,
		101,
		true
	},
	challenge_share_progress = {
		414241,
		107,
		true
	},
	challenge_share = {
		414348,
		85,
		true
	},
	challenge_expire_warn = {
		414433,
		170,
		true
	},
	challenge_normal_tip = {
		414603,
		146,
		true
	},
	challenge_unlimited_tip = {
		414749,
		151,
		true
	},
	commander_prefab_rename_success = {
		414900,
		118,
		true
	},
	commander_prefab_name = {
		415018,
		92,
		true
	},
	commander_prefab_rename_time = {
		415110,
		145,
		true
	},
	commander_build_solt_deficiency = {
		415255,
		159,
		true
	},
	commander_select_box_tip = {
		415414,
		172,
		true
	},
	challenge_end_tip = {
		415586,
		107,
		true
	},
	pass_times = {
		415693,
		87,
		true
	},
	list_empty_tip_billboardui = {
		415780,
		116,
		true
	},
	list_empty_tip_equipmentdesignui = {
		415896,
		126,
		true
	},
	list_empty_tip_storehouseui_equip = {
		416022,
		121,
		true
	},
	list_empty_tip_storehouseui_item = {
		416143,
		125,
		true
	},
	list_empty_tip_eventui = {
		416268,
		118,
		true
	},
	list_empty_tip_guildrequestui = {
		416386,
		123,
		true
	},
	list_empty_tip_joinguildui = {
		416509,
		137,
		true
	},
	list_empty_tip_friendui = {
		416646,
		114,
		true
	},
	list_empty_tip_friendui_search = {
		416760,
		145,
		true
	},
	list_empty_tip_friendui_request = {
		416905,
		132,
		true
	},
	list_empty_tip_friendui_black = {
		417037,
		136,
		true
	},
	list_empty_tip_dockyardui = {
		417173,
		135,
		true
	},
	list_empty_tip_taskscene = {
		417308,
		120,
		true
	},
	empty_tip_mailboxui = {
		417428,
		117,
		true
	},
	emptymarkroom_tip_mailboxui = {
		417545,
		122,
		true
	},
	empty_tip_mailboxui_en = {
		417667,
		116,
		true
	},
	emptymarkroom_tip_mailboxui_en = {
		417783,
		126,
		true
	},
	words_settings_unlock_ship = {
		417909,
		105,
		true
	},
	words_settings_resolve_equip = {
		418014,
		107,
		true
	},
	words_settings_unlock_commander = {
		418121,
		116,
		true
	},
	words_settings_create_inherit = {
		418237,
		109,
		true
	},
	tips_fail_secondarypwd_much_times = {
		418346,
		185,
		true
	},
	words_desc_unlock = {
		418531,
		131,
		true
	},
	words_desc_resolve_equip = {
		418662,
		138,
		true
	},
	words_desc_create_inherit = {
		418800,
		105,
		true
	},
	words_desc_close_password = {
		418905,
		123,
		true
	},
	words_desc_change_settings = {
		419028,
		137,
		true
	},
	words_set_password = {
		419165,
		107,
		true
	},
	words_information = {
		419272,
		85,
		true
	},
	Word_Ship_Exp_Buff = {
		419357,
		92,
		true
	},
	secondarypassword_incorrectpwd_error = {
		419449,
		193,
		true
	},
	secondary_password_help = {
		419642,
		1501,
		true
	},
	comic_help = {
		421143,
		365,
		true
	},
	secondarypassword_illegal_tip = {
		421508,
		135,
		true
	},
	pt_cosume = {
		421643,
		80,
		true
	},
	secondarypassword_confirm_tips = {
		421723,
		178,
		true
	},
	help_tempesteve = {
		421901,
		800,
		true
	},
	word_rest_times = {
		422701,
		118,
		true
	},
	common_buy_gold_success = {
		422819,
		144,
		true
	},
	harbour_bomb_tip = {
		422963,
		110,
		true
	},
	submarine_approach = {
		423073,
		101,
		true
	},
	submarine_approach_desc = {
		423174,
		130,
		true
	},
	desc_quick_play = {
		423304,
		91,
		true
	},
	text_win_condition = {
		423395,
		97,
		true
	},
	text_lose_condition = {
		423492,
		99,
		true
	},
	text_rest_HP = {
		423591,
		93,
		true
	},
	desc_defense_reward = {
		423684,
		152,
		true
	},
	desc_base_hp = {
		423836,
		99,
		true
	},
	map_event_open = {
		423935,
		105,
		true
	},
	word_reward = {
		424040,
		82,
		true
	},
	tips_dispense_completed = {
		424122,
		103,
		true
	},
	tips_firework_completed = {
		424225,
		116,
		true
	},
	help_summer_feast = {
		424341,
		1164,
		true
	},
	help_firework_produce = {
		425505,
		668,
		true
	},
	help_firework = {
		426173,
		1685,
		true
	},
	help_summer_shrine = {
		427858,
		1066,
		true
	},
	help_summer_food = {
		428924,
		1622,
		true
	},
	help_summer_shooting = {
		430546,
		1075,
		true
	},
	help_summer_stamp = {
		431621,
		341,
		true
	},
	tips_summergame_exit = {
		431962,
		198,
		true
	},
	tips_shrine_buff = {
		432160,
		121,
		true
	},
	tips_shrine_nobuff = {
		432281,
		175,
		true
	},
	paint_hide_other_obj_tip = {
		432456,
		111,
		true
	},
	help_vote = {
		432567,
		6103,
		true
	},
	tips_firework_exit = {
		438670,
		157,
		true
	},
	result_firework_produce = {
		438827,
		148,
		true
	},
	tag_level_narrative = {
		438975,
		88,
		true
	},
	vote_get_book = {
		439063,
		115,
		true
	},
	vote_book_is_over = {
		439178,
		115,
		true
	},
	vote_fame_tip = {
		439293,
		167,
		true
	},
	word_maintain = {
		439460,
		94,
		true
	},
	name_zhanliejahe = {
		439554,
		97,
		true
	},
	change_skin_secretary_ship_success = {
		439651,
		124,
		true
	},
	change_skin_secretary_ship = {
		439775,
		103,
		true
	},
	word_billboard = {
		439878,
		86,
		true
	},
	word_easy = {
		439964,
		77,
		true
	},
	word_normal_junhe = {
		440041,
		87,
		true
	},
	word_hard = {
		440128,
		77,
		true
	},
	word_special_challenge_ticket = {
		440205,
		105,
		true
	},
	tip_exchange_ticket = {
		440310,
		177,
		true
	},
	dont_remind = {
		440487,
		89,
		true
	},
	worldbossex_help = {
		440576,
		909,
		true
	},
	ship_formationUI_fleetName_easy = {
		441485,
		99,
		true
	},
	ship_formationUI_fleetName_normal = {
		441584,
		103,
		true
	},
	ship_formationUI_fleetName_hard = {
		441687,
		99,
		true
	},
	ship_formationUI_fleetName_extra = {
		441786,
		98,
		true
	},
	ship_formationUI_fleetName_easy_ss = {
		441884,
		114,
		true
	},
	ship_formationUI_fleetName_normal_ss = {
		441998,
		118,
		true
	},
	ship_formationUI_fleetName_hard_ss = {
		442116,
		114,
		true
	},
	ship_formationUI_fleetName_extra_ss = {
		442230,
		113,
		true
	},
	text_consume = {
		442343,
		80,
		true
	},
	text_inconsume = {
		442423,
		80,
		true
	},
	pt_ship_now = {
		442503,
		93,
		true
	},
	pt_ship_goal = {
		442596,
		81,
		true
	},
	option_desc1 = {
		442677,
		165,
		true
	},
	option_desc2 = {
		442842,
		158,
		true
	},
	option_desc3 = {
		443000,
		167,
		true
	},
	option_desc4 = {
		443167,
		202,
		true
	},
	option_desc5 = {
		443369,
		140,
		true
	},
	option_desc6 = {
		443509,
		155,
		true
	},
	option_desc10 = {
		443664,
		143,
		true
	},
	option_desc11 = {
		443807,
		1748,
		true
	},
	music_collection = {
		445555,
		859,
		true
	},
	music_main = {
		446414,
		1073,
		true
	},
	music_juus = {
		447487,
		1103,
		true
	},
	doa_collection = {
		448590,
		846,
		true
	},
	ins_word_day = {
		449436,
		88,
		true
	},
	ins_word_hour = {
		449524,
		89,
		true
	},
	ins_word_minu = {
		449613,
		91,
		true
	},
	ins_word_like = {
		449704,
		85,
		true
	},
	ins_click_like_success = {
		449789,
		106,
		true
	},
	ins_push_comment_success = {
		449895,
		120,
		true
	},
	skinshop_live2d_fliter_failed = {
		450015,
		146,
		true
	},
	help_music_game = {
		450161,
		1355,
		true
	},
	restart_music_game = {
		451516,
		130,
		true
	},
	reselect_music_game = {
		451646,
		144,
		true
	},
	hololive_goodmorning = {
		451790,
		852,
		true
	},
	hololive_lianliankan = {
		452642,
		1410,
		true
	},
	hololive_dalaozhang = {
		454052,
		764,
		true
	},
	hololive_dashenling = {
		454816,
		1927,
		true
	},
	pocky_jiujiu = {
		456743,
		94,
		true
	},
	pocky_jiujiu_desc = {
		456837,
		118,
		true
	},
	pocky_help = {
		456955,
		697,
		true
	},
	secretary_help = {
		457652,
		2209,
		true
	},
	secretary_unlock2 = {
		459861,
		108,
		true
	},
	secretary_unlock3 = {
		459969,
		108,
		true
	},
	secretary_unlock4 = {
		460077,
		108,
		true
	},
	secretary_unlock5 = {
		460185,
		109,
		true
	},
	secretary_closed = {
		460294,
		88,
		true
	},
	confirm_unlock = {
		460382,
		113,
		true
	},
	secretary_pos_save = {
		460495,
		143,
		true
	},
	secretary_pos_save_success = {
		460638,
		105,
		true
	},
	collection_help = {
		460743,
		346,
		true
	},
	juese_tiyan = {
		461089,
		239,
		true
	},
	resolve_amount_prefix = {
		461328,
		104,
		true
	},
	compose_amount_prefix = {
		461432,
		100,
		true
	},
	help_sub_limits = {
		461532,
		92,
		true
	},
	help_sub_display = {
		461624,
		104,
		true
	},
	confirm_unlock_ship_main = {
		461728,
		151,
		true
	},
	msgbox_text_confirm = {
		461879,
		90,
		true
	},
	msgbox_text_shop = {
		461969,
		85,
		true
	},
	msgbox_text_cancel = {
		462054,
		88,
		true
	},
	msgbox_text_cancel_g = {
		462142,
		90,
		true
	},
	msgbox_text_cancel_fight = {
		462232,
		100,
		true
	},
	msgbox_text_goon_fight = {
		462332,
		94,
		true
	},
	msgbox_text_exit = {
		462426,
		84,
		true
	},
	msgbox_text_clear = {
		462510,
		86,
		true
	},
	msgbox_text_apply = {
		462596,
		85,
		true
	},
	msgbox_text_buy = {
		462681,
		87,
		true
	},
	msgbox_text_noPos_buy = {
		462768,
		91,
		true
	},
	msgbox_text_noPos_clear = {
		462859,
		91,
		true
	},
	msgbox_text_noPos_intensify = {
		462950,
		98,
		true
	},
	msgbox_text_forward = {
		463048,
		85,
		true
	},
	msgbox_text_iknow = {
		463133,
		87,
		true
	},
	msgbox_text_prepage = {
		463220,
		87,
		true
	},
	msgbox_text_nextpage = {
		463307,
		88,
		true
	},
	msgbox_text_exchange = {
		463395,
		92,
		true
	},
	msgbox_text_retreat = {
		463487,
		90,
		true
	},
	msgbox_text_go = {
		463577,
		80,
		true
	},
	msgbox_text_consume = {
		463657,
		87,
		true
	},
	msgbox_text_inconsume = {
		463744,
		87,
		true
	},
	msgbox_text_unlock = {
		463831,
		88,
		true
	},
	msgbox_text_save = {
		463919,
		85,
		true
	},
	msgbox_text_replace = {
		464004,
		88,
		true
	},
	msgbox_text_unload = {
		464092,
		89,
		true
	},
	msgbox_text_modify = {
		464181,
		89,
		true
	},
	msgbox_text_breakthrough = {
		464270,
		93,
		true
	},
	msgbox_text_equipdetail = {
		464363,
		94,
		true
	},
	msgbox_text_use = {
		464457,
		82,
		true
	},
	common_flag_ship = {
		464539,
		89,
		true
	},
	fenjie_lantu_tip = {
		464628,
		188,
		true
	},
	msgbox_text_analyse = {
		464816,
		90,
		true
	},
	fragresolve_empty_tip = {
		464906,
		151,
		true
	},
	confirm_unlock_lv = {
		465057,
		121,
		true
	},
	shops_rest_day = {
		465178,
		98,
		true
	},
	title_limit_time = {
		465276,
		91,
		true
	},
	seven_choose_one = {
		465367,
		224,
		true
	},
	help_newyear_feast = {
		465591,
		1386,
		true
	},
	help_newyear_shrine = {
		466977,
		1243,
		true
	},
	help_newyear_stamp = {
		468220,
		238,
		true
	},
	pt_reconfirm = {
		468458,
		124,
		true
	},
	qte_game_help = {
		468582,
		340,
		true
	},
	word_equipskin_type = {
		468922,
		88,
		true
	},
	word_equipskin_all = {
		469010,
		86,
		true
	},
	word_equipskin_cannon = {
		469096,
		95,
		true
	},
	word_equipskin_tarpedo = {
		469191,
		96,
		true
	},
	word_equipskin_aircraft = {
		469287,
		96,
		true
	},
	word_equipskin_aux = {
		469383,
		86,
		true
	},
	msgbox_repair = {
		469469,
		91,
		true
	},
	msgbox_repair_l2d = {
		469560,
		95,
		true
	},
	msgbox_repair_painting = {
		469655,
		105,
		true
	},
	l2d_32xbanned_warning = {
		469760,
		174,
		true
	},
	word_no_cache = {
		469934,
		107,
		true
	},
	pile_game_notice = {
		470041,
		993,
		true
	},
	help_chunjie_stamp = {
		471034,
		677,
		true
	},
	help_chunjie_feast = {
		471711,
		670,
		true
	},
	help_chunjie_jiulou = {
		472381,
		755,
		true
	},
	special_animal1 = {
		473136,
		227,
		true
	},
	special_animal2 = {
		473363,
		287,
		true
	},
	special_animal3 = {
		473650,
		236,
		true
	},
	special_animal4 = {
		473886,
		256,
		true
	},
	special_animal5 = {
		474142,
		251,
		true
	},
	special_animal6 = {
		474393,
		272,
		true
	},
	special_animal7 = {
		474665,
		275,
		true
	},
	bulin_help = {
		474940,
		403,
		true
	},
	super_bulin = {
		475343,
		120,
		true
	},
	super_bulin_tip = {
		475463,
		110,
		true
	},
	bulin_tip1 = {
		475573,
		101,
		true
	},
	bulin_tip2 = {
		475674,
		117,
		true
	},
	bulin_tip3 = {
		475791,
		101,
		true
	},
	bulin_tip4 = {
		475892,
		108,
		true
	},
	bulin_tip5 = {
		476000,
		101,
		true
	},
	bulin_tip6 = {
		476101,
		108,
		true
	},
	bulin_tip7 = {
		476209,
		101,
		true
	},
	bulin_tip8 = {
		476310,
		126,
		true
	},
	bulin_tip9 = {
		476436,
		122,
		true
	},
	bulin_tip_other1 = {
		476558,
		192,
		true
	},
	bulin_tip_other2 = {
		476750,
		109,
		true
	},
	bulin_tip_other3 = {
		476859,
		122,
		true
	},
	monopoly_left_count = {
		476981,
		89,
		true
	},
	help_chunjie_monopoly = {
		477070,
		1083,
		true
	},
	monoply_drop_ship_step = {
		478153,
		157,
		true
	},
	lanternRiddles_wait_for_reanswer = {
		478310,
		144,
		true
	},
	lanternRiddles_answer_is_wrong = {
		478454,
		118,
		true
	},
	lanternRiddles_answer_is_right = {
		478572,
		110,
		true
	},
	lanternRiddles_gametip = {
		478682,
		607,
		true
	},
	LanternRiddle_wait_time_tip = {
		479289,
		105,
		true
	},
	LinkLinkGame_BestTime = {
		479394,
		92,
		true
	},
	LinkLinkGame_CurTime = {
		479486,
		89,
		true
	},
	sort_attribute = {
		479575,
		82,
		true
	},
	sort_intimacy = {
		479657,
		85,
		true
	},
	index_skin = {
		479742,
		82,
		true
	},
	index_reform = {
		479824,
		94,
		true
	},
	index_reform_cw = {
		479918,
		97,
		true
	},
	index_strengthen = {
		480015,
		91,
		true
	},
	index_special = {
		480106,
		84,
		true
	},
	index_propose_skin = {
		480190,
		96,
		true
	},
	index_not_obtained = {
		480286,
		92,
		true
	},
	index_no_limit = {
		480378,
		86,
		true
	},
	index_awakening = {
		480464,
		91,
		true
	},
	index_not_lvmax = {
		480555,
		90,
		true
	},
	index_spweapon = {
		480645,
		91,
		true
	},
	index_marry = {
		480736,
		81,
		true
	},
	decodegame_gametip = {
		480817,
		2081,
		true
	},
	indexsort_sort = {
		482898,
		82,
		true
	},
	indexsort_index = {
		482980,
		84,
		true
	},
	indexsort_camp = {
		483064,
		85,
		true
	},
	indexsort_type = {
		483149,
		82,
		true
	},
	indexsort_rarity = {
		483231,
		86,
		true
	},
	indexsort_extraindex = {
		483317,
		89,
		true
	},
	indexsort_label = {
		483406,
		83,
		true
	},
	indexsort_sorteng = {
		483489,
		85,
		true
	},
	indexsort_indexeng = {
		483574,
		87,
		true
	},
	indexsort_campeng = {
		483661,
		88,
		true
	},
	indexsort_rarityeng = {
		483749,
		89,
		true
	},
	indexsort_typeeng = {
		483838,
		85,
		true
	},
	indexsort_labeleng = {
		483923,
		86,
		true
	},
	fightfail_up = {
		484009,
		139,
		true
	},
	fightfail_equip = {
		484148,
		141,
		true
	},
	fight_strengthen = {
		484289,
		158,
		true
	},
	fightfail_noequip = {
		484447,
		107,
		true
	},
	fightfail_choiceequip = {
		484554,
		136,
		true
	},
	fightfail_choicestrengthen = {
		484690,
		151,
		true
	},
	sofmap_attention = {
		484841,
		258,
		true
	},
	sofmapsd_1 = {
		485099,
		153,
		true
	},
	sofmapsd_2 = {
		485252,
		132,
		true
	},
	sofmapsd_3 = {
		485384,
		110,
		true
	},
	sofmapsd_4 = {
		485494,
		133,
		true
	},
	inform_level_limit = {
		485627,
		138,
		true
	},
	["3match_tip"] = {
		485765,
		381,
		true
	},
	retire_selectzero = {
		486146,
		138,
		true
	},
	retire_marry_skin = {
		486284,
		106,
		true
	},
	undermist_tip = {
		486390,
		143,
		true
	},
	retire_1 = {
		486533,
		254,
		true
	},
	retire_2 = {
		486787,
		256,
		true
	},
	retire_3 = {
		487043,
		96,
		true
	},
	retire_rarity = {
		487139,
		97,
		true
	},
	retire_title = {
		487236,
		91,
		true
	},
	res_unlock_tip = {
		487327,
		120,
		true
	},
	res_wifi_tip = {
		487447,
		206,
		true
	},
	res_downloading = {
		487653,
		90,
		true
	},
	res_pic_new_tip = {
		487743,
		145,
		true
	},
	res_music_no_pre_tip = {
		487888,
		95,
		true
	},
	res_music_no_next_tip = {
		487983,
		95,
		true
	},
	res_music_new_tip = {
		488078,
		106,
		true
	},
	apple_link_title = {
		488184,
		101,
		true
	},
	retire_setting_help = {
		488285,
		883,
		true
	},
	activity_shop_exchange_count = {
		489168,
		98,
		true
	},
	shops_msgbox_exchange_count = {
		489266,
		107,
		true
	},
	shops_msgbox_output = {
		489373,
		92,
		true
	},
	shop_word_exchange = {
		489465,
		89,
		true
	},
	shop_word_cancel = {
		489554,
		86,
		true
	},
	title_item_ways = {
		489640,
		152,
		true
	},
	item_lack_title = {
		489792,
		152,
		true
	},
	oil_buy_tip_2 = {
		489944,
		386,
		true
	},
	target_chapter_is_lock = {
		490330,
		126,
		true
	},
	ship_book = {
		490456,
		104,
		true
	},
	month_sign_resign = {
		490560,
		87,
		true
	},
	collect_tip = {
		490647,
		139,
		true
	},
	collect_tip2 = {
		490786,
		140,
		true
	},
	word_weakness = {
		490926,
		88,
		true
	},
	special_operation_tip1 = {
		491014,
		111,
		true
	},
	special_operation_tip2 = {
		491125,
		111,
		true
	},
	area_lock = {
		491236,
		106,
		true
	},
	equipment_upgrade_equipped_tag = {
		491342,
		105,
		true
	},
	equipment_upgrade_spare_tag = {
		491447,
		102,
		true
	},
	equipment_upgrade_help = {
		491549,
		1285,
		true
	},
	equipment_upgrade_title = {
		492834,
		97,
		true
	},
	equipment_upgrade_coin_consume = {
		492931,
		98,
		true
	},
	equipment_upgrade_quick_interface_source_chosen = {
		493029,
		123,
		true
	},
	equipment_upgrade_quick_interface_materials_consume = {
		493152,
		121,
		true
	},
	equipment_upgrade_feedback_lack_of_materials = {
		493273,
		141,
		true
	},
	equipment_upgrade_feedback_equipment_consume = {
		493414,
		211,
		true
	},
	equipment_upgrade_feedback_equipment_can_be_produced = {
		493625,
		168,
		true
	},
	equipment_upgrade_quick_interface_feedback_source_chosen = {
		493793,
		133,
		true
	},
	equipment_upgrade_feedback_lack_of_equipment = {
		493926,
		127,
		true
	},
	equipment_upgrade_equipped_unavailable = {
		494053,
		211,
		true
	},
	equipment_upgrade_initial_node = {
		494264,
		134,
		true
	},
	equipment_upgrade_feedback_compose_tip = {
		494398,
		192,
		true
	},
	discount_coupon_tip = {
		494590,
		193,
		true
	},
	pizzahut_help = {
		494783,
		738,
		true
	},
	towerclimbing_gametip = {
		495521,
		645,
		true
	},
	qingdianguangchang_help = {
		496166,
		660,
		true
	},
	building_tip = {
		496826,
		177,
		true
	},
	building_upgrade_tip = {
		497003,
		155,
		true
	},
	msgbox_text_upgrade = {
		497158,
		90,
		true
	},
	towerclimbing_sign_help = {
		497248,
		793,
		true
	},
	building_complete_tip = {
		498041,
		102,
		true
	},
	backyard_theme_refresh_time_tip = {
		498143,
		124,
		true
	},
	backyard_theme_total_print = {
		498267,
		95,
		true
	},
	backyard_theme_shop_title = {
		498362,
		105,
		true
	},
	backyard_theme_mine_title = {
		498467,
		99,
		true
	},
	backyard_theme_collection_title = {
		498566,
		107,
		true
	},
	backyard_theme_ban_upload_tip = {
		498673,
		214,
		true
	},
	backyard_theme_upload_over_maxcnt = {
		498887,
		194,
		true
	},
	backyard_theme_apply_tip1 = {
		499081,
		208,
		true
	},
	backyard_theme_word_buy = {
		499289,
		90,
		true
	},
	backyard_theme_word_apply = {
		499379,
		94,
		true
	},
	backyard_theme_apply_success = {
		499473,
		105,
		true
	},
	backyard_theme_unload_success = {
		499578,
		109,
		true
	},
	backyard_theme_upload_success = {
		499687,
		101,
		true
	},
	backyard_theme_delete_success = {
		499788,
		100,
		true
	},
	backyard_theme_apply_tip2 = {
		499888,
		138,
		true
	},
	backyard_theme_upload_cnt = {
		500026,
		113,
		true
	},
	backyard_theme_upload_time = {
		500139,
		102,
		true
	},
	backyard_theme_word_like = {
		500241,
		93,
		true
	},
	backyard_theme_word_collection = {
		500334,
		103,
		true
	},
	backyard_theme_cancel_collection = {
		500437,
		138,
		true
	},
	backyard_theme_inform_them = {
		500575,
		105,
		true
	},
	open_backyard_theme_template_tip = {
		500680,
		143,
		true
	},
	backyard_theme_cancel_template_upload_tip = {
		500823,
		249,
		true
	},
	backyard_theme_delete_themplate_tip = {
		501072,
		228,
		true
	},
	backyard_theme_template_be_delete_tip = {
		501300,
		140,
		true
	},
	backyard_theme_template_collection_cnt_max = {
		501440,
		143,
		true
	},
	backyard_theme_template_collection_cnt = {
		501583,
		120,
		true
	},
	words_visit_backyard_toggle = {
		501703,
		124,
		true
	},
	words_show_friend_backyardship_toggle = {
		501827,
		154,
		true
	},
	words_show_my_backyardship_toggle = {
		501981,
		154,
		true
	},
	option_desc7 = {
		502135,
		133,
		true
	},
	option_desc8 = {
		502268,
		147,
		true
	},
	option_desc9 = {
		502415,
		174,
		true
	},
	backyard_unopen = {
		502589,
		108,
		true
	},
	backyard_shop_refresh_frequently = {
		502697,
		157,
		true
	},
	word_random = {
		502854,
		81,
		true
	},
	word_hot = {
		502935,
		75,
		true
	},
	word_new = {
		503010,
		75,
		true
	},
	backyard_decoration_theme_template_delete_tip = {
		503085,
		210,
		true
	},
	backyard_not_found_theme_template = {
		503295,
		128,
		true
	},
	backyard_apply_theme_template_erro = {
		503423,
		122,
		true
	},
	backyard_theme_template_list_is_empty = {
		503545,
		121,
		true
	},
	BackYard_collection_be_delete_tip = {
		503666,
		181,
		true
	},
	help_monopoly_car = {
		503847,
		1056,
		true
	},
	help_monopoly_car_2 = {
		504903,
		1125,
		true
	},
	help_monopoly_3th = {
		506028,
		795,
		true
	},
	backYard_missing_furnitrue_tip = {
		506823,
		114,
		true
	},
	win_condition_display_qijian = {
		506937,
		120,
		true
	},
	win_condition_display_qijian_tip = {
		507057,
		126,
		true
	},
	win_condition_display_shangchuan = {
		507183,
		151,
		true
	},
	win_condition_display_shangchuan_tip = {
		507334,
		170,
		true
	},
	win_condition_display_judian = {
		507504,
		116,
		true
	},
	win_condition_display_tuoli = {
		507620,
		126,
		true
	},
	win_condition_display_tuoli_tip = {
		507746,
		130,
		true
	},
	lose_condition_display_quanmie = {
		507876,
		123,
		true
	},
	lose_condition_display_gangqu = {
		507999,
		155,
		true
	},
	re_battle = {
		508154,
		79,
		true
	},
	keep_fate_tip = {
		508233,
		148,
		true
	},
	equip_info_1 = {
		508381,
		79,
		true
	},
	equip_info_2 = {
		508460,
		84,
		true
	},
	equip_info_3 = {
		508544,
		89,
		true
	},
	equip_info_4 = {
		508633,
		81,
		true
	},
	equip_info_5 = {
		508714,
		85,
		true
	},
	equip_info_6 = {
		508799,
		90,
		true
	},
	equip_info_7 = {
		508889,
		86,
		true
	},
	equip_info_8 = {
		508975,
		86,
		true
	},
	equip_info_9 = {
		509061,
		90,
		true
	},
	equip_info_10 = {
		509151,
		85,
		true
	},
	equip_info_11 = {
		509236,
		85,
		true
	},
	equip_info_12 = {
		509321,
		89,
		true
	},
	equip_info_13 = {
		509410,
		86,
		true
	},
	equip_info_14 = {
		509496,
		92,
		true
	},
	equip_info_15 = {
		509588,
		87,
		true
	},
	equip_info_16 = {
		509675,
		89,
		true
	},
	equip_info_17 = {
		509764,
		88,
		true
	},
	equip_info_18 = {
		509852,
		89,
		true
	},
	equip_info_19 = {
		509941,
		84,
		true
	},
	equip_info_20 = {
		510025,
		88,
		true
	},
	equip_info_21 = {
		510113,
		85,
		true
	},
	equip_info_22 = {
		510198,
		91,
		true
	},
	equip_info_23 = {
		510289,
		90,
		true
	},
	equip_info_24 = {
		510379,
		86,
		true
	},
	equip_info_25 = {
		510465,
		77,
		true
	},
	equip_info_26 = {
		510542,
		90,
		true
	},
	equip_info_27 = {
		510632,
		77,
		true
	},
	equip_info_28 = {
		510709,
		93,
		true
	},
	equip_info_29 = {
		510802,
		80,
		true
	},
	equip_info_30 = {
		510882,
		80,
		true
	},
	equip_info_31 = {
		510962,
		80,
		true
	},
	equip_info_32 = {
		511042,
		91,
		true
	},
	equip_info_33 = {
		511133,
		89,
		true
	},
	equip_info_34 = {
		511222,
		90,
		true
	},
	equip_info_extralevel_0 = {
		511312,
		94,
		true
	},
	equip_info_extralevel_1 = {
		511406,
		94,
		true
	},
	equip_info_extralevel_2 = {
		511500,
		94,
		true
	},
	equip_info_extralevel_3 = {
		511594,
		94,
		true
	},
	tec_settings_btn_word = {
		511688,
		99,
		true
	},
	tec_tendency_x = {
		511787,
		86,
		true
	},
	tec_tendency_0 = {
		511873,
		86,
		true
	},
	tec_tendency_1 = {
		511959,
		87,
		true
	},
	tec_tendency_2 = {
		512046,
		87,
		true
	},
	tec_tendency_3 = {
		512133,
		87,
		true
	},
	tec_tendency_4 = {
		512220,
		87,
		true
	},
	tec_tendency_cur_x = {
		512307,
		101,
		true
	},
	tec_tendency_cur_0 = {
		512408,
		108,
		true
	},
	tec_tendency_cur_1 = {
		512516,
		107,
		true
	},
	tec_tendency_cur_2 = {
		512623,
		107,
		true
	},
	tec_tendency_cur_3 = {
		512730,
		107,
		true
	},
	tec_target_catchup_none = {
		512837,
		117,
		true
	},
	tec_target_catchup_selected = {
		512954,
		105,
		true
	},
	tec_tendency_cur_4 = {
		513059,
		107,
		true
	},
	tec_target_catchup_none_x = {
		513166,
		108,
		true
	},
	tec_target_catchup_none_1 = {
		513274,
		107,
		true
	},
	tec_target_catchup_none_2 = {
		513381,
		107,
		true
	},
	tec_target_catchup_none_3 = {
		513488,
		107,
		true
	},
	tec_target_catchup_selected_x = {
		513595,
		108,
		true
	},
	tec_target_catchup_selected_1 = {
		513703,
		107,
		true
	},
	tec_target_catchup_selected_2 = {
		513810,
		107,
		true
	},
	tec_target_catchup_selected_3 = {
		513917,
		107,
		true
	},
	tec_target_catchup_finish_x = {
		514024,
		106,
		true
	},
	tec_target_catchup_finish_1 = {
		514130,
		105,
		true
	},
	tec_target_catchup_finish_2 = {
		514235,
		105,
		true
	},
	tec_target_catchup_finish_3 = {
		514340,
		105,
		true
	},
	tec_target_catchup_finish_4 = {
		514445,
		105,
		true
	},
	tec_target_catchup_dr_finish_tip = {
		514550,
		105,
		true
	},
	tec_target_catchup_all_finish_tip = {
		514655,
		114,
		true
	},
	tec_target_catchup_show_the_finished_version = {
		514769,
		133,
		true
	},
	tec_target_catchup_pry_char = {
		514902,
		99,
		true
	},
	tec_target_catchup_dr_char = {
		515001,
		98,
		true
	},
	tec_target_need_print = {
		515099,
		98,
		true
	},
	tec_target_catchup_progress = {
		515197,
		99,
		true
	},
	tec_target_catchup_select_tip = {
		515296,
		135,
		true
	},
	tec_target_catchup_help_tip = {
		515431,
		824,
		true
	},
	tec_speedup_title = {
		516255,
		102,
		true
	},
	tec_speedup_progress = {
		516357,
		94,
		true
	},
	tec_speedup_overflow = {
		516451,
		186,
		true
	},
	tec_speedup_help_tip = {
		516637,
		274,
		true
	},
	click_back_tip = {
		516911,
		92,
		true
	},
	tech_catchup_sentence_pauses = {
		517003,
		95,
		true
	},
	tec_act_catchup_btn_word = {
		517098,
		103,
		true
	},
	tec_catchup_errorfix = {
		517201,
		226,
		true
	},
	guild_duty_is_too_low = {
		517427,
		149,
		true
	},
	guild_trainee_duty_change_tip = {
		517576,
		144,
		true
	},
	guild_not_exist_donate_task = {
		517720,
		121,
		true
	},
	guild_week_task_state_is_wrong = {
		517841,
		131,
		true
	},
	guild_get_week_done = {
		517972,
		127,
		true
	},
	guild_public_awards = {
		518099,
		97,
		true
	},
	guild_private_awards = {
		518196,
		99,
		true
	},
	guild_task_selecte_tip = {
		518295,
		276,
		true
	},
	guild_task_accept = {
		518571,
		374,
		true
	},
	guild_commander_and_sub_op = {
		518945,
		152,
		true
	},
	["guild_donate_times_not enough"] = {
		519097,
		144,
		true
	},
	guild_donate_success = {
		519241,
		108,
		true
	},
	guild_left_donate_cnt = {
		519349,
		118,
		true
	},
	guild_donate_tip = {
		519467,
		228,
		true
	},
	guild_donate_addition_capital_tip = {
		519695,
		125,
		true
	},
	guild_donate_addition_techpoint_tip = {
		519820,
		141,
		true
	},
	guild_donate_capital_toplimit = {
		519961,
		151,
		true
	},
	guild_donate_techpoint_toplimit = {
		520112,
		153,
		true
	},
	guild_supply_no_open = {
		520265,
		121,
		true
	},
	guild_supply_award_got = {
		520386,
		119,
		true
	},
	guild_new_member_get_award_tip = {
		520505,
		181,
		true
	},
	guild_start_supply_consume_tip = {
		520686,
		143,
		true
	},
	guild_left_supply_day = {
		520829,
		99,
		true
	},
	guild_supply_help_tip = {
		520928,
		731,
		true
	},
	guild_op_only_administrator = {
		521659,
		153,
		true
	},
	guild_shop_refresh_done = {
		521812,
		102,
		true
	},
	guild_shop_cnt_no_enough = {
		521914,
		113,
		true
	},
	guild_shop_refresh_all_tip = {
		522027,
		205,
		true
	},
	guild_shop_exchange_tip = {
		522232,
		128,
		true
	},
	guild_shop_label_1 = {
		522360,
		115,
		true
	},
	guild_shop_label_2 = {
		522475,
		87,
		true
	},
	guild_shop_label_3 = {
		522562,
		89,
		true
	},
	guild_shop_label_4 = {
		522651,
		86,
		true
	},
	guild_shop_label_5 = {
		522737,
		119,
		true
	},
	guild_shop_must_select_goods = {
		522856,
		125,
		true
	},
	guild_not_exist_activation_tech = {
		522981,
		143,
		true
	},
	guild_not_exist_tech = {
		523124,
		119,
		true
	},
	guild_cancel_only_once_pre_day = {
		523243,
		144,
		true
	},
	guild_tech_is_max_level = {
		523387,
		132,
		true
	},
	guild_tech_gold_no_enough = {
		523519,
		141,
		true
	},
	guild_tech_guildgold_no_enough = {
		523660,
		153,
		true
	},
	guild_tech_upgrade_done = {
		523813,
		118,
		true
	},
	guild_exist_activation_tech = {
		523931,
		136,
		true
	},
	guild_tech_gold_desc = {
		524067,
		105,
		true
	},
	guild_tech_oil_desc = {
		524172,
		102,
		true
	},
	guild_tech_shipbag_desc = {
		524274,
		101,
		true
	},
	guild_tech_equipbag_desc = {
		524375,
		107,
		true
	},
	guild_box_gold_desc = {
		524482,
		99,
		true
	},
	guidl_r_box_time_desc = {
		524581,
		115,
		true
	},
	guidl_sr_box_time_desc = {
		524696,
		117,
		true
	},
	guidl_ssr_box_time_desc = {
		524813,
		123,
		true
	},
	guild_member_max_cnt_desc = {
		524936,
		110,
		true
	},
	guild_tech_livness_no_enough = {
		525046,
		271,
		true
	},
	guild_tech_livness_no_enough_label = {
		525317,
		126,
		true
	},
	guild_ship_attr_desc = {
		525443,
		133,
		true
	},
	guild_start_tech_group_tip = {
		525576,
		164,
		true
	},
	guild_cancel_tech_tip = {
		525740,
		182,
		true
	},
	guild_tech_consume_tip = {
		525922,
		219,
		true
	},
	guild_tech_non_admin = {
		526141,
		146,
		true
	},
	guild_tech_label_max_level = {
		526287,
		100,
		true
	},
	guild_tech_label_dev_progress = {
		526387,
		102,
		true
	},
	guild_tech_label_condition = {
		526489,
		131,
		true
	},
	guild_tech_donate_target = {
		526620,
		122,
		true
	},
	guild_not_exist = {
		526742,
		105,
		true
	},
	guild_not_exist_battle = {
		526847,
		126,
		true
	},
	guild_battle_is_end = {
		526973,
		121,
		true
	},
	guild_battle_is_exist = {
		527094,
		126,
		true
	},
	guild_guildgold_no_enough_for_battle = {
		527220,
		164,
		true
	},
	guild_event_start_tip1 = {
		527384,
		167,
		true
	},
	guild_event_start_tip2 = {
		527551,
		168,
		true
	},
	guild_word_may_happen_event = {
		527719,
		106,
		true
	},
	guild_battle_award = {
		527825,
		90,
		true
	},
	guild_word_consume = {
		527915,
		87,
		true
	},
	guild_start_event_consume_tip = {
		528002,
		149,
		true
	},
	guild_start_event_consume_tip_extra = {
		528151,
		222,
		true
	},
	guild_word_consume_for_battle = {
		528373,
		99,
		true
	},
	guild_level_no_enough = {
		528472,
		159,
		true
	},
	guild_open_event_info_when_exist_active = {
		528631,
		170,
		true
	},
	guild_join_event_cnt_label = {
		528801,
		117,
		true
	},
	guild_join_event_max_cnt_tip = {
		528918,
		124,
		true
	},
	guild_join_event_progress_label = {
		529042,
		104,
		true
	},
	guild_join_event_exist_finished_mission_tip = {
		529146,
		277,
		true
	},
	guild_event_not_exist = {
		529423,
		119,
		true
	},
	guild_fleet_can_not_edit = {
		529542,
		131,
		true
	},
	guild_fleet_exist_same_kind_ship = {
		529673,
		151,
		true
	},
	guild_event_exist_same_kind_ship = {
		529824,
		171,
		true
	},
	guidl_event_ship_in_event = {
		529995,
		150,
		true
	},
	guild_event_start_done = {
		530145,
		110,
		true
	},
	guild_fleet_update_done = {
		530255,
		122,
		true
	},
	guild_event_is_lock = {
		530377,
		115,
		true
	},
	guild_event_is_finish = {
		530492,
		161,
		true
	},
	guild_fleet_not_save_tip = {
		530653,
		161,
		true
	},
	guild_word_battle_area = {
		530814,
		91,
		true
	},
	guild_word_battle_type = {
		530905,
		91,
		true
	},
	guild_wrod_battle_target = {
		530996,
		99,
		true
	},
	guild_event_recomm_ship_failed = {
		531095,
		139,
		true
	},
	guild_event_start_event_tip = {
		531234,
		208,
		true
	},
	guild_word_sea = {
		531442,
		83,
		true
	},
	guild_word_score_addition = {
		531525,
		106,
		true
	},
	guild_word_effect_addition = {
		531631,
		111,
		true
	},
	guild_curr_fleet_can_not_edit = {
		531742,
		127,
		true
	},
	guild_next_edit_fleet_time = {
		531869,
		125,
		true
	},
	guild_event_info_desc1 = {
		531994,
		197,
		true
	},
	guild_event_info_desc2 = {
		532191,
		128,
		true
	},
	guild_join_member_cnt = {
		532319,
		97,
		true
	},
	guild_total_effect = {
		532416,
		99,
		true
	},
	guild_word_people = {
		532515,
		81,
		true
	},
	guild_event_info_desc3 = {
		532596,
		104,
		true
	},
	guild_not_exist_boss = {
		532700,
		112,
		true
	},
	guild_ship_from = {
		532812,
		84,
		true
	},
	guild_boss_formation_1 = {
		532896,
		160,
		true
	},
	guild_boss_formation_2 = {
		533056,
		146,
		true
	},
	guild_boss_formation_3 = {
		533202,
		123,
		true
	},
	guild_boss_cnt_no_enough = {
		533325,
		131,
		true
	},
	guild_boss_fleet_cnt_invaild = {
		533456,
		137,
		true
	},
	guild_boss_formation_not_exist_self_ship = {
		533593,
		190,
		true
	},
	guild_boss_formation_exist_event_ship = {
		533783,
		161,
		true
	},
	guild_fleet_is_legal = {
		533944,
		157,
		true
	},
	guild_battle_result_boss_is_death = {
		534101,
		134,
		true
	},
	guild_must_edit_fleet = {
		534235,
		112,
		true
	},
	guild_ship_in_battle = {
		534347,
		163,
		true
	},
	guild_ship_in_assult_fleet = {
		534510,
		134,
		true
	},
	guild_event_exist_assult_ship = {
		534644,
		157,
		true
	},
	guild_formation_erro_in_boss_battle = {
		534801,
		168,
		true
	},
	guild_get_report_failed = {
		534969,
		121,
		true
	},
	guild_report_get_all = {
		535090,
		93,
		true
	},
	guild_can_not_get_tip = {
		535183,
		158,
		true
	},
	guild_not_exist_notifycation = {
		535341,
		146,
		true
	},
	guild_exist_report_award_when_exit = {
		535487,
		172,
		true
	},
	guild_report_tooltip = {
		535659,
		243,
		true
	},
	word_guildgold = {
		535902,
		90,
		true
	},
	guild_member_rank_title_donate = {
		535992,
		107,
		true
	},
	guild_member_rank_title_finish_cnt = {
		536099,
		109,
		true
	},
	guild_member_rank_title_join_cnt = {
		536208,
		110,
		true
	},
	guild_donate_log = {
		536318,
		165,
		true
	},
	guild_supply_log = {
		536483,
		148,
		true
	},
	guild_weektask_log = {
		536631,
		148,
		true
	},
	guild_battle_log = {
		536779,
		137,
		true
	},
	guild_tech_change_log = {
		536916,
		136,
		true
	},
	guild_log_title = {
		537052,
		88,
		true
	},
	guild_use_donateitem_success = {
		537140,
		131,
		true
	},
	guild_use_battleitem_success = {
		537271,
		140,
		true
	},
	not_exist_guild_use_item = {
		537411,
		141,
		true
	},
	guild_member_tip = {
		537552,
		2773,
		true
	},
	guild_tech_tip = {
		540325,
		2740,
		true
	},
	guild_office_tip = {
		543065,
		2650,
		true
	},
	guild_event_help_tip = {
		545715,
		2687,
		true
	},
	guild_mission_info_tip = {
		548402,
		1109,
		true
	},
	guild_public_tech_tip = {
		549511,
		660,
		true
	},
	guild_public_office_tip = {
		550171,
		325,
		true
	},
	guild_tech_price_inc_tip = {
		550496,
		258,
		true
	},
	guild_boss_fleet_desc = {
		550754,
		523,
		true
	},
	guild_boss_formation_exist_invaild_ship = {
		551277,
		197,
		true
	},
	guild_exist_unreceived_supply_award = {
		551474,
		127,
		true
	},
	word_shipState_guild_event = {
		551601,
		159,
		true
	},
	word_shipState_guild_boss = {
		551760,
		193,
		true
	},
	commander_is_in_guild = {
		551953,
		195,
		true
	},
	guild_assult_ship_recommend = {
		552148,
		134,
		true
	},
	guild_cancel_assult_ship_recommend = {
		552282,
		132,
		true
	},
	guild_assult_ship_recommend_conflict = {
		552414,
		147,
		true
	},
	guild_recommend_limit = {
		552561,
		143,
		true
	},
	guild_cancel_assult_ship_recommend_conflict = {
		552704,
		169,
		true
	},
	guild_mission_complate = {
		552873,
		110,
		true
	},
	guild_operation_event_occurrence = {
		552983,
		172,
		true
	},
	guild_transfer_president_confirm = {
		553155,
		236,
		true
	},
	guild_damage_ranking = {
		553391,
		88,
		true
	},
	guild_total_damage = {
		553479,
		88,
		true
	},
	guild_donate_list_updated = {
		553567,
		142,
		true
	},
	guild_donate_list_update_failed = {
		553709,
		146,
		true
	},
	guild_tip_quit_operation = {
		553855,
		239,
		true
	},
	guild_tip_grand_fleet_is_frozen = {
		554094,
		144,
		true
	},
	guild_tip_operation_time_is_not_ample = {
		554238,
		355,
		true
	},
	guild_time_remaining_tip = {
		554593,
		104,
		true
	},
	multiple_ship_energy_low_desc = {
		554697,
		142,
		true
	},
	multiple_ship_energy_low_warn = {
		554839,
		142,
		true
	},
	multiple_ship_energy_low_warn_no_exp = {
		554981,
		282,
		true
	},
	us_error_download_painting = {
		555263,
		243,
		true
	},
	help_rollingBallGame = {
		555506,
		1116,
		true
	},
	rolling_ball_help = {
		556622,
		896,
		true
	},
	help_jiujiu_expedition_game = {
		557518,
		723,
		true
	},
	jiujiu_expedition_game_stg_desc = {
		558241,
		125,
		true
	},
	build_ship_accumulative = {
		558366,
		94,
		true
	},
	destory_ship_before_tip = {
		558460,
		98,
		true
	},
	destory_ship_input_erro = {
		558558,
		127,
		true
	},
	mail_input_erro = {
		558685,
		122,
		true
	},
	destroy_ur_rarity_tip = {
		558807,
		225,
		true
	},
	destory_ur_pt_overflowa = {
		559032,
		283,
		true
	},
	jiujiu_expedition_help = {
		559315,
		514,
		true
	},
	shop_label_unlimt_cnt = {
		559829,
		94,
		true
	},
	jiujiu_expedition_book_tip = {
		559923,
		142,
		true
	},
	jiujiu_expedition_reward_tip = {
		560065,
		140,
		true
	},
	jiujiu_expedition_amount_tip = {
		560205,
		172,
		true
	},
	jiujiu_expedition_stg_tip = {
		560377,
		133,
		true
	},
	trade_card_tips1 = {
		560510,
		85,
		true
	},
	trade_card_tips2 = {
		560595,
		273,
		true
	},
	trade_card_tips3 = {
		560868,
		278,
		true
	},
	trade_card_tips4 = {
		561146,
		93,
		true
	},
	ur_exchange_help_tip = {
		561239,
		967,
		true
	},
	fleet_antisub_range = {
		562206,
		95,
		true
	},
	fleet_antisub_range_tip = {
		562301,
		1085,
		true
	},
	practise_idol_tip = {
		563386,
		120,
		true
	},
	practise_idol_help = {
		563506,
		937,
		true
	},
	upgrade_idol_tip = {
		564443,
		153,
		true
	},
	upgrade_complete_tip = {
		564596,
		104,
		true
	},
	upgrade_introduce_tip = {
		564700,
		135,
		true
	},
	collect_idol_tip = {
		564835,
		158,
		true
	},
	hand_account_tip = {
		564993,
		125,
		true
	},
	hand_account_resetting_tip = {
		565118,
		133,
		true
	},
	help_candymagic = {
		565251,
		1060,
		true
	},
	award_overflow_tip = {
		566311,
		172,
		true
	},
	hunter_npc = {
		566483,
		1368,
		true
	},
	venusvolleyball_help = {
		567851,
		1402,
		true
	},
	venusvolleyball_rule_tip = {
		569253,
		109,
		true
	},
	venusvolleyball_return_tip = {
		569362,
		125,
		true
	},
	venusvolleyball_suspend_tip = {
		569487,
		109,
		true
	},
	doa_main = {
		569596,
		1461,
		true
	},
	doa_pt_help = {
		571057,
		841,
		true
	},
	doa_pt_complete = {
		571898,
		96,
		true
	},
	doa_pt_up = {
		571994,
		110,
		true
	},
	doa_liliang = {
		572104,
		78,
		true
	},
	doa_jiqiao = {
		572182,
		77,
		true
	},
	doa_tili = {
		572259,
		75,
		true
	},
	doa_meili = {
		572334,
		76,
		true
	},
	snowball_help = {
		572410,
		1745,
		true
	},
	help_xinnian2021_feast = {
		574155,
		533,
		true
	},
	help_xinnian2021__qiaozhong = {
		574688,
		1318,
		true
	},
	help_xinnian2021__meishiyemian = {
		576006,
		703,
		true
	},
	help_xinnian2021__meishi = {
		576709,
		1290,
		true
	},
	help_act_event = {
		577999,
		286,
		true
	},
	autofight = {
		578285,
		84,
		true
	},
	autofight_errors_tip = {
		578369,
		142,
		true
	},
	autofight_special_operation_tip = {
		578511,
		322,
		true
	},
	autofight_formation = {
		578833,
		92,
		true
	},
	autofight_cat = {
		578925,
		87,
		true
	},
	autofight_function = {
		579012,
		86,
		true
	},
	autofight_function1 = {
		579098,
		90,
		true
	},
	autofight_function2 = {
		579188,
		92,
		true
	},
	autofight_function3 = {
		579280,
		94,
		true
	},
	autofight_function4 = {
		579374,
		90,
		true
	},
	autofight_function5 = {
		579464,
		98,
		true
	},
	autofight_rewards = {
		579562,
		94,
		true
	},
	autofight_rewards_none = {
		579656,
		104,
		true
	},
	autofight_leave = {
		579760,
		83,
		true
	},
	autofight_onceagain = {
		579843,
		91,
		true
	},
	autofight_entrust = {
		579934,
		109,
		true
	},
	autofight_task = {
		580043,
		99,
		true
	},
	autofight_effect = {
		580142,
		146,
		true
	},
	autofight_file = {
		580288,
		97,
		true
	},
	autofight_discovery = {
		580385,
		112,
		true
	},
	autofight_tip_bigworld_dead = {
		580497,
		155,
		true
	},
	autofight_tip_bigworld_begin = {
		580652,
		137,
		true
	},
	autofight_tip_bigworld_stop = {
		580789,
		137,
		true
	},
	autofight_tip_bigworld_suspend = {
		580926,
		179,
		true
	},
	autofight_tip_bigworld_loop = {
		581105,
		151,
		true
	},
	autofight_farm = {
		581256,
		91,
		true
	},
	autofight_story = {
		581347,
		117,
		true
	},
	fushun_adventure_help = {
		581464,
		1320,
		true
	},
	autofight_change_tip = {
		582784,
		175,
		true
	},
	autofight_selectprops_tip = {
		582959,
		97,
		true
	},
	help_chunjie2021_feast = {
		583056,
		748,
		true
	},
	valentinesday__txt1_tip = {
		583804,
		174,
		true
	},
	valentinesday__txt2_tip = {
		583978,
		136,
		true
	},
	valentinesday__txt3_tip = {
		584114,
		141,
		true
	},
	valentinesday__txt4_tip = {
		584255,
		148,
		true
	},
	valentinesday__txt5_tip = {
		584403,
		140,
		true
	},
	valentinesday__txt6_tip = {
		584543,
		146,
		true
	},
	valentinesday__shop_tip = {
		584689,
		128,
		true
	},
	wwf_bamboo_tip1 = {
		584817,
		104,
		true
	},
	wwf_bamboo_tip2 = {
		584921,
		103,
		true
	},
	wwf_bamboo_tip3 = {
		585024,
		135,
		true
	},
	wwf_bamboo_help = {
		585159,
		1066,
		true
	},
	wwf_guide_tip = {
		586225,
		113,
		true
	},
	securitycake_help = {
		586338,
		2143,
		true
	},
	icecream_help = {
		588481,
		737,
		true
	},
	icecream_make_tip = {
		589218,
		98,
		true
	},
	query_role = {
		589316,
		86,
		true
	},
	query_role_none = {
		589402,
		87,
		true
	},
	query_role_button = {
		589489,
		94,
		true
	},
	query_role_fail = {
		589583,
		93,
		true
	},
	query_role_fail_and_retry = {
		589676,
		147,
		true
	},
	cumulative_victory_target_tip = {
		589823,
		109,
		true
	},
	cumulative_victory_now_tip = {
		589932,
		108,
		true
	},
	word_files_repair = {
		590040,
		95,
		true
	},
	repair_setting_label = {
		590135,
		98,
		true
	},
	voice_control = {
		590233,
		83,
		true
	},
	index_equip = {
		590316,
		84,
		true
	},
	index_without_limit = {
		590400,
		91,
		true
	},
	meta_learn_skill = {
		590491,
		92,
		true
	},
	world_joint_boss_not_found = {
		590583,
		148,
		true
	},
	world_joint_boss_is_death = {
		590731,
		143,
		true
	},
	world_joint_whitout_guild = {
		590874,
		123,
		true
	},
	world_joint_whitout_friend = {
		590997,
		126,
		true
	},
	world_joint_call_support_failed = {
		591123,
		126,
		true
	},
	world_joint_call_support_success = {
		591249,
		131,
		true
	},
	world_joint_call_friend_support_txt = {
		591380,
		111,
		true
	},
	world_joint_call_guild_support_txt = {
		591491,
		110,
		true
	},
	world_joint_call_world_support_txt = {
		591601,
		110,
		true
	},
	ad_4 = {
		591711,
		228,
		true
	},
	world_word_expired = {
		591939,
		94,
		true
	},
	world_word_guild_member = {
		592033,
		99,
		true
	},
	world_word_guild_player = {
		592132,
		93,
		true
	},
	world_joint_boss_award_expired = {
		592225,
		106,
		true
	},
	world_joint_not_refresh_frequently = {
		592331,
		122,
		true
	},
	world_joint_exit_battle_tip = {
		592453,
		151,
		true
	},
	world_boss_get_item = {
		592604,
		215,
		true
	},
	world_boss_ask_help = {
		592819,
		134,
		true
	},
	world_joint_count_no_enough = {
		592953,
		135,
		true
	},
	world_boss_none = {
		593088,
		133,
		true
	},
	world_boss_fleet = {
		593221,
		100,
		true
	},
	world_max_challenge_cnt = {
		593321,
		144,
		true
	},
	world_reset_success = {
		593465,
		124,
		true
	},
	world_map_dangerous_confirm = {
		593589,
		230,
		true
	},
	world_map_version = {
		593819,
		140,
		true
	},
	world_resource_fill = {
		593959,
		130,
		true
	},
	meta_sys_lock_tip = {
		594089,
		93,
		true
	},
	meta_story_lock = {
		594182,
		91,
		true
	},
	meta_acttime_limit = {
		594273,
		90,
		true
	},
	meta_pt_left = {
		594363,
		88,
		true
	},
	meta_syn_rate = {
		594451,
		86,
		true
	},
	meta_repair_rate = {
		594537,
		99,
		true
	},
	meta_story_tip_1 = {
		594636,
		92,
		true
	},
	meta_story_tip_2 = {
		594728,
		92,
		true
	},
	meta_pt_get_way = {
		594820,
		91,
		true
	},
	meta_pt_point = {
		594911,
		84,
		true
	},
	meta_award_get = {
		594995,
		85,
		true
	},
	meta_award_got = {
		595080,
		85,
		true
	},
	meta_repair = {
		595165,
		89,
		true
	},
	meta_repair_success = {
		595254,
		117,
		true
	},
	meta_repair_effect_unlock = {
		595371,
		125,
		true
	},
	meta_repair_effect_special = {
		595496,
		122,
		true
	},
	meta_energy_ship_level_need = {
		595618,
		115,
		true
	},
	meta_energy_ship_repairrate_need = {
		595733,
		125,
		true
	},
	meta_energy_active_box_tip = {
		595858,
		192,
		true
	},
	meta_break = {
		596050,
		127,
		true
	},
	meta_energy_preview_title = {
		596177,
		123,
		true
	},
	meta_energy_preview_tip = {
		596300,
		138,
		true
	},
	meta_exp_per_day = {
		596438,
		90,
		true
	},
	meta_skill_unlock = {
		596528,
		108,
		true
	},
	meta_unlock_skill_tip = {
		596636,
		160,
		true
	},
	meta_unlock_skill_select = {
		596796,
		100,
		true
	},
	meta_switch_skill_disable = {
		596896,
		138,
		true
	},
	meta_switch_skill_box_title = {
		597034,
		128,
		true
	},
	meta_cur_pt = {
		597162,
		87,
		true
	},
	meta_toast_fullexp = {
		597249,
		115,
		true
	},
	meta_toast_tactics = {
		597364,
		95,
		true
	},
	meta_skillbtn_tactics = {
		597459,
		93,
		true
	},
	meta_destroy_tip = {
		597552,
		110,
		true
	},
	meta_voice_name_feeling1 = {
		597662,
		96,
		true
	},
	meta_voice_name_feeling2 = {
		597758,
		96,
		true
	},
	meta_voice_name_feeling3 = {
		597854,
		94,
		true
	},
	meta_voice_name_feeling4 = {
		597948,
		94,
		true
	},
	meta_voice_name_feeling5 = {
		598042,
		92,
		true
	},
	meta_voice_name_propose = {
		598134,
		91,
		true
	},
	world_boss_ad = {
		598225,
		89,
		true
	},
	world_boss_drop_title = {
		598314,
		97,
		true
	},
	world_boss_pt_recove_desc = {
		598411,
		151,
		true
	},
	world_boss_progress_item_desc = {
		598562,
		462,
		true
	},
	world_joint_max_challenge_people_cnt = {
		599024,
		130,
		true
	},
	equip_ammo_type_1 = {
		599154,
		83,
		true
	},
	equip_ammo_type_2 = {
		599237,
		83,
		true
	},
	equip_ammo_type_3 = {
		599320,
		88,
		true
	},
	equip_ammo_type_4 = {
		599408,
		90,
		true
	},
	equip_ammo_type_5 = {
		599498,
		88,
		true
	},
	equip_ammo_type_6 = {
		599586,
		88,
		true
	},
	equip_ammo_type_7 = {
		599674,
		84,
		true
	},
	equip_ammo_type_8 = {
		599758,
		92,
		true
	},
	equip_ammo_type_9 = {
		599850,
		88,
		true
	},
	equip_ammo_type_10 = {
		599938,
		87,
		true
	},
	equip_ammo_type_11 = {
		600025,
		89,
		true
	},
	common_daily_limit = {
		600114,
		94,
		true
	},
	meta_help = {
		600208,
		2376,
		true
	},
	world_boss_daily_limit = {
		602584,
		118,
		true
	},
	common_go_to_analyze = {
		602702,
		92,
		true
	},
	world_boss_not_reach_target = {
		602794,
		122,
		true
	},
	special_transform_limit_reach = {
		602916,
		145,
		true
	},
	meta_pt_notenough = {
		603061,
		175,
		true
	},
	meta_boss_unlock = {
		603236,
		210,
		true
	},
	word_take_effect = {
		603446,
		91,
		true
	},
	world_boss_challenge_cnt = {
		603537,
		100,
		true
	},
	word_shipNation_meta = {
		603637,
		87,
		true
	},
	world_word_friend = {
		603724,
		89,
		true
	},
	world_word_world = {
		603813,
		86,
		true
	},
	world_word_guild = {
		603899,
		85,
		true
	},
	world_collection_1 = {
		603984,
		91,
		true
	},
	world_collection_2 = {
		604075,
		91,
		true
	},
	world_collection_3 = {
		604166,
		91,
		true
	},
	zero_hour_command_error = {
		604257,
		150,
		true
	},
	commander_is_in_bigworld = {
		604407,
		142,
		true
	},
	world_collection_back = {
		604549,
		99,
		true
	},
	archives_whether_to_retreat = {
		604648,
		199,
		true
	},
	world_fleet_stop = {
		604847,
		111,
		true
	},
	world_setting_title = {
		604958,
		108,
		true
	},
	world_setting_quickmode = {
		605066,
		106,
		true
	},
	world_setting_quickmodetip = {
		605172,
		134,
		true
	},
	world_setting_submititem = {
		605306,
		121,
		true
	},
	world_setting_submititemtip = {
		605427,
		332,
		true
	},
	world_setting_mapauto = {
		605759,
		122,
		true
	},
	world_setting_mapautotip = {
		605881,
		171,
		true
	},
	world_boss_maintenance = {
		606052,
		167,
		true
	},
	world_boss_inbattle = {
		606219,
		147,
		true
	},
	world_automode_title_1 = {
		606366,
		103,
		true
	},
	world_automode_title_2 = {
		606469,
		86,
		true
	},
	world_automode_treasure_1 = {
		606555,
		137,
		true
	},
	world_automode_treasure_2 = {
		606692,
		132,
		true
	},
	world_automode_treasure_3 = {
		606824,
		136,
		true
	},
	world_automode_cancel = {
		606960,
		91,
		true
	},
	world_automode_confirm = {
		607051,
		93,
		true
	},
	world_automode_start_tip1 = {
		607144,
		122,
		true
	},
	world_automode_start_tip2 = {
		607266,
		105,
		true
	},
	world_automode_start_tip3 = {
		607371,
		124,
		true
	},
	world_automode_start_tip4 = {
		607495,
		115,
		true
	},
	world_automode_start_tip5 = {
		607610,
		164,
		true
	},
	world_automode_setting_1 = {
		607774,
		119,
		true
	},
	world_automode_setting_1_1 = {
		607893,
		101,
		true
	},
	world_automode_setting_1_2 = {
		607994,
		91,
		true
	},
	world_automode_setting_1_3 = {
		608085,
		91,
		true
	},
	world_automode_setting_1_4 = {
		608176,
		99,
		true
	},
	world_automode_setting_2 = {
		608275,
		137,
		true
	},
	world_automode_setting_2_1 = {
		608412,
		106,
		true
	},
	world_automode_setting_2_2 = {
		608518,
		109,
		true
	},
	world_automode_setting_all_1 = {
		608627,
		135,
		true
	},
	world_automode_setting_all_1_1 = {
		608762,
		115,
		true
	},
	world_automode_setting_all_1_2 = {
		608877,
		119,
		true
	},
	world_automode_setting_all_2 = {
		608996,
		139,
		true
	},
	world_automode_setting_all_2_1 = {
		609135,
		99,
		true
	},
	world_automode_setting_all_2_2 = {
		609234,
		115,
		true
	},
	world_automode_setting_all_2_3 = {
		609349,
		115,
		true
	},
	world_automode_setting_all_3 = {
		609464,
		121,
		true
	},
	world_automode_setting_all_3_1 = {
		609585,
		96,
		true
	},
	world_automode_setting_all_3_2 = {
		609681,
		97,
		true
	},
	world_automode_setting_all_4 = {
		609778,
		135,
		true
	},
	world_automode_setting_all_4_1 = {
		609913,
		97,
		true
	},
	world_automode_setting_all_4_2 = {
		610010,
		96,
		true
	},
	world_automode_setting_new_1 = {
		610106,
		122,
		true
	},
	world_automode_setting_new_1_1 = {
		610228,
		105,
		true
	},
	world_automode_setting_new_1_2 = {
		610333,
		95,
		true
	},
	world_automode_setting_new_1_3 = {
		610428,
		95,
		true
	},
	world_automode_setting_new_1_4 = {
		610523,
		95,
		true
	},
	world_automode_setting_new_1_5 = {
		610618,
		97,
		true
	},
	world_collection_task_tip_1 = {
		610715,
		147,
		true
	},
	area_putong = {
		610862,
		85,
		true
	},
	area_anquan = {
		610947,
		82,
		true
	},
	area_yaosai = {
		611029,
		85,
		true
	},
	area_yaosai_2 = {
		611114,
		96,
		true
	},
	area_shenyuan = {
		611210,
		84,
		true
	},
	area_yinmi = {
		611294,
		80,
		true
	},
	area_renwu = {
		611374,
		81,
		true
	},
	area_zhuxian = {
		611455,
		84,
		true
	},
	area_dangan = {
		611539,
		85,
		true
	},
	charge_trade_no_error = {
		611624,
		122,
		true
	},
	world_reset_1 = {
		611746,
		136,
		true
	},
	world_reset_2 = {
		611882,
		138,
		true
	},
	world_reset_3 = {
		612020,
		111,
		true
	},
	guild_is_frozen_when_start_tech = {
		612131,
		126,
		true
	},
	world_boss_unactivated = {
		612257,
		155,
		true
	},
	world_reset_tip = {
		612412,
		2719,
		true
	},
	spring_invited_2021 = {
		615131,
		231,
		true
	},
	charge_error_count_limit = {
		615362,
		128,
		true
	},
	charge_error_disable = {
		615490,
		144,
		true
	},
	levelScene_select_sp = {
		615634,
		138,
		true
	},
	word_adjustFleet = {
		615772,
		86,
		true
	},
	levelScene_select_noitem = {
		615858,
		112,
		true
	},
	story_setting_label = {
		615970,
		105,
		true
	},
	login_arrears_tips = {
		616075,
		208,
		true
	},
	Supplement_pay1 = {
		616283,
		211,
		true
	},
	Supplement_pay2 = {
		616494,
		231,
		true
	},
	Supplement_pay3 = {
		616725,
		209,
		true
	},
	Supplement_pay4 = {
		616934,
		86,
		true
	},
	world_ship_repair = {
		617020,
		102,
		true
	},
	Supplement_pay5 = {
		617122,
		185,
		true
	},
	area_unkown = {
		617307,
		89,
		true
	},
	Supplement_pay6 = {
		617396,
		89,
		true
	},
	Supplement_pay7 = {
		617485,
		88,
		true
	},
	Supplement_pay8 = {
		617573,
		86,
		true
	},
	world_battle_damage = {
		617659,
		217,
		true
	},
	setting_story_speed_1 = {
		617876,
		89,
		true
	},
	setting_story_speed_2 = {
		617965,
		91,
		true
	},
	setting_story_speed_3 = {
		618056,
		89,
		true
	},
	setting_story_speed_4 = {
		618145,
		94,
		true
	},
	story_autoplay_setting_label = {
		618239,
		106,
		true
	},
	story_autoplay_setting_1 = {
		618345,
		92,
		true
	},
	story_autoplay_setting_2 = {
		618437,
		95,
		true
	},
	meta_shop_exchange_limit = {
		618532,
		98,
		true
	},
	meta_shop_unexchange_label = {
		618630,
		90,
		true
	},
	daily_level_quick_battle_label2 = {
		618720,
		101,
		true
	},
	daily_level_quick_battle_label1 = {
		618821,
		109,
		true
	},
	dailyLevel_quickfinish = {
		618930,
		329,
		true
	},
	daily_level_quick_battle_label3 = {
		619259,
		108,
		true
	},
	backyard_longpress_ship_tip = {
		619367,
		160,
		true
	},
	common_npc_formation_tip = {
		619527,
		126,
		true
	},
	gametip_xiaotiancheng = {
		619653,
		1319,
		true
	},
	guild_task_autoaccept_1 = {
		620972,
		128,
		true
	},
	guild_task_autoaccept_2 = {
		621100,
		135,
		true
	},
	task_lock = {
		621235,
		93,
		true
	},
	week_task_pt_name = {
		621328,
		96,
		true
	},
	week_task_award_preview_label = {
		621424,
		100,
		true
	},
	week_task_title_label = {
		621524,
		108,
		true
	},
	cattery_op_clean_success = {
		621632,
		122,
		true
	},
	cattery_op_feed_success = {
		621754,
		114,
		true
	},
	cattery_op_play_success = {
		621868,
		122,
		true
	},
	cattery_style_change_success = {
		621990,
		130,
		true
	},
	cattery_add_commander_success = {
		622120,
		110,
		true
	},
	cattery_remove_commander_success = {
		622230,
		115,
		true
	},
	commander_box_quickly_tool_tip_1 = {
		622345,
		152,
		true
	},
	commander_box_quickly_tool_tip_2 = {
		622497,
		147,
		true
	},
	commander_box_quickly_tool_tip_3 = {
		622644,
		123,
		true
	},
	commander_box_was_finished = {
		622767,
		119,
		true
	},
	comander_tool_cnt_is_reclac = {
		622886,
		151,
		true
	},
	comander_tool_max_cnt = {
		623037,
		93,
		true
	},
	commander_op_play_level = {
		623130,
		101,
		true
	},
	commander_op_feed_level = {
		623231,
		101,
		true
	},
	cat_home_help = {
		623332,
		1398,
		true
	},
	cat_accelfrate_notenough = {
		624730,
		136,
		true
	},
	cat_home_unlock = {
		624866,
		131,
		true
	},
	cat_sleep_notplay = {
		624997,
		140,
		true
	},
	cathome_style_unlock = {
		625137,
		142,
		true
	},
	commander_is_in_cattery = {
		625279,
		122,
		true
	},
	cat_home_interaction = {
		625401,
		133,
		true
	},
	cat_accelerate_left = {
		625534,
		96,
		true
	},
	common_clean = {
		625630,
		81,
		true
	},
	common_feed = {
		625711,
		79,
		true
	},
	common_play = {
		625790,
		79,
		true
	},
	game_stopwords = {
		625869,
		107,
		true
	},
	game_openwords = {
		625976,
		110,
		true
	},
	amusementpark_shop_enter = {
		626086,
		143,
		true
	},
	amusementpark_shop_exchange = {
		626229,
		189,
		true
	},
	amusementpark_shop_success = {
		626418,
		107,
		true
	},
	amusementpark_shop_special = {
		626525,
		149,
		true
	},
	amusementpark_shop_end = {
		626674,
		116,
		true
	},
	amusementpark_shop_0 = {
		626790,
		176,
		true
	},
	amusementpark_shop_carousel1 = {
		626966,
		152,
		true
	},
	amusementpark_shop_carousel2 = {
		627118,
		151,
		true
	},
	amusementpark_shop_carousel3 = {
		627269,
		153,
		true
	},
	amusementpark_shop_exchange2 = {
		627422,
		196,
		true
	},
	amusementpark_help = {
		627618,
		1927,
		true
	},
	amusementpark_shop_help = {
		629545,
		465,
		true
	},
	handshake_game_help = {
		630010,
		915,
		true
	},
	MeixiV4_help = {
		630925,
		908,
		true
	},
	activity_permanent_total = {
		631833,
		107,
		true
	},
	word_investigate = {
		631940,
		86,
		true
	},
	ambush_display_none = {
		632026,
		88,
		true
	},
	activity_permanent_help = {
		632114,
		502,
		true
	},
	activity_permanent_tips1 = {
		632616,
		171,
		true
	},
	activity_permanent_tips2 = {
		632787,
		175,
		true
	},
	activity_permanent_tips3 = {
		632962,
		155,
		true
	},
	activity_permanent_tips4 = {
		633117,
		199,
		true
	},
	activity_permanent_finished = {
		633316,
		100,
		true
	},
	idolmaster_main = {
		633416,
		1190,
		true
	},
	idolmaster_game_tip1 = {
		634606,
		118,
		true
	},
	idolmaster_game_tip2 = {
		634724,
		116,
		true
	},
	idolmaster_game_tip3 = {
		634840,
		97,
		true
	},
	idolmaster_game_tip4 = {
		634937,
		94,
		true
	},
	idolmaster_game_tip5 = {
		635031,
		89,
		true
	},
	idolmaster_collection = {
		635120,
		631,
		true
	},
	idolmaster_voice_name_feeling1 = {
		635751,
		107,
		true
	},
	idolmaster_voice_name_feeling2 = {
		635858,
		102,
		true
	},
	idolmaster_voice_name_feeling3 = {
		635960,
		101,
		true
	},
	idolmaster_voice_name_feeling4 = {
		636061,
		104,
		true
	},
	idolmaster_voice_name_feeling5 = {
		636165,
		102,
		true
	},
	idolmaster_voice_name_propose = {
		636267,
		98,
		true
	},
	cartoon_all = {
		636365,
		78,
		true
	},
	cartoon_notall = {
		636443,
		84,
		true
	},
	cartoon_haveno = {
		636527,
		111,
		true
	},
	res_cartoon_new_tip = {
		636638,
		108,
		true
	},
	memory_actiivty_ex = {
		636746,
		87,
		true
	},
	memory_activity_sp = {
		636833,
		89,
		true
	},
	memory_activity_daily = {
		636922,
		89,
		true
	},
	memory_activity_others = {
		637011,
		90,
		true
	},
	battle_end_title = {
		637101,
		94,
		true
	},
	battle_end_subtitle1 = {
		637195,
		91,
		true
	},
	battle_end_subtitle2 = {
		637286,
		101,
		true
	},
	meta_skill_dailyexp = {
		637387,
		92,
		true
	},
	meta_skill_learn = {
		637479,
		127,
		true
	},
	meta_skill_maxtip = {
		637606,
		203,
		true
	},
	meta_tactics_detail = {
		637809,
		90,
		true
	},
	meta_tactics_unlock = {
		637899,
		91,
		true
	},
	meta_tactics_switch = {
		637990,
		91,
		true
	},
	meta_skill_maxtip2 = {
		638081,
		91,
		true
	},
	activity_permanent_progress = {
		638172,
		100,
		true
	},
	cattery_settlement_dialogue_1 = {
		638272,
		116,
		true
	},
	cattery_settlement_dialogue_2 = {
		638388,
		131,
		true
	},
	cattery_settlement_dialogue_3 = {
		638519,
		115,
		true
	},
	cattery_settlement_dialogue_4 = {
		638634,
		102,
		true
	},
	blueprint_catchup_by_gold_confirm = {
		638736,
		153,
		true
	},
	blueprint_catchup_by_gold_help = {
		638889,
		318,
		true
	},
	tec_tip_no_consumption = {
		639207,
		90,
		true
	},
	tec_tip_material_stock = {
		639297,
		91,
		true
	},
	tec_tip_to_consumption = {
		639388,
		91,
		true
	},
	onebutton_max_tip = {
		639479,
		96,
		true
	},
	target_get_tip = {
		639575,
		89,
		true
	},
	fleet_select_title = {
		639664,
		94,
		true
	},
	backyard_rename_title = {
		639758,
		96,
		true
	},
	backyard_rename_tip = {
		639854,
		105,
		true
	},
	equip_add = {
		639959,
		99,
		true
	},
	equipskin_add = {
		640058,
		108,
		true
	},
	equipskin_none = {
		640166,
		109,
		true
	},
	equipskin_typewrong = {
		640275,
		117,
		true
	},
	equipskin_typewrong_en = {
		640392,
		108,
		true
	},
	user_is_banned = {
		640500,
		134,
		true
	},
	user_is_forever_banned = {
		640634,
		116,
		true
	},
	old_class_is_close = {
		640750,
		144,
		true
	},
	activity_event_building = {
		640894,
		1210,
		true
	},
	salvage_tips = {
		642104,
		1124,
		true
	},
	tips_shakebeads = {
		643228,
		1036,
		true
	},
	gem_shop_xinzhi_tip = {
		644264,
		113,
		true
	},
	cowboy_tips = {
		644377,
		708,
		true
	},
	backyard_backyardScene_Disable_Rotation = {
		645085,
		137,
		true
	},
	chazi_tips = {
		645222,
		886,
		true
	},
	catchteasure_help = {
		646108,
		453,
		true
	},
	unlock_tips = {
		646561,
		93,
		true
	},
	class_label_tran = {
		646654,
		87,
		true
	},
	class_label_gen = {
		646741,
		88,
		true
	},
	class_attr_store = {
		646829,
		89,
		true
	},
	class_attr_proficiency = {
		646918,
		103,
		true
	},
	class_attr_getproficiency = {
		647021,
		105,
		true
	},
	class_attr_costproficiency = {
		647126,
		104,
		true
	},
	class_label_upgrading = {
		647230,
		94,
		true
	},
	class_label_upgradetime = {
		647324,
		99,
		true
	},
	class_label_oilfield = {
		647423,
		98,
		true
	},
	class_label_goldfield = {
		647521,
		100,
		true
	},
	class_res_maxlevel_tip = {
		647621,
		95,
		true
	},
	ship_exp_item_title = {
		647716,
		93,
		true
	},
	ship_exp_item_label_clear = {
		647809,
		94,
		true
	},
	ship_exp_item_label_recom = {
		647903,
		93,
		true
	},
	ship_exp_item_label_confirm = {
		647996,
		98,
		true
	},
	player_expResource_mail_fullBag = {
		648094,
		200,
		true
	},
	player_expResource_mail_overflow = {
		648294,
		195,
		true
	},
	tec_nation_award_finish = {
		648489,
		98,
		true
	},
	coures_exp_overflow_tip = {
		648587,
		202,
		true
	},
	coures_exp_npc_tip = {
		648789,
		221,
		true
	},
	coures_level_tip = {
		649010,
		162,
		true
	},
	coures_tip_material_stock = {
		649172,
		94,
		true
	},
	coures_tip_exceeded_lv = {
		649266,
		123,
		true
	},
	eatgame_tips = {
		649389,
		844,
		true
	},
	breakout_tip_ultimatebonus_gunner = {
		650233,
		145,
		true
	},
	breakout_tip_ultimatebonus_torpedo = {
		650378,
		130,
		true
	},
	breakout_tip_ultimatebonus_aux = {
		650508,
		133,
		true
	},
	map_event_lighthouse_tip_1 = {
		650641,
		161,
		true
	},
	battlepass_main_tip_2110 = {
		650802,
		202,
		true
	},
	battlepass_main_time = {
		651004,
		94,
		true
	},
	battlepass_main_help_2110 = {
		651098,
		2880,
		true
	},
	cruise_task_help_2110 = {
		653978,
		1094,
		true
	},
	cruise_task_phase = {
		655072,
		106,
		true
	},
	cruise_task_tips = {
		655178,
		89,
		true
	},
	battlepass_task_quickfinish1 = {
		655267,
		231,
		true
	},
	battlepass_task_quickfinish2 = {
		655498,
		224,
		true
	},
	battlepass_task_quickfinish3 = {
		655722,
		102,
		true
	},
	cruise_task_unlock = {
		655824,
		107,
		true
	},
	cruise_task_week = {
		655931,
		87,
		true
	},
	battlepass_pay_timelimit = {
		656018,
		101,
		true
	},
	battlepass_pay_acquire = {
		656119,
		101,
		true
	},
	battlepass_pay_attention = {
		656220,
		159,
		true
	},
	battlepass_acquire_attention = {
		656379,
		189,
		true
	},
	battlepass_pay_tip = {
		656568,
		121,
		true
	},
	battlepass_main_tip1 = {
		656689,
		226,
		true
	},
	battlepass_main_tip2 = {
		656915,
		209,
		true
	},
	battlepass_main_tip3 = {
		657124,
		215,
		true
	},
	battlepass_complete = {
		657339,
		121,
		true
	},
	shop_free_tag = {
		657460,
		81,
		true
	},
	quick_equip_tip1 = {
		657541,
		86,
		true
	},
	quick_equip_tip2 = {
		657627,
		86,
		true
	},
	quick_equip_tip3 = {
		657713,
		85,
		true
	},
	quick_equip_tip4 = {
		657798,
		97,
		true
	},
	quick_equip_tip5 = {
		657895,
		127,
		true
	},
	quick_equip_tip6 = {
		658022,
		184,
		true
	},
	retire_importantequipment_tips = {
		658206,
		179,
		true
	},
	settle_rewards_title = {
		658385,
		109,
		true
	},
	settle_rewards_subtitle = {
		658494,
		101,
		true
	},
	total_rewards_subtitle = {
		658595,
		99,
		true
	},
	settle_rewards_text = {
		658694,
		99,
		true
	},
	use_oil_limit_help = {
		658793,
		243,
		true
	},
	formationScene_use_oil_limit_tip = {
		659036,
		107,
		true
	},
	index_awakening2 = {
		659143,
		93,
		true
	},
	index_upgrade = {
		659236,
		91,
		true
	},
	formationScene_use_oil_limit_enemy = {
		659327,
		104,
		true
	},
	formationScene_use_oil_limit_flagship = {
		659431,
		109,
		true
	},
	formationScene_use_oil_limit_submarine = {
		659540,
		104,
		true
	},
	formationScene_use_oil_limit_surface = {
		659644,
		107,
		true
	},
	formationScene_use_oil_limit_tip_worldboss = {
		659751,
		117,
		true
	},
	attr_durability = {
		659868,
		81,
		true
	},
	attr_armor = {
		659949,
		79,
		true
	},
	attr_reload = {
		660028,
		78,
		true
	},
	attr_cannon = {
		660106,
		77,
		true
	},
	attr_torpedo = {
		660183,
		79,
		true
	},
	attr_motion = {
		660262,
		78,
		true
	},
	attr_antiaircraft = {
		660340,
		83,
		true
	},
	attr_air = {
		660423,
		75,
		true
	},
	attr_hit = {
		660498,
		75,
		true
	},
	attr_antisub = {
		660573,
		79,
		true
	},
	attr_oxy_max = {
		660652,
		79,
		true
	},
	attr_ammo = {
		660731,
		76,
		true
	},
	attr_hunting_range = {
		660807,
		85,
		true
	},
	attr_luck = {
		660892,
		76,
		true
	},
	attr_consume = {
		660968,
		80,
		true
	},
	attr_speed = {
		661048,
		77,
		true
	},
	monthly_card_tip = {
		661125,
		80,
		true
	},
	shopping_error_time_limit = {
		661205,
		138,
		true
	},
	world_total_power = {
		661343,
		86,
		true
	},
	world_mileage = {
		661429,
		91,
		true
	},
	world_pressing = {
		661520,
		91,
		true
	},
	Settings_title_FPS = {
		661611,
		101,
		true
	},
	Settings_title_Notification = {
		661712,
		109,
		true
	},
	Settings_title_Other = {
		661821,
		97,
		true
	},
	Settings_title_LoginJP = {
		661918,
		99,
		true
	},
	Settings_title_Redeem = {
		662017,
		94,
		true
	},
	Settings_title_AdjustScr = {
		662111,
		101,
		true
	},
	Settings_title_Secpw = {
		662212,
		98,
		true
	},
	Settings_title_Secpwlimop = {
		662310,
		110,
		true
	},
	Settings_title_agreement = {
		662420,
		100,
		true
	},
	Settings_title_sound = {
		662520,
		98,
		true
	},
	Settings_title_resUpdate = {
		662618,
		103,
		true
	},
	Settings_title_resManage = {
		662721,
		101,
		true
	},
	Settings_title_resManage_All = {
		662822,
		109,
		true
	},
	Settings_title_resManage_Main = {
		662931,
		111,
		true
	},
	Settings_title_resManage_Sub = {
		663042,
		111,
		true
	},
	equipment_info_change_tip = {
		663153,
		138,
		true
	},
	equipment_info_change_name_a = {
		663291,
		126,
		true
	},
	equipment_info_change_name_b = {
		663417,
		126,
		true
	},
	equipment_info_change_text_before = {
		663543,
		103,
		true
	},
	equipment_info_change_text_after = {
		663646,
		101,
		true
	},
	equipment_info_change_strengthen = {
		663747,
		277,
		true
	},
	world_boss_progress_tip_title = {
		664024,
		122,
		true
	},
	world_boss_progress_tip_desc = {
		664146,
		354,
		true
	},
	ssss_main_help = {
		664500,
		1932,
		true
	},
	mini_game_time = {
		666432,
		88,
		true
	},
	mini_game_score = {
		666520,
		85,
		true
	},
	mini_game_leave = {
		666605,
		93,
		true
	},
	mini_game_pause = {
		666698,
		96,
		true
	},
	mini_game_cur_score = {
		666794,
		97,
		true
	},
	mini_game_high_score = {
		666891,
		95,
		true
	},
	monopoly_world_tip1 = {
		666986,
		96,
		true
	},
	monopoly_world_tip2 = {
		667082,
		237,
		true
	},
	monopoly_world_tip3 = {
		667319,
		212,
		true
	},
	help_monopoly_world = {
		667531,
		1414,
		true
	},
	ssssmedal_tip = {
		668945,
		142,
		true
	},
	ssssmedal_name = {
		669087,
		107,
		true
	},
	ssssmedal_belonging = {
		669194,
		112,
		true
	},
	ssssmedal_name1 = {
		669306,
		108,
		true
	},
	ssssmedal_name2 = {
		669414,
		105,
		true
	},
	ssssmedal_name3 = {
		669519,
		107,
		true
	},
	ssssmedal_name4 = {
		669626,
		109,
		true
	},
	ssssmedal_name5 = {
		669735,
		109,
		true
	},
	ssssmedal_name6 = {
		669844,
		85,
		true
	},
	ssssmedal_belonging1 = {
		669929,
		92,
		true
	},
	ssssmedal_belonging2 = {
		670021,
		99,
		true
	},
	ssssmedal_desc1 = {
		670120,
		168,
		true
	},
	ssssmedal_desc2 = {
		670288,
		158,
		true
	},
	ssssmedal_desc3 = {
		670446,
		168,
		true
	},
	ssssmedal_desc4 = {
		670614,
		155,
		true
	},
	ssssmedal_desc5 = {
		670769,
		180,
		true
	},
	ssssmedal_desc6 = {
		670949,
		131,
		true
	},
	show_fate_demand_count = {
		671080,
		163,
		true
	},
	show_design_demand_count = {
		671243,
		158,
		true
	},
	blueprint_select_overflow = {
		671401,
		124,
		true
	},
	blueprint_select_overflow_tip = {
		671525,
		188,
		true
	},
	blueprint_exchange_empty_tip = {
		671713,
		131,
		true
	},
	blueprint_exchange_select_display = {
		671844,
		128,
		true
	},
	build_rate_title = {
		671972,
		91,
		true
	},
	build_pools_intro = {
		672063,
		116,
		true
	},
	build_detail_intro = {
		672179,
		106,
		true
	},
	ssss_game_tip = {
		672285,
		1498,
		true
	},
	ssss_medal_tip = {
		673783,
		401,
		true
	},
	battlepass_main_tip_2112 = {
		674184,
		233,
		true
	},
	battlepass_main_help_2112 = {
		674417,
		2887,
		true
	},
	cruise_task_help_2112 = {
		677304,
		1085,
		true
	},
	littleSanDiego_npc = {
		678389,
		1223,
		true
	},
	tag_ship_unlocked = {
		679612,
		95,
		true
	},
	tag_ship_locked = {
		679707,
		91,
		true
	},
	acceleration_tips_1 = {
		679798,
		203,
		true
	},
	acceleration_tips_2 = {
		680001,
		228,
		true
	},
	noacceleration_tips = {
		680229,
		119,
		true
	},
	word_shipskin = {
		680348,
		84,
		true
	},
	settings_sound_title_bgm = {
		680432,
		99,
		true
	},
	settings_sound_title_effct = {
		680531,
		101,
		true
	},
	settings_sound_title_cv = {
		680632,
		100,
		true
	},
	setting_resdownload_title_gallery = {
		680732,
		111,
		true
	},
	setting_resdownload_title_live2d = {
		680843,
		109,
		true
	},
	setting_resdownload_title_music = {
		680952,
		105,
		true
	},
	setting_resdownload_title_sound = {
		681057,
		108,
		true
	},
	setting_resdownload_title_manga = {
		681165,
		108,
		true
	},
	setting_resdownload_title_dorm = {
		681273,
		115,
		true
	},
	setting_resdownload_title_main_group = {
		681388,
		117,
		true
	},
	setting_resdownload_title_map = {
		681505,
		113,
		true
	},
	settings_battle_title = {
		681618,
		103,
		true
	},
	settings_battle_tip = {
		681721,
		144,
		true
	},
	settings_battle_Btn_edit = {
		681865,
		92,
		true
	},
	settings_battle_Btn_reset = {
		681957,
		96,
		true
	},
	settings_battle_Btn_save = {
		682053,
		92,
		true
	},
	settings_battle_Btn_cancel = {
		682145,
		96,
		true
	},
	settings_pwd_label_close = {
		682241,
		92,
		true
	},
	settings_pwd_label_open = {
		682333,
		94,
		true
	},
	word_frame = {
		682427,
		78,
		true
	},
	Settings_title_Redeem_input_label = {
		682505,
		109,
		true
	},
	Settings_title_Redeem_input_submit = {
		682614,
		104,
		true
	},
	Settings_title_Redeem_input_placeholder = {
		682718,
		140,
		true
	},
	CurlingGame_tips1 = {
		682858,
		1084,
		true
	},
	maid_task_tips1 = {
		683942,
		1030,
		true
	},
	shop_akashi_pick_title = {
		684972,
		103,
		true
	},
	shop_diamond_title = {
		685075,
		86,
		true
	},
	shop_gift_title = {
		685161,
		84,
		true
	},
	shop_item_title = {
		685245,
		84,
		true
	},
	shop_charge_level_limit = {
		685329,
		102,
		true
	},
	backhill_cantupbuilding = {
		685431,
		135,
		true
	},
	pray_cant_tips = {
		685566,
		107,
		true
	},
	help_xinnian2022_feast = {
		685673,
		2200,
		true
	},
	Pray_activity_tips1 = {
		687873,
		1574,
		true
	},
	backhill_notenoughbuilding = {
		689447,
		184,
		true
	},
	help_xinnian2022_z28 = {
		689631,
		766,
		true
	},
	help_xinnian2022_firework = {
		690397,
		1156,
		true
	},
	settings_title_account_del = {
		691553,
		97,
		true
	},
	settings_text_account_del = {
		691650,
		105,
		true
	},
	settings_text_account_del_desc = {
		691755,
		290,
		true
	},
	settings_text_account_del_confirm = {
		692045,
		150,
		true
	},
	settings_text_account_del_btn = {
		692195,
		99,
		true
	},
	box_account_del_input = {
		692294,
		142,
		true
	},
	box_account_del_target = {
		692436,
		92,
		true
	},
	box_account_del_click = {
		692528,
		100,
		true
	},
	box_account_del_success_content = {
		692628,
		131,
		true
	},
	box_account_reborn_content = {
		692759,
		211,
		true
	},
	tip_account_del_dismatch = {
		692970,
		120,
		true
	},
	tip_account_del_reborn = {
		693090,
		135,
		true
	},
	player_manifesto_placeholder = {
		693225,
		110,
		true
	},
	box_ship_del_click = {
		693335,
		95,
		true
	},
	box_equipment_del_click = {
		693430,
		100,
		true
	},
	change_player_name_title = {
		693530,
		103,
		true
	},
	change_player_name_subtitle = {
		693633,
		111,
		true
	},
	change_player_name_input_tip = {
		693744,
		112,
		true
	},
	change_player_name_illegal = {
		693856,
		241,
		true
	},
	nodisplay_player_home_name = {
		694097,
		94,
		true
	},
	nodisplay_player_home_share = {
		694191,
		97,
		true
	},
	tactics_class_start = {
		694288,
		88,
		true
	},
	tactics_class_cancel = {
		694376,
		90,
		true
	},
	tactics_class_get_exp = {
		694466,
		94,
		true
	},
	tactics_class_spend_time = {
		694560,
		99,
		true
	},
	build_ticket_description = {
		694659,
		118,
		true
	},
	build_ticket_expire_warning = {
		694777,
		103,
		true
	},
	tip_build_ticket_expired = {
		694880,
		135,
		true
	},
	tip_build_ticket_exchange_expired = {
		695015,
		174,
		true
	},
	tip_build_ticket_not_enough = {
		695189,
		107,
		true
	},
	build_ship_tip_use_ticket = {
		695296,
		195,
		true
	},
	springfes_tips1 = {
		695491,
		907,
		true
	},
	worldinpicture_tavel_point_tip = {
		696398,
		126,
		true
	},
	worldinpicture_draw_point_tip = {
		696524,
		122,
		true
	},
	worldinpicture_help = {
		696646,
		1037,
		true
	},
	worldinpicture_task_help = {
		697683,
		1042,
		true
	},
	worldinpicture_not_area_can_draw = {
		698725,
		135,
		true
	},
	missile_attack_area_confirm = {
		698860,
		104,
		true
	},
	missile_attack_area_cancel = {
		698964,
		103,
		true
	},
	shipchange_alert_infleet = {
		699067,
		157,
		true
	},
	shipchange_alert_inpvp = {
		699224,
		168,
		true
	},
	shipchange_alert_inexercise = {
		699392,
		174,
		true
	},
	shipchange_alert_inworld = {
		699566,
		168,
		true
	},
	shipchange_alert_inguildbossevent = {
		699734,
		177,
		true
	},
	shipchange_alert_indiff = {
		699911,
		156,
		true
	},
	shipmodechange_reject_1stfleet_only = {
		700067,
		210,
		true
	},
	shipmodechange_reject_worldfleet_only = {
		700277,
		215,
		true
	},
	monopoly3thre_tip = {
		700492,
		151,
		true
	},
	fushun_game3_tip = {
		700643,
		1291,
		true
	},
	battlepass_main_tip_2202 = {
		701934,
		197,
		true
	},
	battlepass_main_help_2202 = {
		702131,
		2890,
		true
	},
	cruise_task_help_2202 = {
		705021,
		1092,
		true
	},
	battlepass_main_tip_2204 = {
		706113,
		200,
		true
	},
	battlepass_main_help_2204 = {
		706313,
		2881,
		true
	},
	cruise_task_help_2204 = {
		709194,
		1092,
		true
	},
	battlepass_main_tip_2206 = {
		710286,
		200,
		true
	},
	battlepass_main_help_2206 = {
		710486,
		2889,
		true
	},
	cruise_task_help_2206 = {
		713375,
		1092,
		true
	},
	battlepass_main_tip_2208 = {
		714467,
		199,
		true
	},
	battlepass_main_help_2208 = {
		714666,
		2893,
		true
	},
	cruise_task_help_2208 = {
		717559,
		1092,
		true
	},
	battlepass_main_tip_2210 = {
		718651,
		201,
		true
	},
	battlepass_main_help_2210 = {
		718852,
		2893,
		true
	},
	cruise_task_help_2210 = {
		721745,
		1092,
		true
	},
	battlepass_main_tip_2212 = {
		722837,
		224,
		true
	},
	battlepass_main_help_2212 = {
		723061,
		2900,
		true
	},
	cruise_task_help_2212 = {
		725961,
		1092,
		true
	},
	battlepass_main_tip_2302 = {
		727053,
		225,
		true
	},
	battlepass_main_help_2302 = {
		727278,
		2895,
		true
	},
	cruise_task_help_2302 = {
		730173,
		1092,
		true
	},
	battlepass_main_tip_2304 = {
		731265,
		233,
		true
	},
	battlepass_main_help_2304 = {
		731498,
		2913,
		true
	},
	cruise_task_help_2304 = {
		734411,
		1092,
		true
	},
	battlepass_main_tip_2306 = {
		735503,
		195,
		true
	},
	battlepass_main_help_2306 = {
		735698,
		2883,
		true
	},
	cruise_task_help_2306 = {
		738581,
		1092,
		true
	},
	battlepass_main_tip_2308 = {
		739673,
		197,
		true
	},
	battlepass_main_help_2308 = {
		739870,
		2885,
		true
	},
	cruise_task_help_2308 = {
		742755,
		1092,
		true
	},
	battlepass_main_tip_2310 = {
		743847,
		200,
		true
	},
	battlepass_main_help_2310 = {
		744047,
		2893,
		true
	},
	cruise_task_help_2310 = {
		746940,
		1092,
		true
	},
	battlepass_main_tip_2312 = {
		748032,
		196,
		true
	},
	battlepass_main_help_2312 = {
		748228,
		2898,
		true
	},
	cruise_task_help_2312 = {
		751126,
		1092,
		true
	},
	battlepass_main_tip_2402 = {
		752218,
		197,
		true
	},
	battlepass_main_help_2402 = {
		752415,
		2891,
		true
	},
	cruise_task_help_2402 = {
		755306,
		1092,
		true
	},
	battlepass_main_tip_2404 = {
		756398,
		223,
		true
	},
	battlepass_main_help_2404 = {
		756621,
		2901,
		true
	},
	cruise_task_help_2404 = {
		759522,
		1096,
		true
	},
	battlepass_main_tip_2406 = {
		760618,
		197,
		true
	},
	battlepass_main_help_2406 = {
		760815,
		2899,
		true
	},
	cruise_task_help_2406 = {
		763714,
		1092,
		true
	},
	battlepass_main_tip_2408 = {
		764806,
		222,
		true
	},
	battlepass_main_help_2408 = {
		765028,
		2898,
		true
	},
	cruise_task_help_2408 = {
		767926,
		1092,
		true
	},
	battlepass_main_tip_2410 = {
		769018,
		273,
		true
	},
	battlepass_main_help_2410 = {
		769291,
		2901,
		true
	},
	cruise_task_help_2410 = {
		772192,
		1092,
		true
	},
	battlepass_main_tip_2412 = {
		773284,
		230,
		true
	},
	battlepass_main_help_2412 = {
		773514,
		2895,
		true
	},
	cruise_task_help_2412 = {
		776409,
		1092,
		true
	},
	battlepass_main_tip_2502 = {
		777501,
		271,
		true
	},
	battlepass_main_help_2502 = {
		777772,
		2900,
		true
	},
	cruise_task_help_2502 = {
		780672,
		1092,
		true
	},
	battlepass_main_tip_2504 = {
		781764,
		270,
		true
	},
	battlepass_main_help_2504 = {
		782034,
		2905,
		true
	},
	cruise_task_help_2504 = {
		784939,
		1092,
		true
	},
	battlepass_main_tip_2506 = {
		786031,
		273,
		true
	},
	battlepass_main_help_2506 = {
		786304,
		2908,
		true
	},
	cruise_task_help_2506 = {
		789212,
		1092,
		true
	},
	battlepass_main_tip_2508 = {
		790304,
		273,
		true
	},
	battlepass_main_help_2508 = {
		790577,
		2909,
		true
	},
	cruise_task_help_2508 = {
		793486,
		1092,
		true
	},
	battlepass_main_tip_2510 = {
		794578,
		273,
		true
	},
	battlepass_main_help_2510 = {
		794851,
		2906,
		true
	},
	cruise_task_help_2510 = {
		797757,
		1092,
		true
	},
	attrset_reset = {
		798849,
		82,
		true
	},
	attrset_save = {
		798931,
		80,
		true
	},
	attrset_ask_save = {
		799011,
		133,
		true
	},
	attrset_save_success = {
		799144,
		103,
		true
	},
	attrset_disable = {
		799247,
		147,
		true
	},
	attrset_input_ill = {
		799394,
		93,
		true
	},
	blackfriday_help = {
		799487,
		805,
		true
	},
	eventshop_time_hint = {
		800292,
		100,
		true
	},
	purchase_backyard_theme_desc_for_onekey = {
		800392,
		142,
		true
	},
	purchase_backyard_theme_desc_for_all = {
		800534,
		127,
		true
	},
	sp_no_quota = {
		800661,
		108,
		true
	},
	fur_all_buy = {
		800769,
		82,
		true
	},
	fur_onekey_buy = {
		800851,
		85,
		true
	},
	littleRenown_npc = {
		800936,
		1402,
		true
	},
	tech_package_tip = {
		802338,
		241,
		true
	},
	backyard_food_shop_tip = {
		802579,
		96,
		true
	},
	dorm_2f_lock = {
		802675,
		87,
		true
	},
	word_get_way = {
		802762,
		90,
		true
	},
	word_get_date = {
		802852,
		94,
		true
	},
	enter_theme_name = {
		802946,
		113,
		true
	},
	enter_extend_food_label = {
		803059,
		93,
		true
	},
	backyard_extend_tip_1 = {
		803152,
		90,
		true
	},
	backyard_extend_tip_2 = {
		803242,
		103,
		true
	},
	backyard_extend_tip_3 = {
		803345,
		94,
		true
	},
	backyard_extend_tip_4 = {
		803439,
		85,
		true
	},
	email_text = {
		803524,
		79,
		true
	},
	emailhold_text = {
		803603,
		127,
		true
	},
	code_text = {
		803730,
		90,
		true
	},
	codehold_text = {
		803820,
		102,
		true
	},
	genBtn_text = {
		803922,
		83,
		true
	},
	desc_text = {
		804005,
		156,
		true
	},
	loginBtn_text = {
		804161,
		84,
		true
	},
	verification_code_req_tip1 = {
		804245,
		126,
		true
	},
	verification_code_req_tip2 = {
		804371,
		175,
		true
	},
	verification_code_req_tip3 = {
		804546,
		134,
		true
	},
	levelScene_remaster_story_tip = {
		804680,
		176,
		true
	},
	levelScene_remaster_unlock_tip = {
		804856,
		188,
		true
	},
	linkBtn_text = {
		805044,
		83,
		true
	},
	yostar_link_title = {
		805127,
		98,
		true
	},
	level_remaster_tip1 = {
		805225,
		95,
		true
	},
	level_remaster_tip2 = {
		805320,
		89,
		true
	},
	level_remaster_tip3 = {
		805409,
		89,
		true
	},
	level_remaster_tip4 = {
		805498,
		102,
		true
	},
	pay_cancel = {
		805600,
		88,
		true
	},
	order_error = {
		805688,
		101,
		true
	},
	pay_fail = {
		805789,
		86,
		true
	},
	user_cancel = {
		805875,
		94,
		true
	},
	system_error = {
		805969,
		88,
		true
	},
	time_out = {
		806057,
		109,
		true
	},
	server_error = {
		806166,
		102,
		true
	},
	data_error = {
		806268,
		98,
		true
	},
	share_success = {
		806366,
		97,
		true
	},
	shoot_screen_fail = {
		806463,
		98,
		true
	},
	server_name = {
		806561,
		87,
		true
	},
	non_support_share = {
		806648,
		134,
		true
	},
	save_success = {
		806782,
		99,
		true
	},
	word_guild_join_err1 = {
		806881,
		115,
		true
	},
	task_empty_tip_1 = {
		806996,
		104,
		true
	},
	task_empty_tip_2 = {
		807100,
		160,
		true
	},
	["airi_error_code_ 100210"] = {
		807260,
		126,
		true
	},
	["airi_error_code_ 100211"] = {
		807386,
		138,
		true
	},
	["airi_error_code_ 100212"] = {
		807524,
		116,
		true
	},
	["airi_error_code_ 100610"] = {
		807640,
		125,
		true
	},
	["airi_error_code_ 100611"] = {
		807765,
		120,
		true
	},
	["airi_error_code_ 100612"] = {
		807885,
		132,
		true
	},
	["airi_error_code_ 100710"] = {
		808017,
		127,
		true
	},
	["airi_error_code_ 100711"] = {
		808144,
		127,
		true
	},
	["airi_error_code_ 100712"] = {
		808271,
		135,
		true
	},
	["airi_error_code_ 100810"] = {
		808406,
		126,
		true
	},
	["airi_error_code_ 100811"] = {
		808532,
		138,
		true
	},
	["airi_error_code_ 100812"] = {
		808670,
		133,
		true
	},
	["airi_error_code_ 100813"] = {
		808803,
		125,
		true
	},
	["airi_error_code_ 100814"] = {
		808928,
		120,
		true
	},
	["airi_error_code_ 100815"] = {
		809048,
		132,
		true
	},
	["airi_error_code_ 100816"] = {
		809180,
		127,
		true
	},
	["airi_error_code_ 100817"] = {
		809307,
		127,
		true
	},
	["airi_error_code_ 100818"] = {
		809434,
		134,
		true
	},
	facebook_link_title = {
		809568,
		102,
		true
	},
	newserver_time = {
		809670,
		98,
		true
	},
	newserver_soldout = {
		809768,
		103,
		true
	},
	skill_learn_tip = {
		809871,
		133,
		true
	},
	newserver_build_tip = {
		810004,
		150,
		true
	},
	build_count_tip = {
		810154,
		85,
		true
	},
	help_research_package = {
		810239,
		299,
		true
	},
	lv70_package_tip = {
		810538,
		228,
		true
	},
	tech_select_tip1 = {
		810766,
		97,
		true
	},
	tech_select_tip2 = {
		810863,
		107,
		true
	},
	tech_select_tip3 = {
		810970,
		88,
		true
	},
	tech_select_tip4 = {
		811058,
		96,
		true
	},
	tech_select_tip5 = {
		811154,
		117,
		true
	},
	techpackage_item_use = {
		811271,
		203,
		true
	},
	techpackage_item_use_1 = {
		811474,
		238,
		true
	},
	techpackage_item_use_2 = {
		811712,
		200,
		true
	},
	techpackage_item_use_confirm = {
		811912,
		138,
		true
	},
	new_server_shop_sel_goods_tip = {
		812050,
		130,
		true
	},
	new_server_shop_unopen_tip = {
		812180,
		101,
		true
	},
	newserver_activity_tip = {
		812281,
		1685,
		true
	},
	newserver_shop_timelimit = {
		813966,
		106,
		true
	},
	tech_character_get = {
		814072,
		89,
		true
	},
	package_detail_tip = {
		814161,
		88,
		true
	},
	event_ui_consume = {
		814249,
		84,
		true
	},
	event_ui_recommend = {
		814333,
		91,
		true
	},
	event_ui_start = {
		814424,
		83,
		true
	},
	event_ui_giveup = {
		814507,
		85,
		true
	},
	event_ui_finish = {
		814592,
		87,
		true
	},
	nav_tactics_sel_skill_title = {
		814679,
		103,
		true
	},
	battle_result_confirm = {
		814782,
		92,
		true
	},
	battle_result_targets = {
		814874,
		92,
		true
	},
	battle_result_continue = {
		814966,
		103,
		true
	},
	index_L2D = {
		815069,
		76,
		true
	},
	index_DBG = {
		815145,
		84,
		true
	},
	index_BG = {
		815229,
		82,
		true
	},
	index_CANTUSE = {
		815311,
		91,
		true
	},
	index_UNUSE = {
		815402,
		81,
		true
	},
	index_BGM = {
		815483,
		84,
		true
	},
	without_ship_to_wear = {
		815567,
		124,
		true
	},
	choose_ship_to_wear_this_skin = {
		815691,
		136,
		true
	},
	skinatlas_search_holder = {
		815827,
		113,
		true
	},
	skinatlas_search_result_is_empty = {
		815940,
		143,
		true
	},
	chang_ship_skin_window_title = {
		816083,
		96,
		true
	},
	world_boss_item_info = {
		816179,
		350,
		true
	},
	world_past_boss_item_info = {
		816529,
		480,
		true
	},
	world_boss_lefttime = {
		817009,
		92,
		true
	},
	world_boss_item_count_noenough = {
		817101,
		145,
		true
	},
	world_boss_item_usage_tip = {
		817246,
		173,
		true
	},
	world_boss_no_select_archives = {
		817419,
		161,
		true
	},
	world_boss_archives_item_count_noenough = {
		817580,
		157,
		true
	},
	world_boss_archives_are_clear = {
		817737,
		156,
		true
	},
	world_boss_switch_archives = {
		817893,
		248,
		true
	},
	world_boss_switch_archives_success = {
		818141,
		146,
		true
	},
	world_boss_archives_auto_battle_unopen = {
		818287,
		169,
		true
	},
	world_boss_archives_need_stop_auto_battle = {
		818456,
		164,
		true
	},
	world_boss_archives_stop_auto_battle = {
		818620,
		137,
		true
	},
	world_boss_archives_continue_auto_battle = {
		818757,
		140,
		true
	},
	world_boss_archives_auto_battle_reusle_title = {
		818897,
		145,
		true
	},
	world_boss_archives_stop_auto_battle_title = {
		819042,
		146,
		true
	},
	world_boss_archives_stop_auto_battle_tip = {
		819188,
		119,
		true
	},
	world_boss_archives_stop_auto_battle_tip1 = {
		819307,
		241,
		true
	},
	world_archives_boss_help = {
		819548,
		3343,
		true
	},
	world_archives_boss_list_help = {
		822891,
		570,
		true
	},
	archives_boss_was_opened = {
		823461,
		163,
		true
	},
	current_boss_was_opened = {
		823624,
		162,
		true
	},
	world_boss_title_auto_battle = {
		823786,
		103,
		true
	},
	world_boss_title_highest_damge = {
		823889,
		105,
		true
	},
	world_boss_title_estimation = {
		823994,
		113,
		true
	},
	world_boss_title_battle_cnt = {
		824107,
		99,
		true
	},
	world_boss_title_consume_oil_cnt = {
		824206,
		104,
		true
	},
	world_boss_title_spend_time = {
		824310,
		104,
		true
	},
	world_boss_title_total_damage = {
		824414,
		102,
		true
	},
	world_no_time_to_auto_battle = {
		824516,
		143,
		true
	},
	world_boss_current_boss_label = {
		824659,
		104,
		true
	},
	world_boss_current_boss_label1 = {
		824763,
		107,
		true
	},
	world_boss_archives_boss_tip = {
		824870,
		158,
		true
	},
	world_boss_progress_no_enough = {
		825028,
		127,
		true
	},
	world_boss_auto_battle_no_oil = {
		825155,
		119,
		true
	},
	meta_syn_value_label = {
		825274,
		108,
		true
	},
	meta_syn_finish = {
		825382,
		103,
		true
	},
	index_meta_repair = {
		825485,
		104,
		true
	},
	index_meta_tactics = {
		825589,
		103,
		true
	},
	index_meta_energy = {
		825692,
		104,
		true
	},
	tactics_continue_to_learn_other_skill = {
		825796,
		162,
		true
	},
	tactics_continue_to_learn_other_ship_skill = {
		825958,
		161,
		true
	},
	tactics_no_recent_ships = {
		826119,
		113,
		true
	},
	activity_kill = {
		826232,
		95,
		true
	},
	battle_result_dmg = {
		826327,
		87,
		true
	},
	battle_result_kill_count = {
		826414,
		100,
		true
	},
	battle_result_toggle_on = {
		826514,
		96,
		true
	},
	battle_result_toggle_off = {
		826610,
		101,
		true
	},
	battle_result_continue_battle = {
		826711,
		101,
		true
	},
	battle_result_quit_battle = {
		826812,
		96,
		true
	},
	battle_result_share_battle = {
		826908,
		95,
		true
	},
	pre_combat_team = {
		827003,
		91,
		true
	},
	pre_combat_vanguard = {
		827094,
		91,
		true
	},
	pre_combat_main = {
		827185,
		83,
		true
	},
	pre_combat_submarine = {
		827268,
		93,
		true
	},
	pre_combat_targets = {
		827361,
		89,
		true
	},
	pre_combat_atlasloot = {
		827450,
		88,
		true
	},
	destroy_confirm_access = {
		827538,
		93,
		true
	},
	destroy_confirm_cancel = {
		827631,
		92,
		true
	},
	pt_count_tip = {
		827723,
		81,
		true
	},
	dockyard_data_loss_detected = {
		827804,
		167,
		true
	},
	littleEugen_npc = {
		827971,
		1374,
		true
	},
	five_shujuhuigu = {
		829345,
		121,
		true
	},
	five_shujuhuigu1 = {
		829466,
		89,
		true
	},
	littleChaijun_npc = {
		829555,
		1290,
		true
	},
	five_qingdian = {
		830845,
		622,
		true
	},
	friend_resume_title_detail = {
		831467,
		94,
		true
	},
	item_type13_tip1 = {
		831561,
		88,
		true
	},
	item_type13_tip2 = {
		831649,
		88,
		true
	},
	item_type16_tip1 = {
		831737,
		88,
		true
	},
	item_type16_tip2 = {
		831825,
		88,
		true
	},
	item_type17_tip1 = {
		831913,
		87,
		true
	},
	item_type17_tip2 = {
		832000,
		87,
		true
	},
	five_duomaomao = {
		832087,
		788,
		true
	},
	main_4 = {
		832875,
		75,
		true
	},
	main_5 = {
		832950,
		75,
		true
	},
	honor_medal_support_tips_display = {
		833025,
		460,
		true
	},
	honor_medal_support_tips_confirm = {
		833485,
		207,
		true
	},
	support_rate_title = {
		833692,
		87,
		true
	},
	support_times_limited = {
		833779,
		128,
		true
	},
	support_times_tip = {
		833907,
		95,
		true
	},
	build_times_tip = {
		834002,
		90,
		true
	},
	tactics_recent_ship_label = {
		834092,
		105,
		true
	},
	title_info = {
		834197,
		78,
		true
	},
	eventshop_unlock_info = {
		834275,
		93,
		true
	},
	eventshop_unlock_hint = {
		834368,
		142,
		true
	},
	commission_event_tip = {
		834510,
		818,
		true
	},
	decoration_medal_placeholder = {
		835328,
		122,
		true
	},
	technology_filter_placeholder = {
		835450,
		119,
		true
	},
	eva_comment_send_null = {
		835569,
		101,
		true
	},
	report_sent_thank = {
		835670,
		156,
		true
	},
	report_ship_cannot_comment = {
		835826,
		127,
		true
	},
	report_cannot_comment = {
		835953,
		137,
		true
	},
	report_sent_title = {
		836090,
		87,
		true
	},
	report_sent_desc = {
		836177,
		130,
		true
	},
	report_type_1 = {
		836307,
		98,
		true
	},
	report_type_1_1 = {
		836405,
		146,
		true
	},
	report_type_2 = {
		836551,
		94,
		true
	},
	report_type_2_1 = {
		836645,
		146,
		true
	},
	report_type_3 = {
		836791,
		88,
		true
	},
	report_type_3_1 = {
		836879,
		177,
		true
	},
	report_type_other = {
		837056,
		85,
		true
	},
	report_type_other_1 = {
		837141,
		145,
		true
	},
	report_type_other_2 = {
		837286,
		115,
		true
	},
	report_sent_help = {
		837401,
		440,
		true
	},
	rename_input = {
		837841,
		93,
		true
	},
	avatar_task_level = {
		837934,
		166,
		true
	},
	avatar_upgrad_1 = {
		838100,
		92,
		true
	},
	avatar_upgrad_2 = {
		838192,
		92,
		true
	},
	avatar_upgrad_3 = {
		838284,
		95,
		true
	},
	avatar_task_ship_1 = {
		838379,
		92,
		true
	},
	avatar_task_ship_2 = {
		838471,
		103,
		true
	},
	technology_queue_complete = {
		838574,
		97,
		true
	},
	technology_queue_processing = {
		838671,
		102,
		true
	},
	technology_queue_waiting = {
		838773,
		94,
		true
	},
	technology_queue_getaward = {
		838867,
		94,
		true
	},
	technology_daily_refresh = {
		838961,
		119,
		true
	},
	technology_queue_full = {
		839080,
		113,
		true
	},
	technology_queue_in_mission_incomplete = {
		839193,
		177,
		true
	},
	technology_consume = {
		839370,
		95,
		true
	},
	technology_request = {
		839465,
		103,
		true
	},
	technology_queue_in_doublecheck = {
		839568,
		242,
		true
	},
	playervtae_setting_btn_label = {
		839810,
		100,
		true
	},
	technology_queue_in_success = {
		839910,
		130,
		true
	},
	star_require_enemy_text = {
		840040,
		116,
		true
	},
	star_require_enemy_title = {
		840156,
		107,
		true
	},
	star_require_enemy_check = {
		840263,
		95,
		true
	},
	worldboss_rank_timer_label = {
		840358,
		116,
		true
	},
	technology_detail = {
		840474,
		88,
		true
	},
	technology_mission_unfinish = {
		840562,
		127,
		true
	},
	word_chinese = {
		840689,
		82,
		true
	},
	word_japanese_3 = {
		840771,
		80,
		true
	},
	word_japanese_2 = {
		840851,
		80,
		true
	},
	word_japanese = {
		840931,
		78,
		true
	},
	avatarframe_got = {
		841009,
		86,
		true
	},
	item_is_max_cnt = {
		841095,
		110,
		true
	},
	level_fleet_ship_desc = {
		841205,
		103,
		true
	},
	level_fleet_sub_desc = {
		841308,
		95,
		true
	},
	summerland_tip = {
		841403,
		560,
		true
	},
	icecreamgame_tip = {
		841963,
		1578,
		true
	},
	unlock_date_tip = {
		843541,
		118,
		true
	},
	guild_duty_shoule_be_deputy_commander = {
		843659,
		164,
		true
	},
	guild_deputy_commander_cnt_is_full = {
		843823,
		154,
		true
	},
	guild_deputy_commander_cnt = {
		843977,
		153,
		true
	},
	mail_filter_placeholder = {
		844130,
		107,
		true
	},
	recently_sticker_placeholder = {
		844237,
		111,
		true
	},
	backhill_campusfestival_tip = {
		844348,
		1219,
		true
	},
	mini_cookgametip = {
		845567,
		1297,
		true
	},
	cook_game_Albacore = {
		846864,
		115,
		true
	},
	cook_game_august = {
		846979,
		109,
		true
	},
	cook_game_elbe = {
		847088,
		107,
		true
	},
	cook_game_hakuryu = {
		847195,
		125,
		true
	},
	cook_game_howe = {
		847320,
		140,
		true
	},
	cook_game_marcopolo = {
		847460,
		114,
		true
	},
	cook_game_noshiro = {
		847574,
		126,
		true
	},
	cook_game_pnelope = {
		847700,
		130,
		true
	},
	cook_game_laffey = {
		847830,
		171,
		true
	},
	cook_game_janus = {
		848001,
		150,
		true
	},
	cook_game_flandre = {
		848151,
		100,
		true
	},
	cook_game_constellation = {
		848251,
		187,
		true
	},
	cook_game_constellation_skill_name = {
		848438,
		134,
		true
	},
	cook_game_constellation_skill_desc = {
		848572,
		206,
		true
	},
	random_ship_on = {
		848778,
		127,
		true
	},
	random_ship_off_0 = {
		848905,
		181,
		true
	},
	random_ship_off = {
		849086,
		190,
		true
	},
	random_ship_forbidden = {
		849276,
		174,
		true
	},
	random_ship_now = {
		849450,
		97,
		true
	},
	random_ship_label = {
		849547,
		97,
		true
	},
	player_vitae_skin_setting = {
		849644,
		102,
		true
	},
	random_ship_tips1 = {
		849746,
		167,
		true
	},
	random_ship_tips2 = {
		849913,
		145,
		true
	},
	random_ship_before = {
		850058,
		113,
		true
	},
	random_ship_and_skin_title = {
		850171,
		101,
		true
	},
	random_ship_frequse_mode = {
		850272,
		102,
		true
	},
	random_ship_locked_mode = {
		850374,
		99,
		true
	},
	littleSpee_npc = {
		850473,
		1583,
		true
	},
	random_flag_ship = {
		852056,
		96,
		true
	},
	random_flag_ship_changskinBtn_label = {
		852152,
		111,
		true
	},
	expedition_drop_use_out = {
		852263,
		152,
		true
	},
	expedition_extra_drop_tip = {
		852415,
		104,
		true
	},
	ex_pass_use = {
		852519,
		79,
		true
	},
	defense_formation_tip_npc = {
		852598,
		203,
		true
	},
	pgs_login_tip = {
		852801,
		250,
		true
	},
	pgs_login_binding_exist1 = {
		853051,
		204,
		true
	},
	pgs_login_binding_exist2 = {
		853255,
		205,
		true
	},
	pgs_login_binding_exist3 = {
		853460,
		271,
		true
	},
	pgs_binding_account = {
		853731,
		108,
		true
	},
	pgs_unbind = {
		853839,
		92,
		true
	},
	pgs_unbind_tip1 = {
		853931,
		152,
		true
	},
	pgs_unbind_tip2 = {
		854083,
		214,
		true
	},
	word_item = {
		854297,
		77,
		true
	},
	word_tool = {
		854374,
		77,
		true
	},
	word_other = {
		854451,
		78,
		true
	},
	ryza_word_equip = {
		854529,
		83,
		true
	},
	ryza_rest_produce_count = {
		854612,
		109,
		true
	},
	ryza_composite_confirm = {
		854721,
		119,
		true
	},
	ryza_composite_confirm_single = {
		854840,
		122,
		true
	},
	ryza_composite_count = {
		854962,
		93,
		true
	},
	ryza_toggle_only_composite = {
		855055,
		112,
		true
	},
	ryza_tip_select_recipe = {
		855167,
		113,
		true
	},
	ryza_tip_put_materials = {
		855280,
		139,
		true
	},
	ryza_tip_composite_unlock = {
		855419,
		158,
		true
	},
	ryza_tip_unlock_all_tools = {
		855577,
		151,
		true
	},
	ryza_material_not_enough = {
		855728,
		168,
		true
	},
	ryza_tip_composite_invalid = {
		855896,
		132,
		true
	},
	ryza_tip_max_composite_count = {
		856028,
		136,
		true
	},
	ryza_tip_no_item = {
		856164,
		119,
		true
	},
	ryza_ui_show_acess = {
		856283,
		92,
		true
	},
	ryza_tip_no_recipe = {
		856375,
		103,
		true
	},
	ryza_tip_item_access = {
		856478,
		136,
		true
	},
	ryza_tip_control_buff_not_obtain_tip = {
		856614,
		143,
		true
	},
	ryza_tip_control_buff_upgrade = {
		856757,
		100,
		true
	},
	ryza_tip_control_buff_replace = {
		856857,
		100,
		true
	},
	ryza_tip_control_buff_limit = {
		856957,
		96,
		true
	},
	ryza_tip_control_buff_already_active_tip = {
		857053,
		111,
		true
	},
	ryza_tip_control_buff = {
		857164,
		163,
		true
	},
	ryza_tip_control_buff_not_obtain = {
		857327,
		103,
		true
	},
	ryza_tip_control = {
		857430,
		142,
		true
	},
	ryza_tip_main = {
		857572,
		1454,
		true
	},
	battle_levelScene_ryza_lock = {
		859026,
		186,
		true
	},
	ryza_tip_toast_item_got = {
		859212,
		96,
		true
	},
	ryza_composite_help_tip = {
		859308,
		476,
		true
	},
	ryza_control_help_tip = {
		859784,
		296,
		true
	},
	ryza_mini_game = {
		860080,
		351,
		true
	},
	ryza_task_level_desc = {
		860431,
		89,
		true
	},
	ryza_task_tag_explore = {
		860520,
		90,
		true
	},
	ryza_task_tag_battle = {
		860610,
		88,
		true
	},
	ryza_task_tag_dalegate = {
		860698,
		91,
		true
	},
	ryza_task_tag_develop = {
		860789,
		89,
		true
	},
	ryza_task_tag_adventure = {
		860878,
		97,
		true
	},
	ryza_task_tag_build = {
		860975,
		93,
		true
	},
	ryza_task_tag_create = {
		861068,
		92,
		true
	},
	ryza_task_tag_daily = {
		861160,
		90,
		true
	},
	ryza_task_detail_content = {
		861250,
		99,
		true
	},
	ryza_task_detail_award = {
		861349,
		93,
		true
	},
	ryza_task_go = {
		861442,
		83,
		true
	},
	ryza_task_get = {
		861525,
		83,
		true
	},
	ryza_task_get_all = {
		861608,
		90,
		true
	},
	ryza_task_confirm = {
		861698,
		88,
		true
	},
	ryza_task_cancel = {
		861786,
		86,
		true
	},
	ryza_task_level_num = {
		861872,
		93,
		true
	},
	ryza_task_level_add = {
		861965,
		95,
		true
	},
	ryza_task_submit = {
		862060,
		86,
		true
	},
	ryza_task_detail = {
		862146,
		85,
		true
	},
	ryza_composite_words = {
		862231,
		704,
		true
	},
	ryza_task_help_tip = {
		862935,
		345,
		true
	},
	hotspring_buff = {
		863280,
		140,
		true
	},
	random_ship_custom_mode_empty = {
		863420,
		148,
		true
	},
	random_ship_custom_mode_main_button_add = {
		863568,
		106,
		true
	},
	random_ship_custom_mode_main_button_remove = {
		863674,
		112,
		true
	},
	random_ship_custom_mode_main_tip1 = {
		863786,
		151,
		true
	},
	random_ship_custom_mode_main_tip2 = {
		863937,
		107,
		true
	},
	random_ship_custom_mode_main_empty = {
		864044,
		137,
		true
	},
	random_ship_custom_mode_select_all = {
		864181,
		108,
		true
	},
	random_ship_custom_mode_add_tip1 = {
		864289,
		158,
		true
	},
	random_ship_custom_mode_select_number = {
		864447,
		110,
		true
	},
	random_ship_custom_mode_add_complete = {
		864557,
		130,
		true
	},
	random_ship_custom_mode_add_tip2 = {
		864687,
		159,
		true
	},
	random_ship_custom_mode_remove_tip1 = {
		864846,
		166,
		true
	},
	random_ship_custom_mode_remove_complete = {
		865012,
		135,
		true
	},
	random_ship_custom_mode_remove_tip2 = {
		865147,
		166,
		true
	},
	index_dressed = {
		865313,
		89,
		true
	},
	random_ship_custom_mode = {
		865402,
		110,
		true
	},
	random_ship_custom_mode_add_title = {
		865512,
		110,
		true
	},
	random_ship_custom_mode_remove_title = {
		865622,
		116,
		true
	},
	hotspring_shop_enter1 = {
		865738,
		150,
		true
	},
	hotspring_shop_enter2 = {
		865888,
		143,
		true
	},
	hotspring_shop_insufficient = {
		866031,
		189,
		true
	},
	hotspring_shop_success1 = {
		866220,
		117,
		true
	},
	hotspring_shop_success2 = {
		866337,
		103,
		true
	},
	hotspring_shop_finish = {
		866440,
		173,
		true
	},
	hotspring_shop_end = {
		866613,
		155,
		true
	},
	hotspring_shop_touch1 = {
		866768,
		107,
		true
	},
	hotspring_shop_touch2 = {
		866875,
		128,
		true
	},
	hotspring_shop_touch3 = {
		867003,
		115,
		true
	},
	hotspring_shop_exchanged = {
		867118,
		154,
		true
	},
	hotspring_shop_exchange = {
		867272,
		184,
		true
	},
	hotspring_tip1 = {
		867456,
		130,
		true
	},
	hotspring_tip2 = {
		867586,
		104,
		true
	},
	hotspring_help = {
		867690,
		631,
		true
	},
	hotspring_expand = {
		868321,
		147,
		true
	},
	hotspring_shop_help = {
		868468,
		571,
		true
	},
	resorts_help = {
		869039,
		819,
		true
	},
	pvzminigame_help = {
		869858,
		1187,
		true
	},
	tips_yuandanhuoyue2023 = {
		871045,
		745,
		true
	},
	beach_guard_chaijun = {
		871790,
		159,
		true
	},
	beach_guard_jianye = {
		871949,
		164,
		true
	},
	beach_guard_lituoliao = {
		872113,
		279,
		true
	},
	beach_guard_bominghan = {
		872392,
		237,
		true
	},
	beach_guard_nengdai = {
		872629,
		269,
		true
	},
	beach_guard_m_craft = {
		872898,
		121,
		true
	},
	beach_guard_m_atk = {
		873019,
		111,
		true
	},
	beach_guard_m_guard = {
		873130,
		107,
		true
	},
	beach_guard_m_craft_name = {
		873237,
		98,
		true
	},
	beach_guard_m_atk_name = {
		873335,
		94,
		true
	},
	beach_guard_m_guard_name = {
		873429,
		97,
		true
	},
	beach_guard_e1 = {
		873526,
		87,
		true
	},
	beach_guard_e2 = {
		873613,
		84,
		true
	},
	beach_guard_e3 = {
		873697,
		87,
		true
	},
	beach_guard_e4 = {
		873784,
		85,
		true
	},
	beach_guard_e5 = {
		873869,
		87,
		true
	},
	beach_guard_e6 = {
		873956,
		84,
		true
	},
	beach_guard_e7 = {
		874040,
		86,
		true
	},
	beach_guard_e1_desc = {
		874126,
		135,
		true
	},
	beach_guard_e2_desc = {
		874261,
		142,
		true
	},
	beach_guard_e3_desc = {
		874403,
		140,
		true
	},
	beach_guard_e4_desc = {
		874543,
		137,
		true
	},
	beach_guard_e5_desc = {
		874680,
		130,
		true
	},
	beach_guard_e6_desc = {
		874810,
		235,
		true
	},
	beach_guard_e7_desc = {
		875045,
		166,
		true
	},
	ninghai_nianye = {
		875211,
		142,
		true
	},
	yingrui_nianye = {
		875353,
		142,
		true
	},
	zhaohe_nianye = {
		875495,
		135,
		true
	},
	zhenhai_nianye = {
		875630,
		143,
		true
	},
	haitian_nianye = {
		875773,
		153,
		true
	},
	taiyuan_nianye = {
		875926,
		148,
		true
	},
	yixian_nianye = {
		876074,
		166,
		true
	},
	activity_yanhua_tip1 = {
		876240,
		93,
		true
	},
	activity_yanhua_tip2 = {
		876333,
		103,
		true
	},
	activity_yanhua_tip3 = {
		876436,
		103,
		true
	},
	activity_yanhua_tip4 = {
		876539,
		139,
		true
	},
	activity_yanhua_tip5 = {
		876678,
		120,
		true
	},
	activity_yanhua_tip6 = {
		876798,
		124,
		true
	},
	activity_yanhua_tip7 = {
		876922,
		158,
		true
	},
	activity_yanhua_tip8 = {
		877080,
		103,
		true
	},
	help_chunjie2023 = {
		877183,
		1441,
		true
	},
	sevenday_nianye = {
		878624,
		406,
		true
	},
	tip_nianye = {
		879030,
		122,
		true
	},
	couplete_activty_desc = {
		879152,
		351,
		true
	},
	couplete_click_desc = {
		879503,
		131,
		true
	},
	couplet_index_desc = {
		879634,
		89,
		true
	},
	couplete_help = {
		879723,
		770,
		true
	},
	couplete_drag_tip = {
		880493,
		133,
		true
	},
	couplete_remind = {
		880626,
		114,
		true
	},
	couplete_complete = {
		880740,
		132,
		true
	},
	couplete_enter = {
		880872,
		114,
		true
	},
	couplete_stay = {
		880986,
		107,
		true
	},
	couplete_task = {
		881093,
		135,
		true
	},
	couplete_pass_1 = {
		881228,
		96,
		true
	},
	couplete_pass_2 = {
		881324,
		100,
		true
	},
	couplete_fail_1 = {
		881424,
		119,
		true
	},
	couplete_fail_2 = {
		881543,
		117,
		true
	},
	couplete_pair_1 = {
		881660,
		123,
		true
	},
	couplete_pair_2 = {
		881783,
		113,
		true
	},
	couplete_pair_3 = {
		881896,
		119,
		true
	},
	couplete_pair_4 = {
		882015,
		113,
		true
	},
	couplete_pair_5 = {
		882128,
		126,
		true
	},
	couplete_pair_6 = {
		882254,
		119,
		true
	},
	couplete_pair_7 = {
		882373,
		113,
		true
	},
	["2023spring_minigame_item_lantern"] = {
		882486,
		183,
		true
	},
	["2023spring_minigame_item_firecracker"] = {
		882669,
		188,
		true
	},
	["2023spring_minigame_skill_icewall"] = {
		882857,
		149,
		true
	},
	["2023spring_minigame_skill_icewall_up"] = {
		883006,
		223,
		true
	},
	["2023spring_minigame_skill_sprint"] = {
		883229,
		151,
		true
	},
	["2023spring_minigame_skill_sprint_up"] = {
		883380,
		227,
		true
	},
	["2023spring_minigame_skill_flash"] = {
		883607,
		180,
		true
	},
	["2023spring_minigame_skill_flash_up"] = {
		883787,
		200,
		true
	},
	["2023spring_minigame_bless_speed"] = {
		883987,
		136,
		true
	},
	["2023spring_minigame_bless_speed_up"] = {
		884123,
		211,
		true
	},
	["2023spring_minigame_bless_substitute"] = {
		884334,
		204,
		true
	},
	["2023spring_minigame_bless_substitute_up"] = {
		884538,
		127,
		true
	},
	["2023spring_minigame_nenjuu_skill1"] = {
		884665,
		199,
		true
	},
	["2023spring_minigame_nenjuu_skill2"] = {
		884864,
		146,
		true
	},
	["2023spring_minigame_nenjuu_skill3"] = {
		885010,
		158,
		true
	},
	["2023spring_minigame_nenjuu_skill4"] = {
		885168,
		139,
		true
	},
	["2023spring_minigame_nenjuu_skill5"] = {
		885307,
		214,
		true
	},
	["2023spring_minigame_nenjuu_skill6"] = {
		885521,
		158,
		true
	},
	["2023spring_minigame_nenjuu_skill7"] = {
		885679,
		234,
		true
	},
	["2023spring_minigame_nenjuu_skill8"] = {
		885913,
		219,
		true
	},
	["2023spring_minigame_tip1"] = {
		886132,
		93,
		true
	},
	["2023spring_minigame_tip2"] = {
		886225,
		96,
		true
	},
	["2023spring_minigame_tip3"] = {
		886321,
		93,
		true
	},
	["2023spring_minigame_tip5"] = {
		886414,
		136,
		true
	},
	["2023spring_minigame_tip6"] = {
		886550,
		100,
		true
	},
	["2023spring_minigame_tip7"] = {
		886650,
		100,
		true
	},
	["2023spring_minigame_help"] = {
		886750,
		1174,
		true
	},
	multiple_sorties_title = {
		887924,
		97,
		true
	},
	multiple_sorties_title_eng = {
		888021,
		106,
		true
	},
	multiple_sorties_locked_tip = {
		888127,
		180,
		true
	},
	multiple_sorties_times = {
		888307,
		93,
		true
	},
	multiple_sorties_tip = {
		888400,
		206,
		true
	},
	multiple_sorties_challenge_ticket_use = {
		888606,
		118,
		true
	},
	multiple_sorties_cost1 = {
		888724,
		150,
		true
	},
	multiple_sorties_cost2 = {
		888874,
		159,
		true
	},
	multiple_sorties_cost3 = {
		889033,
		184,
		true
	},
	multiple_sorties_stopped = {
		889217,
		95,
		true
	},
	multiple_sorties_stop_tip = {
		889312,
		186,
		true
	},
	multiple_sorties_resume_tip = {
		889498,
		138,
		true
	},
	multiple_sorties_auto_on = {
		889636,
		132,
		true
	},
	multiple_sorties_finish = {
		889768,
		108,
		true
	},
	multiple_sorties_stop = {
		889876,
		105,
		true
	},
	multiple_sorties_stop_end = {
		889981,
		118,
		true
	},
	multiple_sorties_end_status = {
		890099,
		181,
		true
	},
	multiple_sorties_finish_tip = {
		890280,
		140,
		true
	},
	multiple_sorties_stop_tip_end = {
		890420,
		146,
		true
	},
	multiple_sorties_stop_reason1 = {
		890566,
		118,
		true
	},
	multiple_sorties_stop_reason2 = {
		890684,
		147,
		true
	},
	multiple_sorties_stop_reason3 = {
		890831,
		125,
		true
	},
	multiple_sorties_stop_reason4 = {
		890956,
		131,
		true
	},
	multiple_sorties_main_tip = {
		891087,
		253,
		true
	},
	multiple_sorties_main_end = {
		891340,
		204,
		true
	},
	multiple_sorties_rest_time = {
		891544,
		105,
		true
	},
	multiple_sorties_retry_desc = {
		891649,
		108,
		true
	},
	msgbox_text_battle = {
		891757,
		88,
		true
	},
	pre_combat_start = {
		891845,
		86,
		true
	},
	pre_combat_start_en = {
		891931,
		95,
		true
	},
	["2023Valentine_minigame_s"] = {
		892026,
		181,
		true
	},
	["2023Valentine_minigame_a"] = {
		892207,
		165,
		true
	},
	["2023Valentine_minigame_b"] = {
		892372,
		179,
		true
	},
	["2023Valentine_minigame_c"] = {
		892551,
		176,
		true
	},
	["2023Valentine_minigame_label1"] = {
		892727,
		99,
		true
	},
	["2023Valentine_minigame_label2"] = {
		892826,
		97,
		true
	},
	["2023Valentine_minigame_label3"] = {
		892923,
		101,
		true
	},
	Valentine_minigame_label1 = {
		893024,
		95,
		true
	},
	Valentine_minigame_label2 = {
		893119,
		107,
		true
	},
	Valentine_minigame_label3 = {
		893226,
		98,
		true
	},
	sort_energy = {
		893324,
		81,
		true
	},
	dockyard_search_holder = {
		893405,
		100,
		true
	},
	loveletter_exchange_tip1 = {
		893505,
		154,
		true
	},
	loveletter_exchange_tip2 = {
		893659,
		140,
		true
	},
	loveletter_exchange_confirm = {
		893799,
		312,
		true
	},
	loveletter_exchange_button = {
		894111,
		97,
		true
	},
	loveletter_exchange_tip3 = {
		894208,
		163,
		true
	},
	loveletter_recover_tip1 = {
		894371,
		153,
		true
	},
	loveletter_recover_tip2 = {
		894524,
		107,
		true
	},
	loveletter_recover_tip3 = {
		894631,
		152,
		true
	},
	loveletter_recover_tip4 = {
		894783,
		146,
		true
	},
	loveletter_recover_tip5 = {
		894929,
		169,
		true
	},
	loveletter_recover_tip6 = {
		895098,
		156,
		true
	},
	loveletter_recover_tip7 = {
		895254,
		180,
		true
	},
	loveletter_recover_bottom1 = {
		895434,
		94,
		true
	},
	loveletter_recover_bottom2 = {
		895528,
		96,
		true
	},
	loveletter_recover_bottom3 = {
		895624,
		92,
		true
	},
	loveletter_recover_text1 = {
		895716,
		360,
		true
	},
	loveletter_recover_text2 = {
		896076,
		344,
		true
	},
	battle_text_common_1 = {
		896420,
		179,
		true
	},
	battle_text_common_2 = {
		896599,
		235,
		true
	},
	battle_text_common_3 = {
		896834,
		192,
		true
	},
	battle_text_common_4 = {
		897026,
		203,
		true
	},
	battle_text_yingxiv4_1 = {
		897229,
		140,
		true
	},
	battle_text_yingxiv4_2 = {
		897369,
		143,
		true
	},
	battle_text_yingxiv4_3 = {
		897512,
		141,
		true
	},
	battle_text_yingxiv4_4 = {
		897653,
		146,
		true
	},
	battle_text_yingxiv4_5 = {
		897799,
		138,
		true
	},
	battle_text_yingxiv4_6 = {
		897937,
		146,
		true
	},
	battle_text_yingxiv4_7 = {
		898083,
		150,
		true
	},
	battle_text_yingxiv4_8 = {
		898233,
		152,
		true
	},
	battle_text_yingxiv4_9 = {
		898385,
		152,
		true
	},
	battle_text_yingxiv4_10 = {
		898537,
		148,
		true
	},
	battle_text_bisimaiz_1 = {
		898685,
		136,
		true
	},
	battle_text_bisimaiz_2 = {
		898821,
		136,
		true
	},
	battle_text_bisimaiz_3 = {
		898957,
		136,
		true
	},
	battle_text_bisimaiz_4 = {
		899093,
		136,
		true
	},
	battle_text_bisimaiz_5 = {
		899229,
		136,
		true
	},
	battle_text_bisimaiz_6 = {
		899365,
		136,
		true
	},
	battle_text_bisimaiz_7 = {
		899501,
		167,
		true
	},
	battle_text_bisimaiz_8 = {
		899668,
		239,
		true
	},
	battle_text_bisimaiz_9 = {
		899907,
		250,
		true
	},
	battle_text_bisimaiz_10 = {
		900157,
		207,
		true
	},
	battle_text_yunxian_1 = {
		900364,
		172,
		true
	},
	battle_text_yunxian_2 = {
		900536,
		175,
		true
	},
	battle_text_yunxian_3 = {
		900711,
		155,
		true
	},
	battle_text_haidao_1 = {
		900866,
		151,
		true
	},
	battle_text_haidao_2 = {
		901017,
		174,
		true
	},
	battle_text_tongmeng_1 = {
		901191,
		134,
		true
	},
	battle_text_luodeni_1 = {
		901325,
		173,
		true
	},
	battle_text_luodeni_2 = {
		901498,
		202,
		true
	},
	battle_text_luodeni_3 = {
		901700,
		187,
		true
	},
	battle_text_pizibao_1 = {
		901887,
		176,
		true
	},
	battle_text_pizibao_2 = {
		902063,
		178,
		true
	},
	battle_text_tianchengCV_1 = {
		902241,
		194,
		true
	},
	battle_text_tianchengCV_2 = {
		902435,
		174,
		true
	},
	battle_text_tianchengCV_3 = {
		902609,
		189,
		true
	},
	battle_text_lumei_1 = {
		902798,
		119,
		true
	},
	series_enemy_mood = {
		902917,
		91,
		true
	},
	series_enemy_mood_error = {
		903008,
		169,
		true
	},
	series_enemy_reward_tip1 = {
		903177,
		100,
		true
	},
	series_enemy_reward_tip2 = {
		903277,
		112,
		true
	},
	series_enemy_reward_tip3 = {
		903389,
		101,
		true
	},
	series_enemy_reward_tip4 = {
		903490,
		98,
		true
	},
	series_enemy_cost = {
		903588,
		92,
		true
	},
	series_enemy_SP_count = {
		903680,
		104,
		true
	},
	series_enemy_SP_error = {
		903784,
		118,
		true
	},
	series_enemy_unlock = {
		903902,
		126,
		true
	},
	series_enemy_storyunlock = {
		904028,
		119,
		true
	},
	series_enemy_storyreward = {
		904147,
		100,
		true
	},
	series_enemy_help = {
		904247,
		2113,
		true
	},
	series_enemy_score = {
		906360,
		87,
		true
	},
	series_enemy_total_score = {
		906447,
		99,
		true
	},
	setting_label_private = {
		906546,
		85,
		true
	},
	setting_label_licence = {
		906631,
		85,
		true
	},
	series_enemy_reward = {
		906716,
		104,
		true
	},
	series_enemy_mode_1 = {
		906820,
		97,
		true
	},
	series_enemy_mode_2 = {
		906917,
		99,
		true
	},
	series_enemy_fleet_prefix = {
		907016,
		97,
		true
	},
	series_enemy_team_notenough = {
		907113,
		232,
		true
	},
	series_enemy_empty_commander_main = {
		907345,
		108,
		true
	},
	series_enemy_empty_commander_assistant = {
		907453,
		111,
		true
	},
	limit_team_character_tips = {
		907564,
		154,
		true
	},
	game_room_help = {
		907718,
		1337,
		true
	},
	game_cannot_go = {
		909055,
		113,
		true
	},
	game_ticket_notenough = {
		909168,
		143,
		true
	},
	game_ticket_max_all = {
		909311,
		204,
		true
	},
	game_ticket_max_month = {
		909515,
		206,
		true
	},
	game_icon_notenough = {
		909721,
		135,
		true
	},
	game_goldbyicon = {
		909856,
		131,
		true
	},
	game_icon_max = {
		909987,
		189,
		true
	},
	caibulin_tip1 = {
		910176,
		141,
		true
	},
	caibulin_tip2 = {
		910317,
		163,
		true
	},
	caibulin_tip3 = {
		910480,
		141,
		true
	},
	caibulin_tip4 = {
		910621,
		162,
		true
	},
	caibulin_tip5 = {
		910783,
		141,
		true
	},
	caibulin_tip6 = {
		910924,
		163,
		true
	},
	caibulin_tip7 = {
		911087,
		141,
		true
	},
	caibulin_tip8 = {
		911228,
		165,
		true
	},
	caibulin_tip9 = {
		911393,
		162,
		true
	},
	caibulin_tip10 = {
		911555,
		177,
		true
	},
	caibulin_help = {
		911732,
		510,
		true
	},
	caibulin_tip11 = {
		912242,
		167,
		true
	},
	caibulin_lock_tip = {
		912409,
		123,
		true
	},
	gametip_xiaoqiye = {
		912532,
		1526,
		true
	},
	event_recommend_level1 = {
		914058,
		176,
		true
	},
	doa_minigame_Luna = {
		914234,
		85,
		true
	},
	doa_minigame_Misaki = {
		914319,
		89,
		true
	},
	doa_minigame_Marie = {
		914408,
		92,
		true
	},
	doa_minigame_Tamaki = {
		914500,
		89,
		true
	},
	doa_minigame_help = {
		914589,
		294,
		true
	},
	gametip_xiaokewei = {
		914883,
		1529,
		true
	},
	doa_character_select_confirm = {
		916412,
		239,
		true
	},
	blueprint_combatperformance = {
		916651,
		102,
		true
	},
	blueprint_shipperformance = {
		916753,
		94,
		true
	},
	blueprint_researching = {
		916847,
		98,
		true
	},
	sculpture_drawline_tip = {
		916945,
		130,
		true
	},
	sculpture_drawline_done = {
		917075,
		151,
		true
	},
	sculpture_drawline_exit = {
		917226,
		181,
		true
	},
	sculpture_puzzle_tip = {
		917407,
		162,
		true
	},
	sculpture_gratitude_tip = {
		917569,
		131,
		true
	},
	sculpture_close_tip = {
		917700,
		97,
		true
	},
	gift_act_help = {
		917797,
		713,
		true
	},
	gift_act_drawline_help = {
		918510,
		722,
		true
	},
	gift_act_tips = {
		919232,
		92,
		true
	},
	expedition_award_tip = {
		919324,
		150,
		true
	},
	island_act_tips1 = {
		919474,
		94,
		true
	},
	haidaojudian_help = {
		919568,
		2479,
		true
	},
	haidaojudian_building_tip = {
		922047,
		139,
		true
	},
	workbench_help = {
		922186,
		653,
		true
	},
	workbench_need_materials = {
		922839,
		104,
		true
	},
	workbench_tips1 = {
		922943,
		103,
		true
	},
	workbench_tips2 = {
		923046,
		110,
		true
	},
	workbench_tips3 = {
		923156,
		117,
		true
	},
	workbench_tips4 = {
		923273,
		114,
		true
	},
	workbench_tips5 = {
		923387,
		114,
		true
	},
	workbench_tips6 = {
		923501,
		88,
		true
	},
	workbench_tips7 = {
		923589,
		88,
		true
	},
	workbench_tips8 = {
		923677,
		87,
		true
	},
	workbench_tips9 = {
		923764,
		95,
		true
	},
	workbench_tips10 = {
		923859,
		102,
		true
	},
	island_help = {
		923961,
		610,
		true
	},
	islandnode_tips1 = {
		924571,
		92,
		true
	},
	islandnode_tips2 = {
		924663,
		84,
		true
	},
	islandnode_tips3 = {
		924747,
		105,
		true
	},
	islandnode_tips4 = {
		924852,
		105,
		true
	},
	islandnode_tips5 = {
		924957,
		113,
		true
	},
	islandnode_tips6 = {
		925070,
		116,
		true
	},
	islandnode_tips7 = {
		925186,
		125,
		true
	},
	islandnode_tips8 = {
		925311,
		151,
		true
	},
	islandnode_tips9 = {
		925462,
		142,
		true
	},
	islandshop_tips1 = {
		925604,
		98,
		true
	},
	islandshop_tips2 = {
		925702,
		87,
		true
	},
	islandshop_tips3 = {
		925789,
		84,
		true
	},
	islandshop_tips4 = {
		925873,
		95,
		true
	},
	island_shop_limit_error = {
		925968,
		146,
		true
	},
	haidaojudian_upgrade_limit = {
		926114,
		154,
		true
	},
	chargetip_monthcard_1 = {
		926268,
		145,
		true
	},
	chargetip_monthcard_2 = {
		926413,
		145,
		true
	},
	chargetip_crusing = {
		926558,
		102,
		true
	},
	chargetip_giftpackage = {
		926660,
		141,
		true
	},
	package_view_1 = {
		926801,
		131,
		true
	},
	package_view_2 = {
		926932,
		143,
		true
	},
	package_view_3 = {
		927075,
		99,
		true
	},
	package_view_4 = {
		927174,
		87,
		true
	},
	probabilityskinshop_tip = {
		927261,
		175,
		true
	},
	skin_gift_desc = {
		927436,
		258,
		true
	},
	springtask_tip = {
		927694,
		307,
		true
	},
	island_build_desc = {
		928001,
		132,
		true
	},
	island_history_desc = {
		928133,
		146,
		true
	},
	island_build_level = {
		928279,
		91,
		true
	},
	island_game_limit_help = {
		928370,
		143,
		true
	},
	island_game_limit_num = {
		928513,
		94,
		true
	},
	ore_minigame_help = {
		928607,
		954,
		true
	},
	meta_shop_exchange_limit_2 = {
		929561,
		96,
		true
	},
	meta_shop_tip = {
		929657,
		138,
		true
	},
	pt_shop_tran_tip = {
		929795,
		275,
		true
	},
	urdraw_tip = {
		930070,
		125,
		true
	},
	urdraw_complement = {
		930195,
		170,
		true
	},
	meta_class_t_level_1 = {
		930365,
		95,
		true
	},
	meta_class_t_level_2 = {
		930460,
		102,
		true
	},
	meta_class_t_level_3 = {
		930562,
		99,
		true
	},
	meta_class_t_level_4 = {
		930661,
		100,
		true
	},
	meta_class_t_level_5 = {
		930761,
		99,
		true
	},
	meta_shop_exchange_limit_tip = {
		930860,
		121,
		true
	},
	meta_shop_exchange_limit_2_tip = {
		930981,
		143,
		true
	},
	charge_tip_crusing_label = {
		931124,
		101,
		true
	},
	mktea_1 = {
		931225,
		144,
		true
	},
	mktea_2 = {
		931369,
		155,
		true
	},
	mktea_3 = {
		931524,
		159,
		true
	},
	mktea_4 = {
		931683,
		233,
		true
	},
	mktea_5 = {
		931916,
		222,
		true
	},
	random_skin_list_item_desc_label = {
		932138,
		99,
		true
	},
	notice_input_desc = {
		932237,
		99,
		true
	},
	notice_label_send = {
		932336,
		85,
		true
	},
	notice_label_room = {
		932421,
		88,
		true
	},
	notice_label_recv = {
		932509,
		90,
		true
	},
	notice_label_tip = {
		932599,
		123,
		true
	},
	littleTaihou_npc = {
		932722,
		1477,
		true
	},
	disassemble_selected = {
		934199,
		92,
		true
	},
	disassemble_available = {
		934291,
		95,
		true
	},
	ship_formationUI_fleetName_challenge = {
		934386,
		115,
		true
	},
	ship_formationUI_fleetName_challenge_sub = {
		934501,
		119,
		true
	},
	word_status_activity = {
		934620,
		92,
		true
	},
	word_status_challenge = {
		934712,
		97,
		true
	},
	shipmodechange_reject_inactivity = {
		934809,
		188,
		true
	},
	shipmodechange_reject_inchallenge = {
		934997,
		192,
		true
	},
	battle_result_total_time = {
		935189,
		99,
		true
	},
	charge_game_room_coin_tip = {
		935288,
		193,
		true
	},
	game_room_shooting_tip = {
		935481,
		100,
		true
	},
	mini_game_shop_ticked_not_enough = {
		935581,
		154,
		true
	},
	game_ticket_current_month = {
		935735,
		103,
		true
	},
	game_icon_max_full = {
		935838,
		138,
		true
	},
	pre_combat_consume = {
		935976,
		87,
		true
	},
	file_down_msgbox = {
		936063,
		192,
		true
	},
	file_down_mgr_title = {
		936255,
		114,
		true
	},
	file_down_mgr_progress = {
		936369,
		91,
		true
	},
	file_down_mgr_error = {
		936460,
		157,
		true
	},
	last_building_not_shown = {
		936617,
		119,
		true
	},
	setting_group_prefs_tip = {
		936736,
		122,
		true
	},
	group_prefs_switch_tip = {
		936858,
		159,
		true
	},
	main_group_msgbox_content = {
		937017,
		184,
		true
	},
	word_maingroup_checking = {
		937201,
		98,
		true
	},
	word_maingroup_checktoupdate = {
		937299,
		107,
		true
	},
	word_maingroup_checkfailure = {
		937406,
		122,
		true
	},
	word_maingroup_updating = {
		937528,
		98,
		true
	},
	word_maingroup_idle = {
		937626,
		90,
		true
	},
	word_maingroup_latest = {
		937716,
		101,
		true
	},
	word_maingroup_updatesuccess = {
		937817,
		108,
		true
	},
	word_maingroup_updatefailure = {
		937925,
		125,
		true
	},
	group_download_tip = {
		938050,
		157,
		true
	},
	word_manga_checking = {
		938207,
		94,
		true
	},
	word_manga_checktoupdate = {
		938301,
		103,
		true
	},
	word_manga_checkfailure = {
		938404,
		118,
		true
	},
	word_manga_updating = {
		938522,
		98,
		true
	},
	word_manga_updatesuccess = {
		938620,
		104,
		true
	},
	word_manga_updatefailure = {
		938724,
		121,
		true
	},
	cryptolalia_lock_res = {
		938845,
		102,
		true
	},
	cryptolalia_not_download_res = {
		938947,
		113,
		true
	},
	cryptolalia_timelimie = {
		939060,
		92,
		true
	},
	cryptolalia_label_downloading = {
		939152,
		114,
		true
	},
	cryptolalia_delete_res = {
		939266,
		104,
		true
	},
	cryptolalia_delete_res_tip = {
		939370,
		133,
		true
	},
	cryptolalia_delete_res_title = {
		939503,
		105,
		true
	},
	cryptolalia_use_gem_title = {
		939608,
		105,
		true
	},
	cryptolalia_use_ticket_title = {
		939713,
		111,
		true
	},
	cryptolalia_exchange = {
		939824,
		94,
		true
	},
	cryptolalia_exchange_success = {
		939918,
		107,
		true
	},
	cryptolalia_list_title = {
		940025,
		93,
		true
	},
	cryptolalia_list_subtitle = {
		940118,
		100,
		true
	},
	cryptolalia_download_done = {
		940218,
		106,
		true
	},
	cryptolalia_coming_soom = {
		940324,
		101,
		true
	},
	cryptolalia_unopen = {
		940425,
		88,
		true
	},
	cryptolalia_no_ticket = {
		940513,
		164,
		true
	},
	cryptolalia_entrance_coming_soom = {
		940677,
		118,
		true
	},
	ship_formationUI_fleetName_sp = {
		940795,
		111,
		true
	},
	ship_formationUI_fleetName_sp_ss = {
		940906,
		118,
		true
	},
	activityboss_sp_all_buff = {
		941024,
		98,
		true
	},
	activityboss_sp_best_score = {
		941122,
		101,
		true
	},
	activityboss_sp_display_reward = {
		941223,
		106,
		true
	},
	activityboss_sp_score_bonus = {
		941329,
		103,
		true
	},
	activityboss_sp_active_buff = {
		941432,
		99,
		true
	},
	activityboss_sp_window_best_score = {
		941531,
		114,
		true
	},
	activityboss_sp_score_target = {
		941645,
		105,
		true
	},
	activityboss_sp_score = {
		941750,
		95,
		true
	},
	activityboss_sp_score_update = {
		941845,
		106,
		true
	},
	activityboss_sp_score_not_update = {
		941951,
		118,
		true
	},
	collect_page_got = {
		942069,
		89,
		true
	},
	charge_menu_month_tip = {
		942158,
		178,
		true
	},
	activity_shop_title = {
		942336,
		88,
		true
	},
	street_shop_title = {
		942424,
		85,
		true
	},
	military_shop_title = {
		942509,
		88,
		true
	},
	quota_shop_title1 = {
		942597,
		92,
		true
	},
	sham_shop_title = {
		942689,
		89,
		true
	},
	fragment_shop_title = {
		942778,
		88,
		true
	},
	guild_shop_title = {
		942866,
		85,
		true
	},
	medal_shop_title = {
		942951,
		85,
		true
	},
	meta_shop_title = {
		943036,
		83,
		true
	},
	mini_game_shop_title = {
		943119,
		89,
		true
	},
	metaskill_up = {
		943208,
		187,
		true
	},
	metaskill_overflow_tip = {
		943395,
		163,
		true
	},
	msgbox_repair_cipher = {
		943558,
		103,
		true
	},
	msgbox_repair_title = {
		943661,
		89,
		true
	},
	equip_skin_detail_count = {
		943750,
		93,
		true
	},
	faest_nothing_to_get = {
		943843,
		105,
		true
	},
	feast_click_to_close = {
		943948,
		98,
		true
	},
	feast_invitation_btn_label = {
		944046,
		108,
		true
	},
	feast_task_btn_label = {
		944154,
		96,
		true
	},
	feast_task_pt_label = {
		944250,
		91,
		true
	},
	feast_task_pt_level = {
		944341,
		89,
		true
	},
	feast_task_pt_get = {
		944430,
		91,
		true
	},
	feast_task_pt_got = {
		944521,
		88,
		true
	},
	feast_task_tag_daily = {
		944609,
		89,
		true
	},
	feast_task_tag_activity = {
		944698,
		94,
		true
	},
	feast_label_make_invitation = {
		944792,
		106,
		true
	},
	feast_no_invitation = {
		944898,
		108,
		true
	},
	feast_no_gift = {
		945006,
		96,
		true
	},
	feast_label_give_invitation = {
		945102,
		106,
		true
	},
	feast_label_give_invitation_finish = {
		945208,
		113,
		true
	},
	feast_label_give_gift = {
		945321,
		94,
		true
	},
	feast_label_give_gift_finish = {
		945415,
		105,
		true
	},
	feast_label_make_ticket_tip = {
		945520,
		151,
		true
	},
	feast_label_make_ticket_click_tip = {
		945671,
		118,
		true
	},
	feast_label_make_ticket_failed_tip = {
		945789,
		153,
		true
	},
	feast_res_window_title = {
		945942,
		93,
		true
	},
	feast_res_window_go_label = {
		946035,
		96,
		true
	},
	feast_tip = {
		946131,
		422,
		true
	},
	feast_invitation_part1 = {
		946553,
		134,
		true
	},
	feast_invitation_part2 = {
		946687,
		260,
		true
	},
	feast_invitation_part3 = {
		946947,
		278,
		true
	},
	feast_invitation_part4 = {
		947225,
		218,
		true
	},
	uscastle2023_help = {
		947443,
		1519,
		true
	},
	feast_cant_give_gift_tip = {
		948962,
		154,
		true
	},
	uscastle2023_minigame_help = {
		949116,
		367,
		true
	},
	feast_drag_invitation_tip = {
		949483,
		143,
		true
	},
	feast_drag_gift_tip = {
		949626,
		131,
		true
	},
	shoot_preview = {
		949757,
		91,
		true
	},
	hit_preview = {
		949848,
		90,
		true
	},
	story_label_skip = {
		949938,
		84,
		true
	},
	story_label_auto = {
		950022,
		84,
		true
	},
	launch_ball_skill_desc = {
		950106,
		93,
		true
	},
	launch_ball_hatsuduki_skill_1 = {
		950199,
		114,
		true
	},
	launch_ball_hatsuduki_skill_1_desc = {
		950313,
		172,
		true
	},
	launch_ball_hatsuduki_skill_2 = {
		950485,
		127,
		true
	},
	launch_ball_hatsuduki_skill_2_desc = {
		950612,
		334,
		true
	},
	launch_ball_shinano_skill_1 = {
		950946,
		113,
		true
	},
	launch_ball_shinano_skill_1_desc = {
		951059,
		193,
		true
	},
	launch_ball_shinano_skill_2 = {
		951252,
		121,
		true
	},
	launch_ball_shinano_skill_2_desc = {
		951373,
		257,
		true
	},
	launch_ball_yura_skill_1 = {
		951630,
		111,
		true
	},
	launch_ball_yura_skill_1_desc = {
		951741,
		169,
		true
	},
	launch_ball_yura_skill_2 = {
		951910,
		120,
		true
	},
	launch_ball_yura_skill_2_desc = {
		952030,
		206,
		true
	},
	launch_ball_shimakaze_skill_1 = {
		952236,
		124,
		true
	},
	launch_ball_shimakaze_skill_1_desc = {
		952360,
		225,
		true
	},
	launch_ball_shimakaze_skill_2 = {
		952585,
		121,
		true
	},
	launch_ball_shimakaze_skill_2_desc = {
		952706,
		202,
		true
	},
	jp6th_spring_tip1 = {
		952908,
		172,
		true
	},
	jp6th_spring_tip2 = {
		953080,
		104,
		true
	},
	jp6th_biaohoushan_help = {
		953184,
		1312,
		true
	},
	jp6th_lihoushan_help = {
		954496,
		2540,
		true
	},
	jp6th_lihoushan_time = {
		957036,
		125,
		true
	},
	jp6th_lihoushan_order = {
		957161,
		138,
		true
	},
	jp6th_lihoushan_pt1 = {
		957299,
		98,
		true
	},
	launchball_minigame_help = {
		957397,
		357,
		true
	},
	launchball_minigame_select = {
		957754,
		106,
		true
	},
	launchball_minigame_un_select = {
		957860,
		122,
		true
	},
	launchball_minigame_shop = {
		957982,
		106,
		true
	},
	launchball_lock_Shinano = {
		958088,
		172,
		true
	},
	launchball_lock_Yura = {
		958260,
		166,
		true
	},
	launchball_lock_Shimakaze = {
		958426,
		176,
		true
	},
	launchball_spilt_series = {
		958602,
		162,
		true
	},
	launchball_spilt_mix = {
		958764,
		311,
		true
	},
	launchball_spilt_over = {
		959075,
		224,
		true
	},
	launchball_spilt_many = {
		959299,
		152,
		true
	},
	luckybag_skin_isani = {
		959451,
		90,
		true
	},
	luckybag_skin_islive2d = {
		959541,
		93,
		true
	},
	SkinMagazinePage2_tip = {
		959634,
		92,
		true
	},
	racing_cost = {
		959726,
		86,
		true
	},
	racing_rank_top_text = {
		959812,
		98,
		true
	},
	racing_rank_half_h = {
		959910,
		102,
		true
	},
	racing_rank_no_data = {
		960012,
		101,
		true
	},
	racing_minigame_help = {
		960113,
		357,
		true
	},
	child_msg_title_detail = {
		960470,
		93,
		true
	},
	child_msg_title_tip = {
		960563,
		87,
		true
	},
	child_msg_owned = {
		960650,
		88,
		true
	},
	child_polaroid_get_tip = {
		960738,
		135,
		true
	},
	child_close_tip = {
		960873,
		101,
		true
	},
	word_month = {
		960974,
		79,
		true
	},
	word_which_month = {
		961053,
		88,
		true
	},
	word_which_week = {
		961141,
		86,
		true
	},
	word_in_one_week = {
		961227,
		89,
		true
	},
	word_week_title = {
		961316,
		82,
		true
	},
	word_harbour = {
		961398,
		80,
		true
	},
	child_btn_target = {
		961478,
		85,
		true
	},
	child_btn_collect = {
		961563,
		89,
		true
	},
	child_btn_mind = {
		961652,
		86,
		true
	},
	child_btn_bag = {
		961738,
		82,
		true
	},
	child_btn_news = {
		961820,
		90,
		true
	},
	child_main_help = {
		961910,
		526,
		true
	},
	child_archive_name = {
		962436,
		86,
		true
	},
	child_news_import_title = {
		962522,
		99,
		true
	},
	child_news_other_title = {
		962621,
		101,
		true
	},
	child_favor_progress = {
		962722,
		96,
		true
	},
	child_favor_lock1 = {
		962818,
		96,
		true
	},
	child_favor_lock2 = {
		962914,
		96,
		true
	},
	child_target_lock_tip = {
		963010,
		136,
		true
	},
	child_target_progress = {
		963146,
		96,
		true
	},
	child_target_finish_tip = {
		963242,
		117,
		true
	},
	child_target_time_title = {
		963359,
		97,
		true
	},
	child_target_title1 = {
		963456,
		92,
		true
	},
	child_target_title2 = {
		963548,
		94,
		true
	},
	child_item_type0 = {
		963642,
		83,
		true
	},
	child_item_type1 = {
		963725,
		85,
		true
	},
	child_item_type2 = {
		963810,
		91,
		true
	},
	child_item_type3 = {
		963901,
		85,
		true
	},
	child_item_type4 = {
		963986,
		85,
		true
	},
	child_mind_empty_tip = {
		964071,
		124,
		true
	},
	child_mind_finish_title = {
		964195,
		96,
		true
	},
	child_mind_processing_title = {
		964291,
		102,
		true
	},
	child_mind_time_title = {
		964393,
		95,
		true
	},
	child_collect_lock = {
		964488,
		88,
		true
	},
	child_nature_title = {
		964576,
		94,
		true
	},
	child_btn_review = {
		964670,
		87,
		true
	},
	child_schedule_empty_tip = {
		964757,
		132,
		true
	},
	child_schedule_event_tip = {
		964889,
		136,
		true
	},
	child_schedule_sure_tip = {
		965025,
		189,
		true
	},
	child_schedule_sure_tip2 = {
		965214,
		146,
		true
	},
	child_plan_check_tip1 = {
		965360,
		152,
		true
	},
	child_plan_check_tip2 = {
		965512,
		141,
		true
	},
	child_plan_check_tip3 = {
		965653,
		166,
		true
	},
	child_plan_check_tip4 = {
		965819,
		132,
		true
	},
	child_plan_check_tip5 = {
		965951,
		133,
		true
	},
	child_plan_event = {
		966084,
		96,
		true
	},
	child_btn_home = {
		966180,
		85,
		true
	},
	child_option_limit = {
		966265,
		89,
		true
	},
	child_shop_tip1 = {
		966354,
		117,
		true
	},
	child_shop_tip2 = {
		966471,
		112,
		true
	},
	child_filter_title = {
		966583,
		88,
		true
	},
	child_filter_type1 = {
		966671,
		95,
		true
	},
	child_filter_type2 = {
		966766,
		93,
		true
	},
	child_filter_type3 = {
		966859,
		91,
		true
	},
	child_plan_type1 = {
		966950,
		86,
		true
	},
	child_plan_type2 = {
		967036,
		87,
		true
	},
	child_plan_type3 = {
		967123,
		95,
		true
	},
	child_plan_type4 = {
		967218,
		89,
		true
	},
	child_filter_award_res = {
		967307,
		91,
		true
	},
	child_filter_award_nature = {
		967398,
		100,
		true
	},
	child_filter_award_attr1 = {
		967498,
		93,
		true
	},
	child_filter_award_attr2 = {
		967591,
		97,
		true
	},
	child_mood_desc1 = {
		967688,
		149,
		true
	},
	child_mood_desc2 = {
		967837,
		143,
		true
	},
	child_mood_desc3 = {
		967980,
		145,
		true
	},
	child_mood_desc4 = {
		968125,
		145,
		true
	},
	child_mood_desc5 = {
		968270,
		145,
		true
	},
	child_stage_desc1 = {
		968415,
		95,
		true
	},
	child_stage_desc2 = {
		968510,
		95,
		true
	},
	child_stage_desc3 = {
		968605,
		95,
		true
	},
	child_default_callname = {
		968700,
		95,
		true
	},
	flagship_display_mode_1 = {
		968795,
		118,
		true
	},
	flagship_display_mode_2 = {
		968913,
		117,
		true
	},
	flagship_display_mode_3 = {
		969030,
		95,
		true
	},
	flagship_educate_slot_lock_tip = {
		969125,
		184,
		true
	},
	child_story_name = {
		969309,
		89,
		true
	},
	secretary_special_name = {
		969398,
		88,
		true
	},
	secretary_special_lock_tip = {
		969486,
		101,
		true
	},
	secretary_special_title_age = {
		969587,
		109,
		true
	},
	secretary_special_title_physiognomy = {
		969696,
		117,
		true
	},
	child_plan_skip = {
		969813,
		93,
		true
	},
	child_attr_name1 = {
		969906,
		85,
		true
	},
	child_attr_name2 = {
		969991,
		89,
		true
	},
	child_task_system_type2 = {
		970080,
		93,
		true
	},
	child_task_system_type3 = {
		970173,
		91,
		true
	},
	child_plan_perform_title = {
		970264,
		104,
		true
	},
	child_date_text1 = {
		970368,
		93,
		true
	},
	child_date_text2 = {
		970461,
		96,
		true
	},
	child_date_text3 = {
		970557,
		94,
		true
	},
	child_date_text4 = {
		970651,
		93,
		true
	},
	child_upgrade_sure_tip = {
		970744,
		231,
		true
	},
	child_school_sure_tip = {
		970975,
		212,
		true
	},
	child_extraAttr_sure_tip = {
		971187,
		140,
		true
	},
	child_reset_sure_tip = {
		971327,
		172,
		true
	},
	child_end_sure_tip = {
		971499,
		104,
		true
	},
	child_buff_name = {
		971603,
		85,
		true
	},
	child_unlock_tip = {
		971688,
		86,
		true
	},
	child_unlock_out = {
		971774,
		90,
		true
	},
	child_unlock_memory = {
		971864,
		91,
		true
	},
	child_unlock_polaroid = {
		971955,
		92,
		true
	},
	child_unlock_ending = {
		972047,
		90,
		true
	},
	child_unlock_intimacy = {
		972137,
		94,
		true
	},
	child_unlock_buff = {
		972231,
		87,
		true
	},
	child_unlock_attr2 = {
		972318,
		93,
		true
	},
	child_unlock_attr3 = {
		972411,
		91,
		true
	},
	child_unlock_bag = {
		972502,
		85,
		true
	},
	child_shop_empty_tip = {
		972587,
		101,
		true
	},
	child_bag_empty_tip = {
		972688,
		101,
		true
	},
	levelscene_deploy_submarine = {
		972789,
		105,
		true
	},
	levelscene_deploy_submarine_cancel = {
		972894,
		104,
		true
	},
	levelscene_airexpel_cancel = {
		972998,
		96,
		true
	},
	levelscene_airexpel_select_enemy = {
		973094,
		131,
		true
	},
	levelscene_airexpel_outrange = {
		973225,
		137,
		true
	},
	levelscene_airexpel_select_boss = {
		973362,
		141,
		true
	},
	levelscene_airexpel_select_battle = {
		973503,
		154,
		true
	},
	levelscene_airexpel_select_confirm_left = {
		973657,
		204,
		true
	},
	levelscene_airexpel_select_confirm_right = {
		973861,
		206,
		true
	},
	levelscene_airexpel_select_confirm_up = {
		974067,
		193,
		true
	},
	levelscene_airexpel_select_confirm_down = {
		974260,
		197,
		true
	},
	shipyard_phase_1 = {
		974457,
		929,
		true
	},
	shipyard_phase_2 = {
		975386,
		86,
		true
	},
	shipyard_button_1 = {
		975472,
		91,
		true
	},
	shipyard_button_2 = {
		975563,
		153,
		true
	},
	shipyard_introduce = {
		975716,
		246,
		true
	},
	help_supportfleet = {
		975962,
		358,
		true
	},
	help_supportfleet_16 = {
		976320,
		363,
		true
	},
	help_supportfleet_16_submarine = {
		976683,
		391,
		true
	},
	word_status_inSupportFleet = {
		977074,
		106,
		true
	},
	ship_formationMediator_request_replace_support = {
		977180,
		190,
		true
	},
	courtyard_label_train = {
		977370,
		90,
		true
	},
	courtyard_label_rest = {
		977460,
		88,
		true
	},
	courtyard_label_capacity = {
		977548,
		96,
		true
	},
	courtyard_label_share = {
		977644,
		90,
		true
	},
	courtyard_label_shop = {
		977734,
		88,
		true
	},
	courtyard_label_decoration = {
		977822,
		94,
		true
	},
	courtyard_label_template = {
		977916,
		94,
		true
	},
	courtyard_label_floor = {
		978010,
		91,
		true
	},
	courtyard_label_exp_addition = {
		978101,
		101,
		true
	},
	courtyard_label_total_exp_addition = {
		978202,
		114,
		true
	},
	courtyard_label_comfortable_addition = {
		978316,
		116,
		true
	},
	courtyard_label_placed_furniture = {
		978432,
		112,
		true
	},
	courtyard_label_shop_1 = {
		978544,
		90,
		true
	},
	courtyard_label_clear = {
		978634,
		90,
		true
	},
	courtyard_label_save = {
		978724,
		88,
		true
	},
	courtyard_label_save_theme = {
		978812,
		100,
		true
	},
	courtyard_label_using = {
		978912,
		103,
		true
	},
	courtyard_label_search_holder = {
		979015,
		105,
		true
	},
	courtyard_label_filter = {
		979120,
		92,
		true
	},
	courtyard_label_time = {
		979212,
		88,
		true
	},
	courtyard_label_week = {
		979300,
		93,
		true
	},
	courtyard_label_month = {
		979393,
		94,
		true
	},
	courtyard_label_year = {
		979487,
		93,
		true
	},
	courtyard_label_putlist_title = {
		979580,
		114,
		true
	},
	courtyard_label_custom_theme = {
		979694,
		102,
		true
	},
	courtyard_label_system_theme = {
		979796,
		99,
		true
	},
	courtyard_tip_furniture_not_in_layer = {
		979895,
		142,
		true
	},
	courtyard_label_detail = {
		980037,
		93,
		true
	},
	courtyard_label_place_pnekey = {
		980130,
		103,
		true
	},
	courtyard_label_delete = {
		980233,
		92,
		true
	},
	courtyard_label_cancel_share = {
		980325,
		104,
		true
	},
	courtyard_label_empty_template_list = {
		980429,
		139,
		true
	},
	courtyard_label_empty_custom_template_list = {
		980568,
		195,
		true
	},
	courtyard_label_empty_collection_list = {
		980763,
		135,
		true
	},
	courtyard_label_go = {
		980898,
		89,
		true
	},
	mot_class_t_level_1 = {
		980987,
		97,
		true
	},
	mot_class_t_level_2 = {
		981084,
		98,
		true
	},
	equip_share_label_1 = {
		981182,
		99,
		true
	},
	equip_share_label_2 = {
		981281,
		100,
		true
	},
	equip_share_label_3 = {
		981381,
		99,
		true
	},
	equip_share_label_4 = {
		981480,
		96,
		true
	},
	equip_share_label_5 = {
		981576,
		95,
		true
	},
	equip_share_label_6 = {
		981671,
		99,
		true
	},
	equip_share_label_7 = {
		981770,
		87,
		true
	},
	equip_share_label_8 = {
		981857,
		90,
		true
	},
	equip_share_label_9 = {
		981947,
		87,
		true
	},
	equipcode_input = {
		982034,
		104,
		true
	},
	equipcode_slot_unmatch = {
		982138,
		153,
		true
	},
	equipcode_share_nolabel = {
		982291,
		132,
		true
	},
	equipcode_share_exceedlimit = {
		982423,
		124,
		true
	},
	equipcode_illegal = {
		982547,
		116,
		true
	},
	equipcode_confirm_doublecheck = {
		982663,
		137,
		true
	},
	equipcode_import_success = {
		982800,
		132,
		true
	},
	equipcode_share_success = {
		982932,
		128,
		true
	},
	equipcode_like_limited = {
		983060,
		138,
		true
	},
	equipcode_like_success = {
		983198,
		102,
		true
	},
	equipcode_dislike_success = {
		983300,
		115,
		true
	},
	equipcode_report_type_1 = {
		983415,
		118,
		true
	},
	equipcode_report_type_2 = {
		983533,
		110,
		true
	},
	equipcode_report_warning = {
		983643,
		150,
		true
	},
	equipcode_level_unmatched = {
		983793,
		100,
		true
	},
	equipcode_equipment_unowned = {
		983893,
		103,
		true
	},
	equipcode_diff_selected = {
		983996,
		101,
		true
	},
	equipcode_export_success = {
		984097,
		105,
		true
	},
	equipcode_unsaved_tips = {
		984202,
		154,
		true
	},
	equipcode_share_ruletips = {
		984356,
		139,
		true
	},
	equipcode_share_errorcode7 = {
		984495,
		146,
		true
	},
	equipcode_share_errorcode44 = {
		984641,
		137,
		true
	},
	equipcode_share_title = {
		984778,
		93,
		true
	},
	equipcode_share_titleeng = {
		984871,
		96,
		true
	},
	equipcode_share_listempty = {
		984967,
		115,
		true
	},
	equipcode_equip_occupied = {
		985082,
		94,
		true
	},
	sail_boat_equip_tip_1 = {
		985176,
		206,
		true
	},
	sail_boat_equip_tip_2 = {
		985382,
		215,
		true
	},
	sail_boat_equip_tip_3 = {
		985597,
		218,
		true
	},
	sail_boat_equip_tip_4 = {
		985815,
		210,
		true
	},
	sail_boat_equip_tip_5 = {
		986025,
		191,
		true
	},
	sail_boat_minigame_help = {
		986216,
		356,
		true
	},
	pirate_wanted_help = {
		986572,
		448,
		true
	},
	harbor_backhill_help = {
		987020,
		1172,
		true
	},
	cryptolalia_download_task_already_exists = {
		988192,
		135,
		true
	},
	charge_scene_buy_confirm_backyard = {
		988327,
		168,
		true
	},
	roll_room1 = {
		988495,
		88,
		true
	},
	roll_room2 = {
		988583,
		88,
		true
	},
	roll_room3 = {
		988671,
		84,
		true
	},
	roll_room4 = {
		988755,
		83,
		true
	},
	roll_room5 = {
		988838,
		85,
		true
	},
	roll_room6 = {
		988923,
		92,
		true
	},
	roll_room7 = {
		989015,
		85,
		true
	},
	roll_room8 = {
		989100,
		81,
		true
	},
	roll_room9 = {
		989181,
		86,
		true
	},
	roll_room10 = {
		989267,
		91,
		true
	},
	roll_room11 = {
		989358,
		89,
		true
	},
	roll_room12 = {
		989447,
		90,
		true
	},
	roll_room13 = {
		989537,
		89,
		true
	},
	roll_room14 = {
		989626,
		87,
		true
	},
	roll_room15 = {
		989713,
		80,
		true
	},
	roll_room16 = {
		989793,
		86,
		true
	},
	roll_room17 = {
		989879,
		81,
		true
	},
	roll_attr_list = {
		989960,
		693,
		true
	},
	roll_notimes = {
		990653,
		142,
		true
	},
	roll_tip2 = {
		990795,
		137,
		true
	},
	roll_reward_word1 = {
		990932,
		89,
		true
	},
	roll_reward_word2 = {
		991021,
		90,
		true
	},
	roll_reward_word3 = {
		991111,
		90,
		true
	},
	roll_reward_word4 = {
		991201,
		90,
		true
	},
	roll_reward_word5 = {
		991291,
		90,
		true
	},
	roll_reward_word6 = {
		991381,
		90,
		true
	},
	roll_reward_word7 = {
		991471,
		90,
		true
	},
	roll_reward_word8 = {
		991561,
		87,
		true
	},
	roll_reward_tip = {
		991648,
		94,
		true
	},
	roll_unlock = {
		991742,
		126,
		true
	},
	roll_noname = {
		991868,
		116,
		true
	},
	roll_card_info = {
		991984,
		85,
		true
	},
	roll_card_attr = {
		992069,
		83,
		true
	},
	roll_card_skill = {
		992152,
		85,
		true
	},
	roll_times_left = {
		992237,
		93,
		true
	},
	roll_room_unexplored = {
		992330,
		87,
		true
	},
	roll_reward_got = {
		992417,
		86,
		true
	},
	roll_gametip = {
		992503,
		1639,
		true
	},
	roll_ending_tip1 = {
		994142,
		157,
		true
	},
	roll_ending_tip2 = {
		994299,
		141,
		true
	},
	commandercat_label_raw_name = {
		994440,
		104,
		true
	},
	commandercat_label_custom_name = {
		994544,
		105,
		true
	},
	commandercat_label_display_name = {
		994649,
		106,
		true
	},
	commander_selected_max = {
		994755,
		127,
		true
	},
	word_talent = {
		994882,
		82,
		true
	},
	word_click_to_close = {
		994964,
		95,
		true
	},
	commander_subtile_ablity = {
		995059,
		104,
		true
	},
	commander_subtile_talent = {
		995163,
		102,
		true
	},
	commander_confirm_tip = {
		995265,
		130,
		true
	},
	commander_level_up_tip = {
		995395,
		122,
		true
	},
	commander_skill_effect = {
		995517,
		99,
		true
	},
	commander_choice_talent_1 = {
		995616,
		127,
		true
	},
	commander_choice_talent_2 = {
		995743,
		106,
		true
	},
	commander_choice_talent_3 = {
		995849,
		132,
		true
	},
	commander_get_box_tip_1 = {
		995981,
		102,
		true
	},
	commander_get_box_tip = {
		996083,
		113,
		true
	},
	commander_total_gold = {
		996196,
		95,
		true
	},
	commander_use_box_tip = {
		996291,
		101,
		true
	},
	commander_use_box_queue = {
		996392,
		95,
		true
	},
	commander_command_ability = {
		996487,
		99,
		true
	},
	commander_logistics_ability = {
		996586,
		100,
		true
	},
	commander_tactical_ability = {
		996686,
		97,
		true
	},
	commander_choice_talent_4 = {
		996783,
		147,
		true
	},
	commander_rename_tip = {
		996930,
		145,
		true
	},
	commander_home_level_label = {
		997075,
		103,
		true
	},
	commander_get_commander_coptyright = {
		997178,
		117,
		true
	},
	commander_choice_talent_reset = {
		997295,
		236,
		true
	},
	commander_lock_setting_title = {
		997531,
		180,
		true
	},
	skin_exchange_confirm = {
		997711,
		162,
		true
	},
	skin_purchase_confirm = {
		997873,
		238,
		true
	},
	blackfriday_pack_lock = {
		998111,
		126,
		true
	},
	skin_exchange_title = {
		998237,
		99,
		true
	},
	blackfriday_pack_select_skinall = {
		998336,
		257,
		true
	},
	skin_discount_desc = {
		998593,
		137,
		true
	},
	skin_exchange_timelimit = {
		998730,
		198,
		true
	},
	blackfriday_pack_purchased = {
		998928,
		99,
		true
	},
	commander_unsel_lock_flag_tip = {
		999027,
		200,
		true
	},
	skin_discount_timelimit = {
		999227,
		175,
		true
	},
	shan_luan_task_progress_tip = {
		999402,
		104,
		true
	},
	shan_luan_task_level_tip = {
		999506,
		104,
		true
	},
	shan_luan_task_help = {
		999610,
		876,
		true
	},
	shan_luan_task_buff_default = {
		1000486,
		94,
		true
	},
	senran_pt_consume_tip = {
		1000580,
		228,
		true
	},
	senran_pt_not_enough = {
		1000808,
		139,
		true
	},
	senran_pt_help = {
		1000947,
		595,
		true
	},
	senran_pt_rank = {
		1001542,
		101,
		true
	},
	senran_pt_words_feiniao = {
		1001643,
		420,
		true
	},
	senran_pt_words_banjiu = {
		1002063,
		524,
		true
	},
	senran_pt_words_yan = {
		1002587,
		419,
		true
	},
	senran_pt_words_xuequan = {
		1003006,
		453,
		true
	},
	senran_pt_words_xuebugui = {
		1003459,
		433,
		true
	},
	senran_pt_words_zi = {
		1003892,
		394,
		true
	},
	senran_pt_words_xishao = {
		1004286,
		392,
		true
	},
	senrankagura_backhill_help = {
		1004678,
		1252,
		true
	},
	dorm3d_furnitrue_type_wallpaper = {
		1005930,
		105,
		true
	},
	dorm3d_furnitrue_type_floor = {
		1006035,
		99,
		true
	},
	dorm3d_furnitrue_type_decoration = {
		1006134,
		107,
		true
	},
	dorm3d_furnitrue_type_bed = {
		1006241,
		93,
		true
	},
	dorm3d_furnitrue_type_couch = {
		1006334,
		98,
		true
	},
	dorm3d_furnitrue_type_table = {
		1006432,
		97,
		true
	},
	vote_lable_not_start = {
		1006529,
		90,
		true
	},
	vote_lable_voting = {
		1006619,
		92,
		true
	},
	vote_lable_title = {
		1006711,
		173,
		true
	},
	vote_lable_acc_title_1 = {
		1006884,
		97,
		true
	},
	vote_lable_acc_title_2 = {
		1006981,
		98,
		true
	},
	vote_lable_curr_title_1 = {
		1007079,
		103,
		true
	},
	vote_lable_curr_title_2 = {
		1007182,
		104,
		true
	},
	vote_lable_window_title = {
		1007286,
		94,
		true
	},
	vote_lable_rearch = {
		1007380,
		90,
		true
	},
	vote_lable_daily_task_title = {
		1007470,
		98,
		true
	},
	vote_lable_daily_task_tip = {
		1007568,
		138,
		true
	},
	vote_lable_task_title = {
		1007706,
		96,
		true
	},
	vote_lable_task_list_is_empty = {
		1007802,
		124,
		true
	},
	vote_lable_ship_votes = {
		1007926,
		95,
		true
	},
	vote_help_2023 = {
		1008021,
		5208,
		true
	},
	vote_tip_level_limit = {
		1013229,
		139,
		true
	},
	vote_label_rank = {
		1013368,
		83,
		true
	},
	vote_label_rank_fresh_time_tip = {
		1013451,
		135,
		true
	},
	vote_tip_area_closed = {
		1013586,
		102,
		true
	},
	commander_skill_ui_info = {
		1013688,
		91,
		true
	},
	commander_skill_ui_confirm = {
		1013779,
		97,
		true
	},
	commander_formation_prefab_fleet = {
		1013876,
		102,
		true
	},
	rect_ship_card_tpl_add = {
		1013978,
		96,
		true
	},
	newyear2024_backhill_help = {
		1014074,
		1024,
		true
	},
	last_times_sign = {
		1015098,
		100,
		true
	},
	skin_page_sign = {
		1015198,
		83,
		true
	},
	skin_page_desc = {
		1015281,
		178,
		true
	},
	live2d_reset_desc = {
		1015459,
		110,
		true
	},
	skin_exchange_usetip = {
		1015569,
		138,
		true
	},
	blackfriday_pack_select_skinall_dialog = {
		1015707,
		211,
		true
	},
	not_use_ticket_to_buy_skin = {
		1015918,
		113,
		true
	},
	skin_purchase_over_price = {
		1016031,
		337,
		true
	},
	help_chunjie2024 = {
		1016368,
		1357,
		true
	},
	child_random_polaroid_drop = {
		1017725,
		97,
		true
	},
	child_random_ops_drop = {
		1017822,
		99,
		true
	},
	child_refresh_sure_tip = {
		1017921,
		118,
		true
	},
	child_target_set_sure_tip = {
		1018039,
		225,
		true
	},
	child_polaroid_lock_tip = {
		1018264,
		128,
		true
	},
	child_task_finish_all = {
		1018392,
		115,
		true
	},
	child_unlock_new_secretary = {
		1018507,
		197,
		true
	},
	child_no_resource = {
		1018704,
		103,
		true
	},
	child_target_set_empty = {
		1018807,
		110,
		true
	},
	child_target_set_skip = {
		1018917,
		132,
		true
	},
	child_news_import_empty = {
		1019049,
		130,
		true
	},
	child_news_other_empty = {
		1019179,
		116,
		true
	},
	word_week_day1 = {
		1019295,
		84,
		true
	},
	word_week_day2 = {
		1019379,
		85,
		true
	},
	word_week_day3 = {
		1019464,
		87,
		true
	},
	word_week_day4 = {
		1019551,
		86,
		true
	},
	word_week_day5 = {
		1019637,
		84,
		true
	},
	word_week_day6 = {
		1019721,
		86,
		true
	},
	word_week_day7 = {
		1019807,
		84,
		true
	},
	child_shop_price_title = {
		1019891,
		92,
		true
	},
	child_callname_tip = {
		1019983,
		104,
		true
	},
	child_plan_no_cost = {
		1020087,
		93,
		true
	},
	word_emoji_unlock = {
		1020180,
		102,
		true
	},
	word_get_emoji = {
		1020282,
		86,
		true
	},
	word_show_extra_reward_at_fudai_dialog = {
		1020368,
		136,
		true
	},
	skin_shop_buy_confirm = {
		1020504,
		166,
		true
	},
	activity_victory = {
		1020670,
		106,
		true
	},
	other_world_temple_toggle_1 = {
		1020776,
		106,
		true
	},
	other_world_temple_toggle_2 = {
		1020882,
		108,
		true
	},
	other_world_temple_toggle_3 = {
		1020990,
		107,
		true
	},
	other_world_temple_char = {
		1021097,
		96,
		true
	},
	other_world_temple_award = {
		1021193,
		101,
		true
	},
	other_world_temple_got = {
		1021294,
		93,
		true
	},
	other_world_temple_progress = {
		1021387,
		136,
		true
	},
	other_world_temple_char_title = {
		1021523,
		102,
		true
	},
	other_world_temple_award_last = {
		1021625,
		108,
		true
	},
	other_world_temple_award_title_1 = {
		1021733,
		122,
		true
	},
	other_world_temple_award_title_2 = {
		1021855,
		124,
		true
	},
	other_world_temple_award_title_3 = {
		1021979,
		123,
		true
	},
	other_world_temple_lottery_all = {
		1022102,
		123,
		true
	},
	other_world_temple_award_desc = {
		1022225,
		163,
		true
	},
	temple_consume_not_enough = {
		1022388,
		111,
		true
	},
	other_world_temple_pay = {
		1022499,
		101,
		true
	},
	other_world_task_type_daily = {
		1022600,
		96,
		true
	},
	other_world_task_type_main = {
		1022696,
		94,
		true
	},
	other_world_task_type_repeat = {
		1022790,
		106,
		true
	},
	other_world_task_title = {
		1022896,
		100,
		true
	},
	other_world_task_get_all = {
		1022996,
		97,
		true
	},
	other_world_task_go = {
		1023093,
		90,
		true
	},
	other_world_task_got = {
		1023183,
		91,
		true
	},
	other_world_task_get = {
		1023274,
		90,
		true
	},
	other_world_task_tag_main = {
		1023364,
		93,
		true
	},
	other_world_task_tag_daily = {
		1023457,
		95,
		true
	},
	other_world_task_tag_all = {
		1023552,
		91,
		true
	},
	terminal_personal_title = {
		1023643,
		101,
		true
	},
	terminal_adventure_title = {
		1023744,
		102,
		true
	},
	terminal_guardian_title = {
		1023846,
		96,
		true
	},
	personal_info_title = {
		1023942,
		93,
		true
	},
	personal_property_title = {
		1024035,
		92,
		true
	},
	personal_ability_title = {
		1024127,
		92,
		true
	},
	adventure_award_title = {
		1024219,
		108,
		true
	},
	adventure_progress_title = {
		1024327,
		102,
		true
	},
	adventure_lv_title = {
		1024429,
		99,
		true
	},
	adventure_record_title = {
		1024528,
		99,
		true
	},
	adventure_record_grade_title = {
		1024627,
		108,
		true
	},
	adventure_award_end_tip = {
		1024735,
		114,
		true
	},
	guardian_select_title = {
		1024849,
		100,
		true
	},
	guardian_sure_btn = {
		1024949,
		85,
		true
	},
	guardian_cancel_btn = {
		1025034,
		89,
		true
	},
	guardian_active_tip = {
		1025123,
		89,
		true
	},
	personal_random = {
		1025212,
		94,
		true
	},
	adventure_get_all = {
		1025306,
		90,
		true
	},
	Announcements_Event_Notice = {
		1025396,
		95,
		true
	},
	Announcements_System_Notice = {
		1025491,
		97,
		true
	},
	Announcements_News = {
		1025588,
		86,
		true
	},
	Announcements_Donotshow = {
		1025674,
		109,
		true
	},
	adventure_unlock_tip = {
		1025783,
		170,
		true
	},
	personal_random_tip = {
		1025953,
		139,
		true
	},
	guardian_sure_limit_tip = {
		1026092,
		123,
		true
	},
	other_world_temple_tip = {
		1026215,
		533,
		true
	},
	otherworld_map_help = {
		1026748,
		530,
		true
	},
	otherworld_backhill_help = {
		1027278,
		535,
		true
	},
	otherworld_terminal_help = {
		1027813,
		535,
		true
	},
	vote_2023_reward_word_1 = {
		1028348,
		207,
		true
	},
	vote_2023_reward_word_2 = {
		1028555,
		357,
		true
	},
	vote_2023_reward_word_3 = {
		1028912,
		354,
		true
	},
	voting_page_reward = {
		1029266,
		87,
		true
	},
	backyard_shipAddInimacy_ships_ok = {
		1029353,
		177,
		true
	},
	backyard_shipAddMoney_ships_ok = {
		1029530,
		201,
		true
	},
	idol3rd_houshan = {
		1029731,
		1145,
		true
	},
	idol3rd_collection = {
		1030876,
		800,
		true
	},
	idol3rd_practice = {
		1031676,
		944,
		true
	},
	dorm3d_furniture_window_acesses = {
		1032620,
		106,
		true
	},
	dorm3d_furniture_count = {
		1032726,
		96,
		true
	},
	dorm3d_furniture_used = {
		1032822,
		116,
		true
	},
	dorm3d_furniture_lack = {
		1032938,
		97,
		true
	},
	dorm3d_furniture_unfit = {
		1033035,
		94,
		true
	},
	dorm3d_waiting = {
		1033129,
		88,
		true
	},
	dorm3d_daily_favor = {
		1033217,
		102,
		true
	},
	dorm3d_favor_level = {
		1033319,
		95,
		true
	},
	dorm3d_time_choose = {
		1033414,
		93,
		true
	},
	dorm3d_now_time = {
		1033507,
		91,
		true
	},
	dorm3d_is_auto_time = {
		1033598,
		106,
		true
	},
	dorm3d_clothing_choose = {
		1033704,
		100,
		true
	},
	dorm3d_now_clothing = {
		1033804,
		90,
		true
	},
	dorm3d_talk = {
		1033894,
		79,
		true
	},
	dorm3d_touch = {
		1033973,
		84,
		true
	},
	dorm3d_gift = {
		1034057,
		79,
		true
	},
	dorm3d_gift_owner_num = {
		1034136,
		94,
		true
	},
	dorm3d_unlock_tips = {
		1034230,
		105,
		true
	},
	dorm3d_daily_favor_tips = {
		1034335,
		107,
		true
	},
	main_silent_tip_1 = {
		1034442,
		109,
		true
	},
	main_silent_tip_2 = {
		1034551,
		110,
		true
	},
	main_silent_tip_3 = {
		1034661,
		110,
		true
	},
	main_silent_tip_4 = {
		1034771,
		115,
		true
	},
	main_silent_tip_5 = {
		1034886,
		111,
		true
	},
	main_silent_tip_6 = {
		1034997,
		113,
		true
	},
	commission_label_go = {
		1035110,
		90,
		true
	},
	commission_label_finish = {
		1035200,
		95,
		true
	},
	commission_label_go_mellow = {
		1035295,
		97,
		true
	},
	commission_label_finish_mellow = {
		1035392,
		102,
		true
	},
	commission_label_unlock_event_tip = {
		1035494,
		126,
		true
	},
	commission_label_unlock_tech_tip = {
		1035620,
		125,
		true
	},
	specialshipyard_tip = {
		1035745,
		165,
		true
	},
	specialshipyard_name = {
		1035910,
		97,
		true
	},
	liner_sign_cnt_tip = {
		1036007,
		93,
		true
	},
	liner_sign_unlock_tip = {
		1036100,
		100,
		true
	},
	liner_target_type1 = {
		1036200,
		93,
		true
	},
	liner_target_type2 = {
		1036293,
		91,
		true
	},
	liner_target_type3 = {
		1036384,
		98,
		true
	},
	liner_target_type4 = {
		1036482,
		97,
		true
	},
	liner_target_type5 = {
		1036579,
		112,
		true
	},
	liner_log_schedule_title = {
		1036691,
		103,
		true
	},
	liner_log_room_title = {
		1036794,
		109,
		true
	},
	liner_log_event_title = {
		1036903,
		101,
		true
	},
	liner_schedule_award_tip1 = {
		1037004,
		113,
		true
	},
	liner_schedule_award_tip2 = {
		1037117,
		113,
		true
	},
	liner_room_award_tip = {
		1037230,
		109,
		true
	},
	liner_event_award_tip1 = {
		1037339,
		152,
		true
	},
	liner_log_event_group_title1 = {
		1037491,
		102,
		true
	},
	liner_log_event_group_title2 = {
		1037593,
		102,
		true
	},
	liner_log_event_group_title3 = {
		1037695,
		102,
		true
	},
	liner_log_event_group_title4 = {
		1037797,
		102,
		true
	},
	liner_event_award_tip2 = {
		1037899,
		115,
		true
	},
	liner_event_reasoning_title = {
		1038014,
		107,
		true
	},
	["7th_main_tip"] = {
		1038121,
		850,
		true
	},
	pipe_minigame_help = {
		1038971,
		294,
		true
	},
	pipe_minigame_rank = {
		1039265,
		114,
		true
	},
	liner_event_award_tip3 = {
		1039379,
		128,
		true
	},
	liner_room_get_tip = {
		1039507,
		110,
		true
	},
	liner_event_get_tip = {
		1039617,
		101,
		true
	},
	liner_event_lock = {
		1039718,
		132,
		true
	},
	liner_event_title1 = {
		1039850,
		88,
		true
	},
	liner_event_title2 = {
		1039938,
		88,
		true
	},
	liner_event_title3 = {
		1040026,
		88,
		true
	},
	liner_help = {
		1040114,
		282,
		true
	},
	liner_activity_lock = {
		1040396,
		135,
		true
	},
	liner_name_modify = {
		1040531,
		122,
		true
	},
	UrExchange_Pt_NotEnough = {
		1040653,
		125,
		true
	},
	UrExchange_Pt_charges = {
		1040778,
		105,
		true
	},
	UrExchange_Pt_help = {
		1040883,
		335,
		true
	},
	xiaodadi_npc = {
		1041218,
		1503,
		true
	},
	words_lock_ship_label = {
		1042721,
		118,
		true
	},
	one_click_retire_subtitle = {
		1042839,
		109,
		true
	},
	unique_ship_retire_protect = {
		1042948,
		118,
		true
	},
	unique_ship_tip1 = {
		1043066,
		152,
		true
	},
	unique_ship_retire_before_tip = {
		1043218,
		100,
		true
	},
	unique_ship_tip2 = {
		1043318,
		215,
		true
	},
	lock_new_ship = {
		1043533,
		110,
		true
	},
	main_scene_settings = {
		1043643,
		103,
		true
	},
	settings_enable_standby_mode = {
		1043746,
		110,
		true
	},
	settings_time_system = {
		1043856,
		108,
		true
	},
	settings_flagship_interaction = {
		1043964,
		124,
		true
	},
	settings_enter_standby_mode_time = {
		1044088,
		128,
		true
	},
	["202406_wenquan_unlock"] = {
		1044216,
		177,
		true
	},
	["202406_wenquan_unlock_tip2"] = {
		1044393,
		113,
		true
	},
	["202406_main_help"] = {
		1044506,
		1060,
		true
	},
	MonopolyCar2024Game_title1 = {
		1045566,
		94,
		true
	},
	MonopolyCar2024Game_title2 = {
		1045660,
		98,
		true
	},
	help_monopoly_car2024 = {
		1045758,
		1380,
		true
	},
	MonopolyCar2024Game_pick_tip = {
		1047138,
		191,
		true
	},
	MonopolyCar2024Game_sel_label = {
		1047329,
		99,
		true
	},
	MonopolyCar2024Game_total_award_title = {
		1047428,
		115,
		true
	},
	MonopolyCar2024Game_lock_auto_tip = {
		1047543,
		161,
		true
	},
	MonopolyCar2024Game_open_auto_tip = {
		1047704,
		210,
		true
	},
	MonopolyCar2024Game_total_num_tip = {
		1047914,
		109,
		true
	},
	sitelasibao_expup_name = {
		1048023,
		95,
		true
	},
	sitelasibao_expup_desc = {
		1048118,
		259,
		true
	},
	levelScene_tracking_error_pre_2 = {
		1048377,
		125,
		true
	},
	town_lock_level = {
		1048502,
		121,
		true
	},
	town_place_next_title = {
		1048623,
		103,
		true
	},
	town_unlcok_new = {
		1048726,
		98,
		true
	},
	town_unlcok_level = {
		1048824,
		100,
		true
	},
	["0815_main_help"] = {
		1048924,
		876,
		true
	},
	town_help = {
		1049800,
		931,
		true
	},
	activity_0815_town_memory = {
		1050731,
		163,
		true
	},
	town_gold_tip = {
		1050894,
		212,
		true
	},
	award_max_warning_minigame = {
		1051106,
		226,
		true
	},
	dorm3d_photo_len = {
		1051332,
		86,
		true
	},
	dorm3d_photo_depthoffield = {
		1051418,
		93,
		true
	},
	dorm3d_photo_focusdistance = {
		1051511,
		103,
		true
	},
	dorm3d_photo_focusstrength = {
		1051614,
		104,
		true
	},
	dorm3d_photo_paramaters = {
		1051718,
		97,
		true
	},
	dorm3d_photo_postexposure = {
		1051815,
		97,
		true
	},
	dorm3d_photo_saturation = {
		1051912,
		97,
		true
	},
	dorm3d_photo_contrast = {
		1052009,
		93,
		true
	},
	dorm3d_photo_Others = {
		1052102,
		88,
		true
	},
	dorm3d_photo_hidecharacter = {
		1052190,
		104,
		true
	},
	dorm3d_photo_facecamera = {
		1052294,
		98,
		true
	},
	dorm3d_photo_lighting = {
		1052392,
		93,
		true
	},
	dorm3d_photo_filter = {
		1052485,
		89,
		true
	},
	dorm3d_photo_alpha = {
		1052574,
		94,
		true
	},
	dorm3d_photo_strength = {
		1052668,
		90,
		true
	},
	dorm3d_photo_regular_anim = {
		1052758,
		96,
		true
	},
	dorm3d_photo_special_anim = {
		1052854,
		96,
		true
	},
	dorm3d_photo_animspeed = {
		1052950,
		96,
		true
	},
	dorm3d_photo_furniture_lock = {
		1053046,
		118,
		true
	},
	dorm3d_shop_gift = {
		1053164,
		172,
		true
	},
	dorm3d_shop_gift_tip = {
		1053336,
		184,
		true
	},
	word_unlock = {
		1053520,
		83,
		true
	},
	word_lock = {
		1053603,
		84,
		true
	},
	dorm3d_collect_favor_plus = {
		1053687,
		105,
		true
	},
	dorm3d_collect_nothing = {
		1053792,
		107,
		true
	},
	dorm3d_collect_locked = {
		1053899,
		108,
		true
	},
	dorm3d_collect_not_found = {
		1054007,
		104,
		true
	},
	dorm3d_sirius_table = {
		1054111,
		94,
		true
	},
	dorm3d_sirius_chair = {
		1054205,
		94,
		true
	},
	dorm3d_sirius_bed = {
		1054299,
		88,
		true
	},
	dorm3d_sirius_bath = {
		1054387,
		95,
		true
	},
	dorm3d_collection_beach = {
		1054482,
		92,
		true
	},
	dorm3d_reload_unlock = {
		1054574,
		94,
		true
	},
	dorm3d_reload_unlock_name = {
		1054668,
		92,
		true
	},
	dorm3d_reload_favor = {
		1054760,
		97,
		true
	},
	dorm3d_reload_gift = {
		1054857,
		101,
		true
	},
	dorm3d_collect_unlock = {
		1054958,
		95,
		true
	},
	dorm3d_pledge_favor = {
		1055053,
		136,
		true
	},
	dorm3d_own_favor = {
		1055189,
		132,
		true
	},
	dorm3d_role_choose = {
		1055321,
		93,
		true
	},
	dorm3d_beach_buy = {
		1055414,
		171,
		true
	},
	dorm3d_beach_role = {
		1055585,
		146,
		true
	},
	dorm3d_beach_download = {
		1055731,
		128,
		true
	},
	dorm3d_role_check_in = {
		1055859,
		143,
		true
	},
	dorm3d_data_choose = {
		1056002,
		93,
		true
	},
	dorm3d_role_manage = {
		1056095,
		97,
		true
	},
	dorm3d_role_manage_role = {
		1056192,
		97,
		true
	},
	dorm3d_role_manage_public_area = {
		1056289,
		105,
		true
	},
	dorm3d_data_go = {
		1056394,
		138,
		true
	},
	dorm3d_role_assets_delete = {
		1056532,
		178,
		true
	},
	dorm3d_role_assets_download = {
		1056710,
		224,
		true
	},
	volleyball_end_tip = {
		1056934,
		110,
		true
	},
	volleyball_end_award = {
		1057044,
		106,
		true
	},
	sure_exit_volleyball = {
		1057150,
		119,
		true
	},
	dorm3d_photo_active_zone = {
		1057269,
		105,
		true
	},
	apartment_level_unenough = {
		1057374,
		114,
		true
	},
	help_dorm3d_info = {
		1057488,
		537,
		true
	},
	dorm3d_shop_gift_already_given = {
		1058025,
		127,
		true
	},
	dorm3d_shop_gift_not_owned = {
		1058152,
		114,
		true
	},
	dorm3d_select_tip = {
		1058266,
		101,
		true
	},
	dorm3d_volleyball_title = {
		1058367,
		92,
		true
	},
	dorm3d_minigame_again = {
		1058459,
		90,
		true
	},
	dorm3d_minigame_close = {
		1058549,
		89,
		true
	},
	dorm3d_data_Invite_lack = {
		1058638,
		128,
		true
	},
	dorm3d_item_num = {
		1058766,
		88,
		true
	},
	dorm3d_collect_not_owned = {
		1058854,
		112,
		true
	},
	dorm3d_furniture_sure_save = {
		1058966,
		136,
		true
	},
	dorm3d_furniture_save_success = {
		1059102,
		131,
		true
	},
	dorm3d_removable = {
		1059233,
		151,
		true
	},
	report_cannot_comment_level_1 = {
		1059384,
		151,
		true
	},
	report_cannot_comment_level_2 = {
		1059535,
		130,
		true
	},
	commander_exp_limit = {
		1059665,
		147,
		true
	},
	dreamland_label_day = {
		1059812,
		86,
		true
	},
	dreamland_label_dusk = {
		1059898,
		91,
		true
	},
	dreamland_label_night = {
		1059989,
		90,
		true
	},
	dreamland_label_area = {
		1060079,
		88,
		true
	},
	dreamland_label_explore = {
		1060167,
		94,
		true
	},
	dreamland_label_explore_award_tip = {
		1060261,
		120,
		true
	},
	dreamland_area_lock_tip = {
		1060381,
		127,
		true
	},
	dreamland_spring_lock_tip = {
		1060508,
		116,
		true
	},
	dreamland_spring_tip = {
		1060624,
		116,
		true
	},
	dream_land_tip = {
		1060740,
		969,
		true
	},
	touch_cake_minigame_help = {
		1061709,
		359,
		true
	},
	dreamland_main_desc = {
		1062068,
		232,
		true
	},
	dreamland_main_tip = {
		1062300,
		1017,
		true
	},
	no_share_skin_gametip = {
		1063317,
		120,
		true
	},
	no_share_skin_tianchenghangmu = {
		1063437,
		102,
		true
	},
	no_share_skin_tianchengzhanlie = {
		1063539,
		103,
		true
	},
	no_share_skin_jiahezhanlie = {
		1063642,
		98,
		true
	},
	no_share_skin_jiahehangmu = {
		1063740,
		97,
		true
	},
	ui_pack_tip1 = {
		1063837,
		167,
		true
	},
	ui_pack_tip2 = {
		1064004,
		81,
		true
	},
	ui_pack_tip3 = {
		1064085,
		83,
		true
	},
	battle_ui_unlock = {
		1064168,
		96,
		true
	},
	compensate_ui_expiration_hour = {
		1064264,
		114,
		true
	},
	compensate_ui_expiration_day = {
		1064378,
		112,
		true
	},
	compensate_ui_title1 = {
		1064490,
		89,
		true
	},
	compensate_ui_title2 = {
		1064579,
		94,
		true
	},
	compensate_ui_nothing1 = {
		1064673,
		115,
		true
	},
	compensate_ui_nothing2 = {
		1064788,
		114,
		true
	},
	attire_combatui_preview = {
		1064902,
		94,
		true
	},
	attire_combatui_confirm = {
		1064996,
		92,
		true
	},
	grapihcs3d_setting_quality = {
		1065088,
		106,
		true
	},
	grapihcs3d_setting_quality_option_low = {
		1065194,
		104,
		true
	},
	grapihcs3d_setting_quality_option_medium = {
		1065298,
		110,
		true
	},
	grapihcs3d_setting_quality_option_high = {
		1065408,
		106,
		true
	},
	grapihcs3d_setting_quality_option_custom = {
		1065514,
		110,
		true
	},
	grapihcs3d_setting_universal = {
		1065624,
		111,
		true
	},
	grapihcs3d_setting_gpgpu_warning = {
		1065735,
		149,
		true
	},
	dorm3d_shop_tag1 = {
		1065884,
		109,
		true
	},
	dorm3d_shop_tag2 = {
		1065993,
		101,
		true
	},
	dorm3d_shop_tag3 = {
		1066094,
		113,
		true
	},
	dorm3d_shop_tag4 = {
		1066207,
		110,
		true
	},
	dorm3d_shop_tag5 = {
		1066317,
		106,
		true
	},
	dorm3d_shop_tag6 = {
		1066423,
		96,
		true
	},
	dorm3d_system_switch = {
		1066519,
		110,
		true
	},
	dorm3d_beach_switch = {
		1066629,
		106,
		true
	},
	dorm3d_AR_switch = {
		1066735,
		123,
		true
	},
	dorm3d_invite_confirm_original = {
		1066858,
		207,
		true
	},
	dorm3d_invite_confirm_discount = {
		1067065,
		229,
		true
	},
	dorm3d_invite_confirm_free = {
		1067294,
		241,
		true
	},
	dorm3d_purchase_confirm_original = {
		1067535,
		188,
		true
	},
	dorm3d_purchase_confirm_discount = {
		1067723,
		209,
		true
	},
	dorm3d_purchase_confirm_free = {
		1067932,
		215,
		true
	},
	dorm3d_purchase_confirm_tip = {
		1068147,
		96,
		true
	},
	dorm3d_purchase_label_special = {
		1068243,
		102,
		true
	},
	dorm3d_purchase_outtime = {
		1068345,
		111,
		true
	},
	dorm3d_collect_block_by_furniture = {
		1068456,
		160,
		true
	},
	cruise_phase_title = {
		1068616,
		87,
		true
	},
	cruise_title_2410 = {
		1068703,
		100,
		true
	},
	cruise_title_2412 = {
		1068803,
		106,
		true
	},
	cruise_title_2502 = {
		1068909,
		106,
		true
	},
	cruise_title_2504 = {
		1069015,
		106,
		true
	},
	cruise_title_2506 = {
		1069121,
		106,
		true
	},
	cruise_title_2508 = {
		1069227,
		100,
		true
	},
	cruise_title_2510 = {
		1069327,
		100,
		true
	},
	cruise_title_2406 = {
		1069427,
		102,
		true
	},
	battlepass_main_time_title = {
		1069529,
		105,
		true
	},
	cruise_shop_no_open = {
		1069634,
		109,
		true
	},
	cruise_btn_pay = {
		1069743,
		98,
		true
	},
	cruise_btn_all = {
		1069841,
		87,
		true
	},
	task_go = {
		1069928,
		78,
		true
	},
	task_got = {
		1070006,
		81,
		true
	},
	cruise_shop_title_skin = {
		1070087,
		90,
		true
	},
	cruise_shop_title_equip_skin = {
		1070177,
		101,
		true
	},
	cruise_shop_lock_tip = {
		1070278,
		120,
		true
	},
	cruise_tip_skin = {
		1070398,
		96,
		true
	},
	cruise_tip_base = {
		1070494,
		95,
		true
	},
	cruise_tip_upgrade = {
		1070589,
		99,
		true
	},
	cruise_shop_limit_tip = {
		1070688,
		104,
		true
	},
	cruise_limit_count = {
		1070792,
		126,
		true
	},
	cruise_title_2408 = {
		1070918,
		100,
		true
	},
	cruise_shop_title = {
		1071018,
		95,
		true
	},
	dorm3d_favor_level_story = {
		1071113,
		101,
		true
	},
	dorm3d_already_gifted = {
		1071214,
		98,
		true
	},
	dorm3d_story_unlock_tip = {
		1071312,
		101,
		true
	},
	dorm3d_skin_locked = {
		1071413,
		100,
		true
	},
	dorm3d_photo_no_role = {
		1071513,
		105,
		true
	},
	dorm3d_furniture_locked = {
		1071618,
		108,
		true
	},
	dorm3d_accompany_locked = {
		1071726,
		98,
		true
	},
	dorm3d_role_locked = {
		1071824,
		151,
		true
	},
	dorm3d_volleyball_button = {
		1071975,
		104,
		true
	},
	dorm3d_minigame_button1 = {
		1072079,
		95,
		true
	},
	dorm3d_collection_title_en = {
		1072174,
		99,
		true
	},
	dorm3d_collection_cost_tip = {
		1072273,
		182,
		true
	},
	dorm3d_gift_story_unlock = {
		1072455,
		110,
		true
	},
	dorm3d_furniture_replace_tip = {
		1072565,
		117,
		true
	},
	dorm3d_recall_locked = {
		1072682,
		96,
		true
	},
	dorm3d_gift_maximum = {
		1072778,
		110,
		true
	},
	dorm3d_need_construct_item = {
		1072888,
		111,
		true
	},
	AR_plane_check = {
		1072999,
		108,
		true
	},
	AR_plane_long_press_to_summon = {
		1073107,
		148,
		true
	},
	AR_plane_distance_near = {
		1073255,
		157,
		true
	},
	AR_plane_summon_fail_by_near = {
		1073412,
		140,
		true
	},
	AR_plane_summon_success = {
		1073552,
		105,
		true
	},
	dorm3d_day_night_switching1 = {
		1073657,
		118,
		true
	},
	dorm3d_day_night_switching2 = {
		1073775,
		120,
		true
	},
	dorm3d_download_complete = {
		1073895,
		105,
		true
	},
	dorm3d_resource_downloading = {
		1074000,
		109,
		true
	},
	dorm3d_resource_delete = {
		1074109,
		100,
		true
	},
	dorm3d_favor_maximize = {
		1074209,
		122,
		true
	},
	dorm3d_purchase_weekly_limit = {
		1074331,
		116,
		true
	},
	child2_cur_round = {
		1074447,
		87,
		true
	},
	child2_assess_round = {
		1074534,
		110,
		true
	},
	child2_assess_target = {
		1074644,
		100,
		true
	},
	child2_ending_stage = {
		1074744,
		95,
		true
	},
	child2_reset_stage = {
		1074839,
		86,
		true
	},
	child2_main_help = {
		1074925,
		588,
		true
	},
	child2_personality_title = {
		1075513,
		99,
		true
	},
	child2_attr_title = {
		1075612,
		86,
		true
	},
	child2_talent_title = {
		1075698,
		90,
		true
	},
	child2_status_title = {
		1075788,
		89,
		true
	},
	child2_talent_unlock_tip = {
		1075877,
		106,
		true
	},
	child2_status_time1 = {
		1075983,
		90,
		true
	},
	child2_status_time2 = {
		1076073,
		92,
		true
	},
	child2_assess_tip = {
		1076165,
		136,
		true
	},
	child2_assess_tip_target = {
		1076301,
		135,
		true
	},
	child2_site_exit = {
		1076436,
		85,
		true
	},
	child2_shop_limit_cnt = {
		1076521,
		92,
		true
	},
	child2_unlock_site_round = {
		1076613,
		133,
		true
	},
	child2_site_drop_add = {
		1076746,
		123,
		true
	},
	child2_site_drop_reduce = {
		1076869,
		126,
		true
	},
	child2_site_drop_item = {
		1076995,
		105,
		true
	},
	child2_personal_id1_tag1 = {
		1077100,
		92,
		true
	},
	child2_personal_id1_tag2 = {
		1077192,
		98,
		true
	},
	child2_personal_change = {
		1077290,
		104,
		true
	},
	child2_ship_upgrade_favor = {
		1077394,
		132,
		true
	},
	child2_plan_title_front = {
		1077526,
		91,
		true
	},
	child2_plan_title_back = {
		1077617,
		86,
		true
	},
	child2_plan_upgrade_condition = {
		1077703,
		116,
		true
	},
	child2_endings_toggle_on = {
		1077819,
		100,
		true
	},
	child2_endings_toggle_off = {
		1077919,
		111,
		true
	},
	child2_game_cnt = {
		1078030,
		89,
		true
	},
	child2_enter = {
		1078119,
		89,
		true
	},
	child2_select_help = {
		1078208,
		529,
		true
	},
	child2_not_start = {
		1078737,
		103,
		true
	},
	child2_schedule_sure_tip = {
		1078840,
		152,
		true
	},
	child2_reset_sure_tip = {
		1078992,
		153,
		true
	},
	child2_schedule_sure_tip2 = {
		1079145,
		154,
		true
	},
	child2_schedule_sure_tip3 = {
		1079299,
		178,
		true
	},
	child2_assess_start_tip = {
		1079477,
		103,
		true
	},
	child2_site_again = {
		1079580,
		86,
		true
	},
	child2_shop_benefit_sure = {
		1079666,
		209,
		true
	},
	child2_shop_benefit_sure2 = {
		1079875,
		188,
		true
	},
	world_file_tip = {
		1080063,
		157,
		true
	},
	levelscene_mapselect_part1 = {
		1080220,
		96,
		true
	},
	levelscene_mapselect_part2 = {
		1080316,
		96,
		true
	},
	levelscene_mapselect_sp = {
		1080412,
		89,
		true
	},
	levelscene_mapselect_tp = {
		1080501,
		89,
		true
	},
	levelscene_mapselect_ex = {
		1080590,
		89,
		true
	},
	levelscene_mapselect_normal = {
		1080679,
		97,
		true
	},
	levelscene_mapselect_advanced = {
		1080776,
		102,
		true
	},
	levelscene_mapselect_material = {
		1080878,
		102,
		true
	},
	levelscene_title_story = {
		1080980,
		94,
		true
	},
	juuschat_filter_title = {
		1081074,
		91,
		true
	},
	juuschat_filter_tip1 = {
		1081165,
		87,
		true
	},
	juuschat_filter_tip2 = {
		1081252,
		92,
		true
	},
	juuschat_filter_tip3 = {
		1081344,
		93,
		true
	},
	juuschat_filter_tip4 = {
		1081437,
		91,
		true
	},
	juuschat_filter_tip5 = {
		1081528,
		89,
		true
	},
	juuschat_label1 = {
		1081617,
		85,
		true
	},
	juuschat_label2 = {
		1081702,
		86,
		true
	},
	juuschat_chattip1 = {
		1081788,
		97,
		true
	},
	juuschat_chattip2 = {
		1081885,
		91,
		true
	},
	juuschat_chattip3 = {
		1081976,
		92,
		true
	},
	juuschat_reddot_title = {
		1082068,
		94,
		true
	},
	juuschat_filter_subtitle1 = {
		1082162,
		100,
		true
	},
	juuschat_filter_subtitle2 = {
		1082262,
		102,
		true
	},
	juuschat_filter_subtitle3 = {
		1082364,
		96,
		true
	},
	juuschat_redpacket_show_detail = {
		1082460,
		101,
		true
	},
	juuschat_redpacket_detail = {
		1082561,
		105,
		true
	},
	juuschat_filter_empty = {
		1082666,
		100,
		true
	},
	dorm3d_appellation_title = {
		1082766,
		103,
		true
	},
	dorm3d_appellation_cd = {
		1082869,
		130,
		true
	},
	dorm3d_appellation_interval = {
		1082999,
		141,
		true
	},
	dorm3d_appellation_waring1 = {
		1083140,
		131,
		true
	},
	dorm3d_appellation_waring2 = {
		1083271,
		116,
		true
	},
	dorm3d_appellation_waring3 = {
		1083387,
		117,
		true
	},
	dorm3d_appellation_waring4 = {
		1083504,
		133,
		true
	},
	dorm3d_shop_gift_owned = {
		1083637,
		123,
		true
	},
	dorm3d_accompany_not_download = {
		1083760,
		135,
		true
	},
	dorm3d_nengdai_minigame_day1 = {
		1083895,
		95,
		true
	},
	dorm3d_nengdai_minigame_day2 = {
		1083990,
		95,
		true
	},
	dorm3d_nengdai_minigame_day3 = {
		1084085,
		95,
		true
	},
	dorm3d_nengdai_minigame_day4 = {
		1084180,
		95,
		true
	},
	dorm3d_nengdai_minigame_day5 = {
		1084275,
		95,
		true
	},
	dorm3d_nengdai_minigame_day6 = {
		1084370,
		95,
		true
	},
	dorm3d_nengdai_minigame_day7 = {
		1084465,
		95,
		true
	},
	dorm3d_nengdai_minigame_remember = {
		1084560,
		122,
		true
	},
	dorm3d_nengdai_minigame_choose = {
		1084682,
		118,
		true
	},
	dorm3d_nengdai_minigame_behavior1 = {
		1084800,
		104,
		true
	},
	dorm3d_nengdai_minigame_behavior2 = {
		1084904,
		104,
		true
	},
	dorm3d_nengdai_minigame_behavior3 = {
		1085008,
		105,
		true
	},
	dorm3d_nengdai_minigame_behavior4 = {
		1085113,
		104,
		true
	},
	dorm3d_nengdai_minigame_behavior5 = {
		1085217,
		107,
		true
	},
	dorm3d_nengdai_minigame_behavior6 = {
		1085324,
		105,
		true
	},
	dorm3d_nengdai_minigame_behavior7 = {
		1085429,
		105,
		true
	},
	dorm3d_nengdai_minigame_behavior8 = {
		1085534,
		104,
		true
	},
	dorm3d_nengdai_minigame_behavior9 = {
		1085638,
		104,
		true
	},
	dorm3d_nengdai_minigame_behavior10 = {
		1085742,
		103,
		true
	},
	dorm3d_nengdai_minigame_behavior11 = {
		1085845,
		102,
		true
	},
	dorm3d_nengdai_minigame_behavior12 = {
		1085947,
		101,
		true
	},
	dorm3d_nengdai_minigame_evaluate1 = {
		1086048,
		103,
		true
	},
	dorm3d_nengdai_minigame_evaluate2 = {
		1086151,
		107,
		true
	},
	dorm3d_nengdai_minigame_evaluate3 = {
		1086258,
		104,
		true
	},
	dorm3d_nengdai_minigame_evaluate4 = {
		1086362,
		102,
		true
	},
	dorm3d_nengdai_minigame_evaluate5 = {
		1086464,
		105,
		true
	},
	BoatAdGame_minigame_help = {
		1086569,
		311,
		true
	},
	activity_1024_memory = {
		1086880,
		155,
		true
	},
	activity_1024_memory_get = {
		1087035,
		99,
		true
	},
	juuschat_background_tip1 = {
		1087134,
		97,
		true
	},
	juuschat_background_tip2 = {
		1087231,
		112,
		true
	},
	drom3d_memory_limit_tip = {
		1087343,
		182,
		true
	},
	drom3d_beach_memory_limit_tip = {
		1087525,
		216,
		true
	},
	blackfriday_main_tip = {
		1087741,
		542,
		true
	},
	blackfriday_shop_tip = {
		1088283,
		103,
		true
	},
	tolovegame_buff_name_1 = {
		1088386,
		98,
		true
	},
	tolovegame_buff_name_2 = {
		1088484,
		97,
		true
	},
	tolovegame_buff_name_3 = {
		1088581,
		102,
		true
	},
	tolovegame_buff_name_4 = {
		1088683,
		103,
		true
	},
	tolovegame_buff_name_5 = {
		1088786,
		102,
		true
	},
	tolovegame_buff_name_6 = {
		1088888,
		107,
		true
	},
	tolovegame_buff_name_7 = {
		1088995,
		95,
		true
	},
	tolovegame_buff_desc_1 = {
		1089090,
		177,
		true
	},
	tolovegame_buff_desc_2 = {
		1089267,
		132,
		true
	},
	tolovegame_buff_desc_3 = {
		1089399,
		123,
		true
	},
	tolovegame_buff_desc_4 = {
		1089522,
		276,
		true
	},
	tolovegame_buff_desc_5 = {
		1089798,
		213,
		true
	},
	tolovegame_buff_desc_6 = {
		1090011,
		206,
		true
	},
	tolovegame_buff_desc_7 = {
		1090217,
		221,
		true
	},
	tolovegame_join_reward = {
		1090438,
		93,
		true
	},
	tolovegame_score = {
		1090531,
		85,
		true
	},
	tolovegame_rank_tip = {
		1090616,
		118,
		true
	},
	tolovegame_lock_1 = {
		1090734,
		116,
		true
	},
	tolovegame_lock_2 = {
		1090850,
		102,
		true
	},
	tolovegame_buff_switch_1 = {
		1090952,
		102,
		true
	},
	tolovegame_buff_switch_2 = {
		1091054,
		104,
		true
	},
	tolovegame_proceed = {
		1091158,
		89,
		true
	},
	tolovegame_collect = {
		1091247,
		88,
		true
	},
	tolovegame_collected = {
		1091335,
		91,
		true
	},
	tolovegame_tutorial = {
		1091426,
		635,
		true
	},
	tolovegame_awards = {
		1092061,
		88,
		true
	},
	tolovemainpage_skin_countdown = {
		1092149,
		111,
		true
	},
	tolovemainpage_build_countdown = {
		1092260,
		105,
		true
	},
	tolovegame_puzzle_title = {
		1092365,
		107,
		true
	},
	tolovegame_puzzle_ship_need = {
		1092472,
		106,
		true
	},
	tolovegame_puzzle_task_need = {
		1092578,
		108,
		true
	},
	tolovegame_puzzle_detail_collect = {
		1092686,
		113,
		true
	},
	tolovegame_puzzle_detail_puzzle = {
		1092799,
		109,
		true
	},
	tolovegame_puzzle_detail_connection = {
		1092908,
		117,
		true
	},
	tolovegame_puzzle_ship_unknown = {
		1093025,
		97,
		true
	},
	tolovegame_puzzle_lock_by_front = {
		1093122,
		138,
		true
	},
	tolovegame_puzzle_lock_by_time = {
		1093260,
		130,
		true
	},
	tolovegame_puzzle_cheat = {
		1093390,
		114,
		true
	},
	tolovegame_puzzle_open_detail = {
		1093504,
		109,
		true
	},
	tolove_main_help = {
		1093613,
		1464,
		true
	},
	tolovegame_puzzle_finished = {
		1095077,
		99,
		true
	},
	tolovegame_puzzle_title_desc = {
		1095176,
		112,
		true
	},
	tolovegame_puzzle_pop_next = {
		1095288,
		94,
		true
	},
	tolovegame_puzzle_pop_finish = {
		1095382,
		100,
		true
	},
	tolovegame_puzzle_pop_save = {
		1095482,
		107,
		true
	},
	tolovegame_puzzle_unlock = {
		1095589,
		95,
		true
	},
	tolovegame_puzzle_lock = {
		1095684,
		101,
		true
	},
	tolovegame_puzzle_line_tip = {
		1095785,
		125,
		true
	},
	tolovegame_puzzle_puzzle_tip = {
		1095910,
		144,
		true
	},
	maintenance_message_text = {
		1096054,
		255,
		true
	},
	maintenance_message_stop_text = {
		1096309,
		105,
		true
	},
	task_get = {
		1096414,
		79,
		true
	},
	notify_clock_tip = {
		1096493,
		80,
		true
	},
	notify_clock_button = {
		1096573,
		83,
		true
	},
	skin_shop_nonuse_label = {
		1096656,
		107,
		true
	},
	skin_shop_use_label = {
		1096763,
		97,
		true
	},
	skin_shop_discount_item_link = {
		1096860,
		158,
		true
	},
	help_starLightAlbum = {
		1097018,
		940,
		true
	},
	word_gain_date = {
		1097958,
		92,
		true
	},
	word_limited_activity = {
		1098050,
		90,
		true
	},
	word_show_expire_content = {
		1098140,
		105,
		true
	},
	word_got_pt = {
		1098245,
		82,
		true
	},
	word_activity_not_open = {
		1098327,
		103,
		true
	},
	activity_shop_template_normaltext = {
		1098430,
		122,
		true
	},
	activity_shop_template_extratext = {
		1098552,
		121,
		true
	},
	dorm3d_now_is_downloading = {
		1098673,
		110,
		true
	},
	dorm3d_resource_download_complete = {
		1098783,
		115,
		true
	},
	dorm3d_delete_finish = {
		1098898,
		96,
		true
	},
	dorm3d_guide_tip = {
		1098994,
		107,
		true
	},
	dorm3d_guide_tip2 = {
		1099101,
		107,
		true
	},
	dorm3d_noshiro_table = {
		1099208,
		95,
		true
	},
	dorm3d_noshiro_chair = {
		1099303,
		95,
		true
	},
	dorm3d_noshiro_bed = {
		1099398,
		89,
		true
	},
	dorm3d_guide_beach_tip = {
		1099487,
		148,
		true
	},
	dorm3d_Ankeleiqi_entertainmentarea = {
		1099635,
		112,
		true
	},
	dorm3d_Ankeleiqi_chair = {
		1099747,
		97,
		true
	},
	dorm3d_Ankeleiqi_bed = {
		1099844,
		91,
		true
	},
	dorm3d_xinzexi_table = {
		1099935,
		95,
		true
	},
	dorm3d_xinzexi_chair = {
		1100030,
		95,
		true
	},
	dorm3d_xinzexi_bed = {
		1100125,
		89,
		true
	},
	dorm3d_gift_favor_max = {
		1100214,
		194,
		true
	},
	dorm3d_VIDEO_CHAT_LABEL = {
		1100408,
		102,
		true
	},
	dorm3d_VIDEO_TELEPHONE_LABEL = {
		1100510,
		104,
		true
	},
	dorm3d_privatechat_favor = {
		1100614,
		96,
		true
	},
	dorm3d_privatechat_furniture = {
		1100710,
		101,
		true
	},
	dorm3d_privatechat_visit = {
		1100811,
		98,
		true
	},
	dorm3d_privatechat_visit_time = {
		1100909,
		106,
		true
	},
	dorm3d_privatechat_no_visit_time = {
		1101015,
		102,
		true
	},
	dorm3d_privatechat_gift = {
		1101117,
		92,
		true
	},
	dorm3d_privatechat_chat = {
		1101209,
		95,
		true
	},
	dorm3d_privatechat_nonew_messages = {
		1101304,
		109,
		true
	},
	dorm3d_privatechat_new_messages = {
		1101413,
		106,
		true
	},
	dorm3d_privatechat_phone = {
		1101519,
		98,
		true
	},
	dorm3d_privatechat_new_calls = {
		1101617,
		101,
		true
	},
	dorm3d_privatechat_nonew_calls = {
		1101718,
		105,
		true
	},
	dorm3d_privatechat_topics = {
		1101823,
		99,
		true
	},
	dorm3d_privatechat_ins = {
		1101922,
		96,
		true
	},
	dorm3d_privatechat_new_topics = {
		1102018,
		110,
		true
	},
	dorm3d_privatechat_nonew_topics = {
		1102128,
		106,
		true
	},
	dorm3d_privatechat_room_beach = {
		1102234,
		163,
		true
	},
	dorm3d_privatechat_room_character = {
		1102397,
		116,
		true
	},
	dorm3d_privatechat_room_unlock = {
		1102513,
		132,
		true
	},
	dorm3d_privatechat_screen_all = {
		1102645,
		96,
		true
	},
	dorm3d_privatechat_screen_floor_1 = {
		1102741,
		107,
		true
	},
	dorm3d_privatechat_screen_floor_2 = {
		1102848,
		101,
		true
	},
	dorm3d_privatechat_visit_time_now = {
		1102949,
		102,
		true
	},
	dorm3d_privatechat_room_guide = {
		1103051,
		116,
		true
	},
	dorm3d_privatechat_room_download = {
		1103167,
		133,
		true
	},
	dorm3d_privatechat_telephone = {
		1103300,
		123,
		true
	},
	dorm3d_privatechat_welcome = {
		1103423,
		110,
		true
	},
	dorm3d_gift_favor_exceed = {
		1103533,
		184,
		true
	},
	dorm3d_privatechat_telephone_calllog = {
		1103717,
		118,
		true
	},
	dorm3d_privatechat_telephone_call = {
		1103835,
		107,
		true
	},
	dorm3d_privatechat_telephone_noviewed = {
		1103942,
		111,
		true
	},
	dorm3d_privatechat_video_call = {
		1104053,
		103,
		true
	},
	dorm3d_ins_no_msg = {
		1104156,
		92,
		true
	},
	dorm3d_ins_no_topics = {
		1104248,
		95,
		true
	},
	dorm3d_skin_confirm = {
		1104343,
		97,
		true
	},
	dorm3d_skin_already = {
		1104440,
		90,
		true
	},
	dorm3d_skin_equip = {
		1104530,
		96,
		true
	},
	dorm3d_skin_unlock = {
		1104626,
		125,
		true
	},
	dorm3d_room_floor_1 = {
		1104751,
		88,
		true
	},
	dorm3d_room_floor_2 = {
		1104839,
		87,
		true
	},
	please_input_1_99 = {
		1104926,
		108,
		true
	},
	child2_empty_plan = {
		1105034,
		94,
		true
	},
	child2_replay_tip = {
		1105128,
		229,
		true
	},
	child2_replay_clear = {
		1105357,
		89,
		true
	},
	child2_replay_continue = {
		1105446,
		94,
		true
	},
	firework_2025_level = {
		1105540,
		91,
		true
	},
	firework_2025_pt = {
		1105631,
		92,
		true
	},
	firework_2025_get = {
		1105723,
		90,
		true
	},
	firework_2025_got = {
		1105813,
		88,
		true
	},
	firework_2025_tip1 = {
		1105901,
		136,
		true
	},
	firework_2025_tip2 = {
		1106037,
		104,
		true
	},
	firework_2025_unlock_tip1 = {
		1106141,
		110,
		true
	},
	firework_2025_unlock_tip2 = {
		1106251,
		91,
		true
	},
	firework_2025_tip = {
		1106342,
		835,
		true
	},
	secretary_special_character_unlock = {
		1107177,
		171,
		true
	},
	secretary_special_character_buy_unlock = {
		1107348,
		210,
		true
	},
	child2_mood_desc1 = {
		1107558,
		149,
		true
	},
	child2_mood_desc2 = {
		1107707,
		143,
		true
	},
	child2_mood_desc3 = {
		1107850,
		123,
		true
	},
	child2_mood_desc4 = {
		1107973,
		145,
		true
	},
	child2_mood_desc5 = {
		1108118,
		145,
		true
	},
	child2_schedule_target = {
		1108263,
		102,
		true
	},
	child2_shop_point_sure = {
		1108365,
		177,
		true
	},
	["2025Valentine_minigame_s"] = {
		1108542,
		214,
		true
	},
	["2025Valentine_minigame_a"] = {
		1108756,
		224,
		true
	},
	["2025Valentine_minigame_b"] = {
		1108980,
		229,
		true
	},
	["2025Valentine_minigame_c"] = {
		1109209,
		214,
		true
	},
	rps_game_take_card = {
		1109423,
		94,
		true
	},
	SkinDiscountHelp_School = {
		1109517,
		656,
		true
	},
	SkinDiscountHelp_BlackFriday = {
		1110173,
		729,
		true
	},
	SkinDiscount_Hint = {
		1110902,
		158,
		true
	},
	SkinDiscount_Got = {
		1111060,
		89,
		true
	},
	skin_original_price = {
		1111149,
		93,
		true
	},
	SkinDiscount_Owned_Tips = {
		1111242,
		363,
		true
	},
	SkinDiscount_Last_Coupon = {
		1111605,
		257,
		true
	},
	clue_title_1 = {
		1111862,
		89,
		true
	},
	clue_title_2 = {
		1111951,
		90,
		true
	},
	clue_title_3 = {
		1112041,
		90,
		true
	},
	clue_title_4 = {
		1112131,
		81,
		true
	},
	clue_task_goto = {
		1112212,
		97,
		true
	},
	clue_lock_tip1 = {
		1112309,
		99,
		true
	},
	clue_lock_tip2 = {
		1112408,
		87,
		true
	},
	clue_get = {
		1112495,
		77,
		true
	},
	clue_got = {
		1112572,
		79,
		true
	},
	clue_unselect_tip = {
		1112651,
		133,
		true
	},
	clue_close_tip = {
		1112784,
		102,
		true
	},
	clue_pt_tip = {
		1112886,
		83,
		true
	},
	clue_buff_research = {
		1112969,
		89,
		true
	},
	clue_buff_pt_boost = {
		1113058,
		128,
		true
	},
	clue_buff_stage_loot = {
		1113186,
		97,
		true
	},
	clue_task_tip = {
		1113283,
		91,
		true
	},
	clue_buff_reach_max = {
		1113374,
		125,
		true
	},
	clue_buff_unselect = {
		1113499,
		116,
		true
	},
	ship_formationUI_fleetName_1 = {
		1113615,
		119,
		true
	},
	ship_formationUI_fleetName_2 = {
		1113734,
		120,
		true
	},
	ship_formationUI_fleetName_3 = {
		1113854,
		117,
		true
	},
	ship_formationUI_fleetName_4 = {
		1113971,
		116,
		true
	},
	ship_formationUI_fleetName_5 = {
		1114087,
		120,
		true
	},
	ship_formationUI_fleetName_6 = {
		1114207,
		121,
		true
	},
	ship_formationUI_fleetName_7 = {
		1114328,
		118,
		true
	},
	ship_formationUI_fleetName_8 = {
		1114446,
		117,
		true
	},
	ship_formationUI_fleetName_9 = {
		1114563,
		121,
		true
	},
	ship_formationUI_fleetName_10 = {
		1114684,
		123,
		true
	},
	ship_formationUI_fleetName_11 = {
		1114807,
		120,
		true
	},
	ship_formationUI_fleetName_12 = {
		1114927,
		119,
		true
	},
	ship_formationUI_fleetName_13 = {
		1115046,
		111,
		true
	},
	clue_buff_ticket_tips = {
		1115157,
		167,
		true
	},
	clue_buff_empty_ticket = {
		1115324,
		136,
		true
	},
	SuperBulin2_tip1 = {
		1115460,
		118,
		true
	},
	SuperBulin2_tip2 = {
		1115578,
		117,
		true
	},
	SuperBulin2_tip3 = {
		1115695,
		126,
		true
	},
	SuperBulin2_tip4 = {
		1115821,
		117,
		true
	},
	SuperBulin2_tip5 = {
		1115938,
		126,
		true
	},
	SuperBulin2_tip6 = {
		1116064,
		120,
		true
	},
	SuperBulin2_tip7 = {
		1116184,
		117,
		true
	},
	SuperBulin2_tip8 = {
		1116301,
		117,
		true
	},
	SuperBulin2_tip9 = {
		1116418,
		125,
		true
	},
	SuperBulin2_help = {
		1116543,
		513,
		true
	},
	SuperBulin2_lock_tip = {
		1117056,
		132,
		true
	},
	dorm3d_shop_buy_tips = {
		1117188,
		218,
		true
	},
	dorm3d_shop_title = {
		1117406,
		94,
		true
	},
	dorm3d_shop_limit = {
		1117500,
		88,
		true
	},
	dorm3d_shop_sold_out = {
		1117588,
		92,
		true
	},
	dorm3d_shop_all = {
		1117680,
		82,
		true
	},
	dorm3d_shop_gift1 = {
		1117762,
		86,
		true
	},
	dorm3d_shop_furniture = {
		1117848,
		94,
		true
	},
	dorm3d_shop_others = {
		1117942,
		87,
		true
	},
	dorm3d_shop_limit1 = {
		1118029,
		96,
		true
	},
	dorm3d_cafe_minigame1 = {
		1118125,
		105,
		true
	},
	dorm3d_cafe_minigame2 = {
		1118230,
		102,
		true
	},
	dorm3d_cafe_minigame3 = {
		1118332,
		97,
		true
	},
	dorm3d_cafe_minigame4 = {
		1118429,
		90,
		true
	},
	dorm3d_cafe_minigame5 = {
		1118519,
		89,
		true
	},
	dorm3d_cafe_minigame6 = {
		1118608,
		94,
		true
	},
	xiaoankeleiqi_npc = {
		1118702,
		1518,
		true
	},
	island_name_too_long_or_too_short = {
		1120220,
		156,
		true
	},
	island_name_exist_special_word = {
		1120376,
		152,
		true
	},
	island_name_exist_ban_word = {
		1120528,
		145,
		true
	},
	grapihcs3d_setting_enable_gup_driver = {
		1120673,
		112,
		true
	},
	grapihcs3d_setting_resolution = {
		1120785,
		107,
		true
	},
	grapihcs3d_setting_resolution_optionname0 = {
		1120892,
		109,
		true
	},
	grapihcs3d_setting_resolution_optionname1 = {
		1121001,
		110,
		true
	},
	grapihcs3d_setting_resolution_optionname2 = {
		1121111,
		107,
		true
	},
	grapihcs3d_setting_rendering_quality = {
		1121218,
		117,
		true
	},
	grapihcs3d_setting_rendering_quality_optionname0 = {
		1121335,
		115,
		true
	},
	grapihcs3d_setting_rendering_quality_optionname1 = {
		1121450,
		116,
		true
	},
	grapihcs3d_setting_shader_quality = {
		1121566,
		111,
		true
	},
	grapihcs3d_setting_shader_quality_optionname0 = {
		1121677,
		112,
		true
	},
	grapihcs3d_setting_shader_quality_optionname1 = {
		1121789,
		113,
		true
	},
	grapihcs3d_setting_shadow_quality = {
		1121902,
		111,
		true
	},
	grapihcs3d_setting_shadow_quality_optionname0 = {
		1122013,
		112,
		true
	},
	grapihcs3d_setting_shadow_quality_optionname1 = {
		1122125,
		112,
		true
	},
	grapihcs3d_setting_shadow_quality_optionname2 = {
		1122237,
		115,
		true
	},
	grapihcs3d_setting_shadow_quality_optionname3 = {
		1122352,
		113,
		true
	},
	grapihcs3d_setting_shadow_update_mode = {
		1122465,
		125,
		true
	},
	grapihcs3d_setting_shadow_update_mode_optionname0 = {
		1122590,
		116,
		true
	},
	grapihcs3d_setting_shadow_update_mode_optionname1 = {
		1122706,
		119,
		true
	},
	grapihcs3d_setting_shadow_update_mode_optionname2 = {
		1122825,
		117,
		true
	},
	grapihcs3d_setting_shadow_update_mode_optionname3 = {
		1122942,
		122,
		true
	},
	grapihcs3d_setting_terrain_layer_quality = {
		1123064,
		125,
		true
	},
	grapihcs3d_setting_terrain_layer_quality_optionname0 = {
		1123189,
		119,
		true
	},
	grapihcs3d_setting_terrain_layer_quality_optionname1 = {
		1123308,
		122,
		true
	},
	grapihcs3d_setting_terrain_layer_quality_optionname2 = {
		1123430,
		120,
		true
	},
	grapihcs3d_setting_enable_additional_lights = {
		1123550,
		121,
		true
	},
	grapihcs3d_setting_enable_reflection = {
		1123671,
		110,
		true
	},
	grapihcs3d_setting_character_quality = {
		1123781,
		123,
		true
	},
	grapihcs3d_setting_character_quality_optionname0 = {
		1123904,
		115,
		true
	},
	grapihcs3d_setting_character_quality_optionname1 = {
		1124019,
		118,
		true
	},
	grapihcs3d_setting_character_quality_optionname2 = {
		1124137,
		116,
		true
	},
	grapihcs3d_setting_enable_post_process = {
		1124253,
		117,
		true
	},
	grapihcs3d_setting_enable_post_antialiasing = {
		1124370,
		120,
		true
	},
	grapihcs3d_setting_enable_hdr = {
		1124490,
		96,
		true
	},
	grapihcs3d_setting_enable_distort = {
		1124586,
		107,
		true
	},
	grapihcs3d_setting_enable_dof = {
		1124693,
		107,
		true
	},
	grapihcs3d_setting_3Dquality = {
		1124800,
		100,
		true
	},
	grapihcs3d_setting_control = {
		1124900,
		98,
		true
	},
	grapihcs3d_setting_general = {
		1124998,
		105,
		true
	},
	grapihcs3d_setting_card_title = {
		1125103,
		100,
		true
	},
	grapihcs3d_setting_card_tag = {
		1125203,
		103,
		true
	},
	grapihcs3d_setting_card_socialdata = {
		1125306,
		110,
		true
	},
	grapihcs3d_setting_common_title = {
		1125416,
		118,
		true
	},
	grapihcs3d_setting_common_use = {
		1125534,
		96,
		true
	},
	grapihcs3d_setting_common_unstuck = {
		1125630,
		111,
		true
	},
	grapihcs3d_setting_common_unstuck_msgbox = {
		1125741,
		192,
		true
	},
	island_daily_gift_invite_success = {
		1125933,
		140,
		true
	},
	island_build_save_conflict = {
		1126073,
		104,
		true
	},
	island_build_save_success = {
		1126177,
		108,
		true
	},
	island_build_capacity_tip = {
		1126285,
		135,
		true
	},
	island_build_clean_tip = {
		1126420,
		138,
		true
	},
	island_build_revert_tip = {
		1126558,
		146,
		true
	},
	island_dress_exit = {
		1126704,
		120,
		true
	},
	island_dress_exit2 = {
		1126824,
		116,
		true
	},
	island_dress_mutually_exclusive = {
		1126940,
		166,
		true
	},
	island_dress_skin_buy = {
		1127106,
		117,
		true
	},
	island_dress_color_buy = {
		1127223,
		130,
		true
	},
	island_dress_color_unlock = {
		1127353,
		103,
		true
	},
	island_dress_save1 = {
		1127456,
		87,
		true
	},
	island_dress_save2 = {
		1127543,
		123,
		true
	},
	island_dress_mutually_exclusive1 = {
		1127666,
		135,
		true
	},
	island_dress_send_tip = {
		1127801,
		113,
		true
	},
	island_dress_send_tip_success = {
		1127914,
		108,
		true
	},
	handbook_new_player_task_locked_by_section = {
		1128022,
		163,
		true
	},
	handbook_new_player_guide_locked_by_level = {
		1128185,
		135,
		true
	},
	handbook_task_locked_by_level = {
		1128320,
		122,
		true
	},
	handbook_task_locked_by_other_task = {
		1128442,
		149,
		true
	},
	handbook_task_locked_by_chapter = {
		1128591,
		132,
		true
	},
	handbook_name = {
		1128723,
		85,
		true
	},
	handbook_process = {
		1128808,
		91,
		true
	},
	handbook_claim = {
		1128899,
		85,
		true
	},
	handbook_finished = {
		1128984,
		90,
		true
	},
	handbook_unfinished = {
		1129074,
		128,
		true
	},
	handbook_gametip = {
		1129202,
		1607,
		true
	},
	handbook_research_confirm = {
		1130809,
		104,
		true
	},
	handbook_research_final_task_desc_locked = {
		1130913,
		184,
		true
	},
	handbook_research_final_task_btn_locked = {
		1131097,
		114,
		true
	},
	handbook_research_final_task_btn_claim = {
		1131211,
		107,
		true
	},
	handbook_research_final_task_btn_finished = {
		1131318,
		112,
		true
	},
	handbook_ur_double_check = {
		1131430,
		242,
		true
	},
	NewMusic_1 = {
		1131672,
		87,
		true
	},
	NewMusic_2 = {
		1131759,
		86,
		true
	},
	NewMusic_help = {
		1131845,
		286,
		true
	},
	NewMusic_3 = {
		1132131,
		111,
		true
	},
	NewMusic_4 = {
		1132242,
		112,
		true
	},
	NewMusic_5 = {
		1132354,
		83,
		true
	},
	NewMusic_6 = {
		1132437,
		80,
		true
	},
	NewMusic_7 = {
		1132517,
		100,
		true
	},
	holiday_tip_minigame1 = {
		1132617,
		98,
		true
	},
	holiday_tip_minigame2 = {
		1132715,
		94,
		true
	},
	holiday_tip_bath = {
		1132809,
		93,
		true
	},
	holiday_tip_collection = {
		1132902,
		91,
		true
	},
	holiday_tip_task = {
		1132993,
		88,
		true
	},
	holiday_tip_shop = {
		1133081,
		88,
		true
	},
	holiday_tip_trans = {
		1133169,
		95,
		true
	},
	holiday_tip_task_now = {
		1133264,
		96,
		true
	},
	holiday_tip_finish = {
		1133360,
		259,
		true
	},
	holiday_tip_trans_get = {
		1133619,
		137,
		true
	},
	holiday_tip_rebuild_not = {
		1133756,
		130,
		true
	},
	holiday_tip_trans_not = {
		1133886,
		127,
		true
	},
	holiday_tip_task_finish = {
		1134013,
		135,
		true
	},
	holiday_tip_trans_tip = {
		1134148,
		99,
		true
	},
	holiday_tip_trans_desc1 = {
		1134247,
		348,
		true
	},
	holiday_tip_trans_desc2 = {
		1134595,
		348,
		true
	},
	holiday_tip_gametip = {
		1134943,
		1181,
		true
	},
	holiday_tip_spring = {
		1136124,
		299,
		true
	},
	activity_holiday_function_lock = {
		1136423,
		134,
		true
	},
	storyline_chapter0 = {
		1136557,
		90,
		true
	},
	storyline_chapter1 = {
		1136647,
		91,
		true
	},
	storyline_chapter2 = {
		1136738,
		91,
		true
	},
	storyline_chapter3 = {
		1136829,
		91,
		true
	},
	storyline_chapter4 = {
		1136920,
		91,
		true
	},
	storyline_memorysearch1 = {
		1137011,
		99,
		true
	},
	storyline_memorysearch2 = {
		1137110,
		99,
		true
	},
	use_amount_prefix = {
		1137209,
		93,
		true
	},
	sure_exit_resolve_equip = {
		1137302,
		205,
		true
	},
	resolve_equip_tip = {
		1137507,
		153,
		true
	},
	resolve_equip_title = {
		1137660,
		92,
		true
	},
	tec_catchup_0 = {
		1137752,
		85,
		true
	},
	tec_catchup_confirm = {
		1137837,
		303,
		true
	},
	watermelon_minigame_help = {
		1138140,
		306,
		true
	},
	breakout_tip = {
		1138446,
		98,
		true
	},
	collection_book_lock_place = {
		1138544,
		107,
		true
	},
	collection_book_tag_1 = {
		1138651,
		101,
		true
	},
	collection_book_tag_2 = {
		1138752,
		97,
		true
	},
	collection_book_tag_3 = {
		1138849,
		103,
		true
	},
	challenge_minigame_unlock = {
		1138952,
		104,
		true
	},
	storyline_camp = {
		1139056,
		87,
		true
	},
	storyline_goto = {
		1139143,
		92,
		true
	},
	holiday_villa_locked = {
		1139235,
		162,
		true
	},
	tech_shadow_change_button_1 = {
		1139397,
		106,
		true
	},
	tech_shadow_change_button_2 = {
		1139503,
		111,
		true
	},
	tech_shadow_limit_text = {
		1139614,
		105,
		true
	},
	tech_shadow_commit_tip = {
		1139719,
		146,
		true
	},
	shadow_scene_name = {
		1139865,
		96,
		true
	},
	shadow_unlock_tip = {
		1139961,
		138,
		true
	},
	shadow_skin_change_success = {
		1140099,
		141,
		true
	},
	add_skin_secretary_ship = {
		1140240,
		108,
		true
	},
	add_skin_random_secretary_ship_list = {
		1140348,
		119,
		true
	},
	choose_secretary_change_to_this_ship = {
		1140467,
		121,
		true
	},
	random_ship_custom_mode_add_shadow_complete = {
		1140588,
		162,
		true
	},
	random_ship_custom_mode_remove_shadow_complete = {
		1140750,
		169,
		true
	},
	choose_secretary_change_title = {
		1140919,
		102,
		true
	},
	ship_random_secretary_tag = {
		1141021,
		105,
		true
	},
	projection_help = {
		1141126,
		280,
		true
	},
	littleaijier_npc = {
		1141406,
		1483,
		true
	},
	brs_main_tip = {
		1142889,
		131,
		true
	},
	brs_expedition_tip = {
		1143020,
		140,
		true
	},
	brs_dmact_tip = {
		1143160,
		92,
		true
	},
	brs_reward_tip_1 = {
		1143252,
		93,
		true
	},
	brs_reward_tip_2 = {
		1143345,
		82,
		true
	},
	dorm3d_dance_button = {
		1143427,
		88,
		true
	},
	dorm3d_collection_cafe = {
		1143515,
		91,
		true
	},
	zengke_series_help = {
		1143606,
		1395,
		true
	},
	zengke_series_pt = {
		1145001,
		85,
		true
	},
	zengke_series_pt_small = {
		1145086,
		91,
		true
	},
	zengke_series_rank = {
		1145177,
		89,
		true
	},
	zengke_series_rank_small = {
		1145266,
		95,
		true
	},
	zengke_series_task = {
		1145361,
		90,
		true
	},
	zengke_series_task_small = {
		1145451,
		96,
		true
	},
	zengke_series_confirm = {
		1145547,
		91,
		true
	},
	zengke_story_reward_count = {
		1145638,
		142,
		true
	},
	zengke_series_easy = {
		1145780,
		86,
		true
	},
	zengke_series_normal = {
		1145866,
		90,
		true
	},
	zengke_series_hard = {
		1145956,
		86,
		true
	},
	zengke_series_sp = {
		1146042,
		82,
		true
	},
	zengke_series_ex = {
		1146124,
		82,
		true
	},
	zengke_series_ex_confirm = {
		1146206,
		94,
		true
	},
	battleui_display1 = {
		1146300,
		85,
		true
	},
	battleui_display2 = {
		1146385,
		87,
		true
	},
	battleui_display3 = {
		1146472,
		90,
		true
	},
	zengke_series_serverinfo = {
		1146562,
		95,
		true
	},
	grapihcs3d_setting_bloom = {
		1146657,
		102,
		true
	},
	grapihcs3d_setting_bloom_optionname0 = {
		1146759,
		104,
		true
	},
	grapihcs3d_setting_bloom_optionname1 = {
		1146863,
		103,
		true
	},
	SkinDiscountHelp_Carnival = {
		1146966,
		707,
		true
	},
	open_today = {
		1147673,
		85,
		true
	},
	daily_level_go = {
		1147758,
		80,
		true
	},
	yumia_main_tip_1 = {
		1147838,
		85,
		true
	},
	yumia_main_tip_2 = {
		1147923,
		86,
		true
	},
	yumia_main_tip_3 = {
		1148009,
		85,
		true
	},
	yumia_main_tip_4 = {
		1148094,
		127,
		true
	},
	yumia_main_tip_5 = {
		1148221,
		85,
		true
	},
	yumia_main_tip_6 = {
		1148306,
		93,
		true
	},
	yumia_main_tip_7 = {
		1148399,
		87,
		true
	},
	yumia_main_tip_8 = {
		1148486,
		89,
		true
	},
	yumia_main_tip_9 = {
		1148575,
		91,
		true
	},
	yumia_base_name_1 = {
		1148666,
		98,
		true
	},
	yumia_base_name_2 = {
		1148764,
		100,
		true
	},
	yumia_base_name_3 = {
		1148864,
		98,
		true
	},
	yumia_stronghold_1 = {
		1148962,
		95,
		true
	},
	yumia_stronghold_2 = {
		1149057,
		131,
		true
	},
	yumia_stronghold_3 = {
		1149188,
		93,
		true
	},
	yumia_stronghold_4 = {
		1149281,
		95,
		true
	},
	yumia_stronghold_5 = {
		1149376,
		97,
		true
	},
	yumia_stronghold_6 = {
		1149473,
		90,
		true
	},
	yumia_stronghold_7 = {
		1149563,
		90,
		true
	},
	yumia_stronghold_8 = {
		1149653,
		98,
		true
	},
	yumia_stronghold_9 = {
		1149751,
		88,
		true
	},
	yumia_stronghold_10 = {
		1149839,
		97,
		true
	},
	yumia_award_1 = {
		1149936,
		81,
		true
	},
	yumia_award_2 = {
		1150017,
		86,
		true
	},
	yumia_award_3 = {
		1150103,
		87,
		true
	},
	yumia_award_4 = {
		1150190,
		92,
		true
	},
	yumia_pt_1 = {
		1150282,
		161,
		true
	},
	yumia_pt_2 = {
		1150443,
		85,
		true
	},
	yumia_pt_3 = {
		1150528,
		82,
		true
	},
	yumia_mana_battle_tip = {
		1150610,
		221,
		true
	},
	yumia_buff_name_1 = {
		1150831,
		100,
		true
	},
	yumia_buff_name_2 = {
		1150931,
		94,
		true
	},
	yumia_buff_name_3 = {
		1151025,
		94,
		true
	},
	yumia_buff_name_4 = {
		1151119,
		94,
		true
	},
	yumia_buff_name_5 = {
		1151213,
		90,
		true
	},
	yumia_buff_desc_1 = {
		1151303,
		163,
		true
	},
	yumia_buff_desc_2 = {
		1151466,
		163,
		true
	},
	yumia_buff_desc_3 = {
		1151629,
		163,
		true
	},
	yumia_buff_desc_4 = {
		1151792,
		163,
		true
	},
	yumia_buff_desc_5 = {
		1151955,
		163,
		true
	},
	yumia_buff_1 = {
		1152118,
		92,
		true
	},
	yumia_buff_2 = {
		1152210,
		84,
		true
	},
	yumia_buff_3 = {
		1152294,
		85,
		true
	},
	yumia_buff_4 = {
		1152379,
		123,
		true
	},
	yumia_atelier_tip1 = {
		1152502,
		123,
		true
	},
	yumia_atelier_tip2 = {
		1152625,
		86,
		true
	},
	yumia_atelier_tip3 = {
		1152711,
		87,
		true
	},
	yumia_atelier_tip4 = {
		1152798,
		89,
		true
	},
	yumia_atelier_tip5 = {
		1152887,
		107,
		true
	},
	yumia_atelier_tip6 = {
		1152994,
		89,
		true
	},
	yumia_atelier_tip7 = {
		1153083,
		111,
		true
	},
	yumia_atelier_tip8 = {
		1153194,
		95,
		true
	},
	yumia_atelier_tip9 = {
		1153289,
		97,
		true
	},
	yumia_atelier_tip10 = {
		1153386,
		99,
		true
	},
	yumia_atelier_tip11 = {
		1153485,
		101,
		true
	},
	yumia_atelier_tip12 = {
		1153586,
		100,
		true
	},
	yumia_atelier_tip13 = {
		1153686,
		96,
		true
	},
	yumia_atelier_tip14 = {
		1153782,
		90,
		true
	},
	yumia_atelier_tip15 = {
		1153872,
		98,
		true
	},
	yumia_atelier_tip16 = {
		1153970,
		90,
		true
	},
	yumia_atelier_tip17 = {
		1154060,
		111,
		true
	},
	yumia_atelier_tip18 = {
		1154171,
		98,
		true
	},
	yumia_atelier_tip19 = {
		1154269,
		115,
		true
	},
	yumia_atelier_tip20 = {
		1154384,
		120,
		true
	},
	yumia_atelier_tip21 = {
		1154504,
		110,
		true
	},
	yumia_atelier_tip22 = {
		1154614,
		628,
		true
	},
	yumia_atelier_tip23 = {
		1155242,
		92,
		true
	},
	yumia_atelier_tip24 = {
		1155334,
		96,
		true
	},
	yumia_storymode_tip1 = {
		1155430,
		103,
		true
	},
	yumia_storymode_tip2 = {
		1155533,
		122,
		true
	},
	yumia_pt_tip = {
		1155655,
		81,
		true
	},
	yumia_pt_4 = {
		1155736,
		82,
		true
	},
	masaina_main_title = {
		1155818,
		102,
		true
	},
	masaina_main_title_en = {
		1155920,
		105,
		true
	},
	masaina_main_sheet1 = {
		1156025,
		93,
		true
	},
	masaina_main_sheet2 = {
		1156118,
		92,
		true
	},
	masaina_main_sheet3 = {
		1156210,
		90,
		true
	},
	masaina_main_sheet4 = {
		1156300,
		91,
		true
	},
	masaina_main_skin_tag = {
		1156391,
		93,
		true
	},
	masaina_main_other_tag = {
		1156484,
		97,
		true
	},
	shop_title = {
		1156581,
		78,
		true
	},
	shop_recommend = {
		1156659,
		81,
		true
	},
	shop_recommend_en = {
		1156740,
		84,
		true
	},
	shop_skin = {
		1156824,
		78,
		true
	},
	shop_skin_en = {
		1156902,
		81,
		true
	},
	shop_supply_prop = {
		1156983,
		86,
		true
	},
	shop_supply_prop_en = {
		1157069,
		89,
		true
	},
	shop_skin_new = {
		1157158,
		84,
		true
	},
	shop_skin_permanent = {
		1157242,
		90,
		true
	},
	shop_month = {
		1157332,
		81,
		true
	},
	shop_supply = {
		1157413,
		81,
		true
	},
	shop_activity = {
		1157494,
		91,
		true
	},
	shop_package_sort_0 = {
		1157585,
		86,
		true
	},
	shop_package_sort_en_0 = {
		1157671,
		89,
		true
	},
	shop_package_sort_1 = {
		1157760,
		97,
		true
	},
	shop_package_sort_en_1 = {
		1157857,
		100,
		true
	},
	shop_package_sort_2 = {
		1157957,
		88,
		true
	},
	shop_package_sort_en_2 = {
		1158045,
		91,
		true
	},
	shop_package_sort_3 = {
		1158136,
		85,
		true
	},
	shop_package_sort_en_3 = {
		1158221,
		88,
		true
	},
	shop_goods_left_day = {
		1158309,
		91,
		true
	},
	shop_goods_left_hour = {
		1158400,
		92,
		true
	},
	shop_goods_left_minute = {
		1158492,
		94,
		true
	},
	shop_refresh_time = {
		1158586,
		93,
		true
	},
	shop_side_lable_en = {
		1158679,
		91,
		true
	},
	street_shop_titleen = {
		1158770,
		87,
		true
	},
	military_shop_titleen = {
		1158857,
		90,
		true
	},
	guild_shop_titleen = {
		1158947,
		87,
		true
	},
	meta_shop_titleen = {
		1159034,
		85,
		true
	},
	mini_game_shop_titleen = {
		1159119,
		91,
		true
	},
	shop_item_unlock = {
		1159210,
		92,
		true
	},
	shop_item_unobtained = {
		1159302,
		94,
		true
	},
	beat_game_rule = {
		1159396,
		83,
		true
	},
	beat_game_rank = {
		1159479,
		85,
		true
	},
	beat_game_go = {
		1159564,
		78,
		true
	},
	beat_game_start = {
		1159642,
		89,
		true
	},
	beat_game_high_score = {
		1159731,
		94,
		true
	},
	beat_game_current_score = {
		1159825,
		100,
		true
	},
	beat_game_exit_desc = {
		1159925,
		142,
		true
	},
	musicbeat_minigame_help = {
		1160067,
		908,
		true
	},
	masaina_pt_claimed = {
		1160975,
		90,
		true
	},
	activity_shop_titleen = {
		1161065,
		90,
		true
	},
	shop_diamond_title_en = {
		1161155,
		89,
		true
	},
	shop_gift_title_en = {
		1161244,
		87,
		true
	},
	shop_item_title_en = {
		1161331,
		87,
		true
	},
	shop_pack_empty = {
		1161418,
		96,
		true
	},
	shop_new_unfound = {
		1161514,
		126,
		true
	},
	shop_new_shop = {
		1161640,
		81,
		true
	},
	shop_new_during_day = {
		1161721,
		91,
		true
	},
	shop_new_during_hour = {
		1161812,
		92,
		true
	},
	shop_new_during_minite = {
		1161904,
		94,
		true
	},
	shop_new_sort = {
		1161998,
		83,
		true
	},
	shop_new_search = {
		1162081,
		92,
		true
	},
	shop_new_purchased = {
		1162173,
		91,
		true
	},
	shop_new_purchase = {
		1162264,
		89,
		true
	},
	shop_new_claim = {
		1162353,
		85,
		true
	},
	shop_new_furniture = {
		1162438,
		96,
		true
	},
	shop_new_discount = {
		1162534,
		91,
		true
	},
	shop_new_try = {
		1162625,
		82,
		true
	},
	shop_new_gift = {
		1162707,
		81,
		true
	},
	shop_new_gem_transform = {
		1162788,
		122,
		true
	},
	shop_new_review = {
		1162910,
		84,
		true
	},
	shop_new_all = {
		1162994,
		79,
		true
	},
	shop_new_owned = {
		1163073,
		83,
		true
	},
	shop_new_havent_own = {
		1163156,
		90,
		true
	},
	shop_new_unused = {
		1163246,
		95,
		true
	},
	shop_new_type = {
		1163341,
		81,
		true
	},
	shop_new_static = {
		1163422,
		85,
		true
	},
	shop_new_dynamic = {
		1163507,
		87,
		true
	},
	shop_new_static_bg = {
		1163594,
		92,
		true
	},
	shop_new_dynamic_bg = {
		1163686,
		94,
		true
	},
	shop_new_bgm = {
		1163780,
		79,
		true
	},
	shop_new_index = {
		1163859,
		82,
		true
	},
	shop_new_ship_owned = {
		1163941,
		93,
		true
	},
	shop_new_ship_havent_owned = {
		1164034,
		102,
		true
	},
	shop_new_nation = {
		1164136,
		86,
		true
	},
	shop_new_rarity = {
		1164222,
		85,
		true
	},
	shop_new_category = {
		1164307,
		89,
		true
	},
	shop_new_skin_theme = {
		1164396,
		88,
		true
	},
	shop_new_confirm = {
		1164484,
		87,
		true
	},
	shop_new_during_time = {
		1164571,
		93,
		true
	},
	shop_new_daily = {
		1164664,
		83,
		true
	},
	shop_new_recommend = {
		1164747,
		85,
		true
	},
	shop_new_skin_shop = {
		1164832,
		87,
		true
	},
	shop_new_purchase_gem = {
		1164919,
		89,
		true
	},
	shop_new_akashi_recommend = {
		1165008,
		100,
		true
	},
	shop_new_packs = {
		1165108,
		83,
		true
	},
	shop_new_props = {
		1165191,
		83,
		true
	},
	shop_new_ptshop = {
		1165274,
		85,
		true
	},
	shop_new_skin_new = {
		1165359,
		88,
		true
	},
	shop_new_skin_permanent = {
		1165447,
		90,
		true
	},
	shop_new_in_use = {
		1165537,
		85,
		true
	},
	shop_new_unable_to_use = {
		1165622,
		94,
		true
	},
	shop_new_owned_skin = {
		1165716,
		88,
		true
	},
	shop_new_wear = {
		1165804,
		81,
		true
	},
	shop_new_get_now = {
		1165885,
		90,
		true
	},
	shop_new_remaining_time = {
		1165975,
		125,
		true
	},
	shop_new_remove = {
		1166100,
		95,
		true
	},
	shop_new_retro = {
		1166195,
		83,
		true
	},
	shop_new_able_to_exchange = {
		1166278,
		105,
		true
	},
	shop_countdown = {
		1166383,
		97,
		true
	},
	quota_shop_title1en = {
		1166480,
		83,
		true
	},
	sham_shop_titleen = {
		1166563,
		81,
		true
	},
	medal_shop_titleen = {
		1166644,
		82,
		true
	},
	fragment_shop_titleen = {
		1166726,
		85,
		true
	},
	shop_fragment_resolve = {
		1166811,
		103,
		true
	},
	beat_game_my_record = {
		1166914,
		90,
		true
	},
	shop_filter_all = {
		1167004,
		82,
		true
	},
	shop_filter_trial = {
		1167086,
		87,
		true
	},
	shop_filter_retro = {
		1167173,
		86,
		true
	},
	island_chara_invitename = {
		1167259,
		117,
		true
	},
	island_chara_totalname = {
		1167376,
		103,
		true
	},
	island_chara_totalname_en = {
		1167479,
		97,
		true
	},
	island_chara_power = {
		1167576,
		89,
		true
	},
	island_chara_attribute1 = {
		1167665,
		92,
		true
	},
	island_chara_attribute2 = {
		1167757,
		92,
		true
	},
	island_chara_attribute3 = {
		1167849,
		92,
		true
	},
	island_chara_attribute4 = {
		1167941,
		92,
		true
	},
	island_chara_attribute5 = {
		1168033,
		92,
		true
	},
	island_chara_attribute6 = {
		1168125,
		93,
		true
	},
	island_chara_skill_lock = {
		1168218,
		115,
		true
	},
	island_chara_list = {
		1168333,
		95,
		true
	},
	island_chara_list_filter = {
		1168428,
		94,
		true
	},
	island_chara_list_sort = {
		1168522,
		90,
		true
	},
	island_chara_list_level = {
		1168612,
		99,
		true
	},
	island_chara_list_attribute = {
		1168711,
		105,
		true
	},
	island_chara_list_workspeed = {
		1168816,
		101,
		true
	},
	island_index_name = {
		1168917,
		93,
		true
	},
	island_index_extra_all = {
		1169010,
		95,
		true
	},
	island_index_potency = {
		1169105,
		98,
		true
	},
	island_index_skill = {
		1169203,
		98,
		true
	},
	island_index_status = {
		1169301,
		89,
		true
	},
	island_confirm = {
		1169390,
		86,
		true
	},
	island_cancel = {
		1169476,
		83,
		true
	},
	island_chara_levelup = {
		1169559,
		92,
		true
	},
	islland_chara_material_consum = {
		1169651,
		106,
		true
	},
	island_chara_up_button = {
		1169757,
		94,
		true
	},
	island_chara_now_rank = {
		1169851,
		97,
		true
	},
	island_chara_breakout = {
		1169948,
		92,
		true
	},
	island_chara_skill_tip = {
		1170040,
		99,
		true
	},
	island_chara_consum = {
		1170139,
		88,
		true
	},
	island_chara_breakout_button = {
		1170227,
		99,
		true
	},
	island_chara_breakout_down = {
		1170326,
		98,
		true
	},
	island_chara_level_limit = {
		1170424,
		97,
		true
	},
	island_chara_power_limit = {
		1170521,
		99,
		true
	},
	island_click_to_close = {
		1170620,
		98,
		true
	},
	island_chara_skill_unlock = {
		1170718,
		103,
		true
	},
	island_chara_attribute_develop = {
		1170821,
		107,
		true
	},
	island_chara_choose_attribute = {
		1170928,
		115,
		true
	},
	island_chara_rating_up = {
		1171043,
		99,
		true
	},
	island_chara_limit_up = {
		1171142,
		96,
		true
	},
	island_chara_ceiling_unlock = {
		1171238,
		161,
		true
	},
	island_chara_choose_gift = {
		1171399,
		106,
		true
	},
	island_chara_buff_better = {
		1171505,
		142,
		true
	},
	island_chara_buff_nomal = {
		1171647,
		135,
		true
	},
	island_chara_gift_power = {
		1171782,
		107,
		true
	},
	island_visit_title = {
		1171889,
		87,
		true
	},
	island_visit_friend = {
		1171976,
		90,
		true
	},
	island_visit_teammate = {
		1172066,
		90,
		true
	},
	island_visit_code = {
		1172156,
		91,
		true
	},
	island_visit_search = {
		1172247,
		89,
		true
	},
	island_visit_whitelist = {
		1172336,
		95,
		true
	},
	island_visit_balcklist = {
		1172431,
		95,
		true
	},
	island_visit_set = {
		1172526,
		88,
		true
	},
	island_visit_delete = {
		1172614,
		89,
		true
	},
	island_visit_more = {
		1172703,
		85,
		true
	},
	island_visit_code_title = {
		1172788,
		97,
		true
	},
	island_visit_code_input = {
		1172885,
		97,
		true
	},
	island_visit_code_like = {
		1172982,
		101,
		true
	},
	island_visit_code_likelist = {
		1173083,
		104,
		true
	},
	island_visit_code_remove = {
		1173187,
		94,
		true
	},
	island_visit_code_copy = {
		1173281,
		90,
		true
	},
	island_visit_search_mineid = {
		1173371,
		93,
		true
	},
	island_visit_search_input = {
		1173464,
		105,
		true
	},
	island_visit_whitelist_tip = {
		1173569,
		153,
		true
	},
	island_visit_balcklist_tip = {
		1173722,
		152,
		true
	},
	island_visit_set_title = {
		1173874,
		107,
		true
	},
	island_visit_set_tip = {
		1173981,
		110,
		true
	},
	island_visit_set_refresh = {
		1174091,
		95,
		true
	},
	island_visit_set_close = {
		1174186,
		110,
		true
	},
	island_visit_set_help = {
		1174296,
		405,
		true
	},
	island_visitor_button = {
		1174701,
		90,
		true
	},
	island_visitor_status = {
		1174791,
		93,
		true
	},
	island_visitor_record = {
		1174884,
		94,
		true
	},
	island_visitor_num = {
		1174978,
		88,
		true
	},
	island_visitor_kick = {
		1175066,
		87,
		true
	},
	island_visitor_kickall = {
		1175153,
		94,
		true
	},
	island_visitor_close = {
		1175247,
		99,
		true
	},
	island_lineup_tip = {
		1175346,
		155,
		true
	},
	island_lineup_button = {
		1175501,
		96,
		true
	},
	island_visit_tip1 = {
		1175597,
		101,
		true
	},
	island_visit_tip2 = {
		1175698,
		117,
		true
	},
	island_visit_tip3 = {
		1175815,
		108,
		true
	},
	island_visit_tip4 = {
		1175923,
		113,
		true
	},
	island_visit_tip5 = {
		1176036,
		99,
		true
	},
	island_visit_tip6 = {
		1176135,
		102,
		true
	},
	island_visit_tip7 = {
		1176237,
		120,
		true
	},
	island_season_help = {
		1176357,
		972,
		true
	},
	island_season_title = {
		1177329,
		89,
		true
	},
	island_season_pt_hold = {
		1177418,
		93,
		true
	},
	island_season_pt_collectall = {
		1177511,
		101,
		true
	},
	island_season_activity = {
		1177612,
		91,
		true
	},
	island_season_pt = {
		1177703,
		96,
		true
	},
	island_season_task = {
		1177799,
		98,
		true
	},
	island_season_shop = {
		1177897,
		86,
		true
	},
	island_season_charts = {
		1177983,
		100,
		true
	},
	island_season_review = {
		1178083,
		90,
		true
	},
	island_season_task_collect = {
		1178173,
		95,
		true
	},
	island_season_task_collected = {
		1178268,
		99,
		true
	},
	island_season_task_collectall = {
		1178367,
		102,
		true
	},
	island_season_shop_stage1 = {
		1178469,
		96,
		true
	},
	island_season_shop_stage2 = {
		1178565,
		96,
		true
	},
	island_season_shop_stage3 = {
		1178661,
		96,
		true
	},
	island_season_charts_ranking = {
		1178757,
		108,
		true
	},
	island_season_charts_information = {
		1178865,
		107,
		true
	},
	island_season_charts_pt = {
		1178972,
		105,
		true
	},
	island_season_charts_award = {
		1179077,
		105,
		true
	},
	island_season_charts_level = {
		1179182,
		107,
		true
	},
	island_season_charts_refresh = {
		1179289,
		144,
		true
	},
	island_season_charts_out = {
		1179433,
		96,
		true
	},
	island_season_review_lv = {
		1179529,
		100,
		true
	},
	island_season_review_charnum = {
		1179629,
		109,
		true
	},
	island_season_review_projuctnum = {
		1179738,
		109,
		true
	},
	island_season_review_titleone = {
		1179847,
		99,
		true
	},
	island_season_review_ptnum = {
		1179946,
		93,
		true
	},
	island_season_review_ptrank = {
		1180039,
		107,
		true
	},
	island_season_review_produce = {
		1180146,
		113,
		true
	},
	island_season_review_ordernum = {
		1180259,
		104,
		true
	},
	island_season_review_formulanum = {
		1180363,
		103,
		true
	},
	island_season_review_relax = {
		1180466,
		101,
		true
	},
	island_season_review_fishnum = {
		1180567,
		100,
		true
	},
	island_season_review_gamenum = {
		1180667,
		106,
		true
	},
	island_season_review_achi = {
		1180773,
		100,
		true
	},
	island_season_review_achinum = {
		1180873,
		100,
		true
	},
	island_season_review_guidenum = {
		1180973,
		107,
		true
	},
	island_season_review_blank = {
		1181080,
		121,
		true
	},
	island_season_window_end = {
		1181201,
		113,
		true
	},
	island_season_window_end2 = {
		1181314,
		114,
		true
	},
	island_season_window_rule = {
		1181428,
		813,
		true
	},
	island_season_window_transformtip = {
		1182241,
		142,
		true
	},
	island_season_window_pt = {
		1182383,
		127,
		true
	},
	island_season_window_ranking = {
		1182510,
		105,
		true
	},
	island_season_window_award = {
		1182615,
		105,
		true
	},
	island_season_window_out = {
		1182720,
		98,
		true
	},
	island_season_review_miss = {
		1182818,
		134,
		true
	},
	island_season_reset = {
		1182952,
		109,
		true
	},
	island_help_ship_order = {
		1183061,
		568,
		true
	},
	island_help_farm = {
		1183629,
		295,
		true
	},
	island_help_commission = {
		1183924,
		503,
		true
	},
	island_help_cafe_minigame = {
		1184427,
		313,
		true
	},
	island_help_signin = {
		1184740,
		361,
		true
	},
	island_help_ranch = {
		1185101,
		358,
		true
	},
	island_help_manage = {
		1185459,
		544,
		true
	},
	island_help_combo = {
		1186003,
		358,
		true
	},
	island_help_friends = {
		1186361,
		364,
		true
	},
	island_help_season = {
		1186725,
		544,
		true
	},
	island_help_archive = {
		1187269,
		302,
		true
	},
	island_help_renovation = {
		1187571,
		373,
		true
	},
	island_help_photo = {
		1187944,
		298,
		true
	},
	island_help_greet = {
		1188242,
		358,
		true
	},
	island_help_character_info = {
		1188600,
		454,
		true
	},
	island_help_fish = {
		1189054,
		414,
		true
	},
	island_skin_original_desc = {
		1189468,
		96,
		true
	},
	island_dress_no_item = {
		1189564,
		118,
		true
	},
	island_agora_deco_empty = {
		1189682,
		97,
		true
	},
	island_agora_pos_unavailability = {
		1189779,
		109,
		true
	},
	island_agora_max_capacity = {
		1189888,
		113,
		true
	},
	island_agora_label_base = {
		1190001,
		94,
		true
	},
	island_agora_label_building = {
		1190095,
		95,
		true
	},
	island_agora_label_furniture = {
		1190190,
		103,
		true
	},
	island_agora_label_dec = {
		1190293,
		97,
		true
	},
	island_agora_label_floor = {
		1190390,
		94,
		true
	},
	island_agora_label_tile = {
		1190484,
		104,
		true
	},
	island_agora_label_collection = {
		1190588,
		103,
		true
	},
	island_agora_label_default = {
		1190691,
		97,
		true
	},
	island_agora_label_rarity = {
		1190788,
		95,
		true
	},
	island_agora_label_gettime = {
		1190883,
		103,
		true
	},
	island_agora_label_capacity = {
		1190986,
		99,
		true
	},
	island_agora_capacity = {
		1191085,
		99,
		true
	},
	island_agora_furniure_preview = {
		1191184,
		100,
		true
	},
	island_agora_function_unuse = {
		1191284,
		131,
		true
	},
	island_agora_signIn_tip = {
		1191415,
		146,
		true
	},
	island_agora_working = {
		1191561,
		109,
		true
	},
	island_agora_using = {
		1191670,
		88,
		true
	},
	island_agora_save_theme = {
		1191758,
		97,
		true
	},
	island_agora_btn_label_clear = {
		1191855,
		97,
		true
	},
	island_agora_btn_label_revert = {
		1191952,
		98,
		true
	},
	island_agora_btn_label_save = {
		1192050,
		95,
		true
	},
	island_agora_title = {
		1192145,
		101,
		true
	},
	island_agora_label_search = {
		1192246,
		102,
		true
	},
	island_agora_label_theme = {
		1192348,
		93,
		true
	},
	island_agora_label_empty_tip = {
		1192441,
		127,
		true
	},
	island_agora_clear_tip = {
		1192568,
		127,
		true
	},
	island_agora_revert_tip = {
		1192695,
		120,
		true
	},
	island_agora_save_or_exit_tip = {
		1192815,
		137,
		true
	},
	island_agora_exit_and_unsave = {
		1192952,
		104,
		true
	},
	island_agora_exit_and_save = {
		1193056,
		102,
		true
	},
	island_agora_no_pos_place = {
		1193158,
		121,
		true
	},
	island_agora_pave_tip = {
		1193279,
		110,
		true
	},
	island_enter_island_ban = {
		1193389,
		103,
		true
	},
	island_order_not_get_award = {
		1193492,
		113,
		true
	},
	island_order_cant_replace = {
		1193605,
		113,
		true
	},
	island_rename_tip = {
		1193718,
		134,
		true
	},
	island_rename_confirm = {
		1193852,
		126,
		true
	},
	island_bag_max_level = {
		1193978,
		102,
		true
	},
	island_bag_uprade_success = {
		1194080,
		105,
		true
	},
	island_agora_save_success = {
		1194185,
		108,
		true
	},
	island_agora_max_level = {
		1194293,
		104,
		true
	},
	island_white_list_full = {
		1194397,
		109,
		true
	},
	island_black_list_full = {
		1194506,
		109,
		true
	},
	island_inviteCode_refresh = {
		1194615,
		131,
		true
	},
	island_give_gift_success = {
		1194746,
		99,
		true
	},
	island_get_git_tip = {
		1194845,
		127,
		true
	},
	island_get_git_cnt_tip = {
		1194972,
		118,
		true
	},
	island_share_gift_success = {
		1195090,
		102,
		true
	},
	island_invitation_gift_success = {
		1195192,
		138,
		true
	},
	island_dectect_mode3x3 = {
		1195330,
		105,
		true
	},
	island_dectect_mode1x1 = {
		1195435,
		108,
		true
	},
	island_ship_buff_cover = {
		1195543,
		161,
		true
	},
	island_ship_buff_cover_1 = {
		1195704,
		163,
		true
	},
	island_ship_buff_cover_2 = {
		1195867,
		154,
		true
	},
	island_ship_buff_cover_3 = {
		1196021,
		154,
		true
	},
	island_log_visit = {
		1196175,
		104,
		true
	},
	island_log_exit = {
		1196279,
		100,
		true
	},
	island_log_gift = {
		1196379,
		116,
		true
	},
	island_log_trade = {
		1196495,
		111,
		true
	},
	island_item_type_res = {
		1196606,
		93,
		true
	},
	island_item_type_consume = {
		1196699,
		99,
		true
	},
	island_item_type_spe = {
		1196798,
		91,
		true
	},
	island_ship_attrName_1 = {
		1196889,
		91,
		true
	},
	island_ship_attrName_2 = {
		1196980,
		91,
		true
	},
	island_ship_attrName_3 = {
		1197071,
		91,
		true
	},
	island_ship_attrName_4 = {
		1197162,
		91,
		true
	},
	island_ship_attrName_5 = {
		1197253,
		91,
		true
	},
	island_ship_attrName_6 = {
		1197344,
		92,
		true
	},
	island_task_title = {
		1197436,
		97,
		true
	},
	island_task_title_en = {
		1197533,
		92,
		true
	},
	island_task_type_1 = {
		1197625,
		85,
		true
	},
	island_task_type_2 = {
		1197710,
		100,
		true
	},
	island_task_type_3 = {
		1197810,
		93,
		true
	},
	island_task_type_4 = {
		1197903,
		87,
		true
	},
	island_task_type_5 = {
		1197990,
		88,
		true
	},
	island_task_type_6 = {
		1198078,
		87,
		true
	},
	island_tech_type_1 = {
		1198165,
		97,
		true
	},
	island_default_name = {
		1198262,
		94,
		true
	},
	island_order_type_1 = {
		1198356,
		99,
		true
	},
	island_order_type_2 = {
		1198455,
		98,
		true
	},
	island_order_desc_1 = {
		1198553,
		148,
		true
	},
	island_order_desc_2 = {
		1198701,
		172,
		true
	},
	island_order_desc_3 = {
		1198873,
		173,
		true
	},
	island_order_difficulty_1 = {
		1199046,
		95,
		true
	},
	island_order_difficulty_2 = {
		1199141,
		93,
		true
	},
	island_order_difficulty_3 = {
		1199234,
		93,
		true
	},
	island_commander = {
		1199327,
		89,
		true
	},
	island_task_lefttime = {
		1199416,
		105,
		true
	},
	island_seek_game_tip = {
		1199521,
		117,
		true
	},
	island_item_transfer = {
		1199638,
		120,
		true
	},
	island_set_manifesto_success = {
		1199758,
		105,
		true
	},
	island_prosperity_level = {
		1199863,
		96,
		true
	},
	island_toast_status = {
		1199959,
		107,
		true
	},
	island_toast_level = {
		1200066,
		106,
		true
	},
	island_toast_ship = {
		1200172,
		107,
		true
	},
	island_lock_map_tip = {
		1200279,
		116,
		true
	},
	island_home_btn_cant_use = {
		1200395,
		127,
		true
	},
	island_item_overflow = {
		1200522,
		98,
		true
	},
	island_item_no_capacity = {
		1200620,
		104,
		true
	},
	island_ship_no_energy = {
		1200724,
		94,
		true
	},
	island_ship_working = {
		1200818,
		91,
		true
	},
	island_ship_level_limit = {
		1200909,
		98,
		true
	},
	island_ship_energy_limit = {
		1201007,
		97,
		true
	},
	island_click_close = {
		1201104,
		94,
		true
	},
	island_break_finish = {
		1201198,
		116,
		true
	},
	island_unlock_skill = {
		1201314,
		122,
		true
	},
	island_ship_title_info = {
		1201436,
		100,
		true
	},
	island_building_title_info = {
		1201536,
		102,
		true
	},
	island_word_effect = {
		1201638,
		89,
		true
	},
	island_word_dispatch = {
		1201727,
		95,
		true
	},
	island_word_working = {
		1201822,
		90,
		true
	},
	island_word_stop_work = {
		1201912,
		97,
		true
	},
	island_level_to_unlock = {
		1202009,
		113,
		true
	},
	island_select_product = {
		1202122,
		99,
		true
	},
	island_sub_product_cnt = {
		1202221,
		102,
		true
	},
	island_make_unlock_tip = {
		1202323,
		109,
		true
	},
	island_need_star = {
		1202432,
		109,
		true
	},
	island_need_star_1 = {
		1202541,
		105,
		true
	},
	island_select_ship = {
		1202646,
		98,
		true
	},
	island_select_ship_label_1 = {
		1202744,
		99,
		true
	},
	island_select_ship_overview = {
		1202843,
		100,
		true
	},
	island_select_ship_tip = {
		1202943,
		417,
		true
	},
	island_friend = {
		1203360,
		84,
		true
	},
	island_guild = {
		1203444,
		81,
		true
	},
	island_code = {
		1203525,
		85,
		true
	},
	island_search = {
		1203610,
		83,
		true
	},
	island_whiteList = {
		1203693,
		89,
		true
	},
	island_add_friend = {
		1203782,
		84,
		true
	},
	island_blackList = {
		1203866,
		89,
		true
	},
	island_settings = {
		1203955,
		87,
		true
	},
	island_settings_en = {
		1204042,
		90,
		true
	},
	island_btn_label_visit = {
		1204132,
		91,
		true
	},
	island_git_cnt_tip = {
		1204223,
		99,
		true
	},
	island_public_invitation = {
		1204322,
		101,
		true
	},
	island_onekey_invitation = {
		1204423,
		98,
		true
	},
	island_public_invitation_1 = {
		1204521,
		112,
		true
	},
	island_curr_visitor = {
		1204633,
		91,
		true
	},
	island_visitor_log = {
		1204724,
		91,
		true
	},
	island_kick_all = {
		1204815,
		87,
		true
	},
	island_close_visit = {
		1204902,
		94,
		true
	},
	island_curr_people_cnt = {
		1204996,
		95,
		true
	},
	island_close_access_state = {
		1205091,
		117,
		true
	},
	island_btn_label_remove = {
		1205208,
		93,
		true
	},
	island_btn_label_del = {
		1205301,
		90,
		true
	},
	island_btn_label_copy = {
		1205391,
		89,
		true
	},
	island_btn_label_more = {
		1205480,
		90,
		true
	},
	island_btn_label_invitation = {
		1205570,
		97,
		true
	},
	island_btn_label_invitation_already = {
		1205667,
		106,
		true
	},
	island_btn_label_online = {
		1205773,
		96,
		true
	},
	island_btn_label_kick = {
		1205869,
		89,
		true
	},
	island_btn_label_location = {
		1205958,
		107,
		true
	},
	island_black_list_tip = {
		1206065,
		128,
		true
	},
	island_white_list_tip = {
		1206193,
		162,
		true
	},
	island_input_code_tip = {
		1206355,
		95,
		true
	},
	island_input_code_tip_1 = {
		1206450,
		97,
		true
	},
	island_set_like = {
		1206547,
		94,
		true
	},
	island_input_code_erro = {
		1206641,
		106,
		true
	},
	island_code_exist = {
		1206747,
		106,
		true
	},
	island_like_title = {
		1206853,
		95,
		true
	},
	island_my_id = {
		1206948,
		85,
		true
	},
	island_input_my_id = {
		1207033,
		98,
		true
	},
	island_open_settings = {
		1207131,
		105,
		true
	},
	island_open_settings_tip1 = {
		1207236,
		134,
		true
	},
	island_open_settings_tip2 = {
		1207370,
		113,
		true
	},
	island_open_settings_tip3 = {
		1207483,
		409,
		true
	},
	island_code_refresh_cnt = {
		1207892,
		103,
		true
	},
	island_word_sort = {
		1207995,
		84,
		true
	},
	island_word_reset = {
		1208079,
		86,
		true
	},
	island_bag_title = {
		1208165,
		89,
		true
	},
	island_batch_covert = {
		1208254,
		96,
		true
	},
	island_total_price = {
		1208350,
		94,
		true
	},
	island_word_temp = {
		1208444,
		89,
		true
	},
	island_word_desc = {
		1208533,
		87,
		true
	},
	island_open_ship_tip = {
		1208620,
		132,
		true
	},
	island_bag_upgrade_tip = {
		1208752,
		111,
		true
	},
	island_bag_upgrade_req = {
		1208863,
		102,
		true
	},
	island_bag_upgrade_max_level = {
		1208965,
		110,
		true
	},
	island_bag_upgrade_capacity = {
		1209075,
		118,
		true
	},
	island_rename_title = {
		1209193,
		96,
		true
	},
	island_rename_input_tip = {
		1209289,
		104,
		true
	},
	island_rename_consutme_tip = {
		1209393,
		137,
		true
	},
	island_upgrade_preview = {
		1209530,
		102,
		true
	},
	island_upgrade_exp = {
		1209632,
		97,
		true
	},
	island_upgrade_res = {
		1209729,
		98,
		true
	},
	island_word_award = {
		1209827,
		88,
		true
	},
	island_word_unlock = {
		1209915,
		88,
		true
	},
	island_word_get = {
		1210003,
		85,
		true
	},
	island_prosperity_level_display = {
		1210088,
		121,
		true
	},
	island_prosperity_value_display = {
		1210209,
		115,
		true
	},
	island_rename_subtitle = {
		1210324,
		97,
		true
	},
	island_manage_title = {
		1210421,
		99,
		true
	},
	island_manage_sp_event = {
		1210520,
		100,
		true
	},
	island_manage_no_work = {
		1210620,
		92,
		true
	},
	island_manage_end_work = {
		1210712,
		95,
		true
	},
	island_manage_view = {
		1210807,
		89,
		true
	},
	island_manage_result = {
		1210896,
		96,
		true
	},
	island_manage_prepare = {
		1210992,
		95,
		true
	},
	island_manage_daily_cnt_tip = {
		1211087,
		99,
		true
	},
	island_manage_produce_tip = {
		1211186,
		120,
		true
	},
	island_manage_sel_worker = {
		1211306,
		100,
		true
	},
	island_manage_upgrade_worker_level = {
		1211406,
		128,
		true
	},
	island_manage_saleroom = {
		1211534,
		91,
		true
	},
	island_manage_capacity = {
		1211625,
		101,
		true
	},
	island_manage_skill_cant_use = {
		1211726,
		111,
		true
	},
	island_manage_predict_saleroom = {
		1211837,
		109,
		true
	},
	island_manage_cnt = {
		1211946,
		88,
		true
	},
	island_manage_addition = {
		1212034,
		95,
		true
	},
	island_manage_no_addition = {
		1212129,
		108,
		true
	},
	island_manage_auto_work = {
		1212237,
		98,
		true
	},
	island_manage_start_work = {
		1212335,
		98,
		true
	},
	island_manage_working = {
		1212433,
		92,
		true
	},
	island_manage_end_daily_work = {
		1212525,
		100,
		true
	},
	island_manage_attr_effect = {
		1212625,
		105,
		true
	},
	island_manage_need_ext = {
		1212730,
		96,
		true
	},
	island_manage_reach = {
		1212826,
		92,
		true
	},
	island_manage_slot = {
		1212918,
		92,
		true
	},
	island_manage_food_cnt = {
		1213010,
		99,
		true
	},
	island_manage_sale_ratio = {
		1213109,
		98,
		true
	},
	island_manage_worker_cnt = {
		1213207,
		93,
		true
	},
	island_manage_sale_daily = {
		1213300,
		99,
		true
	},
	island_manage_fake_price = {
		1213399,
		98,
		true
	},
	island_manage_real_price = {
		1213497,
		98,
		true
	},
	island_manage_result_1 = {
		1213595,
		97,
		true
	},
	island_manage_result_3 = {
		1213692,
		99,
		true
	},
	island_manage_word_cnt = {
		1213791,
		91,
		true
	},
	island_manage_shop_exp = {
		1213882,
		95,
		true
	},
	island_manage_help_tip = {
		1213977,
		417,
		true
	},
	island_manage_buff_tip = {
		1214394,
		190,
		true
	},
	island_word_go = {
		1214584,
		86,
		true
	},
	island_map_title = {
		1214670,
		90,
		true
	},
	island_label_furniture = {
		1214760,
		95,
		true
	},
	island_label_furniture_cnt = {
		1214855,
		96,
		true
	},
	island_label_furniture_capacity = {
		1214951,
		109,
		true
	},
	island_label_furniture_tip = {
		1215060,
		173,
		true
	},
	island_label_furniture_capacity_display = {
		1215233,
		124,
		true
	},
	island_label_furniture_exit = {
		1215357,
		97,
		true
	},
	island_label_furniture_save = {
		1215454,
		101,
		true
	},
	island_label_furniture_save_tip = {
		1215555,
		113,
		true
	},
	island_agora_extend = {
		1215668,
		89,
		true
	},
	island_agora_extend_consume = {
		1215757,
		110,
		true
	},
	island_agora_extend_capacity = {
		1215867,
		106,
		true
	},
	island_msg_info = {
		1215973,
		83,
		true
	},
	island_get_way = {
		1216056,
		88,
		true
	},
	island_own_cnt = {
		1216144,
		84,
		true
	},
	island_word_convert = {
		1216228,
		90,
		true
	},
	island_no_remind_today = {
		1216318,
		108,
		true
	},
	island_input_theme_name = {
		1216426,
		103,
		true
	},
	island_custom_theme_name = {
		1216529,
		103,
		true
	},
	island_custom_theme_name_tip = {
		1216632,
		120,
		true
	},
	island_skill_desc = {
		1216752,
		94,
		true
	},
	island_word_place = {
		1216846,
		86,
		true
	},
	island_word_turndown = {
		1216932,
		91,
		true
	},
	island_word_sbumit = {
		1217023,
		88,
		true
	},
	island_word_speedup = {
		1217111,
		91,
		true
	},
	island_order_cd_tip = {
		1217202,
		123,
		true
	},
	island_order_leftcnt_dispaly = {
		1217325,
		123,
		true
	},
	island_order_title = {
		1217448,
		94,
		true
	},
	island_order_difficulty = {
		1217542,
		105,
		true
	},
	island_order_leftCnt_tip = {
		1217647,
		108,
		true
	},
	island_order_get_label = {
		1217755,
		99,
		true
	},
	island_order_ship_working = {
		1217854,
		104,
		true
	},
	island_order_ship_end_work = {
		1217958,
		101,
		true
	},
	island_order_ship_worktime = {
		1218059,
		108,
		true
	},
	island_order_ship_unlock_tip = {
		1218167,
		123,
		true
	},
	island_order_ship_unlock_tip_2 = {
		1218290,
		101,
		true
	},
	island_order_ship_loadup_award = {
		1218391,
		110,
		true
	},
	island_order_ship_loadup = {
		1218501,
		94,
		true
	},
	island_order_ship_loadup_nores = {
		1218595,
		115,
		true
	},
	island_order_ship_page_req = {
		1218710,
		102,
		true
	},
	island_order_ship_page_award = {
		1218812,
		104,
		true
	},
	island_cancel_queue = {
		1218916,
		95,
		true
	},
	island_queue_display = {
		1219011,
		169,
		true
	},
	island_season_label = {
		1219180,
		92,
		true
	},
	island_first_season = {
		1219272,
		91,
		true
	},
	island_word_own = {
		1219363,
		88,
		true
	},
	island_ship_title1 = {
		1219451,
		95,
		true
	},
	island_ship_title2 = {
		1219546,
		95,
		true
	},
	island_ship_title3 = {
		1219641,
		93,
		true
	},
	island_ship_title4 = {
		1219734,
		98,
		true
	},
	island_ship_lock_attr_tip = {
		1219832,
		111,
		true
	},
	island_ship_unlock_limit_tip = {
		1219943,
		162,
		true
	},
	island_ship_breakout = {
		1220105,
		91,
		true
	},
	island_ship_breakout_consume = {
		1220196,
		97,
		true
	},
	island_ship_newskill_unlock = {
		1220293,
		104,
		true
	},
	island_word_give = {
		1220397,
		89,
		true
	},
	island_unlock_ship_skill_color = {
		1220486,
		133,
		true
	},
	island_dressup_tip = {
		1220619,
		144,
		true
	},
	island_dressup_titile = {
		1220763,
		92,
		true
	},
	island_dressup_tip_1 = {
		1220855,
		151,
		true
	},
	island_ship_energy = {
		1221006,
		90,
		true
	},
	island_ship_energy_full = {
		1221096,
		102,
		true
	},
	island_ship_energy_recoverytips = {
		1221198,
		110,
		true
	},
	island_word_ship_buff_desc = {
		1221308,
		97,
		true
	},
	island_word_ship_desc = {
		1221405,
		102,
		true
	},
	island_need_ship_level = {
		1221507,
		113,
		true
	},
	island_skill_consume_title = {
		1221620,
		103,
		true
	},
	island_select_ship_gift = {
		1221723,
		100,
		true
	},
	island_word_ship_enengy_recover = {
		1221823,
		111,
		true
	},
	island_word_ship_level_upgrade = {
		1221934,
		102,
		true
	},
	island_word_ship_level_upgrade_1 = {
		1222036,
		112,
		true
	},
	island_word_ship_rank = {
		1222148,
		97,
		true
	},
	island_task_open = {
		1222245,
		89,
		true
	},
	island_task_target = {
		1222334,
		89,
		true
	},
	island_task_award = {
		1222423,
		88,
		true
	},
	island_task_tracking = {
		1222511,
		90,
		true
	},
	island_task_tracked = {
		1222601,
		91,
		true
	},
	island_dev_level = {
		1222692,
		97,
		true
	},
	island_dev_level_tip = {
		1222789,
		194,
		true
	},
	island_invite_title = {
		1222983,
		110,
		true
	},
	island_technology_title = {
		1223093,
		106,
		true
	},
	island_tech_noauthority = {
		1223199,
		107,
		true
	},
	island_tech_unlock_need = {
		1223306,
		104,
		true
	},
	island_tech_unlock_dev = {
		1223410,
		101,
		true
	},
	island_tech_dev_start = {
		1223511,
		99,
		true
	},
	island_tech_dev_starting = {
		1223610,
		99,
		true
	},
	island_tech_dev_success = {
		1223709,
		104,
		true
	},
	island_tech_dev_finish = {
		1223813,
		96,
		true
	},
	island_tech_dev_finish_1 = {
		1223909,
		105,
		true
	},
	island_tech_dev_cost = {
		1224014,
		97,
		true
	},
	island_tech_detail_desctitle = {
		1224111,
		101,
		true
	},
	island_tech_detail_unlocktitle = {
		1224212,
		111,
		true
	},
	island_tech_nodev = {
		1224323,
		92,
		true
	},
	island_tech_can_get = {
		1224415,
		92,
		true
	},
	island_get_item_tip = {
		1224507,
		97,
		true
	},
	island_add_temp_bag = {
		1224604,
		146,
		true
	},
	island_buff_lasttime = {
		1224750,
		97,
		true
	},
	island_visit_off = {
		1224847,
		83,
		true
	},
	island_visit_on = {
		1224930,
		81,
		true
	},
	island_tech_unlock_tip = {
		1225011,
		116,
		true
	},
	island_tech_unlock_tip0 = {
		1225127,
		108,
		true
	},
	island_tech_unlock_tip1 = {
		1225235,
		116,
		true
	},
	island_tech_unlock_tip2 = {
		1225351,
		115,
		true
	},
	island_tech_unlock_tip3 = {
		1225466,
		121,
		true
	},
	island_tech_no_slot = {
		1225587,
		110,
		true
	},
	island_tech_lock = {
		1225697,
		86,
		true
	},
	island_tech_empty = {
		1225783,
		91,
		true
	},
	island_submit_order_cd_tip = {
		1225874,
		112,
		true
	},
	island_friend_add = {
		1225986,
		84,
		true
	},
	island_friend_agree = {
		1226070,
		89,
		true
	},
	island_friend_refuse = {
		1226159,
		90,
		true
	},
	island_friend_refuse_all = {
		1226249,
		98,
		true
	},
	island_request = {
		1226347,
		85,
		true
	},
	island_post_manage = {
		1226432,
		92,
		true
	},
	island_post_produce = {
		1226524,
		93,
		true
	},
	island_post_operate = {
		1226617,
		93,
		true
	},
	island_post_acceptable = {
		1226710,
		95,
		true
	},
	island_post_vacant = {
		1226805,
		97,
		true
	},
	island_production_selected_character = {
		1226902,
		106,
		true
	},
	island_production_collect = {
		1227008,
		96,
		true
	},
	island_production_selected_item = {
		1227104,
		110,
		true
	},
	island_production_byproduct = {
		1227214,
		111,
		true
	},
	island_production_start = {
		1227325,
		97,
		true
	},
	island_production_finish = {
		1227422,
		101,
		true
	},
	island_production_additional = {
		1227523,
		108,
		true
	},
	island_production_count = {
		1227631,
		103,
		true
	},
	island_production_character_info = {
		1227734,
		113,
		true
	},
	island_production_selected_tip1 = {
		1227847,
		132,
		true
	},
	island_production_selected_tip2 = {
		1227979,
		113,
		true
	},
	island_production_hold = {
		1228092,
		95,
		true
	},
	island_production_log_recover = {
		1228187,
		160,
		true
	},
	island_production_plantable = {
		1228347,
		100,
		true
	},
	island_production_being_planted = {
		1228447,
		122,
		true
	},
	island_production_cost_notenough = {
		1228569,
		131,
		true
	},
	island_production_manually_cancel = {
		1228700,
		183,
		true
	},
	island_production_harvestable = {
		1228883,
		104,
		true
	},
	island_production_seeds_notenough = {
		1228987,
		116,
		true
	},
	island_production_seeds_empty = {
		1229103,
		141,
		true
	},
	island_production_tip = {
		1229244,
		93,
		true
	},
	island_production_speed_addition1 = {
		1229337,
		127,
		true
	},
	island_production_speed_addition2 = {
		1229464,
		109,
		true
	},
	island_production_speed_addition3 = {
		1229573,
		108,
		true
	},
	island_production_speed_tip1 = {
		1229681,
		139,
		true
	},
	island_production_speed_tip2 = {
		1229820,
		115,
		true
	},
	island_order_ship_page_onekey_loadup = {
		1229935,
		126,
		true
	},
	agora_belong_theme = {
		1230061,
		91,
		true
	},
	agora_belong_theme_none = {
		1230152,
		95,
		true
	},
	island_achievement_title = {
		1230247,
		107,
		true
	},
	island_achv_total = {
		1230354,
		103,
		true
	},
	island_achv_finish_tip = {
		1230457,
		113,
		true
	},
	island_card_edit_name = {
		1230570,
		98,
		true
	},
	island_card_edit_word = {
		1230668,
		100,
		true
	},
	island_card_default_word = {
		1230768,
		126,
		true
	},
	island_card_view_detaills = {
		1230894,
		105,
		true
	},
	island_card_close = {
		1230999,
		93,
		true
	},
	island_card_choose_photo = {
		1231092,
		111,
		true
	},
	island_card_word_title = {
		1231203,
		101,
		true
	},
	island_card_label_list = {
		1231304,
		104,
		true
	},
	island_card_choose_achievement = {
		1231408,
		108,
		true
	},
	island_card_edit_label = {
		1231516,
		101,
		true
	},
	island_card_choose_label = {
		1231617,
		103,
		true
	},
	island_card_like_done = {
		1231720,
		118,
		true
	},
	island_card_label_done = {
		1231838,
		126,
		true
	},
	island_card_no_achv_self = {
		1231964,
		101,
		true
	},
	island_card_no_achv_other = {
		1232065,
		106,
		true
	},
	island_leave = {
		1232171,
		82,
		true
	},
	island_repeat_vip = {
		1232253,
		120,
		true
	},
	island_repeat_blacklist = {
		1232373,
		126,
		true
	},
	island_chat_settings = {
		1232499,
		97,
		true
	},
	island_card_no_label = {
		1232596,
		91,
		true
	},
	ship_gift = {
		1232687,
		78,
		true
	},
	ship_gift_cnt = {
		1232765,
		84,
		true
	},
	ship_gift2 = {
		1232849,
		78,
		true
	},
	shipyard_gift_exceed = {
		1232927,
		151,
		true
	},
	shipyard_gift_non_existent = {
		1233078,
		106,
		true
	},
	shipyard_favorability_exceed = {
		1233184,
		144,
		true
	},
	shipyard_favorability_threshold = {
		1233328,
		177,
		true
	},
	shipyard_favorability_max = {
		1233505,
		121,
		true
	},
	island_activity_decorative_word = {
		1233626,
		108,
		true
	},
	island_no_activity = {
		1233734,
		101,
		true
	},
	island_spoperation_level_2509_1 = {
		1233835,
		134,
		true
	},
	island_spoperation_tip_2509_1 = {
		1233969,
		341,
		true
	},
	island_spoperation_tip_2509_2 = {
		1234310,
		206,
		true
	},
	island_spoperation_tip_2509_3 = {
		1234516,
		254,
		true
	},
	island_spoperation_btn_2509_1 = {
		1234770,
		116,
		true
	},
	island_spoperation_btn_2509_2 = {
		1234886,
		118,
		true
	},
	island_spoperation_btn_2509_3 = {
		1235004,
		106,
		true
	},
	island_spoperation_item_2509_1 = {
		1235110,
		114,
		true
	},
	island_spoperation_item_2509_2 = {
		1235224,
		106,
		true
	},
	island_spoperation_item_2509_3 = {
		1235330,
		101,
		true
	},
	island_spoperation_item_2509_4 = {
		1235431,
		103,
		true
	},
	island_spoperation_tip_2602_1 = {
		1235534,
		341,
		true
	},
	island_spoperation_tip_2602_2 = {
		1235875,
		206,
		true
	},
	island_spoperation_tip_2602_3 = {
		1236081,
		257,
		true
	},
	island_spoperation_btn_2602_1 = {
		1236338,
		118,
		true
	},
	island_spoperation_btn_2602_2 = {
		1236456,
		116,
		true
	},
	island_spoperation_btn_2602_3 = {
		1236572,
		106,
		true
	},
	island_spoperation_item_2602_1 = {
		1236678,
		114,
		true
	},
	island_spoperation_item_2602_2 = {
		1236792,
		110,
		true
	},
	island_spoperation_item_2602_3 = {
		1236902,
		108,
		true
	},
	island_spoperation_item_2602_4 = {
		1237010,
		102,
		true
	},
	island_follow_success = {
		1237112,
		93,
		true
	},
	island_cancel_follow_success = {
		1237205,
		100,
		true
	},
	island_follower_cnt_max = {
		1237305,
		122,
		true
	},
	island_cancel_follow_tip = {
		1237427,
		141,
		true
	},
	island_follower_state_no_normal = {
		1237568,
		124,
		true
	},
	island_follow_btn_State_usable = {
		1237692,
		108,
		true
	},
	island_follow_btn_State_cancel = {
		1237800,
		102,
		true
	},
	island_follow_btn_State_disable = {
		1237902,
		99,
		true
	},
	island_draw_tab = {
		1238001,
		97,
		true
	},
	island_draw_tab_en = {
		1238098,
		100,
		true
	},
	island_draw_last = {
		1238198,
		90,
		true
	},
	island_draw_null = {
		1238288,
		88,
		true
	},
	island_draw_num = {
		1238376,
		84,
		true
	},
	island_draw_lottery = {
		1238460,
		87,
		true
	},
	island_draw_pick = {
		1238547,
		87,
		true
	},
	island_draw_reward = {
		1238634,
		94,
		true
	},
	island_draw_time = {
		1238728,
		94,
		true
	},
	island_draw_time_1 = {
		1238822,
		93,
		true
	},
	island_draw_S_order_title = {
		1238915,
		102,
		true
	},
	island_draw_S_order = {
		1239017,
		118,
		true
	},
	island_draw_S = {
		1239135,
		84,
		true
	},
	island_draw_A = {
		1239219,
		84,
		true
	},
	island_draw_B = {
		1239303,
		84,
		true
	},
	island_draw_C = {
		1239387,
		84,
		true
	},
	island_draw_get = {
		1239471,
		87,
		true
	},
	island_draw_ready = {
		1239558,
		123,
		true
	},
	island_draw_float = {
		1239681,
		100,
		true
	},
	island_draw_choice_title = {
		1239781,
		95,
		true
	},
	island_draw_choice = {
		1239876,
		92,
		true
	},
	island_draw_sort = {
		1239968,
		106,
		true
	},
	island_draw_tip1 = {
		1240074,
		119,
		true
	},
	island_draw_tip2 = {
		1240193,
		121,
		true
	},
	island_draw_tip3 = {
		1240314,
		114,
		true
	},
	island_draw_tip4 = {
		1240428,
		128,
		true
	},
	island_freight_btn_locked = {
		1240556,
		100,
		true
	},
	island_freight_btn_receive = {
		1240656,
		100,
		true
	},
	island_freight_btn_idle = {
		1240756,
		105,
		true
	},
	island_ticket_shop = {
		1240861,
		88,
		true
	},
	island_ticket_remain_time = {
		1240949,
		98,
		true
	},
	island_ticket_auto_select = {
		1241047,
		100,
		true
	},
	island_ticket_use = {
		1241147,
		100,
		true
	},
	island_ticket_view = {
		1241247,
		90,
		true
	},
	island_ticket_storage_title = {
		1241337,
		106,
		true
	},
	island_ticket_sort_valid = {
		1241443,
		100,
		true
	},
	island_ticket_sort_speedup = {
		1241543,
		98,
		true
	},
	island_ticket_completed_quantity = {
		1241641,
		115,
		true
	},
	island_ticket_nearing_expiration = {
		1241756,
		108,
		true
	},
	island_ticket_expiration_tip1 = {
		1241864,
		144,
		true
	},
	island_ticket_expiration_tip2 = {
		1242008,
		137,
		true
	},
	island_ticket_finished = {
		1242145,
		94,
		true
	},
	island_ticket_expired = {
		1242239,
		92,
		true
	},
	island_use_ticket_success = {
		1242331,
		106,
		true
	},
	island_sure_ticket_overflow = {
		1242437,
		172,
		true
	},
	island_ticket_expired_day = {
		1242609,
		109,
		true
	},
	island_dress_replace_tip = {
		1242718,
		156,
		true
	},
	island_activity_expired = {
		1242874,
		102,
		true
	},
	island_guide = {
		1242976,
		86,
		true
	},
	island_guide_help = {
		1243062,
		891,
		true
	},
	island_guide_help_npc = {
		1243953,
		389,
		true
	},
	island_guide_help_item = {
		1244342,
		646,
		true
	},
	island_guide_help_fish = {
		1244988,
		657,
		true
	},
	island_guide_character_help = {
		1245645,
		95,
		true
	},
	island_guide_en = {
		1245740,
		89,
		true
	},
	island_guide_character = {
		1245829,
		96,
		true
	},
	island_guide_character_en = {
		1245925,
		99,
		true
	},
	island_guide_npc = {
		1246024,
		103,
		true
	},
	island_guide_npc_en = {
		1246127,
		106,
		true
	},
	island_guide_item = {
		1246233,
		90,
		true
	},
	island_guide_item_en = {
		1246323,
		93,
		true
	},
	island_guide_collectionpoint = {
		1246416,
		113,
		true
	},
	island_guide_fish_min_weight = {
		1246529,
		103,
		true
	},
	island_guide_fish_max_weight = {
		1246632,
		102,
		true
	},
	island_get_collect_point_success = {
		1246734,
		124,
		true
	},
	island_guide_active = {
		1246858,
		93,
		true
	},
	island_book_collection_award_title = {
		1246951,
		119,
		true
	},
	island_book_award_title = {
		1247070,
		99,
		true
	},
	island_guide_do_active = {
		1247169,
		92,
		true
	},
	island_guide_lock_desc = {
		1247261,
		97,
		true
	},
	island_gift_entrance = {
		1247358,
		96,
		true
	},
	island_sign_text = {
		1247454,
		101,
		true
	},
	island_3Dshop_chara_set = {
		1247555,
		108,
		true
	},
	island_3Dshop_chara_choose = {
		1247663,
		106,
		true
	},
	island_3Dshop_res_have = {
		1247769,
		117,
		true
	},
	island_3Dshop_time_close = {
		1247886,
		114,
		true
	},
	island_3Dshop_time_refresh = {
		1248000,
		105,
		true
	},
	island_3Dshop_refresh_limit = {
		1248105,
		119,
		true
	},
	island_3Dshop_have = {
		1248224,
		88,
		true
	},
	island_3Dshop_time_unlock = {
		1248312,
		102,
		true
	},
	island_3Dshop_buy_no = {
		1248414,
		97,
		true
	},
	island_3Dshop_last = {
		1248511,
		97,
		true
	},
	island_3Dshop_close = {
		1248608,
		106,
		true
	},
	island_3Dshop_no_have = {
		1248714,
		95,
		true
	},
	island_3Dshop_goods_time = {
		1248809,
		102,
		true
	},
	island_3Dshop_clothes_jump = {
		1248911,
		131,
		true
	},
	island_3Dshop_buy_confirm = {
		1249042,
		92,
		true
	},
	island_3Dshop_buy = {
		1249134,
		84,
		true
	},
	island_3Dshop_buy_tip0 = {
		1249218,
		92,
		true
	},
	island_3Dshop_buy_return = {
		1249310,
		94,
		true
	},
	island_3Dshop_buy_price = {
		1249404,
		92,
		true
	},
	island_3Dshop_buy_have = {
		1249496,
		91,
		true
	},
	island_3Dshop_bag_max = {
		1249587,
		142,
		true
	},
	island_3Dshop_lack_gold = {
		1249729,
		115,
		true
	},
	island_3Dshop_lack_gem = {
		1249844,
		104,
		true
	},
	island_3Dshop_lack_res = {
		1249948,
		116,
		true
	},
	island_photo_fur_lock = {
		1250064,
		121,
		true
	},
	island_exchange_title = {
		1250185,
		93,
		true
	},
	island_exchange_title_en = {
		1250278,
		96,
		true
	},
	island_exchange_own_count = {
		1250374,
		99,
		true
	},
	island_exchange_btn_text = {
		1250473,
		96,
		true
	},
	island_exchange_sure_tip = {
		1250569,
		104,
		true
	},
	island_bag_max_tip = {
		1250673,
		111,
		true
	},
	graphi_api_switch_opengl = {
		1250784,
		296,
		true
	},
	graphi_api_switch_vulkan = {
		1251080,
		254,
		true
	},
	["3ddorm_beach_slide_tip1"] = {
		1251334,
		92,
		true
	},
	["3ddorm_beach_slide_tip2"] = {
		1251426,
		103,
		true
	},
	["3ddorm_beach_slide_tip3"] = {
		1251529,
		92,
		true
	},
	["3ddorm_beach_slide_tip4"] = {
		1251621,
		103,
		true
	},
	["3ddorm_beach_slide_tip5"] = {
		1251724,
		102,
		true
	},
	["3ddorm_beach_slide_tip6"] = {
		1251826,
		104,
		true
	},
	["3ddorm_beach_slide_tip7"] = {
		1251930,
		98,
		true
	},
	dorm3d_shop_tag7 = {
		1252028,
		167,
		true
	},
	grapihcs3d_setting_global_illumination = {
		1252195,
		126,
		true
	},
	grapihcs3d_setting_global_illumination_optionname0 = {
		1252321,
		117,
		true
	},
	grapihcs3d_setting_global_illumination_optionname1 = {
		1252438,
		120,
		true
	},
	grapihcs3d_setting_global_illumination_optionname2 = {
		1252558,
		118,
		true
	},
	grapihcs3d_setting_global_illumination_optionname3 = {
		1252676,
		123,
		true
	},
	grapihcs3d_setting_bloom_intensity = {
		1252799,
		113,
		true
	},
	grapihcs3d_setting_bloom_intensity_0 = {
		1252912,
		103,
		true
	},
	grapihcs3d_setting_bloom_intensity_1 = {
		1253015,
		103,
		true
	},
	grapihcs3d_setting_bloom_intensity_2 = {
		1253118,
		106,
		true
	},
	grapihcs3d_setting_bloom_intensity_3 = {
		1253224,
		104,
		true
	},
	grapihcs3d_setting_flare = {
		1253328,
		98,
		true
	},
	Outpost_20250904_Sidebar4 = {
		1253426,
		101,
		true
	},
	Outpost_20250904_Sidebar5 = {
		1253527,
		96,
		true
	},
	Outpost_20250904_Title1 = {
		1253623,
		99,
		true
	},
	Outpost_20250904_Title2 = {
		1253722,
		99,
		true
	},
	Outpost_20250904_Progress = {
		1253821,
		97,
		true
	},
	outpost_20250904_Sidebar4 = {
		1253918,
		101,
		true
	},
	outpost_20250904_Sidebar5 = {
		1254019,
		96,
		true
	},
	outpost_20250904_Title1 = {
		1254115,
		92,
		true
	},
	outpost_20250904_Title2 = {
		1254207,
		92,
		true
	},
	ninja_buff_name1 = {
		1254299,
		102,
		true
	},
	ninja_buff_name2 = {
		1254401,
		99,
		true
	},
	ninja_buff_name3 = {
		1254500,
		98,
		true
	},
	ninja_buff_name4 = {
		1254598,
		97,
		true
	},
	ninja_buff_name5 = {
		1254695,
		91,
		true
	},
	ninja_buff_name6 = {
		1254786,
		93,
		true
	},
	ninja_buff_name7 = {
		1254879,
		106,
		true
	},
	ninja_buff_name8 = {
		1254985,
		98,
		true
	},
	ninja_buff_name9 = {
		1255083,
		102,
		true
	},
	ninja_buff_name10 = {
		1255185,
		101,
		true
	},
	ninja_buff_effect1 = {
		1255286,
		114,
		true
	},
	ninja_buff_effect2 = {
		1255400,
		113,
		true
	},
	ninja_buff_effect3 = {
		1255513,
		95,
		true
	},
	ninja_buff_effect4 = {
		1255608,
		103,
		true
	},
	ninja_buff_effect5 = {
		1255711,
		132,
		true
	},
	ninja_buff_effect6 = {
		1255843,
		112,
		true
	},
	ninja_buff_effect7 = {
		1255955,
		106,
		true
	},
	ninja_buff_effect8 = {
		1256061,
		107,
		true
	},
	ninja_buff_effect9 = {
		1256168,
		107,
		true
	},
	ninja_buff_effect10 = {
		1256275,
		132,
		true
	},
	activity_ninjia_main_title = {
		1256407,
		95,
		true
	},
	activity_ninjia_main_title_en = {
		1256502,
		98,
		true
	},
	activity_ninjia_main_sheet1 = {
		1256600,
		103,
		true
	},
	activity_ninjia_main_sheet2 = {
		1256703,
		102,
		true
	},
	activity_ninjia_main_sheet3 = {
		1256805,
		101,
		true
	},
	activity_ninjia_main_sheet4 = {
		1256906,
		99,
		true
	},
	activity_return_reward_pt = {
		1257005,
		106,
		true
	},
	outpost_20250904_Sidebar1 = {
		1257111,
		99,
		true
	},
	outpost_20250904_Sidebar2 = {
		1257210,
		98,
		true
	},
	outpost_20250904_Sidebar3 = {
		1257308,
		100,
		true
	},
	anniversary_eight_main_page_desc = {
		1257408,
		319,
		true
	},
	eighth_tip_spring = {
		1257727,
		289,
		true
	},
	eighth_spring_cost = {
		1258016,
		183,
		true
	},
	eighth_spring_not_enough = {
		1258199,
		113,
		true
	},
	ninja_game_helper = {
		1258312,
		1822,
		true
	},
	ninja_game_citylevel = {
		1260134,
		99,
		true
	},
	ninja_game_wave = {
		1260233,
		91,
		true
	},
	ninja_game_current_section = {
		1260324,
		114,
		true
	},
	ninja_game_buildcost = {
		1260438,
		95,
		true
	},
	ninja_game_allycost = {
		1260533,
		99,
		true
	},
	ninja_game_citydmg = {
		1260632,
		98,
		true
	},
	ninja_game_allydmg = {
		1260730,
		95,
		true
	},
	ninja_game_dps = {
		1260825,
		96,
		true
	},
	ninja_game_time = {
		1260921,
		93,
		true
	},
	ninja_game_income = {
		1261014,
		90,
		true
	},
	ninja_game_buffeffect = {
		1261104,
		97,
		true
	},
	ninja_game_buffcost = {
		1261201,
		96,
		true
	},
	ninja_game_levelblock = {
		1261297,
		107,
		true
	},
	ninja_game_storydialog = {
		1261404,
		135,
		true
	},
	ninja_game_update_failed = {
		1261539,
		166,
		true
	},
	ninja_game_ptcount = {
		1261705,
		92,
		true
	},
	ninja_game_cant_pickup = {
		1261797,
		108,
		true
	},
	ninja_game_booktip = {
		1261905,
		164,
		true
	},
	island_no_position_to_reponse_action = {
		1262069,
		178,
		true
	},
	island_position_cant_play_cp_action = {
		1262247,
		177,
		true
	},
	island_position_cant_response_cp_action = {
		1262424,
		192,
		true
	},
	island_card_no_achieve_tip = {
		1262616,
		115,
		true
	},
	island_card_no_label_tip = {
		1262731,
		126,
		true
	},
	gift_giving_prefer = {
		1262857,
		106,
		true
	},
	gift_giving_dislike = {
		1262963,
		109,
		true
	},
	dorm3d_publicroom_unlock = {
		1263072,
		126,
		true
	},
	dorm3d_dafeng_table = {
		1263198,
		90,
		true
	},
	dorm3d_dafeng_chair = {
		1263288,
		94,
		true
	},
	dorm3d_dafeng_bed = {
		1263382,
		88,
		true
	},
	island_draw_help = {
		1263470,
		1626,
		true
	},
	island_dress_initial_makesure = {
		1265096,
		101,
		true
	},
	island_shop_lock_tip = {
		1265197,
		115,
		true
	},
	island_agora_no_size = {
		1265312,
		107,
		true
	},
	island_combo_unlock = {
		1265419,
		113,
		true
	},
	island_additional_production_tip1 = {
		1265532,
		113,
		true
	},
	island_additional_production_tip2 = {
		1265645,
		153,
		true
	},
	island_manage_stock_out = {
		1265798,
		118,
		true
	},
	island_manage_item_select = {
		1265916,
		102,
		true
	},
	island_combo_produced = {
		1266018,
		89,
		true
	},
	island_combo_produced_times = {
		1266107,
		101,
		true
	},
	island_agora_no_interact_point = {
		1266208,
		124,
		true
	},
	island_reward_tip = {
		1266332,
		87,
		true
	},
	island_commontips_close = {
		1266419,
		110,
		true
	},
	world_inventory_tip = {
		1266529,
		108,
		true
	},
	island_setmeal_title = {
		1266637,
		95,
		true
	},
	island_setmeal_benifit_title = {
		1266732,
		102,
		true
	},
	island_shipselect_confirm = {
		1266834,
		97,
		true
	},
	island_dresscolorunlock_tips = {
		1266931,
		107,
		true
	},
	island_dresscolorunlock = {
		1267038,
		93,
		true
	},
	danmachi_main_sheet1 = {
		1267131,
		94,
		true
	},
	danmachi_main_sheet2 = {
		1267225,
		90,
		true
	},
	danmachi_main_sheet3 = {
		1267315,
		92,
		true
	},
	danmachi_main_sheet4 = {
		1267407,
		89,
		true
	},
	danmachi_main_sheet5 = {
		1267496,
		95,
		true
	},
	danmachi_main_time = {
		1267591,
		97,
		true
	},
	danmachi_award_1 = {
		1267688,
		88,
		true
	},
	danmachi_award_2 = {
		1267776,
		89,
		true
	},
	danmachi_award_3 = {
		1267865,
		90,
		true
	},
	danmachi_award_4 = {
		1267955,
		88,
		true
	},
	danmachi_award_name1 = {
		1268043,
		90,
		true
	},
	danmachi_award_name2 = {
		1268133,
		92,
		true
	},
	danmachi_award_get = {
		1268225,
		90,
		true
	},
	danmachi_award_unget = {
		1268315,
		94,
		true
	},
	dorm3d_touch2 = {
		1268409,
		87,
		true
	},
	dorm3d_furnitrue_type_special = {
		1268496,
		102,
		true
	},
	island_helpbtn_order = {
		1268598,
		1169,
		true
	},
	island_helpbtn_commission = {
		1269767,
		891,
		true
	},
	island_helpbtn_speedup = {
		1270658,
		588,
		true
	},
	island_helpbtn_card = {
		1271246,
		751,
		true
	},
	island_helpbtn_technology = {
		1271997,
		1018,
		true
	},
	island_shiporder_refresh_tip1 = {
		1273015,
		153,
		true
	},
	island_shiporder_refresh_tip2 = {
		1273168,
		137,
		true
	},
	island_shiporder_refresh_preparing = {
		1273305,
		123,
		true
	},
	island_information_tech = {
		1273428,
		108,
		true
	},
	dorm3d_shop_tag8 = {
		1273536,
		105,
		true
	},
	island_chara_attr_help = {
		1273641,
		733,
		true
	},
	fengfanV3_20251023_Sidebar1 = {
		1274374,
		102,
		true
	},
	fengfanV3_20251023_Sidebar2 = {
		1274476,
		101,
		true
	},
	fengfanV3_20251023_Sidebar3 = {
		1274577,
		102,
		true
	},
	fengfanV3_20251023_jinianshouce = {
		1274679,
		107,
		true
	},
	island_selectall = {
		1274786,
		83,
		true
	},
	island_quickselect_tip = {
		1274869,
		148,
		true
	},
	search_equipment = {
		1275017,
		99,
		true
	},
	search_sp_equipment = {
		1275116,
		109,
		true
	},
	search_equipment_appearance = {
		1275225,
		115,
		true
	},
	meta_reproduce_btn = {
		1275340,
		222,
		true
	},
	meta_simulated_btn = {
		1275562,
		222,
		true
	},
	equip_enhancement_tip = {
		1275784,
		107,
		true
	},
	equip_enhancement_lv1 = {
		1275891,
		95,
		true
	},
	equip_enhancement_lvx = {
		1275986,
		99,
		true
	},
	equip_enhancement_finish = {
		1276085,
		96,
		true
	},
	equip_enhancement_lv = {
		1276181,
		86,
		true
	},
	equip_enhancement_title = {
		1276267,
		94,
		true
	},
	equip_enhancement_required = {
		1276361,
		107,
		true
	},
	shop_sell_ended = {
		1276468,
		90,
		true
	},
	island_taskjump_systemnoopen_tips = {
		1276558,
		137,
		true
	},
	island_taskjump_placenoopen_tips = {
		1276695,
		137,
		true
	},
	island_ship_order_toggle_label_award = {
		1276832,
		107,
		true
	},
	island_ship_order_toggle_label_request = {
		1276939,
		106,
		true
	},
	island_ship_order_delegate_auto_refresh_label = {
		1277045,
		153,
		true
	},
	island_ship_order_delegate_auto_refresh_time = {
		1277198,
		141,
		true
	},
	island_order_ship_finish_cnt = {
		1277339,
		108,
		true
	},
	island_order_ship_sel_delegate_label = {
		1277447,
		121,
		true
	},
	island_order_ship_finish_cnt_not_enough = {
		1277568,
		110,
		true
	},
	island_order_ship_reset_all = {
		1277678,
		134,
		true
	},
	island_order_ship_exchange_tip = {
		1277812,
		140,
		true
	},
	island_order_ship_btn_replace = {
		1277952,
		104,
		true
	},
	island_fishing_tip_hooked = {
		1278056,
		111,
		true
	},
	island_fishing_tip_escape = {
		1278167,
		109,
		true
	},
	island_fishing_exit = {
		1278276,
		111,
		true
	},
	island_fishing_lure_empty = {
		1278387,
		102,
		true
	},
	island_order_ship_exchange_tip_2 = {
		1278489,
		142,
		true
	},
	island_follower_exiting_tip = {
		1278631,
		118,
		true
	},
	island_order_ship_exchange_tip_1 = {
		1278749,
		251,
		true
	},
	island_urgent_notice = {
		1279000,
		2711,
		true
	},
	general_activity_side_bar1 = {
		1281711,
		106,
		true
	},
	general_activity_side_bar2 = {
		1281817,
		113,
		true
	},
	general_activity_side_bar3 = {
		1281930,
		108,
		true
	},
	general_activity_side_bar4 = {
		1282038,
		111,
		true
	},
	black5_bundle_desc = {
		1282149,
		128,
		true
	},
	black5_bundle_purchased = {
		1282277,
		96,
		true
	},
	black5_bundle_tip = {
		1282373,
		104,
		true
	},
	black5_bundle_buy_all = {
		1282477,
		97,
		true
	},
	black5_bundle_popup = {
		1282574,
		173,
		true
	},
	black5_bundle_receive = {
		1282747,
		96,
		true
	},
	black5_bundle_button = {
		1282843,
		89,
		true
	},
	skinshop_on_sale_tip = {
		1282932,
		97,
		true
	},
	skinshop_on_sale_tip_2 = {
		1283029,
		103,
		true
	},
	blackfriday_cruise_task_tips = {
		1283132,
		101,
		true
	},
	blackfriday_cruise_task_unlock = {
		1283233,
		125,
		true
	},
	blackfriday_cruise_task_day = {
		1283358,
		97,
		true
	},
	blackfriday_battlepass_pay_acquire = {
		1283455,
		113,
		true
	},
	blackfriday_battlepass_pay_tip = {
		1283568,
		134,
		true
	},
	blackfriday_battlepass_complete = {
		1283702,
		144,
		true
	},
	blackfriday_cruise_phase_title = {
		1283846,
		99,
		true
	},
	blackfriday_cruise_title_1113 = {
		1283945,
		121,
		true
	},
	blackfriday_battlepass_main_time_title = {
		1284066,
		117,
		true
	},
	blackfriday_cruise_btn_pay = {
		1284183,
		110,
		true
	},
	blackfriday_cruise_btn_all = {
		1284293,
		101,
		true
	},
	blackfriday_battlepass_main_help_1113 = {
		1284394,
		2381,
		true
	},
	blackfriday_cruise_task_help_1113 = {
		1286775,
		702,
		true
	},
	shop_tag_control_tip = {
		1287477,
		107,
		true
	},
	blackfriday_battlepass_mission = {
		1287584,
		102,
		true
	},
	blackfriday_battlepass_rewards = {
		1287686,
		101,
		true
	},
	black5_bundle_help = {
		1287787,
		351,
		true
	},
	blackfriday_luckybag_164 = {
		1288138,
		305,
		true
	},
	blackfriday_luckybag_165 = {
		1288443,
		560,
		true
	},
	battlepass_main_tip_2512 = {
		1289003,
		270,
		true
	},
	battlepass_main_help_2512 = {
		1289273,
		2899,
		true
	},
	cruise_task_help_2512 = {
		1292172,
		1092,
		true
	},
	cruise_title_2512 = {
		1293264,
		102,
		true
	},
	DAL_stage_label_data = {
		1293366,
		96,
		true
	},
	DAL_stage_label_support = {
		1293462,
		101,
		true
	},
	DAL_stage_label_commander = {
		1293563,
		103,
		true
	},
	DAL_stage_label_analysis_2 = {
		1293666,
		107,
		true
	},
	DAL_stage_label_analysis_1 = {
		1293773,
		102,
		true
	},
	DAL_stage_finish_at = {
		1293875,
		92,
		true
	},
	activity_remain_time = {
		1293967,
		93,
		true
	},
	dal_main_sheet1 = {
		1294060,
		88,
		true
	},
	dal_main_sheet2 = {
		1294148,
		96,
		true
	},
	dal_main_sheet3 = {
		1294244,
		97,
		true
	},
	dal_main_sheet4 = {
		1294341,
		91,
		true
	},
	dal_main_sheet5 = {
		1294432,
		90,
		true
	},
	DAL_upgrade_ship = {
		1294522,
		95,
		true
	},
	DAL_upgrade_active = {
		1294617,
		89,
		true
	},
	dal_main_sheet1_en = {
		1294706,
		91,
		true
	},
	dal_main_sheet2_en = {
		1294797,
		91,
		true
	},
	dal_main_sheet3_en = {
		1294888,
		94,
		true
	},
	dal_main_sheet4_en = {
		1294982,
		94,
		true
	},
	dal_main_sheet5_en = {
		1295076,
		93,
		true
	},
	DAL_story_tip = {
		1295169,
		137,
		true
	},
	DAL_upgrade_program = {
		1295306,
		98,
		true
	},
	dal_story_tip_name_en_1 = {
		1295404,
		95,
		true
	},
	dal_story_tip_name_en_2 = {
		1295499,
		95,
		true
	},
	dal_story_tip_name_en_3 = {
		1295594,
		95,
		true
	},
	dal_story_tip_name_en_4 = {
		1295689,
		95,
		true
	},
	dal_story_tip_name_en_5 = {
		1295784,
		95,
		true
	},
	dal_story_tip_name_en_6 = {
		1295879,
		95,
		true
	},
	dal_story_tip1 = {
		1295974,
		107,
		true
	},
	dal_story_tip2 = {
		1296081,
		102,
		true
	},
	dal_story_tip3 = {
		1296183,
		86,
		true
	},
	dal_AwardPage_name_1 = {
		1296269,
		88,
		true
	},
	dal_AwardPage_name_2 = {
		1296357,
		90,
		true
	},
	dal_chapter_goto = {
		1296447,
		82,
		true
	},
	DAL_upgrade_unlock = {
		1296529,
		88,
		true
	},
	DAL_upgrade_not_enough = {
		1296617,
		154,
		true
	},
	dal_chapter_tip = {
		1296771,
		1939,
		true
	},
	dal_chapter_tip2 = {
		1298710,
		110,
		true
	},
	scenario_unlock_pt_require = {
		1298820,
		121,
		true
	},
	scenario_unlock = {
		1298941,
		104,
		true
	},
	vote_help_2025 = {
		1299045,
		5313,
		true
	},
	HelenaCoreActivity_title = {
		1304358,
		93,
		true
	},
	HelenaCoreActivity_title2 = {
		1304451,
		94,
		true
	},
	HelenaPTPage_title = {
		1304545,
		98,
		true
	},
	HelenaPTPage_title2 = {
		1304643,
		83,
		true
	},
	HelenaCoreActivity_subtitle_1 = {
		1304726,
		109,
		true
	},
	HelenaCoreActivity_subtitle_2 = {
		1304835,
		105,
		true
	},
	HelenaCoreActivity_subtitle_3 = {
		1304940,
		112,
		true
	},
	HelenaCoreActivity_subtitle_4 = {
		1305052,
		121,
		true
	},
	HelenaCoreActivity_subtitle_5 = {
		1305173,
		112,
		true
	},
	HelenaCoreActivity_subtitle_6 = {
		1305285,
		104,
		true
	},
	fate_unlock_icon_desc = {
		1305389,
		120,
		true
	},
	blueprint_exchange_fate_unlock = {
		1305509,
		162,
		true
	},
	blueprint_exchange_fate_unlock_over = {
		1305671,
		213,
		true
	},
	blueprint_lab_fate_lock = {
		1305884,
		133,
		true
	},
	blueprint_lab_fate_unlock = {
		1306017,
		137,
		true
	},
	blueprint_lab_exchange_fate_unlock = {
		1306154,
		166,
		true
	},
	skinstory_20251218 = {
		1306320,
		91,
		true
	},
	skinstory_20251225 = {
		1306411,
		92,
		true
	},
	change_skin_asmr_desc_1 = {
		1306503,
		145,
		true
	},
	change_skin_asmr_desc_2 = {
		1306648,
		134,
		true
	},
	dorm3d_aijier_table = {
		1306782,
		88,
		true
	},
	dorm3d_aijier_chair = {
		1306870,
		89,
		true
	},
	dorm3d_aijier_bed = {
		1306959,
		88,
		true
	},
	winterwish_20251225 = {
		1307047,
		95,
		true
	},
	winterwish_20251225_tip1 = {
		1307142,
		98,
		true
	},
	winterwish_20251225_tip2 = {
		1307240,
		99,
		true
	},
	battlepass_main_tip_2602 = {
		1307339,
		255,
		true
	},
	battlepass_main_help_2602 = {
		1307594,
		2897,
		true
	},
	cruise_task_help_2602 = {
		1310491,
		1092,
		true
	},
	cruise_title_2602 = {
		1311583,
		102,
		true
	},
	battle_battleMediator_quest_exist_submarine_support = {
		1311685,
		220,
		true
	},
	island_survey_ui_1 = {
		1311905,
		82,
		true
	},
	island_survey_ui_2 = {
		1311987,
		82,
		true
	},
	island_survey_ui_award = {
		1312069,
		86,
		true
	},
	island_survey_ui_button = {
		1312155,
		87,
		true
	},
	ANTTFFCoreActivity_subtitle_1 = {
		1312242,
		131,
		true
	},
	ANTTFFCoreActivity_title = {
		1312373,
		94,
		true
	},
	ANTTFFCoreActivity_title2 = {
		1312467,
		89,
		true
	},
	ANTTFFCoreActivityPtpage_title = {
		1312556,
		100,
		true
	},
	ANTTFFCoreActivityPtpage_title2 = {
		1312656,
		95,
		true
	},
	submarine_support_oil_consume_tip = {
		1312751,
		177,
		true
	},
	SardiniaSPCoreActivityUI_title = {
		1312928,
		99,
		true
	},
	SardiniaSPCoreActivityUI_subtitle_1 = {
		1313027,
		113,
		true
	},
	SardiniaSPCoreActivityUI_subtitle_2 = {
		1313140,
		108,
		true
	},
	SardiniaSPCoreActivityUI_story_reward_count = {
		1313248,
		331,
		true
	},
	SardiniaSPCoreActivityUI_unlock = {
		1313579,
		101,
		true
	},
	SardiniaSPCoreActivityUI_fleetconfirm = {
		1313680,
		190,
		true
	},
	SardiniaSPCoreActivityUI_help = {
		1313870,
		1388,
		true
	},
	pac_game_high_score_tip = {
		1315258,
		101,
		true
	},
	pac_game_rule_btn = {
		1315359,
		92,
		true
	},
	pac_game_start_btn = {
		1315451,
		87,
		true
	},
	pac_game_gaming_time_desc = {
		1315538,
		94,
		true
	},
	pac_game_gaming_score = {
		1315632,
		91,
		true
	},
	mini_game_continue = {
		1315723,
		88,
		true
	},
	mini_game_over_game = {
		1315811,
		87,
		true
	},
	pac_minigame_help = {
		1315898,
		802,
		true
	},
	SpringFestival2026CoreActivity_subtitle_1 = {
		1316700,
		130,
		true
	},
	SpringFestival2026CoreActivity_subtitle_2 = {
		1316830,
		126,
		true
	},
	SpringFestival2026CoreActivity_subtitle_3 = {
		1316956,
		118,
		true
	},
	SpringFestival2026CoreActivity_subtitle_4 = {
		1317074,
		126,
		true
	},
	SpringFestival2026CoreActivity_subtitle_5 = {
		1317200,
		127,
		true
	},
	SpringFestival2026CoreActivity_subtitle_6 = {
		1317327,
		132,
		true
	},
	SpringFestival2026CoreActivity_subtitle_7 = {
		1317459,
		128,
		true
	},
	island_post_event_label = {
		1317587,
		101,
		true
	},
	island_post_event_close_label = {
		1317688,
		99,
		true
	},
	island_post_event_open_label = {
		1317787,
		99,
		true
	},
	island_post_event_addition_label = {
		1317886,
		133,
		true
	},
	island_addition_influence = {
		1318019,
		104,
		true
	},
	island_addition_sale = {
		1318123,
		89,
		true
	},
	island_trade_title = {
		1318212,
		98,
		true
	},
	island_trade_title2 = {
		1318310,
		99,
		true
	},
	island_trade_sell_label = {
		1318409,
		98,
		true
	},
	island_trade_trend_label = {
		1318507,
		101,
		true
	},
	island_trade_purchase_label = {
		1318608,
		101,
		true
	},
	island_trade_rank_label = {
		1318709,
		102,
		true
	},
	island_trade_purchase_sub_label = {
		1318811,
		98,
		true
	},
	island_trade_sell_sub_label = {
		1318909,
		95,
		true
	},
	island_trade_rank_num_label = {
		1319004,
		107,
		true
	},
	island_trade_rank_info_label = {
		1319111,
		103,
		true
	},
	island_trade_rank_price_label = {
		1319214,
		106,
		true
	},
	island_trade_rank_level_label = {
		1319320,
		103,
		true
	},
	island_trade_invite_label = {
		1319423,
		102,
		true
	},
	island_trade_tip_label = {
		1319525,
		134,
		true
	},
	island_trade_tip_label2 = {
		1319659,
		136,
		true
	},
	island_trade_limit_label = {
		1319795,
		124,
		true
	},
	island_trade_send_msg_label = {
		1319919,
		174,
		true
	},
	island_trade_send_msg_match_label = {
		1320093,
		111,
		true
	},
	island_trade_sell_tip_label = {
		1320204,
		135,
		true
	},
	island_trade_purchase_failed_label = {
		1320339,
		142,
		true
	},
	island_trade_sell_failed_label = {
		1320481,
		145,
		true
	},
	island_trade_sell_failed_label2 = {
		1320626,
		137,
		true
	},
	island_trade_bag_full_label = {
		1320763,
		149,
		true
	},
	island_trade_reset_label = {
		1320912,
		114,
		true
	},
	island_trade_help = {
		1321026,
		84,
		true
	},
	island_trade_help_1 = {
		1321110,
		300,
		true
	},
	island_trade_help_2 = {
		1321410,
		420,
		true
	},
	island_trade_price_unrefresh = {
		1321830,
		157,
		true
	},
	island_trade_msg_pop = {
		1321987,
		164,
		true
	},
	island_trade_invite_success = {
		1322151,
		112,
		true
	},
	island_trade_share_success = {
		1322263,
		111,
		true
	},
	island_trade_activity_desc_1 = {
		1322374,
		191,
		true
	},
	island_trade_activity_desc_2 = {
		1322565,
		185,
		true
	},
	island_trade_activity_unlock = {
		1322750,
		137,
		true
	},
	island_bar_quick_game = {
		1322887,
		95,
		true
	},
	island_trade_cnt_inadequate = {
		1322982,
		110,
		true
	},
	drawdiary_ui_2026 = {
		1323092,
		93,
		true
	},
	loveactivity_ui_1 = {
		1323185,
		95,
		true
	},
	loveactivity_ui_2 = {
		1323280,
		94,
		true
	},
	loveactivity_ui_3 = {
		1323374,
		89,
		true
	},
	loveactivity_ui_4 = {
		1323463,
		144,
		true
	},
	loveactivity_ui_4_1 = {
		1323607,
		285,
		true
	},
	loveactivity_ui_4_2 = {
		1323892,
		285,
		true
	},
	loveactivity_ui_4_3 = {
		1324177,
		286,
		true
	},
	loveactivity_ui_5 = {
		1324463,
		95,
		true
	},
	loveactivity_ui_6 = {
		1324558,
		89,
		true
	},
	loveactivity_ui_7 = {
		1324647,
		134,
		true
	},
	loveactivity_ui_8 = {
		1324781,
		87,
		true
	},
	loveactivity_ui_9 = {
		1324868,
		102,
		true
	},
	loveactivity_ui_10 = {
		1324970,
		100,
		true
	},
	loveactivity_ui_11 = {
		1325070,
		107,
		true
	},
	loveactivity_ui_12 = {
		1325177,
		158,
		true
	},
	loveactivity_ui_13 = {
		1325335,
		123,
		true
	},
	child_cg_buy = {
		1325458,
		149,
		true
	},
	child_polaroid_buy = {
		1325607,
		155,
		true
	},
	child_could_buy = {
		1325762,
		124,
		true
	},
	loveactivity_ui_14 = {
		1325886,
		107,
		true
	},
	loveactivity_ui_15 = {
		1325993,
		110,
		true
	},
	loveactivity_ui_16 = {
		1326103,
		102,
		true
	},
	loveactivity_ui_17 = {
		1326205,
		102,
		true
	},
	loveactivity_ui_18 = {
		1326307,
		118,
		true
	},
	loveactivity_ui_19 = {
		1326425,
		123,
		true
	},
	loveactivity_ui_20 = {
		1326548,
		120,
		true
	},
	help_chunjie_jiulou_2026 = {
		1326668,
		951,
		true
	},
	LiquorFloorTaskUI_title = {
		1327619,
		104,
		true
	},
	LiquorFloorTaskUI_go = {
		1327723,
		91,
		true
	},
	LiquorFloorTaskUI_get = {
		1327814,
		91,
		true
	},
	LiquorFloorTaskUI_got = {
		1327905,
		92,
		true
	},
	LiquorFloor_gold_get = {
		1327997,
		101,
		true
	},
	MoscowURCoreActivity_subtitle_1 = {
		1328098,
		116,
		true
	},
	MoscowURCoreActivity_subtitle_2 = {
		1328214,
		109,
		true
	},
	loveactivity_help_tips = {
		1328323,
		455,
		true
	},
	spring_present_tips_btn = {
		1328778,
		104,
		true
	},
	spring_present_tips_time = {
		1328882,
		138,
		true
	},
	spring_present_tips0 = {
		1329020,
		143,
		true
	},
	spring_present_tips1 = {
		1329163,
		176,
		true
	},
	spring_present_tips2 = {
		1329339,
		184,
		true
	},
	spring_present_tips3 = {
		1329523,
		121,
		true
	},
	island_gift_tip_title = {
		1329644,
		92,
		true
	},
	island_gift_tip = {
		1329736,
		178,
		true
	},
	island_chara_gather_tip = {
		1329914,
		96,
		true
	},
	island_chara_gather_power = {
		1330010,
		101,
		true
	},
	island_chara_gather_money = {
		1330111,
		99,
		true
	},
	island_chara_gather_range = {
		1330210,
		110,
		true
	},
	island_chara_gather_start = {
		1330320,
		94,
		true
	},
	island_chara_gather_tag_1 = {
		1330414,
		105,
		true
	},
	island_chara_gather_tag_2 = {
		1330519,
		104,
		true
	},
	island_chara_gather_skill_effect = {
		1330623,
		108,
		true
	},
	island_chara_gather_done = {
		1330731,
		106,
		true
	},
	island_chara_gather_no_target = {
		1330837,
		118,
		true
	},
	island_quick_delegation = {
		1330955,
		95,
		true
	},
	island_quick_delegation_notenough_encourage = {
		1331050,
		165,
		true
	},
	island_quick_delegation_notenough_onduty = {
		1331215,
		159,
		true
	},
	child_plan_skip_event = {
		1331374,
		110,
		true
	},
	child_buy_memory_tip = {
		1331484,
		144,
		true
	},
	child_buy_polaroid_tip = {
		1331628,
		146,
		true
	},
	child_buy_ending_tip = {
		1331774,
		145,
		true
	},
	child_buy_collect_success = {
		1331919,
		98,
		true
	},
	loveletter2018_ui_4 = {
		1332017,
		120,
		true
	},
	loveletter2018_ui_5 = {
		1332137,
		155,
		true
	},
	LiquorFloor_title = {
		1332292,
		102,
		true
	},
	LiquorFloor_title_en = {
		1332394,
		94,
		true
	},
	LiquorFloor_level = {
		1332488,
		88,
		true
	},
	LiquorFloor_story_title = {
		1332576,
		96,
		true
	},
	LiquorFloor_story_title_1 = {
		1332672,
		105,
		true
	},
	LiquorFloor_story_title_2 = {
		1332777,
		105,
		true
	},
	LiquorFloor_story_title_3 = {
		1332882,
		106,
		true
	},
	LiquorFloor_story_title_4 = {
		1332988,
		98,
		true
	},
	LiquorFloor_story_go = {
		1333086,
		91,
		true
	},
	LiquorFloor_story_get = {
		1333177,
		91,
		true
	},
	LiquorFloor_story_got = {
		1333268,
		92,
		true
	},
	LiquorFloor_character_num = {
		1333360,
		103,
		true
	},
	LiquorFloor_character_unlock = {
		1333463,
		109,
		true
	},
	LiquorFloor_character_tip = {
		1333572,
		181,
		true
	},
	LiquorFloor_gold_num = {
		1333753,
		102,
		true
	},
	LiquorFloor_gold = {
		1333855,
		95,
		true
	},
	LiquorFloor_update = {
		1333950,
		90,
		true
	},
	LiquorFloor_update_unlock = {
		1334040,
		118,
		true
	},
	LiquorFloor_update_max = {
		1334158,
		103,
		true
	},
	LiquorFloor_gold_max_tip = {
		1334261,
		125,
		true
	},
	LiquorFloor_tip = {
		1334386,
		1439,
		true
	},
	loveletter2018_ui_1 = {
		1335825,
		219,
		true
	},
	loveletter2018_ui_2 = {
		1336044,
		142,
		true
	},
	loveletter2018_ui_3 = {
		1336186,
		138,
		true
	},
	loveletter2018_ui_tips = {
		1336324,
		113,
		true
	},
	child2_choose_title = {
		1336437,
		93,
		true
	},
	child2_choose_help = {
		1336530,
		1554,
		true
	},
	child2_show_detail_desc = {
		1338084,
		99,
		true
	},
	child2_tarot_empty = {
		1338183,
		112,
		true
	},
	child2_refresh_title = {
		1338295,
		97,
		true
	},
	child2_choose_hide = {
		1338392,
		86,
		true
	},
	child2_choose_giveup = {
		1338478,
		91,
		true
	},
	child2_tarot_tag_current = {
		1338569,
		99,
		true
	},
	child2_all_entry_title = {
		1338668,
		101,
		true
	},
	child2_benefit_moeny_effect = {
		1338769,
		108,
		true
	},
	child2_benefit_mood_effect = {
		1338877,
		107,
		true
	},
	child2_replace_sure_tip = {
		1338984,
		113,
		true
	},
	child2_tarot_title = {
		1339097,
		94,
		true
	},
	child2_entry_summary = {
		1339191,
		102,
		true
	},
	child2_benefit_result = {
		1339293,
		100,
		true
	},
	child2_mood_benefit = {
		1339393,
		98,
		true
	},
	child2_mood_stage1 = {
		1339491,
		105,
		true
	},
	child2_mood_stage2 = {
		1339596,
		99,
		true
	},
	child2_mood_stage3 = {
		1339695,
		102,
		true
	},
	child2_mood_stage4 = {
		1339797,
		101,
		true
	},
	child2_mood_stage5 = {
		1339898,
		101,
		true
	},
	child2_entry_activated = {
		1339999,
		102,
		true
	},
	child2_collect_tarot_progress = {
		1340101,
		109,
		true
	},
	child2_collect_tarot = {
		1340210,
		96,
		true
	},
	child2_collect_entry = {
		1340306,
		91,
		true
	},
	child2_collect_talent = {
		1340397,
		92,
		true
	},
	child2_rank_toggle_attr = {
		1340489,
		93,
		true
	},
	child2_rank_toggle_endless = {
		1340582,
		102,
		true
	},
	child2_rank_not_on = {
		1340684,
		90,
		true
	},
	child2_rank_refresh_tip = {
		1340774,
		127,
		true
	},
	child2_rank_header_rank = {
		1340901,
		98,
		true
	},
	child2_rank_header_info = {
		1340999,
		91,
		true
	},
	child2_rank_header_attr = {
		1341090,
		102,
		true
	},
	child2_replace_title = {
		1341192,
		110,
		true
	},
	child2_replace_tip = {
		1341302,
		251,
		true
	},
	child2_tarot_tag_replace = {
		1341553,
		97,
		true
	},
	child2_replace_cancel = {
		1341650,
		91,
		true
	},
	child2_replace_sure = {
		1341741,
		90,
		true
	},
	child2_nailing_game_tip = {
		1341831,
		153,
		true
	},
	child2_nailing_game_count = {
		1341984,
		100,
		true
	},
	child2_nailing_game_score = {
		1342084,
		95,
		true
	},
	child2_benefit_summary = {
		1342179,
		100,
		true
	},
	child2_word_giveup = {
		1342279,
		98,
		true
	},
	child2_rank_header_wave = {
		1342377,
		106,
		true
	},
	child2_personal_id2_tag1 = {
		1342483,
		91,
		true
	},
	child2_personal_id2_tag2 = {
		1342574,
		96,
		true
	},
	child2_go_shop = {
		1342670,
		98,
		true
	},
	child2_scratch_minigame_help = {
		1342768,
		522,
		true
	},
	child2_endless_sure_tip = {
		1343290,
		348,
		true
	},
	child2_endless_stage = {
		1343638,
		96,
		true
	},
	child2_cur_wave = {
		1343734,
		86,
		true
	},
	child2_endless_attrs_value = {
		1343820,
		105,
		true
	},
	child2_endless_boss_value = {
		1343925,
		114,
		true
	},
	child2_endless_assest_wave = {
		1344039,
		112,
		true
	},
	child2_endless_history_wave = {
		1344151,
		120,
		true
	},
	child2_endless_current_wave = {
		1344271,
		113,
		true
	},
	child2_endless_reset_tip = {
		1344384,
		175,
		true
	},
	child2_hard = {
		1344559,
		84,
		true
	},
	child2_hard_enter = {
		1344643,
		96,
		true
	},
	child2_switch_sure = {
		1344739,
		337,
		true
	},
	child2_collect_entry_progress = {
		1345076,
		110,
		true
	},
	child2_collect_talent_progress = {
		1345186,
		112,
		true
	},
	child2_word_upgrade = {
		1345298,
		91,
		true
	},
	child2_nailing_minigame_help = {
		1345389,
		849,
		true
	},
	child2_nailing_game_result2 = {
		1346238,
		97,
		true
	},
	child2_game_endless_cnt = {
		1346335,
		103,
		true
	},
	cultivating_plant_task_title = {
		1346438,
		116,
		true
	},
	cultivating_plant_island_task = {
		1346554,
		128,
		true
	},
	cultivating_plant_part_1 = {
		1346682,
		114,
		true
	},
	cultivating_plant_part_2 = {
		1346796,
		118,
		true
	},
	cultivating_plant_part_3 = {
		1346914,
		120,
		true
	},
	child2_priority_tip = {
		1347034,
		117,
		true
	},
	child2_cur_round_temp = {
		1347151,
		95,
		true
	},
	child2_nailing_game_result = {
		1347246,
		96,
		true
	},
	child2_benefit_summary2 = {
		1347342,
		101,
		true
	},
	child2_pool_exhausted = {
		1347443,
		122,
		true
	},
	child2_secretary_skin_confirm = {
		1347565,
		142,
		true
	},
	child2_secretary_skin_expire = {
		1347707,
		128,
		true
	},
	child2_explorer_main_help = {
		1347835,
		600,
		true
	}
}
