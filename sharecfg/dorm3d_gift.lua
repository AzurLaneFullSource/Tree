pg = pg or {}
pg.dorm3d_gift = {
	[1021001] = {
		ship_group_id = 0,
		display = "A pink stuffed bunny with a scarf. It's made of soft materials that make you want to hug it all day.",
		rarity = 2,
		unlock_dialogue_id = 0,
		id = 1021001,
		icon = "dorm3dicon/3Ddrom_everyone_CommonGift3",
		name = "Bunny Plushie",
		favor_trigger_id = 1009,
		reply_dialogue_id = {
			{
				20220,
				1501
			},
			{
				30221,
				20301
			}
		},
		shop_id = {},
		unlock_tips = {},
		unlock_banners = {
			{
				20220,
				{
					"banner_test"
				}
			},
			{
				30221,
				{
					"banner_nengdaigift"
				}
			}
		}
	},
	[1021002] = {
		ship_group_id = 0,
		display = "This bouquet exudes a rich, captivating aroma. Both the roses and the other red flowers are practically dripping with emotion and romance.",
		rarity = 3,
		unlock_dialogue_id = 0,
		id = 1021002,
		icon = "dorm3dicon/3Ddrom_everyone_CommonGift2",
		name = "Romantic's Bouquet",
		favor_trigger_id = 1010,
		reply_dialogue_id = {
			{
				20220,
				1502
			},
			{
				30221,
				20302
			}
		},
		shop_id = {
			260101,
			260102,
			260103,
			260104,
			260105
		},
		unlock_tips = {},
		unlock_banners = {
			{
				20220,
				{
					"banner_test"
				}
			},
			{
				30221,
				{
					"banner_nengdaigift"
				}
			}
		}
	},
	[1021003] = {
		ship_group_id = 0,
		display = "A meticulously wrapped box containing slices of delicious cake. You can eat them yourself, or you can gift them and make someone's day.",
		rarity = 4,
		unlock_dialogue_id = 0,
		id = 1021003,
		icon = "dorm3dicon/3Ddrom_everyone_CommonGift1",
		name = "Cake Gift Box",
		favor_trigger_id = 1019,
		reply_dialogue_id = {
			{
				20220,
				1503
			},
			{
				30221,
				20303
			}
		},
		shop_id = {
			260201,
			260202
		},
		unlock_tips = {},
		unlock_banners = {
			{
				20220,
				{
					"banner_test"
				}
			},
			{
				30221,
				{
					"banner_nengdaigift"
				}
			}
		}
	},
	[2022001] = {
		ship_group_id = 20220,
		display = "A toolbox of must-have items for cleaning and tidying up both at home and at the workplace. It's built with durable and resilient materials to protect the tools inside from damage.",
		rarity = 4,
		unlock_dialogue_id = 10060,
		id = 2022001,
		icon = "dorm3dicon/3Ddrom_tianlangxing_FancyGift2",
		name = "Cleaning Supplies Toolbox",
		favor_trigger_id = 1004,
		reply_dialogue_id = {
			{
				20220,
				1504
			}
		},
		shop_id = {
			260301
		},
		unlock_tips = {
			4
		},
		unlock_banners = {
			{
				20220,
				{
					"banner_gift2022001"
				}
			}
		}
	},
	[2022002] = {
		ship_group_id = 20220,
		display = "A classy, elegant tea set from the Royal Islands.\nIts blue and white design feels both refreshing and relaxing, bringing grace to your teatime.",
		rarity = 4,
		unlock_dialogue_id = 10070,
		id = 2022002,
		icon = "dorm3dicon/3Ddrom_tianlangxing_FancyGift1",
		name = "Royal Tea Set",
		favor_trigger_id = 1004,
		reply_dialogue_id = {
			{
				20220,
				1505
			}
		},
		shop_id = {
			260302
		},
		unlock_tips = {
			4
		},
		unlock_banners = {
			{
				20220,
				{
					"banner_gift2022002"
				}
			}
		}
	},
	[3022101] = {
		ship_group_id = 30221,
		display = "A simple design with a simple color scheme. Easy and comfortable to wear. \nThey fit perfectly around the heel and welcome your feet every time you put them on.",
		rarity = 4,
		unlock_dialogue_id = 10060,
		id = 3022101,
		icon = "dorm3dicon/3Ddrom_nengdai_FancyGift1",
		name = "Sincere Loafers",
		favor_trigger_id = 1004,
		reply_dialogue_id = {
			{
				30221,
				20304
			}
		},
		shop_id = {
			260321
		},
		unlock_tips = {
			4
		},
		unlock_banners = {
			{
				30221,
				{
					"banner_gift3022101"
				}
			}
		}
	},
	get_id_list_by_ship_group_id = {
		[0] = {
			1021001,
			1021002,
			1021003
		},
		[20220] = {
			2022001,
			2022002
		},
		[30221] = {
			3022101
		}
	},
	all = {
		1021001,
		1021002,
		1021003,
		2022001,
		2022002,
		3022101
	}
}
