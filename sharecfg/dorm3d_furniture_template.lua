pg = pg or {}
pg.dorm3d_furniture_template = rawget(pg, "dorm3d_furniture_template") or setmetatable({
	__name = "dorm3d_furniture_template"
}, confNEO)
pg.dorm3d_furniture_template.all = {
	1,
	2,
	3,
	4,
	5,
	6,
	121,
	122,
	201,
	202,
	203,
	204,
	205,
	206,
	207,
	208,
	209,
	210,
	221,
	222,
	223,
	151,
	251,
	301,
	302,
	303,
	304,
	305,
	306,
	307,
	321,
	322,
	401,
	323,
	324,
	1101,
	1102,
	1103,
	1104,
	1105,
	1106,
	1107,
	1108,
	1151,
	1152,
	1153,
	1154,
	1201,
	1202,
	1203,
	1211,
	1212,
	1213,
	1214,
	1215,
	1221,
	1222,
	1223,
	1401,
	1402,
	1403,
	1411,
	1412,
	1413,
	1414,
	1415,
	1461,
	1462,
	1463,
	1468,
	2101,
	2102,
	2103,
	2111,
	2112,
	2113,
	2114,
	2115,
	2161,
	2201,
	2202,
	2203,
	2211,
	2212,
	2213,
	2214,
	2215,
	2261
}
pg.dorm3d_furniture_template.get_id_list_by_room_id = {
	{
		1,
		2,
		3,
		4,
		5,
		6,
		121,
		122,
		151
	},
	{
		201,
		202,
		203,
		204,
		205,
		206,
		207,
		208,
		209,
		210,
		221,
		222,
		223,
		251
	},
	{
		301,
		302,
		303,
		304,
		305,
		306,
		307,
		321,
		322,
		323,
		324
	},
	{
		401
	},
	[11] = {
		1101,
		1102,
		1103,
		1104,
		1105,
		1106,
		1107,
		1108,
		1151,
		1152,
		1153,
		1154
	},
	[12] = {
		1201,
		1202,
		1203,
		1211,
		1212,
		1213,
		1214,
		1215,
		1221,
		1222,
		1223
	},
	[14] = {
		1401,
		1402,
		1403,
		1411,
		1412,
		1413,
		1414,
		1415,
		1461,
		1462,
		1463,
		1468
	},
	[21] = {
		2101,
		2102,
		2103,
		2111,
		2112,
		2113,
		2114,
		2115,
		2161
	},
	[22] = {
		2201,
		2202,
		2203,
		2211,
		2212,
		2213,
		2214,
		2215,
		2261
	}
}
pg.base = pg.base or {}
pg.base.dorm3d_furniture_template = {}

