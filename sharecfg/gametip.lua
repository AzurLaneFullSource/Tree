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
		89,
		true
	},
	common_not_get_ship = {
		41655,
		101,
		true
	},
	common_sale_out = {
		41756,
		87,
		true
	},
	common_skin_out_of_stock = {
		41843,
		99,
		true
	},
	common_go_home = {
		41942,
		121,
		true
	},
	dont_remind_today = {
		42063,
		89,
		true
	},
	dont_remind_session = {
		42152,
		91,
		true
	},
	battle_no_oil = {
		42243,
		144,
		true
	},
	battle_emptyBlock = {
		42387,
		116,
		true
	},
	battle_duel_main_rage = {
		42503,
		171,
		true
	},
	battle_main_emergent = {
		42674,
		163,
		true
	},
	battle_battleMediator_goOnFight = {
		42837,
		103,
		true
	},
	battle_battleMediator_existFight = {
		42940,
		101,
		true
	},
	battle_battleMediator_remainTime = {
		43041,
		110,
		true
	},
	battle_battleMediator_clear_warning = {
		43151,
		251,
		true
	},
	battle_battleMediator_quest_exist = {
		43402,
		233,
		true
	},
	battle_levelMediator_ok_takeResource = {
		43635,
		119,
		true
	},
	battle_result_time_limit = {
		43754,
		125,
		true
	},
	battle_result_sink_limit = {
		43879,
		111,
		true
	},
	battle_result_undefeated = {
		43990,
		101,
		true
	},
	battle_result_victory = {
		44091,
		98,
		true
	},
	battle_result_defeat_all_enemys = {
		44189,
		117,
		true
	},
	battle_result_base_score = {
		44306,
		102,
		true
	},
	battle_result_dead_score = {
		44408,
		104,
		true
	},
	battle_result_score = {
		44512,
		105,
		true
	},
	battle_result_score_total = {
		44617,
		95,
		true
	},
	battle_result_total_damage = {
		44712,
		103,
		true
	},
	battle_result_contribution = {
		44815,
		111,
		true
	},
	battle_result_total_score = {
		44926,
		101,
		true
	},
	battle_result_max_combo = {
		45027,
		97,
		true
	},
	battle_result_boss_hp_lower = {
		45124,
		125,
		true
	},
	battle_levelScene_0Oil = {
		45249,
		105,
		true
	},
	battle_levelScene_0Gold = {
		45354,
		108,
		true
	},
	battle_levelScene_noRaderCount = {
		45462,
		106,
		true
	},
	battle_levelScene_lock = {
		45568,
		185,
		true
	},
	battle_levelScene_hard_lock = {
		45753,
		245,
		true
	},
	battle_levelScene_close = {
		45998,
		130,
		true
	},
	battle_levelScene_chapter_lock = {
		46128,
		193,
		true
	},
	battle_preCombatLayer_changeFormationError = {
		46321,
		160,
		true
	},
	battle_preCombatLayer_changeFormationNumberError = {
		46481,
		197,
		true
	},
	battle_preCombatLayer_ready = {
		46678,
		141,
		true
	},
	battle_preCombatLayer_quest_leaveFleet = {
		46819,
		151,
		true
	},
	battle_preCombatLayer_clear_confirm = {
		46970,
		154,
		true
	},
	battle_preCombatLayer_auto_confirm = {
		47124,
		176,
		true
	},
	battle_preCombatLayer_save_confirm = {
		47300,
		124,
		true
	},
	battle_preCombatLayer_save_march = {
		47424,
		126,
		true
	},
	battle_preCombatLayer_save_success = {
		47550,
		114,
		true
	},
	battle_preCombatLayer_time_limit = {
		47664,
		123,
		true
	},
	battle_preCombatLayer_sink_limit = {
		47787,
		119,
		true
	},
	battle_preCombatLayer_undefeated = {
		47906,
		119,
		true
	},
	battle_preCombatLayer_victory = {
		48025,
		111,
		true
	},
	battle_preCombatLayer_time_hold = {
		48136,
		119,
		true
	},
	battle_preCombatLayer_damage_before_end = {
		48255,
		158,
		true
	},
	battle_preCombatLayer_destory_transport_ship = {
		48413,
		138,
		true
	},
	battle_preCombatMediator_leastLimit = {
		48551,
		124,
		true
	},
	battle_preCombatMediator_timeout = {
		48675,
		184,
		true
	},
	battle_preCombatMediator_activity_timeout = {
		48859,
		203,
		true
	},
	battle_resourceSiteLayer_collecTimeDefault = {
		49062,
		155,
		true
	},
	battle_resourceSiteLayer_collecTime = {
		49217,
		142,
		true
	},
	battle_resourceSiteLayer_maxLv = {
		49359,
		139,
		true
	},
	battle_resourceSiteLayer_avgLv = {
		49498,
		139,
		true
	},
	battle_resourceSiteLayer_shipTypeCount = {
		49637,
		108,
		true
	},
	battle_resourceSiteLayer_no_maxLv = {
		49745,
		157,
		true
	},
	battle_resourceSiteLayer_no_avgLv = {
		49902,
		157,
		true
	},
	battle_resourceSiteLayer_no_shipTypeCount = {
		50059,
		151,
		true
	},
	battle_resourceSiteLayer_startError_collecting = {
		50210,
		123,
		true
	},
	battle_resourceSiteLayer_startError_not5Ship = {
		50333,
		162,
		true
	},
	battle_resourceSiteLayer_startError_limit = {
		50495,
		153,
		true
	},
	battle_resourceSiteLayer_endError_notStar = {
		50648,
		131,
		true
	},
	battle_resourceSiteLayer_quest_end = {
		50779,
		182,
		true
	},
	battle_resourceSiteMediator_noSite = {
		50961,
		127,
		true
	},
	battle_resourceSiteMediator_shipState_fight = {
		51088,
		157,
		true
	},
	battle_resourceSiteMediator_shipState_rest = {
		51245,
		133,
		true
	},
	battle_resourceSiteMediator_shipState_study = {
		51378,
		133,
		true
	},
	battle_resourceSiteMediator_shipState_event = {
		51511,
		138,
		true
	},
	battle_resourceSiteMediator_shipState_same = {
		51649,
		140,
		true
	},
	battle_resourceSiteMediator_ok_end = {
		51789,
		112,
		true
	},
	battle_autobot_unlock = {
		51901,
		106,
		true
	},
	tips_confirm_teleport_sub = {
		52007,
		335,
		true
	},
	backyard_addExp_Info = {
		52342,
		280,
		true
	},
	backyard_extendCapacity_error = {
		52622,
		111,
		true
	},
	backyard_extendCapacity_ok = {
		52733,
		174,
		true
	},
	backyard_addShip_error = {
		52907,
		106,
		true
	},
	backyard_buyFurniture_error = {
		53013,
		122,
		true
	},
	backyard_extendBackYard_error = {
		53135,
		122,
		true
	},
	backyard_addFood_error = {
		53257,
		108,
		true
	},
	backyard_addFood_ok = {
		53365,
		141,
		true
	},
	backyard_putFurniture_ok = {
		53506,
		94,
		true
	},
	backyard_backyardGranaryLayer_foodCountLimit = {
		53600,
		138,
		true
	},
	backyard_shipAddInimacy_ok = {
		53738,
		161,
		true
	},
	backyard_shipAddInimacy_error = {
		53899,
		119,
		true
	},
	backyard_shipAddMoney_ok = {
		54018,
		185,
		true
	},
	backyard_shipAddMoney_error = {
		54203,
		116,
		true
	},
	backyard_shipExit_error = {
		54319,
		109,
		true
	},
	backyard_shipSpeedUpEnergy_error = {
		54428,
		112,
		true
	},
	backyard_shipAlreadyExit = {
		54540,
		111,
		true
	},
	backyard_backyardGranaryLayer_full = {
		54651,
		163,
		true
	},
	backyard_backyardGranaryLayer_buyCountLimit = {
		54814,
		152,
		true
	},
	backyard_backyardGranaryLayer_error_noResource = {
		54966,
		181,
		true
	},
	backyard_backyardGranaryLayer_noFood = {
		55147,
		151,
		true
	},
	backyard_backyardGranaryLayer_noTimer = {
		55298,
		188,
		true
	},
	backyard_backyardGranaryLayer_word = {
		55486,
		147,
		true
	},
	backyard_backyardGranaryLayer_noShip = {
		55633,
		168,
		true
	},
	backyard_backyardGranaryLayer_foodTimeNotice_top = {
		55801,
		144,
		true
	},
	backyard_backyardGranaryLayer_foodTimeNotice_bottom = {
		55945,
		133,
		true
	},
	backyard_backyardGranaryLayer_foodMaxIncreaseNotice = {
		56078,
		199,
		true
	},
	backyard_backyardGranaryLayer_error_entendFail = {
		56277,
		190,
		true
	},
	backyard_backyardGranaryLayer_buy_max_count = {
		56467,
		154,
		true
	},
	backyard_backyardScene_comforChatContent1 = {
		56621,
		291,
		true
	},
	backyard_backyardScene_comforChatContent2 = {
		56912,
		275,
		true
	},
	backyard_buyExtendItem_question = {
		57187,
		172,
		true
	},
	backyard_backyardScene_expression_label_1 = {
		57359,
		108,
		true
	},
	backyard_backyardScene_expression_label_2 = {
		57467,
		111,
		true
	},
	backyard_backyardScene_expression_label_3 = {
		57578,
		116,
		true
	},
	backyard_backyardScene_quest_clearButton = {
		57694,
		154,
		true
	},
	backyard_backyardScene_quest_saveFurniture = {
		57848,
		152,
		true
	},
	backyard_backyardScene_restSuccess = {
		58000,
		127,
		true
	},
	backyard_backyardScene_clearSuccess = {
		58127,
		131,
		true
	},
	backyard_backyardScene_name = {
		58258,
		123,
		true
	},
	backyard_backyardScene_exitShipAfterAddEnergy = {
		58381,
		154,
		true
	},
	backyard_backyardScene_showAddExpInfo = {
		58535,
		180,
		true
	},
	backyard_backyardScene_error_noPosPutFurniture = {
		58715,
		137,
		true
	},
	backyard_backyardScene_error_noFurniture = {
		58852,
		146,
		true
	},
	backyard_backyardScene_error_canNotRotate = {
		58998,
		158,
		true
	},
	backyard_backyardShipInfoLayer_quest_openPos = {
		59156,
		160,
		true
	},
	backyard_backyardShipInfoLayer_quest_addShipNoFood = {
		59316,
		182,
		true
	},
	backyard_backyardShipInfoLayer_quest_quickAddEnergy = {
		59498,
		196,
		true
	},
	backyard_backyardShipInfoLayer_error_noQuickItem = {
		59694,
		151,
		true
	},
	backyard_backyardShipInfoMediator_shipState_rest = {
		59845,
		149,
		true
	},
	backyard_backyardShipInfoMediator_shipState_fight = {
		59994,
		150,
		true
	},
	backyard_backyardShipInfoMediator_shipState_study = {
		60144,
		139,
		true
	},
	backyard_backyardShipInfoMediator_shipState_collect = {
		60283,
		146,
		true
	},
	backyard_backyardShipInfoMediator_shipState_event = {
		60429,
		150,
		true
	},
	backyard_backyardShipInfoMediator_quest_moveOutFleet = {
		60579,
		228,
		true
	},
	backyard_backyardShipInfoMediator_error_vanguardFleetOnlyOneShip = {
		60807,
		174,
		true
	},
	backyard_backyardShipInfoMediator_error_mainFleetOnlyOneShip = {
		60981,
		172,
		true
	},
	backyard_backyardShipInfoMediator_ok_addShip = {
		61153,
		119,
		true
	},
	backyard_backyardShipInfoMediator_ok_unlock = {
		61272,
		116,
		true
	},
	backyard_backyardShipInfoMediator_error_noFood = {
		61388,
		140,
		true
	},
	backyard_backyardShipInfoMediator_error_fullEnergy = {
		61528,
		142,
		true
	},
	backyard_backyardShipInfoMediator_error_fleetOnlyOneShip = {
		61670,
		188,
		true
	},
	backyard_open_2floor = {
		61858,
		224,
		true
	},
	backyarad_theme_replace = {
		62082,
		168,
		true
	},
	backyard_extendArea_ok = {
		62250,
		100,
		true
	},
	backyard_extendArea_erro = {
		62350,
		137,
		true
	},
	backyard_extendArea_tip = {
		62487,
		141,
		true
	},
	backyard_notPosition_shipExit = {
		62628,
		131,
		true
	},
	backyard_no_ship_tip = {
		62759,
		104,
		true
	},
	backyard_energy_qiuck_up_tip = {
		62863,
		225,
		true
	},
	backyard_cant_put_tip = {
		63088,
		101,
		true
	},
	backyard_cant_buy_tip = {
		63189,
		104,
		true
	},
	backyard_theme_lock_tip = {
		63293,
		138,
		true
	},
	backyard_theme_open_tip = {
		63431,
		144,
		true
	},
	backyard_theme_furniture_buy_tip = {
		63575,
		272,
		true
	},
	backyard_cannot_repeat_purchase = {
		63847,
		118,
		true
	},
	backyard_theme_bought = {
		63965,
		94,
		true
	},
	backyard_interAction_no_open = {
		64059,
		132,
		true
	},
	backyard_theme_no_exist = {
		64191,
		108,
		true
	},
	backayrd_theme_delete_sucess = {
		64299,
		106,
		true
	},
	backayrd_theme_delete_erro = {
		64405,
		113,
		true
	},
	backyard_ship_on_furnitrue = {
		64518,
		141,
		true
	},
	backyard_save_empty_theme = {
		64659,
		117,
		true
	},
	backyard_theme_name_forbid = {
		64776,
		130,
		true
	},
	backyard_getResource_emptry = {
		64906,
		111,
		true
	},
	backyard_no_pos_for_ship = {
		65017,
		161,
		true
	},
	equipment_destroyEquipments_error_noEquip = {
		65178,
		125,
		true
	},
	equipment_destroyEquipments_error_notEnoughEquip = {
		65303,
		128,
		true
	},
	equipment_equipDevUI_error_noPos = {
		65431,
		122,
		true
	},
	equipment_equipmentInfoLayer_error_canNotEquip = {
		65553,
		153,
		true
	},
	equipment_equipmentScene_selectError_more = {
		65706,
		163,
		true
	},
	equipment_newEquipLayer_getNewEquip = {
		65869,
		140,
		true
	},
	equipment_select_materials_tip = {
		66009,
		95,
		true
	},
	equipment_select_device_tip = {
		66104,
		119,
		true
	},
	equipment_cant_unload = {
		66223,
		159,
		true
	},
	equipment_max_level = {
		66382,
		97,
		true
	},
	equipment_upgrade_costcheck_error = {
		66479,
		164,
		true
	},
	equipment_upgrade_feedback_lack_of_fragment = {
		66643,
		148,
		true
	},
	exercise_count_insufficient = {
		66791,
		147,
		true
	},
	exercise_clear_fleet_tip = {
		66938,
		203,
		true
	},
	exercise_fleet_exit_tip = {
		67141,
		205,
		true
	},
	exercise_replace_rivals_ok_tip = {
		67346,
		112,
		true
	},
	exercise_replace_rivals_question = {
		67458,
		163,
		true
	},
	exercise_count_recover_tip = {
		67621,
		128,
		true
	},
	exercise_shop_refresh_tip = {
		67749,
		152,
		true
	},
	exercise_shop_buy_tip = {
		67901,
		141,
		true
	},
	exercise_formation_title = {
		68042,
		112,
		true
	},
	exercise_time_tip = {
		68154,
		99,
		true
	},
	exercise_rule_tip = {
		68253,
		1371,
		true
	},
	exercise_award_tip = {
		69624,
		190,
		true
	},
	dock_yard_left_tips = {
		69814,
		132,
		true
	},
	fleet_error_no_fleet = {
		69946,
		105,
		true
	},
	fleet_repairShips_error_fullEnergy = {
		70051,
		138,
		true
	},
	fleet_repairShips_error_noResource = {
		70189,
		126,
		true
	},
	fleet_repairShips_quest = {
		70315,
		157,
		true
	},
	fleet_fleetRaname_error = {
		70472,
		105,
		true
	},
	fleet_updateFleet_error = {
		70577,
		111,
		true
	},
	friend_acceptFriendRequest_error = {
		70688,
		130,
		true
	},
	friend_deleteFriend_error = {
		70818,
		114,
		true
	},
	friend_fetchFriendMsg_error = {
		70932,
		119,
		true
	},
	friend_rejectFriendRequest_error = {
		71051,
		130,
		true
	},
	friend_searchFriend_noPlayer = {
		71181,
		120,
		true
	},
	friend_sendFriendMsg_error = {
		71301,
		114,
		true
	},
	friend_sendFriendMsg_error_noFriend = {
		71415,
		137,
		true
	},
	friend_sendFriendRequest_error = {
		71552,
		118,
		true
	},
	friend_addblacklist_error = {
		71670,
		110,
		true
	},
	friend_relieveblacklist_error = {
		71780,
		126,
		true
	},
	friend_sendFriendRequest_success = {
		71906,
		116,
		true
	},
	friend_relieveblacklist_success = {
		72022,
		118,
		true
	},
	friend_addblacklist_success = {
		72140,
		110,
		true
	},
	friend_confirm_add_blacklist = {
		72250,
		199,
		true
	},
	friend_relieve_backlist_tip = {
		72449,
		171,
		true
	},
	friend_player_is_friend_tip = {
		72620,
		133,
		true
	},
	friend_searchFriend_wait_time = {
		72753,
		123,
		true
	},
	lesson_classOver_error = {
		72876,
		113,
		true
	},
	lesson_endToLearn_error = {
		72989,
		101,
		true
	},
	lesson_startToLearn_error = {
		73090,
		112,
		true
	},
	tactics_lesson_cancel = {
		73202,
		227,
		true
	},
	tactics_lesson_system_introduce = {
		73429,
		287,
		true
	},
	tactics_lesson_start_tip = {
		73716,
		243,
		true
	},
	tactics_noskill_erro = {
		73959,
		101,
		true
	},
	tactics_max_level = {
		74060,
		120,
		true
	},
	tactics_end_to_learn = {
		74180,
		206,
		true
	},
	tactics_continue_to_learn = {
		74386,
		127,
		true
	},
	tactics_should_exist_skill = {
		74513,
		107,
		true
	},
	tactics_skill_level_up = {
		74620,
		128,
		true
	},
	tactics_no_lesson = {
		74748,
		100,
		true
	},
	tactics_lesson_full = {
		74848,
		100,
		true
	},
	tactics_lesson_repeated = {
		74948,
		110,
		true
	},
	login_gate_not_ready = {
		75058,
		100,
		true
	},
	login_game_not_ready = {
		75158,
		105,
		true
	},
	login_game_rigister_full = {
		75263,
		128,
		true
	},
	login_game_login_full = {
		75391,
		158,
		true
	},
	login_game_banned = {
		75549,
		130,
		true
	},
	login_game_frequence = {
		75679,
		138,
		true
	},
	login_createNewPlayer_full = {
		75817,
		138,
		true
	},
	login_createNewPlayer_error = {
		75955,
		112,
		true
	},
	login_createNewPlayer_error_nameNull = {
		76067,
		128,
		true
	},
	login_newPlayerScene_word_lingBo = {
		76195,
		179,
		true
	},
	login_newPlayerScene_word_yingHuoChong = {
		76374,
		210,
		true
	},
	login_newPlayerScene_word_laFei = {
		76584,
		200,
		true
	},
	login_newPlayerScene_word_biaoqiang = {
		76784,
		187,
		true
	},
	login_newPlayerScene_word_z23 = {
		76971,
		194,
		true
	},
	login_newPlayerScene_randomName = {
		77165,
		106,
		true
	},
	login_newPlayerScene_error_notChoiseShip = {
		77271,
		125,
		true
	},
	login_newPlayerScene_inputName = {
		77396,
		104,
		true
	},
	login_loginMediator_kickOtherLogin = {
		77500,
		143,
		true
	},
	login_loginMediator_kickServerClose = {
		77643,
		117,
		true
	},
	login_loginMediator_kickIntError = {
		77760,
		109,
		true
	},
	login_loginMediator_kickTimeError = {
		77869,
		118,
		true
	},
	login_loginMediator_vertifyFail = {
		77987,
		118,
		true
	},
	login_loginMediator_dataExpired = {
		78105,
		113,
		true
	},
	login_loginMediator_kickLoginOut = {
		78218,
		112,
		true
	},
	login_loginMediator_serverLoginErro = {
		78330,
		125,
		true
	},
	login_loginMediator_kickUndefined = {
		78455,
		120,
		true
	},
	login_loginMediator_loginSuccess = {
		78575,
		113,
		true
	},
	login_loginMediator_quest_RegisterSuccess = {
		78688,
		151,
		true
	},
	login_loginMediator_registerFail_error = {
		78839,
		123,
		true
	},
	login_loginMediator_userLoginFail_error = {
		78962,
		124,
		true
	},
	login_loginMediator_serverLoginFail_error = {
		79086,
		123,
		true
	},
	login_loginScene_error_noUserName = {
		79209,
		123,
		true
	},
	login_loginScene_error_noPassword = {
		79332,
		123,
		true
	},
	login_loginScene_error_diffPassword = {
		79455,
		122,
		true
	},
	login_loginScene_error_noMailBox = {
		79577,
		119,
		true
	},
	login_loginScene_choiseServer = {
		79696,
		116,
		true
	},
	login_loginScene_server_vindicate = {
		79812,
		125,
		true
	},
	login_loginScene_server_full = {
		79937,
		107,
		true
	},
	login_loginScene_server_disabled = {
		80044,
		108,
		true
	},
	login_register_full = {
		80152,
		111,
		true
	},
	system_database_busy = {
		80263,
		125,
		true
	},
	mail_getMailList_error_noNewMail = {
		80388,
		108,
		true
	},
	mail_takeAttachment_error_noMail = {
		80496,
		119,
		true
	},
	mail_takeAttachment_error_noAttach = {
		80615,
		124,
		true
	},
	mail_takeAttachment_error_noWorld = {
		80739,
		161,
		true
	},
	mail_takeAttachment_error_reWorld = {
		80900,
		205,
		true
	},
	mail_count = {
		81105,
		118,
		true
	},
	mail_takeAttachment_error_magazine_full = {
		81223,
		215,
		true
	},
	mail_takeAttachment_error_dockYrad_full = {
		81438,
		208,
		true
	},
	mail_confirm_set_important_flag = {
		81646,
		112,
		true
	},
	mail_confirm_cancel_important_flag = {
		81758,
		117,
		true
	},
	mail_confirm_delete_important_flag = {
		81875,
		132,
		true
	},
	mail_mail_page = {
		82007,
		82,
		true
	},
	mail_storeroom_page = {
		82089,
		90,
		true
	},
	mail_boxroom_page = {
		82179,
		88,
		true
	},
	mail_all_page = {
		82267,
		80,
		true
	},
	mail_important_page = {
		82347,
		92,
		true
	},
	mail_rare_page = {
		82439,
		85,
		true
	},
	mail_reward_got = {
		82524,
		86,
		true
	},
	mail_reward_tips = {
		82610,
		139,
		true
	},
	mail_boxroom_extend_title = {
		82749,
		103,
		true
	},
	mail_boxroom_extend_tips = {
		82852,
		113,
		true
	},
	mail_buy_button = {
		82965,
		82,
		true
	},
	mail_manager_title = {
		83047,
		93,
		true
	},
	mail_manager_tips_2 = {
		83140,
		142,
		true
	},
	mail_manager_all = {
		83282,
		98,
		true
	},
	mail_manager_rare = {
		83380,
		113,
		true
	},
	mail_get_oneclick = {
		83493,
		92,
		true
	},
	mail_read_oneclick = {
		83585,
		92,
		true
	},
	mail_delete_oneclick = {
		83677,
		96,
		true
	},
	mail_search_new = {
		83773,
		92,
		true
	},
	mail_receive_time = {
		83865,
		92,
		true
	},
	mail_move_oneclick = {
		83957,
		92,
		true
	},
	mail_deleteread_button = {
		84049,
		97,
		true
	},
	mail_manage_button = {
		84146,
		93,
		true
	},
	mail_move_button = {
		84239,
		90,
		true
	},
	mail_delet_button = {
		84329,
		87,
		true
	},
	mail_delet_button_1 = {
		84416,
		94,
		true
	},
	mail_moveone_button = {
		84510,
		92,
		true
	},
	mail_getone_button = {
		84602,
		95,
		true
	},
	mail_take_all_mail_msgbox = {
		84697,
		147,
		true
	},
	mail_take_maildetail_msgbox = {
		84844,
		103,
		true
	},
	mail_take_canget_msgbox = {
		84947,
		117,
		true
	},
	mail_getbox_title = {
		85064,
		91,
		true
	},
	mail_title_new = {
		85155,
		82,
		true
	},
	mail_boxtitle_information = {
		85237,
		93,
		true
	},
	mail_box_confirm = {
		85330,
		87,
		true
	},
	mail_box_cancel = {
		85417,
		85,
		true
	},
	mail_title_English = {
		85502,
		89,
		true
	},
	mail_toggle_on = {
		85591,
		80,
		true
	},
	mail_toggle_off = {
		85671,
		82,
		true
	},
	main_mailLayer_mailBoxClear = {
		85753,
		115,
		true
	},
	main_mailLayer_noNewMail = {
		85868,
		100,
		true
	},
	main_mailLayer_takeAttach = {
		85968,
		104,
		true
	},
	main_mailLayer_noAttach = {
		86072,
		97,
		true
	},
	main_mailLayer_attachTaken = {
		86169,
		107,
		true
	},
	main_mailLayer_quest_clear = {
		86276,
		207,
		true
	},
	main_mailLayer_quest_clear_choice = {
		86483,
		218,
		true
	},
	main_mailLayer_quest_deleteNotTakeAttach = {
		86701,
		204,
		true
	},
	main_mailLayer_quest_deleteNotRead = {
		86905,
		203,
		true
	},
	main_mailMediator_mailDelete = {
		87108,
		104,
		true
	},
	main_mailMediator_attachTaken = {
		87212,
		110,
		true
	},
	main_mailMediator_mailread = {
		87322,
		121,
		true
	},
	main_mailMediator_mailmove = {
		87443,
		126,
		true
	},
	main_mailMediator_notingToTake = {
		87569,
		115,
		true
	},
	main_mailMediator_takeALot = {
		87684,
		101,
		true
	},
	main_navalAcademyScene_systemClose = {
		87785,
		148,
		true
	},
	main_navalAcademyScene_quest_startClass = {
		87933,
		170,
		true
	},
	main_navalAcademyScene_quest_stopClass = {
		88103,
		248,
		true
	},
	main_navalAcademyScene_quest_Classover_long = {
		88351,
		226,
		true
	},
	main_navalAcademyScene_quest_Classover_short = {
		88577,
		196,
		true
	},
	main_navalAcademyScene_upgrade_complete = {
		88773,
		182,
		true
	},
	main_navalAcademyScene_class_upgrade_complete = {
		88955,
		131,
		true
	},
	main_navalAcademyScene_work_done = {
		89086,
		118,
		true
	},
	main_notificationLayer_searchInput = {
		89204,
		130,
		true
	},
	main_notificationLayer_noInput = {
		89334,
		117,
		true
	},
	main_notificationLayer_noFriend = {
		89451,
		122,
		true
	},
	main_notificationLayer_deleteFriend = {
		89573,
		112,
		true
	},
	main_notificationLayer_sendButton = {
		89685,
		122,
		true
	},
	main_notificationLayer_addFriendError_addSelf = {
		89807,
		136,
		true
	},
	main_notificationLayer_addFriendError_friendAlready = {
		89943,
		156,
		true
	},
	main_notificationLayer_quest_deletFriend = {
		90099,
		163,
		true
	},
	main_notificationLayer_quest_request = {
		90262,
		166,
		true
	},
	main_notificationLayer_enter_room = {
		90428,
		137,
		true
	},
	main_notificationLayer_not_roomId = {
		90565,
		121,
		true
	},
	main_notificationLayer_roomId_invaild = {
		90686,
		124,
		true
	},
	main_notificationMediator_sendFriendRequest = {
		90810,
		127,
		true
	},
	main_notificationMediator_beFriend = {
		90937,
		150,
		true
	},
	main_notificationMediator_deleteFriend = {
		91087,
		160,
		true
	},
	main_notificationMediator_room_max_number = {
		91247,
		122,
		true
	},
	main_playerInfoLayer_inputName = {
		91369,
		104,
		true
	},
	main_playerInfoLayer_inputManifesto = {
		91473,
		123,
		true
	},
	main_playerInfoLayer_quest_changeName = {
		91596,
		159,
		true
	},
	main_playerInfoLayer_error_changeNameNoGem = {
		91755,
		134,
		true
	},
	main_settingsScene_quest_exist = {
		91889,
		126,
		true
	},
	coloring_color_missmatch = {
		92015,
		128,
		true
	},
	coloring_color_not_enough = {
		92143,
		117,
		true
	},
	coloring_erase_all_warning = {
		92260,
		200,
		true
	},
	coloring_erase_warning = {
		92460,
		231,
		true
	},
	coloring_lock = {
		92691,
		88,
		true
	},
	coloring_wait_open = {
		92779,
		91,
		true
	},
	coloring_help_tip = {
		92870,
		1235,
		true
	},
	link_link_help_tip = {
		94105,
		1207,
		true
	},
	player_changeManifesto_ok = {
		95312,
		103,
		true
	},
	player_changeManifesto_error = {
		95415,
		116,
		true
	},
	player_changePlayerIcon_ok = {
		95531,
		108,
		true
	},
	player_changePlayerIcon_error = {
		95639,
		121,
		true
	},
	player_changePlayerName_ok = {
		95760,
		103,
		true
	},
	player_changePlayerName_error = {
		95863,
		116,
		true
	},
	player_changePlayerName_error_2015 = {
		95979,
		136,
		true
	},
	player_harvestResource_error = {
		96115,
		121,
		true
	},
	player_harvestResource_error_fullBag = {
		96236,
		145,
		true
	},
	player_change_chat_room_erro = {
		96381,
		123,
		true
	},
	prop_destroyProp_error_noItem = {
		96504,
		118,
		true
	},
	prop_destroyProp_error_canNotSell = {
		96622,
		123,
		true
	},
	prop_destroyProp_error_notEnoughItem = {
		96745,
		151,
		true
	},
	prop_destroyProp_error = {
		96896,
		108,
		true
	},
	resourceSite_error_noSite = {
		97004,
		118,
		true
	},
	resourceSite_beginScanMap_ok = {
		97122,
		108,
		true
	},
	resourceSite_beginScanMap_error = {
		97230,
		114,
		true
	},
	resourceSite_collectResource_error = {
		97344,
		134,
		true
	},
	resourceSite_finishResourceSite_error = {
		97478,
		133,
		true
	},
	resourceSite_startResourceSite_error = {
		97611,
		134,
		true
	},
	ship_error_noShip = {
		97745,
		133,
		true
	},
	ship_addStarExp_error = {
		97878,
		109,
		true
	},
	ship_buildShip_error = {
		97987,
		106,
		true
	},
	ship_buildShip_error_noTemplate = {
		98093,
		150,
		true
	},
	ship_buildShip_error_notEnoughItem = {
		98243,
		131,
		true
	},
	ship_buildShipImmediately_error = {
		98374,
		115,
		true
	},
	ship_buildShipImmediately_error_noSHip = {
		98489,
		119,
		true
	},
	ship_buildShipImmediately_error_finished = {
		98608,
		126,
		true
	},
	ship_buildShipImmediately_error_noItem = {
		98734,
		138,
		true
	},
	ship_buildShip_not_position = {
		98872,
		143,
		true
	},
	ship_buildBatchShip = {
		99015,
		181,
		true
	},
	ship_buildSingleShip = {
		99196,
		181,
		true
	},
	ship_buildShip_succeed = {
		99377,
		100,
		true
	},
	ship_buildShip_list_empty = {
		99477,
		117,
		true
	},
	ship_buildship_tip = {
		99594,
		191,
		true
	},
	ship_destoryShips_error = {
		99785,
		110,
		true
	},
	ship_equipToShip_ok = {
		99895,
		118,
		true
	},
	ship_equipToShip_error = {
		100013,
		103,
		true
	},
	ship_equipToShip_error_noEquip = {
		100116,
		114,
		true
	},
	ship_equip_check = {
		100230,
		138,
		true
	},
	ship_getShip_error = {
		100368,
		105,
		true
	},
	ship_getShip_error_noShip = {
		100473,
		106,
		true
	},
	ship_getShip_error_notFinish = {
		100579,
		122,
		true
	},
	ship_getShip_error_full = {
		100701,
		153,
		true
	},
	ship_modShip_error = {
		100854,
		106,
		true
	},
	ship_modShip_error_notEnoughGold = {
		100960,
		136,
		true
	},
	ship_remouldShip_error = {
		101096,
		106,
		true
	},
	ship_unequipFromShip_ok = {
		101202,
		126,
		true
	},
	ship_unequipFromShip_error = {
		101328,
		114,
		true
	},
	ship_unequipFromShip_error_noEquip = {
		101442,
		119,
		true
	},
	ship_unequip_all_tip = {
		101561,
		126,
		true
	},
	ship_unequip_all_success = {
		101687,
		127,
		true
	},
	ship_updateShipLock_ok_lock = {
		101814,
		124,
		true
	},
	ship_updateShipLock_ok_unlock = {
		101938,
		128,
		true
	},
	ship_updateShipLock_error = {
		102066,
		119,
		true
	},
	ship_upgradeStar_error = {
		102185,
		106,
		true
	},
	ship_upgradeStar_error_4010 = {
		102291,
		152,
		true
	},
	ship_upgradeStar_error_lvLimit = {
		102443,
		155,
		true
	},
	ship_upgradeStar_error_noEnoughMatrail = {
		102598,
		125,
		true
	},
	ship_upgradeStar_notConfig = {
		102723,
		151,
		true
	},
	ship_upgradeStar_maxLevel = {
		102874,
		121,
		true
	},
	ship_upgradeStar_select_material_tip = {
		102995,
		124,
		true
	},
	ship_exchange_question = {
		103119,
		159,
		true
	},
	ship_exchange_medalCount_noEnough = {
		103278,
		126,
		true
	},
	ship_exchange_erro = {
		103404,
		124,
		true
	},
	ship_exchange_confirm = {
		103528,
		111,
		true
	},
	ship_exchange_tip = {
		103639,
		289,
		true
	},
	ship_vo_fighting = {
		103928,
		120,
		true
	},
	ship_vo_event = {
		104048,
		123,
		true
	},
	ship_vo_isCharacter = {
		104171,
		153,
		true
	},
	ship_vo_inBackyardRest = {
		104324,
		126,
		true
	},
	ship_vo_inClass = {
		104450,
		110,
		true
	},
	ship_vo_moveout_backyard = {
		104560,
		103,
		true
	},
	ship_vo_moveout_formation = {
		104663,
		111,
		true
	},
	ship_vo_mainFleet_must_hasShip = {
		104774,
		146,
		true
	},
	ship_vo_vanguardFleet_must_hasShip = {
		104920,
		148,
		true
	},
	ship_vo_getWordsUndefined = {
		105068,
		142,
		true
	},
	ship_vo_locked = {
		105210,
		98,
		true
	},
	ship_vo_mainFleet_exist_same_ship = {
		105308,
		146,
		true
	},
	ship_vo_vanguardFleet_exist_same_ship = {
		105454,
		148,
		true
	},
	ship_buildShipMediator_startBuild = {
		105602,
		108,
		true
	},
	ship_buildShipMediator_finishBuild = {
		105710,
		120,
		true
	},
	ship_buildShipScene_quest_quickFinish = {
		105830,
		235,
		true
	},
	ship_dockyardMediator_destroy = {
		106065,
		106,
		true
	},
	ship_dockyardScene_capacity = {
		106171,
		105,
		true
	},
	ship_dockyardScene_noRole = {
		106276,
		123,
		true
	},
	ship_dockyardScene_error_choiseRoleMore = {
		106399,
		163,
		true
	},
	ship_dockyardScene_error_choiseRoleLess = {
		106562,
		157,
		true
	},
	ship_formationMediator_leastLimit = {
		106719,
		122,
		true
	},
	ship_formationMediator_changeNameSuccess = {
		106841,
		123,
		true
	},
	ship_formationMediator_changeNameError_sameShip = {
		106964,
		173,
		true
	},
	ship_formationMediator_addShipError_overlimit = {
		107137,
		182,
		true
	},
	ship_formationMediator_replaceError_onlyShip = {
		107319,
		212,
		true
	},
	ship_formationMediator_quest_replace = {
		107531,
		188,
		true
	},
	ship_formationMediaror_trash_warning = {
		107719,
		264,
		true
	},
	ship_formationUI_fleetName1 = {
		107983,
		98,
		true
	},
	ship_formationUI_fleetName2 = {
		108081,
		98,
		true
	},
	ship_formationUI_fleetName3 = {
		108179,
		98,
		true
	},
	ship_formationUI_fleetName4 = {
		108277,
		98,
		true
	},
	ship_formationUI_fleetName5 = {
		108375,
		98,
		true
	},
	ship_formationUI_fleetName6 = {
		108473,
		98,
		true
	},
	ship_formationUI_fleetName11 = {
		108571,
		103,
		true
	},
	ship_formationUI_fleetName12 = {
		108674,
		103,
		true
	},
	ship_formationUI_fleetName13 = {
		108777,
		105,
		true
	},
	ship_formationUI_exercise_fleetName = {
		108882,
		113,
		true
	},
	ship_formationUI_fleetName_world = {
		108995,
		117,
		true
	},
	ship_formationUI_changeFormationError_flag = {
		109112,
		160,
		true
	},
	ship_formationUI_changeFormationError_countError = {
		109272,
		139,
		true
	},
	ship_formationUI_removeError_onlyShip = {
		109411,
		190,
		true
	},
	ship_formationUI_quest_remove = {
		109601,
		152,
		true
	},
	ship_newShipLayer_get = {
		109753,
		147,
		true
	},
	ship_newSkinLayer_get = {
		109900,
		152,
		true
	},
	ship_newSkin_name = {
		110052,
		83,
		true
	},
	ship_shipInfoMediator_destory = {
		110135,
		106,
		true
	},
	ship_shipInfoScene_equipUnlockSlostContent = {
		110241,
		166,
		true
	},
	ship_shipInfoScene_equipUnlockSlostYesText = {
		110407,
		118,
		true
	},
	ship_shipInfoScene_effect = {
		110525,
		132,
		true
	},
	ship_shipInfoScene_effect1or2 = {
		110657,
		134,
		true
	},
	ship_shipInfoScene_modLvMax = {
		110791,
		135,
		true
	},
	ship_shipInfoScene_choiseMod = {
		110926,
		132,
		true
	},
	ship_shipModLayer_effect = {
		111058,
		131,
		true
	},
	ship_shipModLayer_effect1or2 = {
		111189,
		133,
		true
	},
	ship_shipModLayer_modSuccess = {
		111322,
		101,
		true
	},
	ship_mod_no_addition_tip = {
		111423,
		145,
		true
	},
	ship_shipModMediator_choiseMaterial = {
		111568,
		150,
		true
	},
	ship_shipModMediator_noticeLvOver1 = {
		111718,
		111,
		true
	},
	ship_shipModMediator_noticeStarOver4 = {
		111829,
		112,
		true
	},
	ship_shipModMediator_noticeSameButLargerStar = {
		111941,
		131,
		true
	},
	ship_shipModMediator_quest = {
		112072,
		168,
		true
	},
	ship_shipUpgradeLayer2_levelError = {
		112240,
		114,
		true
	},
	ship_shipUpgradeLayer2_noMaterail = {
		112354,
		120,
		true
	},
	ship_shipUpgradeLayer2_ok = {
		112474,
		110,
		true
	},
	ship_shipUpgradeLayer2_effect = {
		112584,
		136,
		true
	},
	ship_shipUpgradeLayer2_effect1or2 = {
		112720,
		138,
		true
	},
	ship_shipUpgradeLayer2_mod_uncommon_tip = {
		112858,
		221,
		true
	},
	ship_shipUpgradeLayer2_uncommon_tip = {
		113079,
		217,
		true
	},
	ship_shipUpgradeLayer2_mod_advanced_tip = {
		113296,
		220,
		true
	},
	ship_shipUpgradeLayer2_advanced_tip = {
		113516,
		222,
		true
	},
	ship_mod_exp_to_attr_tip = {
		113738,
		145,
		true
	},
	ship_max_star = {
		113883,
		144,
		true
	},
	ship_skill_unlock_tip = {
		114027,
		106,
		true
	},
	ship_lock_tip = {
		114133,
		131,
		true
	},
	ship_destroy_uncommon_tip = {
		114264,
		186,
		true
	},
	ship_destroy_advanced_tip = {
		114450,
		162,
		true
	},
	ship_energy_mid_desc = {
		114612,
		132,
		true
	},
	ship_energy_low_desc = {
		114744,
		133,
		true
	},
	ship_energy_low_warn = {
		114877,
		169,
		true
	},
	ship_energy_low_warn_no_exp = {
		115046,
		274,
		true
	},
	test_ship_intensify_tip = {
		115320,
		115,
		true
	},
	test_ship_upgrade_tip = {
		115435,
		126,
		true
	},
	shop_buyItem_ok = {
		115561,
		138,
		true
	},
	shop_buyItem_error = {
		115699,
		102,
		true
	},
	shop_extendMagazine_error = {
		115801,
		115,
		true
	},
	shop_entendShipYard_error = {
		115916,
		112,
		true
	},
	spweapon_attr_effect = {
		116028,
		96,
		true
	},
	spweapon_attr_skillupgrade = {
		116124,
		103,
		true
	},
	spweapon_help_storage = {
		116227,
		3345,
		true
	},
	spweapon_tip_upgrade = {
		119572,
		120,
		true
	},
	spweapon_tip_attr_modify = {
		119692,
		148,
		true
	},
	spweapon_tip_materal_no_enough = {
		119840,
		126,
		true
	},
	spweapon_tip_gold_no_enough = {
		119966,
		119,
		true
	},
	spweapon_tip_pt_no_enough = {
		120085,
		143,
		true
	},
	spweapon_tip_creatept_no_enough = {
		120228,
		180,
		true
	},
	spweapon_tip_bag_no_enough = {
		120408,
		148,
		true
	},
	spweapon_tip_create_sussess = {
		120556,
		151,
		true
	},
	spweapon_tip_group_error = {
		120707,
		125,
		true
	},
	spweapon_tip_breakout_overflow = {
		120832,
		172,
		true
	},
	spweapon_tip_breakout_materal_check = {
		121004,
		144,
		true
	},
	spweapon_tip_transform_materal_check = {
		121148,
		146,
		true
	},
	spweapon_tip_transform_attrmax = {
		121294,
		148,
		true
	},
	spweapon_tip_locked = {
		121442,
		180,
		true
	},
	spweapon_tip_unload = {
		121622,
		135,
		true
	},
	spweapon_tip_sail_locked = {
		121757,
		157,
		true
	},
	spweapon_ui_level = {
		121914,
		94,
		true
	},
	spweapon_ui_levelmax = {
		122008,
		93,
		true
	},
	spweapon_ui_levelmax2 = {
		122101,
		126,
		true
	},
	spweapon_ui_need_resource = {
		122227,
		108,
		true
	},
	spweapon_ui_ptitem = {
		122335,
		96,
		true
	},
	spweapon_ui_spweapon = {
		122431,
		98,
		true
	},
	spweapon_ui_transform = {
		122529,
		105,
		true
	},
	spweapon_ui_transform_attr_text = {
		122634,
		197,
		true
	},
	spweapon_ui_keep_attr = {
		122831,
		93,
		true
	},
	spweapon_ui_change_attr = {
		122924,
		94,
		true
	},
	spweapon_ui_autoselect = {
		123018,
		97,
		true
	},
	spweapon_ui_cancelselect = {
		123115,
		94,
		true
	},
	spweapon_ui_index_shipType_quZhu = {
		123209,
		98,
		true
	},
	spweapon_ui_index_shipType_qinXun = {
		123307,
		99,
		true
	},
	spweapon_ui_index_shipType_zhongXun = {
		123406,
		101,
		true
	},
	spweapon_ui_index_shipType_zhanLie = {
		123507,
		100,
		true
	},
	spweapon_ui_index_shipType_hangMu = {
		123607,
		99,
		true
	},
	spweapon_ui_index_shipType_weiXiu = {
		123706,
		99,
		true
	},
	spweapon_ui_index_shipType_qianTing = {
		123805,
		101,
		true
	},
	spweapon_ui_index_shipType_other = {
		123906,
		100,
		true
	},
	spweapon_ui_keep_attr_text1 = {
		124006,
		206,
		true
	},
	spweapon_ui_keep_attr_text2 = {
		124212,
		150,
		true
	},
	spweapon_ui_change_attr_text1 = {
		124362,
		176,
		true
	},
	spweapon_ui_change_attr_text2 = {
		124538,
		214,
		true
	},
	spweapon_ui_create_exp = {
		124752,
		115,
		true
	},
	spweapon_ui_upgrade_exp = {
		124867,
		118,
		true
	},
	spweapon_ui_breakout_exp = {
		124985,
		117,
		true
	},
	spweapon_ui_create = {
		125102,
		87,
		true
	},
	spweapon_ui_storage = {
		125189,
		88,
		true
	},
	spweapon_ui_empty = {
		125277,
		106,
		true
	},
	spweapon_ui_create_button = {
		125383,
		94,
		true
	},
	spweapon_ui_helptext = {
		125477,
		295,
		true
	},
	spweapon_ui_effect_tag = {
		125772,
		98,
		true
	},
	spweapon_ui_skill_tag = {
		125870,
		98,
		true
	},
	spweapon_activity_ui_text1 = {
		125968,
		174,
		true
	},
	spweapon_activity_ui_text2 = {
		126142,
		165,
		true
	},
	spweapon_tip_skill_locked = {
		126307,
		98,
		true
	},
	spweapon_tip_owned = {
		126405,
		91,
		true
	},
	spweapon_tip_view = {
		126496,
		145,
		true
	},
	spweapon_tip_ship = {
		126641,
		93,
		true
	},
	spweapon_tip_type = {
		126734,
		90,
		true
	},
	stage_beginStage_error = {
		126824,
		109,
		true
	},
	stage_beginStage_error_fleetEmpty = {
		126933,
		120,
		true
	},
	stage_beginStage_error_teamEmpty = {
		127053,
		173,
		true
	},
	stage_beginStage_error_noEnergy = {
		127226,
		143,
		true
	},
	stage_beginStage_error_noResource = {
		127369,
		147,
		true
	},
	stage_beginStage_error_noTicket = {
		127516,
		148,
		true
	},
	stage_finishStage_error = {
		127664,
		115,
		true
	},
	levelScene_map_lock = {
		127779,
		157,
		true
	},
	levelScene_chapter_lock = {
		127936,
		146,
		true
	},
	levelScene_chapter_strategying = {
		128082,
		141,
		true
	},
	levelScene_threat_to_rule_out = {
		128223,
		112,
		true
	},
	levelScene_whether_to_retreat = {
		128335,
		168,
		true
	},
	levelScene_who_to_retreat = {
		128503,
		165,
		true
	},
	levelScene_who_to_exchange = {
		128668,
		138,
		true
	},
	levelScene_time_out = {
		128806,
		104,
		true
	},
	levelScene_nothing = {
		128910,
		103,
		true
	},
	levelScene_notCargo = {
		129013,
		107,
		true
	},
	levelScene_openCargo_erro = {
		129120,
		119,
		true
	},
	levelScene_chapter_notInStrategy = {
		129239,
		114,
		true
	},
	levelScene_retreat_erro = {
		129353,
		105,
		true
	},
	levelScene_strategying = {
		129458,
		100,
		true
	},
	levelScene_tracking_erro = {
		129558,
		94,
		true
	},
	levelScene_tracking_error_3001 = {
		129652,
		150,
		true
	},
	levelScene_chapter_unlock_tip = {
		129802,
		163,
		true
	},
	levelScene_chapter_win = {
		129965,
		116,
		true
	},
	levelScene_sham_win = {
		130081,
		110,
		true
	},
	levelScene_escort_win = {
		130191,
		154,
		true
	},
	levelScene_escort_lose = {
		130345,
		155,
		true
	},
	levelScene_escort_help_tip = {
		130500,
		1412,
		true
	},
	levelScene_escort_retreat = {
		131912,
		225,
		true
	},
	levelScene_oni_retreat = {
		132137,
		204,
		true
	},
	levelScene_oni_win = {
		132341,
		115,
		true
	},
	levelScene_oni_lose = {
		132456,
		123,
		true
	},
	levelScene_bomb_retreat = {
		132579,
		97,
		true
	},
	levelScene_sphunt_help_tip = {
		132676,
		493,
		true
	},
	levelScene_bomb_help_tip = {
		133169,
		341,
		true
	},
	levelScene_chapter_timeout = {
		133510,
		142,
		true
	},
	levelScene_chapter_level_limit = {
		133652,
		162,
		true
	},
	levelScene_chapter_count_tip = {
		133814,
		115,
		true
	},
	levelScene_tracking_error_retry = {
		133929,
		139,
		true
	},
	levelScene_destroy_torpedo = {
		134068,
		123,
		true
	},
	levelScene_new_chapter_coming = {
		134191,
		109,
		true
	},
	levelScene_chapter_open_count_down = {
		134300,
		108,
		true
	},
	levelScene_chapter_not_open = {
		134408,
		103,
		true
	},
	levelScene_activate_remaster = {
		134511,
		194,
		true
	},
	levelScene_remaster_tickets_not_enough = {
		134705,
		136,
		true
	},
	levelScene_remaster_do_not_open = {
		134841,
		121,
		true
	},
	levelScene_remaster_help_tip = {
		134962,
		1192,
		true
	},
	levelScene_activate_loop_mode_failed = {
		136154,
		168,
		true
	},
	levelScene_coastalgun_help_tip = {
		136322,
		359,
		true
	},
	levelScene_select_SP_OP = {
		136681,
		98,
		true
	},
	levelScene_unselect_SP_OP = {
		136779,
		96,
		true
	},
	levelScene_select_SP_OP_reminder = {
		136875,
		415,
		true
	},
	tack_tickets_max_warning = {
		137290,
		281,
		true
	},
	world_battle_count = {
		137571,
		112,
		true
	},
	world_fleetName1 = {
		137683,
		89,
		true
	},
	world_fleetName2 = {
		137772,
		89,
		true
	},
	world_fleetName3 = {
		137861,
		89,
		true
	},
	world_fleetName4 = {
		137950,
		89,
		true
	},
	world_fleetName5 = {
		138039,
		89,
		true
	},
	world_ship_repair_1 = {
		138128,
		162,
		true
	},
	world_ship_repair_2 = {
		138290,
		165,
		true
	},
	world_ship_repair_all = {
		138455,
		168,
		true
	},
	world_ship_repair_no_need = {
		138623,
		111,
		true
	},
	world_event_teleport_alter = {
		138734,
		175,
		true
	},
	world_transport_battle_alter = {
		138909,
		152,
		true
	},
	world_transport_locked = {
		139061,
		200,
		true
	},
	world_target_count = {
		139261,
		105,
		true
	},
	world_target_filter_tip1 = {
		139366,
		91,
		true
	},
	world_target_filter_tip2 = {
		139457,
		98,
		true
	},
	world_target_get_all = {
		139555,
		112,
		true
	},
	world_target_goto = {
		139667,
		92,
		true
	},
	world_help_tip = {
		139759,
		90,
		true
	},
	world_dangerbattle_confirm = {
		139849,
		190,
		true
	},
	world_stamina_exchange = {
		140039,
		177,
		true
	},
	world_stamina_not_enough = {
		140216,
		104,
		true
	},
	world_stamina_recover = {
		140320,
		206,
		true
	},
	world_stamina_text = {
		140526,
		216,
		true
	},
	world_stamina_text2 = {
		140742,
		160,
		true
	},
	world_stamina_resetwarning = {
		140902,
		287,
		true
	},
	world_ship_healthy = {
		141189,
		169,
		true
	},
	world_map_dangerous = {
		141358,
		119,
		true
	},
	world_map_not_open = {
		141477,
		102,
		true
	},
	world_map_locked_stage = {
		141579,
		106,
		true
	},
	world_map_locked_border = {
		141685,
		106,
		true
	},
	world_item_allocate_panel_fleet_info_text = {
		141791,
		163,
		true
	},
	world_redeploy_not_change = {
		141954,
		159,
		true
	},
	world_redeploy_warn = {
		142113,
		187,
		true
	},
	world_redeploy_cost_tip = {
		142300,
		270,
		true
	},
	world_redeploy_tip = {
		142570,
		104,
		true
	},
	world_fleet_choose = {
		142674,
		173,
		true
	},
	world_fleet_formation_not_valid = {
		142847,
		133,
		true
	},
	world_fleet_in_vortex = {
		142980,
		156,
		true
	},
	world_stage_help = {
		143136,
		218,
		true
	},
	world_transport_disable = {
		143354,
		131,
		true
	},
	world_ap = {
		143485,
		74,
		true
	},
	world_resource_tip_1 = {
		143559,
		96,
		true
	},
	world_resource_tip_2 = {
		143655,
		96,
		true
	},
	world_instruction_all_1 = {
		143751,
		127,
		true
	},
	world_instruction_help_1 = {
		143878,
		1467,
		true
	},
	world_instruction_redeploy_1 = {
		145345,
		147,
		true
	},
	world_instruction_redeploy_2 = {
		145492,
		159,
		true
	},
	world_instruction_redeploy_3 = {
		145651,
		166,
		true
	},
	world_instruction_morale_1 = {
		145817,
		187,
		true
	},
	world_instruction_morale_2 = {
		146004,
		120,
		true
	},
	world_instruction_morale_3 = {
		146124,
		113,
		true
	},
	world_instruction_morale_4 = {
		146237,
		160,
		true
	},
	world_instruction_submarine_1 = {
		146397,
		137,
		true
	},
	world_instruction_submarine_2 = {
		146534,
		136,
		true
	},
	world_instruction_submarine_3 = {
		146670,
		135,
		true
	},
	world_instruction_submarine_4 = {
		146805,
		163,
		true
	},
	world_instruction_submarine_5 = {
		146968,
		132,
		true
	},
	world_instruction_submarine_6 = {
		147100,
		209,
		true
	},
	world_instruction_submarine_7 = {
		147309,
		155,
		true
	},
	world_instruction_submarine_8 = {
		147464,
		182,
		true
	},
	world_instruction_submarine_9 = {
		147646,
		190,
		true
	},
	world_instruction_submarine_10 = {
		147836,
		106,
		true
	},
	world_instruction_submarine_11 = {
		147942,
		118,
		true
	},
	world_instruction_detect_1 = {
		148060,
		128,
		true
	},
	world_instruction_detect_2 = {
		148188,
		122,
		true
	},
	world_instruction_supply_1 = {
		148310,
		102,
		true
	},
	world_instruction_supply_2 = {
		148412,
		133,
		true
	},
	world_instruction_port_goods_locked = {
		148545,
		120,
		true
	},
	world_port_inbattle = {
		148665,
		141,
		true
	},
	world_item_recycle_1 = {
		148806,
		151,
		true
	},
	world_item_recycle_2 = {
		148957,
		146,
		true
	},
	world_item_origin = {
		149103,
		132,
		true
	},
	world_shop_bag_unactivated = {
		149235,
		170,
		true
	},
	world_shop_preview_tip = {
		149405,
		119,
		true
	},
	world_shop_init_notice = {
		149524,
		147,
		true
	},
	world_map_title_tips_en = {
		149671,
		101,
		true
	},
	world_map_title_tips = {
		149772,
		99,
		true
	},
	world_mapbuff_attrtxt_1 = {
		149871,
		101,
		true
	},
	world_mapbuff_attrtxt_2 = {
		149972,
		102,
		true
	},
	world_mapbuff_attrtxt_3 = {
		150074,
		107,
		true
	},
	world_mapbuff_compare_txt = {
		150181,
		104,
		true
	},
	world_wind_move = {
		150285,
		171,
		true
	},
	world_battle_pause = {
		150456,
		91,
		true
	},
	world_battle_pause2 = {
		150547,
		99,
		true
	},
	world_task_samemap = {
		150646,
		171,
		true
	},
	world_task_maplock = {
		150817,
		215,
		true
	},
	world_task_goto0 = {
		151032,
		115,
		true
	},
	world_task_goto3 = {
		151147,
		136,
		true
	},
	world_task_view1 = {
		151283,
		99,
		true
	},
	world_task_view2 = {
		151382,
		99,
		true
	},
	world_task_view3 = {
		151481,
		88,
		true
	},
	world_task_refuse1 = {
		151569,
		125,
		true
	},
	world_daily_task_lock = {
		151694,
		148,
		true
	},
	world_daily_task_none = {
		151842,
		117,
		true
	},
	world_daily_task_none_2 = {
		151959,
		87,
		true
	},
	world_sairen_title = {
		152046,
		99,
		true
	},
	world_sairen_description1 = {
		152145,
		131,
		true
	},
	world_sairen_description2 = {
		152276,
		131,
		true
	},
	world_sairen_description3 = {
		152407,
		131,
		true
	},
	world_low_morale = {
		152538,
		241,
		true
	},
	world_recycle_notice = {
		152779,
		142,
		true
	},
	world_recycle_item_transform = {
		152921,
		188,
		true
	},
	world_exit_tip = {
		153109,
		105,
		true
	},
	world_consume_carry_tips = {
		153214,
		100,
		true
	},
	world_boss_help_meta = {
		153314,
		3227,
		true
	},
	world_close = {
		156541,
		120,
		true
	},
	world_catsearch_success = {
		156661,
		139,
		true
	},
	world_catsearch_stop = {
		156800,
		236,
		true
	},
	world_catsearch_fleetcheck = {
		157036,
		240,
		true
	},
	world_catsearch_leavemap = {
		157276,
		242,
		true
	},
	world_catsearch_help_1 = {
		157518,
		315,
		true
	},
	world_catsearch_help_2 = {
		157833,
		105,
		true
	},
	world_catsearch_help_3 = {
		157938,
		278,
		true
	},
	world_catsearch_help_4 = {
		158216,
		100,
		true
	},
	world_catsearch_help_5 = {
		158316,
		144,
		true
	},
	world_catsearch_help_6 = {
		158460,
		125,
		true
	},
	world_level_prefix = {
		158585,
		87,
		true
	},
	world_map_level = {
		158672,
		232,
		true
	},
	world_movelimit_event_text = {
		158904,
		158,
		true
	},
	world_mapbuff_tip = {
		159062,
		127,
		true
	},
	world_sametask_tip = {
		159189,
		152,
		true
	},
	world_expedition_reward_display = {
		159341,
		102,
		true
	},
	world_expedition_reward_display2 = {
		159443,
		102,
		true
	},
	world_complete_item_tip = {
		159545,
		167,
		true
	},
	task_notfound_error = {
		159712,
		149,
		true
	},
	task_submitTask_error = {
		159861,
		111,
		true
	},
	task_submitTask_error_client = {
		159972,
		118,
		true
	},
	task_submitTask_error_notFinish = {
		160090,
		136,
		true
	},
	task_taskMediator_getItem = {
		160226,
		158,
		true
	},
	task_taskMediator_getResource = {
		160384,
		166,
		true
	},
	task_taskMediator_getEquip = {
		160550,
		158,
		true
	},
	task_target_chapter_in_progress = {
		160708,
		178,
		true
	},
	task_level_notenough = {
		160886,
		119,
		true
	},
	loading_tip_ShaderMgr = {
		161005,
		105,
		true
	},
	loading_tip_FontMgr = {
		161110,
		100,
		true
	},
	loading_tip_TipsMgr = {
		161210,
		102,
		true
	},
	loading_tip_MsgboxMgr = {
		161312,
		103,
		true
	},
	loading_tip_GuideMgr = {
		161415,
		111,
		true
	},
	loading_tip_PoolMgr = {
		161526,
		98,
		true
	},
	loading_tip_FModMgr = {
		161624,
		98,
		true
	},
	loading_tip_StoryMgr = {
		161722,
		102,
		true
	},
	energy_desc_happy = {
		161824,
		136,
		true
	},
	energy_desc_normal = {
		161960,
		148,
		true
	},
	energy_desc_tired = {
		162108,
		139,
		true
	},
	energy_desc_angry = {
		162247,
		121,
		true
	},
	create_player_success = {
		162368,
		103,
		true
	},
	login_newPlayerScene_invalideName = {
		162471,
		141,
		true
	},
	login_newPlayerScene_name_tooShort = {
		162612,
		116,
		true
	},
	login_newPlayerScene_name_existOtherChar = {
		162728,
		140,
		true
	},
	login_newPlayerScene_name_tooLong = {
		162868,
		114,
		true
	},
	equipment_updateGrade_tip = {
		162982,
		143,
		true
	},
	equipment_upgrade_ok = {
		163125,
		98,
		true
	},
	equipment_cant_upgrade = {
		163223,
		113,
		true
	},
	equipment_upgrade_erro = {
		163336,
		111,
		true
	},
	collection_nostar = {
		163447,
		98,
		true
	},
	collection_getResource_error = {
		163545,
		119,
		true
	},
	collection_hadAward = {
		163664,
		109,
		true
	},
	collection_lock = {
		163773,
		85,
		true
	},
	collection_fetched = {
		163858,
		114,
		true
	},
	buyProp_noResource_error = {
		163972,
		137,
		true
	},
	refresh_shopStreet_ok = {
		164109,
		109,
		true
	},
	refresh_shopStreet_erro = {
		164218,
		114,
		true
	},
	shopStreet_upgrade_done = {
		164332,
		103,
		true
	},
	shopStreet_refresh_max_count = {
		164435,
		122,
		true
	},
	buy_countLimit = {
		164557,
		105,
		true
	},
	buy_item_quest = {
		164662,
		117,
		true
	},
	refresh_shopStreet_question = {
		164779,
		276,
		true
	},
	quota_shop_title = {
		165055,
		96,
		true
	},
	quota_shop_description = {
		165151,
		183,
		true
	},
	quota_shop_owned = {
		165334,
		85,
		true
	},
	quota_shop_good_limit = {
		165419,
		98,
		true
	},
	quota_shop_limit_error = {
		165517,
		145,
		true
	},
	item_assigned_type_limit_error = {
		165662,
		153,
		true
	},
	event_start_success = {
		165815,
		104,
		true
	},
	event_start_fail = {
		165919,
		107,
		true
	},
	event_finish_success = {
		166026,
		104,
		true
	},
	event_finish_fail = {
		166130,
		111,
		true
	},
	event_giveup_success = {
		166241,
		114,
		true
	},
	event_giveup_fail = {
		166355,
		110,
		true
	},
	event_flush_success = {
		166465,
		107,
		true
	},
	event_flush_fail = {
		166572,
		107,
		true
	},
	event_flush_not_enough = {
		166679,
		110,
		true
	},
	event_start = {
		166789,
		80,
		true
	},
	event_finish = {
		166869,
		84,
		true
	},
	event_giveup = {
		166953,
		82,
		true
	},
	event_minimus_ship_numbers = {
		167035,
		184,
		true
	},
	event_confirm_giveup = {
		167219,
		131,
		true
	},
	event_confirm_flush = {
		167350,
		172,
		true
	},
	event_fleet_busy = {
		167522,
		146,
		true
	},
	event_same_type_not_allowed = {
		167668,
		127,
		true
	},
	event_condition_ship_level = {
		167795,
		165,
		true
	},
	event_condition_ship_count = {
		167960,
		145,
		true
	},
	event_condition_ship_type = {
		168105,
		119,
		true
	},
	event_level_unreached = {
		168224,
		108,
		true
	},
	event_type_unreached = {
		168332,
		119,
		true
	},
	event_oil_consume = {
		168451,
		168,
		true
	},
	event_type_unlimit = {
		168619,
		90,
		true
	},
	dailyLevel_restCount_notEnough = {
		168709,
		133,
		true
	},
	dailyLevel_unopened = {
		168842,
		91,
		true
	},
	dailyLevel_opened = {
		168933,
		85,
		true
	},
	dailyLevel_bonus_activity = {
		169018,
		102,
		true
	},
	playerinfo_ship_is_already_flagship = {
		169120,
		128,
		true
	},
	playerinfo_mask_word = {
		169248,
		107,
		true
	},
	just_now = {
		169355,
		80,
		true
	},
	several_minutes_before = {
		169435,
		116,
		true
	},
	several_hours_before = {
		169551,
		115,
		true
	},
	several_days_before = {
		169666,
		113,
		true
	},
	long_time_offline = {
		169779,
		89,
		true
	},
	dont_send_message_frequently = {
		169868,
		114,
		true
	},
	no_activity = {
		169982,
		95,
		true
	},
	which_day = {
		170077,
		102,
		true
	},
	which_day_2 = {
		170179,
		81,
		true
	},
	invalidate_evaluation = {
		170260,
		118,
		true
	},
	chapter_no = {
		170378,
		107,
		true
	},
	reconnect_tip = {
		170485,
		123,
		true
	},
	like_ship_success = {
		170608,
		97,
		true
	},
	eva_ship_success = {
		170705,
		98,
		true
	},
	zan_ship_eva_success = {
		170803,
		100,
		true
	},
	zan_ship_eva_error_7 = {
		170903,
		121,
		true
	},
	eva_count_limit = {
		171024,
		119,
		true
	},
	attribute_durability = {
		171143,
		86,
		true
	},
	attribute_cannon = {
		171229,
		83,
		true
	},
	attribute_torpedo = {
		171312,
		85,
		true
	},
	attribute_antiaircraft = {
		171397,
		89,
		true
	},
	attribute_air = {
		171486,
		81,
		true
	},
	attribute_reload = {
		171567,
		84,
		true
	},
	attribute_cd = {
		171651,
		79,
		true
	},
	attribute_armor_type = {
		171730,
		94,
		true
	},
	attribute_armor = {
		171824,
		84,
		true
	},
	attribute_hit = {
		171908,
		80,
		true
	},
	attribute_speed = {
		171988,
		84,
		true
	},
	attribute_luck = {
		172072,
		82,
		true
	},
	attribute_dodge = {
		172154,
		83,
		true
	},
	attribute_expend = {
		172237,
		84,
		true
	},
	attribute_damage = {
		172321,
		83,
		true
	},
	attribute_healthy = {
		172404,
		88,
		true
	},
	attribute_speciality = {
		172492,
		91,
		true
	},
	attribute_range = {
		172583,
		84,
		true
	},
	attribute_angle = {
		172667,
		91,
		true
	},
	attribute_scatter = {
		172758,
		93,
		true
	},
	attribute_ammo = {
		172851,
		82,
		true
	},
	attribute_antisub = {
		172933,
		85,
		true
	},
	attribute_sonarRange = {
		173018,
		88,
		true
	},
	attribute_sonarInterval = {
		173106,
		92,
		true
	},
	attribute_oxy_max = {
		173198,
		85,
		true
	},
	attribute_dodge_limit = {
		173283,
		99,
		true
	},
	attribute_intimacy = {
		173382,
		90,
		true
	},
	attribute_max_distance_damage = {
		173472,
		111,
		true
	},
	attribute_anti_siren = {
		173583,
		101,
		true
	},
	attribute_add_new = {
		173684,
		85,
		true
	},
	skill = {
		173769,
		75,
		true
	},
	cd_normal = {
		173844,
		75,
		true
	},
	intensify = {
		173919,
		80,
		true
	},
	change = {
		173999,
		76,
		true
	},
	formation_switch_failed = {
		174075,
		111,
		true
	},
	formation_switch_success = {
		174186,
		102,
		true
	},
	formation_switch_tip = {
		174288,
		161,
		true
	},
	formation_reform_tip = {
		174449,
		145,
		true
	},
	formation_invalide = {
		174594,
		120,
		true
	},
	chapter_ap_not_enough = {
		174714,
		110,
		true
	},
	formation_forbid_when_in_chapter = {
		174824,
		159,
		true
	},
	military_forbid_when_in_chapter = {
		174983,
		158,
		true
	},
	confirm_app_exit = {
		175141,
		119,
		true
	},
	friend_info_page_tip = {
		175260,
		109,
		true
	},
	friend_search_page_tip = {
		175369,
		135,
		true
	},
	friend_request_page_tip = {
		175504,
		152,
		true
	},
	friend_id_copy_ok = {
		175656,
		106,
		true
	},
	friend_inpout_key_tip = {
		175762,
		106,
		true
	},
	remove_friend_tip = {
		175868,
		126,
		true
	},
	friend_request_msg_placeholder = {
		175994,
		109,
		true
	},
	friend_request_msg_title = {
		176103,
		105,
		true
	},
	friend_max_count = {
		176208,
		147,
		true
	},
	friend_add_ok = {
		176355,
		90,
		true
	},
	friend_max_count_1 = {
		176445,
		117,
		true
	},
	friend_no_request = {
		176562,
		99,
		true
	},
	reject_all_friend_ok = {
		176661,
		113,
		true
	},
	reject_friend_ok = {
		176774,
		104,
		true
	},
	friend_offline = {
		176878,
		96,
		true
	},
	friend_msg_forbid = {
		176974,
		151,
		true
	},
	dont_add_self = {
		177125,
		114,
		true
	},
	friend_already_add = {
		177239,
		122,
		true
	},
	friend_not_add = {
		177361,
		114,
		true
	},
	friend_send_msg_erro_tip = {
		177475,
		131,
		true
	},
	friend_send_msg_null_tip = {
		177606,
		111,
		true
	},
	friend_search_succeed = {
		177717,
		101,
		true
	},
	friend_request_msg_sent = {
		177818,
		100,
		true
	},
	friend_resume_ship_count = {
		177918,
		100,
		true
	},
	friend_resume_title_metal = {
		178018,
		103,
		true
	},
	friend_resume_collection_rate = {
		178121,
		104,
		true
	},
	friend_resume_attack_count = {
		178225,
		99,
		true
	},
	friend_resume_attack_win_rate = {
		178324,
		100,
		true
	},
	friend_resume_manoeuvre_count = {
		178424,
		104,
		true
	},
	friend_resume_manoeuvre_win_rate = {
		178528,
		104,
		true
	},
	friend_resume_fleet_gs = {
		178632,
		98,
		true
	},
	friend_event_count = {
		178730,
		95,
		true
	},
	firend_relieve_blacklist_ok = {
		178825,
		99,
		true
	},
	firend_relieve_blacklist_tip = {
		178924,
		148,
		true
	},
	word_shipNation_all = {
		179072,
		95,
		true
	},
	word_shipNation_baiYing = {
		179167,
		98,
		true
	},
	word_shipNation_huangJia = {
		179265,
		98,
		true
	},
	word_shipNation_chongYing = {
		179363,
		102,
		true
	},
	word_shipNation_tieXue = {
		179465,
		96,
		true
	},
	word_shipNation_dongHuang = {
		179561,
		102,
		true
	},
	word_shipNation_saDing = {
		179663,
		103,
		true
	},
	word_shipNation_beiLian = {
		179766,
		106,
		true
	},
	word_shipNation_other = {
		179872,
		89,
		true
	},
	word_shipNation_np = {
		179961,
		89,
		true
	},
	word_shipNation_ziyou = {
		180050,
		95,
		true
	},
	word_shipNation_weixi = {
		180145,
		100,
		true
	},
	word_shipNation_yuanwei = {
		180245,
		101,
		true
	},
	word_shipNation_bili = {
		180346,
		96,
		true
	},
	word_shipNation_um = {
		180442,
		96,
		true
	},
	word_shipNation_ai = {
		180538,
		90,
		true
	},
	word_shipNation_holo = {
		180628,
		92,
		true
	},
	word_shipNation_doa = {
		180720,
		98,
		true
	},
	word_shipNation_imas = {
		180818,
		99,
		true
	},
	word_shipNation_link = {
		180917,
		91,
		true
	},
	word_shipNation_ssss = {
		181008,
		88,
		true
	},
	word_shipNation_mot = {
		181096,
		91,
		true
	},
	word_shipNation_ryza = {
		181187,
		96,
		true
	},
	word_shipNation_meta_index = {
		181283,
		94,
		true
	},
	word_shipNation_senran = {
		181377,
		99,
		true
	},
	word_shipNation_tolove = {
		181476,
		96,
		true
	},
	word_shipNation_yujinwangguo = {
		181572,
		98,
		true
	},
	word_shipNation_brs = {
		181670,
		103,
		true
	},
	word_shipNation_yumia = {
		181773,
		98,
		true
	},
	word_shipNation_danmachi = {
		181871,
		96,
		true
	},
	word_shipNation_dal = {
		181967,
		94,
		true
	},
	word_reset = {
		182061,
		79,
		true
	},
	word_asc = {
		182140,
		81,
		true
	},
	word_desc = {
		182221,
		83,
		true
	},
	word_own = {
		182304,
		78,
		true
	},
	word_own1 = {
		182382,
		79,
		true
	},
	oil_buy_limit_tip = {
		182461,
		150,
		true
	},
	friend_resume_title = {
		182611,
		89,
		true
	},
	friend_resume_data_title = {
		182700,
		92,
		true
	},
	batch_destroy = {
		182792,
		90,
		true
	},
	equipment_select_device_destroy_tip = {
		182882,
		123,
		true
	},
	equipment_select_device_destroy_bonus_tip = {
		183005,
		120,
		true
	},
	equipment_select_device_destroy_nobonus_tip = {
		183125,
		119,
		true
	},
	ship_equip_profiiency = {
		183244,
		100,
		true
	},
	no_open_system_tip = {
		183344,
		165,
		true
	},
	open_system_tip = {
		183509,
		98,
		true
	},
	charge_start_tip = {
		183607,
		102,
		true
	},
	charge_double_gem_tip = {
		183709,
		104,
		true
	},
	charge_month_card_lefttime_tip = {
		183813,
		122,
		true
	},
	charge_title = {
		183935,
		98,
		true
	},
	charge_extra_gem_tip = {
		184033,
		103,
		true
	},
	charge_month_card_title = {
		184136,
		143,
		true
	},
	charge_items_title = {
		184279,
		96,
		true
	},
	setting_interface_save_success = {
		184375,
		116,
		true
	},
	setting_interface_revert_check = {
		184491,
		148,
		true
	},
	setting_interface_cancel_check = {
		184639,
		115,
		true
	},
	event_special_update = {
		184754,
		106,
		true
	},
	no_notice_tip = {
		184860,
		116,
		true
	},
	energy_desc_1 = {
		184976,
		165,
		true
	},
	energy_desc_2 = {
		185141,
		134,
		true
	},
	energy_desc_3 = {
		185275,
		115,
		true
	},
	energy_desc_4 = {
		185390,
		148,
		true
	},
	intimacy_desc_1 = {
		185538,
		100,
		true
	},
	intimacy_desc_2 = {
		185638,
		107,
		true
	},
	intimacy_desc_3 = {
		185745,
		120,
		true
	},
	intimacy_desc_4 = {
		185865,
		124,
		true
	},
	intimacy_desc_5 = {
		185989,
		118,
		true
	},
	intimacy_desc_6 = {
		186107,
		120,
		true
	},
	intimacy_desc_7 = {
		186227,
		120,
		true
	},
	intimacy_desc_1_buff = {
		186347,
		102,
		true
	},
	intimacy_desc_2_buff = {
		186449,
		102,
		true
	},
	intimacy_desc_3_buff = {
		186551,
		141,
		true
	},
	intimacy_desc_4_buff = {
		186692,
		141,
		true
	},
	intimacy_desc_5_buff = {
		186833,
		141,
		true
	},
	intimacy_desc_6_buff = {
		186974,
		141,
		true
	},
	intimacy_desc_7_buff = {
		187115,
		142,
		true
	},
	intimacy_desc_propose = {
		187257,
		323,
		true
	},
	intimacy_desc_1_detail = {
		187580,
		157,
		true
	},
	intimacy_desc_2_detail = {
		187737,
		164,
		true
	},
	intimacy_desc_3_detail = {
		187901,
		196,
		true
	},
	intimacy_desc_4_detail = {
		188097,
		200,
		true
	},
	intimacy_desc_5_detail = {
		188297,
		194,
		true
	},
	intimacy_desc_6_detail = {
		188491,
		324,
		true
	},
	intimacy_desc_7_detail = {
		188815,
		324,
		true
	},
	intimacy_desc_ring = {
		189139,
		96,
		true
	},
	intimacy_desc_tiara = {
		189235,
		96,
		true
	},
	intimacy_desc_day = {
		189331,
		81,
		true
	},
	word_propose_cost_tip1 = {
		189412,
		340,
		true
	},
	word_propose_cost_tip2 = {
		189752,
		318,
		true
	},
	word_propose_tiara_tip = {
		190070,
		153,
		true
	},
	charge_title_getitem = {
		190223,
		117,
		true
	},
	charge_title_getitem_soon = {
		190340,
		113,
		true
	},
	charge_title_getitem_month = {
		190453,
		120,
		true
	},
	charge_limit_all = {
		190573,
		96,
		true
	},
	charge_limit_daily = {
		190669,
		101,
		true
	},
	charge_limit_weekly = {
		190770,
		106,
		true
	},
	charge_limit_monthly = {
		190876,
		108,
		true
	},
	charge_error = {
		190984,
		92,
		true
	},
	charge_success = {
		191076,
		89,
		true
	},
	charge_level_limit = {
		191165,
		99,
		true
	},
	ship_drop_desc_default = {
		191264,
		101,
		true
	},
	charge_limit_lv = {
		191365,
		93,
		true
	},
	charge_time_out = {
		191458,
		144,
		true
	},
	help_shipinfo_equip = {
		191602,
		628,
		true
	},
	help_shipinfo_detail = {
		192230,
		679,
		true
	},
	help_shipinfo_intensify = {
		192909,
		632,
		true
	},
	help_shipinfo_upgrate = {
		193541,
		630,
		true
	},
	help_shipinfo_maxlevel = {
		194171,
		631,
		true
	},
	help_shipinfo_actnpc = {
		194802,
		1323,
		true
	},
	help_backyard = {
		196125,
		590,
		true
	},
	help_shipinfo_fashion = {
		196715,
		168,
		true
	},
	help_shipinfo_attr = {
		196883,
		3917,
		true
	},
	help_equipment = {
		200800,
		1884,
		true
	},
	help_equipment_skin = {
		202684,
		912,
		true
	},
	help_daily_task = {
		203596,
		3705,
		true
	},
	help_build = {
		207301,
		281,
		true
	},
	help_build_1 = {
		207582,
		551,
		true
	},
	help_build_2 = {
		208133,
		283,
		true
	},
	help_build_4 = {
		208416,
		573,
		true
	},
	help_build_5 = {
		208989,
		792,
		true
	},
	help_shipinfo_hunting = {
		209781,
		1244,
		true
	},
	shop_extendship_success = {
		211025,
		101,
		true
	},
	shop_extendequip_success = {
		211126,
		110,
		true
	},
	shop_spweapon_success = {
		211236,
		137,
		true
	},
	naval_academy_res_desc_cateen = {
		211373,
		240,
		true
	},
	naval_academy_res_desc_shop = {
		211613,
		211,
		true
	},
	naval_academy_res_desc_class = {
		211824,
		270,
		true
	},
	number_1 = {
		212094,
		73,
		true
	},
	number_2 = {
		212167,
		73,
		true
	},
	number_3 = {
		212240,
		73,
		true
	},
	number_4 = {
		212313,
		73,
		true
	},
	number_5 = {
		212386,
		73,
		true
	},
	number_6 = {
		212459,
		73,
		true
	},
	number_7 = {
		212532,
		73,
		true
	},
	number_8 = {
		212605,
		73,
		true
	},
	number_9 = {
		212678,
		73,
		true
	},
	number_10 = {
		212751,
		75,
		true
	},
	military_shop_no_open_tip = {
		212826,
		188,
		true
	},
	switch_to_shop_tip_1 = {
		213014,
		149,
		true
	},
	switch_to_shop_tip_2 = {
		213163,
		142,
		true
	},
	switch_to_shop_tip_3 = {
		213305,
		127,
		true
	},
	switch_to_shop_tip_noPos = {
		213432,
		123,
		true
	},
	text_noPos_clear = {
		213555,
		84,
		true
	},
	text_noPos_buy = {
		213639,
		84,
		true
	},
	text_noPos_intensify = {
		213723,
		92,
		true
	},
	switch_to_shop_tip_noDockyard = {
		213815,
		125,
		true
	},
	commission_no_open = {
		213940,
		83,
		true
	},
	commission_open_tip = {
		214023,
		107,
		true
	},
	commission_idle = {
		214130,
		86,
		true
	},
	commission_urgency = {
		214216,
		101,
		true
	},
	commission_normal = {
		214317,
		93,
		true
	},
	commission_get_award = {
		214410,
		109,
		true
	},
	activity_build_end_tip = {
		214519,
		127,
		true
	},
	event_over_time_expired = {
		214646,
		106,
		true
	},
	mail_sender_default = {
		214752,
		95,
		true
	},
	exchangecode_title = {
		214847,
		95,
		true
	},
	exchangecode_use_placeholder = {
		214942,
		116,
		true
	},
	exchangecode_use_ok = {
		215058,
		132,
		true
	},
	exchangecode_use_error = {
		215190,
		110,
		true
	},
	exchangecode_use_error_3 = {
		215300,
		105,
		true
	},
	exchangecode_use_error_6 = {
		215405,
		122,
		true
	},
	exchangecode_use_error_7 = {
		215527,
		115,
		true
	},
	exchangecode_use_error_8 = {
		215642,
		108,
		true
	},
	exchangecode_use_error_9 = {
		215750,
		108,
		true
	},
	exchangecode_use_error_16 = {
		215858,
		108,
		true
	},
	exchangecode_use_error_20 = {
		215966,
		109,
		true
	},
	text_noRes_tip = {
		216075,
		92,
		true
	},
	text_noRes_info_tip = {
		216167,
		111,
		true
	},
	text_noRes_info_tip_link = {
		216278,
		93,
		true
	},
	text_noRes_info_tip2 = {
		216371,
		137,
		true
	},
	text_shop_noRes_tip = {
		216508,
		112,
		true
	},
	text_shop_enoughRes_tip = {
		216620,
		128,
		true
	},
	text_buy_fashion_tip = {
		216748,
		108,
		true
	},
	equip_part_title = {
		216856,
		83,
		true
	},
	equip_part_main_title = {
		216939,
		95,
		true
	},
	equip_part_sub_title = {
		217034,
		99,
		true
	},
	equipment_upgrade_overlimit = {
		217133,
		133,
		true
	},
	err_name_existOtherChar = {
		217266,
		117,
		true
	},
	help_battle_rule = {
		217383,
		511,
		true
	},
	help_battle_warspite = {
		217894,
		300,
		true
	},
	help_battle_defense = {
		218194,
		588,
		true
	},
	backyard_theme_set_tip = {
		218782,
		147,
		true
	},
	backyard_theme_save_tip = {
		218929,
		172,
		true
	},
	backyard_theme_defaultname = {
		219101,
		102,
		true
	},
	backyard_rename_success = {
		219203,
		105,
		true
	},
	ship_set_skin_success = {
		219308,
		98,
		true
	},
	ship_set_skin_error = {
		219406,
		107,
		true
	},
	equip_part_tip = {
		219513,
		109,
		true
	},
	help_battle_auto = {
		219622,
		334,
		true
	},
	gold_buy_tip = {
		219956,
		247,
		true
	},
	oil_buy_tip = {
		220203,
		387,
		true
	},
	text_iknow = {
		220590,
		80,
		true
	},
	help_oil_buy_limit = {
		220670,
		299,
		true
	},
	text_nofood_yes = {
		220969,
		88,
		true
	},
	text_nofood_no = {
		221057,
		84,
		true
	},
	tip_add_task = {
		221141,
		91,
		true
	},
	collection_award_ship = {
		221232,
		134,
		true
	},
	guild_create_sucess = {
		221366,
		97,
		true
	},
	guild_create_error = {
		221463,
		105,
		true
	},
	guild_create_error_noname = {
		221568,
		117,
		true
	},
	guild_create_error_nofaction = {
		221685,
		131,
		true
	},
	guild_create_error_nopolicy = {
		221816,
		121,
		true
	},
	guild_create_error_nomanifesto = {
		221937,
		123,
		true
	},
	guild_create_error_nomoney = {
		222060,
		117,
		true
	},
	guild_tip_dissolve = {
		222177,
		347,
		true
	},
	guild_tip_quit = {
		222524,
		119,
		true
	},
	guild_create_confirm = {
		222643,
		144,
		true
	},
	guild_apply_erro = {
		222787,
		113,
		true
	},
	guild_dissolve_erro = {
		222900,
		108,
		true
	},
	guild_fire_erro = {
		223008,
		107,
		true
	},
	guild_impeach_erro = {
		223115,
		114,
		true
	},
	guild_quit_erro = {
		223229,
		101,
		true
	},
	guild_accept_erro = {
		223330,
		110,
		true
	},
	guild_reject_erro = {
		223440,
		110,
		true
	},
	guild_modify_erro = {
		223550,
		103,
		true
	},
	guild_setduty_erro = {
		223653,
		106,
		true
	},
	guild_apply_sucess = {
		223759,
		108,
		true
	},
	guild_no_exist = {
		223867,
		99,
		true
	},
	guild_dissolve_sucess = {
		223966,
		110,
		true
	},
	guild_commder_in_impeach_time = {
		224076,
		126,
		true
	},
	guild_impeach_sucess = {
		224202,
		107,
		true
	},
	guild_quit_sucess = {
		224309,
		105,
		true
	},
	guild_member_max_count = {
		224414,
		104,
		true
	},
	guild_new_member_join = {
		224518,
		119,
		true
	},
	guild_player_in_cd_time = {
		224637,
		185,
		true
	},
	guild_player_already_join = {
		224822,
		123,
		true
	},
	guild_rejecet_apply_sucess = {
		224945,
		111,
		true
	},
	guild_should_input_keyword = {
		225056,
		117,
		true
	},
	guild_search_sucess = {
		225173,
		99,
		true
	},
	guild_list_refresh_sucess = {
		225272,
		123,
		true
	},
	guild_info_update = {
		225395,
		100,
		true
	},
	guild_duty_id_is_null = {
		225495,
		108,
		true
	},
	guild_player_is_null = {
		225603,
		109,
		true
	},
	guild_duty_commder_max_count = {
		225712,
		126,
		true
	},
	guild_set_duty_sucess = {
		225838,
		107,
		true
	},
	guild_policy_power = {
		225945,
		86,
		true
	},
	guild_policy_relax = {
		226031,
		88,
		true
	},
	guild_faction_blhx = {
		226119,
		91,
		true
	},
	guild_faction_cszz = {
		226210,
		94,
		true
	},
	guild_faction_unknown = {
		226304,
		89,
		true
	},
	guild_faction_meta = {
		226393,
		86,
		true
	},
	guild_word_commder = {
		226479,
		89,
		true
	},
	guild_word_deputy_commder = {
		226568,
		101,
		true
	},
	guild_word_picked = {
		226669,
		86,
		true
	},
	guild_word_ordinary = {
		226755,
		89,
		true
	},
	guild_word_home = {
		226844,
		83,
		true
	},
	guild_word_member = {
		226927,
		88,
		true
	},
	guild_word_apply = {
		227015,
		85,
		true
	},
	guild_faction_change_tip = {
		227100,
		197,
		true
	},
	guild_msg_is_null = {
		227297,
		111,
		true
	},
	guild_log_new_guild_join = {
		227408,
		192,
		true
	},
	guild_log_duty_change = {
		227600,
		178,
		true
	},
	guild_log_quit = {
		227778,
		180,
		true
	},
	guild_log_fire = {
		227958,
		187,
		true
	},
	guild_leave_cd_time = {
		228145,
		148,
		true
	},
	guild_sort_time = {
		228293,
		83,
		true
	},
	guild_sort_level = {
		228376,
		83,
		true
	},
	guild_sort_duty = {
		228459,
		83,
		true
	},
	guild_fire_tip = {
		228542,
		120,
		true
	},
	guild_impeach_tip = {
		228662,
		126,
		true
	},
	guild_set_duty_title = {
		228788,
		99,
		true
	},
	guild_search_list_max_count = {
		228887,
		107,
		true
	},
	guild_sort_all = {
		228994,
		81,
		true
	},
	guild_sort_blhx = {
		229075,
		88,
		true
	},
	guild_sort_cszz = {
		229163,
		91,
		true
	},
	guild_sort_power = {
		229254,
		84,
		true
	},
	guild_sort_relax = {
		229338,
		86,
		true
	},
	guild_join_cd = {
		229424,
		142,
		true
	},
	guild_name_invaild = {
		229566,
		110,
		true
	},
	guild_apply_full = {
		229676,
		117,
		true
	},
	guild_member_full = {
		229793,
		101,
		true
	},
	guild_fire_duty_limit = {
		229894,
		142,
		true
	},
	guild_fire_succeed = {
		230036,
		89,
		true
	},
	guild_duty_tip_1 = {
		230125,
		115,
		true
	},
	guild_duty_tip_2 = {
		230240,
		116,
		true
	},
	battle_repair_special_tip = {
		230356,
		168,
		true
	},
	battle_repair_normal_name = {
		230524,
		109,
		true
	},
	battle_repair_special_name = {
		230633,
		111,
		true
	},
	oil_max_tip_title = {
		230744,
		110,
		true
	},
	gold_max_tip_title = {
		230854,
		113,
		true
	},
	expbook_max_tip_title = {
		230967,
		121,
		true
	},
	resource_max_tip_shop = {
		231088,
		108,
		true
	},
	resource_max_tip_event = {
		231196,
		122,
		true
	},
	resource_max_tip_battle = {
		231318,
		162,
		true
	},
	resource_max_tip_collect = {
		231480,
		124,
		true
	},
	resource_max_tip_mail = {
		231604,
		121,
		true
	},
	resource_max_tip_eventstart = {
		231725,
		118,
		true
	},
	resource_max_tip_destroy = {
		231843,
		111,
		true
	},
	resource_max_tip_retire = {
		231954,
		104,
		true
	},
	resource_max_tip_retire_1 = {
		232058,
		163,
		true
	},
	new_version_tip = {
		232221,
		165,
		true
	},
	guild_request_msg_title = {
		232386,
		115,
		true
	},
	guild_request_msg_placeholder = {
		232501,
		147,
		true
	},
	ship_upgrade_unequip_tip = {
		232648,
		223,
		true
	},
	destination_can_not_reach = {
		232871,
		121,
		true
	},
	destination_can_not_reach_safety = {
		232992,
		136,
		true
	},
	destination_not_in_range = {
		233128,
		123,
		true
	},
	level_ammo_enough = {
		233251,
		146,
		true
	},
	level_ammo_supply = {
		233397,
		120,
		true
	},
	level_ammo_empty = {
		233517,
		132,
		true
	},
	level_ammo_supply_p1 = {
		233649,
		108,
		true
	},
	level_flare_supply = {
		233757,
		209,
		true
	},
	chat_level_not_enough = {
		233966,
		136,
		true
	},
	chat_msg_inform = {
		234102,
		143,
		true
	},
	chat_msg_ban = {
		234245,
		182,
		true
	},
	month_card_set_ratio_success = {
		234427,
		115,
		true
	},
	month_card_set_ratio_not_change = {
		234542,
		125,
		true
	},
	charge_ship_bag_max = {
		234667,
		117,
		true
	},
	charge_equip_bag_max = {
		234784,
		121,
		true
	},
	login_wait_tip = {
		234905,
		141,
		true
	},
	ship_equip_exchange_tip = {
		235046,
		189,
		true
	},
	ship_rename_success = {
		235235,
		109,
		true
	},
	formation_chapter_lock = {
		235344,
		122,
		true
	},
	elite_disable_unsatisfied = {
		235466,
		127,
		true
	},
	elite_disable_ship_escort = {
		235593,
		158,
		true
	},
	elite_disable_formation_unsatisfied = {
		235751,
		149,
		true
	},
	elite_disable_no_fleet = {
		235900,
		135,
		true
	},
	elite_disable_property_unsatisfied = {
		236035,
		146,
		true
	},
	elite_disable_unusable = {
		236181,
		131,
		true
	},
	elite_warp_to_latest_map = {
		236312,
		111,
		true
	},
	elite_fleet_confirm = {
		236423,
		189,
		true
	},
	elite_condition_level = {
		236612,
		98,
		true
	},
	elite_condition_durability = {
		236710,
		98,
		true
	},
	elite_condition_cannon = {
		236808,
		94,
		true
	},
	elite_condition_torpedo = {
		236902,
		96,
		true
	},
	elite_condition_antiaircraft = {
		236998,
		100,
		true
	},
	elite_condition_air = {
		237098,
		92,
		true
	},
	elite_condition_antisub = {
		237190,
		96,
		true
	},
	elite_condition_dodge = {
		237286,
		94,
		true
	},
	elite_condition_reload = {
		237380,
		95,
		true
	},
	elite_condition_fleet_totle_level = {
		237475,
		134,
		true
	},
	common_compare_larger = {
		237609,
		86,
		true
	},
	common_compare_equal = {
		237695,
		85,
		true
	},
	common_compare_smaller = {
		237780,
		87,
		true
	},
	common_compare_not_less_than = {
		237867,
		95,
		true
	},
	common_compare_not_more_than = {
		237962,
		95,
		true
	},
	level_scene_formation_active_already = {
		238057,
		133,
		true
	},
	level_scene_not_enough = {
		238190,
		120,
		true
	},
	level_scene_full_hp = {
		238310,
		148,
		true
	},
	level_click_to_move = {
		238458,
		115,
		true
	},
	common_hardmode = {
		238573,
		83,
		true
	},
	common_elite_no_quota = {
		238656,
		135,
		true
	},
	common_food = {
		238791,
		81,
		true
	},
	common_no_limit = {
		238872,
		88,
		true
	},
	common_proficiency = {
		238960,
		92,
		true
	},
	backyard_food_remind = {
		239052,
		178,
		true
	},
	backyard_food_count = {
		239230,
		109,
		true
	},
	sham_ship_level_limit = {
		239339,
		114,
		true
	},
	sham_count_limit = {
		239453,
		115,
		true
	},
	sham_count_reset = {
		239568,
		126,
		true
	},
	sham_team_limit = {
		239694,
		175,
		true
	},
	sham_formation_invalid = {
		239869,
		154,
		true
	},
	sham_my_assist_ship_level_limit = {
		240023,
		132,
		true
	},
	sham_reset_confirm = {
		240155,
		160,
		true
	},
	sham_battle_help_tip = {
		240315,
		84,
		true
	},
	sham_reset_err_limit = {
		240399,
		130,
		true
	},
	sham_ship_equip_forbid_1 = {
		240529,
		207,
		true
	},
	sham_ship_equip_forbid_2 = {
		240736,
		183,
		true
	},
	sham_enter_error_friend_ship_expired = {
		240919,
		156,
		true
	},
	sham_can_not_change_ship = {
		241075,
		140,
		true
	},
	sham_friend_ship_tip = {
		241215,
		213,
		true
	},
	inform_sueecss = {
		241428,
		95,
		true
	},
	inform_failed = {
		241523,
		101,
		true
	},
	inform_player = {
		241624,
		94,
		true
	},
	inform_select_type = {
		241718,
		114,
		true
	},
	inform_chat_msg = {
		241832,
		101,
		true
	},
	inform_sueecss_tip = {
		241933,
		161,
		true
	},
	ship_remould_max_level = {
		242094,
		137,
		true
	},
	ship_remould_material_ship_no_enough = {
		242231,
		139,
		true
	},
	ship_remould_material_ship_on_exist = {
		242370,
		138,
		true
	},
	ship_remould_material_unlock_skill = {
		242508,
		112,
		true
	},
	ship_remould_prev_lock = {
		242620,
		93,
		true
	},
	ship_remould_need_level = {
		242713,
		94,
		true
	},
	ship_remould_need_star = {
		242807,
		94,
		true
	},
	ship_remould_finished = {
		242901,
		94,
		true
	},
	ship_remould_no_item = {
		242995,
		101,
		true
	},
	ship_remould_no_gold = {
		243096,
		112,
		true
	},
	ship_remould_no_material = {
		243208,
		120,
		true
	},
	ship_remould_selecte_exceed = {
		243328,
		124,
		true
	},
	ship_remould_sueecss = {
		243452,
		93,
		true
	},
	ship_remould_warning_101994 = {
		243545,
		582,
		true
	},
	ship_remould_warning_102174 = {
		244127,
		200,
		true
	},
	ship_remould_warning_102284 = {
		244327,
		205,
		true
	},
	ship_remould_warning_102304 = {
		244532,
		356,
		true
	},
	ship_remould_warning_105214 = {
		244888,
		222,
		true
	},
	ship_remould_warning_105224 = {
		245110,
		221,
		true
	},
	ship_remould_warning_105234 = {
		245331,
		235,
		true
	},
	ship_remould_warning_107974 = {
		245566,
		470,
		true
	},
	ship_remould_warning_107984 = {
		246036,
		238,
		true
	},
	ship_remould_warning_201514 = {
		246274,
		249,
		true
	},
	ship_remould_warning_201524 = {
		246523,
		208,
		true
	},
	ship_remould_warning_203114 = {
		246731,
		361,
		true
	},
	ship_remould_warning_203124 = {
		247092,
		352,
		true
	},
	ship_remould_warning_205124 = {
		247444,
		204,
		true
	},
	ship_remould_warning_205154 = {
		247648,
		228,
		true
	},
	ship_remould_warning_206134 = {
		247876,
		329,
		true
	},
	ship_remould_warning_301534 = {
		248205,
		183,
		true
	},
	ship_remould_warning_301874 = {
		248388,
		551,
		true
	},
	ship_remould_warning_301934 = {
		248939,
		268,
		true
	},
	ship_remould_warning_310014 = {
		249207,
		470,
		true
	},
	ship_remould_warning_310024 = {
		249677,
		470,
		true
	},
	ship_remould_warning_310034 = {
		250147,
		470,
		true
	},
	ship_remould_warning_310044 = {
		250617,
		470,
		true
	},
	ship_remould_warning_303154 = {
		251087,
		604,
		true
	},
	ship_remould_warning_402134 = {
		251691,
		264,
		true
	},
	ship_remould_warning_702124 = {
		251955,
		492,
		true
	},
	ship_remould_warning_520014 = {
		252447,
		280,
		true
	},
	ship_remould_warning_521014 = {
		252727,
		282,
		true
	},
	ship_remould_warning_520034 = {
		253009,
		280,
		true
	},
	ship_remould_warning_521034 = {
		253289,
		282,
		true
	},
	ship_remould_warning_520044 = {
		253571,
		280,
		true
	},
	ship_remould_warning_521044 = {
		253851,
		282,
		true
	},
	ship_remould_warning_502114 = {
		254133,
		186,
		true
	},
	ship_remould_warning_506114 = {
		254319,
		399,
		true
	},
	ship_remould_warning_506124 = {
		254718,
		290,
		true
	},
	ship_remould_warning_520024 = {
		255008,
		280,
		true
	},
	ship_remould_warning_521024 = {
		255288,
		282,
		true
	},
	word_soundfiles_download_title = {
		255570,
		116,
		true
	},
	word_soundfiles_download = {
		255686,
		102,
		true
	},
	word_soundfiles_checking_title = {
		255788,
		105,
		true
	},
	word_soundfiles_checking = {
		255893,
		99,
		true
	},
	word_soundfiles_checkend_title = {
		255992,
		131,
		true
	},
	word_soundfiles_checkend = {
		256123,
		101,
		true
	},
	word_soundfiles_noneedupdate = {
		256224,
		98,
		true
	},
	word_soundfiles_checkfailed = {
		256322,
		122,
		true
	},
	word_soundfiles_retry = {
		256444,
		97,
		true
	},
	word_soundfiles_update = {
		256541,
		97,
		true
	},
	word_soundfiles_update_end_title = {
		256638,
		118,
		true
	},
	word_soundfiles_update_end = {
		256756,
		106,
		true
	},
	word_soundfiles_update_failed = {
		256862,
		124,
		true
	},
	word_soundfiles_update_retry = {
		256986,
		104,
		true
	},
	word_live2dfiles_download_title = {
		257090,
		125,
		true
	},
	word_live2dfiles_download = {
		257215,
		109,
		true
	},
	word_live2dfiles_checking_title = {
		257324,
		107,
		true
	},
	word_live2dfiles_checking = {
		257431,
		98,
		true
	},
	word_live2dfiles_checkend_title = {
		257529,
		140,
		true
	},
	word_live2dfiles_checkend = {
		257669,
		102,
		true
	},
	word_live2dfiles_noneedupdate = {
		257771,
		99,
		true
	},
	word_live2dfiles_checkfailed = {
		257870,
		134,
		true
	},
	word_live2dfiles_retry = {
		258004,
		98,
		true
	},
	word_live2dfiles_update = {
		258102,
		98,
		true
	},
	word_live2dfiles_update_end_title = {
		258200,
		136,
		true
	},
	word_live2dfiles_update_end = {
		258336,
		107,
		true
	},
	word_live2dfiles_update_failed = {
		258443,
		130,
		true
	},
	word_live2dfiles_update_retry = {
		258573,
		105,
		true
	},
	word_live2dfiles_main_update_tip = {
		258678,
		149,
		true
	},
	achieve_propose_tip = {
		258827,
		101,
		true
	},
	mingshi_get_tip = {
		258928,
		105,
		true
	},
	mingshi_task_tip_1 = {
		259033,
		217,
		true
	},
	mingshi_task_tip_2 = {
		259250,
		221,
		true
	},
	mingshi_task_tip_3 = {
		259471,
		220,
		true
	},
	mingshi_task_tip_4 = {
		259691,
		221,
		true
	},
	mingshi_task_tip_5 = {
		259912,
		216,
		true
	},
	mingshi_task_tip_6 = {
		260128,
		215,
		true
	},
	mingshi_task_tip_7 = {
		260343,
		228,
		true
	},
	mingshi_task_tip_8 = {
		260571,
		223,
		true
	},
	mingshi_task_tip_9 = {
		260794,
		221,
		true
	},
	mingshi_task_tip_10 = {
		261015,
		229,
		true
	},
	mingshi_task_tip_11 = {
		261244,
		215,
		true
	},
	word_propose_changename_title = {
		261459,
		163,
		true
	},
	word_propose_changename_tip1 = {
		261622,
		136,
		true
	},
	word_propose_changename_tip2 = {
		261758,
		113,
		true
	},
	word_propose_ring_tip = {
		261871,
		109,
		true
	},
	word_rename_time_tip = {
		261980,
		147,
		true
	},
	word_rename_switch_tip = {
		262127,
		151,
		true
	},
	word_ssr = {
		262278,
		74,
		true
	},
	word_sr = {
		262352,
		76,
		true
	},
	word_r = {
		262428,
		71,
		true
	},
	ship_renameShip_error = {
		262499,
		107,
		true
	},
	ship_renameShip_error_4 = {
		262606,
		125,
		true
	},
	ship_renameShip_error_2011 = {
		262731,
		107,
		true
	},
	ship_proposeShip_error = {
		262838,
		104,
		true
	},
	ship_proposeShip_error_1 = {
		262942,
		106,
		true
	},
	word_rename_time_warning = {
		263048,
		236,
		true
	},
	word_propose_cost_tip = {
		263284,
		453,
		true
	},
	word_propose_switch_tip = {
		263737,
		102,
		true
	},
	evaluate_too_loog = {
		263839,
		101,
		true
	},
	evaluate_ban_word = {
		263940,
		112,
		true
	},
	activity_level_easy_tip = {
		264052,
		181,
		true
	},
	activity_level_difficulty_tip = {
		264233,
		210,
		true
	},
	activity_level_limit_tip = {
		264443,
		174,
		true
	},
	activity_level_inwarime_tip = {
		264617,
		221,
		true
	},
	activity_level_pass_easy_tip = {
		264838,
		187,
		true
	},
	activity_level_is_closed = {
		265025,
		114,
		true
	},
	activity_switch_tip = {
		265139,
		255,
		true
	},
	reduce_sp3_pass_count = {
		265394,
		103,
		true
	},
	qiuqiu_count = {
		265497,
		85,
		true
	},
	qiuqiu_total_count = {
		265582,
		91,
		true
	},
	npcfriendly_count = {
		265673,
		98,
		true
	},
	npcfriendly_total_count = {
		265771,
		97,
		true
	},
	longxiang_count = {
		265868,
		98,
		true
	},
	longxiang_total_count = {
		265966,
		103,
		true
	},
	pt_count = {
		266069,
		82,
		true
	},
	pt_total_count = {
		266151,
		94,
		true
	},
	remould_ship_ok = {
		266245,
		88,
		true
	},
	remould_ship_count_more = {
		266333,
		120,
		true
	},
	word_should_input = {
		266453,
		108,
		true
	},
	simulation_advantage_counting = {
		266561,
		126,
		true
	},
	simulation_disadvantage_counting = {
		266687,
		130,
		true
	},
	simulation_enhancing = {
		266817,
		144,
		true
	},
	simulation_enhanced = {
		266961,
		121,
		true
	},
	word_skill_desc_get = {
		267082,
		94,
		true
	},
	word_skill_desc_learn = {
		267176,
		89,
		true
	},
	chapter_tip_aovid_succeed = {
		267265,
		96,
		true
	},
	chapter_tip_aovid_failed = {
		267361,
		104,
		true
	},
	chapter_tip_change = {
		267465,
		103,
		true
	},
	chapter_tip_use = {
		267568,
		98,
		true
	},
	chapter_tip_with_npc = {
		267666,
		285,
		true
	},
	chapter_tip_bp_ammo = {
		267951,
		137,
		true
	},
	build_ship_tip = {
		268088,
		190,
		true
	},
	auto_battle_limit_tip = {
		268278,
		123,
		true
	},
	build_ship_quickly_buy_stone = {
		268401,
		190,
		true
	},
	build_ship_quickly_buy_tool = {
		268591,
		205,
		true
	},
	ship_profile_voice_locked = {
		268796,
		121,
		true
	},
	ship_profile_skin_locked = {
		268917,
		110,
		true
	},
	ship_profile_words = {
		269027,
		88,
		true
	},
	ship_profile_action_words = {
		269115,
		102,
		true
	},
	ship_profile_label_common = {
		269217,
		96,
		true
	},
	ship_profile_label_diff = {
		269313,
		98,
		true
	},
	level_fleet_lease_one_ship = {
		269411,
		133,
		true
	},
	level_fleet_not_enough = {
		269544,
		131,
		true
	},
	level_fleet_outof_limit = {
		269675,
		125,
		true
	},
	vote_success = {
		269800,
		82,
		true
	},
	vote_not_enough = {
		269882,
		111,
		true
	},
	vote_love_not_enough = {
		269993,
		125,
		true
	},
	vote_love_limit = {
		270118,
		143,
		true
	},
	vote_love_confirm = {
		270261,
		125,
		true
	},
	vote_primary_rule = {
		270386,
		81,
		true
	},
	vote_final_title1 = {
		270467,
		88,
		true
	},
	vote_final_rule1 = {
		270555,
		231,
		true
	},
	vote_final_title2 = {
		270786,
		94,
		true
	},
	vote_final_rule2 = {
		270880,
		240,
		true
	},
	vote_vote_time = {
		271120,
		100,
		true
	},
	vote_vote_count = {
		271220,
		87,
		true
	},
	vote_vote_group = {
		271307,
		87,
		true
	},
	vote_rank_refresh_time = {
		271394,
		120,
		true
	},
	vote_rank_in_current_server = {
		271514,
		128,
		true
	},
	words_auto_battle_label = {
		271642,
		105,
		true
	},
	words_show_ship_name_label = {
		271747,
		106,
		true
	},
	words_rare_ship_vibrate = {
		271853,
		100,
		true
	},
	words_display_ship_get_effect = {
		271953,
		108,
		true
	},
	words_show_touch_effect = {
		272061,
		102,
		true
	},
	words_bg_fit_mode = {
		272163,
		121,
		true
	},
	words_battle_hide_bg = {
		272284,
		116,
		true
	},
	words_battle_expose_line = {
		272400,
		123,
		true
	},
	words_autoFight_battery_savemode = {
		272523,
		121,
		true
	},
	words_autoFight_battery_savemode_des = {
		272644,
		182,
		true
	},
	words_autoFIght_down_frame = {
		272826,
		115,
		true
	},
	words_autoFIght_down_frame_des = {
		272941,
		163,
		true
	},
	words_autoFight_tips = {
		273104,
		131,
		true
	},
	words_autoFight_right = {
		273235,
		175,
		true
	},
	activity_puzzle_get1 = {
		273410,
		132,
		true
	},
	activity_puzzle_get2 = {
		273542,
		143,
		true
	},
	activity_puzzle_get3 = {
		273685,
		143,
		true
	},
	activity_puzzle_get4 = {
		273828,
		143,
		true
	},
	activity_puzzle_get5 = {
		273971,
		143,
		true
	},
	activity_puzzle_get6 = {
		274114,
		143,
		true
	},
	activity_puzzle_get7 = {
		274257,
		143,
		true
	},
	activity_puzzle_get8 = {
		274400,
		143,
		true
	},
	activity_puzzle_get9 = {
		274543,
		143,
		true
	},
	activity_puzzle_get10 = {
		274686,
		133,
		true
	},
	activity_puzzle_get11 = {
		274819,
		133,
		true
	},
	activity_puzzle_get12 = {
		274952,
		133,
		true
	},
	activity_puzzle_get13 = {
		275085,
		133,
		true
	},
	activity_puzzle_get14 = {
		275218,
		133,
		true
	},
	activity_puzzle_get15 = {
		275351,
		133,
		true
	},
	word_stopremain_build = {
		275484,
		102,
		true
	},
	word_stopremain_default = {
		275586,
		104,
		true
	},
	transcode_desc = {
		275690,
		359,
		true
	},
	transcode_empty_tip = {
		276049,
		117,
		true
	},
	set_birth_title = {
		276166,
		91,
		true
	},
	set_birth_confirm_tip = {
		276257,
		110,
		true
	},
	set_birth_empty_tip = {
		276367,
		105,
		true
	},
	set_birth_success = {
		276472,
		107,
		true
	},
	clear_transcode_cache_confirm = {
		276579,
		143,
		true
	},
	clear_transcode_cache_success = {
		276722,
		115,
		true
	},
	exchange_item_success = {
		276837,
		94,
		true
	},
	give_up_cloth_change = {
		276931,
		120,
		true
	},
	err_cloth_change_noship = {
		277051,
		103,
		true
	},
	need_break_tip = {
		277154,
		99,
		true
	},
	max_level_notice = {
		277253,
		152,
		true
	},
	new_skin_no_choose = {
		277405,
		156,
		true
	},
	sure_resume_volume = {
		277561,
		114,
		true
	},
	course_class_not_ready = {
		277675,
		165,
		true
	},
	course_student_max_level = {
		277840,
		152,
		true
	},
	course_stop_confirm = {
		277992,
		103,
		true
	},
	course_class_help = {
		278095,
		1480,
		true
	},
	course_class_name = {
		279575,
		100,
		true
	},
	course_proficiency_not_enough = {
		279675,
		128,
		true
	},
	course_state_rest = {
		279803,
		91,
		true
	},
	course_state_lession = {
		279894,
		97,
		true
	},
	course_energy_not_enough = {
		279991,
		156,
		true
	},
	course_proficiency_tip = {
		280147,
		382,
		true
	},
	course_sunday_tip = {
		280529,
		145,
		true
	},
	course_exit_confirm = {
		280674,
		158,
		true
	},
	course_learning = {
		280832,
		111,
		true
	},
	time_remaining_tip = {
		280943,
		93,
		true
	},
	propose_intimacy_tip = {
		281036,
		119,
		true
	},
	no_found_record_equipment = {
		281155,
		196,
		true
	},
	sec_floor_limit_tip = {
		281351,
		130,
		true
	},
	guild_shop_flash_success = {
		281481,
		98,
		true
	},
	destroy_high_rarity_tip = {
		281579,
		125,
		true
	},
	destroy_high_level_tip = {
		281704,
		133,
		true
	},
	destroy_importantequipment_tip = {
		281837,
		126,
		true
	},
	destroy_eliteequipment_tip = {
		281963,
		117,
		true
	},
	destroy_high_intensify_tip = {
		282080,
		124,
		true
	},
	destroy_inHardFormation_tip = {
		282204,
		126,
		true
	},
	destroy_equip_rarity_tip = {
		282330,
		161,
		true
	},
	ship_quick_change_noequip = {
		282491,
		116,
		true
	},
	ship_quick_change_nofreeequip = {
		282607,
		134,
		true
	},
	word_nowenergy = {
		282741,
		84,
		true
	},
	word_energy_recov_speed = {
		282825,
		101,
		true
	},
	destroy_eliteship_tip = {
		282926,
		111,
		true
	},
	err_resloveequip_nochoice = {
		283037,
		120,
		true
	},
	take_nothing = {
		283157,
		103,
		true
	},
	take_all_mail = {
		283260,
		171,
		true
	},
	buy_furniture_overtime = {
		283431,
		135,
		true
	},
	twitter_login_tips = {
		283566,
		166,
		true
	},
	data_erro = {
		283732,
		121,
		true
	},
	login_failed = {
		283853,
		94,
		true
	},
	["not yet completed"] = {
		283947,
		93,
		true
	},
	escort_less_count_to_combat = {
		284040,
		127,
		true
	},
	ten_even_draw = {
		284167,
		94,
		true
	},
	ten_even_draw_confirm = {
		284261,
		111,
		true
	},
	level_risk_level_desc = {
		284372,
		90,
		true
	},
	level_risk_level_mitigation_rate = {
		284462,
		239,
		true
	},
	level_diffcult_chapter_state_safety = {
		284701,
		229,
		true
	},
	level_chapter_state_high_risk = {
		284930,
		137,
		true
	},
	level_chapter_state_risk = {
		285067,
		128,
		true
	},
	level_chapter_state_low_risk = {
		285195,
		133,
		true
	},
	level_chapter_state_safety = {
		285328,
		132,
		true
	},
	open_skill_class_success = {
		285460,
		121,
		true
	},
	backyard_sort_tag_default = {
		285581,
		91,
		true
	},
	backyard_sort_tag_price = {
		285672,
		93,
		true
	},
	backyard_sort_tag_comfortable = {
		285765,
		100,
		true
	},
	backyard_sort_tag_size = {
		285865,
		90,
		true
	},
	backyard_filter_tag_other = {
		285955,
		93,
		true
	},
	word_status_inFight = {
		286048,
		90,
		true
	},
	word_status_inPVP = {
		286138,
		91,
		true
	},
	word_status_inEvent = {
		286229,
		92,
		true
	},
	word_status_inEventFinished = {
		286321,
		100,
		true
	},
	word_status_inTactics = {
		286421,
		93,
		true
	},
	word_status_inClass = {
		286514,
		91,
		true
	},
	word_status_rest = {
		286605,
		87,
		true
	},
	word_status_train = {
		286692,
		89,
		true
	},
	word_status_world = {
		286781,
		97,
		true
	},
	word_status_inHardFormation = {
		286878,
		103,
		true
	},
	word_status_series_enemy = {
		286981,
		103,
		true
	},
	challenge_rule = {
		287084,
		101,
		true
	},
	challenge_exit_warning = {
		287185,
		241,
		true
	},
	challenge_fleet_type_fail = {
		287426,
		141,
		true
	},
	challenge_current_level = {
		287567,
		110,
		true
	},
	challenge_current_score = {
		287677,
		104,
		true
	},
	challenge_total_score = {
		287781,
		99,
		true
	},
	challenge_current_progress = {
		287880,
		113,
		true
	},
	challenge_count_unlimit = {
		287993,
		99,
		true
	},
	challenge_no_fleet = {
		288092,
		118,
		true
	},
	equipment_skin_unload = {
		288210,
		147,
		true
	},
	equipment_skin_no_old_ship = {
		288357,
		119,
		true
	},
	equipment_skin_no_old_skinorequipment = {
		288476,
		162,
		true
	},
	equipment_skin_no_new_ship = {
		288638,
		113,
		true
	},
	equipment_skin_no_new_equipment = {
		288751,
		126,
		true
	},
	equipment_skin_count_noenough = {
		288877,
		115,
		true
	},
	equipment_skin_replace_done = {
		288992,
		120,
		true
	},
	equipment_skin_unload_failed = {
		289112,
		128,
		true
	},
	equipment_skin_unmatch_equipment = {
		289240,
		180,
		true
	},
	equipment_skin_no_equipment_tip = {
		289420,
		156,
		true
	},
	activity_pool_awards_empty = {
		289576,
		119,
		true
	},
	activity_switch_award_pool_failed = {
		289695,
		183,
		true
	},
	shop_street_activity_tip = {
		289878,
		300,
		true
	},
	shop_street_Equipment_skin_box_help = {
		290178,
		166,
		true
	},
	twitter_link_title = {
		290344,
		100,
		true
	},
	commander_material_noenough = {
		290444,
		122,
		true
	},
	battle_result_boss_destruct = {
		290566,
		132,
		true
	},
	battle_preCombatLayer_boss_destruct = {
		290698,
		140,
		true
	},
	destory_important_equipment_tip = {
		290838,
		198,
		true
	},
	destory_important_equipment_input_erro = {
		291036,
		121,
		true
	},
	activity_hit_monster_nocount = {
		291157,
		112,
		true
	},
	activity_hit_monster_death = {
		291269,
		124,
		true
	},
	activity_hit_monster_help = {
		291393,
		119,
		true
	},
	activity_hit_monster_erro = {
		291512,
		103,
		true
	},
	activity_xiaotiane_progress = {
		291615,
		107,
		true
	},
	activity_hit_monster_reset_tip = {
		291722,
		228,
		true
	},
	answer_help_tip = {
		291950,
		182,
		true
	},
	answer_answer_role = {
		292132,
		172,
		true
	},
	answer_exit_tip = {
		292304,
		112,
		true
	},
	equip_skin_detail_tip = {
		292416,
		121,
		true
	},
	emoji_type_0 = {
		292537,
		82,
		true
	},
	emoji_type_1 = {
		292619,
		83,
		true
	},
	emoji_type_2 = {
		292702,
		84,
		true
	},
	emoji_type_3 = {
		292786,
		82,
		true
	},
	emoji_type_4 = {
		292868,
		84,
		true
	},
	card_pairs_help_tip = {
		292952,
		943,
		true
	},
	card_pairs_tips = {
		293895,
		162,
		true
	},
	["card_battle_card details_deck"] = {
		294057,
		105,
		true
	},
	["card_battle_card details_hand"] = {
		294162,
		109,
		true
	},
	["card_battle_card details"] = {
		294271,
		100,
		true
	},
	["card_battle_card details_switchto_deck"] = {
		294371,
		111,
		true
	},
	["card_battle_card details_switchto_hand"] = {
		294482,
		115,
		true
	},
	card_battle_card_empty_en = {
		294597,
		106,
		true
	},
	card_battle_card_empty_ch = {
		294703,
		130,
		true
	},
	card_puzzel_goal_ch = {
		294833,
		93,
		true
	},
	card_puzzel_goal_en = {
		294926,
		89,
		true
	},
	card_puzzle_deck = {
		295015,
		84,
		true
	},
	upgrade_to_next_maxlevel_failed = {
		295099,
		181,
		true
	},
	upgrade_to_next_maxlevel_tip = {
		295280,
		240,
		true
	},
	upgrade_to_next_maxlevel_succeed = {
		295520,
		198,
		true
	},
	extra_chapter_socre_tip = {
		295718,
		173,
		true
	},
	extra_chapter_record_updated = {
		295891,
		102,
		true
	},
	extra_chapter_record_not_updated = {
		295993,
		112,
		true
	},
	extra_chapter_locked_tip = {
		296105,
		120,
		true
	},
	extra_chapter_locked_tip_1 = {
		296225,
		167,
		true
	},
	player_name_change_time_lv_tip = {
		296392,
		172,
		true
	},
	player_name_change_time_limit_tip = {
		296564,
		174,
		true
	},
	player_name_change_windows_tip = {
		296738,
		234,
		true
	},
	player_name_change_warning = {
		296972,
		247,
		true
	},
	player_name_change_success = {
		297219,
		116,
		true
	},
	player_name_change_failed = {
		297335,
		111,
		true
	},
	same_player_name_tip = {
		297446,
		109,
		true
	},
	task_is_not_existence = {
		297555,
		112,
		true
	},
	cannot_build_multiple_printblue = {
		297667,
		366,
		true
	},
	printblue_build_success = {
		298033,
		107,
		true
	},
	printblue_build_erro = {
		298140,
		103,
		true
	},
	blueprint_mod_success = {
		298243,
		107,
		true
	},
	blueprint_mod_erro = {
		298350,
		100,
		true
	},
	technology_refresh_sucess = {
		298450,
		133,
		true
	},
	technology_refresh_erro = {
		298583,
		126,
		true
	},
	change_technology_refresh_sucess = {
		298709,
		136,
		true
	},
	change_technology_refresh_erro = {
		298845,
		130,
		true
	},
	technology_start_up = {
		298975,
		100,
		true
	},
	technology_start_erro = {
		299075,
		101,
		true
	},
	technology_stop_success = {
		299176,
		119,
		true
	},
	technology_stop_erro = {
		299295,
		111,
		true
	},
	technology_finish_success = {
		299406,
		121,
		true
	},
	technology_finish_erro = {
		299527,
		114,
		true
	},
	blueprint_stop_success = {
		299641,
		121,
		true
	},
	blueprint_stop_erro = {
		299762,
		113,
		true
	},
	blueprint_destory_tip = {
		299875,
		119,
		true
	},
	blueprint_task_update_tip = {
		299994,
		172,
		true
	},
	blueprint_mod_addition_lock = {
		300166,
		125,
		true
	},
	blueprint_mod_word_unlock = {
		300291,
		111,
		true
	},
	blueprint_mod_skin_unlock = {
		300402,
		106,
		true
	},
	blueprint_build_consume = {
		300508,
		120,
		true
	},
	blueprint_stop_tip = {
		300628,
		180,
		true
	},
	technology_canot_refresh = {
		300808,
		153,
		true
	},
	technology_refresh_tip = {
		300961,
		138,
		true
	},
	technology_is_actived = {
		301099,
		125,
		true
	},
	technology_stop_tip = {
		301224,
		178,
		true
	},
	technology_help_text = {
		301402,
		2742,
		true
	},
	blueprint_build_time_tip = {
		304144,
		209,
		true
	},
	blueprint_cannot_build_tip = {
		304353,
		147,
		true
	},
	technology_task_none_tip = {
		304500,
		97,
		true
	},
	technology_task_build_tip = {
		304597,
		161,
		true
	},
	blueprint_commit_tip = {
		304758,
		165,
		true
	},
	buleprint_need_level_tip = {
		304923,
		141,
		true
	},
	blueprint_max_level_tip = {
		305064,
		132,
		true
	},
	ship_profile_voice_locked_intimacy = {
		305196,
		133,
		true
	},
	ship_profile_voice_locked_propose = {
		305329,
		115,
		true
	},
	ship_profile_voice_locked_propose_imas = {
		305444,
		120,
		true
	},
	ship_profile_voice_locked_design = {
		305564,
		140,
		true
	},
	ship_profile_voice_locked_meta = {
		305704,
		106,
		true
	},
	help_technolog0 = {
		305810,
		350,
		true
	},
	help_technolog = {
		306160,
		513,
		true
	},
	hide_chat_warning = {
		306673,
		115,
		true
	},
	show_chat_warning = {
		306788,
		117,
		true
	},
	help_shipblueprintui = {
		306905,
		4396,
		true
	},
	help_shipblueprintui_luck = {
		311301,
		734,
		true
	},
	anniversary_task_title_1 = {
		312035,
		175,
		true
	},
	anniversary_task_title_2 = {
		312210,
		206,
		true
	},
	anniversary_task_title_3 = {
		312416,
		177,
		true
	},
	anniversary_task_title_4 = {
		312593,
		210,
		true
	},
	anniversary_task_title_5 = {
		312803,
		184,
		true
	},
	anniversary_task_title_6 = {
		312987,
		204,
		true
	},
	anniversary_task_title_7 = {
		313191,
		202,
		true
	},
	anniversary_task_title_8 = {
		313393,
		169,
		true
	},
	anniversary_task_title_9 = {
		313562,
		193,
		true
	},
	anniversary_task_title_10 = {
		313755,
		176,
		true
	},
	anniversary_task_title_11 = {
		313931,
		160,
		true
	},
	anniversary_task_title_12 = {
		314091,
		178,
		true
	},
	anniversary_task_title_13 = {
		314269,
		195,
		true
	},
	anniversary_task_title_14 = {
		314464,
		179,
		true
	},
	charge_scene_buy_confirm = {
		314643,
		163,
		true
	},
	charge_scene_buy_confirm_gold = {
		314806,
		168,
		true
	},
	charge_scene_batch_buy_tip = {
		314974,
		189,
		true
	},
	help_level_ui = {
		315163,
		911,
		true
	},
	guild_modify_info_tip = {
		316074,
		193,
		true
	},
	ai_change_1 = {
		316267,
		118,
		true
	},
	ai_change_2 = {
		316385,
		117,
		true
	},
	activity_shop_lable = {
		316502,
		126,
		true
	},
	word_bilibili = {
		316628,
		90,
		true
	},
	levelScene_tracking_error_pre = {
		316718,
		143,
		true
	},
	ship_limit_notice = {
		316861,
		157,
		true
	},
	idle = {
		317018,
		73,
		true
	},
	main_1 = {
		317091,
		81,
		true
	},
	main_2 = {
		317172,
		81,
		true
	},
	main_3 = {
		317253,
		81,
		true
	},
	complete = {
		317334,
		84,
		true
	},
	login = {
		317418,
		74,
		true
	},
	home = {
		317492,
		74,
		true
	},
	mail = {
		317566,
		77,
		true
	},
	mission = {
		317643,
		83,
		true
	},
	mission_complete = {
		317726,
		96,
		true
	},
	wedding = {
		317822,
		77,
		true
	},
	touch_head = {
		317899,
		84,
		true
	},
	touch_body = {
		317983,
		82,
		true
	},
	touch_special = {
		318065,
		84,
		true
	},
	gold = {
		318149,
		73,
		true
	},
	oil = {
		318222,
		70,
		true
	},
	diamond = {
		318292,
		75,
		true
	},
	word_photo_mode = {
		318367,
		84,
		true
	},
	word_video_mode = {
		318451,
		82,
		true
	},
	word_save_ok = {
		318533,
		114,
		true
	},
	word_save_video = {
		318647,
		120,
		true
	},
	reflux_help_tip = {
		318767,
		974,
		true
	},
	reflux_pt_not_enough = {
		319741,
		121,
		true
	},
	reflux_word_1 = {
		319862,
		87,
		true
	},
	reflux_word_2 = {
		319949,
		85,
		true
	},
	ship_hunting_level_tips = {
		320034,
		190,
		true
	},
	acquisitionmode_is_not_open = {
		320224,
		123,
		true
	},
	collect_chapter_is_activation = {
		320347,
		140,
		true
	},
	levelScene_chapter_is_activation = {
		320487,
		189,
		true
	},
	resource_verify_warn = {
		320676,
		245,
		true
	},
	resource_verify_fail = {
		320921,
		191,
		true
	},
	resource_verify_success = {
		321112,
		122,
		true
	},
	resource_clear_all = {
		321234,
		178,
		true
	},
	resource_clear_manga = {
		321412,
		228,
		true
	},
	resource_clear_gallery = {
		321640,
		236,
		true
	},
	resource_clear_3ddorm = {
		321876,
		256,
		true
	},
	resource_clear_tbchild = {
		322132,
		257,
		true
	},
	resource_clear_3disland = {
		322389,
		254,
		true
	},
	resource_clear_generaltext = {
		322643,
		103,
		true
	},
	acl_oil_count = {
		322746,
		87,
		true
	},
	acl_oil_total_count = {
		322833,
		99,
		true
	},
	word_take_video_tip = {
		322932,
		141,
		true
	},
	word_snapshot_share_title = {
		323073,
		118,
		true
	},
	word_snapshot_share_agreement = {
		323191,
		540,
		true
	},
	skin_remain_time = {
		323731,
		91,
		true
	},
	word_museum_1 = {
		323822,
		120,
		true
	},
	word_museum_help = {
		323942,
		734,
		true
	},
	goldship_help_tip = {
		324676,
		787,
		true
	},
	metalgearsub_help_tip = {
		325463,
		1847,
		true
	},
	acl_gold_count = {
		327310,
		91,
		true
	},
	acl_gold_total_count = {
		327401,
		102,
		true
	},
	discount_time = {
		327503,
		146,
		true
	},
	commander_talent_not_exist = {
		327649,
		132,
		true
	},
	commander_replace_talent_not_exist = {
		327781,
		154,
		true
	},
	commander_talent_learned = {
		327935,
		121,
		true
	},
	commander_talent_learn_erro = {
		328056,
		133,
		true
	},
	commander_not_exist = {
		328189,
		114,
		true
	},
	commander_fleet_not_exist = {
		328303,
		115,
		true
	},
	commander_fleet_pos_not_exist = {
		328418,
		128,
		true
	},
	commander_equip_to_fleet_erro = {
		328546,
		140,
		true
	},
	commander_acquire_erro = {
		328686,
		138,
		true
	},
	commander_lock_erro = {
		328824,
		121,
		true
	},
	commander_reset_talent_time_no_rearch = {
		328945,
		157,
		true
	},
	commander_reset_talent_is_not_need = {
		329102,
		125,
		true
	},
	commander_reset_talent_success = {
		329227,
		118,
		true
	},
	commander_reset_talent_erro = {
		329345,
		136,
		true
	},
	commander_can_not_be_upgrade = {
		329481,
		133,
		true
	},
	commander_anyone_is_in_fleet = {
		329614,
		139,
		true
	},
	commander_is_in_fleet = {
		329753,
		133,
		true
	},
	commander_play_erro = {
		329886,
		104,
		true
	},
	ship_equip_same_group_equipment = {
		329990,
		136,
		true
	},
	summary_page_un_rearch = {
		330126,
		96,
		true
	},
	player_summary_from = {
		330222,
		97,
		true
	},
	player_summary_data = {
		330319,
		95,
		true
	},
	commander_exp_overflow_tip = {
		330414,
		192,
		true
	},
	commander_reset_talent_tip = {
		330606,
		141,
		true
	},
	commander_reset_talent = {
		330747,
		96,
		true
	},
	commander_select_min_cnt = {
		330843,
		127,
		true
	},
	commander_select_max = {
		330970,
		123,
		true
	},
	commander_lock_done = {
		331093,
		101,
		true
	},
	commander_unlock_done = {
		331194,
		105,
		true
	},
	commander_get_1 = {
		331299,
		127,
		true
	},
	commander_get = {
		331426,
		139,
		true
	},
	commander_build_done = {
		331565,
		114,
		true
	},
	commander_build_erro = {
		331679,
		117,
		true
	},
	commander_get_skills_done = {
		331796,
		132,
		true
	},
	collection_way_is_unopen = {
		331928,
		115,
		true
	},
	commander_can_not_select_same_group = {
		332043,
		162,
		true
	},
	commander_capcity_is_max = {
		332205,
		115,
		true
	},
	commander_reserve_count_is_max = {
		332320,
		128,
		true
	},
	commander_build_pool_tip = {
		332448,
		143,
		true
	},
	commander_select_matiral_erro = {
		332591,
		212,
		true
	},
	commander_material_is_rarity = {
		332803,
		156,
		true
	},
	commander_material_is_maxLevel = {
		332959,
		200,
		true
	},
	charge_commander_bag_max = {
		333159,
		161,
		true
	},
	shop_extendcommander_success = {
		333320,
		148,
		true
	},
	commander_skill_point_noengough = {
		333468,
		144,
		true
	},
	buildship_new_tip = {
		333612,
		160,
		true
	},
	buildship_heavy_tip = {
		333772,
		138,
		true
	},
	buildship_light_tip = {
		333910,
		127,
		true
	},
	buildship_special_tip = {
		334037,
		136,
		true
	},
	Normalbuild_URexchange_help = {
		334173,
		615,
		true
	},
	Normalbuild_URexchange_text1 = {
		334788,
		103,
		true
	},
	Normalbuild_URexchange_text2 = {
		334891,
		97,
		true
	},
	Normalbuild_URexchange_text3 = {
		334988,
		103,
		true
	},
	Normalbuild_URexchange_text4 = {
		335091,
		100,
		true
	},
	Normalbuild_URexchange_warning1 = {
		335191,
		128,
		true
	},
	Normalbuild_URexchange_warning3 = {
		335319,
		207,
		true
	},
	Normalbuild_URexchange_confirm = {
		335526,
		121,
		true
	},
	open_skill_pos = {
		335647,
		236,
		true
	},
	open_skill_pos_discount = {
		335883,
		239,
		true
	},
	event_recommend_fail = {
		336122,
		124,
		true
	},
	newplayer_help_tip = {
		336246,
		988,
		true
	},
	newplayer_notice_1 = {
		337234,
		125,
		true
	},
	newplayer_notice_2 = {
		337359,
		125,
		true
	},
	newplayer_notice_3 = {
		337484,
		117,
		true
	},
	newplayer_notice_4 = {
		337601,
		121,
		true
	},
	newplayer_notice_5 = {
		337722,
		119,
		true
	},
	newplayer_notice_6 = {
		337841,
		171,
		true
	},
	newplayer_notice_7 = {
		338012,
		124,
		true
	},
	newplayer_notice_8 = {
		338136,
		149,
		true
	},
	tec_catchup_1 = {
		338285,
		85,
		true
	},
	tec_catchup_2 = {
		338370,
		85,
		true
	},
	tec_catchup_3 = {
		338455,
		85,
		true
	},
	tec_catchup_4 = {
		338540,
		85,
		true
	},
	tec_catchup_5 = {
		338625,
		85,
		true
	},
	tec_catchup_6 = {
		338710,
		85,
		true
	},
	tec_catchup_7 = {
		338795,
		85,
		true
	},
	tec_notice = {
		338880,
		124,
		true
	},
	tec_notice_not_open_tip = {
		339004,
		141,
		true
	},
	apply_permission_camera_tip1 = {
		339145,
		181,
		true
	},
	apply_permission_camera_tip2 = {
		339326,
		187,
		true
	},
	apply_permission_camera_tip3 = {
		339513,
		177,
		true
	},
	apply_permission_record_audio_tip1 = {
		339690,
		163,
		true
	},
	apply_permission_record_audio_tip2 = {
		339853,
		197,
		true
	},
	apply_permission_record_audio_tip3 = {
		340050,
		183,
		true
	},
	nine_choose_one = {
		340233,
		269,
		true
	},
	help_commander_info = {
		340502,
		810,
		true
	},
	help_commander_play = {
		341312,
		810,
		true
	},
	help_commander_ability = {
		342122,
		813,
		true
	},
	story_skip_confirm = {
		342935,
		215,
		true
	},
	commander_ability_replace_warning = {
		343150,
		205,
		true
	},
	help_command_room = {
		343355,
		808,
		true
	},
	commander_build_rate_tip = {
		344163,
		154,
		true
	},
	help_activity_bossbattle = {
		344317,
		1040,
		true
	},
	commander_is_in_fleet_already = {
		345357,
		141,
		true
	},
	commander_material_is_in_fleet_tip = {
		345498,
		167,
		true
	},
	commander_main_pos = {
		345665,
		93,
		true
	},
	commander_assistant_pos = {
		345758,
		96,
		true
	},
	comander_repalce_tip = {
		345854,
		200,
		true
	},
	commander_lock_tip = {
		346054,
		121,
		true
	},
	commander_is_in_battle = {
		346175,
		125,
		true
	},
	commander_rename_warning = {
		346300,
		143,
		true
	},
	commander_rename_coldtime_tip = {
		346443,
		154,
		true
	},
	commander_rename_success_tip = {
		346597,
		115,
		true
	},
	amercian_notice_1 = {
		346712,
		170,
		true
	},
	amercian_notice_2 = {
		346882,
		131,
		true
	},
	amercian_notice_3 = {
		347013,
		104,
		true
	},
	amercian_notice_4 = {
		347117,
		92,
		true
	},
	amercian_notice_5 = {
		347209,
		112,
		true
	},
	amercian_notice_6 = {
		347321,
		222,
		true
	},
	ranking_word_1 = {
		347543,
		89,
		true
	},
	ranking_word_2 = {
		347632,
		93,
		true
	},
	ranking_word_3 = {
		347725,
		91,
		true
	},
	ranking_word_4 = {
		347816,
		93,
		true
	},
	ranking_word_5 = {
		347909,
		89,
		true
	},
	ranking_word_6 = {
		347998,
		91,
		true
	},
	ranking_word_7 = {
		348089,
		90,
		true
	},
	ranking_word_8 = {
		348179,
		82,
		true
	},
	ranking_word_9 = {
		348261,
		83,
		true
	},
	ranking_word_10 = {
		348344,
		94,
		true
	},
	spece_illegal_tip = {
		348438,
		99,
		true
	},
	utaware_warmup_notice = {
		348537,
		902,
		true
	},
	utaware_formal_notice = {
		349439,
		648,
		true
	},
	npc_learn_skill_tip = {
		350087,
		250,
		true
	},
	npc_upgrade_max_level = {
		350337,
		147,
		true
	},
	npc_propse_tip = {
		350484,
		113,
		true
	},
	npc_strength_tip = {
		350597,
		206,
		true
	},
	npc_breakout_tip = {
		350803,
		210,
		true
	},
	word_chuansong = {
		351013,
		95,
		true
	},
	npc_evaluation_tip = {
		351108,
		145,
		true
	},
	map_event_skip = {
		351253,
		90,
		true
	},
	map_event_stop_tip = {
		351343,
		163,
		true
	},
	map_event_stop_battle_tip = {
		351506,
		172,
		true
	},
	map_event_stop_battle_tip_2 = {
		351678,
		151,
		true
	},
	map_event_stop_story_tip = {
		351829,
		167,
		true
	},
	map_event_save_nekone = {
		351996,
		136,
		true
	},
	map_event_save_rurutie = {
		352132,
		139,
		true
	},
	map_event_memory_collected = {
		352271,
		152,
		true
	},
	map_event_save_kizuna = {
		352423,
		140,
		true
	},
	five_choose_one = {
		352563,
		201,
		true
	},
	ship_preference_common = {
		352764,
		107,
		true
	},
	draw_big_luck_1 = {
		352871,
		116,
		true
	},
	draw_big_luck_2 = {
		352987,
		127,
		true
	},
	draw_big_luck_3 = {
		353114,
		131,
		true
	},
	draw_medium_luck_1 = {
		353245,
		124,
		true
	},
	draw_medium_luck_2 = {
		353369,
		122,
		true
	},
	draw_medium_luck_3 = {
		353491,
		133,
		true
	},
	draw_little_luck_1 = {
		353624,
		128,
		true
	},
	draw_little_luck_2 = {
		353752,
		124,
		true
	},
	draw_little_luck_3 = {
		353876,
		134,
		true
	},
	ship_preference_non = {
		354010,
		106,
		true
	},
	school_title_dajiangtang = {
		354116,
		101,
		true
	},
	school_title_zhihuimiao = {
		354217,
		95,
		true
	},
	school_title_shitang = {
		354312,
		92,
		true
	},
	school_title_xiaomaibu = {
		354404,
		95,
		true
	},
	school_title_shangdian = {
		354499,
		94,
		true
	},
	school_title_xueyuan = {
		354593,
		98,
		true
	},
	school_title_shoucang = {
		354691,
		95,
		true
	},
	school_title_xiaoyouxiting = {
		354786,
		96,
		true
	},
	tag_level_fighting = {
		354882,
		93,
		true
	},
	tag_level_oni = {
		354975,
		89,
		true
	},
	tag_level_bomb = {
		355064,
		90,
		true
	},
	ui_word_levelui2_inevent = {
		355154,
		97,
		true
	},
	exit_backyard_exp_display = {
		355251,
		125,
		true
	},
	help_monopoly = {
		355376,
		1634,
		true
	},
	md5_error = {
		357010,
		120,
		true
	},
	world_boss_help = {
		357130,
		4705,
		true
	},
	world_boss_tip = {
		361835,
		193,
		true
	},
	world_boss_award_limit = {
		362028,
		157,
		true
	},
	backyard_is_loading = {
		362185,
		104,
		true
	},
	levelScene_loop_help_tip = {
		362289,
		2782,
		true
	},
	no_airspace_competition = {
		365071,
		104,
		true
	},
	air_supremacy_value = {
		365175,
		101,
		true
	},
	read_the_user_agreement = {
		365276,
		146,
		true
	},
	award_max_warning = {
		365422,
		175,
		true
	},
	sub_item_warning = {
		365597,
		140,
		true
	},
	select_award_warning = {
		365737,
		126,
		true
	},
	no_item_selected_tip = {
		365863,
		119,
		true
	},
	backyard_traning_tip = {
		365982,
		160,
		true
	},
	backyard_rest_tip = {
		366142,
		122,
		true
	},
	backyard_class_tip = {
		366264,
		122,
		true
	},
	medal_notice_1 = {
		366386,
		95,
		true
	},
	medal_notice_2 = {
		366481,
		86,
		true
	},
	medal_help_tip = {
		366567,
		1522,
		true
	},
	trophy_achieved = {
		368089,
		94,
		true
	},
	text_shop = {
		368183,
		77,
		true
	},
	text_confirm = {
		368260,
		83,
		true
	},
	text_cancel = {
		368343,
		81,
		true
	},
	text_cancel_fight = {
		368424,
		93,
		true
	},
	text_goon_fight = {
		368517,
		87,
		true
	},
	text_exit = {
		368604,
		77,
		true
	},
	text_clear = {
		368681,
		79,
		true
	},
	text_apply = {
		368760,
		83,
		true
	},
	text_buy = {
		368843,
		75,
		true
	},
	text_forward = {
		368918,
		78,
		true
	},
	text_prepage = {
		368996,
		80,
		true
	},
	text_nextpage = {
		369076,
		81,
		true
	},
	text_exchange = {
		369157,
		85,
		true
	},
	text_retreat = {
		369242,
		83,
		true
	},
	text_goto = {
		369325,
		80,
		true
	},
	level_scene_title_word_1 = {
		369405,
		100,
		true
	},
	level_scene_title_word_2 = {
		369505,
		108,
		true
	},
	level_scene_title_word_3 = {
		369613,
		100,
		true
	},
	level_scene_title_word_4 = {
		369713,
		97,
		true
	},
	level_scene_title_word_5 = {
		369810,
		97,
		true
	},
	ambush_display_0 = {
		369907,
		89,
		true
	},
	ambush_display_1 = {
		369996,
		84,
		true
	},
	ambush_display_2 = {
		370080,
		85,
		true
	},
	ambush_display_3 = {
		370165,
		83,
		true
	},
	ambush_display_4 = {
		370248,
		86,
		true
	},
	ambush_display_5 = {
		370334,
		84,
		true
	},
	ambush_display_6 = {
		370418,
		86,
		true
	},
	black_white_grid_notice = {
		370504,
		1416,
		true
	},
	black_white_grid_reset = {
		371920,
		104,
		true
	},
	black_white_grid_switch_tip = {
		372024,
		122,
		true
	},
	no_way_to_escape = {
		372146,
		93,
		true
	},
	word_attr_ac = {
		372239,
		92,
		true
	},
	help_battle_ac = {
		372331,
		2193,
		true
	},
	help_attribute_dodge_limit = {
		374524,
		388,
		true
	},
	refuse_friend = {
		374912,
		105,
		true
	},
	refuse_and_add_into_bl = {
		375017,
		108,
		true
	},
	tech_simulate_closed = {
		375125,
		141,
		true
	},
	tech_simulate_quit = {
		375266,
		126,
		true
	},
	technology_uplevel_error_no_res = {
		375392,
		244,
		true
	},
	help_technologytree = {
		375636,
		2458,
		true
	},
	tech_change_version_mark = {
		378094,
		108,
		true
	},
	technology_uplevel_error_studying = {
		378202,
		196,
		true
	},
	fate_attr_word = {
		378398,
		105,
		true
	},
	fate_phase_word = {
		378503,
		98,
		true
	},
	blueprint_simulation_confirm = {
		378601,
		245,
		true
	},
	blueprint_simulation_confirm_19901 = {
		378846,
		416,
		true
	},
	blueprint_simulation_confirm_19902 = {
		379262,
		397,
		true
	},
	blueprint_simulation_confirm_39903 = {
		379659,
		398,
		true
	},
	blueprint_simulation_confirm_39904 = {
		380057,
		415,
		true
	},
	blueprint_simulation_confirm_49902 = {
		380472,
		413,
		true
	},
	blueprint_simulation_confirm_99901 = {
		380885,
		412,
		true
	},
	blueprint_simulation_confirm_29903 = {
		381297,
		374,
		true
	},
	blueprint_simulation_confirm_29904 = {
		381671,
		381,
		true
	},
	blueprint_simulation_confirm_49903 = {
		382052,
		374,
		true
	},
	blueprint_simulation_confirm_49904 = {
		382426,
		384,
		true
	},
	blueprint_simulation_confirm_89902 = {
		382810,
		380,
		true
	},
	blueprint_simulation_confirm_19903 = {
		383190,
		406,
		true
	},
	blueprint_simulation_confirm_39905 = {
		383596,
		349,
		true
	},
	blueprint_simulation_confirm_49905 = {
		383945,
		409,
		true
	},
	blueprint_simulation_confirm_49906 = {
		384354,
		339,
		true
	},
	blueprint_simulation_confirm_69901 = {
		384693,
		421,
		true
	},
	blueprint_simulation_confirm_29905 = {
		385114,
		398,
		true
	},
	blueprint_simulation_confirm_49907 = {
		385512,
		406,
		true
	},
	blueprint_simulation_confirm_59901 = {
		385918,
		396,
		true
	},
	blueprint_simulation_confirm_79901 = {
		386314,
		347,
		true
	},
	blueprint_simulation_confirm_89903 = {
		386661,
		416,
		true
	},
	blueprint_simulation_confirm_19904 = {
		387077,
		423,
		true
	},
	blueprint_simulation_confirm_39906 = {
		387500,
		430,
		true
	},
	blueprint_simulation_confirm_49908 = {
		387930,
		441,
		true
	},
	blueprint_simulation_confirm_49909 = {
		388371,
		440,
		true
	},
	blueprint_simulation_confirm_99902 = {
		388811,
		431,
		true
	},
	blueprint_simulation_confirm_19905 = {
		389242,
		379,
		true
	},
	blueprint_simulation_confirm_39907 = {
		389621,
		399,
		true
	},
	blueprint_simulation_confirm_69902 = {
		390020,
		441,
		true
	},
	blueprint_simulation_confirm_89904 = {
		390461,
		408,
		true
	},
	blueprint_simulation_confirm_79902 = {
		390869,
		385,
		true
	},
	blueprint_simulation_confirm_19906 = {
		391254,
		418,
		true
	},
	blueprint_simulation_confirm_49910 = {
		391672,
		414,
		true
	},
	blueprint_simulation_confirm_69903 = {
		392086,
		437,
		true
	},
	blueprint_simulation_confirm_79903 = {
		392523,
		431,
		true
	},
	blueprint_simulation_confirm_119901 = {
		392954,
		429,
		true
	},
	electrotherapy_wanning = {
		393383,
		125,
		true
	},
	siren_chase_warning = {
		393508,
		104,
		true
	},
	memorybook_get_award_tip = {
		393612,
		173,
		true
	},
	memorybook_notice = {
		393785,
		548,
		true
	},
	word_votes = {
		394333,
		79,
		true
	},
	number_0 = {
		394412,
		73,
		true
	},
	intimacy_desc_propose_vertical = {
		394485,
		340,
		true
	},
	without_selected_ship = {
		394825,
		101,
		true
	},
	index_all = {
		394926,
		76,
		true
	},
	index_fleetfront = {
		395002,
		89,
		true
	},
	index_fleetrear = {
		395091,
		84,
		true
	},
	index_shipType_quZhu = {
		395175,
		86,
		true
	},
	index_shipType_qinXun = {
		395261,
		87,
		true
	},
	index_shipType_zhongXun = {
		395348,
		89,
		true
	},
	index_shipType_zhanLie = {
		395437,
		88,
		true
	},
	index_shipType_hangMu = {
		395525,
		87,
		true
	},
	index_shipType_weiXiu = {
		395612,
		87,
		true
	},
	index_shipType_qianTing = {
		395699,
		89,
		true
	},
	index_other = {
		395788,
		79,
		true
	},
	index_rare2 = {
		395867,
		81,
		true
	},
	index_rare3 = {
		395948,
		79,
		true
	},
	index_rare4 = {
		396027,
		80,
		true
	},
	index_rare5 = {
		396107,
		85,
		true
	},
	index_rare6 = {
		396192,
		80,
		true
	},
	warning_mail_max_1 = {
		396272,
		197,
		true
	},
	warning_mail_max_2 = {
		396469,
		103,
		true
	},
	warning_mail_max_3 = {
		396572,
		196,
		true
	},
	warning_mail_max_4 = {
		396768,
		209,
		true
	},
	warning_mail_max_5 = {
		396977,
		141,
		true
	},
	mail_moveto_markroom_1 = {
		397118,
		223,
		true
	},
	mail_moveto_markroom_2 = {
		397341,
		233,
		true
	},
	mail_moveto_markroom_max = {
		397574,
		186,
		true
	},
	mail_markroom_delete = {
		397760,
		153,
		true
	},
	mail_markroom_tip = {
		397913,
		135,
		true
	},
	mail_manage_1 = {
		398048,
		80,
		true
	},
	mail_manage_2 = {
		398128,
		109,
		true
	},
	mail_manage_3 = {
		398237,
		116,
		true
	},
	mail_manage_tip_1 = {
		398353,
		156,
		true
	},
	mail_storeroom_tips = {
		398509,
		139,
		true
	},
	mail_storeroom_noextend = {
		398648,
		168,
		true
	},
	mail_storeroom_extend = {
		398816,
		111,
		true
	},
	mail_storeroom_extend_1 = {
		398927,
		104,
		true
	},
	mail_storeroom_taken_1 = {
		399031,
		104,
		true
	},
	mail_storeroom_max_1 = {
		399135,
		185,
		true
	},
	mail_storeroom_max_2 = {
		399320,
		136,
		true
	},
	mail_storeroom_max_3 = {
		399456,
		139,
		true
	},
	mail_storeroom_max_4 = {
		399595,
		142,
		true
	},
	mail_storeroom_addgold = {
		399737,
		103,
		true
	},
	mail_storeroom_addoil = {
		399840,
		100,
		true
	},
	mail_storeroom_collect = {
		399940,
		139,
		true
	},
	mail_search = {
		400079,
		87,
		true
	},
	mail_storeroom_resourcetaken = {
		400166,
		107,
		true
	},
	resource_max_tip_storeroom = {
		400273,
		131,
		true
	},
	mail_tip = {
		400404,
		1328,
		true
	},
	mail_page_1 = {
		401732,
		79,
		true
	},
	mail_page_2 = {
		401811,
		82,
		true
	},
	mail_page_3 = {
		401893,
		82,
		true
	},
	mail_gold_res = {
		401975,
		82,
		true
	},
	mail_oil_res = {
		402057,
		79,
		true
	},
	mail_all_price = {
		402136,
		84,
		true
	},
	return_award_bind_success = {
		402220,
		110,
		true
	},
	return_award_bind_erro = {
		402330,
		106,
		true
	},
	rename_commander_erro = {
		402436,
		111,
		true
	},
	change_display_medal_success = {
		402547,
		123,
		true
	},
	limit_skin_time_day = {
		402670,
		103,
		true
	},
	limit_skin_time_day_min = {
		402773,
		108,
		true
	},
	limit_skin_time_min = {
		402881,
		106,
		true
	},
	limit_skin_time_overtime = {
		402987,
		136,
		true
	},
	limit_skin_time_before_maintenance = {
		403123,
		119,
		true
	},
	award_window_pt_title = {
		403242,
		101,
		true
	},
	return_have_participated_in_act = {
		403343,
		140,
		true
	},
	input_returner_code = {
		403483,
		92,
		true
	},
	dress_up_success = {
		403575,
		115,
		true
	},
	already_have_the_skin = {
		403690,
		111,
		true
	},
	exchange_limit_skin_tip = {
		403801,
		188,
		true
	},
	returner_help = {
		403989,
		1925,
		true
	},
	attire_time_stamp = {
		405914,
		90,
		true
	},
	pray_build_select_ship_instruction = {
		406004,
		117,
		true
	},
	warning_pray_build_pool = {
		406121,
		212,
		true
	},
	error_pray_select_ship_max = {
		406333,
		113,
		true
	},
	tip_pray_build_pool_success = {
		406446,
		118,
		true
	},
	tip_pray_build_pool_fail = {
		406564,
		116,
		true
	},
	pray_build_help = {
		406680,
		2296,
		true
	},
	pray_build_UR_warning = {
		408976,
		161,
		true
	},
	bismarck_award_tip = {
		409137,
		118,
		true
	},
	bismarck_chapter_desc = {
		409255,
		171,
		true
	},
	returner_push_success = {
		409426,
		115,
		true
	},
	returner_max_count = {
		409541,
		126,
		true
	},
	returner_push_tip = {
		409667,
		240,
		true
	},
	returner_match_tip = {
		409907,
		232,
		true
	},
	return_lock_tip = {
		410139,
		134,
		true
	},
	challenge_help = {
		410273,
		1901,
		true
	},
	challenge_casual_reset = {
		412174,
		138,
		true
	},
	challenge_infinite_reset = {
		412312,
		153,
		true
	},
	challenge_normal_reset = {
		412465,
		132,
		true
	},
	challenge_casual_click_switch = {
		412597,
		184,
		true
	},
	challenge_infinite_click_switch = {
		412781,
		189,
		true
	},
	challenge_season_update = {
		412970,
		126,
		true
	},
	challenge_season_update_casual_clear = {
		413096,
		240,
		true
	},
	challenge_season_update_infinite_clear = {
		413336,
		245,
		true
	},
	challenge_season_update_casual_switch = {
		413581,
		274,
		true
	},
	challenge_season_update_infinite_switch = {
		413855,
		286,
		true
	},
	challenge_combat_score = {
		414141,
		101,
		true
	},
	challenge_share_progress = {
		414242,
		107,
		true
	},
	challenge_share = {
		414349,
		85,
		true
	},
	challenge_expire_warn = {
		414434,
		170,
		true
	},
	challenge_normal_tip = {
		414604,
		146,
		true
	},
	challenge_unlimited_tip = {
		414750,
		151,
		true
	},
	commander_prefab_rename_success = {
		414901,
		118,
		true
	},
	commander_prefab_name = {
		415019,
		92,
		true
	},
	commander_prefab_rename_time = {
		415111,
		145,
		true
	},
	commander_build_solt_deficiency = {
		415256,
		159,
		true
	},
	commander_select_box_tip = {
		415415,
		172,
		true
	},
	challenge_end_tip = {
		415587,
		107,
		true
	},
	pass_times = {
		415694,
		87,
		true
	},
	list_empty_tip_billboardui = {
		415781,
		116,
		true
	},
	list_empty_tip_equipmentdesignui = {
		415897,
		126,
		true
	},
	list_empty_tip_storehouseui_equip = {
		416023,
		121,
		true
	},
	list_empty_tip_storehouseui_item = {
		416144,
		125,
		true
	},
	list_empty_tip_eventui = {
		416269,
		118,
		true
	},
	list_empty_tip_guildrequestui = {
		416387,
		123,
		true
	},
	list_empty_tip_joinguildui = {
		416510,
		137,
		true
	},
	list_empty_tip_friendui = {
		416647,
		114,
		true
	},
	list_empty_tip_friendui_search = {
		416761,
		145,
		true
	},
	list_empty_tip_friendui_request = {
		416906,
		132,
		true
	},
	list_empty_tip_friendui_black = {
		417038,
		136,
		true
	},
	list_empty_tip_dockyardui = {
		417174,
		135,
		true
	},
	list_empty_tip_taskscene = {
		417309,
		120,
		true
	},
	empty_tip_mailboxui = {
		417429,
		117,
		true
	},
	emptymarkroom_tip_mailboxui = {
		417546,
		122,
		true
	},
	empty_tip_mailboxui_en = {
		417668,
		116,
		true
	},
	emptymarkroom_tip_mailboxui_en = {
		417784,
		126,
		true
	},
	words_settings_unlock_ship = {
		417910,
		105,
		true
	},
	words_settings_resolve_equip = {
		418015,
		107,
		true
	},
	words_settings_unlock_commander = {
		418122,
		116,
		true
	},
	words_settings_create_inherit = {
		418238,
		109,
		true
	},
	tips_fail_secondarypwd_much_times = {
		418347,
		185,
		true
	},
	words_desc_unlock = {
		418532,
		131,
		true
	},
	words_desc_resolve_equip = {
		418663,
		138,
		true
	},
	words_desc_create_inherit = {
		418801,
		105,
		true
	},
	words_desc_close_password = {
		418906,
		123,
		true
	},
	words_desc_change_settings = {
		419029,
		137,
		true
	},
	words_set_password = {
		419166,
		107,
		true
	},
	words_information = {
		419273,
		85,
		true
	},
	Word_Ship_Exp_Buff = {
		419358,
		92,
		true
	},
	secondarypassword_incorrectpwd_error = {
		419450,
		193,
		true
	},
	secondary_password_help = {
		419643,
		1501,
		true
	},
	comic_help = {
		421144,
		365,
		true
	},
	secondarypassword_illegal_tip = {
		421509,
		135,
		true
	},
	pt_cosume = {
		421644,
		80,
		true
	},
	secondarypassword_confirm_tips = {
		421724,
		178,
		true
	},
	help_tempesteve = {
		421902,
		800,
		true
	},
	word_rest_times = {
		422702,
		118,
		true
	},
	common_buy_gold_success = {
		422820,
		144,
		true
	},
	harbour_bomb_tip = {
		422964,
		110,
		true
	},
	submarine_approach = {
		423074,
		101,
		true
	},
	submarine_approach_desc = {
		423175,
		130,
		true
	},
	desc_quick_play = {
		423305,
		91,
		true
	},
	text_win_condition = {
		423396,
		97,
		true
	},
	text_lose_condition = {
		423493,
		99,
		true
	},
	text_rest_HP = {
		423592,
		93,
		true
	},
	desc_defense_reward = {
		423685,
		152,
		true
	},
	desc_base_hp = {
		423837,
		99,
		true
	},
	map_event_open = {
		423936,
		105,
		true
	},
	word_reward = {
		424041,
		82,
		true
	},
	tips_dispense_completed = {
		424123,
		103,
		true
	},
	tips_firework_completed = {
		424226,
		116,
		true
	},
	help_summer_feast = {
		424342,
		1164,
		true
	},
	help_firework_produce = {
		425506,
		668,
		true
	},
	help_firework = {
		426174,
		1685,
		true
	},
	help_summer_shrine = {
		427859,
		1066,
		true
	},
	help_summer_food = {
		428925,
		1622,
		true
	},
	help_summer_shooting = {
		430547,
		1075,
		true
	},
	help_summer_stamp = {
		431622,
		341,
		true
	},
	tips_summergame_exit = {
		431963,
		198,
		true
	},
	tips_shrine_buff = {
		432161,
		121,
		true
	},
	tips_shrine_nobuff = {
		432282,
		175,
		true
	},
	paint_hide_other_obj_tip = {
		432457,
		111,
		true
	},
	help_vote = {
		432568,
		6103,
		true
	},
	tips_firework_exit = {
		438671,
		157,
		true
	},
	result_firework_produce = {
		438828,
		148,
		true
	},
	tag_level_narrative = {
		438976,
		88,
		true
	},
	vote_get_book = {
		439064,
		115,
		true
	},
	vote_book_is_over = {
		439179,
		115,
		true
	},
	vote_fame_tip = {
		439294,
		167,
		true
	},
	word_maintain = {
		439461,
		94,
		true
	},
	name_zhanliejahe = {
		439555,
		97,
		true
	},
	change_skin_secretary_ship_success = {
		439652,
		124,
		true
	},
	change_skin_secretary_ship = {
		439776,
		103,
		true
	},
	word_billboard = {
		439879,
		86,
		true
	},
	word_easy = {
		439965,
		77,
		true
	},
	word_normal_junhe = {
		440042,
		87,
		true
	},
	word_hard = {
		440129,
		77,
		true
	},
	word_special_challenge_ticket = {
		440206,
		105,
		true
	},
	tip_exchange_ticket = {
		440311,
		177,
		true
	},
	dont_remind = {
		440488,
		89,
		true
	},
	worldbossex_help = {
		440577,
		909,
		true
	},
	ship_formationUI_fleetName_easy = {
		441486,
		99,
		true
	},
	ship_formationUI_fleetName_normal = {
		441585,
		103,
		true
	},
	ship_formationUI_fleetName_hard = {
		441688,
		99,
		true
	},
	ship_formationUI_fleetName_extra = {
		441787,
		98,
		true
	},
	ship_formationUI_fleetName_easy_ss = {
		441885,
		114,
		true
	},
	ship_formationUI_fleetName_normal_ss = {
		441999,
		118,
		true
	},
	ship_formationUI_fleetName_hard_ss = {
		442117,
		114,
		true
	},
	ship_formationUI_fleetName_extra_ss = {
		442231,
		113,
		true
	},
	text_consume = {
		442344,
		80,
		true
	},
	text_inconsume = {
		442424,
		80,
		true
	},
	pt_ship_now = {
		442504,
		93,
		true
	},
	pt_ship_goal = {
		442597,
		81,
		true
	},
	option_desc1 = {
		442678,
		165,
		true
	},
	option_desc2 = {
		442843,
		158,
		true
	},
	option_desc3 = {
		443001,
		167,
		true
	},
	option_desc4 = {
		443168,
		202,
		true
	},
	option_desc5 = {
		443370,
		140,
		true
	},
	option_desc6 = {
		443510,
		155,
		true
	},
	option_desc10 = {
		443665,
		143,
		true
	},
	option_desc11 = {
		443808,
		1748,
		true
	},
	music_collection = {
		445556,
		859,
		true
	},
	music_main = {
		446415,
		1073,
		true
	},
	music_juus = {
		447488,
		1103,
		true
	},
	doa_collection = {
		448591,
		846,
		true
	},
	ins_word_day = {
		449437,
		88,
		true
	},
	ins_word_hour = {
		449525,
		89,
		true
	},
	ins_word_minu = {
		449614,
		91,
		true
	},
	ins_word_like = {
		449705,
		85,
		true
	},
	ins_click_like_success = {
		449790,
		106,
		true
	},
	ins_push_comment_success = {
		449896,
		120,
		true
	},
	skinshop_live2d_fliter_failed = {
		450016,
		146,
		true
	},
	help_music_game = {
		450162,
		1355,
		true
	},
	restart_music_game = {
		451517,
		130,
		true
	},
	reselect_music_game = {
		451647,
		144,
		true
	},
	hololive_goodmorning = {
		451791,
		852,
		true
	},
	hololive_lianliankan = {
		452643,
		1410,
		true
	},
	hololive_dalaozhang = {
		454053,
		764,
		true
	},
	hololive_dashenling = {
		454817,
		1927,
		true
	},
	pocky_jiujiu = {
		456744,
		94,
		true
	},
	pocky_jiujiu_desc = {
		456838,
		118,
		true
	},
	pocky_help = {
		456956,
		697,
		true
	},
	secretary_help = {
		457653,
		2209,
		true
	},
	secretary_unlock2 = {
		459862,
		108,
		true
	},
	secretary_unlock3 = {
		459970,
		108,
		true
	},
	secretary_unlock4 = {
		460078,
		108,
		true
	},
	secretary_unlock5 = {
		460186,
		109,
		true
	},
	secretary_closed = {
		460295,
		88,
		true
	},
	confirm_unlock = {
		460383,
		113,
		true
	},
	secretary_pos_save = {
		460496,
		143,
		true
	},
	secretary_pos_save_success = {
		460639,
		105,
		true
	},
	collection_help = {
		460744,
		346,
		true
	},
	juese_tiyan = {
		461090,
		239,
		true
	},
	resolve_amount_prefix = {
		461329,
		104,
		true
	},
	compose_amount_prefix = {
		461433,
		100,
		true
	},
	help_sub_limits = {
		461533,
		92,
		true
	},
	help_sub_display = {
		461625,
		104,
		true
	},
	confirm_unlock_ship_main = {
		461729,
		151,
		true
	},
	msgbox_text_confirm = {
		461880,
		90,
		true
	},
	msgbox_text_shop = {
		461970,
		85,
		true
	},
	msgbox_text_cancel = {
		462055,
		88,
		true
	},
	msgbox_text_cancel_g = {
		462143,
		90,
		true
	},
	msgbox_text_cancel_fight = {
		462233,
		100,
		true
	},
	msgbox_text_goon_fight = {
		462333,
		94,
		true
	},
	msgbox_text_exit = {
		462427,
		84,
		true
	},
	msgbox_text_clear = {
		462511,
		86,
		true
	},
	msgbox_text_apply = {
		462597,
		85,
		true
	},
	msgbox_text_buy = {
		462682,
		87,
		true
	},
	msgbox_text_noPos_buy = {
		462769,
		91,
		true
	},
	msgbox_text_noPos_clear = {
		462860,
		91,
		true
	},
	msgbox_text_noPos_intensify = {
		462951,
		98,
		true
	},
	msgbox_text_forward = {
		463049,
		85,
		true
	},
	msgbox_text_iknow = {
		463134,
		87,
		true
	},
	msgbox_text_prepage = {
		463221,
		87,
		true
	},
	msgbox_text_nextpage = {
		463308,
		88,
		true
	},
	msgbox_text_exchange = {
		463396,
		92,
		true
	},
	msgbox_text_retreat = {
		463488,
		90,
		true
	},
	msgbox_text_go = {
		463578,
		80,
		true
	},
	msgbox_text_consume = {
		463658,
		87,
		true
	},
	msgbox_text_inconsume = {
		463745,
		87,
		true
	},
	msgbox_text_unlock = {
		463832,
		88,
		true
	},
	msgbox_text_save = {
		463920,
		85,
		true
	},
	msgbox_text_replace = {
		464005,
		88,
		true
	},
	msgbox_text_unload = {
		464093,
		89,
		true
	},
	msgbox_text_modify = {
		464182,
		89,
		true
	},
	msgbox_text_breakthrough = {
		464271,
		93,
		true
	},
	msgbox_text_equipdetail = {
		464364,
		94,
		true
	},
	msgbox_text_use = {
		464458,
		82,
		true
	},
	common_flag_ship = {
		464540,
		89,
		true
	},
	fenjie_lantu_tip = {
		464629,
		188,
		true
	},
	msgbox_text_analyse = {
		464817,
		90,
		true
	},
	fragresolve_empty_tip = {
		464907,
		151,
		true
	},
	confirm_unlock_lv = {
		465058,
		121,
		true
	},
	shops_rest_day = {
		465179,
		98,
		true
	},
	title_limit_time = {
		465277,
		91,
		true
	},
	seven_choose_one = {
		465368,
		224,
		true
	},
	help_newyear_feast = {
		465592,
		1386,
		true
	},
	help_newyear_shrine = {
		466978,
		1243,
		true
	},
	help_newyear_stamp = {
		468221,
		238,
		true
	},
	pt_reconfirm = {
		468459,
		124,
		true
	},
	qte_game_help = {
		468583,
		340,
		true
	},
	word_equipskin_type = {
		468923,
		88,
		true
	},
	word_equipskin_all = {
		469011,
		86,
		true
	},
	word_equipskin_cannon = {
		469097,
		95,
		true
	},
	word_equipskin_tarpedo = {
		469192,
		96,
		true
	},
	word_equipskin_aircraft = {
		469288,
		96,
		true
	},
	word_equipskin_aux = {
		469384,
		86,
		true
	},
	msgbox_repair = {
		469470,
		91,
		true
	},
	msgbox_repair_l2d = {
		469561,
		95,
		true
	},
	msgbox_repair_painting = {
		469656,
		105,
		true
	},
	l2d_32xbanned_warning = {
		469761,
		174,
		true
	},
	word_no_cache = {
		469935,
		107,
		true
	},
	pile_game_notice = {
		470042,
		993,
		true
	},
	help_chunjie_stamp = {
		471035,
		677,
		true
	},
	help_chunjie_feast = {
		471712,
		670,
		true
	},
	help_chunjie_jiulou = {
		472382,
		755,
		true
	},
	special_animal1 = {
		473137,
		227,
		true
	},
	special_animal2 = {
		473364,
		287,
		true
	},
	special_animal3 = {
		473651,
		236,
		true
	},
	special_animal4 = {
		473887,
		256,
		true
	},
	special_animal5 = {
		474143,
		251,
		true
	},
	special_animal6 = {
		474394,
		272,
		true
	},
	special_animal7 = {
		474666,
		275,
		true
	},
	bulin_help = {
		474941,
		403,
		true
	},
	super_bulin = {
		475344,
		120,
		true
	},
	super_bulin_tip = {
		475464,
		110,
		true
	},
	bulin_tip1 = {
		475574,
		101,
		true
	},
	bulin_tip2 = {
		475675,
		117,
		true
	},
	bulin_tip3 = {
		475792,
		101,
		true
	},
	bulin_tip4 = {
		475893,
		108,
		true
	},
	bulin_tip5 = {
		476001,
		101,
		true
	},
	bulin_tip6 = {
		476102,
		108,
		true
	},
	bulin_tip7 = {
		476210,
		101,
		true
	},
	bulin_tip8 = {
		476311,
		126,
		true
	},
	bulin_tip9 = {
		476437,
		122,
		true
	},
	bulin_tip_other1 = {
		476559,
		192,
		true
	},
	bulin_tip_other2 = {
		476751,
		109,
		true
	},
	bulin_tip_other3 = {
		476860,
		122,
		true
	},
	monopoly_left_count = {
		476982,
		89,
		true
	},
	help_chunjie_monopoly = {
		477071,
		1083,
		true
	},
	monoply_drop_ship_step = {
		478154,
		157,
		true
	},
	lanternRiddles_wait_for_reanswer = {
		478311,
		144,
		true
	},
	lanternRiddles_answer_is_wrong = {
		478455,
		118,
		true
	},
	lanternRiddles_answer_is_right = {
		478573,
		110,
		true
	},
	lanternRiddles_gametip = {
		478683,
		607,
		true
	},
	LanternRiddle_wait_time_tip = {
		479290,
		105,
		true
	},
	LinkLinkGame_BestTime = {
		479395,
		92,
		true
	},
	LinkLinkGame_CurTime = {
		479487,
		89,
		true
	},
	sort_attribute = {
		479576,
		82,
		true
	},
	sort_intimacy = {
		479658,
		85,
		true
	},
	index_skin = {
		479743,
		82,
		true
	},
	index_reform = {
		479825,
		94,
		true
	},
	index_reform_cw = {
		479919,
		97,
		true
	},
	index_strengthen = {
		480016,
		91,
		true
	},
	index_special = {
		480107,
		84,
		true
	},
	index_propose_skin = {
		480191,
		96,
		true
	},
	index_not_obtained = {
		480287,
		92,
		true
	},
	index_no_limit = {
		480379,
		86,
		true
	},
	index_awakening = {
		480465,
		91,
		true
	},
	index_not_lvmax = {
		480556,
		90,
		true
	},
	index_spweapon = {
		480646,
		91,
		true
	},
	index_marry = {
		480737,
		81,
		true
	},
	decodegame_gametip = {
		480818,
		2081,
		true
	},
	indexsort_sort = {
		482899,
		82,
		true
	},
	indexsort_index = {
		482981,
		84,
		true
	},
	indexsort_camp = {
		483065,
		85,
		true
	},
	indexsort_type = {
		483150,
		82,
		true
	},
	indexsort_rarity = {
		483232,
		86,
		true
	},
	indexsort_extraindex = {
		483318,
		89,
		true
	},
	indexsort_label = {
		483407,
		83,
		true
	},
	indexsort_sorteng = {
		483490,
		85,
		true
	},
	indexsort_indexeng = {
		483575,
		87,
		true
	},
	indexsort_campeng = {
		483662,
		88,
		true
	},
	indexsort_rarityeng = {
		483750,
		89,
		true
	},
	indexsort_typeeng = {
		483839,
		85,
		true
	},
	indexsort_labeleng = {
		483924,
		86,
		true
	},
	fightfail_up = {
		484010,
		139,
		true
	},
	fightfail_equip = {
		484149,
		141,
		true
	},
	fight_strengthen = {
		484290,
		158,
		true
	},
	fightfail_noequip = {
		484448,
		107,
		true
	},
	fightfail_choiceequip = {
		484555,
		136,
		true
	},
	fightfail_choicestrengthen = {
		484691,
		151,
		true
	},
	sofmap_attention = {
		484842,
		258,
		true
	},
	sofmapsd_1 = {
		485100,
		153,
		true
	},
	sofmapsd_2 = {
		485253,
		132,
		true
	},
	sofmapsd_3 = {
		485385,
		110,
		true
	},
	sofmapsd_4 = {
		485495,
		133,
		true
	},
	inform_level_limit = {
		485628,
		138,
		true
	},
	["3match_tip"] = {
		485766,
		381,
		true
	},
	retire_selectzero = {
		486147,
		138,
		true
	},
	retire_marry_skin = {
		486285,
		106,
		true
	},
	undermist_tip = {
		486391,
		143,
		true
	},
	retire_1 = {
		486534,
		254,
		true
	},
	retire_2 = {
		486788,
		256,
		true
	},
	retire_3 = {
		487044,
		96,
		true
	},
	retire_rarity = {
		487140,
		97,
		true
	},
	retire_title = {
		487237,
		91,
		true
	},
	res_unlock_tip = {
		487328,
		120,
		true
	},
	res_wifi_tip = {
		487448,
		206,
		true
	},
	res_downloading = {
		487654,
		90,
		true
	},
	res_pic_new_tip = {
		487744,
		145,
		true
	},
	res_music_no_pre_tip = {
		487889,
		95,
		true
	},
	res_music_no_next_tip = {
		487984,
		95,
		true
	},
	res_music_new_tip = {
		488079,
		106,
		true
	},
	apple_link_title = {
		488185,
		101,
		true
	},
	retire_setting_help = {
		488286,
		883,
		true
	},
	activity_shop_exchange_count = {
		489169,
		98,
		true
	},
	shops_msgbox_exchange_count = {
		489267,
		107,
		true
	},
	shops_msgbox_output = {
		489374,
		92,
		true
	},
	shop_word_exchange = {
		489466,
		89,
		true
	},
	shop_word_cancel = {
		489555,
		86,
		true
	},
	title_item_ways = {
		489641,
		152,
		true
	},
	item_lack_title = {
		489793,
		152,
		true
	},
	oil_buy_tip_2 = {
		489945,
		386,
		true
	},
	target_chapter_is_lock = {
		490331,
		126,
		true
	},
	ship_book = {
		490457,
		104,
		true
	},
	month_sign_resign = {
		490561,
		87,
		true
	},
	collect_tip = {
		490648,
		139,
		true
	},
	collect_tip2 = {
		490787,
		140,
		true
	},
	word_weakness = {
		490927,
		88,
		true
	},
	special_operation_tip1 = {
		491015,
		111,
		true
	},
	special_operation_tip2 = {
		491126,
		111,
		true
	},
	area_lock = {
		491237,
		106,
		true
	},
	equipment_upgrade_equipped_tag = {
		491343,
		105,
		true
	},
	equipment_upgrade_spare_tag = {
		491448,
		102,
		true
	},
	equipment_upgrade_help = {
		491550,
		1285,
		true
	},
	equipment_upgrade_title = {
		492835,
		97,
		true
	},
	equipment_upgrade_coin_consume = {
		492932,
		98,
		true
	},
	equipment_upgrade_quick_interface_source_chosen = {
		493030,
		123,
		true
	},
	equipment_upgrade_quick_interface_materials_consume = {
		493153,
		121,
		true
	},
	equipment_upgrade_feedback_lack_of_materials = {
		493274,
		141,
		true
	},
	equipment_upgrade_feedback_equipment_consume = {
		493415,
		211,
		true
	},
	equipment_upgrade_feedback_equipment_can_be_produced = {
		493626,
		168,
		true
	},
	equipment_upgrade_quick_interface_feedback_source_chosen = {
		493794,
		133,
		true
	},
	equipment_upgrade_feedback_lack_of_equipment = {
		493927,
		127,
		true
	},
	equipment_upgrade_equipped_unavailable = {
		494054,
		211,
		true
	},
	equipment_upgrade_initial_node = {
		494265,
		134,
		true
	},
	equipment_upgrade_feedback_compose_tip = {
		494399,
		192,
		true
	},
	discount_coupon_tip = {
		494591,
		193,
		true
	},
	pizzahut_help = {
		494784,
		738,
		true
	},
	towerclimbing_gametip = {
		495522,
		645,
		true
	},
	qingdianguangchang_help = {
		496167,
		660,
		true
	},
	building_tip = {
		496827,
		177,
		true
	},
	building_upgrade_tip = {
		497004,
		155,
		true
	},
	msgbox_text_upgrade = {
		497159,
		90,
		true
	},
	towerclimbing_sign_help = {
		497249,
		793,
		true
	},
	building_complete_tip = {
		498042,
		102,
		true
	},
	backyard_theme_refresh_time_tip = {
		498144,
		124,
		true
	},
	backyard_theme_total_print = {
		498268,
		95,
		true
	},
	backyard_theme_shop_title = {
		498363,
		105,
		true
	},
	backyard_theme_mine_title = {
		498468,
		99,
		true
	},
	backyard_theme_collection_title = {
		498567,
		107,
		true
	},
	backyard_theme_ban_upload_tip = {
		498674,
		214,
		true
	},
	backyard_theme_upload_over_maxcnt = {
		498888,
		194,
		true
	},
	backyard_theme_apply_tip1 = {
		499082,
		208,
		true
	},
	backyard_theme_word_buy = {
		499290,
		90,
		true
	},
	backyard_theme_word_apply = {
		499380,
		94,
		true
	},
	backyard_theme_apply_success = {
		499474,
		105,
		true
	},
	backyard_theme_unload_success = {
		499579,
		109,
		true
	},
	backyard_theme_upload_success = {
		499688,
		101,
		true
	},
	backyard_theme_delete_success = {
		499789,
		100,
		true
	},
	backyard_theme_apply_tip2 = {
		499889,
		138,
		true
	},
	backyard_theme_upload_cnt = {
		500027,
		113,
		true
	},
	backyard_theme_upload_time = {
		500140,
		102,
		true
	},
	backyard_theme_word_like = {
		500242,
		93,
		true
	},
	backyard_theme_word_collection = {
		500335,
		103,
		true
	},
	backyard_theme_cancel_collection = {
		500438,
		138,
		true
	},
	backyard_theme_inform_them = {
		500576,
		105,
		true
	},
	open_backyard_theme_template_tip = {
		500681,
		143,
		true
	},
	backyard_theme_cancel_template_upload_tip = {
		500824,
		249,
		true
	},
	backyard_theme_delete_themplate_tip = {
		501073,
		228,
		true
	},
	backyard_theme_template_be_delete_tip = {
		501301,
		140,
		true
	},
	backyard_theme_template_collection_cnt_max = {
		501441,
		143,
		true
	},
	backyard_theme_template_collection_cnt = {
		501584,
		120,
		true
	},
	words_visit_backyard_toggle = {
		501704,
		124,
		true
	},
	words_show_friend_backyardship_toggle = {
		501828,
		154,
		true
	},
	words_show_my_backyardship_toggle = {
		501982,
		154,
		true
	},
	option_desc7 = {
		502136,
		133,
		true
	},
	option_desc8 = {
		502269,
		147,
		true
	},
	option_desc9 = {
		502416,
		174,
		true
	},
	backyard_unopen = {
		502590,
		108,
		true
	},
	backyard_shop_refresh_frequently = {
		502698,
		157,
		true
	},
	word_random = {
		502855,
		81,
		true
	},
	word_hot = {
		502936,
		75,
		true
	},
	word_new = {
		503011,
		75,
		true
	},
	backyard_decoration_theme_template_delete_tip = {
		503086,
		210,
		true
	},
	backyard_not_found_theme_template = {
		503296,
		128,
		true
	},
	backyard_apply_theme_template_erro = {
		503424,
		122,
		true
	},
	backyard_theme_template_list_is_empty = {
		503546,
		121,
		true
	},
	BackYard_collection_be_delete_tip = {
		503667,
		181,
		true
	},
	help_monopoly_car = {
		503848,
		1056,
		true
	},
	help_monopoly_car_2 = {
		504904,
		1125,
		true
	},
	help_monopoly_3th = {
		506029,
		795,
		true
	},
	backYard_missing_furnitrue_tip = {
		506824,
		114,
		true
	},
	win_condition_display_qijian = {
		506938,
		120,
		true
	},
	win_condition_display_qijian_tip = {
		507058,
		126,
		true
	},
	win_condition_display_shangchuan = {
		507184,
		151,
		true
	},
	win_condition_display_shangchuan_tip = {
		507335,
		170,
		true
	},
	win_condition_display_judian = {
		507505,
		116,
		true
	},
	win_condition_display_tuoli = {
		507621,
		126,
		true
	},
	win_condition_display_tuoli_tip = {
		507747,
		130,
		true
	},
	lose_condition_display_quanmie = {
		507877,
		123,
		true
	},
	lose_condition_display_gangqu = {
		508000,
		155,
		true
	},
	re_battle = {
		508155,
		79,
		true
	},
	keep_fate_tip = {
		508234,
		148,
		true
	},
	equip_info_1 = {
		508382,
		79,
		true
	},
	equip_info_2 = {
		508461,
		84,
		true
	},
	equip_info_3 = {
		508545,
		89,
		true
	},
	equip_info_4 = {
		508634,
		81,
		true
	},
	equip_info_5 = {
		508715,
		85,
		true
	},
	equip_info_6 = {
		508800,
		90,
		true
	},
	equip_info_7 = {
		508890,
		86,
		true
	},
	equip_info_8 = {
		508976,
		86,
		true
	},
	equip_info_9 = {
		509062,
		90,
		true
	},
	equip_info_10 = {
		509152,
		85,
		true
	},
	equip_info_11 = {
		509237,
		85,
		true
	},
	equip_info_12 = {
		509322,
		89,
		true
	},
	equip_info_13 = {
		509411,
		86,
		true
	},
	equip_info_14 = {
		509497,
		92,
		true
	},
	equip_info_15 = {
		509589,
		87,
		true
	},
	equip_info_16 = {
		509676,
		89,
		true
	},
	equip_info_17 = {
		509765,
		88,
		true
	},
	equip_info_18 = {
		509853,
		89,
		true
	},
	equip_info_19 = {
		509942,
		84,
		true
	},
	equip_info_20 = {
		510026,
		88,
		true
	},
	equip_info_21 = {
		510114,
		85,
		true
	},
	equip_info_22 = {
		510199,
		91,
		true
	},
	equip_info_23 = {
		510290,
		90,
		true
	},
	equip_info_24 = {
		510380,
		86,
		true
	},
	equip_info_25 = {
		510466,
		77,
		true
	},
	equip_info_26 = {
		510543,
		90,
		true
	},
	equip_info_27 = {
		510633,
		77,
		true
	},
	equip_info_28 = {
		510710,
		93,
		true
	},
	equip_info_29 = {
		510803,
		80,
		true
	},
	equip_info_30 = {
		510883,
		80,
		true
	},
	equip_info_31 = {
		510963,
		80,
		true
	},
	equip_info_32 = {
		511043,
		91,
		true
	},
	equip_info_33 = {
		511134,
		89,
		true
	},
	equip_info_34 = {
		511223,
		90,
		true
	},
	equip_info_extralevel_0 = {
		511313,
		94,
		true
	},
	equip_info_extralevel_1 = {
		511407,
		94,
		true
	},
	equip_info_extralevel_2 = {
		511501,
		94,
		true
	},
	equip_info_extralevel_3 = {
		511595,
		94,
		true
	},
	tec_settings_btn_word = {
		511689,
		99,
		true
	},
	tec_tendency_x = {
		511788,
		86,
		true
	},
	tec_tendency_0 = {
		511874,
		86,
		true
	},
	tec_tendency_1 = {
		511960,
		87,
		true
	},
	tec_tendency_2 = {
		512047,
		87,
		true
	},
	tec_tendency_3 = {
		512134,
		87,
		true
	},
	tec_tendency_4 = {
		512221,
		87,
		true
	},
	tec_tendency_cur_x = {
		512308,
		101,
		true
	},
	tec_tendency_cur_0 = {
		512409,
		108,
		true
	},
	tec_tendency_cur_1 = {
		512517,
		107,
		true
	},
	tec_tendency_cur_2 = {
		512624,
		107,
		true
	},
	tec_tendency_cur_3 = {
		512731,
		107,
		true
	},
	tec_target_catchup_none = {
		512838,
		117,
		true
	},
	tec_target_catchup_selected = {
		512955,
		105,
		true
	},
	tec_tendency_cur_4 = {
		513060,
		107,
		true
	},
	tec_target_catchup_none_x = {
		513167,
		108,
		true
	},
	tec_target_catchup_none_1 = {
		513275,
		107,
		true
	},
	tec_target_catchup_none_2 = {
		513382,
		107,
		true
	},
	tec_target_catchup_none_3 = {
		513489,
		107,
		true
	},
	tec_target_catchup_selected_x = {
		513596,
		108,
		true
	},
	tec_target_catchup_selected_1 = {
		513704,
		107,
		true
	},
	tec_target_catchup_selected_2 = {
		513811,
		107,
		true
	},
	tec_target_catchup_selected_3 = {
		513918,
		107,
		true
	},
	tec_target_catchup_finish_x = {
		514025,
		106,
		true
	},
	tec_target_catchup_finish_1 = {
		514131,
		105,
		true
	},
	tec_target_catchup_finish_2 = {
		514236,
		105,
		true
	},
	tec_target_catchup_finish_3 = {
		514341,
		105,
		true
	},
	tec_target_catchup_finish_4 = {
		514446,
		105,
		true
	},
	tec_target_catchup_dr_finish_tip = {
		514551,
		105,
		true
	},
	tec_target_catchup_all_finish_tip = {
		514656,
		114,
		true
	},
	tec_target_catchup_show_the_finished_version = {
		514770,
		133,
		true
	},
	tec_target_catchup_pry_char = {
		514903,
		99,
		true
	},
	tec_target_catchup_dr_char = {
		515002,
		98,
		true
	},
	tec_target_need_print = {
		515100,
		98,
		true
	},
	tec_target_catchup_progress = {
		515198,
		99,
		true
	},
	tec_target_catchup_select_tip = {
		515297,
		135,
		true
	},
	tec_target_catchup_help_tip = {
		515432,
		824,
		true
	},
	tec_speedup_title = {
		516256,
		102,
		true
	},
	tec_speedup_progress = {
		516358,
		94,
		true
	},
	tec_speedup_overflow = {
		516452,
		186,
		true
	},
	tec_speedup_help_tip = {
		516638,
		274,
		true
	},
	click_back_tip = {
		516912,
		92,
		true
	},
	tech_catchup_sentence_pauses = {
		517004,
		95,
		true
	},
	tec_act_catchup_btn_word = {
		517099,
		103,
		true
	},
	tec_catchup_errorfix = {
		517202,
		226,
		true
	},
	guild_duty_is_too_low = {
		517428,
		149,
		true
	},
	guild_trainee_duty_change_tip = {
		517577,
		144,
		true
	},
	guild_not_exist_donate_task = {
		517721,
		121,
		true
	},
	guild_week_task_state_is_wrong = {
		517842,
		131,
		true
	},
	guild_get_week_done = {
		517973,
		127,
		true
	},
	guild_public_awards = {
		518100,
		97,
		true
	},
	guild_private_awards = {
		518197,
		99,
		true
	},
	guild_task_selecte_tip = {
		518296,
		276,
		true
	},
	guild_task_accept = {
		518572,
		374,
		true
	},
	guild_commander_and_sub_op = {
		518946,
		152,
		true
	},
	["guild_donate_times_not enough"] = {
		519098,
		144,
		true
	},
	guild_donate_success = {
		519242,
		108,
		true
	},
	guild_left_donate_cnt = {
		519350,
		118,
		true
	},
	guild_donate_tip = {
		519468,
		228,
		true
	},
	guild_donate_addition_capital_tip = {
		519696,
		125,
		true
	},
	guild_donate_addition_techpoint_tip = {
		519821,
		141,
		true
	},
	guild_donate_capital_toplimit = {
		519962,
		151,
		true
	},
	guild_donate_techpoint_toplimit = {
		520113,
		153,
		true
	},
	guild_supply_no_open = {
		520266,
		121,
		true
	},
	guild_supply_award_got = {
		520387,
		119,
		true
	},
	guild_new_member_get_award_tip = {
		520506,
		181,
		true
	},
	guild_start_supply_consume_tip = {
		520687,
		143,
		true
	},
	guild_left_supply_day = {
		520830,
		99,
		true
	},
	guild_supply_help_tip = {
		520929,
		731,
		true
	},
	guild_op_only_administrator = {
		521660,
		153,
		true
	},
	guild_shop_refresh_done = {
		521813,
		102,
		true
	},
	guild_shop_cnt_no_enough = {
		521915,
		113,
		true
	},
	guild_shop_refresh_all_tip = {
		522028,
		205,
		true
	},
	guild_shop_exchange_tip = {
		522233,
		128,
		true
	},
	guild_shop_label_1 = {
		522361,
		115,
		true
	},
	guild_shop_label_2 = {
		522476,
		87,
		true
	},
	guild_shop_label_3 = {
		522563,
		89,
		true
	},
	guild_shop_label_4 = {
		522652,
		86,
		true
	},
	guild_shop_label_5 = {
		522738,
		119,
		true
	},
	guild_shop_must_select_goods = {
		522857,
		125,
		true
	},
	guild_not_exist_activation_tech = {
		522982,
		143,
		true
	},
	guild_not_exist_tech = {
		523125,
		119,
		true
	},
	guild_cancel_only_once_pre_day = {
		523244,
		144,
		true
	},
	guild_tech_is_max_level = {
		523388,
		132,
		true
	},
	guild_tech_gold_no_enough = {
		523520,
		141,
		true
	},
	guild_tech_guildgold_no_enough = {
		523661,
		153,
		true
	},
	guild_tech_upgrade_done = {
		523814,
		118,
		true
	},
	guild_exist_activation_tech = {
		523932,
		136,
		true
	},
	guild_tech_gold_desc = {
		524068,
		105,
		true
	},
	guild_tech_oil_desc = {
		524173,
		102,
		true
	},
	guild_tech_shipbag_desc = {
		524275,
		101,
		true
	},
	guild_tech_equipbag_desc = {
		524376,
		107,
		true
	},
	guild_box_gold_desc = {
		524483,
		99,
		true
	},
	guidl_r_box_time_desc = {
		524582,
		115,
		true
	},
	guidl_sr_box_time_desc = {
		524697,
		117,
		true
	},
	guidl_ssr_box_time_desc = {
		524814,
		123,
		true
	},
	guild_member_max_cnt_desc = {
		524937,
		110,
		true
	},
	guild_tech_livness_no_enough = {
		525047,
		271,
		true
	},
	guild_tech_livness_no_enough_label = {
		525318,
		126,
		true
	},
	guild_ship_attr_desc = {
		525444,
		133,
		true
	},
	guild_start_tech_group_tip = {
		525577,
		164,
		true
	},
	guild_cancel_tech_tip = {
		525741,
		182,
		true
	},
	guild_tech_consume_tip = {
		525923,
		219,
		true
	},
	guild_tech_non_admin = {
		526142,
		146,
		true
	},
	guild_tech_label_max_level = {
		526288,
		100,
		true
	},
	guild_tech_label_dev_progress = {
		526388,
		102,
		true
	},
	guild_tech_label_condition = {
		526490,
		131,
		true
	},
	guild_tech_donate_target = {
		526621,
		122,
		true
	},
	guild_not_exist = {
		526743,
		105,
		true
	},
	guild_not_exist_battle = {
		526848,
		126,
		true
	},
	guild_battle_is_end = {
		526974,
		121,
		true
	},
	guild_battle_is_exist = {
		527095,
		126,
		true
	},
	guild_guildgold_no_enough_for_battle = {
		527221,
		164,
		true
	},
	guild_event_start_tip1 = {
		527385,
		167,
		true
	},
	guild_event_start_tip2 = {
		527552,
		168,
		true
	},
	guild_word_may_happen_event = {
		527720,
		106,
		true
	},
	guild_battle_award = {
		527826,
		90,
		true
	},
	guild_word_consume = {
		527916,
		87,
		true
	},
	guild_start_event_consume_tip = {
		528003,
		149,
		true
	},
	guild_start_event_consume_tip_extra = {
		528152,
		222,
		true
	},
	guild_word_consume_for_battle = {
		528374,
		99,
		true
	},
	guild_level_no_enough = {
		528473,
		159,
		true
	},
	guild_open_event_info_when_exist_active = {
		528632,
		170,
		true
	},
	guild_join_event_cnt_label = {
		528802,
		117,
		true
	},
	guild_join_event_max_cnt_tip = {
		528919,
		124,
		true
	},
	guild_join_event_progress_label = {
		529043,
		104,
		true
	},
	guild_join_event_exist_finished_mission_tip = {
		529147,
		277,
		true
	},
	guild_event_not_exist = {
		529424,
		119,
		true
	},
	guild_fleet_can_not_edit = {
		529543,
		131,
		true
	},
	guild_fleet_exist_same_kind_ship = {
		529674,
		151,
		true
	},
	guild_event_exist_same_kind_ship = {
		529825,
		171,
		true
	},
	guidl_event_ship_in_event = {
		529996,
		150,
		true
	},
	guild_event_start_done = {
		530146,
		110,
		true
	},
	guild_fleet_update_done = {
		530256,
		122,
		true
	},
	guild_event_is_lock = {
		530378,
		115,
		true
	},
	guild_event_is_finish = {
		530493,
		161,
		true
	},
	guild_fleet_not_save_tip = {
		530654,
		161,
		true
	},
	guild_word_battle_area = {
		530815,
		91,
		true
	},
	guild_word_battle_type = {
		530906,
		91,
		true
	},
	guild_wrod_battle_target = {
		530997,
		99,
		true
	},
	guild_event_recomm_ship_failed = {
		531096,
		139,
		true
	},
	guild_event_start_event_tip = {
		531235,
		208,
		true
	},
	guild_word_sea = {
		531443,
		83,
		true
	},
	guild_word_score_addition = {
		531526,
		106,
		true
	},
	guild_word_effect_addition = {
		531632,
		111,
		true
	},
	guild_curr_fleet_can_not_edit = {
		531743,
		127,
		true
	},
	guild_next_edit_fleet_time = {
		531870,
		125,
		true
	},
	guild_event_info_desc1 = {
		531995,
		197,
		true
	},
	guild_event_info_desc2 = {
		532192,
		128,
		true
	},
	guild_join_member_cnt = {
		532320,
		97,
		true
	},
	guild_total_effect = {
		532417,
		99,
		true
	},
	guild_word_people = {
		532516,
		81,
		true
	},
	guild_event_info_desc3 = {
		532597,
		104,
		true
	},
	guild_not_exist_boss = {
		532701,
		112,
		true
	},
	guild_ship_from = {
		532813,
		84,
		true
	},
	guild_boss_formation_1 = {
		532897,
		160,
		true
	},
	guild_boss_formation_2 = {
		533057,
		146,
		true
	},
	guild_boss_formation_3 = {
		533203,
		123,
		true
	},
	guild_boss_cnt_no_enough = {
		533326,
		131,
		true
	},
	guild_boss_fleet_cnt_invaild = {
		533457,
		137,
		true
	},
	guild_boss_formation_not_exist_self_ship = {
		533594,
		190,
		true
	},
	guild_boss_formation_exist_event_ship = {
		533784,
		161,
		true
	},
	guild_fleet_is_legal = {
		533945,
		157,
		true
	},
	guild_battle_result_boss_is_death = {
		534102,
		134,
		true
	},
	guild_must_edit_fleet = {
		534236,
		112,
		true
	},
	guild_ship_in_battle = {
		534348,
		163,
		true
	},
	guild_ship_in_assult_fleet = {
		534511,
		134,
		true
	},
	guild_event_exist_assult_ship = {
		534645,
		157,
		true
	},
	guild_formation_erro_in_boss_battle = {
		534802,
		168,
		true
	},
	guild_get_report_failed = {
		534970,
		121,
		true
	},
	guild_report_get_all = {
		535091,
		93,
		true
	},
	guild_can_not_get_tip = {
		535184,
		158,
		true
	},
	guild_not_exist_notifycation = {
		535342,
		146,
		true
	},
	guild_exist_report_award_when_exit = {
		535488,
		172,
		true
	},
	guild_report_tooltip = {
		535660,
		243,
		true
	},
	word_guildgold = {
		535903,
		90,
		true
	},
	guild_member_rank_title_donate = {
		535993,
		107,
		true
	},
	guild_member_rank_title_finish_cnt = {
		536100,
		109,
		true
	},
	guild_member_rank_title_join_cnt = {
		536209,
		110,
		true
	},
	guild_donate_log = {
		536319,
		165,
		true
	},
	guild_supply_log = {
		536484,
		148,
		true
	},
	guild_weektask_log = {
		536632,
		148,
		true
	},
	guild_battle_log = {
		536780,
		137,
		true
	},
	guild_tech_change_log = {
		536917,
		136,
		true
	},
	guild_log_title = {
		537053,
		88,
		true
	},
	guild_use_donateitem_success = {
		537141,
		131,
		true
	},
	guild_use_battleitem_success = {
		537272,
		140,
		true
	},
	not_exist_guild_use_item = {
		537412,
		141,
		true
	},
	guild_member_tip = {
		537553,
		2773,
		true
	},
	guild_tech_tip = {
		540326,
		2740,
		true
	},
	guild_office_tip = {
		543066,
		2650,
		true
	},
	guild_event_help_tip = {
		545716,
		2687,
		true
	},
	guild_mission_info_tip = {
		548403,
		1109,
		true
	},
	guild_public_tech_tip = {
		549512,
		660,
		true
	},
	guild_public_office_tip = {
		550172,
		325,
		true
	},
	guild_tech_price_inc_tip = {
		550497,
		258,
		true
	},
	guild_boss_fleet_desc = {
		550755,
		523,
		true
	},
	guild_boss_formation_exist_invaild_ship = {
		551278,
		197,
		true
	},
	guild_exist_unreceived_supply_award = {
		551475,
		127,
		true
	},
	word_shipState_guild_event = {
		551602,
		159,
		true
	},
	word_shipState_guild_boss = {
		551761,
		193,
		true
	},
	commander_is_in_guild = {
		551954,
		195,
		true
	},
	guild_assult_ship_recommend = {
		552149,
		134,
		true
	},
	guild_cancel_assult_ship_recommend = {
		552283,
		132,
		true
	},
	guild_assult_ship_recommend_conflict = {
		552415,
		147,
		true
	},
	guild_recommend_limit = {
		552562,
		143,
		true
	},
	guild_cancel_assult_ship_recommend_conflict = {
		552705,
		169,
		true
	},
	guild_mission_complate = {
		552874,
		110,
		true
	},
	guild_operation_event_occurrence = {
		552984,
		172,
		true
	},
	guild_transfer_president_confirm = {
		553156,
		236,
		true
	},
	guild_damage_ranking = {
		553392,
		88,
		true
	},
	guild_total_damage = {
		553480,
		88,
		true
	},
	guild_donate_list_updated = {
		553568,
		142,
		true
	},
	guild_donate_list_update_failed = {
		553710,
		146,
		true
	},
	guild_tip_quit_operation = {
		553856,
		239,
		true
	},
	guild_tip_grand_fleet_is_frozen = {
		554095,
		144,
		true
	},
	guild_tip_operation_time_is_not_ample = {
		554239,
		355,
		true
	},
	guild_time_remaining_tip = {
		554594,
		104,
		true
	},
	multiple_ship_energy_low_desc = {
		554698,
		142,
		true
	},
	multiple_ship_energy_low_warn = {
		554840,
		142,
		true
	},
	multiple_ship_energy_low_warn_no_exp = {
		554982,
		282,
		true
	},
	us_error_download_painting = {
		555264,
		243,
		true
	},
	help_rollingBallGame = {
		555507,
		1116,
		true
	},
	rolling_ball_help = {
		556623,
		896,
		true
	},
	help_jiujiu_expedition_game = {
		557519,
		723,
		true
	},
	jiujiu_expedition_game_stg_desc = {
		558242,
		125,
		true
	},
	build_ship_accumulative = {
		558367,
		94,
		true
	},
	destory_ship_before_tip = {
		558461,
		98,
		true
	},
	destory_ship_input_erro = {
		558559,
		127,
		true
	},
	mail_input_erro = {
		558686,
		122,
		true
	},
	destroy_ur_rarity_tip = {
		558808,
		225,
		true
	},
	destory_ur_pt_overflowa = {
		559033,
		283,
		true
	},
	jiujiu_expedition_help = {
		559316,
		514,
		true
	},
	shop_label_unlimt_cnt = {
		559830,
		94,
		true
	},
	jiujiu_expedition_book_tip = {
		559924,
		142,
		true
	},
	jiujiu_expedition_reward_tip = {
		560066,
		140,
		true
	},
	jiujiu_expedition_amount_tip = {
		560206,
		172,
		true
	},
	jiujiu_expedition_stg_tip = {
		560378,
		133,
		true
	},
	trade_card_tips1 = {
		560511,
		85,
		true
	},
	trade_card_tips2 = {
		560596,
		273,
		true
	},
	trade_card_tips3 = {
		560869,
		278,
		true
	},
	trade_card_tips4 = {
		561147,
		93,
		true
	},
	ur_exchange_help_tip = {
		561240,
		967,
		true
	},
	fleet_antisub_range = {
		562207,
		95,
		true
	},
	fleet_antisub_range_tip = {
		562302,
		1085,
		true
	},
	practise_idol_tip = {
		563387,
		120,
		true
	},
	practise_idol_help = {
		563507,
		937,
		true
	},
	upgrade_idol_tip = {
		564444,
		153,
		true
	},
	upgrade_complete_tip = {
		564597,
		104,
		true
	},
	upgrade_introduce_tip = {
		564701,
		135,
		true
	},
	collect_idol_tip = {
		564836,
		158,
		true
	},
	hand_account_tip = {
		564994,
		125,
		true
	},
	hand_account_resetting_tip = {
		565119,
		133,
		true
	},
	help_candymagic = {
		565252,
		1060,
		true
	},
	award_overflow_tip = {
		566312,
		172,
		true
	},
	hunter_npc = {
		566484,
		1368,
		true
	},
	venusvolleyball_help = {
		567852,
		1402,
		true
	},
	venusvolleyball_rule_tip = {
		569254,
		109,
		true
	},
	venusvolleyball_return_tip = {
		569363,
		125,
		true
	},
	venusvolleyball_suspend_tip = {
		569488,
		109,
		true
	},
	doa_main = {
		569597,
		1461,
		true
	},
	doa_pt_help = {
		571058,
		841,
		true
	},
	doa_pt_complete = {
		571899,
		96,
		true
	},
	doa_pt_up = {
		571995,
		110,
		true
	},
	doa_liliang = {
		572105,
		78,
		true
	},
	doa_jiqiao = {
		572183,
		77,
		true
	},
	doa_tili = {
		572260,
		75,
		true
	},
	doa_meili = {
		572335,
		76,
		true
	},
	snowball_help = {
		572411,
		1745,
		true
	},
	help_xinnian2021_feast = {
		574156,
		533,
		true
	},
	help_xinnian2021__qiaozhong = {
		574689,
		1318,
		true
	},
	help_xinnian2021__meishiyemian = {
		576007,
		703,
		true
	},
	help_xinnian2021__meishi = {
		576710,
		1290,
		true
	},
	help_act_event = {
		578000,
		286,
		true
	},
	autofight = {
		578286,
		84,
		true
	},
	autofight_errors_tip = {
		578370,
		142,
		true
	},
	autofight_special_operation_tip = {
		578512,
		322,
		true
	},
	autofight_formation = {
		578834,
		92,
		true
	},
	autofight_cat = {
		578926,
		87,
		true
	},
	autofight_function = {
		579013,
		86,
		true
	},
	autofight_function1 = {
		579099,
		90,
		true
	},
	autofight_function2 = {
		579189,
		92,
		true
	},
	autofight_function3 = {
		579281,
		94,
		true
	},
	autofight_function4 = {
		579375,
		90,
		true
	},
	autofight_function5 = {
		579465,
		98,
		true
	},
	autofight_rewards = {
		579563,
		94,
		true
	},
	autofight_rewards_none = {
		579657,
		104,
		true
	},
	autofight_leave = {
		579761,
		83,
		true
	},
	autofight_onceagain = {
		579844,
		91,
		true
	},
	autofight_entrust = {
		579935,
		109,
		true
	},
	autofight_task = {
		580044,
		99,
		true
	},
	autofight_effect = {
		580143,
		146,
		true
	},
	autofight_file = {
		580289,
		97,
		true
	},
	autofight_discovery = {
		580386,
		112,
		true
	},
	autofight_tip_bigworld_dead = {
		580498,
		155,
		true
	},
	autofight_tip_bigworld_begin = {
		580653,
		137,
		true
	},
	autofight_tip_bigworld_stop = {
		580790,
		137,
		true
	},
	autofight_tip_bigworld_suspend = {
		580927,
		179,
		true
	},
	autofight_tip_bigworld_loop = {
		581106,
		151,
		true
	},
	autofight_farm = {
		581257,
		91,
		true
	},
	autofight_story = {
		581348,
		117,
		true
	},
	fushun_adventure_help = {
		581465,
		1320,
		true
	},
	autofight_change_tip = {
		582785,
		175,
		true
	},
	autofight_selectprops_tip = {
		582960,
		97,
		true
	},
	help_chunjie2021_feast = {
		583057,
		748,
		true
	},
	valentinesday__txt1_tip = {
		583805,
		174,
		true
	},
	valentinesday__txt2_tip = {
		583979,
		136,
		true
	},
	valentinesday__txt3_tip = {
		584115,
		141,
		true
	},
	valentinesday__txt4_tip = {
		584256,
		148,
		true
	},
	valentinesday__txt5_tip = {
		584404,
		140,
		true
	},
	valentinesday__txt6_tip = {
		584544,
		146,
		true
	},
	valentinesday__shop_tip = {
		584690,
		128,
		true
	},
	wwf_bamboo_tip1 = {
		584818,
		104,
		true
	},
	wwf_bamboo_tip2 = {
		584922,
		103,
		true
	},
	wwf_bamboo_tip3 = {
		585025,
		135,
		true
	},
	wwf_bamboo_help = {
		585160,
		1066,
		true
	},
	wwf_guide_tip = {
		586226,
		113,
		true
	},
	securitycake_help = {
		586339,
		2143,
		true
	},
	icecream_help = {
		588482,
		737,
		true
	},
	icecream_make_tip = {
		589219,
		98,
		true
	},
	query_role = {
		589317,
		86,
		true
	},
	query_role_none = {
		589403,
		87,
		true
	},
	query_role_button = {
		589490,
		94,
		true
	},
	query_role_fail = {
		589584,
		93,
		true
	},
	query_role_fail_and_retry = {
		589677,
		147,
		true
	},
	cumulative_victory_target_tip = {
		589824,
		109,
		true
	},
	cumulative_victory_now_tip = {
		589933,
		108,
		true
	},
	word_files_repair = {
		590041,
		95,
		true
	},
	repair_setting_label = {
		590136,
		98,
		true
	},
	voice_control = {
		590234,
		83,
		true
	},
	index_equip = {
		590317,
		84,
		true
	},
	index_without_limit = {
		590401,
		91,
		true
	},
	meta_learn_skill = {
		590492,
		92,
		true
	},
	world_joint_boss_not_found = {
		590584,
		148,
		true
	},
	world_joint_boss_is_death = {
		590732,
		143,
		true
	},
	world_joint_whitout_guild = {
		590875,
		123,
		true
	},
	world_joint_whitout_friend = {
		590998,
		126,
		true
	},
	world_joint_call_support_failed = {
		591124,
		126,
		true
	},
	world_joint_call_support_success = {
		591250,
		131,
		true
	},
	world_joint_call_friend_support_txt = {
		591381,
		111,
		true
	},
	world_joint_call_guild_support_txt = {
		591492,
		110,
		true
	},
	world_joint_call_world_support_txt = {
		591602,
		110,
		true
	},
	ad_4 = {
		591712,
		228,
		true
	},
	world_word_expired = {
		591940,
		94,
		true
	},
	world_word_guild_member = {
		592034,
		99,
		true
	},
	world_word_guild_player = {
		592133,
		93,
		true
	},
	world_joint_boss_award_expired = {
		592226,
		106,
		true
	},
	world_joint_not_refresh_frequently = {
		592332,
		122,
		true
	},
	world_joint_exit_battle_tip = {
		592454,
		151,
		true
	},
	world_boss_get_item = {
		592605,
		215,
		true
	},
	world_boss_ask_help = {
		592820,
		134,
		true
	},
	world_joint_count_no_enough = {
		592954,
		135,
		true
	},
	world_boss_none = {
		593089,
		133,
		true
	},
	world_boss_fleet = {
		593222,
		100,
		true
	},
	world_max_challenge_cnt = {
		593322,
		144,
		true
	},
	world_reset_success = {
		593466,
		124,
		true
	},
	world_map_dangerous_confirm = {
		593590,
		230,
		true
	},
	world_map_version = {
		593820,
		140,
		true
	},
	world_resource_fill = {
		593960,
		130,
		true
	},
	meta_sys_lock_tip = {
		594090,
		93,
		true
	},
	meta_story_lock = {
		594183,
		91,
		true
	},
	meta_acttime_limit = {
		594274,
		90,
		true
	},
	meta_pt_left = {
		594364,
		88,
		true
	},
	meta_syn_rate = {
		594452,
		86,
		true
	},
	meta_repair_rate = {
		594538,
		99,
		true
	},
	meta_story_tip_1 = {
		594637,
		92,
		true
	},
	meta_story_tip_2 = {
		594729,
		92,
		true
	},
	meta_pt_get_way = {
		594821,
		91,
		true
	},
	meta_pt_point = {
		594912,
		84,
		true
	},
	meta_award_get = {
		594996,
		85,
		true
	},
	meta_award_got = {
		595081,
		85,
		true
	},
	meta_repair = {
		595166,
		89,
		true
	},
	meta_repair_success = {
		595255,
		117,
		true
	},
	meta_repair_effect_unlock = {
		595372,
		125,
		true
	},
	meta_repair_effect_special = {
		595497,
		122,
		true
	},
	meta_energy_ship_level_need = {
		595619,
		115,
		true
	},
	meta_energy_ship_repairrate_need = {
		595734,
		125,
		true
	},
	meta_energy_active_box_tip = {
		595859,
		192,
		true
	},
	meta_break = {
		596051,
		127,
		true
	},
	meta_energy_preview_title = {
		596178,
		123,
		true
	},
	meta_energy_preview_tip = {
		596301,
		138,
		true
	},
	meta_exp_per_day = {
		596439,
		90,
		true
	},
	meta_skill_unlock = {
		596529,
		108,
		true
	},
	meta_unlock_skill_tip = {
		596637,
		160,
		true
	},
	meta_unlock_skill_select = {
		596797,
		100,
		true
	},
	meta_switch_skill_disable = {
		596897,
		138,
		true
	},
	meta_switch_skill_box_title = {
		597035,
		128,
		true
	},
	meta_cur_pt = {
		597163,
		87,
		true
	},
	meta_toast_fullexp = {
		597250,
		115,
		true
	},
	meta_toast_tactics = {
		597365,
		95,
		true
	},
	meta_skillbtn_tactics = {
		597460,
		93,
		true
	},
	meta_destroy_tip = {
		597553,
		110,
		true
	},
	meta_voice_name_feeling1 = {
		597663,
		96,
		true
	},
	meta_voice_name_feeling2 = {
		597759,
		96,
		true
	},
	meta_voice_name_feeling3 = {
		597855,
		94,
		true
	},
	meta_voice_name_feeling4 = {
		597949,
		94,
		true
	},
	meta_voice_name_feeling5 = {
		598043,
		92,
		true
	},
	meta_voice_name_propose = {
		598135,
		91,
		true
	},
	world_boss_ad = {
		598226,
		89,
		true
	},
	world_boss_drop_title = {
		598315,
		97,
		true
	},
	world_boss_pt_recove_desc = {
		598412,
		151,
		true
	},
	world_boss_progress_item_desc = {
		598563,
		462,
		true
	},
	world_joint_max_challenge_people_cnt = {
		599025,
		130,
		true
	},
	equip_ammo_type_1 = {
		599155,
		83,
		true
	},
	equip_ammo_type_2 = {
		599238,
		83,
		true
	},
	equip_ammo_type_3 = {
		599321,
		88,
		true
	},
	equip_ammo_type_4 = {
		599409,
		90,
		true
	},
	equip_ammo_type_5 = {
		599499,
		88,
		true
	},
	equip_ammo_type_6 = {
		599587,
		88,
		true
	},
	equip_ammo_type_7 = {
		599675,
		84,
		true
	},
	equip_ammo_type_8 = {
		599759,
		92,
		true
	},
	equip_ammo_type_9 = {
		599851,
		88,
		true
	},
	equip_ammo_type_10 = {
		599939,
		87,
		true
	},
	equip_ammo_type_11 = {
		600026,
		89,
		true
	},
	common_daily_limit = {
		600115,
		94,
		true
	},
	meta_help = {
		600209,
		2376,
		true
	},
	world_boss_daily_limit = {
		602585,
		118,
		true
	},
	common_go_to_analyze = {
		602703,
		92,
		true
	},
	world_boss_not_reach_target = {
		602795,
		122,
		true
	},
	special_transform_limit_reach = {
		602917,
		145,
		true
	},
	meta_pt_notenough = {
		603062,
		175,
		true
	},
	meta_boss_unlock = {
		603237,
		210,
		true
	},
	word_take_effect = {
		603447,
		91,
		true
	},
	world_boss_challenge_cnt = {
		603538,
		100,
		true
	},
	word_shipNation_meta = {
		603638,
		87,
		true
	},
	world_word_friend = {
		603725,
		89,
		true
	},
	world_word_world = {
		603814,
		86,
		true
	},
	world_word_guild = {
		603900,
		85,
		true
	},
	world_collection_1 = {
		603985,
		91,
		true
	},
	world_collection_2 = {
		604076,
		91,
		true
	},
	world_collection_3 = {
		604167,
		91,
		true
	},
	zero_hour_command_error = {
		604258,
		150,
		true
	},
	commander_is_in_bigworld = {
		604408,
		142,
		true
	},
	world_collection_back = {
		604550,
		99,
		true
	},
	archives_whether_to_retreat = {
		604649,
		199,
		true
	},
	world_fleet_stop = {
		604848,
		111,
		true
	},
	world_setting_title = {
		604959,
		108,
		true
	},
	world_setting_quickmode = {
		605067,
		106,
		true
	},
	world_setting_quickmodetip = {
		605173,
		134,
		true
	},
	world_setting_submititem = {
		605307,
		121,
		true
	},
	world_setting_submititemtip = {
		605428,
		332,
		true
	},
	world_setting_mapauto = {
		605760,
		122,
		true
	},
	world_setting_mapautotip = {
		605882,
		171,
		true
	},
	world_boss_maintenance = {
		606053,
		167,
		true
	},
	world_boss_inbattle = {
		606220,
		147,
		true
	},
	world_automode_title_1 = {
		606367,
		103,
		true
	},
	world_automode_title_2 = {
		606470,
		86,
		true
	},
	world_automode_treasure_1 = {
		606556,
		137,
		true
	},
	world_automode_treasure_2 = {
		606693,
		132,
		true
	},
	world_automode_treasure_3 = {
		606825,
		136,
		true
	},
	world_automode_cancel = {
		606961,
		91,
		true
	},
	world_automode_confirm = {
		607052,
		93,
		true
	},
	world_automode_start_tip1 = {
		607145,
		122,
		true
	},
	world_automode_start_tip2 = {
		607267,
		105,
		true
	},
	world_automode_start_tip3 = {
		607372,
		124,
		true
	},
	world_automode_start_tip4 = {
		607496,
		115,
		true
	},
	world_automode_start_tip5 = {
		607611,
		164,
		true
	},
	world_automode_setting_1 = {
		607775,
		119,
		true
	},
	world_automode_setting_1_1 = {
		607894,
		101,
		true
	},
	world_automode_setting_1_2 = {
		607995,
		91,
		true
	},
	world_automode_setting_1_3 = {
		608086,
		91,
		true
	},
	world_automode_setting_1_4 = {
		608177,
		99,
		true
	},
	world_automode_setting_2 = {
		608276,
		137,
		true
	},
	world_automode_setting_2_1 = {
		608413,
		106,
		true
	},
	world_automode_setting_2_2 = {
		608519,
		109,
		true
	},
	world_automode_setting_all_1 = {
		608628,
		135,
		true
	},
	world_automode_setting_all_1_1 = {
		608763,
		115,
		true
	},
	world_automode_setting_all_1_2 = {
		608878,
		119,
		true
	},
	world_automode_setting_all_2 = {
		608997,
		139,
		true
	},
	world_automode_setting_all_2_1 = {
		609136,
		99,
		true
	},
	world_automode_setting_all_2_2 = {
		609235,
		115,
		true
	},
	world_automode_setting_all_2_3 = {
		609350,
		115,
		true
	},
	world_automode_setting_all_3 = {
		609465,
		121,
		true
	},
	world_automode_setting_all_3_1 = {
		609586,
		96,
		true
	},
	world_automode_setting_all_3_2 = {
		609682,
		97,
		true
	},
	world_automode_setting_all_4 = {
		609779,
		135,
		true
	},
	world_automode_setting_all_4_1 = {
		609914,
		97,
		true
	},
	world_automode_setting_all_4_2 = {
		610011,
		96,
		true
	},
	world_automode_setting_new_1 = {
		610107,
		122,
		true
	},
	world_automode_setting_new_1_1 = {
		610229,
		105,
		true
	},
	world_automode_setting_new_1_2 = {
		610334,
		95,
		true
	},
	world_automode_setting_new_1_3 = {
		610429,
		95,
		true
	},
	world_automode_setting_new_1_4 = {
		610524,
		95,
		true
	},
	world_automode_setting_new_1_5 = {
		610619,
		97,
		true
	},
	world_collection_task_tip_1 = {
		610716,
		147,
		true
	},
	area_putong = {
		610863,
		85,
		true
	},
	area_anquan = {
		610948,
		82,
		true
	},
	area_yaosai = {
		611030,
		85,
		true
	},
	area_yaosai_2 = {
		611115,
		96,
		true
	},
	area_shenyuan = {
		611211,
		84,
		true
	},
	area_yinmi = {
		611295,
		80,
		true
	},
	area_renwu = {
		611375,
		81,
		true
	},
	area_zhuxian = {
		611456,
		84,
		true
	},
	area_dangan = {
		611540,
		85,
		true
	},
	charge_trade_no_error = {
		611625,
		122,
		true
	},
	world_reset_1 = {
		611747,
		136,
		true
	},
	world_reset_2 = {
		611883,
		138,
		true
	},
	world_reset_3 = {
		612021,
		111,
		true
	},
	guild_is_frozen_when_start_tech = {
		612132,
		126,
		true
	},
	world_boss_unactivated = {
		612258,
		155,
		true
	},
	world_reset_tip = {
		612413,
		2719,
		true
	},
	spring_invited_2021 = {
		615132,
		231,
		true
	},
	charge_error_count_limit = {
		615363,
		128,
		true
	},
	charge_error_disable = {
		615491,
		144,
		true
	},
	levelScene_select_sp = {
		615635,
		138,
		true
	},
	word_adjustFleet = {
		615773,
		86,
		true
	},
	levelScene_select_noitem = {
		615859,
		112,
		true
	},
	story_setting_label = {
		615971,
		105,
		true
	},
	login_arrears_tips = {
		616076,
		208,
		true
	},
	Supplement_pay1 = {
		616284,
		211,
		true
	},
	Supplement_pay2 = {
		616495,
		231,
		true
	},
	Supplement_pay3 = {
		616726,
		209,
		true
	},
	Supplement_pay4 = {
		616935,
		86,
		true
	},
	world_ship_repair = {
		617021,
		102,
		true
	},
	Supplement_pay5 = {
		617123,
		185,
		true
	},
	area_unkown = {
		617308,
		89,
		true
	},
	Supplement_pay6 = {
		617397,
		89,
		true
	},
	Supplement_pay7 = {
		617486,
		88,
		true
	},
	Supplement_pay8 = {
		617574,
		86,
		true
	},
	world_battle_damage = {
		617660,
		217,
		true
	},
	setting_story_speed_1 = {
		617877,
		89,
		true
	},
	setting_story_speed_2 = {
		617966,
		91,
		true
	},
	setting_story_speed_3 = {
		618057,
		89,
		true
	},
	setting_story_speed_4 = {
		618146,
		94,
		true
	},
	story_autoplay_setting_label = {
		618240,
		106,
		true
	},
	story_autoplay_setting_1 = {
		618346,
		92,
		true
	},
	story_autoplay_setting_2 = {
		618438,
		95,
		true
	},
	meta_shop_exchange_limit = {
		618533,
		98,
		true
	},
	meta_shop_unexchange_label = {
		618631,
		90,
		true
	},
	daily_level_quick_battle_label2 = {
		618721,
		101,
		true
	},
	daily_level_quick_battle_label1 = {
		618822,
		109,
		true
	},
	dailyLevel_quickfinish = {
		618931,
		329,
		true
	},
	daily_level_quick_battle_label3 = {
		619260,
		108,
		true
	},
	backyard_longpress_ship_tip = {
		619368,
		160,
		true
	},
	common_npc_formation_tip = {
		619528,
		126,
		true
	},
	gametip_xiaotiancheng = {
		619654,
		1319,
		true
	},
	guild_task_autoaccept_1 = {
		620973,
		128,
		true
	},
	guild_task_autoaccept_2 = {
		621101,
		135,
		true
	},
	task_lock = {
		621236,
		93,
		true
	},
	week_task_pt_name = {
		621329,
		96,
		true
	},
	week_task_award_preview_label = {
		621425,
		100,
		true
	},
	week_task_title_label = {
		621525,
		108,
		true
	},
	cattery_op_clean_success = {
		621633,
		122,
		true
	},
	cattery_op_feed_success = {
		621755,
		114,
		true
	},
	cattery_op_play_success = {
		621869,
		122,
		true
	},
	cattery_style_change_success = {
		621991,
		130,
		true
	},
	cattery_add_commander_success = {
		622121,
		110,
		true
	},
	cattery_remove_commander_success = {
		622231,
		115,
		true
	},
	commander_box_quickly_tool_tip_1 = {
		622346,
		152,
		true
	},
	commander_box_quickly_tool_tip_2 = {
		622498,
		147,
		true
	},
	commander_box_quickly_tool_tip_3 = {
		622645,
		123,
		true
	},
	commander_box_was_finished = {
		622768,
		119,
		true
	},
	comander_tool_cnt_is_reclac = {
		622887,
		151,
		true
	},
	comander_tool_max_cnt = {
		623038,
		93,
		true
	},
	commander_op_play_level = {
		623131,
		101,
		true
	},
	commander_op_feed_level = {
		623232,
		101,
		true
	},
	cat_home_help = {
		623333,
		1398,
		true
	},
	cat_accelfrate_notenough = {
		624731,
		136,
		true
	},
	cat_home_unlock = {
		624867,
		131,
		true
	},
	cat_sleep_notplay = {
		624998,
		140,
		true
	},
	cathome_style_unlock = {
		625138,
		142,
		true
	},
	commander_is_in_cattery = {
		625280,
		122,
		true
	},
	cat_home_interaction = {
		625402,
		133,
		true
	},
	cat_accelerate_left = {
		625535,
		96,
		true
	},
	common_clean = {
		625631,
		81,
		true
	},
	common_feed = {
		625712,
		79,
		true
	},
	common_play = {
		625791,
		79,
		true
	},
	game_stopwords = {
		625870,
		107,
		true
	},
	game_openwords = {
		625977,
		110,
		true
	},
	amusementpark_shop_enter = {
		626087,
		143,
		true
	},
	amusementpark_shop_exchange = {
		626230,
		189,
		true
	},
	amusementpark_shop_success = {
		626419,
		107,
		true
	},
	amusementpark_shop_special = {
		626526,
		149,
		true
	},
	amusementpark_shop_end = {
		626675,
		116,
		true
	},
	amusementpark_shop_0 = {
		626791,
		176,
		true
	},
	amusementpark_shop_carousel1 = {
		626967,
		152,
		true
	},
	amusementpark_shop_carousel2 = {
		627119,
		151,
		true
	},
	amusementpark_shop_carousel3 = {
		627270,
		153,
		true
	},
	amusementpark_shop_exchange2 = {
		627423,
		196,
		true
	},
	amusementpark_help = {
		627619,
		1927,
		true
	},
	amusementpark_shop_help = {
		629546,
		465,
		true
	},
	handshake_game_help = {
		630011,
		915,
		true
	},
	MeixiV4_help = {
		630926,
		908,
		true
	},
	activity_permanent_total = {
		631834,
		107,
		true
	},
	word_investigate = {
		631941,
		86,
		true
	},
	ambush_display_none = {
		632027,
		88,
		true
	},
	activity_permanent_help = {
		632115,
		502,
		true
	},
	activity_permanent_tips1 = {
		632617,
		171,
		true
	},
	activity_permanent_tips2 = {
		632788,
		175,
		true
	},
	activity_permanent_tips3 = {
		632963,
		155,
		true
	},
	activity_permanent_tips4 = {
		633118,
		199,
		true
	},
	activity_permanent_finished = {
		633317,
		100,
		true
	},
	idolmaster_main = {
		633417,
		1190,
		true
	},
	idolmaster_game_tip1 = {
		634607,
		118,
		true
	},
	idolmaster_game_tip2 = {
		634725,
		116,
		true
	},
	idolmaster_game_tip3 = {
		634841,
		97,
		true
	},
	idolmaster_game_tip4 = {
		634938,
		94,
		true
	},
	idolmaster_game_tip5 = {
		635032,
		89,
		true
	},
	idolmaster_collection = {
		635121,
		631,
		true
	},
	idolmaster_voice_name_feeling1 = {
		635752,
		107,
		true
	},
	idolmaster_voice_name_feeling2 = {
		635859,
		102,
		true
	},
	idolmaster_voice_name_feeling3 = {
		635961,
		101,
		true
	},
	idolmaster_voice_name_feeling4 = {
		636062,
		104,
		true
	},
	idolmaster_voice_name_feeling5 = {
		636166,
		102,
		true
	},
	idolmaster_voice_name_propose = {
		636268,
		98,
		true
	},
	cartoon_all = {
		636366,
		78,
		true
	},
	cartoon_notall = {
		636444,
		84,
		true
	},
	cartoon_haveno = {
		636528,
		111,
		true
	},
	res_cartoon_new_tip = {
		636639,
		108,
		true
	},
	memory_actiivty_ex = {
		636747,
		87,
		true
	},
	memory_activity_sp = {
		636834,
		89,
		true
	},
	memory_activity_daily = {
		636923,
		89,
		true
	},
	memory_activity_others = {
		637012,
		90,
		true
	},
	battle_end_title = {
		637102,
		94,
		true
	},
	battle_end_subtitle1 = {
		637196,
		91,
		true
	},
	battle_end_subtitle2 = {
		637287,
		101,
		true
	},
	meta_skill_dailyexp = {
		637388,
		92,
		true
	},
	meta_skill_learn = {
		637480,
		127,
		true
	},
	meta_skill_maxtip = {
		637607,
		203,
		true
	},
	meta_tactics_detail = {
		637810,
		90,
		true
	},
	meta_tactics_unlock = {
		637900,
		91,
		true
	},
	meta_tactics_switch = {
		637991,
		91,
		true
	},
	meta_skill_maxtip2 = {
		638082,
		91,
		true
	},
	activity_permanent_progress = {
		638173,
		100,
		true
	},
	cattery_settlement_dialogue_1 = {
		638273,
		116,
		true
	},
	cattery_settlement_dialogue_2 = {
		638389,
		131,
		true
	},
	cattery_settlement_dialogue_3 = {
		638520,
		115,
		true
	},
	cattery_settlement_dialogue_4 = {
		638635,
		102,
		true
	},
	blueprint_catchup_by_gold_confirm = {
		638737,
		153,
		true
	},
	blueprint_catchup_by_gold_help = {
		638890,
		318,
		true
	},
	tec_tip_no_consumption = {
		639208,
		90,
		true
	},
	tec_tip_material_stock = {
		639298,
		91,
		true
	},
	tec_tip_to_consumption = {
		639389,
		91,
		true
	},
	onebutton_max_tip = {
		639480,
		96,
		true
	},
	target_get_tip = {
		639576,
		89,
		true
	},
	fleet_select_title = {
		639665,
		94,
		true
	},
	backyard_rename_title = {
		639759,
		96,
		true
	},
	backyard_rename_tip = {
		639855,
		105,
		true
	},
	equip_add = {
		639960,
		99,
		true
	},
	equipskin_add = {
		640059,
		108,
		true
	},
	equipskin_none = {
		640167,
		109,
		true
	},
	equipskin_typewrong = {
		640276,
		117,
		true
	},
	equipskin_typewrong_en = {
		640393,
		108,
		true
	},
	user_is_banned = {
		640501,
		134,
		true
	},
	user_is_forever_banned = {
		640635,
		116,
		true
	},
	old_class_is_close = {
		640751,
		144,
		true
	},
	activity_event_building = {
		640895,
		1210,
		true
	},
	salvage_tips = {
		642105,
		1124,
		true
	},
	tips_shakebeads = {
		643229,
		1036,
		true
	},
	gem_shop_xinzhi_tip = {
		644265,
		113,
		true
	},
	cowboy_tips = {
		644378,
		708,
		true
	},
	backyard_backyardScene_Disable_Rotation = {
		645086,
		137,
		true
	},
	chazi_tips = {
		645223,
		886,
		true
	},
	catchteasure_help = {
		646109,
		453,
		true
	},
	unlock_tips = {
		646562,
		93,
		true
	},
	class_label_tran = {
		646655,
		87,
		true
	},
	class_label_gen = {
		646742,
		88,
		true
	},
	class_attr_store = {
		646830,
		89,
		true
	},
	class_attr_proficiency = {
		646919,
		103,
		true
	},
	class_attr_getproficiency = {
		647022,
		105,
		true
	},
	class_attr_costproficiency = {
		647127,
		104,
		true
	},
	class_label_upgrading = {
		647231,
		94,
		true
	},
	class_label_upgradetime = {
		647325,
		99,
		true
	},
	class_label_oilfield = {
		647424,
		98,
		true
	},
	class_label_goldfield = {
		647522,
		100,
		true
	},
	class_res_maxlevel_tip = {
		647622,
		95,
		true
	},
	ship_exp_item_title = {
		647717,
		93,
		true
	},
	ship_exp_item_label_clear = {
		647810,
		94,
		true
	},
	ship_exp_item_label_recom = {
		647904,
		93,
		true
	},
	ship_exp_item_label_confirm = {
		647997,
		98,
		true
	},
	player_expResource_mail_fullBag = {
		648095,
		200,
		true
	},
	player_expResource_mail_overflow = {
		648295,
		195,
		true
	},
	tec_nation_award_finish = {
		648490,
		98,
		true
	},
	coures_exp_overflow_tip = {
		648588,
		202,
		true
	},
	coures_exp_npc_tip = {
		648790,
		221,
		true
	},
	coures_level_tip = {
		649011,
		162,
		true
	},
	coures_tip_material_stock = {
		649173,
		94,
		true
	},
	coures_tip_exceeded_lv = {
		649267,
		123,
		true
	},
	eatgame_tips = {
		649390,
		844,
		true
	},
	breakout_tip_ultimatebonus_gunner = {
		650234,
		145,
		true
	},
	breakout_tip_ultimatebonus_torpedo = {
		650379,
		130,
		true
	},
	breakout_tip_ultimatebonus_aux = {
		650509,
		133,
		true
	},
	map_event_lighthouse_tip_1 = {
		650642,
		161,
		true
	},
	battlepass_main_tip_2110 = {
		650803,
		202,
		true
	},
	battlepass_main_time = {
		651005,
		94,
		true
	},
	battlepass_main_help_2110 = {
		651099,
		2880,
		true
	},
	cruise_task_help_2110 = {
		653979,
		1094,
		true
	},
	cruise_task_phase = {
		655073,
		106,
		true
	},
	cruise_task_tips = {
		655179,
		89,
		true
	},
	battlepass_task_quickfinish1 = {
		655268,
		231,
		true
	},
	battlepass_task_quickfinish2 = {
		655499,
		224,
		true
	},
	battlepass_task_quickfinish3 = {
		655723,
		102,
		true
	},
	cruise_task_unlock = {
		655825,
		107,
		true
	},
	cruise_task_week = {
		655932,
		87,
		true
	},
	battlepass_pay_timelimit = {
		656019,
		101,
		true
	},
	battlepass_pay_acquire = {
		656120,
		101,
		true
	},
	battlepass_pay_attention = {
		656221,
		159,
		true
	},
	battlepass_acquire_attention = {
		656380,
		189,
		true
	},
	battlepass_pay_tip = {
		656569,
		121,
		true
	},
	battlepass_main_tip1 = {
		656690,
		226,
		true
	},
	battlepass_main_tip2 = {
		656916,
		209,
		true
	},
	battlepass_main_tip3 = {
		657125,
		215,
		true
	},
	battlepass_complete = {
		657340,
		121,
		true
	},
	shop_free_tag = {
		657461,
		81,
		true
	},
	quick_equip_tip1 = {
		657542,
		86,
		true
	},
	quick_equip_tip2 = {
		657628,
		86,
		true
	},
	quick_equip_tip3 = {
		657714,
		85,
		true
	},
	quick_equip_tip4 = {
		657799,
		97,
		true
	},
	quick_equip_tip5 = {
		657896,
		127,
		true
	},
	quick_equip_tip6 = {
		658023,
		184,
		true
	},
	retire_importantequipment_tips = {
		658207,
		179,
		true
	},
	settle_rewards_title = {
		658386,
		109,
		true
	},
	settle_rewards_subtitle = {
		658495,
		101,
		true
	},
	total_rewards_subtitle = {
		658596,
		99,
		true
	},
	settle_rewards_text = {
		658695,
		99,
		true
	},
	use_oil_limit_help = {
		658794,
		243,
		true
	},
	formationScene_use_oil_limit_tip = {
		659037,
		107,
		true
	},
	index_awakening2 = {
		659144,
		93,
		true
	},
	index_upgrade = {
		659237,
		91,
		true
	},
	formationScene_use_oil_limit_enemy = {
		659328,
		104,
		true
	},
	formationScene_use_oil_limit_flagship = {
		659432,
		109,
		true
	},
	formationScene_use_oil_limit_submarine = {
		659541,
		104,
		true
	},
	formationScene_use_oil_limit_surface = {
		659645,
		107,
		true
	},
	formationScene_use_oil_limit_tip_worldboss = {
		659752,
		117,
		true
	},
	attr_durability = {
		659869,
		81,
		true
	},
	attr_armor = {
		659950,
		79,
		true
	},
	attr_reload = {
		660029,
		78,
		true
	},
	attr_cannon = {
		660107,
		77,
		true
	},
	attr_torpedo = {
		660184,
		79,
		true
	},
	attr_motion = {
		660263,
		78,
		true
	},
	attr_antiaircraft = {
		660341,
		83,
		true
	},
	attr_air = {
		660424,
		75,
		true
	},
	attr_hit = {
		660499,
		75,
		true
	},
	attr_antisub = {
		660574,
		79,
		true
	},
	attr_oxy_max = {
		660653,
		79,
		true
	},
	attr_ammo = {
		660732,
		76,
		true
	},
	attr_hunting_range = {
		660808,
		85,
		true
	},
	attr_luck = {
		660893,
		76,
		true
	},
	attr_consume = {
		660969,
		80,
		true
	},
	attr_speed = {
		661049,
		77,
		true
	},
	monthly_card_tip = {
		661126,
		80,
		true
	},
	shopping_error_time_limit = {
		661206,
		138,
		true
	},
	world_total_power = {
		661344,
		86,
		true
	},
	world_mileage = {
		661430,
		91,
		true
	},
	world_pressing = {
		661521,
		91,
		true
	},
	Settings_title_FPS = {
		661612,
		101,
		true
	},
	Settings_title_Notification = {
		661713,
		109,
		true
	},
	Settings_title_Other = {
		661822,
		97,
		true
	},
	Settings_title_LoginJP = {
		661919,
		99,
		true
	},
	Settings_title_Redeem = {
		662018,
		94,
		true
	},
	Settings_title_AdjustScr = {
		662112,
		101,
		true
	},
	Settings_title_Secpw = {
		662213,
		98,
		true
	},
	Settings_title_Secpwlimop = {
		662311,
		110,
		true
	},
	Settings_title_agreement = {
		662421,
		100,
		true
	},
	Settings_title_sound = {
		662521,
		98,
		true
	},
	Settings_title_resUpdate = {
		662619,
		103,
		true
	},
	Settings_title_resManage = {
		662722,
		101,
		true
	},
	Settings_title_resManage_All = {
		662823,
		109,
		true
	},
	Settings_title_resManage_Main = {
		662932,
		111,
		true
	},
	Settings_title_resManage_Sub = {
		663043,
		111,
		true
	},
	equipment_info_change_tip = {
		663154,
		138,
		true
	},
	equipment_info_change_name_a = {
		663292,
		126,
		true
	},
	equipment_info_change_name_b = {
		663418,
		126,
		true
	},
	equipment_info_change_text_before = {
		663544,
		103,
		true
	},
	equipment_info_change_text_after = {
		663647,
		101,
		true
	},
	equipment_info_change_strengthen = {
		663748,
		277,
		true
	},
	world_boss_progress_tip_title = {
		664025,
		122,
		true
	},
	world_boss_progress_tip_desc = {
		664147,
		354,
		true
	},
	ssss_main_help = {
		664501,
		1932,
		true
	},
	mini_game_time = {
		666433,
		88,
		true
	},
	mini_game_score = {
		666521,
		85,
		true
	},
	mini_game_leave = {
		666606,
		93,
		true
	},
	mini_game_pause = {
		666699,
		96,
		true
	},
	mini_game_cur_score = {
		666795,
		97,
		true
	},
	mini_game_high_score = {
		666892,
		95,
		true
	},
	monopoly_world_tip1 = {
		666987,
		96,
		true
	},
	monopoly_world_tip2 = {
		667083,
		237,
		true
	},
	monopoly_world_tip3 = {
		667320,
		212,
		true
	},
	help_monopoly_world = {
		667532,
		1414,
		true
	},
	ssssmedal_tip = {
		668946,
		142,
		true
	},
	ssssmedal_name = {
		669088,
		107,
		true
	},
	ssssmedal_belonging = {
		669195,
		112,
		true
	},
	ssssmedal_name1 = {
		669307,
		108,
		true
	},
	ssssmedal_name2 = {
		669415,
		105,
		true
	},
	ssssmedal_name3 = {
		669520,
		107,
		true
	},
	ssssmedal_name4 = {
		669627,
		109,
		true
	},
	ssssmedal_name5 = {
		669736,
		109,
		true
	},
	ssssmedal_name6 = {
		669845,
		85,
		true
	},
	ssssmedal_belonging1 = {
		669930,
		92,
		true
	},
	ssssmedal_belonging2 = {
		670022,
		99,
		true
	},
	ssssmedal_desc1 = {
		670121,
		168,
		true
	},
	ssssmedal_desc2 = {
		670289,
		158,
		true
	},
	ssssmedal_desc3 = {
		670447,
		168,
		true
	},
	ssssmedal_desc4 = {
		670615,
		155,
		true
	},
	ssssmedal_desc5 = {
		670770,
		180,
		true
	},
	ssssmedal_desc6 = {
		670950,
		131,
		true
	},
	show_fate_demand_count = {
		671081,
		163,
		true
	},
	show_design_demand_count = {
		671244,
		158,
		true
	},
	blueprint_select_overflow = {
		671402,
		124,
		true
	},
	blueprint_select_overflow_tip = {
		671526,
		188,
		true
	},
	blueprint_exchange_empty_tip = {
		671714,
		131,
		true
	},
	blueprint_exchange_select_display = {
		671845,
		128,
		true
	},
	build_rate_title = {
		671973,
		91,
		true
	},
	build_pools_intro = {
		672064,
		116,
		true
	},
	build_detail_intro = {
		672180,
		106,
		true
	},
	ssss_game_tip = {
		672286,
		1498,
		true
	},
	ssss_medal_tip = {
		673784,
		401,
		true
	},
	battlepass_main_tip_2112 = {
		674185,
		233,
		true
	},
	battlepass_main_help_2112 = {
		674418,
		2887,
		true
	},
	cruise_task_help_2112 = {
		677305,
		1085,
		true
	},
	littleSanDiego_npc = {
		678390,
		1223,
		true
	},
	tag_ship_unlocked = {
		679613,
		95,
		true
	},
	tag_ship_locked = {
		679708,
		91,
		true
	},
	acceleration_tips_1 = {
		679799,
		203,
		true
	},
	acceleration_tips_2 = {
		680002,
		228,
		true
	},
	noacceleration_tips = {
		680230,
		119,
		true
	},
	word_shipskin = {
		680349,
		84,
		true
	},
	settings_sound_title_bgm = {
		680433,
		99,
		true
	},
	settings_sound_title_effct = {
		680532,
		101,
		true
	},
	settings_sound_title_cv = {
		680633,
		100,
		true
	},
	setting_resdownload_title_gallery = {
		680733,
		111,
		true
	},
	setting_resdownload_title_live2d = {
		680844,
		109,
		true
	},
	setting_resdownload_title_music = {
		680953,
		105,
		true
	},
	setting_resdownload_title_sound = {
		681058,
		108,
		true
	},
	setting_resdownload_title_manga = {
		681166,
		108,
		true
	},
	setting_resdownload_title_dorm = {
		681274,
		115,
		true
	},
	setting_resdownload_title_main_group = {
		681389,
		117,
		true
	},
	setting_resdownload_title_map = {
		681506,
		113,
		true
	},
	settings_battle_title = {
		681619,
		103,
		true
	},
	settings_battle_tip = {
		681722,
		144,
		true
	},
	settings_battle_Btn_edit = {
		681866,
		92,
		true
	},
	settings_battle_Btn_reset = {
		681958,
		96,
		true
	},
	settings_battle_Btn_save = {
		682054,
		92,
		true
	},
	settings_battle_Btn_cancel = {
		682146,
		96,
		true
	},
	settings_pwd_label_close = {
		682242,
		92,
		true
	},
	settings_pwd_label_open = {
		682334,
		94,
		true
	},
	word_frame = {
		682428,
		78,
		true
	},
	Settings_title_Redeem_input_label = {
		682506,
		109,
		true
	},
	Settings_title_Redeem_input_submit = {
		682615,
		104,
		true
	},
	Settings_title_Redeem_input_placeholder = {
		682719,
		140,
		true
	},
	CurlingGame_tips1 = {
		682859,
		1084,
		true
	},
	maid_task_tips1 = {
		683943,
		1030,
		true
	},
	shop_akashi_pick_title = {
		684973,
		103,
		true
	},
	shop_diamond_title = {
		685076,
		86,
		true
	},
	shop_gift_title = {
		685162,
		84,
		true
	},
	shop_item_title = {
		685246,
		84,
		true
	},
	shop_charge_level_limit = {
		685330,
		102,
		true
	},
	backhill_cantupbuilding = {
		685432,
		135,
		true
	},
	pray_cant_tips = {
		685567,
		107,
		true
	},
	help_xinnian2022_feast = {
		685674,
		2200,
		true
	},
	Pray_activity_tips1 = {
		687874,
		1574,
		true
	},
	backhill_notenoughbuilding = {
		689448,
		184,
		true
	},
	help_xinnian2022_z28 = {
		689632,
		766,
		true
	},
	help_xinnian2022_firework = {
		690398,
		1156,
		true
	},
	settings_title_account_del = {
		691554,
		97,
		true
	},
	settings_text_account_del = {
		691651,
		105,
		true
	},
	settings_text_account_del_desc = {
		691756,
		290,
		true
	},
	settings_text_account_del_confirm = {
		692046,
		150,
		true
	},
	settings_text_account_del_btn = {
		692196,
		99,
		true
	},
	box_account_del_input = {
		692295,
		142,
		true
	},
	box_account_del_target = {
		692437,
		92,
		true
	},
	box_account_del_click = {
		692529,
		100,
		true
	},
	box_account_del_success_content = {
		692629,
		131,
		true
	},
	box_account_reborn_content = {
		692760,
		211,
		true
	},
	tip_account_del_dismatch = {
		692971,
		120,
		true
	},
	tip_account_del_reborn = {
		693091,
		135,
		true
	},
	player_manifesto_placeholder = {
		693226,
		110,
		true
	},
	box_ship_del_click = {
		693336,
		95,
		true
	},
	box_equipment_del_click = {
		693431,
		100,
		true
	},
	change_player_name_title = {
		693531,
		103,
		true
	},
	change_player_name_subtitle = {
		693634,
		111,
		true
	},
	change_player_name_input_tip = {
		693745,
		112,
		true
	},
	change_player_name_illegal = {
		693857,
		241,
		true
	},
	nodisplay_player_home_name = {
		694098,
		94,
		true
	},
	nodisplay_player_home_share = {
		694192,
		97,
		true
	},
	tactics_class_start = {
		694289,
		88,
		true
	},
	tactics_class_cancel = {
		694377,
		90,
		true
	},
	tactics_class_get_exp = {
		694467,
		94,
		true
	},
	tactics_class_spend_time = {
		694561,
		99,
		true
	},
	build_ticket_description = {
		694660,
		118,
		true
	},
	build_ticket_expire_warning = {
		694778,
		103,
		true
	},
	tip_build_ticket_expired = {
		694881,
		135,
		true
	},
	tip_build_ticket_exchange_expired = {
		695016,
		174,
		true
	},
	tip_build_ticket_not_enough = {
		695190,
		107,
		true
	},
	build_ship_tip_use_ticket = {
		695297,
		195,
		true
	},
	springfes_tips1 = {
		695492,
		907,
		true
	},
	worldinpicture_tavel_point_tip = {
		696399,
		126,
		true
	},
	worldinpicture_draw_point_tip = {
		696525,
		122,
		true
	},
	worldinpicture_help = {
		696647,
		1037,
		true
	},
	worldinpicture_task_help = {
		697684,
		1042,
		true
	},
	worldinpicture_not_area_can_draw = {
		698726,
		135,
		true
	},
	missile_attack_area_confirm = {
		698861,
		104,
		true
	},
	missile_attack_area_cancel = {
		698965,
		103,
		true
	},
	shipchange_alert_infleet = {
		699068,
		157,
		true
	},
	shipchange_alert_inpvp = {
		699225,
		168,
		true
	},
	shipchange_alert_inexercise = {
		699393,
		174,
		true
	},
	shipchange_alert_inworld = {
		699567,
		168,
		true
	},
	shipchange_alert_inguildbossevent = {
		699735,
		177,
		true
	},
	shipchange_alert_indiff = {
		699912,
		156,
		true
	},
	shipmodechange_reject_1stfleet_only = {
		700068,
		210,
		true
	},
	shipmodechange_reject_worldfleet_only = {
		700278,
		215,
		true
	},
	monopoly3thre_tip = {
		700493,
		151,
		true
	},
	fushun_game3_tip = {
		700644,
		1291,
		true
	},
	battlepass_main_tip_2202 = {
		701935,
		197,
		true
	},
	battlepass_main_help_2202 = {
		702132,
		2890,
		true
	},
	cruise_task_help_2202 = {
		705022,
		1092,
		true
	},
	battlepass_main_tip_2204 = {
		706114,
		200,
		true
	},
	battlepass_main_help_2204 = {
		706314,
		2881,
		true
	},
	cruise_task_help_2204 = {
		709195,
		1092,
		true
	},
	battlepass_main_tip_2206 = {
		710287,
		200,
		true
	},
	battlepass_main_help_2206 = {
		710487,
		2889,
		true
	},
	cruise_task_help_2206 = {
		713376,
		1092,
		true
	},
	battlepass_main_tip_2208 = {
		714468,
		199,
		true
	},
	battlepass_main_help_2208 = {
		714667,
		2893,
		true
	},
	cruise_task_help_2208 = {
		717560,
		1092,
		true
	},
	battlepass_main_tip_2210 = {
		718652,
		201,
		true
	},
	battlepass_main_help_2210 = {
		718853,
		2893,
		true
	},
	cruise_task_help_2210 = {
		721746,
		1092,
		true
	},
	battlepass_main_tip_2212 = {
		722838,
		224,
		true
	},
	battlepass_main_help_2212 = {
		723062,
		2900,
		true
	},
	cruise_task_help_2212 = {
		725962,
		1092,
		true
	},
	battlepass_main_tip_2302 = {
		727054,
		225,
		true
	},
	battlepass_main_help_2302 = {
		727279,
		2895,
		true
	},
	cruise_task_help_2302 = {
		730174,
		1092,
		true
	},
	battlepass_main_tip_2304 = {
		731266,
		233,
		true
	},
	battlepass_main_help_2304 = {
		731499,
		2913,
		true
	},
	cruise_task_help_2304 = {
		734412,
		1092,
		true
	},
	battlepass_main_tip_2306 = {
		735504,
		195,
		true
	},
	battlepass_main_help_2306 = {
		735699,
		2883,
		true
	},
	cruise_task_help_2306 = {
		738582,
		1092,
		true
	},
	battlepass_main_tip_2308 = {
		739674,
		197,
		true
	},
	battlepass_main_help_2308 = {
		739871,
		2885,
		true
	},
	cruise_task_help_2308 = {
		742756,
		1092,
		true
	},
	battlepass_main_tip_2310 = {
		743848,
		200,
		true
	},
	battlepass_main_help_2310 = {
		744048,
		2893,
		true
	},
	cruise_task_help_2310 = {
		746941,
		1092,
		true
	},
	battlepass_main_tip_2312 = {
		748033,
		196,
		true
	},
	battlepass_main_help_2312 = {
		748229,
		2898,
		true
	},
	cruise_task_help_2312 = {
		751127,
		1092,
		true
	},
	battlepass_main_tip_2402 = {
		752219,
		197,
		true
	},
	battlepass_main_help_2402 = {
		752416,
		2891,
		true
	},
	cruise_task_help_2402 = {
		755307,
		1092,
		true
	},
	battlepass_main_tip_2404 = {
		756399,
		223,
		true
	},
	battlepass_main_help_2404 = {
		756622,
		2901,
		true
	},
	cruise_task_help_2404 = {
		759523,
		1096,
		true
	},
	battlepass_main_tip_2406 = {
		760619,
		197,
		true
	},
	battlepass_main_help_2406 = {
		760816,
		2899,
		true
	},
	cruise_task_help_2406 = {
		763715,
		1092,
		true
	},
	battlepass_main_tip_2408 = {
		764807,
		222,
		true
	},
	battlepass_main_help_2408 = {
		765029,
		2898,
		true
	},
	cruise_task_help_2408 = {
		767927,
		1092,
		true
	},
	battlepass_main_tip_2410 = {
		769019,
		273,
		true
	},
	battlepass_main_help_2410 = {
		769292,
		2901,
		true
	},
	cruise_task_help_2410 = {
		772193,
		1092,
		true
	},
	battlepass_main_tip_2412 = {
		773285,
		230,
		true
	},
	battlepass_main_help_2412 = {
		773515,
		2895,
		true
	},
	cruise_task_help_2412 = {
		776410,
		1092,
		true
	},
	battlepass_main_tip_2502 = {
		777502,
		271,
		true
	},
	battlepass_main_help_2502 = {
		777773,
		2900,
		true
	},
	cruise_task_help_2502 = {
		780673,
		1092,
		true
	},
	battlepass_main_tip_2504 = {
		781765,
		270,
		true
	},
	battlepass_main_help_2504 = {
		782035,
		2905,
		true
	},
	cruise_task_help_2504 = {
		784940,
		1092,
		true
	},
	battlepass_main_tip_2506 = {
		786032,
		273,
		true
	},
	battlepass_main_help_2506 = {
		786305,
		2908,
		true
	},
	cruise_task_help_2506 = {
		789213,
		1092,
		true
	},
	battlepass_main_tip_2508 = {
		790305,
		273,
		true
	},
	battlepass_main_help_2508 = {
		790578,
		2909,
		true
	},
	cruise_task_help_2508 = {
		793487,
		1092,
		true
	},
	battlepass_main_tip_2510 = {
		794579,
		273,
		true
	},
	battlepass_main_help_2510 = {
		794852,
		2906,
		true
	},
	cruise_task_help_2510 = {
		797758,
		1092,
		true
	},
	attrset_reset = {
		798850,
		82,
		true
	},
	attrset_save = {
		798932,
		80,
		true
	},
	attrset_ask_save = {
		799012,
		133,
		true
	},
	attrset_save_success = {
		799145,
		103,
		true
	},
	attrset_disable = {
		799248,
		147,
		true
	},
	attrset_input_ill = {
		799395,
		93,
		true
	},
	blackfriday_help = {
		799488,
		805,
		true
	},
	eventshop_time_hint = {
		800293,
		100,
		true
	},
	purchase_backyard_theme_desc_for_onekey = {
		800393,
		142,
		true
	},
	purchase_backyard_theme_desc_for_all = {
		800535,
		127,
		true
	},
	sp_no_quota = {
		800662,
		108,
		true
	},
	fur_all_buy = {
		800770,
		82,
		true
	},
	fur_onekey_buy = {
		800852,
		85,
		true
	},
	littleRenown_npc = {
		800937,
		1402,
		true
	},
	tech_package_tip = {
		802339,
		241,
		true
	},
	backyard_food_shop_tip = {
		802580,
		96,
		true
	},
	dorm_2f_lock = {
		802676,
		87,
		true
	},
	word_get_way = {
		802763,
		90,
		true
	},
	word_get_date = {
		802853,
		94,
		true
	},
	enter_theme_name = {
		802947,
		113,
		true
	},
	enter_extend_food_label = {
		803060,
		93,
		true
	},
	backyard_extend_tip_1 = {
		803153,
		90,
		true
	},
	backyard_extend_tip_2 = {
		803243,
		103,
		true
	},
	backyard_extend_tip_3 = {
		803346,
		94,
		true
	},
	backyard_extend_tip_4 = {
		803440,
		85,
		true
	},
	email_text = {
		803525,
		79,
		true
	},
	emailhold_text = {
		803604,
		127,
		true
	},
	code_text = {
		803731,
		90,
		true
	},
	codehold_text = {
		803821,
		102,
		true
	},
	genBtn_text = {
		803923,
		83,
		true
	},
	desc_text = {
		804006,
		156,
		true
	},
	loginBtn_text = {
		804162,
		84,
		true
	},
	verification_code_req_tip1 = {
		804246,
		126,
		true
	},
	verification_code_req_tip2 = {
		804372,
		175,
		true
	},
	verification_code_req_tip3 = {
		804547,
		134,
		true
	},
	levelScene_remaster_story_tip = {
		804681,
		176,
		true
	},
	levelScene_remaster_unlock_tip = {
		804857,
		188,
		true
	},
	linkBtn_text = {
		805045,
		83,
		true
	},
	yostar_link_title = {
		805128,
		98,
		true
	},
	level_remaster_tip1 = {
		805226,
		95,
		true
	},
	level_remaster_tip2 = {
		805321,
		89,
		true
	},
	level_remaster_tip3 = {
		805410,
		89,
		true
	},
	level_remaster_tip4 = {
		805499,
		102,
		true
	},
	pay_cancel = {
		805601,
		88,
		true
	},
	order_error = {
		805689,
		101,
		true
	},
	pay_fail = {
		805790,
		86,
		true
	},
	user_cancel = {
		805876,
		94,
		true
	},
	system_error = {
		805970,
		88,
		true
	},
	time_out = {
		806058,
		109,
		true
	},
	server_error = {
		806167,
		102,
		true
	},
	data_error = {
		806269,
		98,
		true
	},
	share_success = {
		806367,
		97,
		true
	},
	shoot_screen_fail = {
		806464,
		98,
		true
	},
	server_name = {
		806562,
		87,
		true
	},
	non_support_share = {
		806649,
		134,
		true
	},
	save_success = {
		806783,
		99,
		true
	},
	word_guild_join_err1 = {
		806882,
		115,
		true
	},
	task_empty_tip_1 = {
		806997,
		104,
		true
	},
	task_empty_tip_2 = {
		807101,
		160,
		true
	},
	["airi_error_code_ 100210"] = {
		807261,
		126,
		true
	},
	["airi_error_code_ 100211"] = {
		807387,
		138,
		true
	},
	["airi_error_code_ 100212"] = {
		807525,
		116,
		true
	},
	["airi_error_code_ 100610"] = {
		807641,
		125,
		true
	},
	["airi_error_code_ 100611"] = {
		807766,
		120,
		true
	},
	["airi_error_code_ 100612"] = {
		807886,
		132,
		true
	},
	["airi_error_code_ 100710"] = {
		808018,
		127,
		true
	},
	["airi_error_code_ 100711"] = {
		808145,
		127,
		true
	},
	["airi_error_code_ 100712"] = {
		808272,
		135,
		true
	},
	["airi_error_code_ 100810"] = {
		808407,
		126,
		true
	},
	["airi_error_code_ 100811"] = {
		808533,
		138,
		true
	},
	["airi_error_code_ 100812"] = {
		808671,
		133,
		true
	},
	["airi_error_code_ 100813"] = {
		808804,
		125,
		true
	},
	["airi_error_code_ 100814"] = {
		808929,
		120,
		true
	},
	["airi_error_code_ 100815"] = {
		809049,
		132,
		true
	},
	["airi_error_code_ 100816"] = {
		809181,
		127,
		true
	},
	["airi_error_code_ 100817"] = {
		809308,
		127,
		true
	},
	["airi_error_code_ 100818"] = {
		809435,
		134,
		true
	},
	facebook_link_title = {
		809569,
		102,
		true
	},
	newserver_time = {
		809671,
		98,
		true
	},
	newserver_soldout = {
		809769,
		103,
		true
	},
	skill_learn_tip = {
		809872,
		133,
		true
	},
	newserver_build_tip = {
		810005,
		150,
		true
	},
	build_count_tip = {
		810155,
		85,
		true
	},
	help_research_package = {
		810240,
		299,
		true
	},
	lv70_package_tip = {
		810539,
		228,
		true
	},
	tech_select_tip1 = {
		810767,
		97,
		true
	},
	tech_select_tip2 = {
		810864,
		107,
		true
	},
	tech_select_tip3 = {
		810971,
		88,
		true
	},
	tech_select_tip4 = {
		811059,
		96,
		true
	},
	tech_select_tip5 = {
		811155,
		117,
		true
	},
	techpackage_item_use = {
		811272,
		203,
		true
	},
	techpackage_item_use_1 = {
		811475,
		238,
		true
	},
	techpackage_item_use_2 = {
		811713,
		200,
		true
	},
	techpackage_item_use_confirm = {
		811913,
		138,
		true
	},
	new_server_shop_sel_goods_tip = {
		812051,
		130,
		true
	},
	new_server_shop_unopen_tip = {
		812181,
		101,
		true
	},
	newserver_activity_tip = {
		812282,
		1685,
		true
	},
	newserver_shop_timelimit = {
		813967,
		106,
		true
	},
	tech_character_get = {
		814073,
		89,
		true
	},
	package_detail_tip = {
		814162,
		88,
		true
	},
	event_ui_consume = {
		814250,
		84,
		true
	},
	event_ui_recommend = {
		814334,
		91,
		true
	},
	event_ui_start = {
		814425,
		83,
		true
	},
	event_ui_giveup = {
		814508,
		85,
		true
	},
	event_ui_finish = {
		814593,
		87,
		true
	},
	nav_tactics_sel_skill_title = {
		814680,
		103,
		true
	},
	battle_result_confirm = {
		814783,
		92,
		true
	},
	battle_result_targets = {
		814875,
		92,
		true
	},
	battle_result_continue = {
		814967,
		103,
		true
	},
	index_L2D = {
		815070,
		76,
		true
	},
	index_DBG = {
		815146,
		84,
		true
	},
	index_BG = {
		815230,
		82,
		true
	},
	index_CANTUSE = {
		815312,
		91,
		true
	},
	index_UNUSE = {
		815403,
		81,
		true
	},
	index_BGM = {
		815484,
		84,
		true
	},
	without_ship_to_wear = {
		815568,
		124,
		true
	},
	choose_ship_to_wear_this_skin = {
		815692,
		136,
		true
	},
	skinatlas_search_holder = {
		815828,
		113,
		true
	},
	skinatlas_search_result_is_empty = {
		815941,
		143,
		true
	},
	chang_ship_skin_window_title = {
		816084,
		96,
		true
	},
	world_boss_item_info = {
		816180,
		350,
		true
	},
	world_past_boss_item_info = {
		816530,
		480,
		true
	},
	world_boss_lefttime = {
		817010,
		92,
		true
	},
	world_boss_item_count_noenough = {
		817102,
		145,
		true
	},
	world_boss_item_usage_tip = {
		817247,
		173,
		true
	},
	world_boss_no_select_archives = {
		817420,
		161,
		true
	},
	world_boss_archives_item_count_noenough = {
		817581,
		157,
		true
	},
	world_boss_archives_are_clear = {
		817738,
		156,
		true
	},
	world_boss_switch_archives = {
		817894,
		248,
		true
	},
	world_boss_switch_archives_success = {
		818142,
		146,
		true
	},
	world_boss_archives_auto_battle_unopen = {
		818288,
		169,
		true
	},
	world_boss_archives_need_stop_auto_battle = {
		818457,
		164,
		true
	},
	world_boss_archives_stop_auto_battle = {
		818621,
		137,
		true
	},
	world_boss_archives_continue_auto_battle = {
		818758,
		140,
		true
	},
	world_boss_archives_auto_battle_reusle_title = {
		818898,
		145,
		true
	},
	world_boss_archives_stop_auto_battle_title = {
		819043,
		146,
		true
	},
	world_boss_archives_stop_auto_battle_tip = {
		819189,
		119,
		true
	},
	world_boss_archives_stop_auto_battle_tip1 = {
		819308,
		241,
		true
	},
	world_archives_boss_help = {
		819549,
		3343,
		true
	},
	world_archives_boss_list_help = {
		822892,
		570,
		true
	},
	archives_boss_was_opened = {
		823462,
		163,
		true
	},
	current_boss_was_opened = {
		823625,
		162,
		true
	},
	world_boss_title_auto_battle = {
		823787,
		103,
		true
	},
	world_boss_title_highest_damge = {
		823890,
		105,
		true
	},
	world_boss_title_estimation = {
		823995,
		113,
		true
	},
	world_boss_title_battle_cnt = {
		824108,
		99,
		true
	},
	world_boss_title_consume_oil_cnt = {
		824207,
		104,
		true
	},
	world_boss_title_spend_time = {
		824311,
		104,
		true
	},
	world_boss_title_total_damage = {
		824415,
		102,
		true
	},
	world_no_time_to_auto_battle = {
		824517,
		143,
		true
	},
	world_boss_current_boss_label = {
		824660,
		104,
		true
	},
	world_boss_current_boss_label1 = {
		824764,
		107,
		true
	},
	world_boss_archives_boss_tip = {
		824871,
		158,
		true
	},
	world_boss_progress_no_enough = {
		825029,
		127,
		true
	},
	world_boss_auto_battle_no_oil = {
		825156,
		119,
		true
	},
	meta_syn_value_label = {
		825275,
		108,
		true
	},
	meta_syn_finish = {
		825383,
		103,
		true
	},
	index_meta_repair = {
		825486,
		104,
		true
	},
	index_meta_tactics = {
		825590,
		103,
		true
	},
	index_meta_energy = {
		825693,
		104,
		true
	},
	tactics_continue_to_learn_other_skill = {
		825797,
		162,
		true
	},
	tactics_continue_to_learn_other_ship_skill = {
		825959,
		161,
		true
	},
	tactics_no_recent_ships = {
		826120,
		113,
		true
	},
	activity_kill = {
		826233,
		95,
		true
	},
	battle_result_dmg = {
		826328,
		87,
		true
	},
	battle_result_kill_count = {
		826415,
		100,
		true
	},
	battle_result_toggle_on = {
		826515,
		96,
		true
	},
	battle_result_toggle_off = {
		826611,
		101,
		true
	},
	battle_result_continue_battle = {
		826712,
		101,
		true
	},
	battle_result_quit_battle = {
		826813,
		96,
		true
	},
	battle_result_share_battle = {
		826909,
		95,
		true
	},
	pre_combat_team = {
		827004,
		91,
		true
	},
	pre_combat_vanguard = {
		827095,
		91,
		true
	},
	pre_combat_main = {
		827186,
		83,
		true
	},
	pre_combat_submarine = {
		827269,
		93,
		true
	},
	pre_combat_targets = {
		827362,
		89,
		true
	},
	pre_combat_atlasloot = {
		827451,
		88,
		true
	},
	destroy_confirm_access = {
		827539,
		93,
		true
	},
	destroy_confirm_cancel = {
		827632,
		92,
		true
	},
	pt_count_tip = {
		827724,
		81,
		true
	},
	dockyard_data_loss_detected = {
		827805,
		167,
		true
	},
	littleEugen_npc = {
		827972,
		1374,
		true
	},
	five_shujuhuigu = {
		829346,
		121,
		true
	},
	five_shujuhuigu1 = {
		829467,
		89,
		true
	},
	littleChaijun_npc = {
		829556,
		1290,
		true
	},
	five_qingdian = {
		830846,
		622,
		true
	},
	friend_resume_title_detail = {
		831468,
		94,
		true
	},
	item_type13_tip1 = {
		831562,
		88,
		true
	},
	item_type13_tip2 = {
		831650,
		88,
		true
	},
	item_type16_tip1 = {
		831738,
		88,
		true
	},
	item_type16_tip2 = {
		831826,
		88,
		true
	},
	item_type17_tip1 = {
		831914,
		87,
		true
	},
	item_type17_tip2 = {
		832001,
		87,
		true
	},
	five_duomaomao = {
		832088,
		788,
		true
	},
	main_4 = {
		832876,
		75,
		true
	},
	main_5 = {
		832951,
		75,
		true
	},
	honor_medal_support_tips_display = {
		833026,
		460,
		true
	},
	honor_medal_support_tips_confirm = {
		833486,
		207,
		true
	},
	support_rate_title = {
		833693,
		87,
		true
	},
	support_times_limited = {
		833780,
		128,
		true
	},
	support_times_tip = {
		833908,
		95,
		true
	},
	build_times_tip = {
		834003,
		90,
		true
	},
	tactics_recent_ship_label = {
		834093,
		105,
		true
	},
	title_info = {
		834198,
		78,
		true
	},
	eventshop_unlock_info = {
		834276,
		93,
		true
	},
	eventshop_unlock_hint = {
		834369,
		142,
		true
	},
	commission_event_tip = {
		834511,
		818,
		true
	},
	decoration_medal_placeholder = {
		835329,
		122,
		true
	},
	technology_filter_placeholder = {
		835451,
		119,
		true
	},
	eva_comment_send_null = {
		835570,
		101,
		true
	},
	report_sent_thank = {
		835671,
		156,
		true
	},
	report_ship_cannot_comment = {
		835827,
		127,
		true
	},
	report_cannot_comment = {
		835954,
		137,
		true
	},
	report_sent_title = {
		836091,
		87,
		true
	},
	report_sent_desc = {
		836178,
		130,
		true
	},
	report_type_1 = {
		836308,
		98,
		true
	},
	report_type_1_1 = {
		836406,
		146,
		true
	},
	report_type_2 = {
		836552,
		94,
		true
	},
	report_type_2_1 = {
		836646,
		146,
		true
	},
	report_type_3 = {
		836792,
		88,
		true
	},
	report_type_3_1 = {
		836880,
		177,
		true
	},
	report_type_other = {
		837057,
		85,
		true
	},
	report_type_other_1 = {
		837142,
		145,
		true
	},
	report_type_other_2 = {
		837287,
		115,
		true
	},
	report_sent_help = {
		837402,
		440,
		true
	},
	rename_input = {
		837842,
		93,
		true
	},
	avatar_task_level = {
		837935,
		166,
		true
	},
	avatar_upgrad_1 = {
		838101,
		92,
		true
	},
	avatar_upgrad_2 = {
		838193,
		92,
		true
	},
	avatar_upgrad_3 = {
		838285,
		95,
		true
	},
	avatar_task_ship_1 = {
		838380,
		92,
		true
	},
	avatar_task_ship_2 = {
		838472,
		103,
		true
	},
	technology_queue_complete = {
		838575,
		97,
		true
	},
	technology_queue_processing = {
		838672,
		102,
		true
	},
	technology_queue_waiting = {
		838774,
		94,
		true
	},
	technology_queue_getaward = {
		838868,
		94,
		true
	},
	technology_daily_refresh = {
		838962,
		119,
		true
	},
	technology_queue_full = {
		839081,
		113,
		true
	},
	technology_queue_in_mission_incomplete = {
		839194,
		177,
		true
	},
	technology_consume = {
		839371,
		95,
		true
	},
	technology_request = {
		839466,
		103,
		true
	},
	technology_queue_in_doublecheck = {
		839569,
		242,
		true
	},
	playervtae_setting_btn_label = {
		839811,
		100,
		true
	},
	technology_queue_in_success = {
		839911,
		130,
		true
	},
	star_require_enemy_text = {
		840041,
		116,
		true
	},
	star_require_enemy_title = {
		840157,
		107,
		true
	},
	star_require_enemy_check = {
		840264,
		95,
		true
	},
	worldboss_rank_timer_label = {
		840359,
		116,
		true
	},
	technology_detail = {
		840475,
		88,
		true
	},
	technology_mission_unfinish = {
		840563,
		127,
		true
	},
	word_chinese = {
		840690,
		82,
		true
	},
	word_japanese_3 = {
		840772,
		80,
		true
	},
	word_japanese_2 = {
		840852,
		80,
		true
	},
	word_japanese = {
		840932,
		78,
		true
	},
	avatarframe_got = {
		841010,
		86,
		true
	},
	item_is_max_cnt = {
		841096,
		110,
		true
	},
	level_fleet_ship_desc = {
		841206,
		103,
		true
	},
	level_fleet_sub_desc = {
		841309,
		95,
		true
	},
	summerland_tip = {
		841404,
		560,
		true
	},
	icecreamgame_tip = {
		841964,
		1578,
		true
	},
	unlock_date_tip = {
		843542,
		118,
		true
	},
	guild_duty_shoule_be_deputy_commander = {
		843660,
		164,
		true
	},
	guild_deputy_commander_cnt_is_full = {
		843824,
		154,
		true
	},
	guild_deputy_commander_cnt = {
		843978,
		153,
		true
	},
	mail_filter_placeholder = {
		844131,
		107,
		true
	},
	recently_sticker_placeholder = {
		844238,
		111,
		true
	},
	backhill_campusfestival_tip = {
		844349,
		1219,
		true
	},
	mini_cookgametip = {
		845568,
		1297,
		true
	},
	cook_game_Albacore = {
		846865,
		115,
		true
	},
	cook_game_august = {
		846980,
		109,
		true
	},
	cook_game_elbe = {
		847089,
		107,
		true
	},
	cook_game_hakuryu = {
		847196,
		125,
		true
	},
	cook_game_howe = {
		847321,
		140,
		true
	},
	cook_game_marcopolo = {
		847461,
		114,
		true
	},
	cook_game_noshiro = {
		847575,
		126,
		true
	},
	cook_game_pnelope = {
		847701,
		130,
		true
	},
	cook_game_laffey = {
		847831,
		171,
		true
	},
	cook_game_janus = {
		848002,
		150,
		true
	},
	cook_game_flandre = {
		848152,
		100,
		true
	},
	cook_game_constellation = {
		848252,
		187,
		true
	},
	cook_game_constellation_skill_name = {
		848439,
		134,
		true
	},
	cook_game_constellation_skill_desc = {
		848573,
		206,
		true
	},
	random_ship_on = {
		848779,
		127,
		true
	},
	random_ship_off_0 = {
		848906,
		181,
		true
	},
	random_ship_off = {
		849087,
		190,
		true
	},
	random_ship_forbidden = {
		849277,
		174,
		true
	},
	random_ship_now = {
		849451,
		97,
		true
	},
	random_ship_label = {
		849548,
		97,
		true
	},
	player_vitae_skin_setting = {
		849645,
		102,
		true
	},
	random_ship_tips1 = {
		849747,
		167,
		true
	},
	random_ship_tips2 = {
		849914,
		145,
		true
	},
	random_ship_before = {
		850059,
		113,
		true
	},
	random_ship_and_skin_title = {
		850172,
		101,
		true
	},
	random_ship_frequse_mode = {
		850273,
		102,
		true
	},
	random_ship_locked_mode = {
		850375,
		99,
		true
	},
	littleSpee_npc = {
		850474,
		1583,
		true
	},
	random_flag_ship = {
		852057,
		96,
		true
	},
	random_flag_ship_changskinBtn_label = {
		852153,
		111,
		true
	},
	expedition_drop_use_out = {
		852264,
		152,
		true
	},
	expedition_extra_drop_tip = {
		852416,
		104,
		true
	},
	ex_pass_use = {
		852520,
		79,
		true
	},
	defense_formation_tip_npc = {
		852599,
		203,
		true
	},
	pgs_login_tip = {
		852802,
		250,
		true
	},
	pgs_login_binding_exist1 = {
		853052,
		204,
		true
	},
	pgs_login_binding_exist2 = {
		853256,
		205,
		true
	},
	pgs_login_binding_exist3 = {
		853461,
		271,
		true
	},
	pgs_binding_account = {
		853732,
		108,
		true
	},
	pgs_unbind = {
		853840,
		92,
		true
	},
	pgs_unbind_tip1 = {
		853932,
		152,
		true
	},
	pgs_unbind_tip2 = {
		854084,
		214,
		true
	},
	word_item = {
		854298,
		77,
		true
	},
	word_tool = {
		854375,
		77,
		true
	},
	word_other = {
		854452,
		78,
		true
	},
	ryza_word_equip = {
		854530,
		83,
		true
	},
	ryza_rest_produce_count = {
		854613,
		109,
		true
	},
	ryza_composite_confirm = {
		854722,
		119,
		true
	},
	ryza_composite_confirm_single = {
		854841,
		122,
		true
	},
	ryza_composite_count = {
		854963,
		93,
		true
	},
	ryza_toggle_only_composite = {
		855056,
		112,
		true
	},
	ryza_tip_select_recipe = {
		855168,
		113,
		true
	},
	ryza_tip_put_materials = {
		855281,
		139,
		true
	},
	ryza_tip_composite_unlock = {
		855420,
		158,
		true
	},
	ryza_tip_unlock_all_tools = {
		855578,
		151,
		true
	},
	ryza_material_not_enough = {
		855729,
		168,
		true
	},
	ryza_tip_composite_invalid = {
		855897,
		132,
		true
	},
	ryza_tip_max_composite_count = {
		856029,
		136,
		true
	},
	ryza_tip_no_item = {
		856165,
		119,
		true
	},
	ryza_ui_show_acess = {
		856284,
		92,
		true
	},
	ryza_tip_no_recipe = {
		856376,
		103,
		true
	},
	ryza_tip_item_access = {
		856479,
		136,
		true
	},
	ryza_tip_control_buff_not_obtain_tip = {
		856615,
		143,
		true
	},
	ryza_tip_control_buff_upgrade = {
		856758,
		100,
		true
	},
	ryza_tip_control_buff_replace = {
		856858,
		100,
		true
	},
	ryza_tip_control_buff_limit = {
		856958,
		96,
		true
	},
	ryza_tip_control_buff_already_active_tip = {
		857054,
		111,
		true
	},
	ryza_tip_control_buff = {
		857165,
		163,
		true
	},
	ryza_tip_control_buff_not_obtain = {
		857328,
		103,
		true
	},
	ryza_tip_control = {
		857431,
		142,
		true
	},
	ryza_tip_main = {
		857573,
		1454,
		true
	},
	battle_levelScene_ryza_lock = {
		859027,
		186,
		true
	},
	ryza_tip_toast_item_got = {
		859213,
		96,
		true
	},
	ryza_composite_help_tip = {
		859309,
		476,
		true
	},
	ryza_control_help_tip = {
		859785,
		296,
		true
	},
	ryza_mini_game = {
		860081,
		351,
		true
	},
	ryza_task_level_desc = {
		860432,
		89,
		true
	},
	ryza_task_tag_explore = {
		860521,
		90,
		true
	},
	ryza_task_tag_battle = {
		860611,
		88,
		true
	},
	ryza_task_tag_dalegate = {
		860699,
		91,
		true
	},
	ryza_task_tag_develop = {
		860790,
		89,
		true
	},
	ryza_task_tag_adventure = {
		860879,
		97,
		true
	},
	ryza_task_tag_build = {
		860976,
		93,
		true
	},
	ryza_task_tag_create = {
		861069,
		92,
		true
	},
	ryza_task_tag_daily = {
		861161,
		90,
		true
	},
	ryza_task_detail_content = {
		861251,
		99,
		true
	},
	ryza_task_detail_award = {
		861350,
		93,
		true
	},
	ryza_task_go = {
		861443,
		83,
		true
	},
	ryza_task_get = {
		861526,
		83,
		true
	},
	ryza_task_get_all = {
		861609,
		90,
		true
	},
	ryza_task_confirm = {
		861699,
		88,
		true
	},
	ryza_task_cancel = {
		861787,
		86,
		true
	},
	ryza_task_level_num = {
		861873,
		93,
		true
	},
	ryza_task_level_add = {
		861966,
		95,
		true
	},
	ryza_task_submit = {
		862061,
		86,
		true
	},
	ryza_task_detail = {
		862147,
		85,
		true
	},
	ryza_composite_words = {
		862232,
		704,
		true
	},
	ryza_task_help_tip = {
		862936,
		345,
		true
	},
	hotspring_buff = {
		863281,
		140,
		true
	},
	random_ship_custom_mode_empty = {
		863421,
		148,
		true
	},
	random_ship_custom_mode_main_button_add = {
		863569,
		106,
		true
	},
	random_ship_custom_mode_main_button_remove = {
		863675,
		112,
		true
	},
	random_ship_custom_mode_main_tip1 = {
		863787,
		151,
		true
	},
	random_ship_custom_mode_main_tip2 = {
		863938,
		107,
		true
	},
	random_ship_custom_mode_main_empty = {
		864045,
		137,
		true
	},
	random_ship_custom_mode_select_all = {
		864182,
		108,
		true
	},
	random_ship_custom_mode_add_tip1 = {
		864290,
		158,
		true
	},
	random_ship_custom_mode_select_number = {
		864448,
		110,
		true
	},
	random_ship_custom_mode_add_complete = {
		864558,
		130,
		true
	},
	random_ship_custom_mode_add_tip2 = {
		864688,
		159,
		true
	},
	random_ship_custom_mode_remove_tip1 = {
		864847,
		166,
		true
	},
	random_ship_custom_mode_remove_complete = {
		865013,
		135,
		true
	},
	random_ship_custom_mode_remove_tip2 = {
		865148,
		166,
		true
	},
	index_dressed = {
		865314,
		89,
		true
	},
	random_ship_custom_mode = {
		865403,
		110,
		true
	},
	random_ship_custom_mode_add_title = {
		865513,
		110,
		true
	},
	random_ship_custom_mode_remove_title = {
		865623,
		116,
		true
	},
	hotspring_shop_enter1 = {
		865739,
		150,
		true
	},
	hotspring_shop_enter2 = {
		865889,
		143,
		true
	},
	hotspring_shop_insufficient = {
		866032,
		189,
		true
	},
	hotspring_shop_success1 = {
		866221,
		117,
		true
	},
	hotspring_shop_success2 = {
		866338,
		103,
		true
	},
	hotspring_shop_finish = {
		866441,
		173,
		true
	},
	hotspring_shop_end = {
		866614,
		155,
		true
	},
	hotspring_shop_touch1 = {
		866769,
		107,
		true
	},
	hotspring_shop_touch2 = {
		866876,
		128,
		true
	},
	hotspring_shop_touch3 = {
		867004,
		115,
		true
	},
	hotspring_shop_exchanged = {
		867119,
		154,
		true
	},
	hotspring_shop_exchange = {
		867273,
		184,
		true
	},
	hotspring_tip1 = {
		867457,
		130,
		true
	},
	hotspring_tip2 = {
		867587,
		104,
		true
	},
	hotspring_help = {
		867691,
		631,
		true
	},
	hotspring_expand = {
		868322,
		147,
		true
	},
	hotspring_shop_help = {
		868469,
		571,
		true
	},
	resorts_help = {
		869040,
		819,
		true
	},
	pvzminigame_help = {
		869859,
		1187,
		true
	},
	tips_yuandanhuoyue2023 = {
		871046,
		745,
		true
	},
	beach_guard_chaijun = {
		871791,
		159,
		true
	},
	beach_guard_jianye = {
		871950,
		164,
		true
	},
	beach_guard_lituoliao = {
		872114,
		279,
		true
	},
	beach_guard_bominghan = {
		872393,
		237,
		true
	},
	beach_guard_nengdai = {
		872630,
		269,
		true
	},
	beach_guard_m_craft = {
		872899,
		121,
		true
	},
	beach_guard_m_atk = {
		873020,
		111,
		true
	},
	beach_guard_m_guard = {
		873131,
		107,
		true
	},
	beach_guard_m_craft_name = {
		873238,
		98,
		true
	},
	beach_guard_m_atk_name = {
		873336,
		94,
		true
	},
	beach_guard_m_guard_name = {
		873430,
		97,
		true
	},
	beach_guard_e1 = {
		873527,
		87,
		true
	},
	beach_guard_e2 = {
		873614,
		84,
		true
	},
	beach_guard_e3 = {
		873698,
		87,
		true
	},
	beach_guard_e4 = {
		873785,
		85,
		true
	},
	beach_guard_e5 = {
		873870,
		87,
		true
	},
	beach_guard_e6 = {
		873957,
		84,
		true
	},
	beach_guard_e7 = {
		874041,
		86,
		true
	},
	beach_guard_e1_desc = {
		874127,
		135,
		true
	},
	beach_guard_e2_desc = {
		874262,
		142,
		true
	},
	beach_guard_e3_desc = {
		874404,
		140,
		true
	},
	beach_guard_e4_desc = {
		874544,
		137,
		true
	},
	beach_guard_e5_desc = {
		874681,
		130,
		true
	},
	beach_guard_e6_desc = {
		874811,
		235,
		true
	},
	beach_guard_e7_desc = {
		875046,
		166,
		true
	},
	ninghai_nianye = {
		875212,
		142,
		true
	},
	yingrui_nianye = {
		875354,
		142,
		true
	},
	zhaohe_nianye = {
		875496,
		135,
		true
	},
	zhenhai_nianye = {
		875631,
		143,
		true
	},
	haitian_nianye = {
		875774,
		153,
		true
	},
	taiyuan_nianye = {
		875927,
		148,
		true
	},
	yixian_nianye = {
		876075,
		166,
		true
	},
	activity_yanhua_tip1 = {
		876241,
		93,
		true
	},
	activity_yanhua_tip2 = {
		876334,
		103,
		true
	},
	activity_yanhua_tip3 = {
		876437,
		103,
		true
	},
	activity_yanhua_tip4 = {
		876540,
		139,
		true
	},
	activity_yanhua_tip5 = {
		876679,
		120,
		true
	},
	activity_yanhua_tip6 = {
		876799,
		124,
		true
	},
	activity_yanhua_tip7 = {
		876923,
		158,
		true
	},
	activity_yanhua_tip8 = {
		877081,
		103,
		true
	},
	help_chunjie2023 = {
		877184,
		1441,
		true
	},
	sevenday_nianye = {
		878625,
		406,
		true
	},
	tip_nianye = {
		879031,
		122,
		true
	},
	couplete_activty_desc = {
		879153,
		351,
		true
	},
	couplete_click_desc = {
		879504,
		131,
		true
	},
	couplet_index_desc = {
		879635,
		89,
		true
	},
	couplete_help = {
		879724,
		770,
		true
	},
	couplete_drag_tip = {
		880494,
		133,
		true
	},
	couplete_remind = {
		880627,
		114,
		true
	},
	couplete_complete = {
		880741,
		132,
		true
	},
	couplete_enter = {
		880873,
		114,
		true
	},
	couplete_stay = {
		880987,
		107,
		true
	},
	couplete_task = {
		881094,
		135,
		true
	},
	couplete_pass_1 = {
		881229,
		96,
		true
	},
	couplete_pass_2 = {
		881325,
		100,
		true
	},
	couplete_fail_1 = {
		881425,
		119,
		true
	},
	couplete_fail_2 = {
		881544,
		117,
		true
	},
	couplete_pair_1 = {
		881661,
		123,
		true
	},
	couplete_pair_2 = {
		881784,
		113,
		true
	},
	couplete_pair_3 = {
		881897,
		119,
		true
	},
	couplete_pair_4 = {
		882016,
		113,
		true
	},
	couplete_pair_5 = {
		882129,
		126,
		true
	},
	couplete_pair_6 = {
		882255,
		119,
		true
	},
	couplete_pair_7 = {
		882374,
		113,
		true
	},
	["2023spring_minigame_item_lantern"] = {
		882487,
		183,
		true
	},
	["2023spring_minigame_item_firecracker"] = {
		882670,
		188,
		true
	},
	["2023spring_minigame_skill_icewall"] = {
		882858,
		149,
		true
	},
	["2023spring_minigame_skill_icewall_up"] = {
		883007,
		223,
		true
	},
	["2023spring_minigame_skill_sprint"] = {
		883230,
		151,
		true
	},
	["2023spring_minigame_skill_sprint_up"] = {
		883381,
		227,
		true
	},
	["2023spring_minigame_skill_flash"] = {
		883608,
		180,
		true
	},
	["2023spring_minigame_skill_flash_up"] = {
		883788,
		200,
		true
	},
	["2023spring_minigame_bless_speed"] = {
		883988,
		136,
		true
	},
	["2023spring_minigame_bless_speed_up"] = {
		884124,
		211,
		true
	},
	["2023spring_minigame_bless_substitute"] = {
		884335,
		204,
		true
	},
	["2023spring_minigame_bless_substitute_up"] = {
		884539,
		127,
		true
	},
	["2023spring_minigame_nenjuu_skill1"] = {
		884666,
		199,
		true
	},
	["2023spring_minigame_nenjuu_skill2"] = {
		884865,
		146,
		true
	},
	["2023spring_minigame_nenjuu_skill3"] = {
		885011,
		158,
		true
	},
	["2023spring_minigame_nenjuu_skill4"] = {
		885169,
		139,
		true
	},
	["2023spring_minigame_nenjuu_skill5"] = {
		885308,
		214,
		true
	},
	["2023spring_minigame_nenjuu_skill6"] = {
		885522,
		158,
		true
	},
	["2023spring_minigame_nenjuu_skill7"] = {
		885680,
		234,
		true
	},
	["2023spring_minigame_nenjuu_skill8"] = {
		885914,
		219,
		true
	},
	["2023spring_minigame_tip1"] = {
		886133,
		93,
		true
	},
	["2023spring_minigame_tip2"] = {
		886226,
		96,
		true
	},
	["2023spring_minigame_tip3"] = {
		886322,
		93,
		true
	},
	["2023spring_minigame_tip5"] = {
		886415,
		136,
		true
	},
	["2023spring_minigame_tip6"] = {
		886551,
		100,
		true
	},
	["2023spring_minigame_tip7"] = {
		886651,
		100,
		true
	},
	["2023spring_minigame_help"] = {
		886751,
		1174,
		true
	},
	multiple_sorties_title = {
		887925,
		97,
		true
	},
	multiple_sorties_title_eng = {
		888022,
		106,
		true
	},
	multiple_sorties_locked_tip = {
		888128,
		180,
		true
	},
	multiple_sorties_times = {
		888308,
		93,
		true
	},
	multiple_sorties_tip = {
		888401,
		206,
		true
	},
	multiple_sorties_challenge_ticket_use = {
		888607,
		118,
		true
	},
	multiple_sorties_cost1 = {
		888725,
		150,
		true
	},
	multiple_sorties_cost2 = {
		888875,
		159,
		true
	},
	multiple_sorties_cost3 = {
		889034,
		184,
		true
	},
	multiple_sorties_stopped = {
		889218,
		95,
		true
	},
	multiple_sorties_stop_tip = {
		889313,
		186,
		true
	},
	multiple_sorties_resume_tip = {
		889499,
		138,
		true
	},
	multiple_sorties_auto_on = {
		889637,
		132,
		true
	},
	multiple_sorties_finish = {
		889769,
		108,
		true
	},
	multiple_sorties_stop = {
		889877,
		105,
		true
	},
	multiple_sorties_stop_end = {
		889982,
		118,
		true
	},
	multiple_sorties_end_status = {
		890100,
		181,
		true
	},
	multiple_sorties_finish_tip = {
		890281,
		140,
		true
	},
	multiple_sorties_stop_tip_end = {
		890421,
		146,
		true
	},
	multiple_sorties_stop_reason1 = {
		890567,
		118,
		true
	},
	multiple_sorties_stop_reason2 = {
		890685,
		147,
		true
	},
	multiple_sorties_stop_reason3 = {
		890832,
		125,
		true
	},
	multiple_sorties_stop_reason4 = {
		890957,
		131,
		true
	},
	multiple_sorties_main_tip = {
		891088,
		253,
		true
	},
	multiple_sorties_main_end = {
		891341,
		204,
		true
	},
	multiple_sorties_rest_time = {
		891545,
		105,
		true
	},
	multiple_sorties_retry_desc = {
		891650,
		108,
		true
	},
	msgbox_text_battle = {
		891758,
		88,
		true
	},
	pre_combat_start = {
		891846,
		86,
		true
	},
	pre_combat_start_en = {
		891932,
		95,
		true
	},
	["2023Valentine_minigame_s"] = {
		892027,
		181,
		true
	},
	["2023Valentine_minigame_a"] = {
		892208,
		165,
		true
	},
	["2023Valentine_minigame_b"] = {
		892373,
		179,
		true
	},
	["2023Valentine_minigame_c"] = {
		892552,
		176,
		true
	},
	["2023Valentine_minigame_label1"] = {
		892728,
		99,
		true
	},
	["2023Valentine_minigame_label2"] = {
		892827,
		97,
		true
	},
	["2023Valentine_minigame_label3"] = {
		892924,
		101,
		true
	},
	Valentine_minigame_label1 = {
		893025,
		95,
		true
	},
	Valentine_minigame_label2 = {
		893120,
		107,
		true
	},
	Valentine_minigame_label3 = {
		893227,
		98,
		true
	},
	sort_energy = {
		893325,
		81,
		true
	},
	dockyard_search_holder = {
		893406,
		100,
		true
	},
	loveletter_exchange_tip1 = {
		893506,
		154,
		true
	},
	loveletter_exchange_tip2 = {
		893660,
		140,
		true
	},
	loveletter_exchange_confirm = {
		893800,
		312,
		true
	},
	loveletter_exchange_button = {
		894112,
		97,
		true
	},
	loveletter_exchange_tip3 = {
		894209,
		163,
		true
	},
	loveletter_recover_tip1 = {
		894372,
		153,
		true
	},
	loveletter_recover_tip2 = {
		894525,
		107,
		true
	},
	loveletter_recover_tip3 = {
		894632,
		152,
		true
	},
	loveletter_recover_tip4 = {
		894784,
		146,
		true
	},
	loveletter_recover_tip5 = {
		894930,
		169,
		true
	},
	loveletter_recover_tip6 = {
		895099,
		156,
		true
	},
	loveletter_recover_tip7 = {
		895255,
		180,
		true
	},
	loveletter_recover_bottom1 = {
		895435,
		94,
		true
	},
	loveletter_recover_bottom2 = {
		895529,
		96,
		true
	},
	loveletter_recover_bottom3 = {
		895625,
		92,
		true
	},
	loveletter_recover_text1 = {
		895717,
		360,
		true
	},
	loveletter_recover_text2 = {
		896077,
		344,
		true
	},
	battle_text_common_1 = {
		896421,
		179,
		true
	},
	battle_text_common_2 = {
		896600,
		235,
		true
	},
	battle_text_common_3 = {
		896835,
		192,
		true
	},
	battle_text_common_4 = {
		897027,
		203,
		true
	},
	battle_text_yingxiv4_1 = {
		897230,
		140,
		true
	},
	battle_text_yingxiv4_2 = {
		897370,
		143,
		true
	},
	battle_text_yingxiv4_3 = {
		897513,
		141,
		true
	},
	battle_text_yingxiv4_4 = {
		897654,
		146,
		true
	},
	battle_text_yingxiv4_5 = {
		897800,
		138,
		true
	},
	battle_text_yingxiv4_6 = {
		897938,
		146,
		true
	},
	battle_text_yingxiv4_7 = {
		898084,
		150,
		true
	},
	battle_text_yingxiv4_8 = {
		898234,
		152,
		true
	},
	battle_text_yingxiv4_9 = {
		898386,
		152,
		true
	},
	battle_text_yingxiv4_10 = {
		898538,
		148,
		true
	},
	battle_text_bisimaiz_1 = {
		898686,
		136,
		true
	},
	battle_text_bisimaiz_2 = {
		898822,
		136,
		true
	},
	battle_text_bisimaiz_3 = {
		898958,
		136,
		true
	},
	battle_text_bisimaiz_4 = {
		899094,
		136,
		true
	},
	battle_text_bisimaiz_5 = {
		899230,
		136,
		true
	},
	battle_text_bisimaiz_6 = {
		899366,
		136,
		true
	},
	battle_text_bisimaiz_7 = {
		899502,
		167,
		true
	},
	battle_text_bisimaiz_8 = {
		899669,
		239,
		true
	},
	battle_text_bisimaiz_9 = {
		899908,
		250,
		true
	},
	battle_text_bisimaiz_10 = {
		900158,
		207,
		true
	},
	battle_text_yunxian_1 = {
		900365,
		172,
		true
	},
	battle_text_yunxian_2 = {
		900537,
		175,
		true
	},
	battle_text_yunxian_3 = {
		900712,
		155,
		true
	},
	battle_text_haidao_1 = {
		900867,
		151,
		true
	},
	battle_text_haidao_2 = {
		901018,
		174,
		true
	},
	battle_text_tongmeng_1 = {
		901192,
		134,
		true
	},
	battle_text_luodeni_1 = {
		901326,
		173,
		true
	},
	battle_text_luodeni_2 = {
		901499,
		202,
		true
	},
	battle_text_luodeni_3 = {
		901701,
		187,
		true
	},
	battle_text_pizibao_1 = {
		901888,
		176,
		true
	},
	battle_text_pizibao_2 = {
		902064,
		178,
		true
	},
	battle_text_tianchengCV_1 = {
		902242,
		194,
		true
	},
	battle_text_tianchengCV_2 = {
		902436,
		174,
		true
	},
	battle_text_tianchengCV_3 = {
		902610,
		189,
		true
	},
	battle_text_lumei_1 = {
		902799,
		119,
		true
	},
	series_enemy_mood = {
		902918,
		91,
		true
	},
	series_enemy_mood_error = {
		903009,
		169,
		true
	},
	series_enemy_reward_tip1 = {
		903178,
		100,
		true
	},
	series_enemy_reward_tip2 = {
		903278,
		112,
		true
	},
	series_enemy_reward_tip3 = {
		903390,
		101,
		true
	},
	series_enemy_reward_tip4 = {
		903491,
		98,
		true
	},
	series_enemy_cost = {
		903589,
		92,
		true
	},
	series_enemy_SP_count = {
		903681,
		104,
		true
	},
	series_enemy_SP_error = {
		903785,
		118,
		true
	},
	series_enemy_unlock = {
		903903,
		126,
		true
	},
	series_enemy_storyunlock = {
		904029,
		119,
		true
	},
	series_enemy_storyreward = {
		904148,
		100,
		true
	},
	series_enemy_help = {
		904248,
		2113,
		true
	},
	series_enemy_score = {
		906361,
		87,
		true
	},
	series_enemy_total_score = {
		906448,
		99,
		true
	},
	setting_label_private = {
		906547,
		85,
		true
	},
	setting_label_licence = {
		906632,
		85,
		true
	},
	series_enemy_reward = {
		906717,
		104,
		true
	},
	series_enemy_mode_1 = {
		906821,
		97,
		true
	},
	series_enemy_mode_2 = {
		906918,
		99,
		true
	},
	series_enemy_fleet_prefix = {
		907017,
		97,
		true
	},
	series_enemy_team_notenough = {
		907114,
		232,
		true
	},
	series_enemy_empty_commander_main = {
		907346,
		108,
		true
	},
	series_enemy_empty_commander_assistant = {
		907454,
		111,
		true
	},
	limit_team_character_tips = {
		907565,
		154,
		true
	},
	game_room_help = {
		907719,
		1337,
		true
	},
	game_cannot_go = {
		909056,
		113,
		true
	},
	game_ticket_notenough = {
		909169,
		143,
		true
	},
	game_ticket_max_all = {
		909312,
		204,
		true
	},
	game_ticket_max_month = {
		909516,
		206,
		true
	},
	game_icon_notenough = {
		909722,
		135,
		true
	},
	game_goldbyicon = {
		909857,
		131,
		true
	},
	game_icon_max = {
		909988,
		189,
		true
	},
	caibulin_tip1 = {
		910177,
		141,
		true
	},
	caibulin_tip2 = {
		910318,
		163,
		true
	},
	caibulin_tip3 = {
		910481,
		141,
		true
	},
	caibulin_tip4 = {
		910622,
		162,
		true
	},
	caibulin_tip5 = {
		910784,
		141,
		true
	},
	caibulin_tip6 = {
		910925,
		163,
		true
	},
	caibulin_tip7 = {
		911088,
		141,
		true
	},
	caibulin_tip8 = {
		911229,
		165,
		true
	},
	caibulin_tip9 = {
		911394,
		162,
		true
	},
	caibulin_tip10 = {
		911556,
		177,
		true
	},
	caibulin_help = {
		911733,
		510,
		true
	},
	caibulin_tip11 = {
		912243,
		167,
		true
	},
	caibulin_lock_tip = {
		912410,
		123,
		true
	},
	gametip_xiaoqiye = {
		912533,
		1526,
		true
	},
	event_recommend_level1 = {
		914059,
		176,
		true
	},
	doa_minigame_Luna = {
		914235,
		85,
		true
	},
	doa_minigame_Misaki = {
		914320,
		89,
		true
	},
	doa_minigame_Marie = {
		914409,
		92,
		true
	},
	doa_minigame_Tamaki = {
		914501,
		89,
		true
	},
	doa_minigame_help = {
		914590,
		294,
		true
	},
	gametip_xiaokewei = {
		914884,
		1529,
		true
	},
	doa_character_select_confirm = {
		916413,
		239,
		true
	},
	blueprint_combatperformance = {
		916652,
		102,
		true
	},
	blueprint_shipperformance = {
		916754,
		94,
		true
	},
	blueprint_researching = {
		916848,
		98,
		true
	},
	sculpture_drawline_tip = {
		916946,
		130,
		true
	},
	sculpture_drawline_done = {
		917076,
		151,
		true
	},
	sculpture_drawline_exit = {
		917227,
		181,
		true
	},
	sculpture_puzzle_tip = {
		917408,
		162,
		true
	},
	sculpture_gratitude_tip = {
		917570,
		131,
		true
	},
	sculpture_close_tip = {
		917701,
		97,
		true
	},
	gift_act_help = {
		917798,
		713,
		true
	},
	gift_act_drawline_help = {
		918511,
		722,
		true
	},
	gift_act_tips = {
		919233,
		92,
		true
	},
	expedition_award_tip = {
		919325,
		150,
		true
	},
	island_act_tips1 = {
		919475,
		94,
		true
	},
	haidaojudian_help = {
		919569,
		2479,
		true
	},
	haidaojudian_building_tip = {
		922048,
		139,
		true
	},
	workbench_help = {
		922187,
		653,
		true
	},
	workbench_need_materials = {
		922840,
		104,
		true
	},
	workbench_tips1 = {
		922944,
		103,
		true
	},
	workbench_tips2 = {
		923047,
		110,
		true
	},
	workbench_tips3 = {
		923157,
		117,
		true
	},
	workbench_tips4 = {
		923274,
		114,
		true
	},
	workbench_tips5 = {
		923388,
		114,
		true
	},
	workbench_tips6 = {
		923502,
		88,
		true
	},
	workbench_tips7 = {
		923590,
		88,
		true
	},
	workbench_tips8 = {
		923678,
		87,
		true
	},
	workbench_tips9 = {
		923765,
		95,
		true
	},
	workbench_tips10 = {
		923860,
		102,
		true
	},
	island_help = {
		923962,
		610,
		true
	},
	islandnode_tips1 = {
		924572,
		92,
		true
	},
	islandnode_tips2 = {
		924664,
		84,
		true
	},
	islandnode_tips3 = {
		924748,
		105,
		true
	},
	islandnode_tips4 = {
		924853,
		105,
		true
	},
	islandnode_tips5 = {
		924958,
		113,
		true
	},
	islandnode_tips6 = {
		925071,
		116,
		true
	},
	islandnode_tips7 = {
		925187,
		125,
		true
	},
	islandnode_tips8 = {
		925312,
		151,
		true
	},
	islandnode_tips9 = {
		925463,
		142,
		true
	},
	islandshop_tips1 = {
		925605,
		98,
		true
	},
	islandshop_tips2 = {
		925703,
		87,
		true
	},
	islandshop_tips3 = {
		925790,
		84,
		true
	},
	islandshop_tips4 = {
		925874,
		95,
		true
	},
	island_shop_limit_error = {
		925969,
		146,
		true
	},
	haidaojudian_upgrade_limit = {
		926115,
		154,
		true
	},
	chargetip_monthcard_1 = {
		926269,
		145,
		true
	},
	chargetip_monthcard_2 = {
		926414,
		145,
		true
	},
	chargetip_crusing = {
		926559,
		102,
		true
	},
	chargetip_giftpackage = {
		926661,
		141,
		true
	},
	package_view_1 = {
		926802,
		131,
		true
	},
	package_view_2 = {
		926933,
		143,
		true
	},
	package_view_3 = {
		927076,
		99,
		true
	},
	package_view_4 = {
		927175,
		87,
		true
	},
	probabilityskinshop_tip = {
		927262,
		175,
		true
	},
	skin_gift_desc = {
		927437,
		258,
		true
	},
	springtask_tip = {
		927695,
		307,
		true
	},
	island_build_desc = {
		928002,
		132,
		true
	},
	island_history_desc = {
		928134,
		146,
		true
	},
	island_build_level = {
		928280,
		91,
		true
	},
	island_game_limit_help = {
		928371,
		143,
		true
	},
	island_game_limit_num = {
		928514,
		94,
		true
	},
	ore_minigame_help = {
		928608,
		954,
		true
	},
	meta_shop_exchange_limit_2 = {
		929562,
		96,
		true
	},
	meta_shop_tip = {
		929658,
		138,
		true
	},
	pt_shop_tran_tip = {
		929796,
		275,
		true
	},
	urdraw_tip = {
		930071,
		125,
		true
	},
	urdraw_complement = {
		930196,
		170,
		true
	},
	meta_class_t_level_1 = {
		930366,
		95,
		true
	},
	meta_class_t_level_2 = {
		930461,
		102,
		true
	},
	meta_class_t_level_3 = {
		930563,
		99,
		true
	},
	meta_class_t_level_4 = {
		930662,
		100,
		true
	},
	meta_class_t_level_5 = {
		930762,
		99,
		true
	},
	meta_shop_exchange_limit_tip = {
		930861,
		121,
		true
	},
	meta_shop_exchange_limit_2_tip = {
		930982,
		143,
		true
	},
	charge_tip_crusing_label = {
		931125,
		101,
		true
	},
	mktea_1 = {
		931226,
		144,
		true
	},
	mktea_2 = {
		931370,
		155,
		true
	},
	mktea_3 = {
		931525,
		159,
		true
	},
	mktea_4 = {
		931684,
		233,
		true
	},
	mktea_5 = {
		931917,
		222,
		true
	},
	random_skin_list_item_desc_label = {
		932139,
		99,
		true
	},
	notice_input_desc = {
		932238,
		99,
		true
	},
	notice_label_send = {
		932337,
		85,
		true
	},
	notice_label_room = {
		932422,
		88,
		true
	},
	notice_label_recv = {
		932510,
		90,
		true
	},
	notice_label_tip = {
		932600,
		123,
		true
	},
	littleTaihou_npc = {
		932723,
		1477,
		true
	},
	disassemble_selected = {
		934200,
		92,
		true
	},
	disassemble_available = {
		934292,
		95,
		true
	},
	ship_formationUI_fleetName_challenge = {
		934387,
		115,
		true
	},
	ship_formationUI_fleetName_challenge_sub = {
		934502,
		119,
		true
	},
	word_status_activity = {
		934621,
		92,
		true
	},
	word_status_challenge = {
		934713,
		97,
		true
	},
	shipmodechange_reject_inactivity = {
		934810,
		188,
		true
	},
	shipmodechange_reject_inchallenge = {
		934998,
		192,
		true
	},
	battle_result_total_time = {
		935190,
		99,
		true
	},
	charge_game_room_coin_tip = {
		935289,
		193,
		true
	},
	game_room_shooting_tip = {
		935482,
		100,
		true
	},
	mini_game_shop_ticked_not_enough = {
		935582,
		154,
		true
	},
	game_ticket_current_month = {
		935736,
		103,
		true
	},
	game_icon_max_full = {
		935839,
		138,
		true
	},
	pre_combat_consume = {
		935977,
		87,
		true
	},
	file_down_msgbox = {
		936064,
		192,
		true
	},
	file_down_mgr_title = {
		936256,
		114,
		true
	},
	file_down_mgr_progress = {
		936370,
		91,
		true
	},
	file_down_mgr_error = {
		936461,
		157,
		true
	},
	last_building_not_shown = {
		936618,
		119,
		true
	},
	setting_group_prefs_tip = {
		936737,
		122,
		true
	},
	group_prefs_switch_tip = {
		936859,
		159,
		true
	},
	main_group_msgbox_content = {
		937018,
		184,
		true
	},
	word_maingroup_checking = {
		937202,
		98,
		true
	},
	word_maingroup_checktoupdate = {
		937300,
		107,
		true
	},
	word_maingroup_checkfailure = {
		937407,
		122,
		true
	},
	word_maingroup_updating = {
		937529,
		98,
		true
	},
	word_maingroup_idle = {
		937627,
		90,
		true
	},
	word_maingroup_latest = {
		937717,
		101,
		true
	},
	word_maingroup_updatesuccess = {
		937818,
		108,
		true
	},
	word_maingroup_updatefailure = {
		937926,
		125,
		true
	},
	group_download_tip = {
		938051,
		157,
		true
	},
	word_manga_checking = {
		938208,
		94,
		true
	},
	word_manga_checktoupdate = {
		938302,
		103,
		true
	},
	word_manga_checkfailure = {
		938405,
		118,
		true
	},
	word_manga_updating = {
		938523,
		98,
		true
	},
	word_manga_updatesuccess = {
		938621,
		104,
		true
	},
	word_manga_updatefailure = {
		938725,
		121,
		true
	},
	cryptolalia_lock_res = {
		938846,
		102,
		true
	},
	cryptolalia_not_download_res = {
		938948,
		113,
		true
	},
	cryptolalia_timelimie = {
		939061,
		92,
		true
	},
	cryptolalia_label_downloading = {
		939153,
		114,
		true
	},
	cryptolalia_delete_res = {
		939267,
		104,
		true
	},
	cryptolalia_delete_res_tip = {
		939371,
		133,
		true
	},
	cryptolalia_delete_res_title = {
		939504,
		105,
		true
	},
	cryptolalia_use_gem_title = {
		939609,
		105,
		true
	},
	cryptolalia_use_ticket_title = {
		939714,
		111,
		true
	},
	cryptolalia_exchange = {
		939825,
		94,
		true
	},
	cryptolalia_exchange_success = {
		939919,
		107,
		true
	},
	cryptolalia_list_title = {
		940026,
		93,
		true
	},
	cryptolalia_list_subtitle = {
		940119,
		100,
		true
	},
	cryptolalia_download_done = {
		940219,
		106,
		true
	},
	cryptolalia_coming_soom = {
		940325,
		101,
		true
	},
	cryptolalia_unopen = {
		940426,
		88,
		true
	},
	cryptolalia_no_ticket = {
		940514,
		164,
		true
	},
	cryptolalia_entrance_coming_soom = {
		940678,
		118,
		true
	},
	ship_formationUI_fleetName_sp = {
		940796,
		111,
		true
	},
	ship_formationUI_fleetName_sp_ss = {
		940907,
		118,
		true
	},
	activityboss_sp_all_buff = {
		941025,
		98,
		true
	},
	activityboss_sp_best_score = {
		941123,
		101,
		true
	},
	activityboss_sp_display_reward = {
		941224,
		106,
		true
	},
	activityboss_sp_score_bonus = {
		941330,
		103,
		true
	},
	activityboss_sp_active_buff = {
		941433,
		99,
		true
	},
	activityboss_sp_window_best_score = {
		941532,
		114,
		true
	},
	activityboss_sp_score_target = {
		941646,
		105,
		true
	},
	activityboss_sp_score = {
		941751,
		95,
		true
	},
	activityboss_sp_score_update = {
		941846,
		106,
		true
	},
	activityboss_sp_score_not_update = {
		941952,
		118,
		true
	},
	collect_page_got = {
		942070,
		89,
		true
	},
	charge_menu_month_tip = {
		942159,
		178,
		true
	},
	activity_shop_title = {
		942337,
		88,
		true
	},
	street_shop_title = {
		942425,
		85,
		true
	},
	military_shop_title = {
		942510,
		88,
		true
	},
	quota_shop_title1 = {
		942598,
		92,
		true
	},
	sham_shop_title = {
		942690,
		89,
		true
	},
	fragment_shop_title = {
		942779,
		88,
		true
	},
	guild_shop_title = {
		942867,
		85,
		true
	},
	medal_shop_title = {
		942952,
		85,
		true
	},
	meta_shop_title = {
		943037,
		83,
		true
	},
	mini_game_shop_title = {
		943120,
		89,
		true
	},
	metaskill_up = {
		943209,
		187,
		true
	},
	metaskill_overflow_tip = {
		943396,
		163,
		true
	},
	msgbox_repair_cipher = {
		943559,
		103,
		true
	},
	msgbox_repair_title = {
		943662,
		89,
		true
	},
	equip_skin_detail_count = {
		943751,
		93,
		true
	},
	faest_nothing_to_get = {
		943844,
		105,
		true
	},
	feast_click_to_close = {
		943949,
		98,
		true
	},
	feast_invitation_btn_label = {
		944047,
		108,
		true
	},
	feast_task_btn_label = {
		944155,
		96,
		true
	},
	feast_task_pt_label = {
		944251,
		91,
		true
	},
	feast_task_pt_level = {
		944342,
		89,
		true
	},
	feast_task_pt_get = {
		944431,
		91,
		true
	},
	feast_task_pt_got = {
		944522,
		88,
		true
	},
	feast_task_tag_daily = {
		944610,
		89,
		true
	},
	feast_task_tag_activity = {
		944699,
		94,
		true
	},
	feast_label_make_invitation = {
		944793,
		106,
		true
	},
	feast_no_invitation = {
		944899,
		108,
		true
	},
	feast_no_gift = {
		945007,
		96,
		true
	},
	feast_label_give_invitation = {
		945103,
		106,
		true
	},
	feast_label_give_invitation_finish = {
		945209,
		113,
		true
	},
	feast_label_give_gift = {
		945322,
		94,
		true
	},
	feast_label_give_gift_finish = {
		945416,
		105,
		true
	},
	feast_label_make_ticket_tip = {
		945521,
		151,
		true
	},
	feast_label_make_ticket_click_tip = {
		945672,
		118,
		true
	},
	feast_label_make_ticket_failed_tip = {
		945790,
		153,
		true
	},
	feast_res_window_title = {
		945943,
		93,
		true
	},
	feast_res_window_go_label = {
		946036,
		96,
		true
	},
	feast_tip = {
		946132,
		422,
		true
	},
	feast_invitation_part1 = {
		946554,
		134,
		true
	},
	feast_invitation_part2 = {
		946688,
		260,
		true
	},
	feast_invitation_part3 = {
		946948,
		278,
		true
	},
	feast_invitation_part4 = {
		947226,
		218,
		true
	},
	uscastle2023_help = {
		947444,
		1519,
		true
	},
	feast_cant_give_gift_tip = {
		948963,
		154,
		true
	},
	uscastle2023_minigame_help = {
		949117,
		367,
		true
	},
	feast_drag_invitation_tip = {
		949484,
		143,
		true
	},
	feast_drag_gift_tip = {
		949627,
		131,
		true
	},
	shoot_preview = {
		949758,
		91,
		true
	},
	hit_preview = {
		949849,
		90,
		true
	},
	story_label_skip = {
		949939,
		84,
		true
	},
	story_label_auto = {
		950023,
		84,
		true
	},
	launch_ball_skill_desc = {
		950107,
		93,
		true
	},
	launch_ball_hatsuduki_skill_1 = {
		950200,
		114,
		true
	},
	launch_ball_hatsuduki_skill_1_desc = {
		950314,
		172,
		true
	},
	launch_ball_hatsuduki_skill_2 = {
		950486,
		127,
		true
	},
	launch_ball_hatsuduki_skill_2_desc = {
		950613,
		334,
		true
	},
	launch_ball_shinano_skill_1 = {
		950947,
		113,
		true
	},
	launch_ball_shinano_skill_1_desc = {
		951060,
		193,
		true
	},
	launch_ball_shinano_skill_2 = {
		951253,
		121,
		true
	},
	launch_ball_shinano_skill_2_desc = {
		951374,
		257,
		true
	},
	launch_ball_yura_skill_1 = {
		951631,
		111,
		true
	},
	launch_ball_yura_skill_1_desc = {
		951742,
		169,
		true
	},
	launch_ball_yura_skill_2 = {
		951911,
		120,
		true
	},
	launch_ball_yura_skill_2_desc = {
		952031,
		206,
		true
	},
	launch_ball_shimakaze_skill_1 = {
		952237,
		124,
		true
	},
	launch_ball_shimakaze_skill_1_desc = {
		952361,
		225,
		true
	},
	launch_ball_shimakaze_skill_2 = {
		952586,
		121,
		true
	},
	launch_ball_shimakaze_skill_2_desc = {
		952707,
		202,
		true
	},
	jp6th_spring_tip1 = {
		952909,
		172,
		true
	},
	jp6th_spring_tip2 = {
		953081,
		104,
		true
	},
	jp6th_biaohoushan_help = {
		953185,
		1312,
		true
	},
	jp6th_lihoushan_help = {
		954497,
		2540,
		true
	},
	jp6th_lihoushan_time = {
		957037,
		125,
		true
	},
	jp6th_lihoushan_order = {
		957162,
		138,
		true
	},
	jp6th_lihoushan_pt1 = {
		957300,
		98,
		true
	},
	launchball_minigame_help = {
		957398,
		357,
		true
	},
	launchball_minigame_select = {
		957755,
		106,
		true
	},
	launchball_minigame_un_select = {
		957861,
		122,
		true
	},
	launchball_minigame_shop = {
		957983,
		106,
		true
	},
	launchball_lock_Shinano = {
		958089,
		172,
		true
	},
	launchball_lock_Yura = {
		958261,
		166,
		true
	},
	launchball_lock_Shimakaze = {
		958427,
		176,
		true
	},
	launchball_spilt_series = {
		958603,
		162,
		true
	},
	launchball_spilt_mix = {
		958765,
		311,
		true
	},
	launchball_spilt_over = {
		959076,
		224,
		true
	},
	launchball_spilt_many = {
		959300,
		152,
		true
	},
	luckybag_skin_isani = {
		959452,
		90,
		true
	},
	luckybag_skin_islive2d = {
		959542,
		93,
		true
	},
	SkinMagazinePage2_tip = {
		959635,
		92,
		true
	},
	racing_cost = {
		959727,
		86,
		true
	},
	racing_rank_top_text = {
		959813,
		98,
		true
	},
	racing_rank_half_h = {
		959911,
		102,
		true
	},
	racing_rank_no_data = {
		960013,
		101,
		true
	},
	racing_minigame_help = {
		960114,
		357,
		true
	},
	child_msg_title_detail = {
		960471,
		93,
		true
	},
	child_msg_title_tip = {
		960564,
		87,
		true
	},
	child_msg_owned = {
		960651,
		88,
		true
	},
	child_polaroid_get_tip = {
		960739,
		135,
		true
	},
	child_close_tip = {
		960874,
		101,
		true
	},
	word_month = {
		960975,
		79,
		true
	},
	word_which_month = {
		961054,
		88,
		true
	},
	word_which_week = {
		961142,
		86,
		true
	},
	word_in_one_week = {
		961228,
		89,
		true
	},
	word_week_title = {
		961317,
		82,
		true
	},
	word_harbour = {
		961399,
		80,
		true
	},
	child_btn_target = {
		961479,
		85,
		true
	},
	child_btn_collect = {
		961564,
		89,
		true
	},
	child_btn_mind = {
		961653,
		86,
		true
	},
	child_btn_bag = {
		961739,
		82,
		true
	},
	child_btn_news = {
		961821,
		90,
		true
	},
	child_main_help = {
		961911,
		526,
		true
	},
	child_archive_name = {
		962437,
		86,
		true
	},
	child_news_import_title = {
		962523,
		99,
		true
	},
	child_news_other_title = {
		962622,
		101,
		true
	},
	child_favor_progress = {
		962723,
		96,
		true
	},
	child_favor_lock1 = {
		962819,
		96,
		true
	},
	child_favor_lock2 = {
		962915,
		96,
		true
	},
	child_target_lock_tip = {
		963011,
		136,
		true
	},
	child_target_progress = {
		963147,
		96,
		true
	},
	child_target_finish_tip = {
		963243,
		117,
		true
	},
	child_target_time_title = {
		963360,
		97,
		true
	},
	child_target_title1 = {
		963457,
		92,
		true
	},
	child_target_title2 = {
		963549,
		94,
		true
	},
	child_item_type0 = {
		963643,
		83,
		true
	},
	child_item_type1 = {
		963726,
		85,
		true
	},
	child_item_type2 = {
		963811,
		91,
		true
	},
	child_item_type3 = {
		963902,
		85,
		true
	},
	child_item_type4 = {
		963987,
		85,
		true
	},
	child_mind_empty_tip = {
		964072,
		124,
		true
	},
	child_mind_finish_title = {
		964196,
		96,
		true
	},
	child_mind_processing_title = {
		964292,
		102,
		true
	},
	child_mind_time_title = {
		964394,
		95,
		true
	},
	child_collect_lock = {
		964489,
		88,
		true
	},
	child_nature_title = {
		964577,
		94,
		true
	},
	child_btn_review = {
		964671,
		87,
		true
	},
	child_schedule_empty_tip = {
		964758,
		132,
		true
	},
	child_schedule_event_tip = {
		964890,
		136,
		true
	},
	child_schedule_sure_tip = {
		965026,
		189,
		true
	},
	child_schedule_sure_tip2 = {
		965215,
		146,
		true
	},
	child_plan_check_tip1 = {
		965361,
		152,
		true
	},
	child_plan_check_tip2 = {
		965513,
		141,
		true
	},
	child_plan_check_tip3 = {
		965654,
		166,
		true
	},
	child_plan_check_tip4 = {
		965820,
		132,
		true
	},
	child_plan_check_tip5 = {
		965952,
		133,
		true
	},
	child_plan_event = {
		966085,
		96,
		true
	},
	child_btn_home = {
		966181,
		85,
		true
	},
	child_option_limit = {
		966266,
		89,
		true
	},
	child_shop_tip1 = {
		966355,
		117,
		true
	},
	child_shop_tip2 = {
		966472,
		112,
		true
	},
	child_filter_title = {
		966584,
		88,
		true
	},
	child_filter_type1 = {
		966672,
		95,
		true
	},
	child_filter_type2 = {
		966767,
		93,
		true
	},
	child_filter_type3 = {
		966860,
		91,
		true
	},
	child_plan_type1 = {
		966951,
		86,
		true
	},
	child_plan_type2 = {
		967037,
		87,
		true
	},
	child_plan_type3 = {
		967124,
		95,
		true
	},
	child_plan_type4 = {
		967219,
		89,
		true
	},
	child_filter_award_res = {
		967308,
		91,
		true
	},
	child_filter_award_nature = {
		967399,
		100,
		true
	},
	child_filter_award_attr1 = {
		967499,
		93,
		true
	},
	child_filter_award_attr2 = {
		967592,
		97,
		true
	},
	child_mood_desc1 = {
		967689,
		149,
		true
	},
	child_mood_desc2 = {
		967838,
		143,
		true
	},
	child_mood_desc3 = {
		967981,
		145,
		true
	},
	child_mood_desc4 = {
		968126,
		145,
		true
	},
	child_mood_desc5 = {
		968271,
		145,
		true
	},
	child_stage_desc1 = {
		968416,
		95,
		true
	},
	child_stage_desc2 = {
		968511,
		95,
		true
	},
	child_stage_desc3 = {
		968606,
		95,
		true
	},
	child_default_callname = {
		968701,
		95,
		true
	},
	flagship_display_mode_1 = {
		968796,
		118,
		true
	},
	flagship_display_mode_2 = {
		968914,
		117,
		true
	},
	flagship_display_mode_3 = {
		969031,
		95,
		true
	},
	flagship_educate_slot_lock_tip = {
		969126,
		184,
		true
	},
	child_story_name = {
		969310,
		89,
		true
	},
	secretary_special_name = {
		969399,
		88,
		true
	},
	secretary_special_lock_tip = {
		969487,
		101,
		true
	},
	secretary_special_title_age = {
		969588,
		109,
		true
	},
	secretary_special_title_physiognomy = {
		969697,
		117,
		true
	},
	child_plan_skip = {
		969814,
		93,
		true
	},
	child_attr_name1 = {
		969907,
		85,
		true
	},
	child_attr_name2 = {
		969992,
		89,
		true
	},
	child_task_system_type2 = {
		970081,
		93,
		true
	},
	child_task_system_type3 = {
		970174,
		91,
		true
	},
	child_plan_perform_title = {
		970265,
		104,
		true
	},
	child_date_text1 = {
		970369,
		93,
		true
	},
	child_date_text2 = {
		970462,
		96,
		true
	},
	child_date_text3 = {
		970558,
		94,
		true
	},
	child_date_text4 = {
		970652,
		93,
		true
	},
	child_upgrade_sure_tip = {
		970745,
		231,
		true
	},
	child_school_sure_tip = {
		970976,
		212,
		true
	},
	child_extraAttr_sure_tip = {
		971188,
		140,
		true
	},
	child_reset_sure_tip = {
		971328,
		172,
		true
	},
	child_end_sure_tip = {
		971500,
		104,
		true
	},
	child_buff_name = {
		971604,
		85,
		true
	},
	child_unlock_tip = {
		971689,
		86,
		true
	},
	child_unlock_out = {
		971775,
		90,
		true
	},
	child_unlock_memory = {
		971865,
		91,
		true
	},
	child_unlock_polaroid = {
		971956,
		92,
		true
	},
	child_unlock_ending = {
		972048,
		90,
		true
	},
	child_unlock_intimacy = {
		972138,
		94,
		true
	},
	child_unlock_buff = {
		972232,
		87,
		true
	},
	child_unlock_attr2 = {
		972319,
		93,
		true
	},
	child_unlock_attr3 = {
		972412,
		91,
		true
	},
	child_unlock_bag = {
		972503,
		85,
		true
	},
	child_shop_empty_tip = {
		972588,
		101,
		true
	},
	child_bag_empty_tip = {
		972689,
		101,
		true
	},
	levelscene_deploy_submarine = {
		972790,
		105,
		true
	},
	levelscene_deploy_submarine_cancel = {
		972895,
		104,
		true
	},
	levelscene_airexpel_cancel = {
		972999,
		96,
		true
	},
	levelscene_airexpel_select_enemy = {
		973095,
		131,
		true
	},
	levelscene_airexpel_outrange = {
		973226,
		137,
		true
	},
	levelscene_airexpel_select_boss = {
		973363,
		141,
		true
	},
	levelscene_airexpel_select_battle = {
		973504,
		154,
		true
	},
	levelscene_airexpel_select_confirm_left = {
		973658,
		204,
		true
	},
	levelscene_airexpel_select_confirm_right = {
		973862,
		206,
		true
	},
	levelscene_airexpel_select_confirm_up = {
		974068,
		193,
		true
	},
	levelscene_airexpel_select_confirm_down = {
		974261,
		197,
		true
	},
	shipyard_phase_1 = {
		974458,
		929,
		true
	},
	shipyard_phase_2 = {
		975387,
		86,
		true
	},
	shipyard_button_1 = {
		975473,
		91,
		true
	},
	shipyard_button_2 = {
		975564,
		153,
		true
	},
	shipyard_introduce = {
		975717,
		246,
		true
	},
	help_supportfleet = {
		975963,
		358,
		true
	},
	help_supportfleet_16 = {
		976321,
		363,
		true
	},
	help_supportfleet_16_submarine = {
		976684,
		391,
		true
	},
	word_status_inSupportFleet = {
		977075,
		106,
		true
	},
	ship_formationMediator_request_replace_support = {
		977181,
		190,
		true
	},
	courtyard_label_train = {
		977371,
		90,
		true
	},
	courtyard_label_rest = {
		977461,
		88,
		true
	},
	courtyard_label_capacity = {
		977549,
		96,
		true
	},
	courtyard_label_share = {
		977645,
		90,
		true
	},
	courtyard_label_shop = {
		977735,
		88,
		true
	},
	courtyard_label_decoration = {
		977823,
		94,
		true
	},
	courtyard_label_template = {
		977917,
		94,
		true
	},
	courtyard_label_floor = {
		978011,
		91,
		true
	},
	courtyard_label_exp_addition = {
		978102,
		101,
		true
	},
	courtyard_label_total_exp_addition = {
		978203,
		114,
		true
	},
	courtyard_label_comfortable_addition = {
		978317,
		116,
		true
	},
	courtyard_label_placed_furniture = {
		978433,
		112,
		true
	},
	courtyard_label_shop_1 = {
		978545,
		90,
		true
	},
	courtyard_label_clear = {
		978635,
		90,
		true
	},
	courtyard_label_save = {
		978725,
		88,
		true
	},
	courtyard_label_save_theme = {
		978813,
		100,
		true
	},
	courtyard_label_using = {
		978913,
		103,
		true
	},
	courtyard_label_search_holder = {
		979016,
		105,
		true
	},
	courtyard_label_filter = {
		979121,
		92,
		true
	},
	courtyard_label_time = {
		979213,
		88,
		true
	},
	courtyard_label_week = {
		979301,
		93,
		true
	},
	courtyard_label_month = {
		979394,
		94,
		true
	},
	courtyard_label_year = {
		979488,
		93,
		true
	},
	courtyard_label_putlist_title = {
		979581,
		114,
		true
	},
	courtyard_label_custom_theme = {
		979695,
		102,
		true
	},
	courtyard_label_system_theme = {
		979797,
		99,
		true
	},
	courtyard_tip_furniture_not_in_layer = {
		979896,
		142,
		true
	},
	courtyard_label_detail = {
		980038,
		93,
		true
	},
	courtyard_label_place_pnekey = {
		980131,
		103,
		true
	},
	courtyard_label_delete = {
		980234,
		92,
		true
	},
	courtyard_label_cancel_share = {
		980326,
		104,
		true
	},
	courtyard_label_empty_template_list = {
		980430,
		139,
		true
	},
	courtyard_label_empty_custom_template_list = {
		980569,
		195,
		true
	},
	courtyard_label_empty_collection_list = {
		980764,
		135,
		true
	},
	courtyard_label_go = {
		980899,
		89,
		true
	},
	mot_class_t_level_1 = {
		980988,
		97,
		true
	},
	mot_class_t_level_2 = {
		981085,
		98,
		true
	},
	equip_share_label_1 = {
		981183,
		99,
		true
	},
	equip_share_label_2 = {
		981282,
		100,
		true
	},
	equip_share_label_3 = {
		981382,
		99,
		true
	},
	equip_share_label_4 = {
		981481,
		96,
		true
	},
	equip_share_label_5 = {
		981577,
		95,
		true
	},
	equip_share_label_6 = {
		981672,
		99,
		true
	},
	equip_share_label_7 = {
		981771,
		87,
		true
	},
	equip_share_label_8 = {
		981858,
		90,
		true
	},
	equip_share_label_9 = {
		981948,
		87,
		true
	},
	equipcode_input = {
		982035,
		104,
		true
	},
	equipcode_slot_unmatch = {
		982139,
		153,
		true
	},
	equipcode_share_nolabel = {
		982292,
		132,
		true
	},
	equipcode_share_exceedlimit = {
		982424,
		124,
		true
	},
	equipcode_illegal = {
		982548,
		116,
		true
	},
	equipcode_confirm_doublecheck = {
		982664,
		137,
		true
	},
	equipcode_import_success = {
		982801,
		132,
		true
	},
	equipcode_share_success = {
		982933,
		128,
		true
	},
	equipcode_like_limited = {
		983061,
		138,
		true
	},
	equipcode_like_success = {
		983199,
		102,
		true
	},
	equipcode_dislike_success = {
		983301,
		115,
		true
	},
	equipcode_report_type_1 = {
		983416,
		118,
		true
	},
	equipcode_report_type_2 = {
		983534,
		110,
		true
	},
	equipcode_report_warning = {
		983644,
		150,
		true
	},
	equipcode_level_unmatched = {
		983794,
		100,
		true
	},
	equipcode_equipment_unowned = {
		983894,
		103,
		true
	},
	equipcode_diff_selected = {
		983997,
		101,
		true
	},
	equipcode_export_success = {
		984098,
		105,
		true
	},
	equipcode_unsaved_tips = {
		984203,
		154,
		true
	},
	equipcode_share_ruletips = {
		984357,
		139,
		true
	},
	equipcode_share_errorcode7 = {
		984496,
		146,
		true
	},
	equipcode_share_errorcode44 = {
		984642,
		137,
		true
	},
	equipcode_share_title = {
		984779,
		93,
		true
	},
	equipcode_share_titleeng = {
		984872,
		96,
		true
	},
	equipcode_share_listempty = {
		984968,
		115,
		true
	},
	equipcode_equip_occupied = {
		985083,
		94,
		true
	},
	sail_boat_equip_tip_1 = {
		985177,
		206,
		true
	},
	sail_boat_equip_tip_2 = {
		985383,
		215,
		true
	},
	sail_boat_equip_tip_3 = {
		985598,
		218,
		true
	},
	sail_boat_equip_tip_4 = {
		985816,
		210,
		true
	},
	sail_boat_equip_tip_5 = {
		986026,
		191,
		true
	},
	sail_boat_minigame_help = {
		986217,
		356,
		true
	},
	pirate_wanted_help = {
		986573,
		448,
		true
	},
	harbor_backhill_help = {
		987021,
		1172,
		true
	},
	cryptolalia_download_task_already_exists = {
		988193,
		135,
		true
	},
	charge_scene_buy_confirm_backyard = {
		988328,
		168,
		true
	},
	roll_room1 = {
		988496,
		88,
		true
	},
	roll_room2 = {
		988584,
		88,
		true
	},
	roll_room3 = {
		988672,
		84,
		true
	},
	roll_room4 = {
		988756,
		83,
		true
	},
	roll_room5 = {
		988839,
		85,
		true
	},
	roll_room6 = {
		988924,
		92,
		true
	},
	roll_room7 = {
		989016,
		85,
		true
	},
	roll_room8 = {
		989101,
		81,
		true
	},
	roll_room9 = {
		989182,
		86,
		true
	},
	roll_room10 = {
		989268,
		91,
		true
	},
	roll_room11 = {
		989359,
		89,
		true
	},
	roll_room12 = {
		989448,
		90,
		true
	},
	roll_room13 = {
		989538,
		89,
		true
	},
	roll_room14 = {
		989627,
		87,
		true
	},
	roll_room15 = {
		989714,
		80,
		true
	},
	roll_room16 = {
		989794,
		86,
		true
	},
	roll_room17 = {
		989880,
		81,
		true
	},
	roll_attr_list = {
		989961,
		693,
		true
	},
	roll_notimes = {
		990654,
		142,
		true
	},
	roll_tip2 = {
		990796,
		137,
		true
	},
	roll_reward_word1 = {
		990933,
		89,
		true
	},
	roll_reward_word2 = {
		991022,
		90,
		true
	},
	roll_reward_word3 = {
		991112,
		90,
		true
	},
	roll_reward_word4 = {
		991202,
		90,
		true
	},
	roll_reward_word5 = {
		991292,
		90,
		true
	},
	roll_reward_word6 = {
		991382,
		90,
		true
	},
	roll_reward_word7 = {
		991472,
		90,
		true
	},
	roll_reward_word8 = {
		991562,
		87,
		true
	},
	roll_reward_tip = {
		991649,
		94,
		true
	},
	roll_unlock = {
		991743,
		126,
		true
	},
	roll_noname = {
		991869,
		116,
		true
	},
	roll_card_info = {
		991985,
		85,
		true
	},
	roll_card_attr = {
		992070,
		83,
		true
	},
	roll_card_skill = {
		992153,
		85,
		true
	},
	roll_times_left = {
		992238,
		93,
		true
	},
	roll_room_unexplored = {
		992331,
		87,
		true
	},
	roll_reward_got = {
		992418,
		86,
		true
	},
	roll_gametip = {
		992504,
		1639,
		true
	},
	roll_ending_tip1 = {
		994143,
		157,
		true
	},
	roll_ending_tip2 = {
		994300,
		141,
		true
	},
	commandercat_label_raw_name = {
		994441,
		104,
		true
	},
	commandercat_label_custom_name = {
		994545,
		105,
		true
	},
	commandercat_label_display_name = {
		994650,
		106,
		true
	},
	commander_selected_max = {
		994756,
		127,
		true
	},
	word_talent = {
		994883,
		82,
		true
	},
	word_click_to_close = {
		994965,
		95,
		true
	},
	commander_subtile_ablity = {
		995060,
		104,
		true
	},
	commander_subtile_talent = {
		995164,
		102,
		true
	},
	commander_confirm_tip = {
		995266,
		130,
		true
	},
	commander_level_up_tip = {
		995396,
		122,
		true
	},
	commander_skill_effect = {
		995518,
		99,
		true
	},
	commander_choice_talent_1 = {
		995617,
		127,
		true
	},
	commander_choice_talent_2 = {
		995744,
		106,
		true
	},
	commander_choice_talent_3 = {
		995850,
		132,
		true
	},
	commander_get_box_tip_1 = {
		995982,
		102,
		true
	},
	commander_get_box_tip = {
		996084,
		113,
		true
	},
	commander_total_gold = {
		996197,
		95,
		true
	},
	commander_use_box_tip = {
		996292,
		101,
		true
	},
	commander_use_box_queue = {
		996393,
		95,
		true
	},
	commander_command_ability = {
		996488,
		99,
		true
	},
	commander_logistics_ability = {
		996587,
		100,
		true
	},
	commander_tactical_ability = {
		996687,
		97,
		true
	},
	commander_choice_talent_4 = {
		996784,
		147,
		true
	},
	commander_rename_tip = {
		996931,
		145,
		true
	},
	commander_home_level_label = {
		997076,
		103,
		true
	},
	commander_get_commander_coptyright = {
		997179,
		117,
		true
	},
	commander_choice_talent_reset = {
		997296,
		236,
		true
	},
	commander_lock_setting_title = {
		997532,
		180,
		true
	},
	skin_exchange_confirm = {
		997712,
		162,
		true
	},
	skin_purchase_confirm = {
		997874,
		238,
		true
	},
	blackfriday_pack_lock = {
		998112,
		126,
		true
	},
	skin_exchange_title = {
		998238,
		99,
		true
	},
	blackfriday_pack_select_skinall = {
		998337,
		257,
		true
	},
	skin_discount_desc = {
		998594,
		137,
		true
	},
	skin_exchange_timelimit = {
		998731,
		198,
		true
	},
	blackfriday_pack_purchased = {
		998929,
		99,
		true
	},
	commander_unsel_lock_flag_tip = {
		999028,
		200,
		true
	},
	skin_discount_timelimit = {
		999228,
		175,
		true
	},
	shan_luan_task_progress_tip = {
		999403,
		104,
		true
	},
	shan_luan_task_level_tip = {
		999507,
		104,
		true
	},
	shan_luan_task_help = {
		999611,
		876,
		true
	},
	shan_luan_task_buff_default = {
		1000487,
		94,
		true
	},
	senran_pt_consume_tip = {
		1000581,
		228,
		true
	},
	senran_pt_not_enough = {
		1000809,
		139,
		true
	},
	senran_pt_help = {
		1000948,
		595,
		true
	},
	senran_pt_rank = {
		1001543,
		101,
		true
	},
	senran_pt_words_feiniao = {
		1001644,
		420,
		true
	},
	senran_pt_words_banjiu = {
		1002064,
		524,
		true
	},
	senran_pt_words_yan = {
		1002588,
		419,
		true
	},
	senran_pt_words_xuequan = {
		1003007,
		453,
		true
	},
	senran_pt_words_xuebugui = {
		1003460,
		433,
		true
	},
	senran_pt_words_zi = {
		1003893,
		394,
		true
	},
	senran_pt_words_xishao = {
		1004287,
		392,
		true
	},
	senrankagura_backhill_help = {
		1004679,
		1252,
		true
	},
	dorm3d_furnitrue_type_wallpaper = {
		1005931,
		105,
		true
	},
	dorm3d_furnitrue_type_floor = {
		1006036,
		99,
		true
	},
	dorm3d_furnitrue_type_decoration = {
		1006135,
		107,
		true
	},
	dorm3d_furnitrue_type_bed = {
		1006242,
		93,
		true
	},
	dorm3d_furnitrue_type_couch = {
		1006335,
		98,
		true
	},
	dorm3d_furnitrue_type_table = {
		1006433,
		97,
		true
	},
	vote_lable_not_start = {
		1006530,
		90,
		true
	},
	vote_lable_voting = {
		1006620,
		92,
		true
	},
	vote_lable_title = {
		1006712,
		173,
		true
	},
	vote_lable_acc_title_1 = {
		1006885,
		97,
		true
	},
	vote_lable_acc_title_2 = {
		1006982,
		98,
		true
	},
	vote_lable_curr_title_1 = {
		1007080,
		103,
		true
	},
	vote_lable_curr_title_2 = {
		1007183,
		104,
		true
	},
	vote_lable_window_title = {
		1007287,
		94,
		true
	},
	vote_lable_rearch = {
		1007381,
		90,
		true
	},
	vote_lable_daily_task_title = {
		1007471,
		98,
		true
	},
	vote_lable_daily_task_tip = {
		1007569,
		138,
		true
	},
	vote_lable_task_title = {
		1007707,
		96,
		true
	},
	vote_lable_task_list_is_empty = {
		1007803,
		124,
		true
	},
	vote_lable_ship_votes = {
		1007927,
		95,
		true
	},
	vote_help_2023 = {
		1008022,
		5208,
		true
	},
	vote_tip_level_limit = {
		1013230,
		139,
		true
	},
	vote_label_rank = {
		1013369,
		83,
		true
	},
	vote_label_rank_fresh_time_tip = {
		1013452,
		135,
		true
	},
	vote_tip_area_closed = {
		1013587,
		102,
		true
	},
	commander_skill_ui_info = {
		1013689,
		91,
		true
	},
	commander_skill_ui_confirm = {
		1013780,
		97,
		true
	},
	commander_formation_prefab_fleet = {
		1013877,
		102,
		true
	},
	rect_ship_card_tpl_add = {
		1013979,
		96,
		true
	},
	newyear2024_backhill_help = {
		1014075,
		1024,
		true
	},
	last_times_sign = {
		1015099,
		100,
		true
	},
	skin_page_sign = {
		1015199,
		83,
		true
	},
	skin_page_desc = {
		1015282,
		178,
		true
	},
	live2d_reset_desc = {
		1015460,
		110,
		true
	},
	skin_exchange_usetip = {
		1015570,
		138,
		true
	},
	blackfriday_pack_select_skinall_dialog = {
		1015708,
		211,
		true
	},
	not_use_ticket_to_buy_skin = {
		1015919,
		113,
		true
	},
	skin_purchase_over_price = {
		1016032,
		337,
		true
	},
	help_chunjie2024 = {
		1016369,
		1357,
		true
	},
	child_random_polaroid_drop = {
		1017726,
		97,
		true
	},
	child_random_ops_drop = {
		1017823,
		99,
		true
	},
	child_refresh_sure_tip = {
		1017922,
		118,
		true
	},
	child_target_set_sure_tip = {
		1018040,
		225,
		true
	},
	child_polaroid_lock_tip = {
		1018265,
		128,
		true
	},
	child_task_finish_all = {
		1018393,
		115,
		true
	},
	child_unlock_new_secretary = {
		1018508,
		197,
		true
	},
	child_no_resource = {
		1018705,
		103,
		true
	},
	child_target_set_empty = {
		1018808,
		110,
		true
	},
	child_target_set_skip = {
		1018918,
		132,
		true
	},
	child_news_import_empty = {
		1019050,
		130,
		true
	},
	child_news_other_empty = {
		1019180,
		116,
		true
	},
	word_week_day1 = {
		1019296,
		84,
		true
	},
	word_week_day2 = {
		1019380,
		85,
		true
	},
	word_week_day3 = {
		1019465,
		87,
		true
	},
	word_week_day4 = {
		1019552,
		86,
		true
	},
	word_week_day5 = {
		1019638,
		84,
		true
	},
	word_week_day6 = {
		1019722,
		86,
		true
	},
	word_week_day7 = {
		1019808,
		84,
		true
	},
	child_shop_price_title = {
		1019892,
		92,
		true
	},
	child_callname_tip = {
		1019984,
		104,
		true
	},
	child_plan_no_cost = {
		1020088,
		93,
		true
	},
	word_emoji_unlock = {
		1020181,
		102,
		true
	},
	word_get_emoji = {
		1020283,
		86,
		true
	},
	word_show_extra_reward_at_fudai_dialog = {
		1020369,
		136,
		true
	},
	skin_shop_buy_confirm = {
		1020505,
		166,
		true
	},
	activity_victory = {
		1020671,
		106,
		true
	},
	other_world_temple_toggle_1 = {
		1020777,
		106,
		true
	},
	other_world_temple_toggle_2 = {
		1020883,
		108,
		true
	},
	other_world_temple_toggle_3 = {
		1020991,
		107,
		true
	},
	other_world_temple_char = {
		1021098,
		96,
		true
	},
	other_world_temple_award = {
		1021194,
		101,
		true
	},
	other_world_temple_got = {
		1021295,
		93,
		true
	},
	other_world_temple_progress = {
		1021388,
		136,
		true
	},
	other_world_temple_char_title = {
		1021524,
		102,
		true
	},
	other_world_temple_award_last = {
		1021626,
		108,
		true
	},
	other_world_temple_award_title_1 = {
		1021734,
		122,
		true
	},
	other_world_temple_award_title_2 = {
		1021856,
		124,
		true
	},
	other_world_temple_award_title_3 = {
		1021980,
		123,
		true
	},
	other_world_temple_lottery_all = {
		1022103,
		123,
		true
	},
	other_world_temple_award_desc = {
		1022226,
		163,
		true
	},
	temple_consume_not_enough = {
		1022389,
		111,
		true
	},
	other_world_temple_pay = {
		1022500,
		101,
		true
	},
	other_world_task_type_daily = {
		1022601,
		96,
		true
	},
	other_world_task_type_main = {
		1022697,
		94,
		true
	},
	other_world_task_type_repeat = {
		1022791,
		106,
		true
	},
	other_world_task_title = {
		1022897,
		100,
		true
	},
	other_world_task_get_all = {
		1022997,
		97,
		true
	},
	other_world_task_go = {
		1023094,
		90,
		true
	},
	other_world_task_got = {
		1023184,
		91,
		true
	},
	other_world_task_get = {
		1023275,
		90,
		true
	},
	other_world_task_tag_main = {
		1023365,
		93,
		true
	},
	other_world_task_tag_daily = {
		1023458,
		95,
		true
	},
	other_world_task_tag_all = {
		1023553,
		91,
		true
	},
	terminal_personal_title = {
		1023644,
		101,
		true
	},
	terminal_adventure_title = {
		1023745,
		102,
		true
	},
	terminal_guardian_title = {
		1023847,
		96,
		true
	},
	personal_info_title = {
		1023943,
		93,
		true
	},
	personal_property_title = {
		1024036,
		92,
		true
	},
	personal_ability_title = {
		1024128,
		92,
		true
	},
	adventure_award_title = {
		1024220,
		108,
		true
	},
	adventure_progress_title = {
		1024328,
		102,
		true
	},
	adventure_lv_title = {
		1024430,
		99,
		true
	},
	adventure_record_title = {
		1024529,
		99,
		true
	},
	adventure_record_grade_title = {
		1024628,
		108,
		true
	},
	adventure_award_end_tip = {
		1024736,
		114,
		true
	},
	guardian_select_title = {
		1024850,
		100,
		true
	},
	guardian_sure_btn = {
		1024950,
		85,
		true
	},
	guardian_cancel_btn = {
		1025035,
		89,
		true
	},
	guardian_active_tip = {
		1025124,
		89,
		true
	},
	personal_random = {
		1025213,
		94,
		true
	},
	adventure_get_all = {
		1025307,
		90,
		true
	},
	Announcements_Event_Notice = {
		1025397,
		95,
		true
	},
	Announcements_System_Notice = {
		1025492,
		97,
		true
	},
	Announcements_News = {
		1025589,
		86,
		true
	},
	Announcements_Donotshow = {
		1025675,
		109,
		true
	},
	adventure_unlock_tip = {
		1025784,
		170,
		true
	},
	personal_random_tip = {
		1025954,
		139,
		true
	},
	guardian_sure_limit_tip = {
		1026093,
		123,
		true
	},
	other_world_temple_tip = {
		1026216,
		533,
		true
	},
	otherworld_map_help = {
		1026749,
		530,
		true
	},
	otherworld_backhill_help = {
		1027279,
		535,
		true
	},
	otherworld_terminal_help = {
		1027814,
		535,
		true
	},
	vote_2023_reward_word_1 = {
		1028349,
		207,
		true
	},
	vote_2023_reward_word_2 = {
		1028556,
		357,
		true
	},
	vote_2023_reward_word_3 = {
		1028913,
		354,
		true
	},
	voting_page_reward = {
		1029267,
		87,
		true
	},
	backyard_shipAddInimacy_ships_ok = {
		1029354,
		177,
		true
	},
	backyard_shipAddMoney_ships_ok = {
		1029531,
		201,
		true
	},
	idol3rd_houshan = {
		1029732,
		1145,
		true
	},
	idol3rd_collection = {
		1030877,
		800,
		true
	},
	idol3rd_practice = {
		1031677,
		944,
		true
	},
	dorm3d_furniture_window_acesses = {
		1032621,
		106,
		true
	},
	dorm3d_furniture_count = {
		1032727,
		96,
		true
	},
	dorm3d_furniture_used = {
		1032823,
		116,
		true
	},
	dorm3d_furniture_lack = {
		1032939,
		97,
		true
	},
	dorm3d_furniture_unfit = {
		1033036,
		94,
		true
	},
	dorm3d_waiting = {
		1033130,
		88,
		true
	},
	dorm3d_daily_favor = {
		1033218,
		102,
		true
	},
	dorm3d_favor_level = {
		1033320,
		95,
		true
	},
	dorm3d_time_choose = {
		1033415,
		93,
		true
	},
	dorm3d_now_time = {
		1033508,
		91,
		true
	},
	dorm3d_is_auto_time = {
		1033599,
		106,
		true
	},
	dorm3d_clothing_choose = {
		1033705,
		100,
		true
	},
	dorm3d_now_clothing = {
		1033805,
		90,
		true
	},
	dorm3d_talk = {
		1033895,
		79,
		true
	},
	dorm3d_touch = {
		1033974,
		84,
		true
	},
	dorm3d_gift = {
		1034058,
		79,
		true
	},
	dorm3d_gift_owner_num = {
		1034137,
		94,
		true
	},
	dorm3d_unlock_tips = {
		1034231,
		105,
		true
	},
	dorm3d_daily_favor_tips = {
		1034336,
		107,
		true
	},
	main_silent_tip_1 = {
		1034443,
		109,
		true
	},
	main_silent_tip_2 = {
		1034552,
		110,
		true
	},
	main_silent_tip_3 = {
		1034662,
		110,
		true
	},
	main_silent_tip_4 = {
		1034772,
		115,
		true
	},
	main_silent_tip_5 = {
		1034887,
		111,
		true
	},
	main_silent_tip_6 = {
		1034998,
		113,
		true
	},
	commission_label_go = {
		1035111,
		90,
		true
	},
	commission_label_finish = {
		1035201,
		95,
		true
	},
	commission_label_go_mellow = {
		1035296,
		97,
		true
	},
	commission_label_finish_mellow = {
		1035393,
		102,
		true
	},
	commission_label_unlock_event_tip = {
		1035495,
		126,
		true
	},
	commission_label_unlock_tech_tip = {
		1035621,
		125,
		true
	},
	specialshipyard_tip = {
		1035746,
		165,
		true
	},
	specialshipyard_name = {
		1035911,
		97,
		true
	},
	liner_sign_cnt_tip = {
		1036008,
		93,
		true
	},
	liner_sign_unlock_tip = {
		1036101,
		100,
		true
	},
	liner_target_type1 = {
		1036201,
		93,
		true
	},
	liner_target_type2 = {
		1036294,
		91,
		true
	},
	liner_target_type3 = {
		1036385,
		98,
		true
	},
	liner_target_type4 = {
		1036483,
		97,
		true
	},
	liner_target_type5 = {
		1036580,
		112,
		true
	},
	liner_log_schedule_title = {
		1036692,
		103,
		true
	},
	liner_log_room_title = {
		1036795,
		109,
		true
	},
	liner_log_event_title = {
		1036904,
		101,
		true
	},
	liner_schedule_award_tip1 = {
		1037005,
		113,
		true
	},
	liner_schedule_award_tip2 = {
		1037118,
		113,
		true
	},
	liner_room_award_tip = {
		1037231,
		109,
		true
	},
	liner_event_award_tip1 = {
		1037340,
		152,
		true
	},
	liner_log_event_group_title1 = {
		1037492,
		102,
		true
	},
	liner_log_event_group_title2 = {
		1037594,
		102,
		true
	},
	liner_log_event_group_title3 = {
		1037696,
		102,
		true
	},
	liner_log_event_group_title4 = {
		1037798,
		102,
		true
	},
	liner_event_award_tip2 = {
		1037900,
		115,
		true
	},
	liner_event_reasoning_title = {
		1038015,
		107,
		true
	},
	["7th_main_tip"] = {
		1038122,
		850,
		true
	},
	pipe_minigame_help = {
		1038972,
		294,
		true
	},
	pipe_minigame_rank = {
		1039266,
		114,
		true
	},
	liner_event_award_tip3 = {
		1039380,
		128,
		true
	},
	liner_room_get_tip = {
		1039508,
		110,
		true
	},
	liner_event_get_tip = {
		1039618,
		101,
		true
	},
	liner_event_lock = {
		1039719,
		132,
		true
	},
	liner_event_title1 = {
		1039851,
		88,
		true
	},
	liner_event_title2 = {
		1039939,
		88,
		true
	},
	liner_event_title3 = {
		1040027,
		88,
		true
	},
	liner_help = {
		1040115,
		282,
		true
	},
	liner_activity_lock = {
		1040397,
		135,
		true
	},
	liner_name_modify = {
		1040532,
		122,
		true
	},
	UrExchange_Pt_NotEnough = {
		1040654,
		125,
		true
	},
	UrExchange_Pt_charges = {
		1040779,
		105,
		true
	},
	UrExchange_Pt_help = {
		1040884,
		335,
		true
	},
	xiaodadi_npc = {
		1041219,
		1503,
		true
	},
	words_lock_ship_label = {
		1042722,
		118,
		true
	},
	one_click_retire_subtitle = {
		1042840,
		109,
		true
	},
	unique_ship_retire_protect = {
		1042949,
		118,
		true
	},
	unique_ship_tip1 = {
		1043067,
		152,
		true
	},
	unique_ship_retire_before_tip = {
		1043219,
		100,
		true
	},
	unique_ship_tip2 = {
		1043319,
		215,
		true
	},
	lock_new_ship = {
		1043534,
		110,
		true
	},
	main_scene_settings = {
		1043644,
		103,
		true
	},
	settings_enable_standby_mode = {
		1043747,
		110,
		true
	},
	settings_time_system = {
		1043857,
		108,
		true
	},
	settings_flagship_interaction = {
		1043965,
		124,
		true
	},
	settings_enter_standby_mode_time = {
		1044089,
		128,
		true
	},
	["202406_wenquan_unlock"] = {
		1044217,
		177,
		true
	},
	["202406_wenquan_unlock_tip2"] = {
		1044394,
		113,
		true
	},
	["202406_main_help"] = {
		1044507,
		1060,
		true
	},
	MonopolyCar2024Game_title1 = {
		1045567,
		94,
		true
	},
	MonopolyCar2024Game_title2 = {
		1045661,
		98,
		true
	},
	help_monopoly_car2024 = {
		1045759,
		1380,
		true
	},
	MonopolyCar2024Game_pick_tip = {
		1047139,
		191,
		true
	},
	MonopolyCar2024Game_sel_label = {
		1047330,
		99,
		true
	},
	MonopolyCar2024Game_total_award_title = {
		1047429,
		115,
		true
	},
	MonopolyCar2024Game_lock_auto_tip = {
		1047544,
		161,
		true
	},
	MonopolyCar2024Game_open_auto_tip = {
		1047705,
		210,
		true
	},
	MonopolyCar2024Game_total_num_tip = {
		1047915,
		109,
		true
	},
	sitelasibao_expup_name = {
		1048024,
		95,
		true
	},
	sitelasibao_expup_desc = {
		1048119,
		259,
		true
	},
	levelScene_tracking_error_pre_2 = {
		1048378,
		125,
		true
	},
	town_lock_level = {
		1048503,
		121,
		true
	},
	town_place_next_title = {
		1048624,
		103,
		true
	},
	town_unlcok_new = {
		1048727,
		98,
		true
	},
	town_unlcok_level = {
		1048825,
		100,
		true
	},
	["0815_main_help"] = {
		1048925,
		876,
		true
	},
	town_help = {
		1049801,
		931,
		true
	},
	activity_0815_town_memory = {
		1050732,
		163,
		true
	},
	town_gold_tip = {
		1050895,
		212,
		true
	},
	award_max_warning_minigame = {
		1051107,
		226,
		true
	},
	dorm3d_photo_len = {
		1051333,
		86,
		true
	},
	dorm3d_photo_depthoffield = {
		1051419,
		93,
		true
	},
	dorm3d_photo_focusdistance = {
		1051512,
		103,
		true
	},
	dorm3d_photo_focusstrength = {
		1051615,
		104,
		true
	},
	dorm3d_photo_paramaters = {
		1051719,
		97,
		true
	},
	dorm3d_photo_postexposure = {
		1051816,
		97,
		true
	},
	dorm3d_photo_saturation = {
		1051913,
		97,
		true
	},
	dorm3d_photo_contrast = {
		1052010,
		93,
		true
	},
	dorm3d_photo_Others = {
		1052103,
		88,
		true
	},
	dorm3d_photo_hidecharacter = {
		1052191,
		104,
		true
	},
	dorm3d_photo_facecamera = {
		1052295,
		98,
		true
	},
	dorm3d_photo_lighting = {
		1052393,
		93,
		true
	},
	dorm3d_photo_filter = {
		1052486,
		89,
		true
	},
	dorm3d_photo_alpha = {
		1052575,
		94,
		true
	},
	dorm3d_photo_strength = {
		1052669,
		90,
		true
	},
	dorm3d_photo_regular_anim = {
		1052759,
		96,
		true
	},
	dorm3d_photo_special_anim = {
		1052855,
		96,
		true
	},
	dorm3d_photo_animspeed = {
		1052951,
		96,
		true
	},
	dorm3d_photo_furniture_lock = {
		1053047,
		118,
		true
	},
	dorm3d_shop_gift = {
		1053165,
		172,
		true
	},
	dorm3d_shop_gift_tip = {
		1053337,
		184,
		true
	},
	word_unlock = {
		1053521,
		83,
		true
	},
	word_lock = {
		1053604,
		84,
		true
	},
	dorm3d_collect_favor_plus = {
		1053688,
		105,
		true
	},
	dorm3d_collect_nothing = {
		1053793,
		107,
		true
	},
	dorm3d_collect_locked = {
		1053900,
		108,
		true
	},
	dorm3d_collect_not_found = {
		1054008,
		104,
		true
	},
	dorm3d_sirius_table = {
		1054112,
		94,
		true
	},
	dorm3d_sirius_chair = {
		1054206,
		94,
		true
	},
	dorm3d_sirius_bed = {
		1054300,
		88,
		true
	},
	dorm3d_sirius_bath = {
		1054388,
		95,
		true
	},
	dorm3d_collection_beach = {
		1054483,
		92,
		true
	},
	dorm3d_reload_unlock = {
		1054575,
		94,
		true
	},
	dorm3d_reload_unlock_name = {
		1054669,
		92,
		true
	},
	dorm3d_reload_favor = {
		1054761,
		97,
		true
	},
	dorm3d_reload_gift = {
		1054858,
		101,
		true
	},
	dorm3d_collect_unlock = {
		1054959,
		95,
		true
	},
	dorm3d_pledge_favor = {
		1055054,
		136,
		true
	},
	dorm3d_own_favor = {
		1055190,
		132,
		true
	},
	dorm3d_role_choose = {
		1055322,
		93,
		true
	},
	dorm3d_beach_buy = {
		1055415,
		171,
		true
	},
	dorm3d_beach_role = {
		1055586,
		146,
		true
	},
	dorm3d_beach_download = {
		1055732,
		128,
		true
	},
	dorm3d_role_check_in = {
		1055860,
		143,
		true
	},
	dorm3d_data_choose = {
		1056003,
		93,
		true
	},
	dorm3d_role_manage = {
		1056096,
		97,
		true
	},
	dorm3d_role_manage_role = {
		1056193,
		97,
		true
	},
	dorm3d_role_manage_public_area = {
		1056290,
		105,
		true
	},
	dorm3d_data_go = {
		1056395,
		138,
		true
	},
	dorm3d_role_assets_delete = {
		1056533,
		178,
		true
	},
	dorm3d_role_assets_download = {
		1056711,
		224,
		true
	},
	volleyball_end_tip = {
		1056935,
		110,
		true
	},
	volleyball_end_award = {
		1057045,
		106,
		true
	},
	sure_exit_volleyball = {
		1057151,
		119,
		true
	},
	dorm3d_photo_active_zone = {
		1057270,
		105,
		true
	},
	apartment_level_unenough = {
		1057375,
		114,
		true
	},
	help_dorm3d_info = {
		1057489,
		537,
		true
	},
	dorm3d_shop_gift_already_given = {
		1058026,
		127,
		true
	},
	dorm3d_shop_gift_not_owned = {
		1058153,
		114,
		true
	},
	dorm3d_select_tip = {
		1058267,
		101,
		true
	},
	dorm3d_volleyball_title = {
		1058368,
		92,
		true
	},
	dorm3d_minigame_again = {
		1058460,
		90,
		true
	},
	dorm3d_minigame_close = {
		1058550,
		89,
		true
	},
	dorm3d_data_Invite_lack = {
		1058639,
		128,
		true
	},
	dorm3d_item_num = {
		1058767,
		88,
		true
	},
	dorm3d_collect_not_owned = {
		1058855,
		112,
		true
	},
	dorm3d_furniture_sure_save = {
		1058967,
		136,
		true
	},
	dorm3d_furniture_save_success = {
		1059103,
		131,
		true
	},
	dorm3d_removable = {
		1059234,
		151,
		true
	},
	report_cannot_comment_level_1 = {
		1059385,
		151,
		true
	},
	report_cannot_comment_level_2 = {
		1059536,
		130,
		true
	},
	commander_exp_limit = {
		1059666,
		147,
		true
	},
	dreamland_label_day = {
		1059813,
		86,
		true
	},
	dreamland_label_dusk = {
		1059899,
		91,
		true
	},
	dreamland_label_night = {
		1059990,
		90,
		true
	},
	dreamland_label_area = {
		1060080,
		88,
		true
	},
	dreamland_label_explore = {
		1060168,
		94,
		true
	},
	dreamland_label_explore_award_tip = {
		1060262,
		120,
		true
	},
	dreamland_area_lock_tip = {
		1060382,
		127,
		true
	},
	dreamland_spring_lock_tip = {
		1060509,
		116,
		true
	},
	dreamland_spring_tip = {
		1060625,
		116,
		true
	},
	dream_land_tip = {
		1060741,
		969,
		true
	},
	touch_cake_minigame_help = {
		1061710,
		359,
		true
	},
	dreamland_main_desc = {
		1062069,
		232,
		true
	},
	dreamland_main_tip = {
		1062301,
		1017,
		true
	},
	no_share_skin_gametip = {
		1063318,
		120,
		true
	},
	no_share_skin_tianchenghangmu = {
		1063438,
		102,
		true
	},
	no_share_skin_tianchengzhanlie = {
		1063540,
		103,
		true
	},
	no_share_skin_jiahezhanlie = {
		1063643,
		98,
		true
	},
	no_share_skin_jiahehangmu = {
		1063741,
		97,
		true
	},
	ui_pack_tip1 = {
		1063838,
		167,
		true
	},
	ui_pack_tip2 = {
		1064005,
		81,
		true
	},
	ui_pack_tip3 = {
		1064086,
		83,
		true
	},
	battle_ui_unlock = {
		1064169,
		96,
		true
	},
	compensate_ui_expiration_hour = {
		1064265,
		114,
		true
	},
	compensate_ui_expiration_day = {
		1064379,
		112,
		true
	},
	compensate_ui_title1 = {
		1064491,
		89,
		true
	},
	compensate_ui_title2 = {
		1064580,
		94,
		true
	},
	compensate_ui_nothing1 = {
		1064674,
		115,
		true
	},
	compensate_ui_nothing2 = {
		1064789,
		114,
		true
	},
	attire_combatui_preview = {
		1064903,
		94,
		true
	},
	attire_combatui_confirm = {
		1064997,
		92,
		true
	},
	grapihcs3d_setting_quality = {
		1065089,
		106,
		true
	},
	grapihcs3d_setting_quality_option_low = {
		1065195,
		104,
		true
	},
	grapihcs3d_setting_quality_option_medium = {
		1065299,
		110,
		true
	},
	grapihcs3d_setting_quality_option_high = {
		1065409,
		106,
		true
	},
	grapihcs3d_setting_quality_option_custom = {
		1065515,
		110,
		true
	},
	grapihcs3d_setting_universal = {
		1065625,
		111,
		true
	},
	grapihcs3d_setting_gpgpu_warning = {
		1065736,
		149,
		true
	},
	dorm3d_shop_tag1 = {
		1065885,
		109,
		true
	},
	dorm3d_shop_tag2 = {
		1065994,
		101,
		true
	},
	dorm3d_shop_tag3 = {
		1066095,
		113,
		true
	},
	dorm3d_shop_tag4 = {
		1066208,
		110,
		true
	},
	dorm3d_shop_tag5 = {
		1066318,
		106,
		true
	},
	dorm3d_shop_tag6 = {
		1066424,
		96,
		true
	},
	dorm3d_system_switch = {
		1066520,
		110,
		true
	},
	dorm3d_beach_switch = {
		1066630,
		106,
		true
	},
	dorm3d_AR_switch = {
		1066736,
		123,
		true
	},
	dorm3d_invite_confirm_original = {
		1066859,
		207,
		true
	},
	dorm3d_invite_confirm_discount = {
		1067066,
		229,
		true
	},
	dorm3d_invite_confirm_free = {
		1067295,
		241,
		true
	},
	dorm3d_purchase_confirm_original = {
		1067536,
		188,
		true
	},
	dorm3d_purchase_confirm_discount = {
		1067724,
		209,
		true
	},
	dorm3d_purchase_confirm_free = {
		1067933,
		215,
		true
	},
	dorm3d_purchase_confirm_tip = {
		1068148,
		96,
		true
	},
	dorm3d_purchase_label_special = {
		1068244,
		102,
		true
	},
	dorm3d_purchase_outtime = {
		1068346,
		111,
		true
	},
	dorm3d_collect_block_by_furniture = {
		1068457,
		160,
		true
	},
	cruise_phase_title = {
		1068617,
		87,
		true
	},
	cruise_title_2410 = {
		1068704,
		100,
		true
	},
	cruise_title_2412 = {
		1068804,
		106,
		true
	},
	cruise_title_2502 = {
		1068910,
		106,
		true
	},
	cruise_title_2504 = {
		1069016,
		106,
		true
	},
	cruise_title_2506 = {
		1069122,
		106,
		true
	},
	cruise_title_2508 = {
		1069228,
		100,
		true
	},
	cruise_title_2510 = {
		1069328,
		100,
		true
	},
	cruise_title_2406 = {
		1069428,
		102,
		true
	},
	battlepass_main_time_title = {
		1069530,
		105,
		true
	},
	cruise_shop_no_open = {
		1069635,
		109,
		true
	},
	cruise_btn_pay = {
		1069744,
		98,
		true
	},
	cruise_btn_all = {
		1069842,
		87,
		true
	},
	task_go = {
		1069929,
		78,
		true
	},
	task_got = {
		1070007,
		81,
		true
	},
	cruise_shop_title_skin = {
		1070088,
		90,
		true
	},
	cruise_shop_title_equip_skin = {
		1070178,
		101,
		true
	},
	cruise_shop_lock_tip = {
		1070279,
		120,
		true
	},
	cruise_tip_skin = {
		1070399,
		96,
		true
	},
	cruise_tip_base = {
		1070495,
		95,
		true
	},
	cruise_tip_upgrade = {
		1070590,
		99,
		true
	},
	cruise_shop_limit_tip = {
		1070689,
		104,
		true
	},
	cruise_limit_count = {
		1070793,
		126,
		true
	},
	cruise_title_2408 = {
		1070919,
		100,
		true
	},
	cruise_shop_title = {
		1071019,
		95,
		true
	},
	dorm3d_favor_level_story = {
		1071114,
		101,
		true
	},
	dorm3d_already_gifted = {
		1071215,
		98,
		true
	},
	dorm3d_story_unlock_tip = {
		1071313,
		101,
		true
	},
	dorm3d_skin_locked = {
		1071414,
		100,
		true
	},
	dorm3d_photo_no_role = {
		1071514,
		105,
		true
	},
	dorm3d_furniture_locked = {
		1071619,
		108,
		true
	},
	dorm3d_accompany_locked = {
		1071727,
		98,
		true
	},
	dorm3d_role_locked = {
		1071825,
		151,
		true
	},
	dorm3d_volleyball_button = {
		1071976,
		104,
		true
	},
	dorm3d_minigame_button1 = {
		1072080,
		95,
		true
	},
	dorm3d_collection_title_en = {
		1072175,
		99,
		true
	},
	dorm3d_collection_cost_tip = {
		1072274,
		182,
		true
	},
	dorm3d_gift_story_unlock = {
		1072456,
		110,
		true
	},
	dorm3d_furniture_replace_tip = {
		1072566,
		117,
		true
	},
	dorm3d_recall_locked = {
		1072683,
		96,
		true
	},
	dorm3d_gift_maximum = {
		1072779,
		110,
		true
	},
	dorm3d_need_construct_item = {
		1072889,
		111,
		true
	},
	AR_plane_check = {
		1073000,
		108,
		true
	},
	AR_plane_long_press_to_summon = {
		1073108,
		148,
		true
	},
	AR_plane_distance_near = {
		1073256,
		157,
		true
	},
	AR_plane_summon_fail_by_near = {
		1073413,
		140,
		true
	},
	AR_plane_summon_success = {
		1073553,
		105,
		true
	},
	dorm3d_day_night_switching1 = {
		1073658,
		118,
		true
	},
	dorm3d_day_night_switching2 = {
		1073776,
		120,
		true
	},
	dorm3d_download_complete = {
		1073896,
		105,
		true
	},
	dorm3d_resource_downloading = {
		1074001,
		109,
		true
	},
	dorm3d_resource_delete = {
		1074110,
		100,
		true
	},
	dorm3d_favor_maximize = {
		1074210,
		122,
		true
	},
	dorm3d_purchase_weekly_limit = {
		1074332,
		116,
		true
	},
	child2_cur_round = {
		1074448,
		87,
		true
	},
	child2_assess_round = {
		1074535,
		110,
		true
	},
	child2_assess_target = {
		1074645,
		100,
		true
	},
	child2_ending_stage = {
		1074745,
		95,
		true
	},
	child2_reset_stage = {
		1074840,
		86,
		true
	},
	child2_main_help = {
		1074926,
		588,
		true
	},
	child2_personality_title = {
		1075514,
		99,
		true
	},
	child2_attr_title = {
		1075613,
		86,
		true
	},
	child2_talent_title = {
		1075699,
		90,
		true
	},
	child2_status_title = {
		1075789,
		89,
		true
	},
	child2_talent_unlock_tip = {
		1075878,
		106,
		true
	},
	child2_status_time1 = {
		1075984,
		90,
		true
	},
	child2_status_time2 = {
		1076074,
		92,
		true
	},
	child2_assess_tip = {
		1076166,
		136,
		true
	},
	child2_assess_tip_target = {
		1076302,
		135,
		true
	},
	child2_site_exit = {
		1076437,
		85,
		true
	},
	child2_shop_limit_cnt = {
		1076522,
		92,
		true
	},
	child2_unlock_site_round = {
		1076614,
		133,
		true
	},
	child2_site_drop_add = {
		1076747,
		123,
		true
	},
	child2_site_drop_reduce = {
		1076870,
		126,
		true
	},
	child2_site_drop_item = {
		1076996,
		105,
		true
	},
	child2_personal_id1_tag1 = {
		1077101,
		92,
		true
	},
	child2_personal_id1_tag2 = {
		1077193,
		98,
		true
	},
	child2_personal_change = {
		1077291,
		104,
		true
	},
	child2_ship_upgrade_favor = {
		1077395,
		132,
		true
	},
	child2_plan_title_front = {
		1077527,
		91,
		true
	},
	child2_plan_title_back = {
		1077618,
		86,
		true
	},
	child2_plan_upgrade_condition = {
		1077704,
		116,
		true
	},
	child2_endings_toggle_on = {
		1077820,
		100,
		true
	},
	child2_endings_toggle_off = {
		1077920,
		111,
		true
	},
	child2_game_cnt = {
		1078031,
		89,
		true
	},
	child2_enter = {
		1078120,
		89,
		true
	},
	child2_select_help = {
		1078209,
		529,
		true
	},
	child2_not_start = {
		1078738,
		103,
		true
	},
	child2_schedule_sure_tip = {
		1078841,
		152,
		true
	},
	child2_reset_sure_tip = {
		1078993,
		153,
		true
	},
	child2_schedule_sure_tip2 = {
		1079146,
		154,
		true
	},
	child2_schedule_sure_tip3 = {
		1079300,
		178,
		true
	},
	child2_assess_start_tip = {
		1079478,
		103,
		true
	},
	child2_site_again = {
		1079581,
		86,
		true
	},
	child2_shop_benefit_sure = {
		1079667,
		209,
		true
	},
	child2_shop_benefit_sure2 = {
		1079876,
		188,
		true
	},
	world_file_tip = {
		1080064,
		157,
		true
	},
	levelscene_mapselect_part1 = {
		1080221,
		96,
		true
	},
	levelscene_mapselect_part2 = {
		1080317,
		96,
		true
	},
	levelscene_mapselect_sp = {
		1080413,
		89,
		true
	},
	levelscene_mapselect_tp = {
		1080502,
		89,
		true
	},
	levelscene_mapselect_ex = {
		1080591,
		89,
		true
	},
	levelscene_mapselect_normal = {
		1080680,
		97,
		true
	},
	levelscene_mapselect_advanced = {
		1080777,
		102,
		true
	},
	levelscene_mapselect_material = {
		1080879,
		102,
		true
	},
	levelscene_title_story = {
		1080981,
		94,
		true
	},
	juuschat_filter_title = {
		1081075,
		91,
		true
	},
	juuschat_filter_tip1 = {
		1081166,
		87,
		true
	},
	juuschat_filter_tip2 = {
		1081253,
		92,
		true
	},
	juuschat_filter_tip3 = {
		1081345,
		93,
		true
	},
	juuschat_filter_tip4 = {
		1081438,
		91,
		true
	},
	juuschat_filter_tip5 = {
		1081529,
		89,
		true
	},
	juuschat_label1 = {
		1081618,
		85,
		true
	},
	juuschat_label2 = {
		1081703,
		86,
		true
	},
	juuschat_chattip1 = {
		1081789,
		97,
		true
	},
	juuschat_chattip2 = {
		1081886,
		91,
		true
	},
	juuschat_chattip3 = {
		1081977,
		92,
		true
	},
	juuschat_reddot_title = {
		1082069,
		94,
		true
	},
	juuschat_filter_subtitle1 = {
		1082163,
		100,
		true
	},
	juuschat_filter_subtitle2 = {
		1082263,
		102,
		true
	},
	juuschat_filter_subtitle3 = {
		1082365,
		96,
		true
	},
	juuschat_redpacket_show_detail = {
		1082461,
		101,
		true
	},
	juuschat_redpacket_detail = {
		1082562,
		105,
		true
	},
	juuschat_filter_empty = {
		1082667,
		100,
		true
	},
	dorm3d_appellation_title = {
		1082767,
		103,
		true
	},
	dorm3d_appellation_cd = {
		1082870,
		130,
		true
	},
	dorm3d_appellation_interval = {
		1083000,
		141,
		true
	},
	dorm3d_appellation_waring1 = {
		1083141,
		131,
		true
	},
	dorm3d_appellation_waring2 = {
		1083272,
		116,
		true
	},
	dorm3d_appellation_waring3 = {
		1083388,
		117,
		true
	},
	dorm3d_appellation_waring4 = {
		1083505,
		133,
		true
	},
	dorm3d_shop_gift_owned = {
		1083638,
		123,
		true
	},
	dorm3d_accompany_not_download = {
		1083761,
		135,
		true
	},
	dorm3d_nengdai_minigame_day1 = {
		1083896,
		95,
		true
	},
	dorm3d_nengdai_minigame_day2 = {
		1083991,
		95,
		true
	},
	dorm3d_nengdai_minigame_day3 = {
		1084086,
		95,
		true
	},
	dorm3d_nengdai_minigame_day4 = {
		1084181,
		95,
		true
	},
	dorm3d_nengdai_minigame_day5 = {
		1084276,
		95,
		true
	},
	dorm3d_nengdai_minigame_day6 = {
		1084371,
		95,
		true
	},
	dorm3d_nengdai_minigame_day7 = {
		1084466,
		95,
		true
	},
	dorm3d_nengdai_minigame_remember = {
		1084561,
		122,
		true
	},
	dorm3d_nengdai_minigame_choose = {
		1084683,
		118,
		true
	},
	dorm3d_nengdai_minigame_behavior1 = {
		1084801,
		104,
		true
	},
	dorm3d_nengdai_minigame_behavior2 = {
		1084905,
		104,
		true
	},
	dorm3d_nengdai_minigame_behavior3 = {
		1085009,
		105,
		true
	},
	dorm3d_nengdai_minigame_behavior4 = {
		1085114,
		104,
		true
	},
	dorm3d_nengdai_minigame_behavior5 = {
		1085218,
		107,
		true
	},
	dorm3d_nengdai_minigame_behavior6 = {
		1085325,
		105,
		true
	},
	dorm3d_nengdai_minigame_behavior7 = {
		1085430,
		105,
		true
	},
	dorm3d_nengdai_minigame_behavior8 = {
		1085535,
		104,
		true
	},
	dorm3d_nengdai_minigame_behavior9 = {
		1085639,
		104,
		true
	},
	dorm3d_nengdai_minigame_behavior10 = {
		1085743,
		103,
		true
	},
	dorm3d_nengdai_minigame_behavior11 = {
		1085846,
		102,
		true
	},
	dorm3d_nengdai_minigame_behavior12 = {
		1085948,
		101,
		true
	},
	dorm3d_nengdai_minigame_evaluate1 = {
		1086049,
		103,
		true
	},
	dorm3d_nengdai_minigame_evaluate2 = {
		1086152,
		107,
		true
	},
	dorm3d_nengdai_minigame_evaluate3 = {
		1086259,
		104,
		true
	},
	dorm3d_nengdai_minigame_evaluate4 = {
		1086363,
		102,
		true
	},
	dorm3d_nengdai_minigame_evaluate5 = {
		1086465,
		105,
		true
	},
	BoatAdGame_minigame_help = {
		1086570,
		311,
		true
	},
	activity_1024_memory = {
		1086881,
		155,
		true
	},
	activity_1024_memory_get = {
		1087036,
		99,
		true
	},
	juuschat_background_tip1 = {
		1087135,
		97,
		true
	},
	juuschat_background_tip2 = {
		1087232,
		112,
		true
	},
	drom3d_memory_limit_tip = {
		1087344,
		182,
		true
	},
	drom3d_beach_memory_limit_tip = {
		1087526,
		216,
		true
	},
	blackfriday_main_tip = {
		1087742,
		542,
		true
	},
	blackfriday_shop_tip = {
		1088284,
		103,
		true
	},
	tolovegame_buff_name_1 = {
		1088387,
		98,
		true
	},
	tolovegame_buff_name_2 = {
		1088485,
		97,
		true
	},
	tolovegame_buff_name_3 = {
		1088582,
		102,
		true
	},
	tolovegame_buff_name_4 = {
		1088684,
		103,
		true
	},
	tolovegame_buff_name_5 = {
		1088787,
		102,
		true
	},
	tolovegame_buff_name_6 = {
		1088889,
		107,
		true
	},
	tolovegame_buff_name_7 = {
		1088996,
		95,
		true
	},
	tolovegame_buff_desc_1 = {
		1089091,
		177,
		true
	},
	tolovegame_buff_desc_2 = {
		1089268,
		132,
		true
	},
	tolovegame_buff_desc_3 = {
		1089400,
		123,
		true
	},
	tolovegame_buff_desc_4 = {
		1089523,
		276,
		true
	},
	tolovegame_buff_desc_5 = {
		1089799,
		213,
		true
	},
	tolovegame_buff_desc_6 = {
		1090012,
		206,
		true
	},
	tolovegame_buff_desc_7 = {
		1090218,
		221,
		true
	},
	tolovegame_join_reward = {
		1090439,
		93,
		true
	},
	tolovegame_score = {
		1090532,
		85,
		true
	},
	tolovegame_rank_tip = {
		1090617,
		118,
		true
	},
	tolovegame_lock_1 = {
		1090735,
		116,
		true
	},
	tolovegame_lock_2 = {
		1090851,
		102,
		true
	},
	tolovegame_buff_switch_1 = {
		1090953,
		102,
		true
	},
	tolovegame_buff_switch_2 = {
		1091055,
		104,
		true
	},
	tolovegame_proceed = {
		1091159,
		89,
		true
	},
	tolovegame_collect = {
		1091248,
		88,
		true
	},
	tolovegame_collected = {
		1091336,
		91,
		true
	},
	tolovegame_tutorial = {
		1091427,
		635,
		true
	},
	tolovegame_awards = {
		1092062,
		88,
		true
	},
	tolovemainpage_skin_countdown = {
		1092150,
		111,
		true
	},
	tolovemainpage_build_countdown = {
		1092261,
		105,
		true
	},
	tolovegame_puzzle_title = {
		1092366,
		107,
		true
	},
	tolovegame_puzzle_ship_need = {
		1092473,
		106,
		true
	},
	tolovegame_puzzle_task_need = {
		1092579,
		108,
		true
	},
	tolovegame_puzzle_detail_collect = {
		1092687,
		113,
		true
	},
	tolovegame_puzzle_detail_puzzle = {
		1092800,
		109,
		true
	},
	tolovegame_puzzle_detail_connection = {
		1092909,
		117,
		true
	},
	tolovegame_puzzle_ship_unknown = {
		1093026,
		97,
		true
	},
	tolovegame_puzzle_lock_by_front = {
		1093123,
		138,
		true
	},
	tolovegame_puzzle_lock_by_time = {
		1093261,
		130,
		true
	},
	tolovegame_puzzle_cheat = {
		1093391,
		114,
		true
	},
	tolovegame_puzzle_open_detail = {
		1093505,
		109,
		true
	},
	tolove_main_help = {
		1093614,
		1464,
		true
	},
	tolovegame_puzzle_finished = {
		1095078,
		99,
		true
	},
	tolovegame_puzzle_title_desc = {
		1095177,
		112,
		true
	},
	tolovegame_puzzle_pop_next = {
		1095289,
		94,
		true
	},
	tolovegame_puzzle_pop_finish = {
		1095383,
		100,
		true
	},
	tolovegame_puzzle_pop_save = {
		1095483,
		107,
		true
	},
	tolovegame_puzzle_unlock = {
		1095590,
		95,
		true
	},
	tolovegame_puzzle_lock = {
		1095685,
		101,
		true
	},
	tolovegame_puzzle_line_tip = {
		1095786,
		125,
		true
	},
	tolovegame_puzzle_puzzle_tip = {
		1095911,
		144,
		true
	},
	maintenance_message_text = {
		1096055,
		255,
		true
	},
	maintenance_message_stop_text = {
		1096310,
		105,
		true
	},
	task_get = {
		1096415,
		79,
		true
	},
	notify_clock_tip = {
		1096494,
		80,
		true
	},
	notify_clock_button = {
		1096574,
		83,
		true
	},
	skin_shop_nonuse_label = {
		1096657,
		107,
		true
	},
	skin_shop_use_label = {
		1096764,
		97,
		true
	},
	skin_shop_discount_item_link = {
		1096861,
		158,
		true
	},
	help_starLightAlbum = {
		1097019,
		940,
		true
	},
	word_gain_date = {
		1097959,
		92,
		true
	},
	word_limited_activity = {
		1098051,
		90,
		true
	},
	word_show_expire_content = {
		1098141,
		105,
		true
	},
	word_got_pt = {
		1098246,
		82,
		true
	},
	word_activity_not_open = {
		1098328,
		103,
		true
	},
	activity_shop_template_normaltext = {
		1098431,
		122,
		true
	},
	activity_shop_template_extratext = {
		1098553,
		121,
		true
	},
	dorm3d_now_is_downloading = {
		1098674,
		110,
		true
	},
	dorm3d_resource_download_complete = {
		1098784,
		115,
		true
	},
	dorm3d_delete_finish = {
		1098899,
		96,
		true
	},
	dorm3d_guide_tip = {
		1098995,
		107,
		true
	},
	dorm3d_guide_tip2 = {
		1099102,
		107,
		true
	},
	dorm3d_noshiro_table = {
		1099209,
		95,
		true
	},
	dorm3d_noshiro_chair = {
		1099304,
		95,
		true
	},
	dorm3d_noshiro_bed = {
		1099399,
		89,
		true
	},
	dorm3d_guide_beach_tip = {
		1099488,
		148,
		true
	},
	dorm3d_Ankeleiqi_entertainmentarea = {
		1099636,
		112,
		true
	},
	dorm3d_Ankeleiqi_chair = {
		1099748,
		97,
		true
	},
	dorm3d_Ankeleiqi_bed = {
		1099845,
		91,
		true
	},
	dorm3d_xinzexi_table = {
		1099936,
		95,
		true
	},
	dorm3d_xinzexi_chair = {
		1100031,
		95,
		true
	},
	dorm3d_xinzexi_bed = {
		1100126,
		89,
		true
	},
	dorm3d_gift_favor_max = {
		1100215,
		194,
		true
	},
	dorm3d_VIDEO_CHAT_LABEL = {
		1100409,
		102,
		true
	},
	dorm3d_VIDEO_TELEPHONE_LABEL = {
		1100511,
		104,
		true
	},
	dorm3d_privatechat_favor = {
		1100615,
		96,
		true
	},
	dorm3d_privatechat_furniture = {
		1100711,
		101,
		true
	},
	dorm3d_privatechat_visit = {
		1100812,
		98,
		true
	},
	dorm3d_privatechat_visit_time = {
		1100910,
		106,
		true
	},
	dorm3d_privatechat_no_visit_time = {
		1101016,
		102,
		true
	},
	dorm3d_privatechat_gift = {
		1101118,
		92,
		true
	},
	dorm3d_privatechat_chat = {
		1101210,
		95,
		true
	},
	dorm3d_privatechat_nonew_messages = {
		1101305,
		109,
		true
	},
	dorm3d_privatechat_new_messages = {
		1101414,
		106,
		true
	},
	dorm3d_privatechat_phone = {
		1101520,
		98,
		true
	},
	dorm3d_privatechat_new_calls = {
		1101618,
		101,
		true
	},
	dorm3d_privatechat_nonew_calls = {
		1101719,
		105,
		true
	},
	dorm3d_privatechat_topics = {
		1101824,
		99,
		true
	},
	dorm3d_privatechat_ins = {
		1101923,
		96,
		true
	},
	dorm3d_privatechat_new_topics = {
		1102019,
		110,
		true
	},
	dorm3d_privatechat_nonew_topics = {
		1102129,
		106,
		true
	},
	dorm3d_privatechat_room_beach = {
		1102235,
		163,
		true
	},
	dorm3d_privatechat_room_character = {
		1102398,
		116,
		true
	},
	dorm3d_privatechat_room_unlock = {
		1102514,
		132,
		true
	},
	dorm3d_privatechat_screen_all = {
		1102646,
		96,
		true
	},
	dorm3d_privatechat_screen_floor_1 = {
		1102742,
		107,
		true
	},
	dorm3d_privatechat_screen_floor_2 = {
		1102849,
		101,
		true
	},
	dorm3d_privatechat_visit_time_now = {
		1102950,
		102,
		true
	},
	dorm3d_privatechat_room_guide = {
		1103052,
		116,
		true
	},
	dorm3d_privatechat_room_download = {
		1103168,
		133,
		true
	},
	dorm3d_privatechat_telephone = {
		1103301,
		123,
		true
	},
	dorm3d_privatechat_welcome = {
		1103424,
		110,
		true
	},
	dorm3d_gift_favor_exceed = {
		1103534,
		184,
		true
	},
	dorm3d_privatechat_telephone_calllog = {
		1103718,
		118,
		true
	},
	dorm3d_privatechat_telephone_call = {
		1103836,
		107,
		true
	},
	dorm3d_privatechat_telephone_noviewed = {
		1103943,
		111,
		true
	},
	dorm3d_privatechat_video_call = {
		1104054,
		103,
		true
	},
	dorm3d_ins_no_msg = {
		1104157,
		92,
		true
	},
	dorm3d_ins_no_topics = {
		1104249,
		95,
		true
	},
	dorm3d_skin_confirm = {
		1104344,
		97,
		true
	},
	dorm3d_skin_already = {
		1104441,
		90,
		true
	},
	dorm3d_skin_equip = {
		1104531,
		96,
		true
	},
	dorm3d_skin_unlock = {
		1104627,
		125,
		true
	},
	dorm3d_room_floor_1 = {
		1104752,
		88,
		true
	},
	dorm3d_room_floor_2 = {
		1104840,
		87,
		true
	},
	please_input_1_99 = {
		1104927,
		108,
		true
	},
	child2_empty_plan = {
		1105035,
		94,
		true
	},
	child2_replay_tip = {
		1105129,
		229,
		true
	},
	child2_replay_clear = {
		1105358,
		89,
		true
	},
	child2_replay_continue = {
		1105447,
		94,
		true
	},
	firework_2025_level = {
		1105541,
		91,
		true
	},
	firework_2025_pt = {
		1105632,
		92,
		true
	},
	firework_2025_get = {
		1105724,
		90,
		true
	},
	firework_2025_got = {
		1105814,
		88,
		true
	},
	firework_2025_tip1 = {
		1105902,
		136,
		true
	},
	firework_2025_tip2 = {
		1106038,
		104,
		true
	},
	firework_2025_unlock_tip1 = {
		1106142,
		110,
		true
	},
	firework_2025_unlock_tip2 = {
		1106252,
		91,
		true
	},
	firework_2025_tip = {
		1106343,
		835,
		true
	},
	secretary_special_character_unlock = {
		1107178,
		171,
		true
	},
	secretary_special_character_buy_unlock = {
		1107349,
		210,
		true
	},
	child2_mood_desc1 = {
		1107559,
		149,
		true
	},
	child2_mood_desc2 = {
		1107708,
		143,
		true
	},
	child2_mood_desc3 = {
		1107851,
		123,
		true
	},
	child2_mood_desc4 = {
		1107974,
		145,
		true
	},
	child2_mood_desc5 = {
		1108119,
		145,
		true
	},
	child2_schedule_target = {
		1108264,
		102,
		true
	},
	child2_shop_point_sure = {
		1108366,
		177,
		true
	},
	["2025Valentine_minigame_s"] = {
		1108543,
		214,
		true
	},
	["2025Valentine_minigame_a"] = {
		1108757,
		224,
		true
	},
	["2025Valentine_minigame_b"] = {
		1108981,
		229,
		true
	},
	["2025Valentine_minigame_c"] = {
		1109210,
		214,
		true
	},
	rps_game_take_card = {
		1109424,
		94,
		true
	},
	SkinDiscountHelp_School = {
		1109518,
		656,
		true
	},
	SkinDiscountHelp_BlackFriday = {
		1110174,
		729,
		true
	},
	SkinDiscount_Hint = {
		1110903,
		158,
		true
	},
	SkinDiscount_Got = {
		1111061,
		89,
		true
	},
	skin_original_price = {
		1111150,
		93,
		true
	},
	SkinDiscount_Owned_Tips = {
		1111243,
		363,
		true
	},
	SkinDiscount_Last_Coupon = {
		1111606,
		257,
		true
	},
	clue_title_1 = {
		1111863,
		89,
		true
	},
	clue_title_2 = {
		1111952,
		90,
		true
	},
	clue_title_3 = {
		1112042,
		90,
		true
	},
	clue_title_4 = {
		1112132,
		81,
		true
	},
	clue_task_goto = {
		1112213,
		97,
		true
	},
	clue_lock_tip1 = {
		1112310,
		99,
		true
	},
	clue_lock_tip2 = {
		1112409,
		87,
		true
	},
	clue_get = {
		1112496,
		77,
		true
	},
	clue_got = {
		1112573,
		79,
		true
	},
	clue_unselect_tip = {
		1112652,
		133,
		true
	},
	clue_close_tip = {
		1112785,
		102,
		true
	},
	clue_pt_tip = {
		1112887,
		83,
		true
	},
	clue_buff_research = {
		1112970,
		89,
		true
	},
	clue_buff_pt_boost = {
		1113059,
		128,
		true
	},
	clue_buff_stage_loot = {
		1113187,
		97,
		true
	},
	clue_task_tip = {
		1113284,
		91,
		true
	},
	clue_buff_reach_max = {
		1113375,
		125,
		true
	},
	clue_buff_unselect = {
		1113500,
		116,
		true
	},
	ship_formationUI_fleetName_1 = {
		1113616,
		119,
		true
	},
	ship_formationUI_fleetName_2 = {
		1113735,
		120,
		true
	},
	ship_formationUI_fleetName_3 = {
		1113855,
		117,
		true
	},
	ship_formationUI_fleetName_4 = {
		1113972,
		116,
		true
	},
	ship_formationUI_fleetName_5 = {
		1114088,
		120,
		true
	},
	ship_formationUI_fleetName_6 = {
		1114208,
		121,
		true
	},
	ship_formationUI_fleetName_7 = {
		1114329,
		118,
		true
	},
	ship_formationUI_fleetName_8 = {
		1114447,
		117,
		true
	},
	ship_formationUI_fleetName_9 = {
		1114564,
		121,
		true
	},
	ship_formationUI_fleetName_10 = {
		1114685,
		123,
		true
	},
	ship_formationUI_fleetName_11 = {
		1114808,
		120,
		true
	},
	ship_formationUI_fleetName_12 = {
		1114928,
		119,
		true
	},
	ship_formationUI_fleetName_13 = {
		1115047,
		111,
		true
	},
	clue_buff_ticket_tips = {
		1115158,
		167,
		true
	},
	clue_buff_empty_ticket = {
		1115325,
		136,
		true
	},
	SuperBulin2_tip1 = {
		1115461,
		118,
		true
	},
	SuperBulin2_tip2 = {
		1115579,
		117,
		true
	},
	SuperBulin2_tip3 = {
		1115696,
		126,
		true
	},
	SuperBulin2_tip4 = {
		1115822,
		117,
		true
	},
	SuperBulin2_tip5 = {
		1115939,
		126,
		true
	},
	SuperBulin2_tip6 = {
		1116065,
		120,
		true
	},
	SuperBulin2_tip7 = {
		1116185,
		117,
		true
	},
	SuperBulin2_tip8 = {
		1116302,
		117,
		true
	},
	SuperBulin2_tip9 = {
		1116419,
		125,
		true
	},
	SuperBulin2_help = {
		1116544,
		513,
		true
	},
	SuperBulin2_lock_tip = {
		1117057,
		132,
		true
	},
	dorm3d_shop_buy_tips = {
		1117189,
		218,
		true
	},
	dorm3d_shop_title = {
		1117407,
		94,
		true
	},
	dorm3d_shop_limit = {
		1117501,
		88,
		true
	},
	dorm3d_shop_sold_out = {
		1117589,
		92,
		true
	},
	dorm3d_shop_all = {
		1117681,
		82,
		true
	},
	dorm3d_shop_gift1 = {
		1117763,
		86,
		true
	},
	dorm3d_shop_furniture = {
		1117849,
		94,
		true
	},
	dorm3d_shop_others = {
		1117943,
		87,
		true
	},
	dorm3d_shop_limit1 = {
		1118030,
		96,
		true
	},
	dorm3d_cafe_minigame1 = {
		1118126,
		105,
		true
	},
	dorm3d_cafe_minigame2 = {
		1118231,
		102,
		true
	},
	dorm3d_cafe_minigame3 = {
		1118333,
		97,
		true
	},
	dorm3d_cafe_minigame4 = {
		1118430,
		90,
		true
	},
	dorm3d_cafe_minigame5 = {
		1118520,
		89,
		true
	},
	dorm3d_cafe_minigame6 = {
		1118609,
		94,
		true
	},
	xiaoankeleiqi_npc = {
		1118703,
		1518,
		true
	},
	island_name_too_long_or_too_short = {
		1120221,
		156,
		true
	},
	island_name_exist_special_word = {
		1120377,
		152,
		true
	},
	island_name_exist_ban_word = {
		1120529,
		145,
		true
	},
	grapihcs3d_setting_enable_gup_driver = {
		1120674,
		112,
		true
	},
	grapihcs3d_setting_resolution = {
		1120786,
		107,
		true
	},
	grapihcs3d_setting_resolution_optionname0 = {
		1120893,
		109,
		true
	},
	grapihcs3d_setting_resolution_optionname1 = {
		1121002,
		110,
		true
	},
	grapihcs3d_setting_resolution_optionname2 = {
		1121112,
		107,
		true
	},
	grapihcs3d_setting_rendering_quality = {
		1121219,
		117,
		true
	},
	grapihcs3d_setting_rendering_quality_optionname0 = {
		1121336,
		115,
		true
	},
	grapihcs3d_setting_rendering_quality_optionname1 = {
		1121451,
		116,
		true
	},
	grapihcs3d_setting_shader_quality = {
		1121567,
		111,
		true
	},
	grapihcs3d_setting_shader_quality_optionname0 = {
		1121678,
		112,
		true
	},
	grapihcs3d_setting_shader_quality_optionname1 = {
		1121790,
		113,
		true
	},
	grapihcs3d_setting_shadow_quality = {
		1121903,
		111,
		true
	},
	grapihcs3d_setting_shadow_quality_optionname0 = {
		1122014,
		112,
		true
	},
	grapihcs3d_setting_shadow_quality_optionname1 = {
		1122126,
		112,
		true
	},
	grapihcs3d_setting_shadow_quality_optionname2 = {
		1122238,
		115,
		true
	},
	grapihcs3d_setting_shadow_quality_optionname3 = {
		1122353,
		113,
		true
	},
	grapihcs3d_setting_shadow_update_mode = {
		1122466,
		125,
		true
	},
	grapihcs3d_setting_shadow_update_mode_optionname0 = {
		1122591,
		116,
		true
	},
	grapihcs3d_setting_shadow_update_mode_optionname1 = {
		1122707,
		119,
		true
	},
	grapihcs3d_setting_shadow_update_mode_optionname2 = {
		1122826,
		117,
		true
	},
	grapihcs3d_setting_shadow_update_mode_optionname3 = {
		1122943,
		122,
		true
	},
	grapihcs3d_setting_terrain_layer_quality = {
		1123065,
		125,
		true
	},
	grapihcs3d_setting_terrain_layer_quality_optionname0 = {
		1123190,
		119,
		true
	},
	grapihcs3d_setting_terrain_layer_quality_optionname1 = {
		1123309,
		122,
		true
	},
	grapihcs3d_setting_terrain_layer_quality_optionname2 = {
		1123431,
		120,
		true
	},
	grapihcs3d_setting_enable_additional_lights = {
		1123551,
		121,
		true
	},
	grapihcs3d_setting_enable_reflection = {
		1123672,
		110,
		true
	},
	grapihcs3d_setting_character_quality = {
		1123782,
		123,
		true
	},
	grapihcs3d_setting_character_quality_optionname0 = {
		1123905,
		115,
		true
	},
	grapihcs3d_setting_character_quality_optionname1 = {
		1124020,
		118,
		true
	},
	grapihcs3d_setting_character_quality_optionname2 = {
		1124138,
		116,
		true
	},
	grapihcs3d_setting_enable_post_process = {
		1124254,
		117,
		true
	},
	grapihcs3d_setting_enable_post_antialiasing = {
		1124371,
		120,
		true
	},
	grapihcs3d_setting_enable_hdr = {
		1124491,
		96,
		true
	},
	grapihcs3d_setting_enable_distort = {
		1124587,
		107,
		true
	},
	grapihcs3d_setting_enable_dof = {
		1124694,
		107,
		true
	},
	grapihcs3d_setting_3Dquality = {
		1124801,
		100,
		true
	},
	grapihcs3d_setting_control = {
		1124901,
		98,
		true
	},
	grapihcs3d_setting_general = {
		1124999,
		105,
		true
	},
	grapihcs3d_setting_card_title = {
		1125104,
		100,
		true
	},
	grapihcs3d_setting_card_tag = {
		1125204,
		103,
		true
	},
	grapihcs3d_setting_card_socialdata = {
		1125307,
		110,
		true
	},
	grapihcs3d_setting_common_title = {
		1125417,
		118,
		true
	},
	grapihcs3d_setting_common_use = {
		1125535,
		96,
		true
	},
	grapihcs3d_setting_common_unstuck = {
		1125631,
		111,
		true
	},
	grapihcs3d_setting_common_unstuck_msgbox = {
		1125742,
		192,
		true
	},
	island_daily_gift_invite_success = {
		1125934,
		140,
		true
	},
	island_build_save_conflict = {
		1126074,
		104,
		true
	},
	island_build_save_success = {
		1126178,
		108,
		true
	},
	island_build_capacity_tip = {
		1126286,
		135,
		true
	},
	island_build_clean_tip = {
		1126421,
		138,
		true
	},
	island_build_revert_tip = {
		1126559,
		146,
		true
	},
	island_dress_exit = {
		1126705,
		120,
		true
	},
	island_dress_exit2 = {
		1126825,
		116,
		true
	},
	island_dress_mutually_exclusive = {
		1126941,
		166,
		true
	},
	island_dress_skin_buy = {
		1127107,
		117,
		true
	},
	island_dress_color_buy = {
		1127224,
		130,
		true
	},
	island_dress_color_unlock = {
		1127354,
		103,
		true
	},
	island_dress_save1 = {
		1127457,
		87,
		true
	},
	island_dress_save2 = {
		1127544,
		123,
		true
	},
	island_dress_mutually_exclusive1 = {
		1127667,
		135,
		true
	},
	island_dress_send_tip = {
		1127802,
		113,
		true
	},
	island_dress_send_tip_success = {
		1127915,
		108,
		true
	},
	handbook_new_player_task_locked_by_section = {
		1128023,
		163,
		true
	},
	handbook_new_player_guide_locked_by_level = {
		1128186,
		135,
		true
	},
	handbook_task_locked_by_level = {
		1128321,
		122,
		true
	},
	handbook_task_locked_by_other_task = {
		1128443,
		149,
		true
	},
	handbook_task_locked_by_chapter = {
		1128592,
		132,
		true
	},
	handbook_name = {
		1128724,
		85,
		true
	},
	handbook_process = {
		1128809,
		91,
		true
	},
	handbook_claim = {
		1128900,
		85,
		true
	},
	handbook_finished = {
		1128985,
		90,
		true
	},
	handbook_unfinished = {
		1129075,
		128,
		true
	},
	handbook_gametip = {
		1129203,
		1607,
		true
	},
	handbook_research_confirm = {
		1130810,
		104,
		true
	},
	handbook_research_final_task_desc_locked = {
		1130914,
		184,
		true
	},
	handbook_research_final_task_btn_locked = {
		1131098,
		114,
		true
	},
	handbook_research_final_task_btn_claim = {
		1131212,
		107,
		true
	},
	handbook_research_final_task_btn_finished = {
		1131319,
		112,
		true
	},
	handbook_ur_double_check = {
		1131431,
		242,
		true
	},
	NewMusic_1 = {
		1131673,
		87,
		true
	},
	NewMusic_2 = {
		1131760,
		86,
		true
	},
	NewMusic_help = {
		1131846,
		286,
		true
	},
	NewMusic_3 = {
		1132132,
		111,
		true
	},
	NewMusic_4 = {
		1132243,
		112,
		true
	},
	NewMusic_5 = {
		1132355,
		83,
		true
	},
	NewMusic_6 = {
		1132438,
		80,
		true
	},
	NewMusic_7 = {
		1132518,
		100,
		true
	},
	holiday_tip_minigame1 = {
		1132618,
		98,
		true
	},
	holiday_tip_minigame2 = {
		1132716,
		94,
		true
	},
	holiday_tip_bath = {
		1132810,
		93,
		true
	},
	holiday_tip_collection = {
		1132903,
		91,
		true
	},
	holiday_tip_task = {
		1132994,
		88,
		true
	},
	holiday_tip_shop = {
		1133082,
		88,
		true
	},
	holiday_tip_trans = {
		1133170,
		95,
		true
	},
	holiday_tip_task_now = {
		1133265,
		96,
		true
	},
	holiday_tip_finish = {
		1133361,
		259,
		true
	},
	holiday_tip_trans_get = {
		1133620,
		137,
		true
	},
	holiday_tip_rebuild_not = {
		1133757,
		130,
		true
	},
	holiday_tip_trans_not = {
		1133887,
		127,
		true
	},
	holiday_tip_task_finish = {
		1134014,
		135,
		true
	},
	holiday_tip_trans_tip = {
		1134149,
		99,
		true
	},
	holiday_tip_trans_desc1 = {
		1134248,
		348,
		true
	},
	holiday_tip_trans_desc2 = {
		1134596,
		348,
		true
	},
	holiday_tip_gametip = {
		1134944,
		1181,
		true
	},
	holiday_tip_spring = {
		1136125,
		299,
		true
	},
	activity_holiday_function_lock = {
		1136424,
		134,
		true
	},
	storyline_chapter0 = {
		1136558,
		90,
		true
	},
	storyline_chapter1 = {
		1136648,
		91,
		true
	},
	storyline_chapter2 = {
		1136739,
		91,
		true
	},
	storyline_chapter3 = {
		1136830,
		91,
		true
	},
	storyline_chapter4 = {
		1136921,
		91,
		true
	},
	storyline_memorysearch1 = {
		1137012,
		99,
		true
	},
	storyline_memorysearch2 = {
		1137111,
		99,
		true
	},
	use_amount_prefix = {
		1137210,
		93,
		true
	},
	sure_exit_resolve_equip = {
		1137303,
		205,
		true
	},
	resolve_equip_tip = {
		1137508,
		153,
		true
	},
	resolve_equip_title = {
		1137661,
		92,
		true
	},
	tec_catchup_0 = {
		1137753,
		85,
		true
	},
	tec_catchup_confirm = {
		1137838,
		303,
		true
	},
	watermelon_minigame_help = {
		1138141,
		306,
		true
	},
	breakout_tip = {
		1138447,
		98,
		true
	},
	collection_book_lock_place = {
		1138545,
		107,
		true
	},
	collection_book_tag_1 = {
		1138652,
		101,
		true
	},
	collection_book_tag_2 = {
		1138753,
		97,
		true
	},
	collection_book_tag_3 = {
		1138850,
		103,
		true
	},
	challenge_minigame_unlock = {
		1138953,
		104,
		true
	},
	storyline_camp = {
		1139057,
		87,
		true
	},
	storyline_goto = {
		1139144,
		92,
		true
	},
	holiday_villa_locked = {
		1139236,
		162,
		true
	},
	tech_shadow_change_button_1 = {
		1139398,
		106,
		true
	},
	tech_shadow_change_button_2 = {
		1139504,
		111,
		true
	},
	tech_shadow_limit_text = {
		1139615,
		105,
		true
	},
	tech_shadow_commit_tip = {
		1139720,
		146,
		true
	},
	shadow_scene_name = {
		1139866,
		96,
		true
	},
	shadow_unlock_tip = {
		1139962,
		138,
		true
	},
	shadow_skin_change_success = {
		1140100,
		141,
		true
	},
	add_skin_secretary_ship = {
		1140241,
		108,
		true
	},
	add_skin_random_secretary_ship_list = {
		1140349,
		119,
		true
	},
	choose_secretary_change_to_this_ship = {
		1140468,
		121,
		true
	},
	random_ship_custom_mode_add_shadow_complete = {
		1140589,
		162,
		true
	},
	random_ship_custom_mode_remove_shadow_complete = {
		1140751,
		169,
		true
	},
	choose_secretary_change_title = {
		1140920,
		102,
		true
	},
	ship_random_secretary_tag = {
		1141022,
		105,
		true
	},
	projection_help = {
		1141127,
		280,
		true
	},
	littleaijier_npc = {
		1141407,
		1483,
		true
	},
	brs_main_tip = {
		1142890,
		131,
		true
	},
	brs_expedition_tip = {
		1143021,
		140,
		true
	},
	brs_dmact_tip = {
		1143161,
		92,
		true
	},
	brs_reward_tip_1 = {
		1143253,
		93,
		true
	},
	brs_reward_tip_2 = {
		1143346,
		82,
		true
	},
	dorm3d_dance_button = {
		1143428,
		88,
		true
	},
	dorm3d_collection_cafe = {
		1143516,
		91,
		true
	},
	zengke_series_help = {
		1143607,
		1395,
		true
	},
	zengke_series_pt = {
		1145002,
		85,
		true
	},
	zengke_series_pt_small = {
		1145087,
		91,
		true
	},
	zengke_series_rank = {
		1145178,
		89,
		true
	},
	zengke_series_rank_small = {
		1145267,
		95,
		true
	},
	zengke_series_task = {
		1145362,
		90,
		true
	},
	zengke_series_task_small = {
		1145452,
		96,
		true
	},
	zengke_series_confirm = {
		1145548,
		91,
		true
	},
	zengke_story_reward_count = {
		1145639,
		142,
		true
	},
	zengke_series_easy = {
		1145781,
		86,
		true
	},
	zengke_series_normal = {
		1145867,
		90,
		true
	},
	zengke_series_hard = {
		1145957,
		86,
		true
	},
	zengke_series_sp = {
		1146043,
		82,
		true
	},
	zengke_series_ex = {
		1146125,
		82,
		true
	},
	zengke_series_ex_confirm = {
		1146207,
		94,
		true
	},
	battleui_display1 = {
		1146301,
		85,
		true
	},
	battleui_display2 = {
		1146386,
		87,
		true
	},
	battleui_display3 = {
		1146473,
		90,
		true
	},
	zengke_series_serverinfo = {
		1146563,
		95,
		true
	},
	grapihcs3d_setting_bloom = {
		1146658,
		102,
		true
	},
	grapihcs3d_setting_bloom_optionname0 = {
		1146760,
		104,
		true
	},
	grapihcs3d_setting_bloom_optionname1 = {
		1146864,
		103,
		true
	},
	SkinDiscountHelp_Carnival = {
		1146967,
		707,
		true
	},
	open_today = {
		1147674,
		85,
		true
	},
	daily_level_go = {
		1147759,
		80,
		true
	},
	yumia_main_tip_1 = {
		1147839,
		85,
		true
	},
	yumia_main_tip_2 = {
		1147924,
		86,
		true
	},
	yumia_main_tip_3 = {
		1148010,
		85,
		true
	},
	yumia_main_tip_4 = {
		1148095,
		127,
		true
	},
	yumia_main_tip_5 = {
		1148222,
		85,
		true
	},
	yumia_main_tip_6 = {
		1148307,
		93,
		true
	},
	yumia_main_tip_7 = {
		1148400,
		87,
		true
	},
	yumia_main_tip_8 = {
		1148487,
		89,
		true
	},
	yumia_main_tip_9 = {
		1148576,
		91,
		true
	},
	yumia_base_name_1 = {
		1148667,
		98,
		true
	},
	yumia_base_name_2 = {
		1148765,
		100,
		true
	},
	yumia_base_name_3 = {
		1148865,
		98,
		true
	},
	yumia_stronghold_1 = {
		1148963,
		95,
		true
	},
	yumia_stronghold_2 = {
		1149058,
		131,
		true
	},
	yumia_stronghold_3 = {
		1149189,
		93,
		true
	},
	yumia_stronghold_4 = {
		1149282,
		95,
		true
	},
	yumia_stronghold_5 = {
		1149377,
		97,
		true
	},
	yumia_stronghold_6 = {
		1149474,
		90,
		true
	},
	yumia_stronghold_7 = {
		1149564,
		90,
		true
	},
	yumia_stronghold_8 = {
		1149654,
		98,
		true
	},
	yumia_stronghold_9 = {
		1149752,
		88,
		true
	},
	yumia_stronghold_10 = {
		1149840,
		97,
		true
	},
	yumia_award_1 = {
		1149937,
		81,
		true
	},
	yumia_award_2 = {
		1150018,
		86,
		true
	},
	yumia_award_3 = {
		1150104,
		87,
		true
	},
	yumia_award_4 = {
		1150191,
		92,
		true
	},
	yumia_pt_1 = {
		1150283,
		161,
		true
	},
	yumia_pt_2 = {
		1150444,
		85,
		true
	},
	yumia_pt_3 = {
		1150529,
		82,
		true
	},
	yumia_mana_battle_tip = {
		1150611,
		221,
		true
	},
	yumia_buff_name_1 = {
		1150832,
		100,
		true
	},
	yumia_buff_name_2 = {
		1150932,
		94,
		true
	},
	yumia_buff_name_3 = {
		1151026,
		94,
		true
	},
	yumia_buff_name_4 = {
		1151120,
		94,
		true
	},
	yumia_buff_name_5 = {
		1151214,
		90,
		true
	},
	yumia_buff_desc_1 = {
		1151304,
		163,
		true
	},
	yumia_buff_desc_2 = {
		1151467,
		163,
		true
	},
	yumia_buff_desc_3 = {
		1151630,
		163,
		true
	},
	yumia_buff_desc_4 = {
		1151793,
		163,
		true
	},
	yumia_buff_desc_5 = {
		1151956,
		163,
		true
	},
	yumia_buff_1 = {
		1152119,
		92,
		true
	},
	yumia_buff_2 = {
		1152211,
		84,
		true
	},
	yumia_buff_3 = {
		1152295,
		85,
		true
	},
	yumia_buff_4 = {
		1152380,
		123,
		true
	},
	yumia_atelier_tip1 = {
		1152503,
		123,
		true
	},
	yumia_atelier_tip2 = {
		1152626,
		86,
		true
	},
	yumia_atelier_tip3 = {
		1152712,
		87,
		true
	},
	yumia_atelier_tip4 = {
		1152799,
		89,
		true
	},
	yumia_atelier_tip5 = {
		1152888,
		107,
		true
	},
	yumia_atelier_tip6 = {
		1152995,
		89,
		true
	},
	yumia_atelier_tip7 = {
		1153084,
		111,
		true
	},
	yumia_atelier_tip8 = {
		1153195,
		95,
		true
	},
	yumia_atelier_tip9 = {
		1153290,
		97,
		true
	},
	yumia_atelier_tip10 = {
		1153387,
		99,
		true
	},
	yumia_atelier_tip11 = {
		1153486,
		101,
		true
	},
	yumia_atelier_tip12 = {
		1153587,
		100,
		true
	},
	yumia_atelier_tip13 = {
		1153687,
		96,
		true
	},
	yumia_atelier_tip14 = {
		1153783,
		90,
		true
	},
	yumia_atelier_tip15 = {
		1153873,
		98,
		true
	},
	yumia_atelier_tip16 = {
		1153971,
		90,
		true
	},
	yumia_atelier_tip17 = {
		1154061,
		111,
		true
	},
	yumia_atelier_tip18 = {
		1154172,
		98,
		true
	},
	yumia_atelier_tip19 = {
		1154270,
		115,
		true
	},
	yumia_atelier_tip20 = {
		1154385,
		120,
		true
	},
	yumia_atelier_tip21 = {
		1154505,
		110,
		true
	},
	yumia_atelier_tip22 = {
		1154615,
		628,
		true
	},
	yumia_atelier_tip23 = {
		1155243,
		92,
		true
	},
	yumia_atelier_tip24 = {
		1155335,
		96,
		true
	},
	yumia_storymode_tip1 = {
		1155431,
		103,
		true
	},
	yumia_storymode_tip2 = {
		1155534,
		122,
		true
	},
	yumia_pt_tip = {
		1155656,
		81,
		true
	},
	yumia_pt_4 = {
		1155737,
		82,
		true
	},
	masaina_main_title = {
		1155819,
		102,
		true
	},
	masaina_main_title_en = {
		1155921,
		105,
		true
	},
	masaina_main_sheet1 = {
		1156026,
		93,
		true
	},
	masaina_main_sheet2 = {
		1156119,
		92,
		true
	},
	masaina_main_sheet3 = {
		1156211,
		90,
		true
	},
	masaina_main_sheet4 = {
		1156301,
		91,
		true
	},
	masaina_main_skin_tag = {
		1156392,
		93,
		true
	},
	masaina_main_other_tag = {
		1156485,
		97,
		true
	},
	shop_title = {
		1156582,
		78,
		true
	},
	shop_recommend = {
		1156660,
		81,
		true
	},
	shop_recommend_en = {
		1156741,
		84,
		true
	},
	shop_skin = {
		1156825,
		78,
		true
	},
	shop_skin_en = {
		1156903,
		81,
		true
	},
	shop_supply_prop = {
		1156984,
		86,
		true
	},
	shop_supply_prop_en = {
		1157070,
		89,
		true
	},
	shop_skin_new = {
		1157159,
		84,
		true
	},
	shop_skin_permanent = {
		1157243,
		90,
		true
	},
	shop_month = {
		1157333,
		81,
		true
	},
	shop_supply = {
		1157414,
		81,
		true
	},
	shop_activity = {
		1157495,
		91,
		true
	},
	shop_package_sort_0 = {
		1157586,
		86,
		true
	},
	shop_package_sort_en_0 = {
		1157672,
		89,
		true
	},
	shop_package_sort_1 = {
		1157761,
		97,
		true
	},
	shop_package_sort_en_1 = {
		1157858,
		100,
		true
	},
	shop_package_sort_2 = {
		1157958,
		88,
		true
	},
	shop_package_sort_en_2 = {
		1158046,
		91,
		true
	},
	shop_package_sort_3 = {
		1158137,
		85,
		true
	},
	shop_package_sort_en_3 = {
		1158222,
		88,
		true
	},
	shop_goods_left_day = {
		1158310,
		91,
		true
	},
	shop_goods_left_hour = {
		1158401,
		92,
		true
	},
	shop_goods_left_minute = {
		1158493,
		94,
		true
	},
	shop_refresh_time = {
		1158587,
		93,
		true
	},
	shop_side_lable_en = {
		1158680,
		91,
		true
	},
	street_shop_titleen = {
		1158771,
		87,
		true
	},
	military_shop_titleen = {
		1158858,
		90,
		true
	},
	guild_shop_titleen = {
		1158948,
		87,
		true
	},
	meta_shop_titleen = {
		1159035,
		85,
		true
	},
	mini_game_shop_titleen = {
		1159120,
		91,
		true
	},
	shop_item_unlock = {
		1159211,
		92,
		true
	},
	shop_item_unobtained = {
		1159303,
		94,
		true
	},
	beat_game_rule = {
		1159397,
		83,
		true
	},
	beat_game_rank = {
		1159480,
		85,
		true
	},
	beat_game_go = {
		1159565,
		78,
		true
	},
	beat_game_start = {
		1159643,
		89,
		true
	},
	beat_game_high_score = {
		1159732,
		94,
		true
	},
	beat_game_current_score = {
		1159826,
		100,
		true
	},
	beat_game_exit_desc = {
		1159926,
		142,
		true
	},
	musicbeat_minigame_help = {
		1160068,
		908,
		true
	},
	masaina_pt_claimed = {
		1160976,
		90,
		true
	},
	activity_shop_titleen = {
		1161066,
		90,
		true
	},
	shop_diamond_title_en = {
		1161156,
		89,
		true
	},
	shop_gift_title_en = {
		1161245,
		87,
		true
	},
	shop_item_title_en = {
		1161332,
		87,
		true
	},
	shop_pack_empty = {
		1161419,
		96,
		true
	},
	shop_new_unfound = {
		1161515,
		126,
		true
	},
	shop_new_shop = {
		1161641,
		81,
		true
	},
	shop_new_during_day = {
		1161722,
		91,
		true
	},
	shop_new_during_hour = {
		1161813,
		92,
		true
	},
	shop_new_during_minite = {
		1161905,
		94,
		true
	},
	shop_new_sort = {
		1161999,
		83,
		true
	},
	shop_new_search = {
		1162082,
		92,
		true
	},
	shop_new_purchased = {
		1162174,
		91,
		true
	},
	shop_new_purchase = {
		1162265,
		89,
		true
	},
	shop_new_claim = {
		1162354,
		85,
		true
	},
	shop_new_furniture = {
		1162439,
		96,
		true
	},
	shop_new_discount = {
		1162535,
		91,
		true
	},
	shop_new_try = {
		1162626,
		82,
		true
	},
	shop_new_gift = {
		1162708,
		81,
		true
	},
	shop_new_gem_transform = {
		1162789,
		122,
		true
	},
	shop_new_review = {
		1162911,
		84,
		true
	},
	shop_new_all = {
		1162995,
		79,
		true
	},
	shop_new_owned = {
		1163074,
		83,
		true
	},
	shop_new_havent_own = {
		1163157,
		90,
		true
	},
	shop_new_unused = {
		1163247,
		95,
		true
	},
	shop_new_type = {
		1163342,
		81,
		true
	},
	shop_new_static = {
		1163423,
		85,
		true
	},
	shop_new_dynamic = {
		1163508,
		87,
		true
	},
	shop_new_static_bg = {
		1163595,
		92,
		true
	},
	shop_new_dynamic_bg = {
		1163687,
		94,
		true
	},
	shop_new_bgm = {
		1163781,
		79,
		true
	},
	shop_new_index = {
		1163860,
		82,
		true
	},
	shop_new_ship_owned = {
		1163942,
		93,
		true
	},
	shop_new_ship_havent_owned = {
		1164035,
		102,
		true
	},
	shop_new_nation = {
		1164137,
		86,
		true
	},
	shop_new_rarity = {
		1164223,
		85,
		true
	},
	shop_new_category = {
		1164308,
		89,
		true
	},
	shop_new_skin_theme = {
		1164397,
		88,
		true
	},
	shop_new_confirm = {
		1164485,
		87,
		true
	},
	shop_new_during_time = {
		1164572,
		93,
		true
	},
	shop_new_daily = {
		1164665,
		83,
		true
	},
	shop_new_recommend = {
		1164748,
		85,
		true
	},
	shop_new_skin_shop = {
		1164833,
		87,
		true
	},
	shop_new_purchase_gem = {
		1164920,
		89,
		true
	},
	shop_new_akashi_recommend = {
		1165009,
		100,
		true
	},
	shop_new_packs = {
		1165109,
		83,
		true
	},
	shop_new_props = {
		1165192,
		83,
		true
	},
	shop_new_ptshop = {
		1165275,
		85,
		true
	},
	shop_new_skin_new = {
		1165360,
		88,
		true
	},
	shop_new_skin_permanent = {
		1165448,
		90,
		true
	},
	shop_new_in_use = {
		1165538,
		85,
		true
	},
	shop_new_unable_to_use = {
		1165623,
		94,
		true
	},
	shop_new_owned_skin = {
		1165717,
		88,
		true
	},
	shop_new_wear = {
		1165805,
		81,
		true
	},
	shop_new_get_now = {
		1165886,
		90,
		true
	},
	shop_new_remaining_time = {
		1165976,
		125,
		true
	},
	shop_new_remove = {
		1166101,
		95,
		true
	},
	shop_new_retro = {
		1166196,
		83,
		true
	},
	shop_new_able_to_exchange = {
		1166279,
		105,
		true
	},
	shop_countdown = {
		1166384,
		97,
		true
	},
	quota_shop_title1en = {
		1166481,
		83,
		true
	},
	sham_shop_titleen = {
		1166564,
		81,
		true
	},
	medal_shop_titleen = {
		1166645,
		82,
		true
	},
	fragment_shop_titleen = {
		1166727,
		85,
		true
	},
	shop_fragment_resolve = {
		1166812,
		103,
		true
	},
	beat_game_my_record = {
		1166915,
		90,
		true
	},
	shop_filter_all = {
		1167005,
		82,
		true
	},
	shop_filter_trial = {
		1167087,
		87,
		true
	},
	shop_filter_retro = {
		1167174,
		86,
		true
	},
	island_chara_invitename = {
		1167260,
		117,
		true
	},
	island_chara_totalname = {
		1167377,
		103,
		true
	},
	island_chara_totalname_en = {
		1167480,
		97,
		true
	},
	island_chara_power = {
		1167577,
		89,
		true
	},
	island_chara_attribute1 = {
		1167666,
		92,
		true
	},
	island_chara_attribute2 = {
		1167758,
		92,
		true
	},
	island_chara_attribute3 = {
		1167850,
		92,
		true
	},
	island_chara_attribute4 = {
		1167942,
		92,
		true
	},
	island_chara_attribute5 = {
		1168034,
		92,
		true
	},
	island_chara_attribute6 = {
		1168126,
		93,
		true
	},
	island_chara_skill_lock = {
		1168219,
		115,
		true
	},
	island_chara_list = {
		1168334,
		95,
		true
	},
	island_chara_list_filter = {
		1168429,
		94,
		true
	},
	island_chara_list_sort = {
		1168523,
		90,
		true
	},
	island_chara_list_level = {
		1168613,
		99,
		true
	},
	island_chara_list_attribute = {
		1168712,
		105,
		true
	},
	island_chara_list_workspeed = {
		1168817,
		101,
		true
	},
	island_index_name = {
		1168918,
		93,
		true
	},
	island_index_extra_all = {
		1169011,
		95,
		true
	},
	island_index_potency = {
		1169106,
		98,
		true
	},
	island_index_skill = {
		1169204,
		98,
		true
	},
	island_index_status = {
		1169302,
		89,
		true
	},
	island_confirm = {
		1169391,
		86,
		true
	},
	island_cancel = {
		1169477,
		83,
		true
	},
	island_chara_levelup = {
		1169560,
		92,
		true
	},
	islland_chara_material_consum = {
		1169652,
		106,
		true
	},
	island_chara_up_button = {
		1169758,
		94,
		true
	},
	island_chara_now_rank = {
		1169852,
		97,
		true
	},
	island_chara_breakout = {
		1169949,
		92,
		true
	},
	island_chara_skill_tip = {
		1170041,
		99,
		true
	},
	island_chara_consum = {
		1170140,
		88,
		true
	},
	island_chara_breakout_button = {
		1170228,
		99,
		true
	},
	island_chara_breakout_down = {
		1170327,
		98,
		true
	},
	island_chara_level_limit = {
		1170425,
		97,
		true
	},
	island_chara_power_limit = {
		1170522,
		99,
		true
	},
	island_click_to_close = {
		1170621,
		98,
		true
	},
	island_chara_skill_unlock = {
		1170719,
		103,
		true
	},
	island_chara_attribute_develop = {
		1170822,
		107,
		true
	},
	island_chara_choose_attribute = {
		1170929,
		115,
		true
	},
	island_chara_rating_up = {
		1171044,
		99,
		true
	},
	island_chara_limit_up = {
		1171143,
		96,
		true
	},
	island_chara_ceiling_unlock = {
		1171239,
		161,
		true
	},
	island_chara_choose_gift = {
		1171400,
		106,
		true
	},
	island_chara_buff_better = {
		1171506,
		142,
		true
	},
	island_chara_buff_nomal = {
		1171648,
		135,
		true
	},
	island_chara_gift_power = {
		1171783,
		107,
		true
	},
	island_visit_title = {
		1171890,
		87,
		true
	},
	island_visit_friend = {
		1171977,
		90,
		true
	},
	island_visit_teammate = {
		1172067,
		90,
		true
	},
	island_visit_code = {
		1172157,
		91,
		true
	},
	island_visit_search = {
		1172248,
		89,
		true
	},
	island_visit_whitelist = {
		1172337,
		95,
		true
	},
	island_visit_balcklist = {
		1172432,
		95,
		true
	},
	island_visit_set = {
		1172527,
		88,
		true
	},
	island_visit_delete = {
		1172615,
		89,
		true
	},
	island_visit_more = {
		1172704,
		85,
		true
	},
	island_visit_code_title = {
		1172789,
		97,
		true
	},
	island_visit_code_input = {
		1172886,
		97,
		true
	},
	island_visit_code_like = {
		1172983,
		101,
		true
	},
	island_visit_code_likelist = {
		1173084,
		104,
		true
	},
	island_visit_code_remove = {
		1173188,
		94,
		true
	},
	island_visit_code_copy = {
		1173282,
		90,
		true
	},
	island_visit_search_mineid = {
		1173372,
		93,
		true
	},
	island_visit_search_input = {
		1173465,
		105,
		true
	},
	island_visit_whitelist_tip = {
		1173570,
		153,
		true
	},
	island_visit_balcklist_tip = {
		1173723,
		152,
		true
	},
	island_visit_set_title = {
		1173875,
		107,
		true
	},
	island_visit_set_tip = {
		1173982,
		110,
		true
	},
	island_visit_set_refresh = {
		1174092,
		95,
		true
	},
	island_visit_set_close = {
		1174187,
		110,
		true
	},
	island_visit_set_help = {
		1174297,
		405,
		true
	},
	island_visitor_button = {
		1174702,
		90,
		true
	},
	island_visitor_status = {
		1174792,
		93,
		true
	},
	island_visitor_record = {
		1174885,
		94,
		true
	},
	island_visitor_num = {
		1174979,
		88,
		true
	},
	island_visitor_kick = {
		1175067,
		87,
		true
	},
	island_visitor_kickall = {
		1175154,
		94,
		true
	},
	island_visitor_close = {
		1175248,
		99,
		true
	},
	island_lineup_tip = {
		1175347,
		155,
		true
	},
	island_lineup_button = {
		1175502,
		96,
		true
	},
	island_visit_tip1 = {
		1175598,
		101,
		true
	},
	island_visit_tip2 = {
		1175699,
		117,
		true
	},
	island_visit_tip3 = {
		1175816,
		108,
		true
	},
	island_visit_tip4 = {
		1175924,
		113,
		true
	},
	island_visit_tip5 = {
		1176037,
		99,
		true
	},
	island_visit_tip6 = {
		1176136,
		102,
		true
	},
	island_visit_tip7 = {
		1176238,
		120,
		true
	},
	island_season_help = {
		1176358,
		972,
		true
	},
	island_season_title = {
		1177330,
		89,
		true
	},
	island_season_pt_hold = {
		1177419,
		93,
		true
	},
	island_season_pt_collectall = {
		1177512,
		101,
		true
	},
	island_season_activity = {
		1177613,
		91,
		true
	},
	island_season_pt = {
		1177704,
		96,
		true
	},
	island_season_task = {
		1177800,
		98,
		true
	},
	island_season_shop = {
		1177898,
		86,
		true
	},
	island_season_charts = {
		1177984,
		100,
		true
	},
	island_season_review = {
		1178084,
		90,
		true
	},
	island_season_task_collect = {
		1178174,
		95,
		true
	},
	island_season_task_collected = {
		1178269,
		99,
		true
	},
	island_season_task_collectall = {
		1178368,
		102,
		true
	},
	island_season_shop_stage1 = {
		1178470,
		96,
		true
	},
	island_season_shop_stage2 = {
		1178566,
		96,
		true
	},
	island_season_shop_stage3 = {
		1178662,
		96,
		true
	},
	island_season_charts_ranking = {
		1178758,
		108,
		true
	},
	island_season_charts_information = {
		1178866,
		107,
		true
	},
	island_season_charts_pt = {
		1178973,
		105,
		true
	},
	island_season_charts_award = {
		1179078,
		105,
		true
	},
	island_season_charts_level = {
		1179183,
		107,
		true
	},
	island_season_charts_refresh = {
		1179290,
		144,
		true
	},
	island_season_charts_out = {
		1179434,
		96,
		true
	},
	island_season_review_lv = {
		1179530,
		100,
		true
	},
	island_season_review_charnum = {
		1179630,
		109,
		true
	},
	island_season_review_projuctnum = {
		1179739,
		109,
		true
	},
	island_season_review_titleone = {
		1179848,
		99,
		true
	},
	island_season_review_ptnum = {
		1179947,
		93,
		true
	},
	island_season_review_ptrank = {
		1180040,
		107,
		true
	},
	island_season_review_produce = {
		1180147,
		113,
		true
	},
	island_season_review_ordernum = {
		1180260,
		104,
		true
	},
	island_season_review_formulanum = {
		1180364,
		103,
		true
	},
	island_season_review_relax = {
		1180467,
		101,
		true
	},
	island_season_review_fishnum = {
		1180568,
		100,
		true
	},
	island_season_review_gamenum = {
		1180668,
		106,
		true
	},
	island_season_review_achi = {
		1180774,
		100,
		true
	},
	island_season_review_achinum = {
		1180874,
		100,
		true
	},
	island_season_review_guidenum = {
		1180974,
		107,
		true
	},
	island_season_review_blank = {
		1181081,
		121,
		true
	},
	island_season_window_end = {
		1181202,
		113,
		true
	},
	island_season_window_end2 = {
		1181315,
		114,
		true
	},
	island_season_window_rule = {
		1181429,
		813,
		true
	},
	island_season_window_transformtip = {
		1182242,
		142,
		true
	},
	island_season_window_pt = {
		1182384,
		127,
		true
	},
	island_season_window_ranking = {
		1182511,
		105,
		true
	},
	island_season_window_award = {
		1182616,
		105,
		true
	},
	island_season_window_out = {
		1182721,
		98,
		true
	},
	island_season_review_miss = {
		1182819,
		134,
		true
	},
	island_season_reset = {
		1182953,
		109,
		true
	},
	island_help_ship_order = {
		1183062,
		568,
		true
	},
	island_help_farm = {
		1183630,
		295,
		true
	},
	island_help_commission = {
		1183925,
		503,
		true
	},
	island_help_cafe_minigame = {
		1184428,
		313,
		true
	},
	island_help_signin = {
		1184741,
		361,
		true
	},
	island_help_ranch = {
		1185102,
		358,
		true
	},
	island_help_manage = {
		1185460,
		544,
		true
	},
	island_help_combo = {
		1186004,
		358,
		true
	},
	island_help_friends = {
		1186362,
		364,
		true
	},
	island_help_season = {
		1186726,
		544,
		true
	},
	island_help_archive = {
		1187270,
		302,
		true
	},
	island_help_renovation = {
		1187572,
		373,
		true
	},
	island_help_photo = {
		1187945,
		298,
		true
	},
	island_help_greet = {
		1188243,
		358,
		true
	},
	island_help_character_info = {
		1188601,
		454,
		true
	},
	island_help_fish = {
		1189055,
		414,
		true
	},
	island_skin_original_desc = {
		1189469,
		96,
		true
	},
	island_dress_no_item = {
		1189565,
		118,
		true
	},
	island_agora_deco_empty = {
		1189683,
		97,
		true
	},
	island_agora_pos_unavailability = {
		1189780,
		109,
		true
	},
	island_agora_max_capacity = {
		1189889,
		113,
		true
	},
	island_agora_label_base = {
		1190002,
		94,
		true
	},
	island_agora_label_building = {
		1190096,
		95,
		true
	},
	island_agora_label_furniture = {
		1190191,
		103,
		true
	},
	island_agora_label_dec = {
		1190294,
		97,
		true
	},
	island_agora_label_floor = {
		1190391,
		94,
		true
	},
	island_agora_label_tile = {
		1190485,
		104,
		true
	},
	island_agora_label_collection = {
		1190589,
		103,
		true
	},
	island_agora_label_default = {
		1190692,
		97,
		true
	},
	island_agora_label_rarity = {
		1190789,
		95,
		true
	},
	island_agora_label_gettime = {
		1190884,
		103,
		true
	},
	island_agora_label_capacity = {
		1190987,
		99,
		true
	},
	island_agora_capacity = {
		1191086,
		99,
		true
	},
	island_agora_furniure_preview = {
		1191185,
		100,
		true
	},
	island_agora_function_unuse = {
		1191285,
		131,
		true
	},
	island_agora_signIn_tip = {
		1191416,
		146,
		true
	},
	island_agora_working = {
		1191562,
		109,
		true
	},
	island_agora_using = {
		1191671,
		88,
		true
	},
	island_agora_save_theme = {
		1191759,
		97,
		true
	},
	island_agora_btn_label_clear = {
		1191856,
		97,
		true
	},
	island_agora_btn_label_revert = {
		1191953,
		98,
		true
	},
	island_agora_btn_label_save = {
		1192051,
		95,
		true
	},
	island_agora_title = {
		1192146,
		101,
		true
	},
	island_agora_label_search = {
		1192247,
		102,
		true
	},
	island_agora_label_theme = {
		1192349,
		93,
		true
	},
	island_agora_label_empty_tip = {
		1192442,
		127,
		true
	},
	island_agora_clear_tip = {
		1192569,
		127,
		true
	},
	island_agora_revert_tip = {
		1192696,
		120,
		true
	},
	island_agora_save_or_exit_tip = {
		1192816,
		137,
		true
	},
	island_agora_exit_and_unsave = {
		1192953,
		104,
		true
	},
	island_agora_exit_and_save = {
		1193057,
		102,
		true
	},
	island_agora_no_pos_place = {
		1193159,
		121,
		true
	},
	island_agora_pave_tip = {
		1193280,
		110,
		true
	},
	island_enter_island_ban = {
		1193390,
		103,
		true
	},
	island_order_not_get_award = {
		1193493,
		113,
		true
	},
	island_order_cant_replace = {
		1193606,
		113,
		true
	},
	island_rename_tip = {
		1193719,
		134,
		true
	},
	island_rename_confirm = {
		1193853,
		126,
		true
	},
	island_bag_max_level = {
		1193979,
		102,
		true
	},
	island_bag_uprade_success = {
		1194081,
		105,
		true
	},
	island_agora_save_success = {
		1194186,
		108,
		true
	},
	island_agora_max_level = {
		1194294,
		104,
		true
	},
	island_white_list_full = {
		1194398,
		109,
		true
	},
	island_black_list_full = {
		1194507,
		109,
		true
	},
	island_inviteCode_refresh = {
		1194616,
		131,
		true
	},
	island_give_gift_success = {
		1194747,
		99,
		true
	},
	island_get_git_tip = {
		1194846,
		127,
		true
	},
	island_get_git_cnt_tip = {
		1194973,
		118,
		true
	},
	island_share_gift_success = {
		1195091,
		102,
		true
	},
	island_invitation_gift_success = {
		1195193,
		138,
		true
	},
	island_dectect_mode3x3 = {
		1195331,
		105,
		true
	},
	island_dectect_mode1x1 = {
		1195436,
		108,
		true
	},
	island_ship_buff_cover = {
		1195544,
		161,
		true
	},
	island_ship_buff_cover_1 = {
		1195705,
		163,
		true
	},
	island_ship_buff_cover_2 = {
		1195868,
		154,
		true
	},
	island_ship_buff_cover_3 = {
		1196022,
		154,
		true
	},
	island_log_visit = {
		1196176,
		104,
		true
	},
	island_log_exit = {
		1196280,
		100,
		true
	},
	island_log_gift = {
		1196380,
		116,
		true
	},
	island_log_trade = {
		1196496,
		111,
		true
	},
	island_item_type_res = {
		1196607,
		93,
		true
	},
	island_item_type_consume = {
		1196700,
		99,
		true
	},
	island_item_type_spe = {
		1196799,
		91,
		true
	},
	island_ship_attrName_1 = {
		1196890,
		91,
		true
	},
	island_ship_attrName_2 = {
		1196981,
		91,
		true
	},
	island_ship_attrName_3 = {
		1197072,
		91,
		true
	},
	island_ship_attrName_4 = {
		1197163,
		91,
		true
	},
	island_ship_attrName_5 = {
		1197254,
		91,
		true
	},
	island_ship_attrName_6 = {
		1197345,
		92,
		true
	},
	island_task_title = {
		1197437,
		97,
		true
	},
	island_task_title_en = {
		1197534,
		92,
		true
	},
	island_task_type_1 = {
		1197626,
		85,
		true
	},
	island_task_type_2 = {
		1197711,
		100,
		true
	},
	island_task_type_3 = {
		1197811,
		93,
		true
	},
	island_task_type_4 = {
		1197904,
		87,
		true
	},
	island_task_type_5 = {
		1197991,
		88,
		true
	},
	island_task_type_6 = {
		1198079,
		87,
		true
	},
	island_tech_type_1 = {
		1198166,
		97,
		true
	},
	island_default_name = {
		1198263,
		94,
		true
	},
	island_order_type_1 = {
		1198357,
		99,
		true
	},
	island_order_type_2 = {
		1198456,
		98,
		true
	},
	island_order_desc_1 = {
		1198554,
		148,
		true
	},
	island_order_desc_2 = {
		1198702,
		172,
		true
	},
	island_order_desc_3 = {
		1198874,
		173,
		true
	},
	island_order_difficulty_1 = {
		1199047,
		95,
		true
	},
	island_order_difficulty_2 = {
		1199142,
		93,
		true
	},
	island_order_difficulty_3 = {
		1199235,
		93,
		true
	},
	island_commander = {
		1199328,
		89,
		true
	},
	island_task_lefttime = {
		1199417,
		105,
		true
	},
	island_seek_game_tip = {
		1199522,
		117,
		true
	},
	island_item_transfer = {
		1199639,
		120,
		true
	},
	island_set_manifesto_success = {
		1199759,
		105,
		true
	},
	island_prosperity_level = {
		1199864,
		96,
		true
	},
	island_toast_status = {
		1199960,
		107,
		true
	},
	island_toast_level = {
		1200067,
		106,
		true
	},
	island_toast_ship = {
		1200173,
		107,
		true
	},
	island_lock_map_tip = {
		1200280,
		116,
		true
	},
	island_home_btn_cant_use = {
		1200396,
		127,
		true
	},
	island_item_overflow = {
		1200523,
		98,
		true
	},
	island_item_no_capacity = {
		1200621,
		104,
		true
	},
	island_ship_no_energy = {
		1200725,
		94,
		true
	},
	island_ship_working = {
		1200819,
		91,
		true
	},
	island_ship_level_limit = {
		1200910,
		98,
		true
	},
	island_ship_energy_limit = {
		1201008,
		97,
		true
	},
	island_click_close = {
		1201105,
		94,
		true
	},
	island_break_finish = {
		1201199,
		116,
		true
	},
	island_unlock_skill = {
		1201315,
		122,
		true
	},
	island_ship_title_info = {
		1201437,
		100,
		true
	},
	island_building_title_info = {
		1201537,
		102,
		true
	},
	island_word_effect = {
		1201639,
		89,
		true
	},
	island_word_dispatch = {
		1201728,
		95,
		true
	},
	island_word_working = {
		1201823,
		90,
		true
	},
	island_word_stop_work = {
		1201913,
		97,
		true
	},
	island_level_to_unlock = {
		1202010,
		113,
		true
	},
	island_select_product = {
		1202123,
		99,
		true
	},
	island_sub_product_cnt = {
		1202222,
		102,
		true
	},
	island_make_unlock_tip = {
		1202324,
		109,
		true
	},
	island_need_star = {
		1202433,
		109,
		true
	},
	island_need_star_1 = {
		1202542,
		105,
		true
	},
	island_select_ship = {
		1202647,
		98,
		true
	},
	island_select_ship_label_1 = {
		1202745,
		99,
		true
	},
	island_select_ship_overview = {
		1202844,
		100,
		true
	},
	island_select_ship_tip = {
		1202944,
		417,
		true
	},
	island_friend = {
		1203361,
		84,
		true
	},
	island_guild = {
		1203445,
		81,
		true
	},
	island_code = {
		1203526,
		85,
		true
	},
	island_search = {
		1203611,
		83,
		true
	},
	island_whiteList = {
		1203694,
		89,
		true
	},
	island_add_friend = {
		1203783,
		84,
		true
	},
	island_blackList = {
		1203867,
		89,
		true
	},
	island_settings = {
		1203956,
		87,
		true
	},
	island_settings_en = {
		1204043,
		90,
		true
	},
	island_btn_label_visit = {
		1204133,
		91,
		true
	},
	island_git_cnt_tip = {
		1204224,
		99,
		true
	},
	island_public_invitation = {
		1204323,
		101,
		true
	},
	island_onekey_invitation = {
		1204424,
		98,
		true
	},
	island_public_invitation_1 = {
		1204522,
		112,
		true
	},
	island_curr_visitor = {
		1204634,
		91,
		true
	},
	island_visitor_log = {
		1204725,
		91,
		true
	},
	island_kick_all = {
		1204816,
		87,
		true
	},
	island_close_visit = {
		1204903,
		94,
		true
	},
	island_curr_people_cnt = {
		1204997,
		95,
		true
	},
	island_close_access_state = {
		1205092,
		117,
		true
	},
	island_btn_label_remove = {
		1205209,
		93,
		true
	},
	island_btn_label_del = {
		1205302,
		90,
		true
	},
	island_btn_label_copy = {
		1205392,
		89,
		true
	},
	island_btn_label_more = {
		1205481,
		90,
		true
	},
	island_btn_label_invitation = {
		1205571,
		97,
		true
	},
	island_btn_label_invitation_already = {
		1205668,
		106,
		true
	},
	island_btn_label_online = {
		1205774,
		96,
		true
	},
	island_btn_label_kick = {
		1205870,
		89,
		true
	},
	island_btn_label_location = {
		1205959,
		107,
		true
	},
	island_black_list_tip = {
		1206066,
		128,
		true
	},
	island_white_list_tip = {
		1206194,
		162,
		true
	},
	island_input_code_tip = {
		1206356,
		95,
		true
	},
	island_input_code_tip_1 = {
		1206451,
		97,
		true
	},
	island_set_like = {
		1206548,
		94,
		true
	},
	island_input_code_erro = {
		1206642,
		106,
		true
	},
	island_code_exist = {
		1206748,
		106,
		true
	},
	island_like_title = {
		1206854,
		95,
		true
	},
	island_my_id = {
		1206949,
		85,
		true
	},
	island_input_my_id = {
		1207034,
		98,
		true
	},
	island_open_settings = {
		1207132,
		105,
		true
	},
	island_open_settings_tip1 = {
		1207237,
		134,
		true
	},
	island_open_settings_tip2 = {
		1207371,
		113,
		true
	},
	island_open_settings_tip3 = {
		1207484,
		409,
		true
	},
	island_code_refresh_cnt = {
		1207893,
		103,
		true
	},
	island_word_sort = {
		1207996,
		84,
		true
	},
	island_word_reset = {
		1208080,
		86,
		true
	},
	island_bag_title = {
		1208166,
		89,
		true
	},
	island_batch_covert = {
		1208255,
		96,
		true
	},
	island_total_price = {
		1208351,
		94,
		true
	},
	island_word_temp = {
		1208445,
		89,
		true
	},
	island_word_desc = {
		1208534,
		87,
		true
	},
	island_open_ship_tip = {
		1208621,
		132,
		true
	},
	island_bag_upgrade_tip = {
		1208753,
		111,
		true
	},
	island_bag_upgrade_req = {
		1208864,
		102,
		true
	},
	island_bag_upgrade_max_level = {
		1208966,
		110,
		true
	},
	island_bag_upgrade_capacity = {
		1209076,
		118,
		true
	},
	island_rename_title = {
		1209194,
		96,
		true
	},
	island_rename_input_tip = {
		1209290,
		104,
		true
	},
	island_rename_consutme_tip = {
		1209394,
		137,
		true
	},
	island_upgrade_preview = {
		1209531,
		102,
		true
	},
	island_upgrade_exp = {
		1209633,
		97,
		true
	},
	island_upgrade_res = {
		1209730,
		98,
		true
	},
	island_word_award = {
		1209828,
		88,
		true
	},
	island_word_unlock = {
		1209916,
		88,
		true
	},
	island_word_get = {
		1210004,
		85,
		true
	},
	island_prosperity_level_display = {
		1210089,
		121,
		true
	},
	island_prosperity_value_display = {
		1210210,
		115,
		true
	},
	island_rename_subtitle = {
		1210325,
		97,
		true
	},
	island_manage_title = {
		1210422,
		99,
		true
	},
	island_manage_sp_event = {
		1210521,
		100,
		true
	},
	island_manage_no_work = {
		1210621,
		92,
		true
	},
	island_manage_end_work = {
		1210713,
		95,
		true
	},
	island_manage_view = {
		1210808,
		89,
		true
	},
	island_manage_result = {
		1210897,
		96,
		true
	},
	island_manage_prepare = {
		1210993,
		95,
		true
	},
	island_manage_daily_cnt_tip = {
		1211088,
		99,
		true
	},
	island_manage_produce_tip = {
		1211187,
		120,
		true
	},
	island_manage_sel_worker = {
		1211307,
		100,
		true
	},
	island_manage_upgrade_worker_level = {
		1211407,
		128,
		true
	},
	island_manage_saleroom = {
		1211535,
		91,
		true
	},
	island_manage_capacity = {
		1211626,
		101,
		true
	},
	island_manage_skill_cant_use = {
		1211727,
		111,
		true
	},
	island_manage_predict_saleroom = {
		1211838,
		109,
		true
	},
	island_manage_cnt = {
		1211947,
		88,
		true
	},
	island_manage_addition = {
		1212035,
		95,
		true
	},
	island_manage_no_addition = {
		1212130,
		108,
		true
	},
	island_manage_auto_work = {
		1212238,
		98,
		true
	},
	island_manage_start_work = {
		1212336,
		98,
		true
	},
	island_manage_working = {
		1212434,
		92,
		true
	},
	island_manage_end_daily_work = {
		1212526,
		100,
		true
	},
	island_manage_attr_effect = {
		1212626,
		105,
		true
	},
	island_manage_need_ext = {
		1212731,
		96,
		true
	},
	island_manage_reach = {
		1212827,
		92,
		true
	},
	island_manage_slot = {
		1212919,
		92,
		true
	},
	island_manage_food_cnt = {
		1213011,
		99,
		true
	},
	island_manage_sale_ratio = {
		1213110,
		98,
		true
	},
	island_manage_worker_cnt = {
		1213208,
		93,
		true
	},
	island_manage_sale_daily = {
		1213301,
		99,
		true
	},
	island_manage_fake_price = {
		1213400,
		98,
		true
	},
	island_manage_real_price = {
		1213498,
		98,
		true
	},
	island_manage_result_1 = {
		1213596,
		97,
		true
	},
	island_manage_result_3 = {
		1213693,
		99,
		true
	},
	island_manage_word_cnt = {
		1213792,
		91,
		true
	},
	island_manage_shop_exp = {
		1213883,
		95,
		true
	},
	island_manage_help_tip = {
		1213978,
		417,
		true
	},
	island_manage_buff_tip = {
		1214395,
		190,
		true
	},
	island_word_go = {
		1214585,
		86,
		true
	},
	island_map_title = {
		1214671,
		90,
		true
	},
	island_label_furniture = {
		1214761,
		95,
		true
	},
	island_label_furniture_cnt = {
		1214856,
		96,
		true
	},
	island_label_furniture_capacity = {
		1214952,
		109,
		true
	},
	island_label_furniture_tip = {
		1215061,
		173,
		true
	},
	island_label_furniture_capacity_display = {
		1215234,
		124,
		true
	},
	island_label_furniture_exit = {
		1215358,
		97,
		true
	},
	island_label_furniture_save = {
		1215455,
		101,
		true
	},
	island_label_furniture_save_tip = {
		1215556,
		113,
		true
	},
	island_agora_extend = {
		1215669,
		89,
		true
	},
	island_agora_extend_consume = {
		1215758,
		110,
		true
	},
	island_agora_extend_capacity = {
		1215868,
		106,
		true
	},
	island_msg_info = {
		1215974,
		83,
		true
	},
	island_get_way = {
		1216057,
		88,
		true
	},
	island_own_cnt = {
		1216145,
		84,
		true
	},
	island_word_convert = {
		1216229,
		90,
		true
	},
	island_no_remind_today = {
		1216319,
		108,
		true
	},
	island_input_theme_name = {
		1216427,
		103,
		true
	},
	island_custom_theme_name = {
		1216530,
		103,
		true
	},
	island_custom_theme_name_tip = {
		1216633,
		120,
		true
	},
	island_skill_desc = {
		1216753,
		94,
		true
	},
	island_word_place = {
		1216847,
		86,
		true
	},
	island_word_turndown = {
		1216933,
		91,
		true
	},
	island_word_sbumit = {
		1217024,
		88,
		true
	},
	island_word_speedup = {
		1217112,
		91,
		true
	},
	island_order_cd_tip = {
		1217203,
		123,
		true
	},
	island_order_leftcnt_dispaly = {
		1217326,
		123,
		true
	},
	island_order_title = {
		1217449,
		94,
		true
	},
	island_order_difficulty = {
		1217543,
		105,
		true
	},
	island_order_leftCnt_tip = {
		1217648,
		108,
		true
	},
	island_order_get_label = {
		1217756,
		99,
		true
	},
	island_order_ship_working = {
		1217855,
		104,
		true
	},
	island_order_ship_end_work = {
		1217959,
		101,
		true
	},
	island_order_ship_worktime = {
		1218060,
		108,
		true
	},
	island_order_ship_unlock_tip = {
		1218168,
		123,
		true
	},
	island_order_ship_unlock_tip_2 = {
		1218291,
		101,
		true
	},
	island_order_ship_loadup_award = {
		1218392,
		110,
		true
	},
	island_order_ship_loadup = {
		1218502,
		94,
		true
	},
	island_order_ship_loadup_nores = {
		1218596,
		115,
		true
	},
	island_order_ship_page_req = {
		1218711,
		102,
		true
	},
	island_order_ship_page_award = {
		1218813,
		104,
		true
	},
	island_cancel_queue = {
		1218917,
		95,
		true
	},
	island_queue_display = {
		1219012,
		169,
		true
	},
	island_season_label = {
		1219181,
		92,
		true
	},
	island_first_season = {
		1219273,
		91,
		true
	},
	island_word_own = {
		1219364,
		88,
		true
	},
	island_ship_title1 = {
		1219452,
		95,
		true
	},
	island_ship_title2 = {
		1219547,
		95,
		true
	},
	island_ship_title3 = {
		1219642,
		93,
		true
	},
	island_ship_title4 = {
		1219735,
		98,
		true
	},
	island_ship_lock_attr_tip = {
		1219833,
		111,
		true
	},
	island_ship_unlock_limit_tip = {
		1219944,
		162,
		true
	},
	island_ship_breakout = {
		1220106,
		91,
		true
	},
	island_ship_breakout_consume = {
		1220197,
		97,
		true
	},
	island_ship_newskill_unlock = {
		1220294,
		104,
		true
	},
	island_word_give = {
		1220398,
		89,
		true
	},
	island_unlock_ship_skill_color = {
		1220487,
		133,
		true
	},
	island_dressup_tip = {
		1220620,
		144,
		true
	},
	island_dressup_titile = {
		1220764,
		92,
		true
	},
	island_dressup_tip_1 = {
		1220856,
		151,
		true
	},
	island_ship_energy = {
		1221007,
		90,
		true
	},
	island_ship_energy_full = {
		1221097,
		102,
		true
	},
	island_ship_energy_recoverytips = {
		1221199,
		110,
		true
	},
	island_word_ship_buff_desc = {
		1221309,
		97,
		true
	},
	island_word_ship_desc = {
		1221406,
		102,
		true
	},
	island_need_ship_level = {
		1221508,
		113,
		true
	},
	island_skill_consume_title = {
		1221621,
		103,
		true
	},
	island_select_ship_gift = {
		1221724,
		100,
		true
	},
	island_word_ship_enengy_recover = {
		1221824,
		111,
		true
	},
	island_word_ship_level_upgrade = {
		1221935,
		102,
		true
	},
	island_word_ship_level_upgrade_1 = {
		1222037,
		112,
		true
	},
	island_word_ship_rank = {
		1222149,
		97,
		true
	},
	island_task_open = {
		1222246,
		89,
		true
	},
	island_task_target = {
		1222335,
		89,
		true
	},
	island_task_award = {
		1222424,
		88,
		true
	},
	island_task_tracking = {
		1222512,
		90,
		true
	},
	island_task_tracked = {
		1222602,
		91,
		true
	},
	island_dev_level = {
		1222693,
		97,
		true
	},
	island_dev_level_tip = {
		1222790,
		194,
		true
	},
	island_invite_title = {
		1222984,
		110,
		true
	},
	island_technology_title = {
		1223094,
		106,
		true
	},
	island_tech_noauthority = {
		1223200,
		107,
		true
	},
	island_tech_unlock_need = {
		1223307,
		104,
		true
	},
	island_tech_unlock_dev = {
		1223411,
		101,
		true
	},
	island_tech_dev_start = {
		1223512,
		99,
		true
	},
	island_tech_dev_starting = {
		1223611,
		99,
		true
	},
	island_tech_dev_success = {
		1223710,
		104,
		true
	},
	island_tech_dev_finish = {
		1223814,
		96,
		true
	},
	island_tech_dev_finish_1 = {
		1223910,
		105,
		true
	},
	island_tech_dev_cost = {
		1224015,
		97,
		true
	},
	island_tech_detail_desctitle = {
		1224112,
		101,
		true
	},
	island_tech_detail_unlocktitle = {
		1224213,
		111,
		true
	},
	island_tech_nodev = {
		1224324,
		92,
		true
	},
	island_tech_can_get = {
		1224416,
		92,
		true
	},
	island_get_item_tip = {
		1224508,
		97,
		true
	},
	island_add_temp_bag = {
		1224605,
		146,
		true
	},
	island_buff_lasttime = {
		1224751,
		97,
		true
	},
	island_visit_off = {
		1224848,
		83,
		true
	},
	island_visit_on = {
		1224931,
		81,
		true
	},
	island_tech_unlock_tip = {
		1225012,
		116,
		true
	},
	island_tech_unlock_tip0 = {
		1225128,
		108,
		true
	},
	island_tech_unlock_tip1 = {
		1225236,
		116,
		true
	},
	island_tech_unlock_tip2 = {
		1225352,
		115,
		true
	},
	island_tech_unlock_tip3 = {
		1225467,
		121,
		true
	},
	island_tech_no_slot = {
		1225588,
		110,
		true
	},
	island_tech_lock = {
		1225698,
		86,
		true
	},
	island_tech_empty = {
		1225784,
		91,
		true
	},
	island_submit_order_cd_tip = {
		1225875,
		112,
		true
	},
	island_friend_add = {
		1225987,
		84,
		true
	},
	island_friend_agree = {
		1226071,
		89,
		true
	},
	island_friend_refuse = {
		1226160,
		90,
		true
	},
	island_friend_refuse_all = {
		1226250,
		98,
		true
	},
	island_request = {
		1226348,
		85,
		true
	},
	island_post_manage = {
		1226433,
		92,
		true
	},
	island_post_produce = {
		1226525,
		93,
		true
	},
	island_post_operate = {
		1226618,
		93,
		true
	},
	island_post_acceptable = {
		1226711,
		95,
		true
	},
	island_post_vacant = {
		1226806,
		97,
		true
	},
	island_production_selected_character = {
		1226903,
		106,
		true
	},
	island_production_collect = {
		1227009,
		96,
		true
	},
	island_production_selected_item = {
		1227105,
		110,
		true
	},
	island_production_byproduct = {
		1227215,
		111,
		true
	},
	island_production_start = {
		1227326,
		97,
		true
	},
	island_production_finish = {
		1227423,
		101,
		true
	},
	island_production_additional = {
		1227524,
		108,
		true
	},
	island_production_count = {
		1227632,
		103,
		true
	},
	island_production_character_info = {
		1227735,
		113,
		true
	},
	island_production_selected_tip1 = {
		1227848,
		132,
		true
	},
	island_production_selected_tip2 = {
		1227980,
		113,
		true
	},
	island_production_hold = {
		1228093,
		95,
		true
	},
	island_production_log_recover = {
		1228188,
		160,
		true
	},
	island_production_plantable = {
		1228348,
		100,
		true
	},
	island_production_being_planted = {
		1228448,
		122,
		true
	},
	island_production_cost_notenough = {
		1228570,
		131,
		true
	},
	island_production_manually_cancel = {
		1228701,
		183,
		true
	},
	island_production_harvestable = {
		1228884,
		104,
		true
	},
	island_production_seeds_notenough = {
		1228988,
		116,
		true
	},
	island_production_seeds_empty = {
		1229104,
		141,
		true
	},
	island_production_tip = {
		1229245,
		93,
		true
	},
	island_production_speed_addition1 = {
		1229338,
		127,
		true
	},
	island_production_speed_addition2 = {
		1229465,
		109,
		true
	},
	island_production_speed_addition3 = {
		1229574,
		108,
		true
	},
	island_production_speed_tip1 = {
		1229682,
		139,
		true
	},
	island_production_speed_tip2 = {
		1229821,
		115,
		true
	},
	island_order_ship_page_onekey_loadup = {
		1229936,
		126,
		true
	},
	agora_belong_theme = {
		1230062,
		91,
		true
	},
	agora_belong_theme_none = {
		1230153,
		95,
		true
	},
	island_achievement_title = {
		1230248,
		107,
		true
	},
	island_achv_total = {
		1230355,
		103,
		true
	},
	island_achv_finish_tip = {
		1230458,
		113,
		true
	},
	island_card_edit_name = {
		1230571,
		98,
		true
	},
	island_card_edit_word = {
		1230669,
		100,
		true
	},
	island_card_default_word = {
		1230769,
		126,
		true
	},
	island_card_view_detaills = {
		1230895,
		105,
		true
	},
	island_card_close = {
		1231000,
		93,
		true
	},
	island_card_choose_photo = {
		1231093,
		111,
		true
	},
	island_card_word_title = {
		1231204,
		101,
		true
	},
	island_card_label_list = {
		1231305,
		104,
		true
	},
	island_card_choose_achievement = {
		1231409,
		108,
		true
	},
	island_card_edit_label = {
		1231517,
		101,
		true
	},
	island_card_choose_label = {
		1231618,
		103,
		true
	},
	island_card_like_done = {
		1231721,
		118,
		true
	},
	island_card_label_done = {
		1231839,
		126,
		true
	},
	island_card_no_achv_self = {
		1231965,
		101,
		true
	},
	island_card_no_achv_other = {
		1232066,
		106,
		true
	},
	island_leave = {
		1232172,
		82,
		true
	},
	island_repeat_vip = {
		1232254,
		120,
		true
	},
	island_repeat_blacklist = {
		1232374,
		126,
		true
	},
	island_chat_settings = {
		1232500,
		97,
		true
	},
	island_card_no_label = {
		1232597,
		91,
		true
	},
	ship_gift = {
		1232688,
		78,
		true
	},
	ship_gift_cnt = {
		1232766,
		84,
		true
	},
	ship_gift2 = {
		1232850,
		78,
		true
	},
	shipyard_gift_exceed = {
		1232928,
		151,
		true
	},
	shipyard_gift_non_existent = {
		1233079,
		106,
		true
	},
	shipyard_favorability_exceed = {
		1233185,
		144,
		true
	},
	shipyard_favorability_threshold = {
		1233329,
		177,
		true
	},
	shipyard_favorability_max = {
		1233506,
		121,
		true
	},
	island_activity_decorative_word = {
		1233627,
		108,
		true
	},
	island_no_activity = {
		1233735,
		101,
		true
	},
	island_spoperation_level_2509_1 = {
		1233836,
		134,
		true
	},
	island_spoperation_tip_2509_1 = {
		1233970,
		341,
		true
	},
	island_spoperation_tip_2509_2 = {
		1234311,
		206,
		true
	},
	island_spoperation_tip_2509_3 = {
		1234517,
		254,
		true
	},
	island_spoperation_btn_2509_1 = {
		1234771,
		116,
		true
	},
	island_spoperation_btn_2509_2 = {
		1234887,
		118,
		true
	},
	island_spoperation_btn_2509_3 = {
		1235005,
		106,
		true
	},
	island_spoperation_item_2509_1 = {
		1235111,
		114,
		true
	},
	island_spoperation_item_2509_2 = {
		1235225,
		106,
		true
	},
	island_spoperation_item_2509_3 = {
		1235331,
		101,
		true
	},
	island_spoperation_item_2509_4 = {
		1235432,
		103,
		true
	},
	island_spoperation_tip_2602_1 = {
		1235535,
		341,
		true
	},
	island_spoperation_tip_2602_2 = {
		1235876,
		206,
		true
	},
	island_spoperation_tip_2602_3 = {
		1236082,
		257,
		true
	},
	island_spoperation_btn_2602_1 = {
		1236339,
		118,
		true
	},
	island_spoperation_btn_2602_2 = {
		1236457,
		116,
		true
	},
	island_spoperation_btn_2602_3 = {
		1236573,
		106,
		true
	},
	island_spoperation_item_2602_1 = {
		1236679,
		114,
		true
	},
	island_spoperation_item_2602_2 = {
		1236793,
		110,
		true
	},
	island_spoperation_item_2602_3 = {
		1236903,
		108,
		true
	},
	island_spoperation_item_2602_4 = {
		1237011,
		102,
		true
	},
	island_follow_success = {
		1237113,
		93,
		true
	},
	island_cancel_follow_success = {
		1237206,
		100,
		true
	},
	island_follower_cnt_max = {
		1237306,
		122,
		true
	},
	island_cancel_follow_tip = {
		1237428,
		141,
		true
	},
	island_follower_state_no_normal = {
		1237569,
		124,
		true
	},
	island_follow_btn_State_usable = {
		1237693,
		108,
		true
	},
	island_follow_btn_State_cancel = {
		1237801,
		102,
		true
	},
	island_follow_btn_State_disable = {
		1237903,
		99,
		true
	},
	island_draw_tab = {
		1238002,
		97,
		true
	},
	island_draw_tab_en = {
		1238099,
		100,
		true
	},
	island_draw_last = {
		1238199,
		90,
		true
	},
	island_draw_null = {
		1238289,
		88,
		true
	},
	island_draw_num = {
		1238377,
		84,
		true
	},
	island_draw_lottery = {
		1238461,
		87,
		true
	},
	island_draw_pick = {
		1238548,
		87,
		true
	},
	island_draw_reward = {
		1238635,
		94,
		true
	},
	island_draw_time = {
		1238729,
		94,
		true
	},
	island_draw_time_1 = {
		1238823,
		93,
		true
	},
	island_draw_S_order_title = {
		1238916,
		102,
		true
	},
	island_draw_S_order = {
		1239018,
		118,
		true
	},
	island_draw_S = {
		1239136,
		84,
		true
	},
	island_draw_A = {
		1239220,
		84,
		true
	},
	island_draw_B = {
		1239304,
		84,
		true
	},
	island_draw_C = {
		1239388,
		84,
		true
	},
	island_draw_get = {
		1239472,
		87,
		true
	},
	island_draw_ready = {
		1239559,
		123,
		true
	},
	island_draw_float = {
		1239682,
		100,
		true
	},
	island_draw_choice_title = {
		1239782,
		95,
		true
	},
	island_draw_choice = {
		1239877,
		92,
		true
	},
	island_draw_sort = {
		1239969,
		106,
		true
	},
	island_draw_tip1 = {
		1240075,
		119,
		true
	},
	island_draw_tip2 = {
		1240194,
		121,
		true
	},
	island_draw_tip3 = {
		1240315,
		114,
		true
	},
	island_draw_tip4 = {
		1240429,
		128,
		true
	},
	island_freight_btn_locked = {
		1240557,
		100,
		true
	},
	island_freight_btn_receive = {
		1240657,
		100,
		true
	},
	island_freight_btn_idle = {
		1240757,
		105,
		true
	},
	island_ticket_shop = {
		1240862,
		88,
		true
	},
	island_ticket_remain_time = {
		1240950,
		98,
		true
	},
	island_ticket_auto_select = {
		1241048,
		100,
		true
	},
	island_ticket_use = {
		1241148,
		100,
		true
	},
	island_ticket_view = {
		1241248,
		90,
		true
	},
	island_ticket_storage_title = {
		1241338,
		106,
		true
	},
	island_ticket_sort_valid = {
		1241444,
		100,
		true
	},
	island_ticket_sort_speedup = {
		1241544,
		98,
		true
	},
	island_ticket_completed_quantity = {
		1241642,
		115,
		true
	},
	island_ticket_nearing_expiration = {
		1241757,
		108,
		true
	},
	island_ticket_expiration_tip1 = {
		1241865,
		144,
		true
	},
	island_ticket_expiration_tip2 = {
		1242009,
		137,
		true
	},
	island_ticket_finished = {
		1242146,
		94,
		true
	},
	island_ticket_expired = {
		1242240,
		92,
		true
	},
	island_use_ticket_success = {
		1242332,
		106,
		true
	},
	island_sure_ticket_overflow = {
		1242438,
		172,
		true
	},
	island_ticket_expired_day = {
		1242610,
		109,
		true
	},
	island_dress_replace_tip = {
		1242719,
		156,
		true
	},
	island_activity_expired = {
		1242875,
		102,
		true
	},
	island_guide = {
		1242977,
		86,
		true
	},
	island_guide_help = {
		1243063,
		891,
		true
	},
	island_guide_help_npc = {
		1243954,
		389,
		true
	},
	island_guide_help_item = {
		1244343,
		646,
		true
	},
	island_guide_help_fish = {
		1244989,
		657,
		true
	},
	island_guide_character_help = {
		1245646,
		95,
		true
	},
	island_guide_en = {
		1245741,
		89,
		true
	},
	island_guide_character = {
		1245830,
		96,
		true
	},
	island_guide_character_en = {
		1245926,
		99,
		true
	},
	island_guide_npc = {
		1246025,
		103,
		true
	},
	island_guide_npc_en = {
		1246128,
		106,
		true
	},
	island_guide_item = {
		1246234,
		90,
		true
	},
	island_guide_item_en = {
		1246324,
		93,
		true
	},
	island_guide_collectionpoint = {
		1246417,
		113,
		true
	},
	island_guide_fish_min_weight = {
		1246530,
		103,
		true
	},
	island_guide_fish_max_weight = {
		1246633,
		102,
		true
	},
	island_get_collect_point_success = {
		1246735,
		124,
		true
	},
	island_guide_active = {
		1246859,
		93,
		true
	},
	island_book_collection_award_title = {
		1246952,
		119,
		true
	},
	island_book_award_title = {
		1247071,
		99,
		true
	},
	island_guide_do_active = {
		1247170,
		92,
		true
	},
	island_guide_lock_desc = {
		1247262,
		97,
		true
	},
	island_gift_entrance = {
		1247359,
		96,
		true
	},
	island_sign_text = {
		1247455,
		101,
		true
	},
	island_3Dshop_chara_set = {
		1247556,
		108,
		true
	},
	island_3Dshop_chara_choose = {
		1247664,
		106,
		true
	},
	island_3Dshop_res_have = {
		1247770,
		117,
		true
	},
	island_3Dshop_time_close = {
		1247887,
		114,
		true
	},
	island_3Dshop_time_refresh = {
		1248001,
		105,
		true
	},
	island_3Dshop_refresh_limit = {
		1248106,
		119,
		true
	},
	island_3Dshop_have = {
		1248225,
		88,
		true
	},
	island_3Dshop_time_unlock = {
		1248313,
		102,
		true
	},
	island_3Dshop_buy_no = {
		1248415,
		97,
		true
	},
	island_3Dshop_last = {
		1248512,
		97,
		true
	},
	island_3Dshop_close = {
		1248609,
		106,
		true
	},
	island_3Dshop_no_have = {
		1248715,
		95,
		true
	},
	island_3Dshop_goods_time = {
		1248810,
		102,
		true
	},
	island_3Dshop_clothes_jump = {
		1248912,
		131,
		true
	},
	island_3Dshop_buy_confirm = {
		1249043,
		92,
		true
	},
	island_3Dshop_buy = {
		1249135,
		84,
		true
	},
	island_3Dshop_buy_tip0 = {
		1249219,
		92,
		true
	},
	island_3Dshop_buy_return = {
		1249311,
		94,
		true
	},
	island_3Dshop_buy_price = {
		1249405,
		92,
		true
	},
	island_3Dshop_buy_have = {
		1249497,
		91,
		true
	},
	island_3Dshop_bag_max = {
		1249588,
		142,
		true
	},
	island_3Dshop_lack_gold = {
		1249730,
		115,
		true
	},
	island_3Dshop_lack_gem = {
		1249845,
		104,
		true
	},
	island_3Dshop_lack_res = {
		1249949,
		116,
		true
	},
	island_photo_fur_lock = {
		1250065,
		121,
		true
	},
	island_exchange_title = {
		1250186,
		93,
		true
	},
	island_exchange_title_en = {
		1250279,
		96,
		true
	},
	island_exchange_own_count = {
		1250375,
		99,
		true
	},
	island_exchange_btn_text = {
		1250474,
		96,
		true
	},
	island_exchange_sure_tip = {
		1250570,
		104,
		true
	},
	island_bag_max_tip = {
		1250674,
		111,
		true
	},
	graphi_api_switch_opengl = {
		1250785,
		296,
		true
	},
	graphi_api_switch_vulkan = {
		1251081,
		254,
		true
	},
	["3ddorm_beach_slide_tip1"] = {
		1251335,
		92,
		true
	},
	["3ddorm_beach_slide_tip2"] = {
		1251427,
		103,
		true
	},
	["3ddorm_beach_slide_tip3"] = {
		1251530,
		92,
		true
	},
	["3ddorm_beach_slide_tip4"] = {
		1251622,
		103,
		true
	},
	["3ddorm_beach_slide_tip5"] = {
		1251725,
		102,
		true
	},
	["3ddorm_beach_slide_tip6"] = {
		1251827,
		104,
		true
	},
	["3ddorm_beach_slide_tip7"] = {
		1251931,
		98,
		true
	},
	dorm3d_shop_tag7 = {
		1252029,
		167,
		true
	},
	grapihcs3d_setting_global_illumination = {
		1252196,
		126,
		true
	},
	grapihcs3d_setting_global_illumination_optionname0 = {
		1252322,
		117,
		true
	},
	grapihcs3d_setting_global_illumination_optionname1 = {
		1252439,
		120,
		true
	},
	grapihcs3d_setting_global_illumination_optionname2 = {
		1252559,
		118,
		true
	},
	grapihcs3d_setting_global_illumination_optionname3 = {
		1252677,
		123,
		true
	},
	grapihcs3d_setting_bloom_intensity = {
		1252800,
		113,
		true
	},
	grapihcs3d_setting_bloom_intensity_0 = {
		1252913,
		103,
		true
	},
	grapihcs3d_setting_bloom_intensity_1 = {
		1253016,
		103,
		true
	},
	grapihcs3d_setting_bloom_intensity_2 = {
		1253119,
		106,
		true
	},
	grapihcs3d_setting_bloom_intensity_3 = {
		1253225,
		104,
		true
	},
	grapihcs3d_setting_flare = {
		1253329,
		98,
		true
	},
	Outpost_20250904_Sidebar4 = {
		1253427,
		101,
		true
	},
	Outpost_20250904_Sidebar5 = {
		1253528,
		96,
		true
	},
	Outpost_20250904_Title1 = {
		1253624,
		99,
		true
	},
	Outpost_20250904_Title2 = {
		1253723,
		99,
		true
	},
	Outpost_20250904_Progress = {
		1253822,
		97,
		true
	},
	outpost_20250904_Sidebar4 = {
		1253919,
		101,
		true
	},
	outpost_20250904_Sidebar5 = {
		1254020,
		96,
		true
	},
	outpost_20250904_Title1 = {
		1254116,
		92,
		true
	},
	outpost_20250904_Title2 = {
		1254208,
		92,
		true
	},
	ninja_buff_name1 = {
		1254300,
		102,
		true
	},
	ninja_buff_name2 = {
		1254402,
		99,
		true
	},
	ninja_buff_name3 = {
		1254501,
		98,
		true
	},
	ninja_buff_name4 = {
		1254599,
		97,
		true
	},
	ninja_buff_name5 = {
		1254696,
		91,
		true
	},
	ninja_buff_name6 = {
		1254787,
		93,
		true
	},
	ninja_buff_name7 = {
		1254880,
		106,
		true
	},
	ninja_buff_name8 = {
		1254986,
		98,
		true
	},
	ninja_buff_name9 = {
		1255084,
		102,
		true
	},
	ninja_buff_name10 = {
		1255186,
		101,
		true
	},
	ninja_buff_effect1 = {
		1255287,
		114,
		true
	},
	ninja_buff_effect2 = {
		1255401,
		113,
		true
	},
	ninja_buff_effect3 = {
		1255514,
		95,
		true
	},
	ninja_buff_effect4 = {
		1255609,
		103,
		true
	},
	ninja_buff_effect5 = {
		1255712,
		132,
		true
	},
	ninja_buff_effect6 = {
		1255844,
		112,
		true
	},
	ninja_buff_effect7 = {
		1255956,
		106,
		true
	},
	ninja_buff_effect8 = {
		1256062,
		107,
		true
	},
	ninja_buff_effect9 = {
		1256169,
		107,
		true
	},
	ninja_buff_effect10 = {
		1256276,
		132,
		true
	},
	activity_ninjia_main_title = {
		1256408,
		95,
		true
	},
	activity_ninjia_main_title_en = {
		1256503,
		98,
		true
	},
	activity_ninjia_main_sheet1 = {
		1256601,
		103,
		true
	},
	activity_ninjia_main_sheet2 = {
		1256704,
		102,
		true
	},
	activity_ninjia_main_sheet3 = {
		1256806,
		101,
		true
	},
	activity_ninjia_main_sheet4 = {
		1256907,
		99,
		true
	},
	activity_return_reward_pt = {
		1257006,
		106,
		true
	},
	outpost_20250904_Sidebar1 = {
		1257112,
		99,
		true
	},
	outpost_20250904_Sidebar2 = {
		1257211,
		98,
		true
	},
	outpost_20250904_Sidebar3 = {
		1257309,
		100,
		true
	},
	anniversary_eight_main_page_desc = {
		1257409,
		319,
		true
	},
	eighth_tip_spring = {
		1257728,
		289,
		true
	},
	eighth_spring_cost = {
		1258017,
		183,
		true
	},
	eighth_spring_not_enough = {
		1258200,
		113,
		true
	},
	ninja_game_helper = {
		1258313,
		1822,
		true
	},
	ninja_game_citylevel = {
		1260135,
		99,
		true
	},
	ninja_game_wave = {
		1260234,
		91,
		true
	},
	ninja_game_current_section = {
		1260325,
		114,
		true
	},
	ninja_game_buildcost = {
		1260439,
		95,
		true
	},
	ninja_game_allycost = {
		1260534,
		99,
		true
	},
	ninja_game_citydmg = {
		1260633,
		98,
		true
	},
	ninja_game_allydmg = {
		1260731,
		95,
		true
	},
	ninja_game_dps = {
		1260826,
		96,
		true
	},
	ninja_game_time = {
		1260922,
		93,
		true
	},
	ninja_game_income = {
		1261015,
		90,
		true
	},
	ninja_game_buffeffect = {
		1261105,
		97,
		true
	},
	ninja_game_buffcost = {
		1261202,
		96,
		true
	},
	ninja_game_levelblock = {
		1261298,
		107,
		true
	},
	ninja_game_storydialog = {
		1261405,
		135,
		true
	},
	ninja_game_update_failed = {
		1261540,
		166,
		true
	},
	ninja_game_ptcount = {
		1261706,
		92,
		true
	},
	ninja_game_cant_pickup = {
		1261798,
		108,
		true
	},
	ninja_game_booktip = {
		1261906,
		164,
		true
	},
	island_no_position_to_reponse_action = {
		1262070,
		178,
		true
	},
	island_position_cant_play_cp_action = {
		1262248,
		177,
		true
	},
	island_position_cant_response_cp_action = {
		1262425,
		192,
		true
	},
	island_card_no_achieve_tip = {
		1262617,
		115,
		true
	},
	island_card_no_label_tip = {
		1262732,
		126,
		true
	},
	gift_giving_prefer = {
		1262858,
		106,
		true
	},
	gift_giving_dislike = {
		1262964,
		109,
		true
	},
	dorm3d_publicroom_unlock = {
		1263073,
		126,
		true
	},
	dorm3d_dafeng_table = {
		1263199,
		90,
		true
	},
	dorm3d_dafeng_chair = {
		1263289,
		94,
		true
	},
	dorm3d_dafeng_bed = {
		1263383,
		88,
		true
	},
	island_draw_help = {
		1263471,
		1626,
		true
	},
	island_dress_initial_makesure = {
		1265097,
		101,
		true
	},
	island_shop_lock_tip = {
		1265198,
		115,
		true
	},
	island_agora_no_size = {
		1265313,
		107,
		true
	},
	island_combo_unlock = {
		1265420,
		113,
		true
	},
	island_additional_production_tip1 = {
		1265533,
		113,
		true
	},
	island_additional_production_tip2 = {
		1265646,
		153,
		true
	},
	island_manage_stock_out = {
		1265799,
		118,
		true
	},
	island_manage_item_select = {
		1265917,
		102,
		true
	},
	island_combo_produced = {
		1266019,
		89,
		true
	},
	island_combo_produced_times = {
		1266108,
		101,
		true
	},
	island_agora_no_interact_point = {
		1266209,
		124,
		true
	},
	island_reward_tip = {
		1266333,
		87,
		true
	},
	island_commontips_close = {
		1266420,
		110,
		true
	},
	world_inventory_tip = {
		1266530,
		108,
		true
	},
	island_setmeal_title = {
		1266638,
		95,
		true
	},
	island_setmeal_benifit_title = {
		1266733,
		102,
		true
	},
	island_shipselect_confirm = {
		1266835,
		97,
		true
	},
	island_dresscolorunlock_tips = {
		1266932,
		107,
		true
	},
	island_dresscolorunlock = {
		1267039,
		93,
		true
	},
	danmachi_main_sheet1 = {
		1267132,
		94,
		true
	},
	danmachi_main_sheet2 = {
		1267226,
		90,
		true
	},
	danmachi_main_sheet3 = {
		1267316,
		92,
		true
	},
	danmachi_main_sheet4 = {
		1267408,
		89,
		true
	},
	danmachi_main_sheet5 = {
		1267497,
		95,
		true
	},
	danmachi_main_time = {
		1267592,
		97,
		true
	},
	danmachi_award_1 = {
		1267689,
		88,
		true
	},
	danmachi_award_2 = {
		1267777,
		89,
		true
	},
	danmachi_award_3 = {
		1267866,
		90,
		true
	},
	danmachi_award_4 = {
		1267956,
		88,
		true
	},
	danmachi_award_name1 = {
		1268044,
		90,
		true
	},
	danmachi_award_name2 = {
		1268134,
		92,
		true
	},
	danmachi_award_get = {
		1268226,
		90,
		true
	},
	danmachi_award_unget = {
		1268316,
		94,
		true
	},
	dorm3d_touch2 = {
		1268410,
		87,
		true
	},
	dorm3d_furnitrue_type_special = {
		1268497,
		102,
		true
	},
	island_helpbtn_order = {
		1268599,
		1169,
		true
	},
	island_helpbtn_commission = {
		1269768,
		891,
		true
	},
	island_helpbtn_speedup = {
		1270659,
		588,
		true
	},
	island_helpbtn_card = {
		1271247,
		751,
		true
	},
	island_helpbtn_technology = {
		1271998,
		1018,
		true
	},
	island_shiporder_refresh_tip1 = {
		1273016,
		153,
		true
	},
	island_shiporder_refresh_tip2 = {
		1273169,
		137,
		true
	},
	island_shiporder_refresh_preparing = {
		1273306,
		123,
		true
	},
	island_information_tech = {
		1273429,
		108,
		true
	},
	dorm3d_shop_tag8 = {
		1273537,
		105,
		true
	},
	island_chara_attr_help = {
		1273642,
		733,
		true
	},
	fengfanV3_20251023_Sidebar1 = {
		1274375,
		102,
		true
	},
	fengfanV3_20251023_Sidebar2 = {
		1274477,
		101,
		true
	},
	fengfanV3_20251023_Sidebar3 = {
		1274578,
		102,
		true
	},
	fengfanV3_20251023_jinianshouce = {
		1274680,
		107,
		true
	},
	island_selectall = {
		1274787,
		83,
		true
	},
	island_quickselect_tip = {
		1274870,
		148,
		true
	},
	search_equipment = {
		1275018,
		99,
		true
	},
	search_sp_equipment = {
		1275117,
		109,
		true
	},
	search_equipment_appearance = {
		1275226,
		115,
		true
	},
	meta_reproduce_btn = {
		1275341,
		222,
		true
	},
	meta_simulated_btn = {
		1275563,
		222,
		true
	},
	equip_enhancement_tip = {
		1275785,
		107,
		true
	},
	equip_enhancement_lv1 = {
		1275892,
		95,
		true
	},
	equip_enhancement_lvx = {
		1275987,
		99,
		true
	},
	equip_enhancement_finish = {
		1276086,
		96,
		true
	},
	equip_enhancement_lv = {
		1276182,
		86,
		true
	},
	equip_enhancement_title = {
		1276268,
		94,
		true
	},
	equip_enhancement_required = {
		1276362,
		107,
		true
	},
	shop_sell_ended = {
		1276469,
		90,
		true
	},
	island_taskjump_systemnoopen_tips = {
		1276559,
		137,
		true
	},
	island_taskjump_placenoopen_tips = {
		1276696,
		137,
		true
	},
	island_ship_order_toggle_label_award = {
		1276833,
		107,
		true
	},
	island_ship_order_toggle_label_request = {
		1276940,
		106,
		true
	},
	island_ship_order_delegate_auto_refresh_label = {
		1277046,
		153,
		true
	},
	island_ship_order_delegate_auto_refresh_time = {
		1277199,
		141,
		true
	},
	island_order_ship_finish_cnt = {
		1277340,
		108,
		true
	},
	island_order_ship_sel_delegate_label = {
		1277448,
		121,
		true
	},
	island_order_ship_finish_cnt_not_enough = {
		1277569,
		110,
		true
	},
	island_order_ship_reset_all = {
		1277679,
		134,
		true
	},
	island_order_ship_exchange_tip = {
		1277813,
		140,
		true
	},
	island_order_ship_btn_replace = {
		1277953,
		104,
		true
	},
	island_fishing_tip_hooked = {
		1278057,
		111,
		true
	},
	island_fishing_tip_escape = {
		1278168,
		109,
		true
	},
	island_fishing_exit = {
		1278277,
		111,
		true
	},
	island_fishing_lure_empty = {
		1278388,
		102,
		true
	},
	island_order_ship_exchange_tip_2 = {
		1278490,
		142,
		true
	},
	island_follower_exiting_tip = {
		1278632,
		118,
		true
	},
	island_order_ship_exchange_tip_1 = {
		1278750,
		251,
		true
	},
	island_urgent_notice = {
		1279001,
		2711,
		true
	},
	general_activity_side_bar1 = {
		1281712,
		106,
		true
	},
	general_activity_side_bar2 = {
		1281818,
		113,
		true
	},
	general_activity_side_bar3 = {
		1281931,
		108,
		true
	},
	general_activity_side_bar4 = {
		1282039,
		111,
		true
	},
	black5_bundle_desc = {
		1282150,
		128,
		true
	},
	black5_bundle_purchased = {
		1282278,
		96,
		true
	},
	black5_bundle_tip = {
		1282374,
		104,
		true
	},
	black5_bundle_buy_all = {
		1282478,
		97,
		true
	},
	black5_bundle_popup = {
		1282575,
		173,
		true
	},
	black5_bundle_receive = {
		1282748,
		96,
		true
	},
	black5_bundle_button = {
		1282844,
		89,
		true
	},
	skinshop_on_sale_tip = {
		1282933,
		97,
		true
	},
	skinshop_on_sale_tip_2 = {
		1283030,
		103,
		true
	},
	blackfriday_cruise_task_tips = {
		1283133,
		101,
		true
	},
	blackfriday_cruise_task_unlock = {
		1283234,
		125,
		true
	},
	blackfriday_cruise_task_day = {
		1283359,
		97,
		true
	},
	blackfriday_battlepass_pay_acquire = {
		1283456,
		113,
		true
	},
	blackfriday_battlepass_pay_tip = {
		1283569,
		134,
		true
	},
	blackfriday_battlepass_complete = {
		1283703,
		144,
		true
	},
	blackfriday_cruise_phase_title = {
		1283847,
		99,
		true
	},
	blackfriday_cruise_title_1113 = {
		1283946,
		121,
		true
	},
	blackfriday_battlepass_main_time_title = {
		1284067,
		117,
		true
	},
	blackfriday_cruise_btn_pay = {
		1284184,
		110,
		true
	},
	blackfriday_cruise_btn_all = {
		1284294,
		101,
		true
	},
	blackfriday_battlepass_main_help_1113 = {
		1284395,
		2381,
		true
	},
	blackfriday_cruise_task_help_1113 = {
		1286776,
		702,
		true
	},
	shop_tag_control_tip = {
		1287478,
		107,
		true
	},
	blackfriday_battlepass_mission = {
		1287585,
		102,
		true
	},
	blackfriday_battlepass_rewards = {
		1287687,
		101,
		true
	},
	black5_bundle_help = {
		1287788,
		351,
		true
	},
	blackfriday_luckybag_164 = {
		1288139,
		305,
		true
	},
	blackfriday_luckybag_165 = {
		1288444,
		560,
		true
	},
	battlepass_main_tip_2512 = {
		1289004,
		270,
		true
	},
	battlepass_main_help_2512 = {
		1289274,
		2899,
		true
	},
	cruise_task_help_2512 = {
		1292173,
		1092,
		true
	},
	cruise_title_2512 = {
		1293265,
		102,
		true
	},
	DAL_stage_label_data = {
		1293367,
		96,
		true
	},
	DAL_stage_label_support = {
		1293463,
		101,
		true
	},
	DAL_stage_label_commander = {
		1293564,
		103,
		true
	},
	DAL_stage_label_analysis_2 = {
		1293667,
		107,
		true
	},
	DAL_stage_label_analysis_1 = {
		1293774,
		102,
		true
	},
	DAL_stage_finish_at = {
		1293876,
		92,
		true
	},
	activity_remain_time = {
		1293968,
		93,
		true
	},
	dal_main_sheet1 = {
		1294061,
		88,
		true
	},
	dal_main_sheet2 = {
		1294149,
		96,
		true
	},
	dal_main_sheet3 = {
		1294245,
		97,
		true
	},
	dal_main_sheet4 = {
		1294342,
		91,
		true
	},
	dal_main_sheet5 = {
		1294433,
		90,
		true
	},
	DAL_upgrade_ship = {
		1294523,
		95,
		true
	},
	DAL_upgrade_active = {
		1294618,
		89,
		true
	},
	dal_main_sheet1_en = {
		1294707,
		91,
		true
	},
	dal_main_sheet2_en = {
		1294798,
		91,
		true
	},
	dal_main_sheet3_en = {
		1294889,
		94,
		true
	},
	dal_main_sheet4_en = {
		1294983,
		94,
		true
	},
	dal_main_sheet5_en = {
		1295077,
		93,
		true
	},
	DAL_story_tip = {
		1295170,
		137,
		true
	},
	DAL_upgrade_program = {
		1295307,
		98,
		true
	},
	dal_story_tip_name_en_1 = {
		1295405,
		95,
		true
	},
	dal_story_tip_name_en_2 = {
		1295500,
		95,
		true
	},
	dal_story_tip_name_en_3 = {
		1295595,
		95,
		true
	},
	dal_story_tip_name_en_4 = {
		1295690,
		95,
		true
	},
	dal_story_tip_name_en_5 = {
		1295785,
		95,
		true
	},
	dal_story_tip_name_en_6 = {
		1295880,
		95,
		true
	},
	dal_story_tip1 = {
		1295975,
		107,
		true
	},
	dal_story_tip2 = {
		1296082,
		102,
		true
	},
	dal_story_tip3 = {
		1296184,
		86,
		true
	},
	dal_AwardPage_name_1 = {
		1296270,
		88,
		true
	},
	dal_AwardPage_name_2 = {
		1296358,
		90,
		true
	},
	dal_chapter_goto = {
		1296448,
		82,
		true
	},
	DAL_upgrade_unlock = {
		1296530,
		88,
		true
	},
	DAL_upgrade_not_enough = {
		1296618,
		154,
		true
	},
	dal_chapter_tip = {
		1296772,
		1939,
		true
	},
	dal_chapter_tip2 = {
		1298711,
		110,
		true
	},
	scenario_unlock_pt_require = {
		1298821,
		121,
		true
	},
	scenario_unlock = {
		1298942,
		104,
		true
	},
	vote_help_2025 = {
		1299046,
		5313,
		true
	},
	HelenaCoreActivity_title = {
		1304359,
		93,
		true
	},
	HelenaCoreActivity_title2 = {
		1304452,
		94,
		true
	},
	HelenaPTPage_title = {
		1304546,
		98,
		true
	},
	HelenaPTPage_title2 = {
		1304644,
		83,
		true
	},
	HelenaCoreActivity_subtitle_1 = {
		1304727,
		109,
		true
	},
	HelenaCoreActivity_subtitle_2 = {
		1304836,
		105,
		true
	},
	HelenaCoreActivity_subtitle_3 = {
		1304941,
		112,
		true
	},
	HelenaCoreActivity_subtitle_4 = {
		1305053,
		121,
		true
	},
	HelenaCoreActivity_subtitle_5 = {
		1305174,
		112,
		true
	},
	HelenaCoreActivity_subtitle_6 = {
		1305286,
		104,
		true
	},
	fate_unlock_icon_desc = {
		1305390,
		120,
		true
	},
	blueprint_exchange_fate_unlock = {
		1305510,
		162,
		true
	},
	blueprint_exchange_fate_unlock_over = {
		1305672,
		213,
		true
	},
	blueprint_lab_fate_lock = {
		1305885,
		133,
		true
	},
	blueprint_lab_fate_unlock = {
		1306018,
		137,
		true
	},
	blueprint_lab_exchange_fate_unlock = {
		1306155,
		166,
		true
	},
	skinstory_20251218 = {
		1306321,
		91,
		true
	},
	skinstory_20251225 = {
		1306412,
		92,
		true
	},
	change_skin_asmr_desc_1 = {
		1306504,
		145,
		true
	},
	change_skin_asmr_desc_2 = {
		1306649,
		134,
		true
	},
	dorm3d_aijier_table = {
		1306783,
		88,
		true
	},
	dorm3d_aijier_chair = {
		1306871,
		89,
		true
	},
	dorm3d_aijier_bed = {
		1306960,
		88,
		true
	},
	winterwish_20251225 = {
		1307048,
		95,
		true
	},
	winterwish_20251225_tip1 = {
		1307143,
		98,
		true
	},
	winterwish_20251225_tip2 = {
		1307241,
		99,
		true
	},
	battlepass_main_tip_2602 = {
		1307340,
		255,
		true
	},
	battlepass_main_help_2602 = {
		1307595,
		2897,
		true
	},
	cruise_task_help_2602 = {
		1310492,
		1092,
		true
	},
	cruise_title_2602 = {
		1311584,
		102,
		true
	},
	battle_battleMediator_quest_exist_submarine_support = {
		1311686,
		220,
		true
	},
	island_survey_ui_1 = {
		1311906,
		82,
		true
	},
	island_survey_ui_2 = {
		1311988,
		82,
		true
	},
	island_survey_ui_award = {
		1312070,
		86,
		true
	},
	island_survey_ui_button = {
		1312156,
		87,
		true
	},
	ANTTFFCoreActivity_subtitle_1 = {
		1312243,
		131,
		true
	},
	ANTTFFCoreActivity_title = {
		1312374,
		94,
		true
	},
	ANTTFFCoreActivity_title2 = {
		1312468,
		89,
		true
	},
	ANTTFFCoreActivityPtpage_title = {
		1312557,
		100,
		true
	},
	ANTTFFCoreActivityPtpage_title2 = {
		1312657,
		95,
		true
	},
	submarine_support_oil_consume_tip = {
		1312752,
		177,
		true
	},
	SardiniaSPCoreActivityUI_title = {
		1312929,
		99,
		true
	},
	SardiniaSPCoreActivityUI_subtitle_1 = {
		1313028,
		113,
		true
	},
	SardiniaSPCoreActivityUI_subtitle_2 = {
		1313141,
		108,
		true
	},
	SardiniaSPCoreActivityUI_story_reward_count = {
		1313249,
		331,
		true
	},
	SardiniaSPCoreActivityUI_unlock = {
		1313580,
		101,
		true
	},
	SardiniaSPCoreActivityUI_fleetconfirm = {
		1313681,
		190,
		true
	},
	SardiniaSPCoreActivityUI_help = {
		1313871,
		1388,
		true
	},
	pac_game_high_score_tip = {
		1315259,
		101,
		true
	},
	pac_game_rule_btn = {
		1315360,
		92,
		true
	},
	pac_game_start_btn = {
		1315452,
		87,
		true
	},
	pac_game_gaming_time_desc = {
		1315539,
		94,
		true
	},
	pac_game_gaming_score = {
		1315633,
		91,
		true
	},
	mini_game_continue = {
		1315724,
		88,
		true
	},
	mini_game_over_game = {
		1315812,
		87,
		true
	},
	pac_minigame_help = {
		1315899,
		802,
		true
	},
	SpringFestival2026CoreActivity_subtitle_1 = {
		1316701,
		130,
		true
	},
	SpringFestival2026CoreActivity_subtitle_2 = {
		1316831,
		126,
		true
	},
	SpringFestival2026CoreActivity_subtitle_3 = {
		1316957,
		118,
		true
	},
	SpringFestival2026CoreActivity_subtitle_4 = {
		1317075,
		126,
		true
	},
	SpringFestival2026CoreActivity_subtitle_5 = {
		1317201,
		127,
		true
	},
	SpringFestival2026CoreActivity_subtitle_6 = {
		1317328,
		132,
		true
	},
	SpringFestival2026CoreActivity_subtitle_7 = {
		1317460,
		128,
		true
	},
	island_post_event_label = {
		1317588,
		101,
		true
	},
	island_post_event_close_label = {
		1317689,
		99,
		true
	},
	island_post_event_open_label = {
		1317788,
		99,
		true
	},
	island_post_event_addition_label = {
		1317887,
		133,
		true
	},
	island_addition_influence = {
		1318020,
		104,
		true
	},
	island_addition_sale = {
		1318124,
		89,
		true
	},
	island_trade_title = {
		1318213,
		98,
		true
	},
	island_trade_title2 = {
		1318311,
		99,
		true
	},
	island_trade_sell_label = {
		1318410,
		98,
		true
	},
	island_trade_trend_label = {
		1318508,
		101,
		true
	},
	island_trade_purchase_label = {
		1318609,
		101,
		true
	},
	island_trade_rank_label = {
		1318710,
		102,
		true
	},
	island_trade_purchase_sub_label = {
		1318812,
		98,
		true
	},
	island_trade_sell_sub_label = {
		1318910,
		95,
		true
	},
	island_trade_rank_num_label = {
		1319005,
		107,
		true
	},
	island_trade_rank_info_label = {
		1319112,
		103,
		true
	},
	island_trade_rank_price_label = {
		1319215,
		106,
		true
	},
	island_trade_rank_level_label = {
		1319321,
		103,
		true
	},
	island_trade_invite_label = {
		1319424,
		102,
		true
	},
	island_trade_tip_label = {
		1319526,
		134,
		true
	},
	island_trade_tip_label2 = {
		1319660,
		136,
		true
	},
	island_trade_limit_label = {
		1319796,
		124,
		true
	},
	island_trade_send_msg_label = {
		1319920,
		174,
		true
	},
	island_trade_send_msg_match_label = {
		1320094,
		111,
		true
	},
	island_trade_sell_tip_label = {
		1320205,
		135,
		true
	},
	island_trade_purchase_failed_label = {
		1320340,
		142,
		true
	},
	island_trade_sell_failed_label = {
		1320482,
		145,
		true
	},
	island_trade_sell_failed_label2 = {
		1320627,
		137,
		true
	},
	island_trade_bag_full_label = {
		1320764,
		149,
		true
	},
	island_trade_reset_label = {
		1320913,
		114,
		true
	},
	island_trade_help = {
		1321027,
		84,
		true
	},
	island_trade_help_1 = {
		1321111,
		300,
		true
	},
	island_trade_help_2 = {
		1321411,
		420,
		true
	},
	island_trade_price_unrefresh = {
		1321831,
		157,
		true
	},
	island_trade_msg_pop = {
		1321988,
		164,
		true
	},
	island_trade_invite_success = {
		1322152,
		112,
		true
	},
	island_trade_share_success = {
		1322264,
		111,
		true
	},
	island_trade_activity_desc_1 = {
		1322375,
		191,
		true
	},
	island_trade_activity_desc_2 = {
		1322566,
		185,
		true
	},
	island_trade_activity_unlock = {
		1322751,
		137,
		true
	},
	island_bar_quick_game = {
		1322888,
		95,
		true
	},
	island_trade_cnt_inadequate = {
		1322983,
		110,
		true
	},
	drawdiary_ui_2026 = {
		1323093,
		93,
		true
	},
	loveactivity_ui_1 = {
		1323186,
		95,
		true
	},
	loveactivity_ui_2 = {
		1323281,
		94,
		true
	},
	loveactivity_ui_3 = {
		1323375,
		89,
		true
	},
	loveactivity_ui_4 = {
		1323464,
		144,
		true
	},
	loveactivity_ui_4_1 = {
		1323608,
		285,
		true
	},
	loveactivity_ui_4_2 = {
		1323893,
		285,
		true
	},
	loveactivity_ui_4_3 = {
		1324178,
		286,
		true
	},
	loveactivity_ui_5 = {
		1324464,
		95,
		true
	},
	loveactivity_ui_6 = {
		1324559,
		89,
		true
	},
	loveactivity_ui_7 = {
		1324648,
		134,
		true
	},
	loveactivity_ui_8 = {
		1324782,
		87,
		true
	},
	loveactivity_ui_9 = {
		1324869,
		102,
		true
	},
	loveactivity_ui_10 = {
		1324971,
		100,
		true
	},
	loveactivity_ui_11 = {
		1325071,
		107,
		true
	},
	loveactivity_ui_12 = {
		1325178,
		158,
		true
	},
	loveactivity_ui_13 = {
		1325336,
		123,
		true
	},
	child_cg_buy = {
		1325459,
		149,
		true
	},
	child_polaroid_buy = {
		1325608,
		155,
		true
	},
	child_could_buy = {
		1325763,
		124,
		true
	},
	loveactivity_ui_14 = {
		1325887,
		107,
		true
	},
	loveactivity_ui_15 = {
		1325994,
		110,
		true
	},
	loveactivity_ui_16 = {
		1326104,
		102,
		true
	},
	loveactivity_ui_17 = {
		1326206,
		102,
		true
	},
	loveactivity_ui_18 = {
		1326308,
		118,
		true
	},
	loveactivity_ui_19 = {
		1326426,
		123,
		true
	},
	loveactivity_ui_20 = {
		1326549,
		120,
		true
	},
	help_chunjie_jiulou_2026 = {
		1326669,
		951,
		true
	},
	LiquorFloorTaskUI_title = {
		1327620,
		104,
		true
	},
	LiquorFloorTaskUI_go = {
		1327724,
		91,
		true
	},
	LiquorFloorTaskUI_get = {
		1327815,
		91,
		true
	},
	LiquorFloorTaskUI_got = {
		1327906,
		92,
		true
	},
	LiquorFloor_gold_get = {
		1327998,
		101,
		true
	},
	MoscowURCoreActivity_subtitle_1 = {
		1328099,
		116,
		true
	},
	MoscowURCoreActivity_subtitle_2 = {
		1328215,
		109,
		true
	},
	loveactivity_help_tips = {
		1328324,
		455,
		true
	},
	spring_present_tips_btn = {
		1328779,
		104,
		true
	},
	spring_present_tips_time = {
		1328883,
		138,
		true
	},
	spring_present_tips0 = {
		1329021,
		143,
		true
	},
	spring_present_tips1 = {
		1329164,
		176,
		true
	},
	spring_present_tips2 = {
		1329340,
		184,
		true
	},
	spring_present_tips3 = {
		1329524,
		121,
		true
	},
	island_gift_tip_title = {
		1329645,
		92,
		true
	},
	island_gift_tip = {
		1329737,
		178,
		true
	},
	island_chara_gather_tip = {
		1329915,
		96,
		true
	},
	island_chara_gather_power = {
		1330011,
		101,
		true
	},
	island_chara_gather_money = {
		1330112,
		99,
		true
	},
	island_chara_gather_range = {
		1330211,
		110,
		true
	},
	island_chara_gather_start = {
		1330321,
		94,
		true
	},
	island_chara_gather_tag_1 = {
		1330415,
		105,
		true
	},
	island_chara_gather_tag_2 = {
		1330520,
		104,
		true
	},
	island_chara_gather_skill_effect = {
		1330624,
		108,
		true
	},
	island_chara_gather_done = {
		1330732,
		106,
		true
	},
	island_chara_gather_no_target = {
		1330838,
		118,
		true
	},
	island_quick_delegation = {
		1330956,
		95,
		true
	},
	island_quick_delegation_notenough_encourage = {
		1331051,
		165,
		true
	},
	island_quick_delegation_notenough_onduty = {
		1331216,
		159,
		true
	},
	child_plan_skip_event = {
		1331375,
		110,
		true
	},
	child_buy_memory_tip = {
		1331485,
		144,
		true
	},
	child_buy_polaroid_tip = {
		1331629,
		146,
		true
	},
	child_buy_ending_tip = {
		1331775,
		145,
		true
	},
	child_buy_collect_success = {
		1331920,
		98,
		true
	},
	loveletter2018_ui_4 = {
		1332018,
		120,
		true
	},
	loveletter2018_ui_5 = {
		1332138,
		155,
		true
	},
	LiquorFloor_title = {
		1332293,
		102,
		true
	},
	LiquorFloor_title_en = {
		1332395,
		94,
		true
	},
	LiquorFloor_level = {
		1332489,
		88,
		true
	},
	LiquorFloor_story_title = {
		1332577,
		96,
		true
	},
	LiquorFloor_story_title_1 = {
		1332673,
		105,
		true
	},
	LiquorFloor_story_title_2 = {
		1332778,
		105,
		true
	},
	LiquorFloor_story_title_3 = {
		1332883,
		106,
		true
	},
	LiquorFloor_story_title_4 = {
		1332989,
		98,
		true
	},
	LiquorFloor_story_go = {
		1333087,
		91,
		true
	},
	LiquorFloor_story_get = {
		1333178,
		91,
		true
	},
	LiquorFloor_story_got = {
		1333269,
		92,
		true
	},
	LiquorFloor_character_num = {
		1333361,
		103,
		true
	},
	LiquorFloor_character_unlock = {
		1333464,
		109,
		true
	},
	LiquorFloor_character_tip = {
		1333573,
		181,
		true
	},
	LiquorFloor_gold_num = {
		1333754,
		102,
		true
	},
	LiquorFloor_gold = {
		1333856,
		95,
		true
	},
	LiquorFloor_update = {
		1333951,
		90,
		true
	},
	LiquorFloor_update_unlock = {
		1334041,
		118,
		true
	},
	LiquorFloor_update_max = {
		1334159,
		103,
		true
	},
	LiquorFloor_gold_max_tip = {
		1334262,
		125,
		true
	},
	LiquorFloor_tip = {
		1334387,
		1439,
		true
	},
	loveletter2018_ui_1 = {
		1335826,
		219,
		true
	},
	loveletter2018_ui_2 = {
		1336045,
		142,
		true
	},
	loveletter2018_ui_3 = {
		1336187,
		138,
		true
	},
	loveletter2018_ui_tips = {
		1336325,
		113,
		true
	},
	child2_choose_title = {
		1336438,
		93,
		true
	},
	child2_choose_help = {
		1336531,
		1554,
		true
	},
	child2_show_detail_desc = {
		1338085,
		99,
		true
	},
	child2_tarot_empty = {
		1338184,
		112,
		true
	},
	child2_refresh_title = {
		1338296,
		97,
		true
	},
	child2_choose_hide = {
		1338393,
		86,
		true
	},
	child2_choose_giveup = {
		1338479,
		91,
		true
	},
	child2_tarot_tag_current = {
		1338570,
		99,
		true
	},
	child2_all_entry_title = {
		1338669,
		101,
		true
	},
	child2_benefit_moeny_effect = {
		1338770,
		108,
		true
	},
	child2_benefit_mood_effect = {
		1338878,
		107,
		true
	},
	child2_replace_sure_tip = {
		1338985,
		113,
		true
	},
	child2_tarot_title = {
		1339098,
		94,
		true
	},
	child2_entry_summary = {
		1339192,
		102,
		true
	},
	child2_benefit_result = {
		1339294,
		100,
		true
	},
	child2_mood_benefit = {
		1339394,
		98,
		true
	},
	child2_mood_stage1 = {
		1339492,
		105,
		true
	},
	child2_mood_stage2 = {
		1339597,
		99,
		true
	},
	child2_mood_stage3 = {
		1339696,
		102,
		true
	},
	child2_mood_stage4 = {
		1339798,
		101,
		true
	},
	child2_mood_stage5 = {
		1339899,
		101,
		true
	},
	child2_entry_activated = {
		1340000,
		102,
		true
	},
	child2_collect_tarot_progress = {
		1340102,
		109,
		true
	},
	child2_collect_tarot = {
		1340211,
		96,
		true
	},
	child2_collect_entry = {
		1340307,
		91,
		true
	},
	child2_collect_talent = {
		1340398,
		92,
		true
	},
	child2_rank_toggle_attr = {
		1340490,
		93,
		true
	},
	child2_rank_toggle_endless = {
		1340583,
		102,
		true
	},
	child2_rank_not_on = {
		1340685,
		90,
		true
	},
	child2_rank_refresh_tip = {
		1340775,
		127,
		true
	},
	child2_rank_header_rank = {
		1340902,
		98,
		true
	},
	child2_rank_header_info = {
		1341000,
		91,
		true
	},
	child2_rank_header_attr = {
		1341091,
		102,
		true
	},
	child2_replace_title = {
		1341193,
		110,
		true
	},
	child2_replace_tip = {
		1341303,
		251,
		true
	},
	child2_tarot_tag_replace = {
		1341554,
		97,
		true
	},
	child2_replace_cancel = {
		1341651,
		91,
		true
	},
	child2_replace_sure = {
		1341742,
		90,
		true
	},
	child2_nailing_game_tip = {
		1341832,
		153,
		true
	},
	child2_nailing_game_count = {
		1341985,
		100,
		true
	},
	child2_nailing_game_score = {
		1342085,
		95,
		true
	},
	child2_benefit_summary = {
		1342180,
		100,
		true
	},
	child2_word_giveup = {
		1342280,
		98,
		true
	},
	child2_rank_header_wave = {
		1342378,
		106,
		true
	},
	child2_personal_id2_tag1 = {
		1342484,
		91,
		true
	},
	child2_personal_id2_tag2 = {
		1342575,
		96,
		true
	},
	child2_go_shop = {
		1342671,
		98,
		true
	},
	child2_scratch_minigame_help = {
		1342769,
		522,
		true
	},
	child2_endless_sure_tip = {
		1343291,
		348,
		true
	},
	child2_endless_stage = {
		1343639,
		96,
		true
	},
	child2_cur_wave = {
		1343735,
		86,
		true
	},
	child2_endless_attrs_value = {
		1343821,
		105,
		true
	},
	child2_endless_boss_value = {
		1343926,
		114,
		true
	},
	child2_endless_assest_wave = {
		1344040,
		112,
		true
	},
	child2_endless_history_wave = {
		1344152,
		120,
		true
	},
	child2_endless_current_wave = {
		1344272,
		113,
		true
	},
	child2_endless_reset_tip = {
		1344385,
		175,
		true
	},
	child2_hard = {
		1344560,
		84,
		true
	},
	child2_hard_enter = {
		1344644,
		96,
		true
	},
	child2_switch_sure = {
		1344740,
		337,
		true
	},
	child2_collect_entry_progress = {
		1345077,
		110,
		true
	},
	child2_collect_talent_progress = {
		1345187,
		112,
		true
	},
	child2_word_upgrade = {
		1345299,
		91,
		true
	},
	child2_nailing_minigame_help = {
		1345390,
		849,
		true
	},
	child2_nailing_game_result2 = {
		1346239,
		97,
		true
	},
	child2_game_endless_cnt = {
		1346336,
		103,
		true
	},
	cultivating_plant_task_title = {
		1346439,
		116,
		true
	},
	cultivating_plant_island_task = {
		1346555,
		128,
		true
	},
	cultivating_plant_part_1 = {
		1346683,
		114,
		true
	},
	cultivating_plant_part_2 = {
		1346797,
		118,
		true
	},
	cultivating_plant_part_3 = {
		1346915,
		120,
		true
	},
	child2_priority_tip = {
		1347035,
		117,
		true
	},
	child2_cur_round_temp = {
		1347152,
		95,
		true
	},
	child2_nailing_game_result = {
		1347247,
		96,
		true
	},
	child2_benefit_summary2 = {
		1347343,
		101,
		true
	},
	child2_pool_exhausted = {
		1347444,
		122,
		true
	},
	child2_secretary_skin_confirm = {
		1347566,
		142,
		true
	},
	child2_secretary_skin_expire = {
		1347708,
		128,
		true
	},
	child2_explorer_main_help = {
		1347836,
		600,
		true
	}
}
