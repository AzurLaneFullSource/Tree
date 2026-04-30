pg = pg or {}
pg.island_skin_template = rawget(pg, "island_skin_template") or setmetatable({
	__name = "island_skin_template"
}, confNEO)
pg.island_skin_template.all = {
	1011001,
	1020501,
	1051701,
	1070301,
	2060301,
	2990301,
	3031201,
	3040701,
	3120101,
	4030301,
	4990201,
	5060101,
	99000201,
	99000202,
	99000101,
	99000102,
	99000301,
	99000302
}
pg.island_skin_template.get_id_list_by_ship_group = {
	[10110] = {
		1011001
	},
	[10205] = {
		1020501
	},
	[10517] = {
		1051701
	},
	[10703] = {
		1070301
	},
	[20603] = {
		2060301
	},
	[29903] = {
		2990301
	},
	[30312] = {
		3031201
	},
	[30407] = {
		3040701
	},
	[31201] = {
		3120101
	},
	[40303] = {
		4030301
	},
	[49902] = {
		4990201
	},
	[50601] = {
		5060101
	},
	[990001] = {
		99000101,
		99000102
	},
	[990002] = {
		99000201,
		99000202
	},
	[990003] = {
		99000301,
		99000302
	}
}
pg.base = pg.base or {}
pg.base.island_skin_template = {}

