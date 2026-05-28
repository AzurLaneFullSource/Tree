pg = pg or {}
pg.activity_mall_story = rawget(pg, "activity_mall_story") or setmetatable({
	__name = "activity_mall_story"
}, confNEO)
pg.activity_mall_story.all = {
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
	201,
	202,
	203,
	204,
	205,
	206,
	207,
	208,
	301,
	302,
	303,
	304,
	305,
	306,
	401,
	402,
	403,
	404,
	405,
	406,
	407,
	408,
	409,
	410
}
pg.base = pg.base or {}
pg.base.activity_mall_story = {}

;(function()
	pg.base.activity_mall_story[101] = {
		lua = "",
		name = "Golden Coast",
		type = 1,
		id = 101,
		icon = "huangjinhaian",
		desc = "A natural beach resort with long beaches filled with abundant sunshine. The perfect place to enjoy the summer waves.",
		posion = {
			653,
			-269,
			0
		}
	}
	pg.base.activity_mall_story[102] = {
		lua = "",
		name = "Docks",
		type = 1,
		id = 102,
		icon = "gangkou",
		desc = "A vital hub for maritime traffic, where various ships come and go, and luxury goods gather",
		posion = {
			1019,
			168,
			0
		}
	}
	pg.base.activity_mall_story[103] = {
		lua = "",
		name = "Artificial Islands",
		type = 1,
		id = 103,
		icon = "rengongqundao",
		desc = "A seaside promenade designed to resemble a ship's anchor. It invokes the feeling of walking through the ebb and flow of the tide.",
		posion = {
			1005,
			-78,
			0
		}
	}
	pg.base.activity_mall_story[104] = {
		lua = "",
		name = "Dome Hotel",
		type = 1,
		id = 104,
		icon = "qiongdingjiudian",
		desc = "This luxurious hotel boasts a distinctive, eye-catching exterior. Its rooftop hotel is extremely popular with tourists.",
		posion = {
			-341,
			-20,
			0
		}
	}
	pg.base.activity_mall_story[105] = {
		lua = "",
		name = "Tower of Luxury",
		type = 1,
		id = 105,
		icon = "fujindasha",
		desc = "A landmark crafted in a most tasteful manner. A top-class commercial complex located in the heart of Luxury Bay.",
		posion = {
			-40,
			62,
			0
		}
	}
	pg.base.activity_mall_story[106] = {
		lua = "",
		name = "Banquet Hall",
		type = 1,
		id = 106,
		icon = "tianfangyanhuiting",
		desc = "A glamorous space perfect for large-scale events. It exudes an opulent, fantastical manner.",
		posion = {
			155,
			35,
			0
		}
	}
	pg.base.activity_mall_story[107] = {
		lua = "",
		name = "Sea Breeze Hotel",
		type = 1,
		id = 107,
		icon = "haifengjiudian",
		desc = "A hotel overlooking the seafront. The perfect starting point for your relaxation and adventures.",
		posion = {
			172,
			-331,
			0
		}
	}
	pg.base.activity_mall_story[108] = {
		lua = "",
		name = "Expo Hall",
		type = 1,
		id = 108,
		icon = "kejiguan",
		desc = "A science and technology expo hall that blurs the boundary between fantasy and reality. It offers wondrous experiences that transcend definitions of real versus virtual.",
		posion = {
			-252,
			-242,
			0
		}
	}
	pg.base.activity_mall_story[109] = {
		lua = "",
		name = "Amusement Park",
		type = 1,
		id = 109,
		icon = "youleyuan",
		desc = "A dreamland-themed amusement park filled with cheers and excitement. A place where you can immerse yourself in pure fun.",
		posion = {
			-546,
			-224,
			0
		}
	}
	pg.base.activity_mall_story[110] = {
		lua = "",
		name = "Spice Market",
		type = 1,
		id = 110,
		icon = "xiangliaoshichang",
		desc = "A spice market filled with rich aromas. A vibrant market offering spices from every corner of the world.",
		posion = {
			-700,
			476,
			0
		}
	}
	pg.base.activity_mall_story[111] = {
		lua = "",
		name = "Tourist District",
		type = 1,
		id = 111,
		icon = "fengqingjie",
		desc = "A bustling tourist district filled with stores. You can find everything from exquisite handicrafts to local delicacies.",
		posion = {
			-478,
			408,
			0
		}
	}
	pg.base.activity_mall_story[112] = {
		lua = "",
		name = "Aquarium",
		type = 1,
		id = 112,
		icon = "shuizuguan",
		desc = "A huge aquarium where you can observe a wide variety of sea life up-close.",
		posion = {
			-680,
			254,
			0
		}
	}
	pg.base.activity_mall_story[113] = {
		lua = "",
		name = "Shallow Sand Area",
		type = 1,
		id = 113,
		icon = "qiansha",
		desc = "A vast desert area, well-suited for desert tours and experiential camping trips.",
		posion = {
			140,
			531,
			0
		}
	}
	pg.base.activity_mall_story[114] = {
		lua = "",
		name = "Garden of Miracles",
		type = 1,
		id = 114,
		icon = "qijihuayuan",
		desc = "Symmetrical flowerbeds surrounding a central gazebo, creating a vibrant scenery filled the aroma of flowers.",
		posion = {
			-164,
			401,
			0
		}
	}
	pg.base.activity_mall_story[115] = {
		lua = "",
		name = "Artificial Lake",
		type = 1,
		id = 115,
		icon = "rengonghu",
		desc = "A secluded waterway nestled between the city and the desert. Its tranquil waters are a symbol of wealth, each inch of greenery representing the prosperity of Luxury Bay.",
		posion = {
			472,
			517,
			0
		}
	}
	pg.base.activity_mall_story[201] = {
		lua = "SHEHUAXIANGMENGFUJINWAN1",
		name = "Time to Wake Up, Commander",
		type = 2,
		id = 201,
		icon = "icon_1",
		desc = "Time to Wake Up, Commander ",
		posion = {
			327,
			198,
			0
		}
	}
	pg.base.activity_mall_story[202] = {
		lua = "SHEHUAXIANGMENGFUJINWAN19",
		name = "The Missing Jewel That Shows Itself",
		type = 2,
		id = 202,
		icon = "icon_1",
		desc = "The Missing Jewel That Shows Itself ",
		posion = {
			-341,
			-20,
			0
		}
	}
	pg.base.activity_mall_story[203] = {
		lua = "SHEHUAXIANGMENGFUJINWAN20",
		name = "Where the Seagulls Go",
		type = 2,
		id = 203,
		icon = "icon_1",
		desc = "Where the Seagulls Go ",
		posion = {
			1019,
			168,
			0
		}
	}
	pg.base.activity_mall_story[204] = {
		lua = "SHEHUAXIANGMENGFUJINWAN21",
		name = "Rooftop \"Pirates\"",
		type = 2,
		id = 204,
		icon = "icon_1",
		desc = "Rooftop \"Pirates\" ",
		posion = {
			172,
			-331,
			0
		}
	}
	pg.base.activity_mall_story[205] = {
		lua = "SHEHUAXIANGMENGFUJINWAN22",
		name = "Wish Upon the Lamp",
		type = 2,
		id = 205,
		icon = "icon_1",
		desc = "Wish Upon the Lamp ",
		posion = {
			-478,
			408,
			0
		}
	}
	pg.base.activity_mall_story[206] = {
		lua = "SHEHUAXIANGMENGFUJINWAN23",
		name = "Magical(?) Garden Banquet",
		type = 2,
		id = 206,
		icon = "icon_1",
		desc = "Magical(?) Garden Banquet ",
		posion = {
			140,
			531,
			0
		}
	}
	pg.base.activity_mall_story[207] = {
		lua = "SHEHUAXIANGMENGFUJINWAN24",
		name = "The Light of a Miracle",
		type = 2,
		id = 207,
		icon = "icon_1",
		desc = "The Light of a Miracle ",
		posion = {
			-164,
			401,
			0
		}
	}
	pg.base.activity_mall_story[208] = {
		lua = "SHEHUAXIANGMENGFUJINWAN2",
		name = "A Gift Dedicated to You",
		type = 2,
		id = 208,
		icon = "icon_1",
		desc = "A Gift Dedicated to You ",
		posion = {
			653,
			-269,
			0
		}
	}
	pg.base.activity_mall_story[301] = {
		lua = "SHEHUAXIANGMENGFUJINWAN13",
		name = "An Eventful Game of Tag",
		type = 3,
		id = 301,
		icon = "gangkou",
		desc = "",
		posion = {
			1019,
			168,
			0
		}
	}
	pg.base.activity_mall_story[302] = {
		lua = "SHEHUAXIANGMENGFUJINWAN14",
		name = "The Sand Sculpting Tournament Begins!",
		type = 3,
		id = 302,
		icon = "rengongqundao",
		desc = "",
		posion = {
			1005,
			-78,
			0
		}
	}
	pg.base.activity_mall_story[303] = {
		lua = "SHEHUAXIANGMENGFUJINWAN15",
		name = "Who Will You Pick?",
		type = 3,
		id = 303,
		icon = "youleyuan",
		desc = "",
		posion = {
			-546,
			-224,
			0
		}
	}
	pg.base.activity_mall_story[304] = {
		lua = "SHEHUAXIANGMENGFUJINWAN16",
		name = "Special Filming Plan",
		type = 3,
		id = 304,
		icon = "xiangliaoshichang",
		desc = "",
		posion = {
			-700,
			476,
			0
		}
	}
	pg.base.activity_mall_story[305] = {
		lua = "SHEHUAXIANGMENGFUJINWAN17",
		name = "Shrouded in Steam",
		type = 3,
		id = 305,
		icon = "fengqingjie",
		desc = "",
		posion = {
			-478,
			408,
			0
		}
	}
	pg.base.activity_mall_story[306] = {
		lua = "SHEHUAXIANGMENGFUJINWAN18",
		name = "Cross Country Race",
		type = 3,
		id = 306,
		icon = "qiansha",
		desc = "",
		posion = {
			140,
			531,
			0
		}
	}
	pg.base.activity_mall_story[401] = {
		lua = "SHEHUAXIANGMENGFUJINWAN3",
		name = "Shimmering Splashes Above the Clouds",
		type = 4,
		id = 401,
		icon = "yanusi",
		desc = "1",
		posion = {
			960,
			540,
			0
		}
	}
	pg.base.activity_mall_story[402] = {
		lua = "SHEHUAXIANGMENGFUJINWAN4",
		name = "Mingling Heartbeats",
		type = 4,
		id = 402,
		icon = "mojiaduoer",
		desc = "2",
		posion = {
			960,
			540,
			0
		}
	}
	pg.base.activity_mall_story[403] = {
		lua = "SHEHUAXIANGMENGFUJINWAN5",
		name = "Honeyed Afterglow",
		type = 4,
		id = 403,
		icon = "luyijiushi",
		desc = "3",
		posion = {
			960,
			540,
			0
		}
	}
	pg.base.activity_mall_story[404] = {
		lua = "SHEHUAXIANGMENGFUJINWAN6",
		name = "Hearts Behind the Water Curtain",
		type = 4,
		id = 404,
		icon = "u2501",
		desc = "4",
		posion = {
			960,
			540,
			0
		}
	}
	pg.base.activity_mall_story[405] = {
		lua = "SHEHUAXIANGMENGFUJINWAN7",
		name = "Waterside Canzone",
		type = 4,
		id = 405,
		icon = "aimudeng",
		desc = "5",
		posion = {
			960,
			540,
			0
		}
	}
	pg.base.activity_mall_story[406] = {
		lua = "SHEHUAXIANGMENGFUJINWAN8",
		name = "Rapture Beneath the Blood Moon",
		type = 4,
		id = 406,
		icon = "gezi",
		desc = "6",
		posion = {
			960,
			540,
			0
		}
	}
	pg.base.activity_mall_story[407] = {
		lua = "SHEHUAXIANGMENGFUJINWAN9",
		name = "The Mermaid of the Emerald Sea",
		type = 4,
		id = 407,
		icon = "tianchengcv",
		desc = "7",
		posion = {
			960,
			540,
			0
		}
	}
	pg.base.activity_mall_story[408] = {
		lua = "SHEHUAXIANGMENGFUJINWAN10",
		name = "The Genie's Game",
		type = 4,
		id = 408,
		icon = "moliciqinwang",
		desc = "8",
		posion = {
			960,
			540,
			0
		}
	}
	pg.base.activity_mall_story[409] = {
		lua = "SHEHUAXIANGMENGFUJINWAN11",
		name = "Night Rendezvous With the Unhulde",
		type = 4,
		id = 409,
		icon = "aogusite",
		desc = "9",
		posion = {
			960,
			540,
			0
		}
	}
	pg.base.activity_mall_story[410] = {
		lua = "SHEHUAXIANGMENGFUJINWAN12",
		name = "Dancing Diver",
		type = 4,
		id = 410,
		icon = "z15",
		desc = "10",
		posion = {
			960,
			540,
			0
		}
	}
end)()
