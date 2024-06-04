local var0 = class("GridGameReView", import("..BaseMiniGameView"))
local var1 = false
local var2 = "battle-boss-4"
local var3 = "event:/ui/ddldaoshu2"
local var4 = "event:/ui/niujiao"
local var5 = "event:/ui/taosheng"
local var6 = "ui/minigameui/gridgameui_atlas"
local var7 = 60
local var8 = "mini_game_time"
local var9 = "mini_game_score"
local var10 = "mini_game_leave"
local var11 = "mini_game_pause"
local var12 = "mini_game_cur_score"
local var13 = "mini_game_high_score"
local var14 = "event grid combo"
local var15 = "event grid trigger"
local var16 = "event move role"
local var17 = "event add score"
local var18 = "event role special"
local var19 = "event special end"
local var20 = "event camera in"
local var21 = "event camedra out"
local var22 = "event ignore time"
local var23 = {
	power_grid = 0,
	grid_index = 0,
	special_time = false,
	special_complete = false
}
local var24 = 12
local var25 = 0.3
local var26 = Vector2(138, 150)
local var27 = 2500
local var28 = 0
local var29 = 100
local var30 = 1
local var31 = 2
local var32 = 3
local var33 = {
	{
		id = 1,
		name = "red",
		index = 1
	},
	{
		id = 2,
		name = "yellow",
		index = 2
	},
	{
		id = 3,
		name = "blue",
		index = 3
	},
	[999] = {
		id = 999,
		name = "color",
		index = 999
	}
}
local var34 = {
	1,
	2,
	3
}
local var35 = {
	{
		rule = var30
	},
	{
		id = 999,
		rule = var31
	},
	{
		rule = var32
	}
}
local var36 = {
	{
		index = 1,
		name = "red",
		max = 1000
	},
	{
		index = 2,
		name = "yellow",
		max = 1000
	},
	{
		index = 3,
		name = "blue",
		max = 1000
	}
}
local var37 = 0.5
local var38 = 50
local var39 = 3
local var40 = 150
local var41 = 1.5
local var42 = 500
local var43 = 260
local var44 = 50
local var45 = 3400
local var46 = 5
local var47 = 4
local var48 = {
	1,
	2,
	3,
	4,
	5
}
local var49 = {
	{
		1,
		5
	}
}
local var50 = {
	1,
	2,
	5
}
local var51 = {
	1,
	2,
	5,
	3,
	4
}
local var52 = {
	{
		5,
		4
	},
	{
		2,
		4
	},
	{
		5,
		3
	},
	{
		1,
		3
	},
	{
		1,
		4
	},
	{
		2,
		3
	},
	{
		5,
		4
	}
}
local var53 = {
	2,
	1,
	1,
	2,
	2,
	1,
	2
}
local var54 = {}
local var55 = 7
local var56 = Vector2(0, 0)
local var57 = 0.07
local var58 = 0.3
local var59 = 0.5
local var60 = 5
local var61 = "sound start"
local var62 = "sound trigger"
local var63 = "sound end"
local var64 = {
	"bg00",
	"bg01",
	"bg02",
	"bg03",
	"bg04",
	"bg10",
	"bg11",
	"bg12",
	"bg13",
	"bg14"
}
local var65 = {
	"bg00",
	"bg01",
	"bg02",
	"bg03",
	"bg04"
}
local var66 = {
	"bg10",
	"bg11",
	"bg12",
	"bg13",
	"bg14"
}
local var67 = 0
local var68 = 1
local var69 = 2
local var70 = var68
local var71 = {
	{
		rate = 0.05,
		source = "scene_background/bg00",
		type = var68
	},
	{
		rate = 0.1,
		source = "scene_background/bg01",
		type = var68
	},
	{
		rate = 0.2,
		source = "scene_background/bg02",
		type = var68
	},
	{
		rate = 0.8,
		source = "scene_background/bg03",
		type = var68
	},
	{
		rate = 0.05,
		source = "scene_background/bg10",
		type = var69
	},
	{
		rate = 0.1,
		source = "scene_background/bg11",
		type = var69
	},
	{
		rate = 0.2,
		source = "scene_background/bg12",
		type = var69
	},
	{
		rate = 0.8,
		source = "scene_background/bg13",
		type = var69
	},
	{
		rate = 1.2,
		source = "scene_front/bg04",
		type = var68
	},
	{
		rate = 1.2,
		source = "scene_front/bg14",
		type = var69
	},
	{
		rate = 1,
		source = "scene/rolePos",
		type = var67
	}
}
local var72 = {
	c_Skill_1 = "c_Skill_1",
	n_Neutral = "n_Neutral",
	n_Combine = "n_Combine",
	n_Skill_2 = "n_Skill_2",
	n_MoveL = "n_MoveL",
	n_Atk = "n_Atk",
	c_Neutral = "c_Neutral",
	n_MoveR = "n_MoveR",
	c_Atk = "c_Atk",
	n_Skill_1 = "n_Skill_1",
	c_MoveL = "c_MoveL",
	c_Dmg = "c_Dmg",
	n_Skill_3 = "n_Skill_3",
	n_DMG = "n_DMG",
	c_MoveR = "c_MoveR"
}
local var73 = {
	n_Move_R = {
		time = 0,
		anim_name = var72.n_MoveR,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(650, 0, 0)
		}
	},
	n_Atk = {
		time = 0,
		sound_trigger = "taosheng",
		anim_name = var72.n_Atk,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(650, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	n_Move_L = {
		time = 0,
		anim_name = var72.n_MoveL,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0)
		}
	},
	n_Skill_1 = {
		time = 0,
		sound_trigger = "jiguang",
		anim_name = var72.n_Skill_1
	},
	n_Skill_2 = {
		time = 0,
		sound_trigger = "guangjian",
		anim_name = var72.n_Skill_2,
		over_offset = Vector3(0, 0),
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(300, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	n_Skill_3 = {
		time = 0,
		sound_trigger = "baozha1",
		anim_name = var72.n_Skill_3
	},
	n_Combine = {
		sound_start = "bianshen",
		time = 0,
		camera = true,
		anim_name = var72.n_Combine
	},
	n_DMG = {
		time = 0,
		anim_name = var72.n_DMG,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance_m = Vector3(-150, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	n_DMG_S = {
		time = 0,
		anim_name = var72.n_DMG
	},
	n_DMG_Back_R = {
		time = 0,
		anim_name = var72.n_MoveR,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0)
		}
	},
	n_Neutral = {
		time = 0,
		anim_name = var72.n_Neutral
	},
	c_Atk = {
		time = 0,
		sound_trigger = "taosheng",
		anim_name = var72.c_Atk,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(500, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	c_Skill_1 = {
		sound_trigger = "baozha2",
		time = 0,
		camera = true,
		anim_name = var72.c_Skill_1
	},
	c_Dmg = {
		time = 0,
		anim_name = var72.c_Dmg,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance_m = Vector3(-150, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	c_Dmg_S = {
		time = 0,
		anim_name = var72.c_Dmg
	},
	c_MoveL = {
		time = 0,
		anim_name = var72.c_MoveL,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0)
		}
	},
	c_MoveR = {
		time = 0,
		anim_name = var72.c_MoveR,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(650, 0, 0)
		}
	},
	c_DMG_Back_R = {
		time = 0,
		anim_name = var72.c_MoveR,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0)
		}
	},
	c_Neutral = {
		time = 0,
		anim_name = var72.c_Neutral
	}
}
local var74 = {
	{
		special_time = false,
		name = "normalAtk",
		power_index = 0,
		atk_index = 1,
		score = {
			100,
			100
		},
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var73.n_Atk,
			var73.n_Move_L
		}
	},
	{
		special_time = false,
		name = "skill1",
		power_index = 1,
		atk_index = 2,
		score = {
			500,
			500
		},
		grid_index = {
			1
		},
		actions = {
			var73.n_Skill_1
		}
	},
	{
		special_time = false,
		name = "skill2",
		power_index = 2,
		atk_index = 2,
		score = {
			500,
			500
		},
		grid_index = {
			2
		},
		actions = {
			var73.n_Skill_2,
			var73.n_Move_L
		}
	},
	{
		special_time = false,
		name = "skill3",
		power_index = 3,
		atk_index = 2,
		score = {
			500,
			500
		},
		grid_index = {
			3
		},
		actions = {
			var73.n_Skill_3
		}
	},
	{
		dmg_index = 2,
		name = "DMG",
		power_index = 0,
		special_time = false,
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var73.n_DMG,
			var73.n_DMG_Back_R
		}
	},
	{
		dmg_index = 1,
		name = "DMGS",
		power_index = 0,
		special_time = false,
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var73.n_DMG_S
		}
	},
	{
		special_end = true,
		name = "special_end",
		power_index = 0,
		special_time = false,
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var73.n_DMG_Back_R
		}
	},
	{
		dmg_index = 3,
		name = "DMGN",
		special_time = false,
		actions = {
			var73.n_DMG
		}
	},
	{
		name = "DMG_BACK",
		special_time = false,
		dmg_back = true,
		actions = {
			var73.n_DMG_Back_R
		}
	},
	{
		power_index = 0,
		name = "Combine",
		special_trigger = true,
		anim_bool = "special",
		special_time = true,
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var73.n_Combine
		}
	},
	{
		special_time = true,
		name = "AtkS",
		power_index = 0,
		atk_index = 1,
		score = {
			300,
			300
		},
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var73.c_Atk,
			var73.c_MoveL
		}
	},
	{
		special_time = true,
		name = "Skill1S",
		power_index = 1,
		atk_index = 2,
		score = {
			1000,
			1000
		},
		grid_index = {
			1
		},
		actions = {
			var73.c_Skill_1
		}
	},
	{
		special_time = true,
		name = "Skill1S",
		power_index = 2,
		atk_index = 2,
		score = {
			1000,
			1000
		},
		grid_index = {
			2
		},
		actions = {
			var73.c_Skill_1
		}
	},
	{
		special_time = true,
		name = "Skill1S",
		power_index = 3,
		atk_index = 2,
		score = {
			1000,
			1000
		},
		grid_index = {
			3
		},
		actions = {
			var73.c_Skill_1
		}
	},
	{
		dmg_index = 2,
		name = "cDmg",
		power_index = 0,
		special_time = true,
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var73.c_Dmg,
			var73.c_DMG_Back_R
		}
	},
	{
		dmg_index = 1,
		name = "cDmgS",
		power_index = 0,
		special_time = true,
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var73.c_Dmg_S
		}
	},
	{
		dmg_index = 3,
		name = "DMGN",
		special_time = false,
		actions = {
			var73.c_DMG
		}
	},
	{
		name = "DMG_BACK",
		special_time = false,
		dmg_back = true,
		actions = {
			var73.c_DMG_Back_R
		}
	}
}
local var75 = {
	c_Skill_1 = "c_Skill_1",
	n_Neutral = "n_Neutral",
	n_Combine = "n_Combine",
	n_Skill_2 = "n_Skill_2",
	n_MoveL = "n_MoveL",
	n_Atk = "n_Atk",
	c_Neutral = "c_Neutral",
	n_MoveR = "n_MoveR",
	c_Atk = "c_ATK",
	n_Skill_1 = "n_Skill_1",
	c_MoveL = "c_MoveL",
	c_Dmg = "c_DMG",
	n_Skill_3 = "n_Skill_3",
	n_DMG = "n_DMG",
	c_MoveR = "c_MoveR"
}
local var76 = {
	n_Move_R = {
		time = 0,
		anim_name = var75.n_MoveR,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(500, 0, 0)
		}
	},
	n_Atk = {
		time = 0,
		sound_trigger = "taosheng",
		anim_name = var75.n_Atk,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(600, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	n_Move_L = {
		time = 0,
		anim_name = var75.n_MoveL,
		move = {
			time = 0.4,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	n_Skill_1 = {
		time = 0,
		sound_trigger = "baozha1",
		anim_name = var75.n_Skill_1,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(600, 0, 0)
		}
	},
	n_Skill_2 = {
		time = 0,
		sound_trigger = "baozha2",
		anim_name = var75.n_Skill_2
	},
	n_Skill_3 = {
		time = 0,
		sound_trigger = "baozha2",
		anim_name = var75.n_Skill_3,
		over_offset = Vector3(247, 2),
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(350, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	n_Combine = {
		sound_start = "bianshen",
		time = 0,
		camera = true,
		anim_name = var75.n_Combine
	},
	n_DMG = {
		time = 0,
		anim_name = var75.n_DMG,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance_m = Vector3(-150, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	n_DMG_S = {
		time = 0,
		anim_name = var75.n_DMG
	},
	n_DMG_Back_R = {
		time = 0,
		anim_name = var75.n_MoveR,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0)
		}
	},
	n_Neutral = {
		time = 0,
		anim_name = var75.n_Neutral
	},
	c_Atk = {
		time = 0,
		sound_trigger = "taosheng",
		anim_name = var75.c_Atk,
		move = {
			time = 0.4,
			start = Vector2(0, 0),
			distance = Vector3(600, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	c_Skill_1 = {
		sound_trigger = "baozha2",
		time = 0,
		camera = true,
		anim_name = var75.c_Skill_1
	},
	c_Dmg = {
		time = 0,
		anim_name = var75.c_Dmg,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance_m = Vector3(-150, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	c_Dmg_S = {
		time = 0,
		anim_name = var75.c_Dmg
	},
	c_MoveL = {
		time = 0,
		anim_name = var75.c_MoveL,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	c_MoveR = {
		time = 0,
		anim_name = var75.c_MoveR,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(650, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	c_DMG_Back_R = {
		time = 0,
		anim_name = var75.c_MoveR,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	c_Neutral = {
		time = 0,
		anim_name = var75.c_Neutral
	}
}
local var77 = {
	{
		special_time = false,
		name = "normalAtk",
		power_index = 0,
		atk_index = 1,
		score = {
			100,
			100
		},
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var76.n_Atk,
			var76.n_Move_L
		}
	},
	{
		special_time = false,
		name = "skill1",
		power_index = 1,
		atk_index = 2,
		score = {
			500,
			500
		},
		grid_index = {
			1
		},
		actions = {
			var76.n_Move_R,
			var76.n_Skill_1,
			var76.n_Move_L
		}
	},
	{
		special_time = false,
		name = "skill2",
		power_index = 2,
		atk_index = 2,
		score = {
			500,
			500
		},
		grid_index = {
			2
		},
		actions = {
			var76.n_Skill_2
		}
	},
	{
		special_time = false,
		name = "skill3",
		power_index = 3,
		atk_index = 2,
		score = {
			500,
			500
		},
		grid_index = {
			3
		},
		actions = {
			var76.n_Skill_3,
			var76.n_Move_L
		}
	},
	{
		dmg_index = 2,
		name = "n_DMG",
		power_index = 0,
		special_time = false,
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var76.n_DMG,
			var76.n_DMG_Back_R
		}
	},
	{
		dmg_index = 1,
		name = "n_DMGS",
		power_index = 0,
		special_time = false,
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var76.n_DMG_S
		}
	},
	{
		special_end = true,
		name = "special_end",
		power_index = 0,
		special_time = false,
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var76.n_DMG_Back_R
		}
	},
	{
		dmg_index = 3,
		name = "DMGN",
		special_time = false,
		actions = {
			var76.n_DMG
		}
	},
	{
		name = "DMG_BACK",
		special_time = false,
		dmg_back = true,
		actions = {
			var76.n_DMG_Back_R
		}
	},
	{
		power_index = 0,
		name = "Combine",
		special_trigger = true,
		anim_bool = "special",
		special_time = true,
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var76.n_Combine
		}
	},
	{
		special_time = true,
		name = "AtkS",
		power_index = 0,
		atk_index = 1,
		score = {
			200,
			200
		},
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var76.c_Atk,
			var76.c_MoveL
		}
	},
	{
		special_time = true,
		name = "Skill1S",
		power_index = 1,
		atk_index = 2,
		score = {
			1000,
			1000
		},
		grid_index = {
			1
		},
		actions = {
			var76.c_Skill_1
		}
	},
	{
		special_time = true,
		name = "Skill1S",
		power_index = 2,
		atk_index = 2,
		score = {
			1000,
			1000
		},
		grid_index = {
			2
		},
		actions = {
			var76.c_Skill_1
		}
	},
	{
		special_time = true,
		name = "Skill1S",
		power_index = 3,
		atk_index = 2,
		score = {
			1000,
			1000
		},
		grid_index = {
			3
		},
		actions = {
			var76.c_Skill_1
		}
	},
	{
		dmg_index = 2,
		name = "c_Dmg",
		power_index = 0,
		special_time = true,
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var76.c_Dmg,
			var76.c_DMG_Back_R
		}
	},
	{
		dmg_index = 1,
		name = "c_DmgS",
		power_index = 0,
		special_time = true,
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var76.c_Dmg_S
		}
	},
	{
		dmg_index = 3,
		name = "DMGN",
		special_time = false,
		actions = {
			var76.c_DMG
		}
	},
	{
		name = "DMG_BACK",
		special_time = false,
		dmg_back = true,
		actions = {
			var76.c_DMG_Back_R
		}
	}
}
local var78 = {
	c_Skill_1 = "c_Skill_1",
	n_Neutral = "n_Neutral",
	n_Combine = "n_Combine",
	n_Skill_2 = "n_Skill_2",
	n_MoveL = "n_MoveL",
	n_Atk = "n_Atk",
	c_Neutral = "c_Neutral",
	n_MoveR = "n_MoveR",
	c_Atk = "c_Atk",
	n_Skill_1 = "n_Skill_1",
	c_MoveL = "c_MoveL",
	c_Dmg = "c_Dmg",
	n_Skill_3 = "n_Skill_3",
	n_DMG = "n_DMG",
	c_MoveR = "c_MoveR"
}
local var79 = {
	n_Move_R = {
		time = 0,
		anim_name = var78.n_MoveR,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(650, 0, 0)
		}
	},
	n_Atk = {
		time = 0,
		sound_trigger = "taosheng",
		anim_name = var78.n_Atk,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(650, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	n_Move_L = {
		time = 0,
		anim_name = var78.n_MoveL,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0)
		}
	},
	n_Skill_1 = {
		time = 0,
		sound_trigger = "jiguang",
		anim_name = var78.n_Skill_1
	},
	n_Skill_2 = {
		time = 0,
		sound_trigger = "guangjian",
		anim_name = var78.n_Skill_2,
		over_offset = Vector3(0, 0),
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(300, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	n_Skill_3 = {
		time = 0,
		sound_trigger = "baozha1",
		anim_name = var78.n_Skill_3
	},
	n_Combine = {
		sound_start = "bianshen",
		time = 0,
		camera = true,
		anim_name = var78.n_Combine,
		camera_pos = Vector2(0, 0)
	},
	n_DMG = {
		time = 0,
		anim_name = var78.n_DMG,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance_m = Vector3(-150, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	n_DMG_S = {
		time = 0,
		anim_name = var78.n_DMG
	},
	n_DMG_Back_R = {
		time = 0,
		anim_name = var78.n_MoveR,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0)
		}
	},
	n_Neutral = {
		time = 0,
		anim_name = var78.n_Neutral
	},
	c_Atk = {
		time = 0,
		sound_trigger = "taosheng",
		anim_name = var78.c_Atk,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(500, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	c_Skill_1 = {
		sound_trigger = "baozha2",
		time = 0,
		camera = true,
		anim_name = var78.c_Skill_1
	},
	c_Dmg = {
		time = 0,
		anim_name = var78.c_Dmg,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance_m = Vector3(-150, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	c_Dmg_S = {
		time = 0,
		anim_name = var78.c_Dmg
	},
	c_MoveL = {
		time = 0,
		anim_name = var78.c_MoveL,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0)
		}
	},
	c_MoveR = {
		time = 0,
		anim_name = var78.c_MoveR,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(650, 0, 0)
		}
	},
	c_DMG_Back_R = {
		time = 0,
		anim_name = var78.c_MoveR,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0)
		}
	},
	c_Neutral = {
		time = 0,
		anim_name = var78.c_Neutral
	}
}
local var80 = {
	{
		special_time = false,
		name = "normalAtk",
		power_index = 0,
		atk_index = 1,
		score = {
			100,
			100
		},
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var79.n_Atk,
			var79.n_Move_L
		}
	},
	{
		special_time = false,
		name = "skill1",
		power_index = 1,
		atk_index = 2,
		score = {
			500,
			500
		},
		grid_index = {
			1
		},
		actions = {
			var79.n_Skill_1
		}
	},
	{
		special_time = false,
		name = "skill2",
		power_index = 2,
		atk_index = 3,
		score = {
			500,
			500
		},
		grid_index = {
			2
		},
		actions = {
			var79.n_Skill_2,
			var79.n_Move_L
		}
	},
	{
		special_time = false,
		name = "skill3",
		power_index = 3,
		atk_index = 2,
		score = {
			500,
			500
		},
		grid_index = {
			3
		},
		actions = {
			var79.n_Skill_3
		}
	},
	{
		dmg_index = 2,
		name = "DMG",
		power_index = 0,
		special_time = false,
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var79.n_DMG,
			var79.n_DMG_Back_R
		}
	},
	{
		dmg_index = 1,
		name = "DMGS",
		power_index = 0,
		special_time = false,
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var79.n_DMG_S
		}
	},
	{
		special_end = true,
		name = "special_end",
		power_index = 0,
		special_time = false,
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var79.n_DMG_Back_R
		},
		anim_init_pos = Vector2(586, 471)
	},
	{
		dmg_index = 3,
		name = "DMGN",
		special_time = false,
		actions = {
			var79.DMG
		}
	},
	{
		name = "DMG_BACK",
		special_time = false,
		dmg_back = true,
		actions = {
			var79.DMG_Back_R
		}
	},
	{
		special_trigger = true,
		name = "Combine",
		power_index = 0,
		anim_bool = "special",
		special_time = true,
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var79.n_Combine
		},
		anim_trigger_pos = Vector2(-58, 350),
		anim_end_pos = Vector2(225, 471)
	},
	{
		special_time = true,
		name = "AtkS",
		power_index = 0,
		atk_index = 1,
		score = {
			300,
			300
		},
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var79.c_Atk,
			var79.c_MoveL
		}
	},
	{
		special_time = true,
		name = "Skill1S",
		power_index = 1,
		atk_index = 2,
		score = {
			1000,
			1000
		},
		grid_index = {
			1
		},
		actions = {
			var79.c_Skill_1
		}
	},
	{
		special_time = true,
		name = "Skill1S",
		power_index = 2,
		atk_index = 2,
		score = {
			1000,
			1000
		},
		grid_index = {
			2
		},
		actions = {
			var79.c_Skill_1
		}
	},
	{
		special_time = true,
		name = "Skill1S",
		power_index = 3,
		atk_index = 2,
		score = {
			1000,
			1000
		},
		grid_index = {
			3
		},
		actions = {
			var79.c_Skill_1
		}
	},
	{
		dmg_index = 2,
		name = "cDmg",
		power_index = 0,
		special_time = true,
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var79.c_Dmg,
			var79.c_DMG_Back_R
		}
	},
	{
		dmg_index = 1,
		name = "cDmgS",
		power_index = 0,
		special_time = true,
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var79.c_Dmg_S
		}
	},
	{
		dmg_index = 3,
		name = "DMGN",
		special_time = false,
		actions = {
			var79.DMG
		}
	},
	{
		name = "DMG_BACK",
		special_time = false,
		dmg_back = true,
		actions = {
			var79.DMG_Back_R
		}
	}
}
local var81 = {
	Neutral = "Neutral",
	Skill_1 = "skill_1",
	Skill_2 = "skill_2",
	Atk = "ATK",
	MoveL = "MoveL",
	DMG = "DMG",
	MoveR = "MoveR"
}
local var82 = {
	Move_R = {
		time = 0,
		anim_name = var81.MoveR,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(500, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	Atk = {
		time = 0,
		sound_trigger = "taosheng",
		anim_name = var81.Atk,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(600, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	Move_L = {
		time = 0,
		anim_name = var81.MoveL,
		move = {
			time = 0.4,
			distance = Vector3(0, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	Skill_1 = {
		time = 0,
		sound_trigger = "jiguang",
		anim_name = var81.Skill_1
	},
	Skill_2 = {
		time = 0,
		sound_trigger = "baozha2",
		anim_name = var81.Skill_2,
		over_offset = Vector2(115, 0)
	},
	DMG = {
		time = 0,
		anim_name = var81.DMG,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance_m = Vector3(-150, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	DMG_Back_R = {
		time = 0,
		anim_name = var81.MoveR,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	DMG_S = {
		time = 0,
		anim_name = var81.DMG
	},
	Neutral = {
		time = 0,
		anim_name = var81.Neutral
	}
}
local var83 = {
	{
		special_time = false,
		name = "normalAtk",
		power_index = 0,
		atk_index = 1,
		score = {
			100,
			100
		},
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var82.Atk,
			var82.Move_L
		}
	},
	{
		special_time = false,
		name = "skill1",
		power_index = 1,
		atk_index = 2,
		score = {
			500,
			500
		},
		grid_index = {
			1
		},
		actions = {
			var82.Skill_1
		}
	},
	{
		special_time = false,
		name = "skill2",
		power_index = 2,
		atk_index = 2,
		score = {
			500,
			500
		},
		grid_index = {
			2,
			3
		},
		actions = {
			var82.Move_R,
			var82.Skill_2,
			var82.Move_L
		}
	},
	{
		dmg_index = 2,
		name = "DMG",
		special_time = false,
		actions = {
			var82.DMG,
			var82.DMG_Back_R
		}
	},
	{
		dmg_index = 1,
		name = "DMG_Stand",
		special_time = false,
		actions = {
			var82.DMG_S
		}
	},
	{
		dmg_index = 3,
		name = "DMGN",
		special_time = false,
		actions = {
			var82.DMG
		}
	},
	{
		name = "DMG_BACK",
		special_time = false,
		dmg_back = true,
		actions = {
			var82.DMG_Back_R
		}
	}
}
local var84 = {
	Neutral = "Neutral",
	Skill_1 = "skill_1",
	Skill_2 = "skill_2",
	Atk = "ATK",
	MoveL = "MoveL",
	DMG = "DMG",
	MoveR = "MoveR"
}
local var85 = {
	Move_R = {
		time = 0,
		anim_name = var84.MoveR,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(500, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	Atk = {
		time = 0,
		sound_trigger = "taosheng",
		anim_name = var84.Atk,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(600, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	Move_L = {
		time = 0,
		anim_name = var84.MoveL,
		move = {
			time = 0.4,
			distance = Vector3(0, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	Skill_1 = {
		time = 0,
		sound_trigger = "jiguang",
		anim_name = var84.Skill_1
	},
	Skill_2 = {
		time = 0,
		sound_trigger = "baozha2",
		anim_name = var84.Skill_2,
		over_offset = Vector2(264, 0)
	},
	DMG = {
		time = 0,
		anim_name = var84.DMG,
		move = {
			time = 0.3,
			distance_m = Vector3(-150, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	DMG_Back_R = {
		time = 0,
		anim_name = var84.MoveR,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	DMG_S = {
		time = 0,
		anim_name = var84.DMG
	},
	Neutral = {
		time = 0,
		anim_name = var84.Neutral
	}
}
local var86 = {
	{
		special_time = false,
		name = "normalAtk",
		power_index = 0,
		atk_index = 1,
		score = {
			100,
			100
		},
		grid_index = {
			1,
			2,
			3
		},
		actions = {
			var85.Atk,
			var85.Move_L
		}
	},
	{
		special_time = false,
		name = "skill1",
		power_index = 1,
		atk_index = 2,
		score = {
			500,
			500
		},
		grid_index = {
			1
		},
		actions = {
			var85.Skill_1
		}
	},
	{
		special_time = false,
		name = "skill2",
		power_index = 2,
		atk_index = 2,
		score = {
			500,
			500
		},
		grid_index = {
			2,
			3
		},
		actions = {
			var85.Skill_2,
			var85.Move_L
		}
	},
	{
		dmg_index = 2,
		name = "DMG",
		special_time = false,
		actions = {
			var85.DMG,
			var85.DMG_Back_R
		}
	},
	{
		dmg_index = 1,
		name = "DMG_Stand",
		special_time = false,
		actions = {
			var85.DMG_S
		}
	},
	{
		dmg_index = 3,
		name = "DMGN",
		special_time = false,
		actions = {
			var85.DMG
		}
	},
	{
		name = "DMG_BACK",
		special_time = false,
		dmg_back = true,
		actions = {
			var85.DMG_Back_R
		}
	}
}
local var87 = {
	{
		index = 1,
		name = "role1",
		skill = var74,
		actions = var73
	},
	{
		index = 2,
		name = "role2",
		skill = var77,
		actions = var76
	},
	{
		index = 3,
		name = "enemy1",
		skill = var83,
		actions = var82
	},
	{
		index = 4,
		name = "enemy2",
		skill = var86,
		actions = var85
	},
	{
		index = 5,
		name = "role3",
		skill = var80,
		actions = var79,
		anim_init_pos = Vector2(586, 411)
	}
}

local function var88(arg0, arg1)
	local var0 = {
		ctor = function(arg0)
			arg0._boxTf = arg0
			arg0._event = arg1

			arg0._event:bind(var15, function()
				local var0 = var23.power_grid

				if var0 and var0 > 0 and var35[var0] then
					local var1 = var35[var0]
					local var2 = var1.rule
					local var3 = var1.id and var1.id or var0

					table.insert(arg0.ruleGridList, {
						id = var3,
						rule = var2
					})
				end
			end)

			arg0._gridEffect = findTF(arg0._boxTf, "effectGrid")
			arg0._content = findTF(arg0._boxTf, "viewport/content")
			arg0.tplGrid = findTF(arg0, "tplGrid")

			setActive(arg0.tplGrid, false)

			arg0.grids = {}
			arg0.effects = {}
			arg0.combo = 0
			arg0.ruleGridList = {}

			for iter0 = 1, var24 do
				local var0 = tf(instantiate(arg0._gridEffect))

				setParent(var0, arg0._content)
				setActive(var0, false)

				var0.anchoredPosition = Vector2(var26.x * iter0 - var26.x / 2, var26.y / 2)

				table.insert(arg0.effects, var0)
			end
		end,
		start = function(arg0)
			arg0.comboCheck = false

			arg0:initGrids(false)

			for iter0 = 1, #arg0.effects do
				setActive(arg0.effects[iter0], false)
			end
		end,
		step = function(arg0)
			if arg0.takeAwayTime and arg0.takeAwayTime > 0 then
				arg0.takeAwayTime = arg0.takeAwayTime - Time.deltaTime

				return
			end

			arg0.gridCreateIndex = 1

			local var0 = false

			for iter0 = 1, #arg0.grids do
				local var1 = arg0.grids[iter0]
				local var2 = iter0

				if not var1.moveAble then
					var0 = var0 or true

					local var3 = (iter0 - 1) * var26.x

					if var3 < var1.tf.anchoredPosition.x then
						var1.tf.anchoredPosition = Vector2(var1.tf.anchoredPosition.x - var1.speed * Time.deltaTime, 0)

						if var1.speed < var27 then
							var1.speed = var1.speed + var29
						end
					end

					if var3 >= var1.tf.anchoredPosition.x then
						var1.speed = 0
						var1.moveAble = true

						if var3 > var1.tf.anchoredPosition.x then
							var1.tf.anchoredPosition = Vector2(var3, 0)
						end
					end
				end

				if not var1.eventAble then
					GetComponent(var1.tf, typeof(EventTriggerListener)):AddPointDownFunc(function()
						if arg0.comboCheck == false then
							local var0, var1 = arg0:triggerDownGrid(var2)

							if #var0 >= 2 then
								arg0.comboCheck = true

								local var2 = arg0:getGridDouble(var0)

								arg0:takeAwayGrid(var0)
								arg0:insertGrids()

								for iter0 = 1, #var1 do
									local var3 = var1[iter0].index
									local var4 = var1[iter0].count

									arg0._event:emit(var14, {
										series = var4,
										combo = arg0.combo,
										index = var3,
										double = var2
									})
								end

								arg0.combo = arg0.combo + 1
							else
								arg0.comboCheck = true

								arg0:takeAwayGrid({
									var2
								})
								arg0:insertGrids()
							end
						end
					end)

					var1.eventAble = true
				end
			end

			if not var0 and arg0.comboCheck then
				local var4 = arg0:getSeriesGrids()

				if #var4 > 0 then
					local var5 = {}

					for iter1 = 1, #var4 do
						local var6 = var4[iter1].series
						local var7 = var4[iter1].index
						local var8 = var4[iter1].double

						for iter2 = 1, #var6 do
							table.insert(var5, var6[iter2])
						end

						local var9 = arg0:getGridDouble(var6)

						arg0._event:emit(var14, {
							series = #var6,
							combo = arg0.combo,
							index = var7,
							double = var9
						})
					end

					arg0:clearGridSeriesAble()
					arg0:takeAwayGrid(var5)
					arg0:insertGrids()

					arg0.comboCheck = true
					arg0.combo = arg0.combo + 1
				else
					arg0.comboCheck = false
					arg0.combo = 0
				end
			end
		end,
		getGridDouble = function(arg0, arg1)
			for iter0 = 1, #arg1 do
				if arg0.grids[iter0] and arg0.grids[iter0].rule == var32 then
					return true
				end
			end

			return false
		end,
		clear = function(arg0)
			for iter0 = 1, #arg0.grids do
				if arg0.grids[iter0].tf then
					destroy(arg0.grids[iter0].tf)
				end
			end

			arg0.grids = {}
			arg0.gridCreateIndex = 1
			arg0.ruleGridList = {}
		end,
		clearGridSeriesAble = function(arg0)
			for iter0 = 1, #arg0.grids do
				if arg0.grids[iter0].seriesAble then
					arg0.grids[iter0].seriesAble = false
				end
			end
		end,
		getSeriesGrids = function(arg0)
			local var0 = {}
			local var1
			local var2 = {}
			local var3 = {}
			local var4
			local var5
			local var6 = 0
			local var7 = false

			for iter0 = 1, #arg0.grids do
				if var5 and var5 == arg0.grids[iter0].index then
					var6 = var6 + 1
				elseif arg0.grids[iter0].rule == var31 then
					var6 = var6 + 1
				elseif var7 then
					var5 = arg0.grids[iter0].index
					var7 = false
				else
					if var6 >= 3 and arg0:checkGridComboFlag(var3) then
						table.insert(var0, {
							series = var3,
							index = var5
						})
					end

					local var8 = arg0.grids[iter0]

					var5 = var8.index
					var6 = 1
					var7 = var8.rule == var31
					var3 = {}
				end

				table.insert(var3, iter0)

				if iter0 == #arg0.grids and #var3 >= 3 and arg0:checkGridComboFlag(var3) then
					table.insert(var0, {
						series = var3,
						index = var5
					})

					var3 = {}
				end
			end

			return var0
		end,
		checkGridComboFlag = function(arg0, arg1)
			for iter0 = 1, #arg1 do
				if arg0.grids[arg1[iter0]].seriesAble and iter0 ~= #arg1 then
					return true
				end
			end

			return false
		end,
		insertGrids = function(arg0)
			local var0 = var24 - #arg0.grids

			for iter0 = 1, var0 do
				local var1 = arg0:createGridData()

				table.insert(arg0.grids, var1)
			end

			if arg0:checkGridsMatchAble() then
				arg0:instiateGrids(true)
			else
				arg0:initGrids(true)
			end

			arg0:changeAbleGrids()
		end,
		changeAbleGrids = function(arg0)
			for iter0 = 1, #arg0.grids do
				arg0.grids[iter0].moveAble = false
				arg0.grids[iter0].eventAble = false
				arg0.grids[iter0].speed = var28
			end
		end,
		takeAwayGrid = function(arg0, arg1)
			table.sort(arg1, function(arg0, arg1)
				return arg0 <= arg1
			end)

			arg0.takeAwayTime = var25

			local var0 = {}
			local var1 = arg1[1] - 1

			if var1 > 0 then
				arg0.grids[var1].seriesAble = true
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/" .. "xiaochu")

			for iter0 = #arg1, 1, -1 do
				table.insert(var0, table.remove(arg0.grids, arg1[iter0]))
				setActive(arg0.effects[arg1[iter0]], false)
				setActive(arg0.effects[arg1[iter0]], true)
			end

			for iter1 = 1, #var0 do
				destroy(var0[iter1].tf)

				var0[iter1] = 0
			end

			local var2 = {}
		end,
		triggerDownGrid = function(arg0, arg1)
			local var0 = arg0.grids[arg1]
			local var1
			local var2 = var0.rule
			local var3 = {}
			local var4 = {}

			if var2 ~= var31 then
				var3 = {
					arg1
				}
				var1 = var0.index
			end

			if not var0 then
				return var3, {}
			end

			if var2 == var31 then
				local var5
				local var6 = true
				local var7 = {}

				for iter0 = arg1 - 1, 1, -1 do
					if var6 then
						if arg0.grids[iter0].rule == var31 then
							table.insert(var7, iter0)
						elseif not var5 then
							var5 = arg0.grids[iter0].index

							table.insert(var7, iter0)
						elseif var5 == arg0.grids[iter0].index then
							table.insert(var7, iter0)
						else
							var6 = false
						end
					end
				end

				local var8
				local var9 = true
				local var10 = {}

				for iter1 = arg1 + 1, #arg0.grids do
					if var9 then
						if arg0.grids[iter1].rule == var31 then
							table.insert(var10, iter1)
						elseif not var8 then
							var8 = arg0.grids[iter1].index

							table.insert(var10, iter1)
						elseif var8 == arg0.grids[iter1].index then
							table.insert(var10, iter1)
						else
							var9 = false
						end
					end
				end

				if var5 == nil and var8 == nil then
					for iter2 = 1, #arg0.grids do
						table.insert(var3, iter2)
					end
				elseif var5 == var8 then
					for iter3 = 1, #var7 do
						table.insert(var3, var7[iter3])
					end

					table.insert(var3, arg1)

					for iter4 = 1, #var10 do
						table.insert(var3, var10[iter4])
					end

					var1 = var5
				else
					if #var7 >= #var10 then
						for iter5 = 1, #var7 do
							table.insert(var3, var7[iter5])
						end

						var1 = var5
					else
						for iter6 = 1, #var10 do
							table.insert(var3, var10[iter6])
						end

						var1 = var8
					end

					table.insert(var3, arg1)
				end

				table.insert(var4, {
					index = var1,
					count = #var3
				})
			elseif var0.rule == var30 then
				local var11
				local var12
				local var13 = var0.index
				local var14
				local var15 = true
				local var16 = {}

				for iter7 = arg1 - 1, 1, -1 do
					if var15 then
						if arg0.grids[iter7].rule == var31 then
							table.insert(var16, iter7)
						elseif not var14 then
							var14 = arg0.grids[iter7].index

							table.insert(var16, iter7)
						elseif var14 == arg0.grids[iter7].index then
							table.insert(var16, iter7)
						else
							var15 = false
						end
					end
				end

				local var17
				local var18 = true
				local var19 = {}

				for iter8 = arg1 + 1, #arg0.grids do
					if var18 then
						if arg0.grids[iter8].rule == var31 then
							table.insert(var19, iter8)
						elseif not var17 then
							var17 = arg0.grids[iter8].index

							table.insert(var19, iter8)
						elseif var17 == arg0.grids[iter8].index then
							table.insert(var19, iter8)
						else
							var18 = false
						end
					end
				end

				table.insert(var4, {
					index = var14,
					count = #var16 + 1
				})
				table.insert(var4, {
					index = var17,
					count = #var19 + 1
				})

				for iter9 = 1, #var16 do
					table.insert(var3, var16[iter9])
				end

				for iter10 = 1, #var19 do
					table.insert(var3, var19[iter10])
				end
			else
				for iter11 = arg1 - 1, 1, -1 do
					if arg0:checkGridMatch(var1, arg0.grids[iter11]) then
						table.insert(var3, iter11)
					else
						break
					end
				end

				for iter12 = arg1 + 1, #arg0.grids do
					if arg0:checkGridMatch(var1, arg0.grids[iter12]) then
						table.insert(var3, iter12)
					else
						break
					end
				end

				table.insert(var4, {
					index = var1,
					count = #var3
				})
			end

			table.sort(var3, function(arg0, arg1)
				return arg0 < arg1
			end)

			return var3, var4
		end,
		checkGridMatch = function(arg0, arg1, arg2)
			if arg1 == arg2.index then
				return true
			elseif arg2.rule == var31 then
				return true
			end

			return false
		end,
		initGrids = function(arg0, arg1)
			arg0:clear()

			for iter0 = 1, var24 do
				local var0 = arg0:createGridData()

				table.insert(arg0.grids, var0)
			end

			if arg0:checkGridsMatchAble() then
				arg0:instiateGrids(arg1)
			else
				arg0:initGrids(arg1)
			end

			arg0.comboCheck = false
		end,
		instiateGrids = function(arg0, arg1)
			for iter0 = 1, #arg0.grids do
				local var0 = arg0.grids[iter0]

				if not var0.tf then
					local var1 = tf(instantiate(arg0.tplGrid))

					SetParent(var1, arg0._content)
					setActive(var1, true)
					setActive(findTF(var1, var0.name), true)

					local var2

					if arg1 then
						var2 = (var24 + arg0.gridCreateIndex - 1) * var26.x
					else
						var2 = (arg0.gridCreateIndex - 1) * var26.x
					end

					if var0.rule == var31 then
						-- block empty
					end

					if var0.rule ~= var31 then
						setActive(findTF(var1, var0.name .. "/boom"), var0.rule == var30)
						setActive(findTF(var1, var0.name .. "/thunder"), var0.rule == var32)
					end

					var1.anchoredPosition = Vector2(var2, 0)
					arg0.gridCreateIndex = arg0.gridCreateIndex + 1
					var0.tf = var1
				end
			end
		end,
		createGridData = function(arg0)
			local var0
			local var1
			local var2
			local var3

			if #arg0.ruleGridList > 0 then
				local var4 = table.remove(arg0.ruleGridList, 1)

				var0 = var4.id
				var3 = var4.rule
			else
				var0 = var34[math.random(1, #var34)]
			end

			local var5 = var33[var0].name
			local var6 = var33[var0].index

			return {
				eventAble = false,
				moveAble = false,
				speed = var28,
				index = var6,
				name = var5,
				rule = var3
			}
		end,
		checkGridsMatchAble = function(arg0)
			return true
		end
	}

	var0:ctor()

	return var0
end

local var89 = false

local function var90(arg0, arg1, arg2)
	local var0 = {
		ctor = function(arg0)
			arg0._specialTf = arg0
			arg0._successTf = arg1
			arg0._effectSuccess = findTF(arg0._successTf, "effectSuccess")
			arg0._event = arg2

			arg0._event:bind(var14, function(arg0, arg1, arg2)
				local var0 = arg1.series or 0
				local var1 = arg1.combo
				local var2 = arg1.index
				local var3 = arg1.double

				arg0:addPowerAmount(var2, arg0:getPowerAmount(var0, var1, var3))
			end)

			arg0.powers = {}

			for iter0 = 1, #var36 do
				local var0 = findTF(arg0._specialTf, var36[iter0].name)
				local var1 = var36[iter0].index
				local var2 = var36[iter0].max
				local var3 = var36[iter0].cur
				local var4 = findTF(arg0._specialTf, var36[iter0].name .. "/text")

				setActive(var4, var1)

				local var5 = {
					active = false,
					tf = var0,
					index = var1,
					max = var2,
					cur = var3,
					text_tf = var4
				}

				table.insert(arg0.powers, var5)
			end

			arg0._event:bind(var20, function(arg0, arg1, arg2)
				arg0.inCameraFlag = true
			end)
			arg0._event:bind(var21, function(arg0, arg1, arg2)
				arg0.inCameraFlag = false
				arg0.inCameraFadeTime = 200
			end)

			arg0.successText = findTF(arg0._successTf, "box/text")

			setActive(arg0.successText, var1)

			arg0.success = {
				cur = 0,
				slider = GetComponent(findTF(arg0._successTf, "box"), typeof(Slider)),
				max = var45
			}
		end,
		start = function(arg0)
			for iter0 = 1, #arg0.powers do
				local var0 = arg0.powers[iter0]

				var0.cur = 0
				var0.active = false
			end

			arg0.inCameraFlag = false
			arg0.inCameraFadeTime = 0
			arg0.success.cur = 0
			arg0.success.active = false

			setActive(arg0._effectSuccess, false)
			arg0:resetSpecialData()
			arg0:step()
		end,
		step = function(arg0)
			for iter0 = 1, #arg0.powers do
				local var0 = arg0.powers[iter0]

				if var0.active and var0.cur > 0 then
					var0.cur = var0.cur - var42 * Time.deltaTime

					if var0.cur <= 0 then
						var0.active = false
						var0.cur = 0
					end
				end

				GetComponent(var0.tf, typeof(Slider)).value = var0.cur > 0 and var0.cur / var0.max or 0

				setText(var0.text_tf, math.floor(var0.cur))
			end

			setText(arg0.successText, math.floor(arg0.success.cur))

			if arg0.success.active and arg0.success.cur > 0 and var23.special_complete and not arg0.inCameraFlag then
				if arg0.inCameraFadeTime > 0 then
					arg0.inCameraFadeTime = arg0.inCameraFadeTime - Time.deltaTime * 1000
				else
					arg0.success.cur = arg0.success.cur - var43 * Time.deltaTime

					if arg0.success.cur <= 0 then
						arg0.success.active = false
						arg0.success.cur = 0

						arg0._event:emit(var19)
					end
				end
			end

			if arg0.success.cur >= arg0.success.max or arg0.success.active then
				setActive(arg0._effectSuccess, true)
			else
				setActive(arg0._effectSuccess, false)
			end

			arg0.success.slider.value = arg0.success.cur > 0 and arg0.success.cur / arg0.success.max or 0
			var23.special_time = arg0.success.active
			var23.grid_index = 0

			if arg0.waitingSpecial then
				arg0:addPowerAmount(1, 0)
			end
		end,
		clear = function(arg0)
			return
		end,
		updateSpecialData = function(arg0, arg1)
			var23.special_time = arg0.success.active
			var23.grid_index = arg1
			var23.power_grid = 0

			for iter0 = 1, #arg0.powers do
				if arg0.powers[iter0].index == arg1 and arg0.powers[iter0].cur == arg0.powers[iter0].max then
					var23.power_grid = arg0.powers[iter0].index
				end
			end

			arg0._event:emit(var15)
		end,
		resetSpecialData = function(arg0)
			var23.special_complete = false
		end,
		addPowerAmount = function(arg0, arg1, arg2)
			local var0 = arg0:getPowerByIndex(arg1)

			if arg0.success then
				if not arg0.success.active then
					arg0.success.cur = arg0.success.cur + arg2

					if arg0.success.cur >= arg0.success.max then
						arg0.success.cur = arg0.success.max

						arg0._event:emit(var18, {
							callback = function(arg0)
								if arg0 then
									if not isActive(arg0._effectSuccess) then
										setActive(arg0._effectSuccess, true)
									end

									arg0.success.active = true
									var23.special_complete = false
									arg0.waitingSpecial = false
								else
									arg0.waitingSpecial = true
								end
							end
						})
					end
				else
					arg0.success.cur = arg0.success.cur + arg2 / 2

					if arg0.success.cur >= arg0.success.max then
						arg0.success.cur = arg0.success.max
					end
				end
			end

			if var0 and not var0.active then
				var0.cur = var0.cur + arg2

				if var0.cur >= var0.max then
					var0.cur = var0.max
					var0.active = true
				end
			end

			if arg2 > 0 then
				arg0:updateSpecialData(arg1)
			end
		end,
		getPowerByIndex = function(arg0, arg1)
			for iter0 = 1, #arg0.powers do
				if arg0.powers[iter0].index == arg1 then
					return arg0.powers[iter0]
				end
			end

			return nil
		end,
		getPowerAmount = function(arg0, arg1, arg2, arg3)
			if arg1 <= 2 then
				print("分数: " .. var44)

				return var44
			end

			local var0 = arg3 and 2 or 1

			if var0 == 2 then
				-- block empty
			end

			local var1 = var23.special_time and var41 or 1

			print("方块个数: " .. arg1 .. ",combo次数: " .. arg2 .. ", 加倍方块: " .. tostring(arg3) .. "，变身倍率: " .. var1)
			print("分数: " .. (var40 + (arg1 - var39) * var38) * (1 + arg2 * var37) * var1)

			return (var40 + (arg1 - var39) * var38) * (1 + arg2 * var37) * var0 * var1
		end
	}

	var0:ctor()

	return var0
end

local function var91(arg0, arg1, arg2)
	local var0 = {
		ctor = function(arg0)
			arg0._sceneTf = arg0
			arg0._event = arg2
			arg0.bgs = {}
			arg0._gameTf = arg1
			arg0._box = findTF(arg0._gameTf, "box")
			arg0._specialPower = findTF(arg0._gameTf, "specialPower")
			arg0._successPower = findTF(arg0._gameTf, "successPower")
			arg0._top = findTF(arg0._gameTf, "top")

			for iter0 = 1, #var71 do
				local var0 = var71[iter0]
				local var1 = findTF(arg0._sceneTf, var71[iter0].source)
				local var2 = var71[iter0].rate

				table.insert(arg0.bgs, {
					tf = var1,
					rate = var2,
					type = var71[iter0].type
				})
			end

			arg0._bgBackCanvas = GetComponent(findTF(arg0._sceneTf, "scene_background"), typeof(CanvasGroup))
			arg0._bgFrontCanvas = GetComponent(findTF(arg0._sceneTf, "scene_front"), typeof(CanvasGroup))
			arg0._bgBeamCanvas = GetComponent(findTF(arg0._sceneTf, "scene/bgBeam"), typeof(CanvasGroup))

			arg0._event:bind(var16, function(arg0, arg1, arg2)
				local var0 = arg1[1]
				local var1 = arg1[2] and -1 or 1
				local var2 = arg1[3]

				if not arg0.inCamera then
					arg0:setTargetFllow(Vector2(var1 * var0.x / 10, var1 * var0.y / 10), var2)
				end
			end)
			arg0._event:bind(var20, function(arg0, arg1, arg2)
				arg0.inCamera = true

				local var0 = Vector2(550, 100)

				if arg1 and arg1.playingAction and arg1.playingAction.camera_pos then
					var0 = arg1.playingAction.camera_pos
				end

				arg0:setTargetFllow(var0)
				arg0:setBeam(false)
			end)
			arg0._event:bind(var21, function(arg0, arg1, arg2)
				arg0.followTf = nil
				arg0.followInit = nil

				arg0:setTargetFllow(Vector2(0, 0), function()
					return
				end, true)
				arg0:setBeam(true)

				arg0.inCamera = false
			end)
		end,
		start = function(arg0)
			arg0.targetVec = Vector2(var56.x, var56.y)
			arg0.currentVec = Vector2(var56.x, var56.y)

			for iter0 = 1, #arg0.bgs do
				local var0 = arg0.bgs[iter0].tf
				local var1 = arg0.bgs[iter0].rate
				local var2 = arg0.bgs[iter0].type

				if var0 then
					setActive(var0, var2 == var67 or var2 == var70)

					var0.anchoredPosition = Vector2(arg0.currentVec.x * var1, arg0.currentVec.y * var1)
				end
			end

			arg0._bgBackCanvas.alpha = 1
			arg0._bgFrontCanvas.alpha = 1
			arg0._bgBeamCanvas.alpha = 0

			setActive(arg0._box, true)
			setActive(arg0._specialPower, true)
			setActive(arg0._successPower, true)
			setActive(arg0._top, true)
		end,
		clear = function(arg0)
			if LeanTween.isTweening(go(arg0._sceneTf)) then
				LeanTween.cancel(go(arg0._sceneTf), false)
			end
		end,
		step = function(arg0)
			local var0 = {
				0,
				0
			}

			if arg0.followTf then
				var0 = {
					arg0.followTf.anchoredPosition.x - arg0.followInit.x,
					arg0.followTf.anchoredPosition.y - arg0.followInit.y
				}
			end

			local var1 = 0
			local var2 = 0
			local var3 = arg0.targetVec.x - var0[1]
			local var4 = arg0.targetVec.y - var0[2]

			if var3 ~= arg0.currentVec.x then
				var1 = (var3 - arg0.currentVec.x) * var57

				if math.abs(var1) < var58 then
					var1 = var58 * math.sign(var1)
				end

				arg0.currentVec.x = arg0.currentVec.x + var1

				if math.abs(arg0.currentVec.x - var3) <= var58 then
					arg0.currentVec.x = var3
				end
			end

			if var4 ~= arg0.currentVec.y then
				var2 = (var4 - arg0.currentVec.y) * var57

				if math.abs(var2) < var58 then
					var2 = var58 * math.sign(var2)
				end

				arg0.currentVec.y = arg0.currentVec.y + var2

				if math.abs(arg0.currentVec.y - var4) <= var58 then
					arg0.currentVec.y = var4
				end
			end

			if var1 ~= 0 or var2 ~= 0 then
				arg0:moveTo(arg0.currentVec)
			end
		end,
		moveTo = function(arg0, arg1)
			for iter0 = 1, #arg0.bgs do
				local var0 = arg0.bgs[iter0].tf
				local var1 = arg0.bgs[iter0].rate
				local var2 = arg0.bgs[iter0].type

				if var2 == var67 or var2 == var70 then
					var0.anchoredPosition = Vector2(arg1.x * var1, arg1.y * var1)
				end
			end
		end,
		setTargetFllow = function(arg0, arg1, arg2, arg3)
			if not arg3 then
				arg0.targetVec = arg1
				arg0.moveCallback = arg2
			else
				arg0.currentVec = arg1
				arg0.targetVec = arg1

				arg0:moveTo(arg1)

				if arg2 then
					arg2()
				end
			end
		end,
		setBeam = function(arg0, arg1, arg2)
			if LeanTween.isTweening(go(arg0._sceneTf)) then
				LeanTween.cancel(go(arg0._sceneTf), false)
			end

			if arg1 then
				setActive(arg0._box, true)
				setActive(arg0._specialPower, true)
				setActive(arg0._successPower, true)
				setActive(arg0._top, true)
			else
				setActive(arg0._box, false)
				setActive(arg0._specialPower, false)
				setActive(arg0._successPower, false)
				setActive(arg0._top, false)
			end

			LeanTween.value(go(arg0._sceneTf), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0)
				if arg1 then
					arg0._bgBackCanvas.alpha = arg0
					arg0._bgFrontCanvas.alpha = arg0
					arg0._bgBeamCanvas.alpha = 1 - arg0
				else
					arg0._bgBackCanvas.alpha = 1 - arg0
					arg0._bgFrontCanvas.alpha = 1 - arg0
					arg0._bgBeamCanvas.alpha = arg0
				end
			end)):setOnComplete(System.Action(function()
				if arg2 then
					arg2()
				end
			end))
		end
	}

	var0:ctor()

	return var0
end

local function var92(arg0, arg1)
	local var0 = {
		ctor = function(arg0)
			arg0._scene = arg0
			arg0._tpl = findTF(arg0._scene, "tpl")
			arg0._leftRolePos = findTF(arg0._scene, "rolePos/leftRole")
			arg0._rightRolePos = findTF(arg0._scene, "rolePos/rightRole")
			arg0._event = arg1

			arg0._event:bind(var15, function()
				arg0:onGridTrigger()
			end)
			arg0._event:bind(var18, function(arg0, arg1, arg2)
				local var0 = false

				for iter0, iter1 in pairs(arg0.playingDatas) do
					if iter1.inPlaying then
						var0 = true
					end
				end

				if arg1.callback then
					arg1.callback(not var0)
				end

				if not var0 then
					arg0:onRoleSpecial(arg1)
				end
			end)
			arg0._event:bind(var19, function()
				arg0:onRoleSpecialEnd()
			end)
		end,
		start = function(arg0)
			if arg0.leftRole then
				destroy(arg0.leftRole.tf)

				arg0.leftRole = nil
			end

			if arg0.rightRole then
				destroy(arg0.rightRole.tf)

				arg0.rightRole = nil
			end

			arg0.leftRole = arg0:createRole(var46, true, arg0._leftRolePos)
			arg0.rightRole = arg0:createRole(var47, false, arg0._rightRolePos)
			arg0.leftRole.targetRole = arg0.rightRole
			arg0.rightRole.targetRole = arg0.leftRole

			arg0.leftRole.animator:SetTrigger("idle")
			arg0.leftRole.animator:SetBool("special", false)
			arg0.rightRole.animator:SetTrigger("idle")
			arg0.rightRole.animator:SetBool("special", false)

			arg0.leftRole.specialBody = false
			arg0.rightRole.specialBody = false
			arg0.leftRole.anchoredPosition = Vector2(0, 0)
			arg0.rightRole.anchoredPosition = Vector2(0, 0)
			arg0.leftRole.specialTime = false
			arg0.rightRole.specialTime = false
			arg0.playingDatas = {}
			arg0.playingDatas[arg0.leftRole.name] = {
				role = arg0.leftRole
			}
			arg0.playingDatas[arg0.leftRole.name].skillDatas = {}
			arg0.playingDatas[arg0.rightRole.name] = {
				role = arg0.rightRole
			}
			arg0.playingDatas[arg0.rightRole.name].skillDatas = {}
			arg0.skillDeltaTime = 0
			arg0.emptySkillTime = math.random(1, 2)
			arg0.addScore = {
				0,
				0
			}

			arg0._event:emit(var16, {
				Vector2(0, 0),
				false
			})
		end,
		step = function(arg0)
			arg0:checkSkillDeltaTime()
			arg0:checkEmptySkillTime()
		end,
		checkSkillDeltaTime = function(arg0)
			if arg0.skillDeltaTime and arg0.skillDeltaTime <= 0 then
				arg0.skillDeltaTime = var59
			end

			arg0.skillDeltaTime = arg0.skillDeltaTime - Time.deltaTime

			if arg0.skillDeltaTime <= 0 then
				local var0 = false

				for iter0, iter1 in pairs(arg0.playingDatas) do
					if iter1.inPlaying then
						var0 = true
					end
				end

				if not var0 then
					for iter2, iter3 in pairs(arg0.playingDatas) do
						if #iter3.skillDatas > 0 then
							arg0:applyOrAddSkillData(iter3)

							break
						end
					end
				end
			end

			var89 = false

			for iter4, iter5 in pairs(arg0.playingDatas) do
				if iter5.inPlaying then
					var89 = true
				end
			end
		end,
		checkEmptySkillTime = function(arg0)
			if arg0.emptySkillTime and arg0.emptySkillTime <= 0 then
				arg0.emptySkillTime = var60
			end

			arg0.emptySkillTime = arg0.emptySkillTime - Time.deltaTime

			if arg0.emptySkillTime <= 0 then
				local var0 = false

				for iter0, iter1 in pairs(arg0.playingDatas) do
					if iter1.inPlaying then
						var0 = true
					end
				end

				if not var0 then
					local var1 = arg0:getRoleEmptySkill(arg0.rightRole)

					if var1 then
						arg0:addRolePlaying(arg0.rightRole, var1)
					end
				end
			end
		end,
		getRoleTestSkill = function(arg0, arg1)
			return arg1.skill[10]
		end,
		getRoleEmptySkill = function(arg0, arg1)
			local var0 = {}

			for iter0 = 1, #arg1.skill do
				local var1 = arg1.skill[iter0]

				if tobool(var1.special_time) == arg1.specialBody and var1.atk_index then
					table.insert(var0, var1)
				end
			end

			if #var0 > 0 then
				return Clone(var0[math.random(1, #var0)])
			end

			return nil
		end,
		onRoleSpecial = function(arg0, arg1)
			arg0.leftRole.specialTime = true

			for iter0 = 1, #arg0.leftRole.skill do
				local var0 = arg0.leftRole.skill[iter0]

				if var0.special_trigger then
					arg0:addRolePlaying(arg0.leftRole, Clone(var0))
				end
			end
		end,
		onRoleSpecialEnd = function(arg0)
			arg0.leftRole.specialTime = false

			local var0
			local var1

			for iter0 = 1, #arg0.leftRole.skill do
				local var2 = arg0.leftRole.skill[iter0]

				if var2.special_time and var2.power_index == 1 and var2.atk_index > 0 then
					var1 = Clone(var2)
				end

				if not var2.special_trigger and var2.special_end then
					var0 = Clone(var2)
				end
			end

			if var1 then
				arg0:addRolePlaying(arg0.leftRole, var1)
			end

			if var0 then
				arg0:addRolePlaying(arg0.leftRole, var0)
			end
		end,
		clear = function(arg0)
			if LeanTween.isTweening(go(arg0._leftRolePos)) then
				LeanTween.cancel(go(arg0._leftRolePos))
			end

			if LeanTween.isTweening(go(arg0._rightRolePos)) then
				LeanTween.cancel(go(arg0._rightRolePos))
			end

			if LeanTween.isTweening(go(arg0.rightRole.tf)) then
				LeanTween.cancel(go(arg0.rightRole.tf))
			end

			if LeanTween.isTweening(go(arg0.leftRole.tf)) then
				LeanTween.cancel(go(arg0.leftRole.tf))
			end
		end,
		onGridTrigger = function(arg0)
			local var0 = var23.grid_index
			local var1 = var23.power_grid
			local var2 = var23.special_time

			for iter0 = 1, #arg0.leftRole.skill do
				local var3 = arg0.leftRole.skill[iter0]

				if tobool(var3.special_time) == tobool(arg0.leftRole.specialTime) and var3.power_index == var1 and table.contains(var3.grid_index, var0) and var3.atk_index then
					arg0:addRolePlaying(arg0.leftRole, Clone(var3))
				end
			end
		end,
		createRole = function(arg0, arg1, arg2, arg3)
			local var0 = arg0:getRoleData(arg1)

			if not var0 then
				return nil
			end

			local var1 = {}
			local var2 = tf(instantiate(findTF(arg0._tpl, var0.name)))

			SetParent(var2, arg3)

			var2.anchoredPosition = Vector2(0, 0)
			var2.localScale = Vector3(1, 1, 1)

			setActive(var2, true)

			if var0.anim_init_pos then
				findTF(var2, "body/anim").anchoredPosition = var0.anim_init_pos
			end

			local var3 = findTF(var2, "body")
			local var4 = findTF(var3, "anim")
			local var5 = GetComponent(var4, typeof(Animator))
			local var6 = GetComponent(var4, typeof(DftAniEvent))

			var6:SetStartEvent(function()
				if var1.startCallback then
					var1.startCallback()
				end
			end)
			var6:SetTriggerEvent(function()
				if var1.triggerCallback then
					var1.triggerCallback()
				end
			end)
			var6:SetEndEvent(function()
				if var1.endCallback then
					var1.endCallback()
				end
			end)

			var1.name = var0.name
			var1.tf = var2
			var1.canvasGroup = GetComponent(var2, typeof(CanvasGroup))
			var1.body = var3
			var1.animTf = var4
			var1.animator = var5
			var1.dftEvent = var6
			var1.startCallback = nil
			var1.triggerCallback = nil
			var1.endCallback = nil
			var1.skill = var0.skill
			var1.name = var0.name
			var1.index = var0.index
			var1.actions = var0.actions

			return var1
		end,
		getRoleData = function(arg0, arg1)
			for iter0 = 1, #var87 do
				if var87[iter0].index == arg1 then
					return Clone(var87[iter0])
				end
			end

			return nil
		end,
		setDftHandle = function(arg0, arg1, arg2, arg3, arg4)
			arg1.startCallback = arg2
			arg1.triggerCallback = arg3
			arg1.endCallback = arg4
		end,
		playAnimation = function(arg0, arg1, arg2)
			arg1.animator:Play(arg2, -1, 0)
		end,
		addRolePlaying = function(arg0, arg1, arg2, arg3)
			for iter0, iter1 in pairs(arg0.playingDatas) do
				if iter0 == arg1.name then
					if arg3 then
						arg0:applyOrAddSkillData(iter1, arg2)
					else
						table.insert(iter1.skillDatas, arg2)

						if arg2.power_index > 0 and arg2.atk_index > 1 or arg2.special_trigger then
							for iter2 = #iter1.skillDatas - 1, 1, -1 do
								local var0 = iter1.skillDatas[iter2]

								if var0.power_index == 0 and var0.atk_index == 1 then
									local var1 = table.remove(iter1.skillDatas, iter2)

									if var1.score then
										arg0.addScore = {
											arg0.addScore[1] + var1.score[1],
											arg0.addScore[2] + var1.score[2]
										}
									end
								end
							end
						end
					end
				end
			end
		end,
		applyOrAddSkillData = function(arg0, arg1, arg2)
			if arg1.inPlaying then
				table.insert(arg1.skillDatas, arg2)

				return
			end

			arg1.inPlaying = true

			local var0 = arg1.role
			local var1 = arg2 or table.remove(arg1.skillDatas, 1)

			arg1.currentSkill = var1
			arg1.actions = var1.actions

			local var2 = var1.anim_bool

			if var2 then
				var0.animator:SetBool(var2, true)
			end

			if var0 == arg0.leftRole and not var1.dmg_index then
				arg0._leftRolePos:SetSiblingIndex(1)
			elseif var0 == arg0.rightRole and not var1.dmg_index then
				arg0._rightRolePos:SetSiblingIndex(1)
			end

			local var3 = var1.anim_init_pos

			if var3 then
				findTF(arg1.role.tf, "body/anim").anchoredPosition = var3
			end

			if var1.special_end then
				arg1.role.specialBody = false
			elseif var1.special_trigger then
				arg1.role.specialBody = true
			end

			arg1.actionIndex = 1

			arg0:checkAction(arg1, function()
				arg1.inPlaying = false

				arg0._event:emit(var16, {
					Vector2(0, 0),
					false
				})
			end)
		end,
		checkAction = function(arg0, arg1, arg2)
			if arg1.actions and arg1.actionIndex <= #arg1.actions then
				arg1.playingAction = arg1.actions[arg1.actionIndex]
				arg1.actionIndex = arg1.actionIndex + 1

				local var0 = arg1.playingAction.anim_name
				local var1 = arg1.playingAction.time
				local var2 = arg1.playingAction.move
				local var3 = arg1.playingAction.over_offset
				local var4 = arg1.playingAction.camera
				local var5 = arg1.playingAction.sound_start
				local var6 = arg1.playingAction.sound_trigger
				local var7 = arg1.playingAction.sound_end
				local var8 = arg1.currentSkill.special_trigger
				local var9 = arg1.currentSkill.special_time
				local var10 = arg1.currentSkill.atk_index

				if var8 or var9 and var10 and var10 >= 2 then
					arg0._event:emit(var22, true)
				end

				if var1 and var1 > 0 then
					-- block empty
				else
					local function var11()
						if var5 then
							pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/" .. var5)
						end

						if var2 then
							arg0:moveRole(arg1.role, var2)
						end

						if var4 then
							arg1.role.targetRole.canvasGroup.alpha = 0

							arg0._event:emit(var20, arg1)
						end
					end

					local function var12()
						if var6 then
							pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/" .. var6)
						end

						if var4 then
							var4 = false
							arg1.role.targetRole.canvasGroup.alpha = 1

							arg0._event:emit(var21)
						else
							local var0 = arg1.currentSkill.anim_trigger_pos

							if var0 then
								findTF(arg1.role.tf, "body/anim").anchoredPosition = var0
							end

							local var1 = arg1.currentSkill.atk_index

							if var1 then
								local var2 = arg0:getRoleDmgData(arg1.role.targetRole, var1)
								local var3 = arg1.role.targetRole.name

								if var2 then
									for iter0, iter1 in pairs(arg0.playingDatas) do
										if iter0 == var3 then
											arg0:applyOrAddSkillData(iter1, Clone(var2), true)
										end
									end
								end

								local var4 = arg1.currentSkill.score

								if var4 and arg1.role == arg0.leftRole then
									arg0._event:emit(var17, math.random(var4[1] + arg0.addScore[1], var4[2] + arg0.addScore[2]))

									arg0.addScore = {
										0,
										0
									}
								end
							end
						end
					end

					local function var13()
						if var7 then
							pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/" .. var7)
						end

						if LeanTween.isTweening(go(arg1.role.tf)) then
							LeanTween.cancel(go(arg1.role.tf))
						end

						local var0 = arg1.currentSkill.anim_end_pos

						if var0 then
							findTF(arg1.role.tf, "body/anim").anchoredPosition = var0
						end

						arg0._event:emit(var22, false)

						if var3 then
							arg1.role.tf.anchoredPosition = Vector2(arg1.role.tf.anchoredPosition.x + var3.x, arg1.role.tf.anchoredPosition.y + var3.y)
						end

						if arg1.currentSkill.special_trigger and var23.special_time and not var23.special_complete then
							var23.special_complete = true
						end

						arg1.playingAction = nil

						arg0:setDftHandle(arg1.role, nil, nil, nil)
						arg0:checkAction(arg1, arg2)
					end

					arg0:setDftHandle(arg1.role, var11, var12, var13)
					arg0:playAnimation(arg1.role, var0)
				end
			else
				local var14 = arg1.currentSkill.atk_index

				if var14 == 3 then
					local var15 = arg0:getRoleDmgBack(arg1.role.targetRole, var14)
					local var16 = arg1.role.targetRole.name

					if var15 then
						for iter0, iter1 in pairs(arg0.playingDatas) do
							if iter0 == var16 then
								arg0:applyOrAddSkillData(iter1, Clone(var15))
							end
						end
					end
				end

				if arg2 then
					arg2()
				end
			end
		end,
		moveRole = function(arg0, arg1, arg2)
			if LeanTween.isTweening(go(arg1.tf)) then
				LeanTween.cancel(go(arg1.tf))
			end

			if arg2.distance then
				arg0._event:emit(var16, {
					arg2.distance,
					arg1 == arg0.leftRole
				})
				LeanTween.move(arg1.tf, Vector3(arg2.distance.x, arg2.distance.y, 0), arg2.time):setEase(arg2.ease or LeanTweenType.linear)
			elseif arg2.distance_m then
				local var0 = Vector2(arg1.tf.anchoredPosition.x + arg2.distance_m.x, arg1.tf.anchoredPosition.y + arg2.distance_m.y)

				arg0._event:emit(var16, {
					var0,
					arg1 == arg0.leftRole
				})
				LeanTween.move(arg1.tf, Vector3(var0.x, var0.y, 0), arg2.time):setEase(arg2.ease or LeanTweenType.linear)
			end
		end,
		getRoleDmgData = function(arg0, arg1, arg2)
			local var0 = arg1.skill

			for iter0 = 1, #var0 do
				local var1 = var0[iter0]

				if var1.dmg_index == arg2 and var1.special_time == tobool(arg1.specialBody) then
					return var1
				end
			end

			return nil
		end,
		getRoleDmgBack = function(arg0, arg1, arg2)
			local var0 = arg1.skill

			for iter0 = 1, #var0 do
				local var1 = var0[iter0]

				if var1.dmg_back and var1.special_time == tobool(arg1.specialBody) then
					return var1
				end
			end

			return nil
		end
	}

	var0:ctor()

	return var0
end

function var0.getUIName(arg0)
	return "GridGameReUI"
end

function var0.didEnter(arg0)
	arg0:initEvent()
	arg0:initData()
	arg0:initUI()
	arg0:initGameUI()
	arg0:initController()
	arg0:updateMenuUI()
	arg0:openMenuUI()
end

function var0.initEvent(arg0)
	arg0:bind(var17, function(arg0, arg1, arg2)
		arg0:addScore(arg1)
	end)
	arg0:bind(var22, function(arg0, arg1, arg2)
		arg0.ignoreTime = arg1
	end)
end

function var0.onEventHandle(arg0, arg1)
	return
end

function var0.initData(arg0)
	local var0 = Application.targetFrameRate or 60

	if var0 > 60 then
		var0 = 60
	end

	arg0.timer = Timer.New(function()
		arg0:onTimer()
	end, 1 / var0, -1)
end

function var0.initUI(arg0)
	arg0.backSceneTf = findTF(arg0._tf, "scene_background")
	arg0.sceneTf = findTF(arg0._tf, "scene")
	arg0.clickMask = findTF(arg0._tf, "clickMask")

	setText(findTF(arg0._tf, "ui/gameUI/top/time"), i18n("mini_game_time"))
	setText(findTF(arg0._tf, "ui/gameUI/top/scoreDesc"), i18n("mini_game_score"))
	setText(findTF(arg0._tf, "pop/LeaveUI/ad/desc"), i18n("mini_game_leave"))
	setText(findTF(arg0._tf, "pop/pauseUI/ad/desc"), i18n("mini_game_pause"))
	setText(findTF(arg0._tf, "pop/SettleMentUI/ad/currentTextDesc"), i18n("mini_game_cur_score"))
	setText(findTF(arg0._tf, "pop/SettleMentUI/ad/highTextDesc"), i18n("mini_game_high_score"))

	arg0.countUI = findTF(arg0._tf, "pop/CountUI")
	arg0.countAnimator = GetComponent(findTF(arg0.countUI, "count"), typeof(Animator))
	arg0.countDft = GetOrAddComponent(findTF(arg0.countUI, "count"), typeof(DftAniEvent))

	arg0.countDft:SetTriggerEvent(function()
		return
	end)
	arg0.countDft:SetEndEvent(function()
		setActive(arg0.countUI, false)
		arg0:gameStart()
	end)

	arg0.leaveUI = findTF(arg0._tf, "pop/LeaveUI")

	onButton(arg0, findTF(arg0.leaveUI, "ad/btnOk"), function()
		arg0:resumeGame()
		arg0:onGameOver()
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.leaveUI, "ad/btnCancel"), function()
		arg0:resumeGame()
	end, SFX_CANCEL)

	arg0.pauseUI = findTF(arg0._tf, "pop/pauseUI")

	onButton(arg0, findTF(arg0.pauseUI, "ad/btnOk"), function()
		setActive(arg0.pauseUI, false)
		arg0:resumeGame()
	end, SFX_CANCEL)

	arg0.settlementUI = findTF(arg0._tf, "pop/SettleMentUI")

	onButton(arg0, findTF(arg0.settlementUI, "ad/btnOver"), function()
		setActive(arg0.settlementUI, false)
		arg0:openMenuUI()
	end, SFX_CANCEL)

	arg0.selectedUI = findTF(arg0._tf, "pop/selectedUI")
	arg0.leftSelectRole = {}

	for iter0 = 1, #var50 do
		local var0 = findTF(arg0.selectedUI, "ad/leftRole/role" .. var50[iter0])

		setActive(var0, true)

		local var1 = var50[iter0]

		onButton(arg0, var0, function()
			var46, var47 = arg0:checkRoleId(var1, var47, var51)

			arg0:updateSelectedUI()
		end, SFX_CONFIRM)
		table.insert(arg0.leftSelectRole, {
			id = var1,
			tf = var0
		})
	end

	onButton(arg0, findTF(arg0.selectedUI, "close"), function()
		setActive(arg0.selectedUI, false)
	end, SFX_CANCEL)

	arg0.rightSelectRole = {}

	for iter1 = 1, #var51 do
		local var2 = findTF(arg0.selectedUI, "ad/rightRole/role" .. var51[iter1])

		setActive(var2, true)

		local var3 = var51[iter1]

		onButton(arg0, var2, function()
			var47, var46 = arg0:checkRoleId(var3, var46, var50)

			arg0:updateSelectedUI()
		end, SFX_CONFIRM)
		table.insert(arg0.rightSelectRole, {
			id = var3,
			tf = var2
		})
	end

	onButton(arg0, findTF(arg0.selectedUI, "ad/btnOk"), function()
		setActive(arg0.selectedUI, false)
		setActive(arg0.menuUI, false)
		arg0:readyStart()
	end, SFX_CONFIRM)

	arg0.btnDay = findTF(arg0.selectedUI, "ad/btnDay")
	arg0.btnNight = findTF(arg0.selectedUI, "ad/btnNight")

	local var4 = arg0:getGameUsedTimes() or 0

	var70 = var53[var4 + 1] and var53[var4 + 1] or var69

	setActive(findTF(arg0.btnDay, "on"), var70 == var68)
	setActive(findTF(arg0.btnNight, "on"), var70 == var69)
	onButton(arg0, arg0.btnDay, function()
		var70 = var68

		setActive(findTF(arg0.btnDay, "on"), true)
		setActive(findTF(arg0.btnNight, "on"), false)
		arg0:updateMenuUI()
	end, SFX_CONFIRM)
	onButton(arg0, arg0.btnNight, function()
		var70 = var69

		setActive(findTF(arg0.btnDay, "on"), false)
		setActive(findTF(arg0.btnNight, "on"), true)
		arg0:updateMenuUI()
	end, SFX_CONFIRM)
	setActive(arg0.selectedUI, false)

	arg0.menuUI = findTF(arg0._tf, "pop/menuUI")
	arg0.battleScrollRect = GetComponent(findTF(arg0.menuUI, "battList"), typeof(ScrollRect))
	arg0.totalTimes = arg0:getGameTotalTime()

	local var5 = arg0:getGameUsedTimes() - 4 < 0 and 0 or arg0:getGameUsedTimes() - 4

	scrollTo(arg0.battleScrollRect, 0, 1 - var5 / (arg0.totalTimes - 4))
	onButton(arg0, findTF(arg0.menuUI, "rightPanelBg/arrowUp"), function()
		local var0 = arg0.battleScrollRect.normalizedPosition.y + 1 / (arg0.totalTimes - 4)

		if var0 > 1 then
			var0 = 1
		end

		scrollTo(arg0.battleScrollRect, 0, var0)
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "rightPanelBg/arrowDown"), function()
		local var0 = arg0.battleScrollRect.normalizedPosition.y - 1 / (arg0.totalTimes - 4)

		if var0 < 0 then
			var0 = 0
		end

		scrollTo(arg0.battleScrollRect, 0, var0)
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "btnBack"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "btnRule"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.ssss_game_tip.tip
		})
	end, SFX_CONFIRM)
	onButton(arg0, findTF(arg0.menuUI, "btnStart"), function()
		local var0 = arg0:getGameUsedTimes() or 0
		local var1 = arg0:getGameTimes() or 0

		if var0 >= var55 and arg0.selectedUI then
			arg0:updateSelectedUI()
			setActive(arg0.selectedUI, true)
		else
			local var2
			local var3 = var0 == 0 and 1 or var1 > 0 and var0 + 1 or var0

			var70 = var53[var0 + 1] and var53[var0 + 1] or 1

			if var3 > #var52 then
				var3 = #var52
			end

			local var4 = var52[var3]

			var46 = var4[1]
			var47 = var4[2]

			setActive(arg0.menuUI, false)
			arg0:readyStart()
		end
	end, SFX_CONFIRM)

	local var6 = findTF(arg0.menuUI, "tplBattleItem")

	arg0.battleItems = {}
	arg0.dropItems = {}

	for iter2 = 1, 7 do
		local var7 = tf(instantiate(var6))

		var7.name = "battleItem_" .. iter2

		setParent(var7, findTF(arg0.menuUI, "battList/Viewport/Content"))

		local var8 = iter2

		GetSpriteFromAtlasAsync(var6, "battleDesc" .. var8, function(arg0)
			setImageSprite(findTF(var7, "state_open/buttomDesc"), arg0, true)
			setImageSprite(findTF(var7, "state_clear/buttomDesc"), arg0, true)
			setImageSprite(findTF(var7, "state_current/buttomDesc"), arg0, true)
			setImageSprite(findTF(var7, "state_closed/buttomDesc"), arg0, true)
		end)
		setActive(var7, true)
		table.insert(arg0.battleItems, var7)
	end

	if not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)
	end

	UpdateBeat:AddListener(arg0.handle)
end

function var0.checkRoleId(arg0, arg1, arg2, arg3)
	local var0 = arg0:matchRoleId(arg1, arg2)
	local var1 = arg2

	if not var0 then
		for iter0 = 1, #arg3 do
			local var2 = arg3[iter0]

			if arg0:matchRoleId(arg1, var2) then
				return arg1, var2
			end
		end
	end

	return arg1, arg2
end

function var0.matchRoleId(arg0, arg1, arg2)
	if arg1 == arg2 then
		return false
	end

	for iter0 = 1, #var49 do
		local var0 = var49[iter0]

		if table.contains(var0, arg1) and table.contains(var0, arg2) then
			return false
		end
	end

	return true
end

function var0.initGameUI(arg0)
	arg0.gameUI = findTF(arg0._tf, "ui/gameUI")

	onButton(arg0, findTF(arg0.gameUI, "topRight/btnStop"), function()
		arg0:stopGame()
		setActive(arg0.pauseUI, true)
	end)
	onButton(arg0, findTF(arg0.gameUI, "btnLeave"), function()
		arg0:stopGame()
		setActive(arg0.leaveUI, true)
	end)

	arg0.gameTimeS = findTF(arg0.gameUI, "top/time/s")
	arg0.scoreTf = findTF(arg0.gameUI, "top/score")
	arg0.scoreAnimTf = findTF(arg0._tf, "sceneContainer/scene_front/scoreAnim")
	arg0.scoreAnimTextTf = findTF(arg0._tf, "sceneContainer/scene_front/scoreAnim/text")

	setActive(arg0.scoreAnimTf, false)
end

function var0.initController(arg0)
	local var0 = findTF(arg0.gameUI, "box")

	arg0.boxController = var88(var0, arg0)

	local var1 = findTF(arg0.gameUI, "specialPower")
	local var2 = findTF(arg0.gameUI, "successPower")

	arg0.specialController = var90(var1, var2, arg0)

	local var3 = findTF(arg0._tf, "sceneContainer")

	arg0.bgController = var91(var3, arg0.gameUI, arg0)

	local var4 = findTF(arg0._tf, "sceneContainer/scene")

	arg0.roleController = var92(var4, arg0)
end

function var0.Update(arg0)
	arg0:AddDebugInput()
end

function var0.AddDebugInput(arg0)
	if arg0.gameStop or arg0.settlementFlag then
		return
	end

	if IsUnityEditor then
		-- block empty
	end
end

function var0.updateSelectedUI(arg0)
	for iter0 = 1, #arg0.leftSelectRole do
		local var0 = arg0.leftSelectRole[iter0]

		if var46 == var0.id then
			setActive(findTF(var0.tf, "selected"), true)
			setActive(findTF(var0.tf, "unSelected"), false)
		else
			setActive(findTF(var0.tf, "selected"), false)
			setActive(findTF(var0.tf, "unSelected"), true)
		end
	end

	for iter1 = 1, #arg0.rightSelectRole do
		local var1 = arg0.rightSelectRole[iter1]

		setGray(var1.tf, not arg0:matchRoleId(var46, var1.id), true)

		if var47 == var1.id then
			setActive(findTF(var1.tf, "selected"), true)
			setActive(findTF(var1.tf, "unSelected"), false)
		else
			setActive(findTF(var1.tf, "selected"), false)
			setActive(findTF(var1.tf, "unSelected"), true)
		end
	end
end

function var0.updateMenuUI(arg0)
	local var0 = arg0:getGameUsedTimes()

	if var0 and var0 >= 7 then
		setActive(findTF(arg0.menuUI, "btnStart/free"), true)
	else
		setActive(findTF(arg0.menuUI, "btnStart/free"), false)
	end

	local var1 = arg0:getGameTimes()

	for iter0 = 1, #arg0.battleItems do
		setActive(findTF(arg0.battleItems[iter0], "state_open"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_closed"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_clear"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_current"), false)

		if iter0 <= var0 then
			setActive(findTF(arg0.battleItems[iter0], "state_clear"), true)
		elseif iter0 == var0 + 1 and var1 >= 1 then
			setActive(findTF(arg0.battleItems[iter0], "state_current"), true)
		elseif var0 < iter0 and iter0 <= var0 + var1 then
			setActive(findTF(arg0.battleItems[iter0], "state_open"), true)
		else
			setActive(findTF(arg0.battleItems[iter0], "state_closed"), true)
		end
	end

	arg0.totalTimes = arg0:getGameTotalTime()

	local var2 = 1 - (arg0:getGameUsedTimes() - 3 < 0 and 0 or arg0:getGameUsedTimes() - 3) / (arg0.totalTimes - 4)

	if var2 > 1 then
		var2 = 1
	end

	scrollTo(arg0.battleScrollRect, 0, var2)
	setActive(findTF(arg0.menuUI, "btnStart/tip"), var1 > 0)

	local var3

	if var70 == var68 then
		var3 = var65
	elseif var70 == var69 then
		var3 = var66
	end

	for iter1, iter2 in ipairs(var64) do
		local var4 = findTF(arg0._tf, "bg/" .. iter2)

		setActive(var4, table.contains(var3, iter2))
	end

	setActive(findTF(arg0.menuUI, "bg/title_day"), var70 == var68)
	setActive(findTF(arg0.menuUI, "bg/title_night"), var70 ~= var68)
	arg0:CheckGet()
end

function var0.CheckGet(arg0)
	setActive(findTF(arg0.menuUI, "got"), false)

	if arg0:getUltimate() and arg0:getUltimate() ~= 0 then
		setActive(findTF(arg0.menuUI, "got"), true)
	end

	if arg0:getUltimate() == 0 then
		if arg0:getGameTotalTime() > arg0:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0.menuUI, "got"), true)
	end
end

function var0.openMenuUI(arg0)
	setActive(findTF(arg0._tf, "sceneContainer/scene_front"), false)
	setActive(findTF(arg0._tf, "sceneContainer/scene_background"), false)
	setActive(findTF(arg0._tf, "sceneContainer/scene"), false)
	setActive(arg0.gameUI, false)
	setActive(arg0.menuUI, true)
	setActive(arg0.selectedUI, false)
	arg0:updateMenuUI()

	local var0 = arg0:getBGM()

	if not var0 then
		if pg.CriMgr.GetInstance():IsDefaultBGM() then
			var0 = pg.voice_bgm.NewMainScene.default_bgm
		else
			var0 = pg.voice_bgm.NewMainScene.bgm
		end
	end

	if arg0.bgm ~= var0 then
		arg0.bgm = var0

		pg.BgmMgr.GetInstance():Push(arg0.__cname, var0)
	end
end

function var0.clearUI(arg0)
	setActive(arg0.sceneTf, false)
	setActive(arg0.settlementUI, false)
	setActive(arg0.countUI, false)
	setActive(arg0.menuUI, false)
	setActive(arg0.gameUI, false)
	setActive(arg0.selectedUI, false)
end

function var0.readyStart(arg0)
	setActive(arg0.countUI, true)
	arg0.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var3)

	if var2 and arg0.bgm ~= var2 then
		arg0.bgm = var2

		pg.BgmMgr.GetInstance():Push(arg0.__cname, var2)
	end
end

function var0.gameStart(arg0)
	setActive(findTF(arg0._tf, "sceneContainer/scene_front"), true)
	setActive(findTF(arg0._tf, "sceneContainer/scene_background"), true)
	setActive(findTF(arg0._tf, "sceneContainer/scene"), true)
	setActive(arg0.scoreAnimTf, false)
	setActive(arg0.gameUI, true)

	arg0.gameStartFlag = true
	arg0.scoreNum = 0
	arg0.playerPosIndex = 2
	arg0.gameStepTime = 0
	arg0.gameTime = var7
	arg0.ignoreTime = false

	arg0.boxController:start()
	arg0.specialController:start()
	arg0.bgController:start()
	arg0.roleController:start()
	arg0:updateGameUI()
	arg0:timerStart()
end

function var0.getGameTimes(arg0)
	return arg0:GetMGHubData().count
end

function var0.getGameUsedTimes(arg0)
	return arg0:GetMGHubData().usedtime
end

function var0.getUltimate(arg0)
	return arg0:GetMGHubData().ultimate
end

function var0.getGameTotalTime(arg0)
	return (arg0:GetMGHubData():getConfig("reward_need"))
end

function var0.changeSpeed(arg0, arg1)
	return
end

function var0.onTimer(arg0)
	arg0:gameStep()
end

function var0.gameStep(arg0)
	if not arg0.ignoreTime then
		arg0.gameTime = arg0.gameTime - Time.deltaTime

		if arg0.gameTime < 0 then
			arg0.gameTime = 0
		end

		arg0.gameStepTime = arg0.gameStepTime + Time.deltaTime
	end

	arg0.boxController:step()
	arg0.specialController:step()
	arg0.bgController:step()
	arg0.roleController:step()
	arg0:updateGameUI()

	if arg0.gameTime <= 0 then
		arg0:onGameOver()

		return
	end
end

function var0.timerStart(arg0)
	if not arg0.timer.running then
		arg0.timer:Start()
	end
end

function var0.timerStop(arg0)
	if arg0.timer.running then
		arg0.timer:Stop()
	end
end

function var0.updateGameUI(arg0)
	setText(arg0.scoreTf, arg0.scoreNum)
	setText(arg0.gameTimeS, math.ceil(arg0.gameTime))
end

function var0.addScore(arg0, arg1)
	setActive(arg0.scoreAnimTf, false)
	setActive(arg0.scoreAnimTf, true)
	setText(arg0.scoreAnimTextTf, "+" .. tostring(arg1))

	arg0.scoreNum = arg0.scoreNum + arg1

	if arg0.scoreNum < 0 then
		arg0.scoreNum = 0
	end
end

function var0.onGameOver(arg0)
	if arg0.settlementFlag then
		return
	end

	arg0:timerStop()

	arg0.settlementFlag = true

	setActive(arg0.clickMask, true)

	if arg0.roleController then
		arg0.roleController:clear()
	end

	if arg0.bgController then
		arg0.bgController:clear()
	end

	LeanTween.delayedCall(go(arg0._tf), 0.1, System.Action(function()
		arg0.settlementFlag = false
		arg0.gameStartFlag = false

		setActive(arg0.clickMask, false)
		arg0:showSettlement()
	end))
end

function var0.showSettlement(arg0)
	setActive(arg0.settlementUI, true)
	GetComponent(findTF(arg0.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0 = arg0:GetMGData():GetRuntimeData("elements")
	local var1 = arg0.scoreNum
	local var2 = var0 and #var0 > 0 and var0[1] or 0

	setActive(findTF(arg0.settlementUI, "ad/new"), var2 < var1)

	if var2 <= var1 then
		var2 = var1

		arg0:StoreDataToServer({
			var2
		})
	end

	local var3 = findTF(arg0.settlementUI, "ad/highText")
	local var4 = findTF(arg0.settlementUI, "ad/currentText")

	setText(var3, var2)
	setText(var4, var1)

	if arg0:getGameTimes() and arg0:getGameTimes() > 0 then
		arg0.sendSuccessFlag = true

		arg0:SendSuccess(0)
	end
end

function var0.resumeGame(arg0)
	arg0.gameStop = false

	setActive(arg0.leaveUI, false)
	arg0:changeSpeed(1)
	arg0:timerStart()
end

function var0.stopGame(arg0)
	arg0.gameStop = true

	arg0:timerStop()
	arg0:changeSpeed(0)
end

function var0.onBackPressed(arg0)
	if not arg0.gameStartFlag then
		arg0:emit(var0.ON_BACK_PRESSED)
	else
		if arg0.settlementFlag then
			return
		end

		if isActive(arg0.pauseUI) then
			setActive(arg0.pauseUI, false)
		end

		arg0:stopGame()
		setActive(arg0.leaveUI, true)
	end
end

function var0.willExit(arg0)
	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)
	end

	if arg0._tf and LeanTween.isTweening(go(arg0._tf)) then
		LeanTween.cancel(go(arg0._tf))
	end

	if arg0.timer and arg0.timer.running then
		arg0.timer:Stop()
	end

	Time.timeScale = 1
	arg0.timer = nil
end

return var0