;(function()
	pg.base.island_skin_template[1011001] = {
		ship_group = 10110,
		name = "Limitless Energy!",
		desc = "It may be a simple cleaning job, but I'll still give it 200% of my energy!",
		model = 1011001,
		shop_id = 0,
		tech_id = 0,
		shop_goods_id = 0,
		jump_page = "",
		id = 1011001,
		icon = "skin_1011001",
		icon_normal = ""
	}
	pg.base.island_skin_template[1020501] = {
		ship_group = 10205,
		name = "Azure Heart",
		desc = "A deeply clear blue that radiates gentle grace. There's an oceanic depth concealed in her service-oriented attitude and quiet smile.",
		model = 1020501,
		shop_id = 0,
		tech_id = 0,
		shop_goods_id = 0,
		jump_page = "",
		id = 1020501,
		icon = "skin_1020501",
		icon_normal = ""
	}
	pg.base.island_skin_template[1051701] = {
		ship_group = 10517,
		name = "Daily Steps",
		desc = "A fresh, practical ensemble perfect for everyday life. One look at her and you can tell – she's ready to have a great day out with you.",
		shop_id = 0,
		tech_id = 0,
		shop_goods_id = 0,
		model = 1051701,
		id = 1051701,
		icon = "skin_1051701",
		icon_normal = "props/skin_1051701",
		jump_page = {}
	}
	pg.base.island_skin_template[1070301] = {
		ship_group = 10703,
		name = "Canvas Day",
		desc = "Cute and energetic. She carries behind her a backpack full of sweet little secrets, sealing them away with an innocent giggle upon the wind.",
		shop_id = 0,
		tech_id = 0,
		shop_goods_id = 0,
		model = 1070301,
		id = 1070301,
		icon = "skin_1070301",
		icon_normal = "props/skin_1070301",
		jump_page = {}
	}
	pg.base.island_skin_template[2060301] = {
		ship_group = 20603,
		name = "Dreamy Starlight",
		desc = "Like a pure, bright star plucked from the night sky, every little detail glimmers with the light of hope.",
		shop_id = 0,
		tech_id = 0,
		shop_goods_id = 0,
		model = 2060301,
		id = 2060301,
		icon = "skin_2060301",
		icon_normal = "props/skin_2060301",
		jump_page = {}
	}
	pg.base.island_skin_template[2990301] = {
		ship_group = 29903,
		name = "Seaspray Leisure",
		desc = "She carries with her the sweet aroma and the electrifying freshness of the sea breeze. Whose heart has she stricken with her cuteness today?",
		shop_id = 0,
		tech_id = 0,
		shop_goods_id = 0,
		model = 2990301,
		id = 2990301,
		icon = "skin_2990301",
		icon_normal = "props/skin_2990301",
		jump_page = {}
	}
	pg.base.island_skin_template[3031201] = {
		ship_group = 30312,
		name = "Lovingly Sweet Tea Time",
		desc = "Tea isn't the only thing I'm serving you – there's also my sweet care and the courtesy hidden in my smile.",
		model = 3031201,
		shop_id = 0,
		tech_id = 0,
		shop_goods_id = 0,
		jump_page = "",
		id = 3031201,
		icon = "skin_3031201",
		icon_normal = ""
	}
	pg.base.island_skin_template[3040701] = {
		ship_group = 30407,
		name = "Fledgling's Fairytale",
		desc = "A golden-yellow fledgling basking beneath the soft sunlight. It warbles a fairytale melody of sweet candy and seashells.",
		shop_id = 0,
		tech_id = 0,
		shop_goods_id = 0,
		model = 3040701,
		id = 3040701,
		icon = "skin_3040701",
		icon_normal = "props/skin_3040701",
		jump_page = {}
	}
	pg.base.island_skin_template[3120101] = {
		ship_group = 31201,
		name = "Night of the Empty Bell",
		desc = "Beneath the neatly tucked collar of her sailor uniform is a sly, mischievous smile, her black skirt fluttering like the playful waves at night. Beware, for this \"mysterious merchant\" has opened up shop at school.",
		shop_id = 0,
		tech_id = 0,
		shop_goods_id = 0,
		model = 3120101,
		id = 3120101,
		icon = "skin_3120101",
		icon_normal = "props/skin_3120101",
		jump_page = {}
	}
	pg.base.island_skin_template[4030301] = {
		ship_group = 40303,
		name = "Lazy Service",
		desc = "She calls it \"special hospitality\" with a touch of playful elegance. What heart-throbbing amusement is she planning?",
		model = 4030301,
		shop_id = 0,
		tech_id = 0,
		shop_goods_id = 0,
		jump_page = "",
		id = 4030301,
		icon = "skin_4030301",
		icon_normal = ""
	}
	pg.base.island_skin_template[4990201] = {
		ship_group = 49902,
		name = "Elegant Affection",
		desc = "Majesty and grace join in perfect unison, fulfilling the supreme contract known as service with an elegant demeanor.",
		model = 4990201,
		shop_id = 0,
		tech_id = 0,
		shop_goods_id = 0,
		jump_page = "",
		id = 4990201,
		icon = "skin_4990201",
		icon_normal = ""
	}
	pg.base.island_skin_template[5060101] = {
		ship_group = 50601,
		name = "Planning Comes Later",
		desc = "Step away from the chessboard for a moment and pick up the teapot. As the steam rises around you both, she delivers a warm kind of wisdom that sees through the human heart.",
		model = 5060101,
		shop_id = 0,
		tech_id = 0,
		shop_goods_id = 0,
		jump_page = "",
		id = 5060101,
		icon = "skin_5060101",
		icon_normal = ""
	}
	pg.base.island_skin_template[99000201] = {
		ship_group = 990002,
		name = "Time of Innocence",
		desc = "Pure and straightforward, she explores her surroundings with uncertainty, feeling everything with her hands.",
		model = 99000201,
		shop_id = 0,
		tech_id = 0,
		shop_goods_id = 0,
		jump_page = "",
		id = 99000201,
		icon = "skin_99000201",
		icon_normal = ""
	}
	pg.base.island_skin_template[99000202] = {
		ship_group = 990002,
		name = "Inexperienced Observer",
		desc = "A neat and tidy dress. Her focused gaze quietly observes the world.",
		model = 99000202,
		shop_id = 0,
		tech_id = 0,
		shop_goods_id = 0,
		jump_page = "",
		id = 99000202,
		icon = "skin_99000202",
		icon_normal = ""
	}
	pg.base.island_skin_template[99000101] = {
		ship_group = 990001,
		name = "Cheerful Route to School",
		desc = "Fully geared up and ready to go! Let's see what kind of pranks she'll pull on her way to school today!",
		model = 99000101,
		shop_id = 0,
		tech_id = 0,
		shop_goods_id = 0,
		jump_page = "",
		id = 99000101,
		icon = "skin_99000101",
		icon_normal = ""
	}
	pg.base.island_skin_template[99000102] = {
		ship_group = 990001,
		name = "Honor Student's Demeanor",
		desc = "Her school uniform is a perfect fit. Even when dressed as an honor student, she can't hide the little devil on her shoulder.",
		model = 99000102,
		shop_id = 0,
		tech_id = 0,
		shop_goods_id = 0,
		jump_page = "",
		id = 99000102,
		icon = "skin_99000102",
		icon_normal = ""
	}
	pg.base.island_skin_template[99000301] = {
		ship_group = 990003,
		name = "Pure White Whisper",
		desc = "This singularly white outfit is wholly untarnished. It's almost like an extension of her quiet personality.",
		model = 99000301,
		shop_id = 0,
		tech_id = 0,
		shop_goods_id = 0,
		jump_page = "",
		id = 99000301,
		icon = "skin_99000301",
		icon_normal = ""
	}
	pg.base.island_skin_template[99000302] = {
		ship_group = 990003,
		name = "Serene Dress",
		desc = "A formal outfit complemented by a jumper skirt. It glows with shy, adorable charm.",
		model = 99000302,
		shop_id = 0,
		tech_id = 0,
		shop_goods_id = 0,
		jump_page = "",
		id = 99000302,
		icon = "skin_99000302",
		icon_normal = ""
	}
end)()