;(function()
	pg.base.dorm3d_furniture_template[1] = {
		name = "Bar Stool",
		is_special = 0,
		unlock_tips = "",
		type = 6,
		unlock_banners = "",
		room_id = 1,
		icon = "dorm3dIcon/3Ddrom_tianlangxing_CommonFurniture5",
		desc = "An exquisitely crafted bar stool with a black wooden seat and a red leather cushion.The cushion is just plush enough that you could sit on it all day and never feel your butt hurt.",
		rarity = 3,
		acesses = "",
		model = "",
		model_night = "",
		id = 1,
		is_exclusive = 0,
		scene_hides = "",
		target_slots = {
			100202
		},
		touch_id = {
			{
				20220,
				10100201
			}
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[2] = {
		name = "Juicer",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 1,
		unlock_banners = "",
		desc = "Chop up your desired fruit or veggie, throw it inside, and press the start button.Feature-rich and easy to use, it's an indispensable item for any beginner chef.",
		icon = "dorm3dIcon/3Ddrom_tianlangxing_CommonFurniture4",
		acesses = "",
		model = "Pay_Siriushostel/pre_db_sh_electrical03",
		rarity = 2,
		id = 2,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			100201
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[3] = {
		name = "Classic Sofa",
		is_special = 0,
		unlock_tips = "",
		type = 5,
		unlock_banners = "",
		room_id = 1,
		icon = "dorm3dIcon/3Ddrom_tianlangxing_CommonFurniture6",
		desc = "This sofa, made of real leather, is just the right length.Beyond adding a luxurious vibe to your living room, it also provides a comfortable sitting experience.",
		rarity = 3,
		acesses = "",
		model = "",
		model_night = "",
		id = 3,
		is_exclusive = 0,
		scene_hides = "",
		target_slots = {
			100301
		},
		touch_id = {
			{
				20220,
				10100303
			}
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[4] = {
		name = "Simple Bed",
		is_special = 0,
		unlock_tips = "",
		type = 4,
		unlock_banners = "",
		room_id = 1,
		icon = "dorm3dIcon/3Ddrom_tianlangxing_CommonFurniture3",
		desc = "The bed frame is made of sturdy lumber that can easily support its user.Its simple and comfortable design does a fantastic job at giving her sweet dreams.",
		rarity = 3,
		acesses = "",
		model = "",
		model_night = "",
		id = 4,
		is_exclusive = 0,
		scene_hides = "",
		target_slots = {
			100102
		},
		touch_id = {
			{
				20220,
				10100104
			}
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[5] = {
		name = "Desk Lamp",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 1,
		unlock_banners = "",
		desc = "A desk lamp sitting on Sirius' dresser. She turns it on at night when it's a bit too dark. She is always adjusting her appearance, trying to look her best for the person she adores.",
		icon = "dorm3dIcon/3Ddrom_tianlangxing_CommonFurniture2",
		acesses = "",
		model = "Pay_Siriushostel/pre_db_sh_chandelier01",
		rarity = 2,
		id = 5,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			100101
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[6] = {
		name = "Model Cruise Liner",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 1,
		unlock_banners = "",
		desc = "A model that Sirius had bought and put together after the big cruise trip.In a way, it really shows her sense of devotion.",
		icon = "dorm3dIcon/3Ddrom_tianlangxing_CommonFurniture1",
		acesses = "",
		model = "Pay_Siriushostel/pre_db_sh_decoration01",
		rarity = 2,
		id = 6,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			100402
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[121] = {
		name = "Sweet Secret",
		is_special = 0,
		icon = "dorm3dIcon/3Ddrom_tianlangxing_PremiumFurniture4",
		type = 4,
		rarity = 4,
		room_id = 1,
		model_night = "",
		desc = "The decorative ribbons all over it exude a charming and romantic vibe, as do the red and white pillows.",
		acesses = "",
		model = "Pay_Siriushostel/pre_db_sh_bed01",
		id = 121,
		is_exclusive = 1,
		scene_hides = "",
		target_slots = {
			100102
		},
		touch_id = {
			{
				20220,
				10100107
			}
		},
		shop_id = {
			270101
		},
		unlock_tips = {
			3
		},
		unlock_banners = {
			"banner_furniture121"
		}
	}
	pg.base.dorm3d_furniture_template[122] = {
		name = "Afternoon Dreamhome",
		is_special = 0,
		icon = "dorm3dIcon/3Ddrom_tianlangxing_PremiumFurniture2",
		type = 5,
		rarity = 4,
		room_id = 1,
		model_night = "",
		desc = "A comfortable reclining couch.\n Soft, fluffy, and comes with cushions and a blanket. A relaxing spot to take a nap at any time of the day.",
		acesses = "",
		model = "Pay_Siriushostel/pre_db_sh_chair02",
		id = 122,
		is_exclusive = 1,
		scene_hides = "",
		target_slots = {
			100301
		},
		touch_id = {
			{
				20220,
				10100202
			}
		},
		shop_id = {
			270103
		},
		unlock_tips = {
			3
		},
		unlock_banners = {
			"banner_furniture122"
		}
	}
	pg.base.dorm3d_furniture_template[201] = {
		name = "Fluffy Futon",
		is_special = 0,
		unlock_tips = "",
		type = 4,
		unlock_banners = "",
		room_id = 2,
		icon = "dorm3dIcon/3Ddrom_nengdai_CommonFurniture1",
		desc = "A simple futon on the tatami. It's refreshing, soothing, soft, and comfortable.\nAll your fatigue fades away the moment you lie down.",
		rarity = 3,
		acesses = "",
		model = "",
		model_night = "",
		id = 201,
		is_exclusive = 0,
		scene_hides = "",
		target_slots = {
			120103
		},
		touch_id = {
			{
				30221,
				2200310
			}
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[202] = {
		name = "Gentle Snack Time",
		is_special = 0,
		unlock_tips = "",
		type = 6,
		unlock_banners = "",
		room_id = 2,
		icon = "dorm3dIcon/3Ddrom_nengdai_CommonFurniture2",
		desc = "Two people sat across from each other. A carefree conversation. An appetizing smell.\nEven the passage of time seems to mellow in the grace of her smile.",
		rarity = 3,
		acesses = "",
		model = "",
		model_night = "",
		id = 202,
		is_exclusive = 0,
		scene_hides = "",
		target_slots = {
			120203
		},
		touch_id = {
			{
				30221,
				2200210
			}
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[203] = {
		name = "Breezy Leisure",
		is_special = 0,
		unlock_tips = "",
		type = 5,
		unlock_banners = "",
		room_id = 2,
		icon = "dorm3dIcon/3Ddrom_nengdai_CommonFurniture3",
		desc = "The comforting, natural material invites you to a leisurely moment of rest.\nA refreshing breeze carries a delicate fragrance and the gentle jingle of wind chimes, weaving together a perfect afternoon.",
		rarity = 3,
		acesses = "",
		model = "",
		model_night = "",
		id = 203,
		is_exclusive = 0,
		scene_hides = "",
		target_slots = {
			120303
		},
		touch_id = {
			{
				30221,
				2200110
			}
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[204] = {
		name = "A Branch of Spring",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 2,
		unlock_banners = "",
		desc = "This vase, with its fine porcelain and beautiful lines, is the perfect complement to flowers in bloom.\nThe fragrance of the blossoms and the vase's graceful shape come together brilliantly, exuding vitality and elegance.",
		icon = "dorm3dIcon/3Ddrom_nengdai_CommonFurniture4",
		acesses = "",
		model = "Pay_Noshirohostel/pre_db_nh_vase01",
		rarity = 2,
		id = 204,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			120101
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[205] = {
		name = "Manjuu Plushie",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 2,
		unlock_banners = "",
		desc = "This cuddly creature brings a smile to your face with its detailed craftsmanship that evokes special memories.\nEven when standing silently in a corner, it warms up the room more than anything else.",
		icon = "dorm3dIcon/3Ddrom_nengdai_CommonFurniture5",
		acesses = "",
		model = "Pay_Noshirohostel/pre_db_nh_toy02",
		rarity = 2,
		id = 205,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			120102
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[206] = {
		name = "Tea for the Pinkish Bloom",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 2,
		unlock_banners = "",
		desc = "The pink petals gently touch the tray's rim – a graceful spring sight.\nIt evokes memories of moments shared with her, amidst swirling cherry blossom breezes and the breath of fresh greenery.",
		icon = "dorm3dIcon/3Ddrom_nengdai_CommonFurniture6",
		acesses = "",
		model = "Pay_Noshirohostel/pre_db_nh_tableware02",
		rarity = 2,
		id = 206,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			120201
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[207] = {
		name = "Blue Skies, Stout Pine",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 2,
		unlock_banners = "",
		desc = "Its barky arms extend toward the sky with grace.\nThe leaves and branches are exquisitely pruned, in the posture of a life yearning for contentment and ease.",
		icon = "dorm3dIcon/3Ddrom_nengdai_CommonFurniture7",
		acesses = "",
		model = "",
		rarity = 2,
		id = 207,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			120202
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[208] = {
		name = "Tranquil Pause",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 2,
		unlock_banners = "",
		desc = "The understated ceramic and the verdant plant together display the art of simplicity.\nIts reserved vitality contributes a Zen-like serenity to the whole space.",
		icon = "dorm3dIcon/3Ddrom_nengdai_CommonFurniture8",
		acesses = "",
		model = "",
		rarity = 2,
		id = 208,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			120301
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[209] = {
		name = "Vernal Vase",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 2,
		unlock_banners = "",
		desc = "The vase is vividly colored in the season's palette, and the branches are naturally spread out, flowing like in a picture scroll.\nEvery time flowers are arranged, their beauty is interpreted anew.",
		icon = "dorm3dIcon/3Ddrom_nengdai_CommonFurniture9",
		acesses = "",
		model = "Pay_Noshirohostel/pre_db_nh_vase02",
		rarity = 2,
		id = 209,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			120302
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[210] = {
		name = "Good Fortjuune Hanging Scroll",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 2,
		unlock_banners = "",
		desc = "May your wishes come true and good fortune grace you.\nThe manjuu's round, endearing shape warms your heart.",
		icon = "dorm3dIcon/3Ddrom_nengdai_CommonFurniture10",
		acesses = "",
		model = "Pay_Noshirohostel/pre_db_nh_decoration02",
		rarity = 2,
		id = 210,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			120202
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[221] = {
		name = "Tanuki Cushion",
		is_special = 0,
		icon = "dorm3dIcon/3Ddrom_nengdai_PremiumFurniture1",
		type = 4,
		rarity = 4,
		room_id = 2,
		model_night = "",
		desc = "Its soft texture and pleasant warmth gently wrap around your body.\nWhether you choose to cuddle it or hug it, the cushion will accept you.",
		acesses = "",
		model = "Pay_Noshirohostel/pre_db_nh_bed01",
		id = 221,
		is_exclusive = 1,
		scene_hides = "",
		target_slots = {
			120103
		},
		touch_id = {
			{
				30221,
				2200410
			}
		},
		shop_id = {
			270201
		},
		unlock_tips = {
			3
		},
		unlock_banners = {
			"banner_furniture221"
		}
	}
	pg.base.dorm3d_furniture_template[222] = {
		name = "Table for Two",
		is_special = 0,
		icon = "dorm3dIcon/3Ddrom_nengdai_PremiumFurniture2",
		type = 6,
		rarity = 3,
		room_id = 2,
		model_night = "",
		desc = "A spacious table full of joy and anticipation for great conversations.\nAll that remains is for two minds to meet.",
		acesses = "",
		model = "Pay_Noshirohostel/pre_db_nh_diningroom01",
		id = 222,
		is_exclusive = 1,
		target_slots = {
			120203
		},
		touch_id = {
			{
				30221,
				2200610
			}
		},
		shop_id = {
			270202
		},
		unlock_tips = {
			3
		},
		unlock_banners = {
			"banner_furniture222"
		},
		scene_hides = {
			"fbx/no_bake_pay_prop/diningroom"
		}
	}
	pg.base.dorm3d_furniture_template[223] = {
		name = "Serene Moment",
		is_special = 0,
		icon = "dorm3dIcon/3Ddrom_nengdai_PremiumFurniture3",
		type = 5,
		rarity = 4,
		room_id = 2,
		model_night = "",
		desc = "Let the soft cushions envelop your weary body and gently prop you up.\nThis spot is very difficult to resist after a long day.",
		acesses = "",
		model = "Pay_Noshirohostel/pre_db_nh_livingroom01",
		id = 223,
		is_exclusive = 1,
		target_slots = {
			120303
		},
		touch_id = {
			{
				30221,
				2200710
			}
		},
		shop_id = {
			270203
		},
		unlock_tips = {
			3
		},
		unlock_banners = {
			"banner_furniture223"
		},
		scene_hides = {
			"fbx/no_bake_pay_prop/livingroom"
		}
	}
	pg.base.dorm3d_furniture_template[151] = {
		name = "Christmas Eve Sleigh Sofa",
		is_special = 1,
		icon = "dorm3dIcon/3Ddrom_tianlangxing_PremiumFurniture5",
		type = 5,
		rarity = 5,
		room_id = 1,
		model_night = "",
		desc = "The snowflakes dance, the fireplace glows warmly, and the promise of Christmas resounds.\nAn adorable reindeer sleigh sofa featuring soft cushions and blankets. Underneath the starlight, your heart thumps expectantly at the blessings and surprises awaiting you.\nGather 'round with jovial spirits and a full belly from the feast, and who knows? You might just write your very own Christmas miracle.",
		acesses = "",
		model = "Pay_Siriushostel/Sh_Sp_Xmas/pre_db_sp_sh_xmas01",
		id = 151,
		is_exclusive = 1,
		target_slots = {
			100301
		},
		touch_id = {
			{
				20220,
				10100203
			}
		},
		shop_id = {
			270104
		},
		unlock_tips = {
			3
		},
		unlock_banners = {
			"banner_furniture151"
		},
		scene_hides = {
			"fbx/litmap_03/pre_db_chandelier06",
			"fbx/litmap_03/pre_db_table02",
			"fbx/litmap_03/pre_db_ceram01",
			"fbx/litmap_03/pre_db_ceram01b (1)",
			"fbx/litmap_03/pre_db_book01"
		}
	}
	pg.base.dorm3d_furniture_template[251] = {
		name = "Where Warmth Lingers",
		is_special = 1,
		icon = "dorm3dIcon/3Ddrom_nengdai_PremiumFurniture251",
		type = 5,
		rarity = 5,
		room_id = 2,
		model_night = "",
		desc = "The warmth of a kotatsu makes you think of a lazy afternoon in the winter.\nSunlight streams through the window and onto the tatami mat, mingling with the kotatsu's warmth to melt away all your stress.",
		acesses = "",
		model = "Pay_Noshirohostel/Nh_Sp_NewYearsDay/pre_db_nh_sp_nyd_livingroom01",
		id = 251,
		is_exclusive = 1,
		target_slots = {
			120303
		},
		touch_id = {
			{
				30221,
				2200510
			}
		},
		shop_id = {
			270105
		},
		unlock_tips = {
			3
		},
		unlock_banners = {
			"banner_furniture251"
		},
		scene_hides = {
			"fbx/no_bake_pay_prop/livingroom"
		}
	}
	pg.base.dorm3d_furniture_template[301] = {
		name = "Beary Comfy Bed",
		is_special = 0,
		unlock_tips = "",
		type = 4,
		unlock_banners = "",
		room_id = 3,
		icon = "dorm3dIcon/3Ddrom_ankeleiqi_CommonFurniture2",
		desc = "The headboard, shaped like a teddy bear cookie, is simple yet cute.\nWhen you lie down in this bed, you can practically smell sea salt cookies, forgetting your fatigue and falling into the sweetest of dreams.",
		rarity = 3,
		acesses = "",
		model = "",
		model_night = "",
		id = 301,
		is_exclusive = 0,
		scene_hides = "",
		target_slots = {
			130103
		},
		touch_id = {
			{
				19903,
				1990330
			}
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[302] = {
		name = "Blue Corner",
		is_special = 0,
		unlock_tips = "",
		type = 6,
		unlock_banners = "",
		room_id = 3,
		icon = "dorm3dIcon/3Ddrom_ankeleiqi_CommonFurniture3",
		desc = "The colorful decorations and imaginative design fill this little corner with wonder and adventure.\nEven if it rained outside, this would put you in a sunny mood.",
		rarity = 3,
		acesses = "",
		model = "",
		model_night = "",
		id = 302,
		is_exclusive = 0,
		scene_hides = "",
		target_slots = {
			130202
		},
		touch_id = {
			{
				19903,
				1990320
			}
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[303] = {
		name = "Warm Sofa",
		is_special = 0,
		unlock_tips = "",
		type = 5,
		unlock_banners = "",
		room_id = 3,
		icon = "dorm3dIcon/3Ddrom_ankeleiqi_CommonFurniture1",
		desc = "A couch with an aroma reminiscent of fresh-baked cookies.\nEvery nook and cranny is as adorable as can be, providing a truly comforting rest.",
		rarity = 3,
		acesses = "",
		model = "",
		model_night = "",
		id = 303,
		is_exclusive = 0,
		scene_hides = "",
		target_slots = {
			130302
		},
		touch_id = {
			{
				19903,
				1990310
			}
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[304] = {
		name = "Sacabambaspis Plushies",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 3,
		unlock_banners = "",
		desc = "Soft plushies modeled after an adorable aquatic creature.\nWhat could be more comforting?",
		icon = "dorm3dIcon/3Ddrom_ankeleiqi_CommonFurniture5",
		acesses = "",
		model = "Pay_Anchoragehostel/pre_db_ah_toy05",
		rarity = 2,
		id = 304,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			130101
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[305] = {
		name = "Breath of Fresh Air",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 3,
		unlock_banners = "",
		desc = "Layers on layers of little foliage.\nAnywhere you put it, natural comfort follows.",
		icon = "dorm3dIcon/3Ddrom_ankeleiqi_CommonFurniture4",
		acesses = "",
		model = "Pay_Anchoragehostel/pre_db_ah_pottedplant01",
		rarity = 2,
		id = 305,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			130102
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[306] = {
		name = "Records of Time",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 3,
		unlock_banners = "",
		desc = "Stylish picture frames hold whimsical artwork.\nSomeday, these frames may display the most precious memories of all.",
		icon = "dorm3dIcon/3Ddrom_ankeleiqi_CommonFurniture6",
		acesses = "",
		model = "Pay_Anchoragehostel/pre_db_ah_billboard01_group01",
		rarity = 2,
		id = 306,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			130201
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[307] = {
		name = "Marine Adventure",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 3,
		unlock_banners = "",
		desc = "More than just a decoration, it's like a switch.\nOne touch turns the window into a magical portal into the sea.",
		icon = "dorm3dIcon/3Ddrom_ankeleiqi_CommonFurniture7",
		acesses = "",
		model = "Pay_Anchoragehostel/pre_db_ah_decoration02",
		rarity = 2,
		id = 307,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			130301
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[321] = {
		name = "Teatime Indulgence",
		is_special = 0,
		icon = "dorm3dIcon/3Ddrom_ankeleiqi_PremiumFurniture1",
		type = 6,
		rarity = 4,
		room_id = 3,
		model_night = "",
		desc = "This coffee cup holds the contentment and comfort of indulging in a moment of fantasy.\nAnyone here can experience what it would be like to have a fairy-tale tea party.",
		acesses = "",
		model = "Pay_Anchoragehostel/pre_db_ah_entertainmentarea01",
		id = 321,
		is_exclusive = 1,
		target_slots = {
			130202
		},
		touch_id = {
			{
				19903,
				1990340
			}
		},
		shop_id = {
			270301
		},
		unlock_tips = {
			3
		},
		unlock_banners = {
			"banner_furniture321"
		},
		scene_hides = {
			"fbx/no_bake_pay_prop/entertainmentarea"
		}
	}
	pg.base.dorm3d_furniture_template[322] = {
		name = "Boat of the Starry Night",
		is_special = 0,
		icon = "dorm3dIcon/3Ddrom_ankeleiqi_PremiumFurniture2",
		type = 4,
		rarity = 4,
		room_id = 3,
		model_night = "",
		desc = "This soft bed features beautiful curves and an ocean blue color scheme. \nIt floats off into the night sky, guiding you into exciting and romantic dreams.",
		acesses = "",
		model = "Pay_Anchoragehostel/pre_db_ah_bedroom01",
		id = 322,
		is_exclusive = 1,
		target_slots = {
			130103
		},
		touch_id = {
			{
				19903,
				1990350
			}
		},
		shop_id = {
			270302
		},
		unlock_tips = {
			3
		},
		unlock_banners = {
			"banner_furniture322"
		},
		scene_hides = {
			"fbx/no_bake_pay_prop/bedroom"
		}
	}
	pg.base.dorm3d_furniture_template[401] = {
		name = "Seaside Slide",
		is_special = 1,
		is_exclusive = 0,
		type = 3,
		icon = "dorm3dIcon/3Ddrom_beach_PremiumFurniture1",
		room_id = 4,
		rarity = 5,
		desc = "Vacation time starts now! Sunlight under the palm tree, a view by the refreshing coast, and water splashes and sea breezes. Your mind is instantly wrapped up in the joys of a tropical vacation.",
		model_night = "",
		acesses = "",
		model = "pay_publicplace/slide",
		id = 401,
		touch_id = "",
		scene_hides = "",
		target_slots = {
			140101
		},
		shop_id = {
			270401
		},
		unlock_tips = {
			7
		},
		unlock_banners = {
			"banner_furniture401"
		}
	}
	pg.base.dorm3d_furniture_template[323] = {
		name = "Dream in the Clouds",
		is_special = 0,
		icon = "dorm3dIcon/3Ddrom_ankeleiqi_PremiumFurniture8",
		type = 5,
		rarity = 4,
		room_id = 3,
		model_night = "",
		desc = "Waving clouds, a soft sensation, a comfiness reminiscent of marshmallows. Get together and relax in the sweet fragrance.",
		acesses = "",
		model = "Pay_Anchoragehostel/pre_db_ah_livingroom01",
		id = 323,
		is_exclusive = 1,
		target_slots = {
			130302
		},
		touch_id = {
			{
				19903,
				1990360
			}
		},
		shop_id = {
			270303
		},
		unlock_tips = {
			3
		},
		unlock_banners = {
			"banner_furniture323"
		},
		scene_hides = {
			"fbx/no_bake_pay_prop/livingroom"
		}
	}
	pg.base.dorm3d_furniture_template[324] = {
		name = "Haven of Innocence",
		is_special = 1,
		icon = "dorm3dIcon/3Ddrom_ankeleiqi_PremiumFurniture9",
		type = 4,
		rarity = 5,
		room_id = 3,
		model_night = "",
		desc = "Soft, heart-shaped cushions and twinkling toy lights adorn this bed. Welcome to an ocean-blue haven of innocence.",
		acesses = "",
		model = "Pay_Anchoragehostel/Ah_Sp_ValentinesDay/pre_db_aklq_sp_vd01",
		id = 324,
		is_exclusive = 1,
		target_slots = {
			130103
		},
		touch_id = {
			{
				19903,
				1990370
			}
		},
		shop_id = {
			270304
		},
		unlock_tips = {
			8
		},
		unlock_banners = {
			"banner_furniture324"
		},
		scene_hides = {
			"fbx/no_bake_pay_prop/bedroom",
			"fbx/no_bake/pre_db_anchoragehostel01_lamp01",
			"fbx/no_bake/pre_db_anchoragehostel01_lamp01_night"
		}
	}
	pg.base.dorm3d_furniture_template[1101] = {
		name = "Rabbit's Cradle",
		is_special = 0,
		unlock_tips = "",
		type = 4,
		unlock_banners = "",
		room_id = 11,
		icon = "dorm3dIcon/3Ddrom_xinzexi_CommonFurniture1",
		desc = "A bed designed for comfortable sleep. Its sturdy structure and stability are top-notch.\nIf you sleep here holding a soft, bunny-shaped cushion, you might just dream of a carrot farm under the stars…",
		rarity = 3,
		acesses = "",
		model = "",
		model_night = "",
		id = 1101,
		is_exclusive = 0,
		scene_hides = "",
		target_slots = {
			1110102
		},
		touch_id = {
			{
				10517,
				1051730
			}
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[1102] = {
		name = "Ice Age",
		is_special = 0,
		unlock_tips = "",
		type = 6,
		unlock_banners = "",
		room_id = 11,
		icon = "dorm3dIcon/3Ddrom_xinzexi_CommonFurniture2",
		desc = "Sleek and next-gen in design, this unit features a powerful cooling system.\nChill some Oxy-cola in it, and it will bring refreshment and comfort to your life.",
		rarity = 3,
		acesses = "",
		model = "",
		model_night = "",
		id = 1102,
		is_exclusive = 0,
		scene_hides = "",
		target_slots = {
			1110203
		},
		touch_id = {
			{
				10517,
				1051710
			}
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[1103] = {
		name = "Sunlight Island",
		is_special = 0,
		unlock_tips = "",
		type = 5,
		unlock_banners = "",
		room_id = 11,
		icon = "dorm3dIcon/3Ddrom_xinzexi_CommonFurniture3",
		desc = "A classic fabric sofa with a soft, fluffy texture.\nWhen the afternoon sunlight shines in, it becomes the perfect island for napping.",
		rarity = 3,
		acesses = "",
		model = "",
		model_night = "",
		id = 1103,
		is_exclusive = 0,
		scene_hides = "",
		target_slots = {
			1110303
		},
		touch_id = {
			{
				10517,
				1051720
			}
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[1104] = {
		name = "Planet Nightlight",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 11,
		unlock_banners = "",
		desc = "A lamp inspired by the shape of a planet. At night, it emits dim light.\nSomewhere in the starry sky, there must be some planet out there quietly watching over you.",
		icon = "dorm3dIcon/3Ddrom_xinzexi_CommonFurniture6",
		acesses = "",
		model = "Pay_Newjerseyhostel/pre_db_njh_electrical03",
		rarity = 2,
		id = 1104,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			1110101
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[1105] = {
		name = "Decorative Art",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 11,
		unlock_banners = "",
		desc = "A minimalist painting featuring overlapping geometric shapes that create a unique beauty. It adds a lively touch to the room.",
		icon = "dorm3dIcon/3Ddrom_xinzexi_CommonFurniture5",
		acesses = "",
		model = "Pay_Newjerseyhostel/pre_db_njh_billboard01",
		rarity = 2,
		id = 1105,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			1110301
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[1106] = {
		name = "Silent Blue",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 11,
		unlock_banners = "",
		desc = "Gently flip the switch, and a soft glow spills out. Jellyfish float in a dreamy blue void.\nHow long... has your imagination been immersed in this little ocean?",
		icon = "dorm3dIcon/3Ddrom_xinzexi_CommonFurniture7",
		acesses = "",
		model = "Pay_Newjerseyhostel/pre_db_njh_fishtank01",
		rarity = 2,
		id = 1106,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			1110302
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[1107] = {
		name = "Microwave",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 11,
		unlock_banners = "",
		desc = "A quick and convenient heating tool, perfect for breakfast, afternoon tea, and more.",
		icon = "dorm3dIcon/3Ddrom_xinzexi_CommonFurniture8",
		acesses = "",
		model = "Pay_Newjerseyhostel/pre_db_njh_electrical04",
		rarity = 2,
		id = 1107,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			1110201
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[1108] = {
		name = "Potted Plant",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 11,
		unlock_banners = "",
		desc = "It doesn't just make the place prettier – it purifies the air, too!",
		icon = "dorm3dIcon/3Ddrom_xinzexi_CommonFurniture9",
		acesses = "",
		model = "Pay_Newjerseyhostel/pre_db_njh_pottedplant01",
		rarity = 2,
		id = 1108,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			1110202
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[1151] = {
		name = "Starry Corner",
		is_special = 0,
		icon = "dorm3dIcon/3Ddrom_xinzexi_PremiumFurniture1",
		type = 5,
		rarity = 4,
		room_id = 11,
		model_night = "",
		desc = "This cutting-edge seat has a futuristic aura and features smart temperature control.\nIt also comes with a 24/7 chilled drink supply, giving you a truly comfortable service experience.",
		acesses = "",
		model = "Pay_Newjerseyhostel/pre_db_njh_livingroom01",
		id = 1151,
		is_exclusive = 1,
		target_slots = {
			1110303
		},
		touch_id = {
			{
				10517,
				1051740
			}
		},
		shop_id = {
			271101
		},
		unlock_tips = {
			3
		},
		unlock_banners = {
			"banner_furniture1151"
		},
		scene_hides = {
			"no_bake_pay_prop/livingroom"
		}
	}
	pg.base.dorm3d_furniture_template[1152] = {
		name = "Exercise Bike",
		is_special = 1,
		icon = "dorm3dIcon/3Ddrom_xinzexi_PremiumFurniture4",
		type = 5,
		rarity = 5,
		room_id = 11,
		model_night = "",
		desc = "A serious exercise machine that even puts thought into the user's emotional and recreational needs.\nSimply put your feet on the pedals and go on a heart-racing journey from the comfort of your own home!",
		acesses = "",
		model = "Pay_Newjerseyhostel/pre_db_njh_entertainment01",
		id = 1152,
		is_exclusive = 1,
		target_slots = {
			1110303
		},
		touch_id = {
			{
				10517,
				1051750
			}
		},
		shop_id = {
			270204
		},
		unlock_tips = {
			3
		},
		unlock_banners = {
			"banner_furniture1152"
		},
		scene_hides = {
			"no_bake_pay_prop/livingroom"
		}
	}
	pg.base.dorm3d_furniture_template[1153] = {
		name = "Sanctuary Beyond Heavens",
		is_special = 0,
		icon = "dorm3dIcon/3Ddrom_xinzexi_PremiumFurniture2",
		type = 4,
		rarity = 4,
		room_id = 11,
		model_night = "",
		desc = "A quiet place to relax that is the synthesis of technology and artistic beauty. It feels almost like a warm safehouse at the edge of the galaxy.\nSurrender yourself to it, forget your daily troubles, and let the dreams of the cosmos embrace you.",
		acesses = "",
		model = "Pay_Newjerseyhostel/pre_db_njh_bedroom01",
		id = 1153,
		is_exclusive = 1,
		target_slots = {
			1110102
		},
		touch_id = {
			{
				10517,
				1051760
			}
		},
		shop_id = {
			270205
		},
		unlock_tips = {
			3
		},
		unlock_banners = {
			"banner_furniture1153"
		},
		scene_hides = {
			"no_bake_pay_prop/bedroom"
		}
	}
	pg.base.dorm3d_furniture_template[1154] = {
		name = "IB-7 Smart Refrigerator",
		is_special = 0,
		icon = "dorm3dIcon/3Ddrom_xinzexi_PremiumFurniture3",
		type = 6,
		rarity = 4,
		room_id = 11,
		model_night = "",
		desc = "Hello. This is the IB-7 smart refrigerator.\nYour strawberry ice cream is ready. It's your favorite flavor.\n...You'd like more personalized recommendations? That feature is currently in development. Please stay tuned!",
		acesses = "",
		model = "Pay_Newjerseyhostel/pre_db_njh_kitchen01",
		id = 1154,
		is_exclusive = 1,
		scene_hides = "",
		target_slots = {
			1110204
		},
		touch_id = {
			{
				10517,
				1051780
			}
		},
		shop_id = {
			270206
		},
		unlock_tips = {
			3
		},
		unlock_banners = {
			"banner_furniture1154"
		}
	}
	pg.base.dorm3d_furniture_template[1201] = {
		name = "Fluffy Bed",
		is_special = 0,
		unlock_tips = "",
		type = 4,
		icon = "dorm3dIcon/3Ddrom_dafeng_CommonFurniture1",
		room_id = 12,
		rarity = 3,
		desc = "A soft double bed with a complete set of bedding: comfy mattress, blanket, and pillows. Slip under the blanket and sleep off the day's troubles.",
		model_night = "",
		acesses = "",
		model = "",
		id = 1201,
		is_exclusive = 0,
		scene_hides = "",
		target_slots = {
			1120103
		},
		touch_id = {
			{
				30707,
				3070710
			}
		},
		shop_id = {},
		unlock_banners = {
			"banner_furniture1151"
		}
	}
	pg.base.dorm3d_furniture_template[1202] = {
		name = "Wooden Dining Table",
		is_special = 0,
		unlock_tips = "",
		type = 6,
		icon = "dorm3dIcon/3Ddrom_dafeng_CommonFurniture2",
		room_id = 12,
		rarity = 3,
		desc = "This table is made of quality, long-lasting wood. Its top is smooth and easy to clean, and its dark surface is resistant to stains while showcasing the natural texture of red sandalwood.",
		model_night = "",
		acesses = "",
		model = "",
		id = 1202,
		is_exclusive = 0,
		scene_hides = "",
		target_slots = {
			1120203
		},
		touch_id = {
			{
				30707,
				3070720
			}
		},
		shop_id = {},
		unlock_banners = {
			"banner_furniture1151"
		}
	}
	pg.base.dorm3d_furniture_template[1203] = {
		name = "Comfy Chair",
		is_special = 0,
		unlock_tips = "",
		type = 5,
		icon = "dorm3dIcon/3Ddrom_dafeng_CommonFurniture3",
		room_id = 12,
		rarity = 3,
		desc = "A simple tatami chair – basically just a seat and a backrest. It's comfy enough that you can sit for a long time without feeling any muscle fatigue.",
		model_night = "",
		acesses = "",
		model = "",
		id = 1203,
		is_exclusive = 0,
		scene_hides = "",
		target_slots = {
			1120303
		},
		touch_id = {
			{
				30707,
				3070730
			}
		},
		shop_id = {},
		unlock_banners = {
			"banner_furniture1152"
		}
	}
	pg.base.dorm3d_furniture_template[1211] = {
		name = "Classical Wall Scroll",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 12,
		unlock_banners = "",
		desc = "The refined art has a zen vibe to it, harmonizing with the rest of the room. It gives a sense of tranquility and elegance.",
		icon = "dorm3dIcon/3Ddrom_dafeng_CommonFurniture4",
		acesses = "",
		model = "Pay_Dafenghostel/pre_db_df_wallscrolls01",
		rarity = 2,
		id = 1211,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			1120301
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[1212] = {
		name = "Beloved Companion",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 12,
		unlock_banners = "",
		desc = "The fabric of the black bikini was exceptionally light and soft against the skin. It almost feels like you're wearing nothing at all!",
		icon = "dorm3dIcon/3Ddrom_dafeng_CommonFurniture5",
		acesses = "",
		model = "Pay_Dafenghostel/pre_db_df_cloth01",
		rarity = 2,
		id = 1212,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			1120101
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[1213] = {
		name = "Floor Lamp",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 12,
		unlock_banners = "",
		desc = "The tall wooden floor lamp casts a gentle glow in the room. It was a piece Taihou had picked out herself.",
		icon = "dorm3dIcon/3Ddrom_dafeng_CommonFurniture6",
		acesses = "",
		model = "Pay_Dafenghostel/pre_db_df_floorlamp01",
		rarity = 2,
		id = 1213,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			1120302
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[1214] = {
		name = "Translucent Screen",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 12,
		unlock_banners = "",
		desc = "The translucent screen features an intricate pattern. Taihou likes to place it by her bed to lend that corner of the room a mysterious allure.",
		icon = "dorm3dIcon/3Ddrom_dafeng_CommonFurniture7",
		acesses = "",
		model = "Pay_Dafenghostel/pre_db_df_frame01",
		rarity = 2,
		id = 1214,
		touch_id = "",
		model_night = "",
		target_slots = {
			1120102
		},
		shop_id = {},
		scene_hides = {
			"no_bake_prop_substitute/pre_db_frame32"
		}
	}
	pg.base.dorm3d_furniture_template[1215] = {
		name = "Night Light",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 12,
		unlock_banners = "",
		desc = "A cute night light, with delicate rattan branches intertwined inside. Its gentle glow fills the room with a comforting warmth.",
		icon = "dorm3dIcon/3Ddrom_dafeng_CommonFurniture8",
		acesses = "",
		model = "Pay_Dafenghostel/pre_db_df_desklamp01",
		rarity = 2,
		id = 1215,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			1120104
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[1221] = {
		name = "Love Nest",
		is_special = 0,
		unlock_tips = "",
		type = 4,
		icon = "dorm3dIcon/3Ddrom_dafeng_PremiumFurniture1",
		room_id = 12,
		rarity = 4,
		desc = "A minimalist double bed made of durable materials. Its sturdy metal frame can withstand heavy strain, and when paired with a premium memory foam mattress, it ensures a deeply comfortable and secure rest.",
		model_night = "",
		acesses = "",
		model = "Pay_Dafenghostel/pre_db_df_bedroom_01",
		id = 1221,
		is_exclusive = 1,
		target_slots = {
			1120103
		},
		touch_id = {
			{
				30707,
				3070740
			}
		},
		shop_id = {
			270501
		},
		unlock_banners = {
			"banner_furniture1221"
		},
		scene_hides = {
			"no_bake_pay_prop/bedroom"
		}
	}
	pg.base.dorm3d_furniture_template[1222] = {
		name = "Floralized Rhythm",
		is_special = 1,
		icon = "dorm3dIcon/3Ddrom_dafeng_PremiumFurniture2",
		type = 99,
		rarity = 5,
		room_id = 12,
		model_night = "",
		desc = "Gentle light caresses the petals, and brings forth her silhouette. Music and flowers intermingle amidst the flowing whispers of nature.",
		acesses = "",
		model = "Pay_Dafenghostel/pre_db_df_tedian01",
		id = 1222,
		is_exclusive = 1,
		target_slots = {
			1120304
		},
		touch_id = {
			{
				30707,
				3070750
			}
		},
		shop_id = {
			270502
		},
		unlock_tips = {
			8
		},
		unlock_banners = {
			"banner_furniture1222"
		},
		scene_hides = {
			"no_bake_pay_prop/entertainment"
		}
	}
	pg.base.dorm3d_furniture_template[1223] = {
		name = "Elegant Cherry Blossom Seating",
		is_special = 0,
		icon = "dorm3dIcon/3Ddrom_dafeng_PremiumFurniture3",
		type = 5,
		rarity = 4,
		room_id = 12,
		model_night = "",
		desc = "A classic paper lantern lights up the crimson silk, while exquisite tea utensils catch the eye amidst the faint, rising fragrance of tea. Cushions styled like cherry blossoms flank the table, creating an elegant space for receiving guests.",
		acesses = "",
		model = "Pay_Dafenghostel/pre_db_df_livingroom_01",
		id = 1223,
		is_exclusive = 1,
		target_slots = {
			1120303
		},
		touch_id = {
			{
				30707,
				3070760
			}
		},
		shop_id = {
			270503
		},
		unlock_tips = {
			3
		},
		unlock_banners = {
			"banner_furniture1223"
		},
		scene_hides = {
			"no_bake_pay_prop/livingroom"
		}
	}
	pg.base.dorm3d_furniture_template[1401] = {
		name = "Velvet Bed",
		is_special = 0,
		unlock_tips = "",
		type = 4,
		unlock_banners = "",
		room_id = 14,
		icon = "dorm3dIcon/3Ddrom_aijier_CommonFurniture1",
		desc = "A double bed with a time-tested design, featuring a black headboard and red velvet bedding. Its soft mattress and pillows provide warmth and peace for a weary body and mind.",
		rarity = 3,
		acesses = "",
		model = "",
		model_night = "",
		id = 1401,
		is_exclusive = 0,
		scene_hides = "",
		target_slots = {
			1140101
		},
		touch_id = {
			{
				49905,
				4990510
			}
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[1402] = {
		name = "Ebony Desk",
		is_special = 0,
		unlock_tips = "",
		type = 6,
		unlock_banners = "",
		room_id = 14,
		icon = "dorm3dIcon/3Ddrom_aijier_CommonFurniture2",
		desc = "A black wooden desk accompanied by a simple red chair. This piece offers both practicality and traditional charm.",
		rarity = 3,
		acesses = "",
		model = "",
		model_night = "",
		id = 1402,
		is_exclusive = 0,
		scene_hides = "",
		target_slots = {
			1140201
		},
		touch_id = {
			{
				49905,
				4990520
			}
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[1403] = {
		name = "Leather Chair",
		is_special = 0,
		unlock_tips = "",
		type = 5,
		unlock_banners = "",
		room_id = 14,
		icon = "dorm3dIcon/3Ddrom_aijier_CommonFurniture3",
		desc = "A soft, comfortable leather chair. Paired with the round tea table, it's the ideal spot for solo relaxation.",
		rarity = 3,
		acesses = "",
		model = "",
		model_night = "",
		id = 1403,
		is_exclusive = 0,
		scene_hides = "",
		target_slots = {
			1140301
		},
		touch_id = {
			{
				49905,
				4990530
			}
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[1411] = {
		name = "Long Candles",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 14,
		unlock_banners = "",
		desc = "These ivory-white candles give warmth to a quiet, romantic night.",
		icon = "dorm3dIcon/3Ddrom_aijier_CommonFurniture4",
		acesses = "",
		model = "Pay_Aijierhostel/pre_db_aje_decoration01",
		rarity = 2,
		id = 1411,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			1140303
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[1412] = {
		name = "Large Plant",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 14,
		unlock_banners = "",
		desc = "This large potted plant does more than just add life to a room with its broad leaves – it helps purify the air, too!",
		icon = "dorm3dIcon/3Ddrom_aijier_CommonFurniture5",
		acesses = "",
		model = "Pay_Aijierhostel/pre_db_aje_bonsai01",
		rarity = 2,
		id = 1412,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			1140202
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[1413] = {
		name = "Elegant Desk Lamp",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 14,
		unlock_banners = "",
		desc = "A small desk lamp that casts a comfortable glow for reading or working at night.",
		icon = "dorm3dIcon/3Ddrom_aijier_CommonFurniture6",
		acesses = "",
		model = "Pay_Aijierhostel/pre_db_aje_desklamp01_on",
		rarity = 2,
		id = 1413,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			1140103
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[1414] = {
		name = "Vintage Camera",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 14,
		unlock_banners = "",
		desc = "This device retains the unique design of antique cameras. It's widely loved by enthusiasts and collectors.",
		icon = "dorm3dIcon/3Ddrom_aijier_CommonFurniture7",
		acesses = "",
		model = "Pay_Aijierhostel/pre_db_aje_camera01",
		rarity = 2,
		id = 1414,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			1140102
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[1415] = {
		name = "Portrait",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 14,
		unlock_banners = "",
		desc = "An abstract portrait painted with a classical touch; with its contrasting yet complementing chiaroscuro of bright and dark colors, it somehow perfectly matches the ambience of the room.",
		icon = "dorm3dIcon/3Ddrom_aijier_CommonFurniture8",
		acesses = "",
		model = "Pay_Aijierhostel/pre_db_aje_billboard01",
		rarity = 2,
		id = 1415,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			1140302
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[1461] = {
		name = "Crimson Tranquility",
		is_special = 0,
		icon = "dorm3dIcon/3Ddrom_aijier_PremiumFurniture1",
		type = 4,
		rarity = 4,
		room_id = 14,
		model_night = "",
		desc = "A secret space for privacy and romance. The red velvet bedding and pull-out curtains make it easy to enjoy tranquility and warmth at night.",
		acesses = "",
		model = "Pay_Aijierhostel/pre_db_aijier_bed01",
		id = 1461,
		is_exclusive = 1,
		target_slots = {
			1140101
		},
		touch_id = {
			{
				49905,
				4990540
			}
		},
		shop_id = {
			270601
		},
		unlock_tips = {
			3
		},
		unlock_banners = {
			"banner_furniture1461"
		},
		scene_hides = {
			"no_bake_pay_prop/bedroom"
		}
	}
	pg.base.dorm3d_furniture_template[1462] = {
		name = "Quiet Contemplation",
		is_special = 0,
		icon = "dorm3dIcon/3Ddrom_aijier_PremiumFurniture2",
		type = 6,
		rarity = 4,
		room_id = 14,
		model_night = "",
		desc = "A desk with a classic design and smooth surface. Its sturdy frame provides plenty of storage space, making it ideal for study and work.",
		acesses = "",
		model = "Pay_Aijierhostel/pre_db_aijier_study01",
		id = 1462,
		is_exclusive = 1,
		target_slots = {
			1140201
		},
		touch_id = {
			{
				49905,
				4990550
			}
		},
		shop_id = {
			270602
		},
		unlock_tips = {
			3
		},
		unlock_banners = {
			"banner_furniture1462"
		},
		scene_hides = {
			"no_bake_pay_prop/study"
		}
	}
	pg.base.dorm3d_furniture_template[1463] = {
		name = "Burgundy Leisure",
		is_special = 0,
		icon = "dorm3dIcon/3Ddrom_aijier_PremiumFurniture3",
		type = 5,
		rarity = 4,
		room_id = 14,
		model_night = "",
		desc = "This sofa, crafted from genuine leather, exudes a luxurious yet understated elegance. Paired with an exquisite coffee table, it truly embodies the passion for life and comfort.",
		acesses = "",
		model = "Pay_Aijierhostel/pre_db_aijier_living01",
		id = 1463,
		is_exclusive = 1,
		target_slots = {
			1140301
		},
		touch_id = {
			{
				49905,
				4990560
			}
		},
		shop_id = {
			270603
		},
		unlock_tips = {
			3
		},
		unlock_banners = {
			"banner_furniture1463"
		},
		scene_hides = {
			"no_bake_pay_prop/livingroom"
		}
	}
	pg.base.dorm3d_furniture_template[1468] = {
		name = "Melting Affections",
		is_special = 1,
		icon = "dorm3dIcon/3Ddrom_aijier_PremiumFurniture4",
		type = 99,
		rarity = 5,
		room_id = 14,
		model_night = "",
		desc = "Seduction, passion, and romance. Feel your emotions quicken beneath the surging waves.",
		acesses = "",
		model = "Pay_Aijierhostel/pre_db_aijier_special01",
		id = 1468,
		is_exclusive = 1,
		target_slots = {
			1140104
		},
		touch_id = {
			{
				49905,
				4990570
			}
		},
		shop_id = {
			270604
		},
		unlock_tips = {
			3
		},
		unlock_banners = {
			"banner_furniture1468"
		},
		scene_hides = {
			"no_bake_pay_prop/entertainment"
		}
	}
	pg.base.dorm3d_furniture_template[2101] = {
		name = "Cardboard Abode",
		is_special = 0,
		unlock_tips = "",
		type = 4,
		unlock_banners = "",
		room_id = 21,
		icon = "dorm3dIcon/3Ddrom_naximofu_CommonFurniture1",
		desc = "A bed made out of a cardboard box. It's light, portable, simple, and comfortable all at once. What better bed for a girl who likes to curl up at night?",
		rarity = 3,
		acesses = "",
		model = "",
		model_night = "",
		id = 2101,
		is_exclusive = 0,
		scene_hides = "",
		target_slots = {
			2210101
		},
		touch_id = {
			{
				79902,
				7990210
			}
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[2102] = {
		name = "Multipurpose Storage Rack",
		is_special = 0,
		unlock_tips = "",
		type = 6,
		unlock_banners = "",
		room_id = 21,
		icon = "dorm3dIcon/3Ddrom_naximofu_CommonFurniture2",
		desc = "The five-tier open shelf has books, tools, and other essentials sorted neatly within. Adorned with the traces of everyday life, it keeps all of one's needs readily within reach.",
		rarity = 3,
		acesses = "",
		model = "",
		model_night = "",
		id = 2102,
		is_exclusive = 0,
		scene_hides = "",
		target_slots = {
			2210201
		},
		touch_id = {
			{
				79902,
				7990220
			}
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[2103] = {
		name = "Sun-Warmed Spot",
		is_special = 0,
		unlock_tips = "",
		type = 5,
		unlock_banners = "",
		room_id = 21,
		icon = "dorm3dIcon/3Ddrom_naximofu_CommonFurniture3",
		desc = "A warm, white sofa decorated with the sunny, orange cushions. The matching low table and blanket make it a perfectly inviting place to relax.",
		rarity = 3,
		acesses = "",
		model = "",
		model_night = "",
		id = 2103,
		is_exclusive = 0,
		scene_hides = "",
		target_slots = {
			2210301
		},
		touch_id = {
			{
				79902,
				7990230
			}
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[2111] = {
		name = "Windowside Plant",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 21,
		unlock_banners = "",
		desc = "A potted plant by the window, with upright branches and unfurled leaves, breathing life and a touch of nature into the space.",
		icon = "dorm3dIcon/3Ddrom_naximofu_CommonFurniture4",
		acesses = "",
		model = "Pay_Naximofuhostel/pre_db_nxmf_flowerpot01",
		rarity = 2,
		id = 2111,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			2210303
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[2112] = {
		name = "Kitty Cushion",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 21,
		unlock_banners = "",
		desc = "A hefty, but soft cushion. No matter where it's placed, it becomes the perfect place of rest for any kitty.",
		icon = "dorm3dIcon/3Ddrom_naximofu_CommonFurniture5",
		acesses = "",
		model = "Pay_Naximofuhostel/pre_db_nxmf_cushion01",
		rarity = 2,
		id = 2112,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			2210304
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[2113] = {
		name = "Ball-and-Stick Model",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 21,
		unlock_banners = "",
		desc = "This science-themed art piece is inspired by atomic models and crystal structures. It serves as a collectible for lovers of physics and a unique desktop decoration.",
		icon = "dorm3dIcon/3Ddrom_naximofu_CommonFurniture6",
		acesses = "",
		model = "Pay_Naximofuhostel/pre_db_nxmf_decoration01",
		rarity = 2,
		id = 2113,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			2210302
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[2114] = {
		name = "Glazed Porcelain",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 21,
		unlock_banners = "",
		desc = "A plump, yellow porcelain item. It has a lustrous glaze and charming, plump shape... much like a donut.",
		icon = "dorm3dIcon/3Ddrom_naximofu_CommonFurniture7",
		acesses = "",
		model = "Pay_Naximofuhostel/pre_db_nxmf_ceram01",
		rarity = 2,
		id = 2114,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			2210103
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[2115] = {
		name = "Aroma Diffuser",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 21,
		unlock_banners = "",
		desc = "This ceramic vessel holds slender incense sticks. They carry a lovely fragrance throughout the room.",
		icon = "dorm3dIcon/3Ddrom_naximofu_CommonFurniture8",
		acesses = "",
		model = "Pay_Naximofuhostel/pre_db_nxmf_cosmetic01",
		rarity = 2,
		id = 2115,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			2210102
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[2161] = {
		name = "Revolving Data Inspector",
		is_special = 0,
		icon = "dorm3dIcon/3Ddrom_naximofu_PremiumFurniture1",
		type = 6,
		rarity = 4,
		room_id = 21,
		model_night = "",
		desc = "The circular scanner slowly rotates as data flows across the screen like stars in the sky. Who knows what scientific mysteries will be unveiled when the start button is pressed?",
		acesses = "",
		model = "Pay_Naximofuhostel/pre_db_naximofu_basement01",
		id = 2161,
		is_exclusive = 1,
		target_slots = {
			2210201
		},
		touch_id = {
			{
				79902,
				7990240
			}
		},
		shop_id = {
			270701
		},
		unlock_tips = {
			3
		},
		unlock_banners = {
			"banner_furniture2161"
		},
		scene_hides = {
			"no_bake_pay_prop/basement/pre_db_naximofu_basement01_0"
		}
	}
	pg.base.dorm3d_furniture_template[2201] = {
		name = "Cozy Bed",
		is_special = 0,
		unlock_tips = "",
		type = 4,
		unlock_banners = "",
		room_id = 22,
		icon = "dorm3dIcon/3Ddrom_yuanchou_CommonFurniture1",
		desc = "This spacious, comfortable bed is made all the more relaxing by its lack of bells and whistles. You'd love to lie there after a long day.",
		rarity = 3,
		acesses = "",
		model = "",
		model_night = "",
		id = 2201,
		is_exclusive = 0,
		scene_hides = "",
		target_slots = {
			2220101
		},
		touch_id = {
			{
				20707,
				2070710
			}
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[2202] = {
		name = "Contemplative Prayer Altar",
		is_special = 0,
		unlock_tips = "",
		type = 6,
		unlock_banners = "",
		room_id = 22,
		icon = "dorm3dIcon/3Ddrom_yuanchou_CommonFurniture2",
		desc = "A small space set up for prayer. It's quiet, orderly, and solemn, also serving as a place for solitary contemplation.",
		rarity = 3,
		acesses = "",
		model = "",
		model_night = "Pay_Yuanchouhostel/pre_db_yuanchou01_chamber01_0_night",
		id = 2202,
		is_exclusive = 0,
		scene_hides = "",
		target_slots = {
			2220201
		},
		touch_id = {
			{
				20707,
				2070720
			}
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[2203] = {
		name = "Afternoon Chat Sofa",
		is_special = 0,
		unlock_tips = "",
		type = 5,
		unlock_banners = "",
		room_id = 22,
		icon = "dorm3dIcon/3Ddrom_yuanchou_CommonFurniture3",
		desc = "Its understated design complements the soft ambiance, creating an ideal spot for relaxation. Whether you're unwinding alone or entertaining guests, it feels just right.",
		rarity = 3,
		acesses = "",
		model = "",
		model_night = "",
		id = 2203,
		is_exclusive = 0,
		scene_hides = "",
		target_slots = {
			2220301
		},
		touch_id = {
			{
				20707,
				2070730
			}
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[2211] = {
		name = "Golden Potted Plant",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 22,
		unlock_banners = "",
		desc = "An eye-catching potted plant effortlessly fills the empty space. Yet its presence is soft enough to complement a tranquil interior design.",
		icon = "dorm3dIcon/3Ddrom_yuanchou_CommonFurniture4",
		acesses = "",
		model = "Pay_Yuanchouhostel/pre_db_yc_flowerpot01",
		rarity = 2,
		id = 2211,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			2220102
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[2212] = {
		name = "Manjuu Keepsake",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 22,
		unlock_banners = "",
		desc = "Sturdy materials underscore the significance of this keepsake. Its innate qualities are clear to see, without any need for embellishment.",
		icon = "dorm3dIcon/3Ddrom_yuanchou_CommonFurniture5",
		acesses = "",
		model = "Pay_Yuanchouhostel/pre_db_yc_billboard02",
		rarity = 2,
		id = 2212,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			2220303
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[2213] = {
		name = "Foliage in Gold",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 22,
		unlock_banners = "",
		desc = "A small yet refined decoration. When placed in the corner, it manages to bring the whole room together.",
		icon = "dorm3dIcon/3Ddrom_yuanchou_CommonFurniture6",
		acesses = "",
		model = "Pay_Yuanchouhostel/pre_db_yc_flowerpot02",
		rarity = 2,
		id = 2213,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			2220103
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[2214] = {
		name = "Seascape",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 22,
		unlock_banners = "",
		desc = "A neatly framed photo of the sea opens up a vista on the wall. Just looking at it soothes the heart.",
		icon = "dorm3dIcon/3Ddrom_yuanchou_CommonFurniture7",
		acesses = "",
		model = "Pay_Yuanchouhostel/pre_db_yc_billboard01",
		rarity = 2,
		id = 2214,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			2220104
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[2215] = {
		name = "Glass Desk Lamp",
		is_special = 0,
		unlock_tips = "",
		type = 3,
		is_exclusive = 0,
		room_id = 22,
		unlock_banners = "",
		desc = "A lighting fixture with a translucent luster brightens the room with cool hues.",
		icon = "dorm3dIcon/3Ddrom_yuanchou_CommonFurniture8",
		acesses = "",
		model = "Pay_Yuanchouhostel/pre_db_yc_decoration02",
		rarity = 2,
		id = 2215,
		touch_id = "",
		scene_hides = "",
		model_night = "",
		target_slots = {
			2220302
		},
		shop_id = {}
	}
	pg.base.dorm3d_furniture_template[2261] = {
		name = "A Lifetime of Learning",
		is_special = 0,
		icon = "dorm3dIcon/3Ddrom_yuanchou_PremiumFurniture1",
		type = 6,
		rarity = 4,
		room_id = 22,
		model_night = "",
		desc = "A long table covered in various instruments and reading materials, displaying both the quiet focus of study and the genuine traces of everyday life.",
		acesses = "",
		model = "Pay_Yuanchouhostel/pre_db_yuanchou01_chamber02",
		id = 2261,
		is_exclusive = 1,
		target_slots = {
			2220202
		},
		touch_id = {
			{
				20707,
				2070740
			}
		},
		shop_id = {
			270801
		},
		unlock_tips = {
			3
		},
		unlock_banners = {
			"banner_furniture2261"
		},
		scene_hides = {
			"no_bake_pay_prop/chamber/pre_db_yuanchou01_chamber02_0",
			"no_bake_pay_prop/chamber/pre_db_yuanchou01_chamber02_0_night"
		}
	}
end)()
