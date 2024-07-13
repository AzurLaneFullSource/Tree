local var0_0 = class("GridGameReView", import("..BaseMiniGameView"))
local var1_0 = false
local var2_0 = "battle-boss-4"
local var3_0 = "event:/ui/ddldaoshu2"
local var4_0 = "event:/ui/niujiao"
local var5_0 = "event:/ui/taosheng"
local var6_0 = "ui/minigameui/gridgameui_atlas"
local var7_0 = 60
local var8_0 = "mini_game_time"
local var9_0 = "mini_game_score"
local var10_0 = "mini_game_leave"
local var11_0 = "mini_game_pause"
local var12_0 = "mini_game_cur_score"
local var13_0 = "mini_game_high_score"
local var14_0 = "event grid combo"
local var15_0 = "event grid trigger"
local var16_0 = "event move role"
local var17_0 = "event add score"
local var18_0 = "event role special"
local var19_0 = "event special end"
local var20_0 = "event camera in"
local var21_0 = "event camedra out"
local var22_0 = "event ignore time"
local var23_0 = {
	power_grid = 0,
	grid_index = 0,
	special_time = false,
	special_complete = false
}
local var24_0 = 12
local var25_0 = 0.3
local var26_0 = Vector2(138, 150)
local var27_0 = 2500
local var28_0 = 0
local var29_0 = 100
local var30_0 = 1
local var31_0 = 2
local var32_0 = 3
local var33_0 = {
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
local var34_0 = {
	1,
	2,
	3
}
local var35_0 = {
	{
		rule = var30_0
	},
	{
		id = 999,
		rule = var31_0
	},
	{
		rule = var32_0
	}
}
local var36_0 = {
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
local var37_0 = 0.5
local var38_0 = 50
local var39_0 = 3
local var40_0 = 150
local var41_0 = 1.5
local var42_0 = 500
local var43_0 = 260
local var44_0 = 50
local var45_0 = 3400
local var46_0 = 5
local var47_0 = 4
local var48_0 = {
	1,
	2,
	3,
	4,
	5
}
local var49_0 = {
	{
		1,
		5
	}
}
local var50_0 = {
	1,
	2,
	5
}
local var51_0 = {
	1,
	2,
	5,
	3,
	4
}
local var52_0 = {
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
local var53_0 = {
	2,
	1,
	1,
	2,
	2,
	1,
	2
}
local var54_0 = {}
local var55_0 = 7
local var56_0 = Vector2(0, 0)
local var57_0 = 0.07
local var58_0 = 0.3
local var59_0 = 0.5
local var60_0 = 5
local var61_0 = "sound start"
local var62_0 = "sound trigger"
local var63_0 = "sound end"
local var64_0 = {
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
local var65_0 = {
	"bg00",
	"bg01",
	"bg02",
	"bg03",
	"bg04"
}
local var66_0 = {
	"bg10",
	"bg11",
	"bg12",
	"bg13",
	"bg14"
}
local var67_0 = 0
local var68_0 = 1
local var69_0 = 2
local var70_0 = var68_0
local var71_0 = {
	{
		rate = 0.05,
		source = "scene_background/bg00",
		type = var68_0
	},
	{
		rate = 0.1,
		source = "scene_background/bg01",
		type = var68_0
	},
	{
		rate = 0.2,
		source = "scene_background/bg02",
		type = var68_0
	},
	{
		rate = 0.8,
		source = "scene_background/bg03",
		type = var68_0
	},
	{
		rate = 0.05,
		source = "scene_background/bg10",
		type = var69_0
	},
	{
		rate = 0.1,
		source = "scene_background/bg11",
		type = var69_0
	},
	{
		rate = 0.2,
		source = "scene_background/bg12",
		type = var69_0
	},
	{
		rate = 0.8,
		source = "scene_background/bg13",
		type = var69_0
	},
	{
		rate = 1.2,
		source = "scene_front/bg04",
		type = var68_0
	},
	{
		rate = 1.2,
		source = "scene_front/bg14",
		type = var69_0
	},
	{
		rate = 1,
		source = "scene/rolePos",
		type = var67_0
	}
}
local var72_0 = {
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
local var73_0 = {
	n_Move_R = {
		time = 0,
		anim_name = var72_0.n_MoveR,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(650, 0, 0)
		}
	},
	n_Atk = {
		time = 0,
		sound_trigger = "taosheng",
		anim_name = var72_0.n_Atk,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(650, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	n_Move_L = {
		time = 0,
		anim_name = var72_0.n_MoveL,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0)
		}
	},
	n_Skill_1 = {
		time = 0,
		sound_trigger = "jiguang",
		anim_name = var72_0.n_Skill_1
	},
	n_Skill_2 = {
		time = 0,
		sound_trigger = "guangjian",
		anim_name = var72_0.n_Skill_2,
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
		anim_name = var72_0.n_Skill_3
	},
	n_Combine = {
		sound_start = "bianshen",
		time = 0,
		camera = true,
		anim_name = var72_0.n_Combine
	},
	n_DMG = {
		time = 0,
		anim_name = var72_0.n_DMG,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance_m = Vector3(-150, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	n_DMG_S = {
		time = 0,
		anim_name = var72_0.n_DMG
	},
	n_DMG_Back_R = {
		time = 0,
		anim_name = var72_0.n_MoveR,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0)
		}
	},
	n_Neutral = {
		time = 0,
		anim_name = var72_0.n_Neutral
	},
	c_Atk = {
		time = 0,
		sound_trigger = "taosheng",
		anim_name = var72_0.c_Atk,
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
		anim_name = var72_0.c_Skill_1
	},
	c_Dmg = {
		time = 0,
		anim_name = var72_0.c_Dmg,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance_m = Vector3(-150, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	c_Dmg_S = {
		time = 0,
		anim_name = var72_0.c_Dmg
	},
	c_MoveL = {
		time = 0,
		anim_name = var72_0.c_MoveL,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0)
		}
	},
	c_MoveR = {
		time = 0,
		anim_name = var72_0.c_MoveR,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(650, 0, 0)
		}
	},
	c_DMG_Back_R = {
		time = 0,
		anim_name = var72_0.c_MoveR,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0)
		}
	},
	c_Neutral = {
		time = 0,
		anim_name = var72_0.c_Neutral
	}
}
local var74_0 = {
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
			var73_0.n_Atk,
			var73_0.n_Move_L
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
			var73_0.n_Skill_1
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
			var73_0.n_Skill_2,
			var73_0.n_Move_L
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
			var73_0.n_Skill_3
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
			var73_0.n_DMG,
			var73_0.n_DMG_Back_R
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
			var73_0.n_DMG_S
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
			var73_0.n_DMG_Back_R
		}
	},
	{
		dmg_index = 3,
		name = "DMGN",
		special_time = false,
		actions = {
			var73_0.n_DMG
		}
	},
	{
		name = "DMG_BACK",
		special_time = false,
		dmg_back = true,
		actions = {
			var73_0.n_DMG_Back_R
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
			var73_0.n_Combine
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
			var73_0.c_Atk,
			var73_0.c_MoveL
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
			var73_0.c_Skill_1
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
			var73_0.c_Skill_1
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
			var73_0.c_Skill_1
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
			var73_0.c_Dmg,
			var73_0.c_DMG_Back_R
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
			var73_0.c_Dmg_S
		}
	},
	{
		dmg_index = 3,
		name = "DMGN",
		special_time = false,
		actions = {
			var73_0.c_DMG
		}
	},
	{
		name = "DMG_BACK",
		special_time = false,
		dmg_back = true,
		actions = {
			var73_0.c_DMG_Back_R
		}
	}
}
local var75_0 = {
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
local var76_0 = {
	n_Move_R = {
		time = 0,
		anim_name = var75_0.n_MoveR,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(500, 0, 0)
		}
	},
	n_Atk = {
		time = 0,
		sound_trigger = "taosheng",
		anim_name = var75_0.n_Atk,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(600, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	n_Move_L = {
		time = 0,
		anim_name = var75_0.n_MoveL,
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
		anim_name = var75_0.n_Skill_1,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(600, 0, 0)
		}
	},
	n_Skill_2 = {
		time = 0,
		sound_trigger = "baozha2",
		anim_name = var75_0.n_Skill_2
	},
	n_Skill_3 = {
		time = 0,
		sound_trigger = "baozha2",
		anim_name = var75_0.n_Skill_3,
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
		anim_name = var75_0.n_Combine
	},
	n_DMG = {
		time = 0,
		anim_name = var75_0.n_DMG,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance_m = Vector3(-150, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	n_DMG_S = {
		time = 0,
		anim_name = var75_0.n_DMG
	},
	n_DMG_Back_R = {
		time = 0,
		anim_name = var75_0.n_MoveR,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0)
		}
	},
	n_Neutral = {
		time = 0,
		anim_name = var75_0.n_Neutral
	},
	c_Atk = {
		time = 0,
		sound_trigger = "taosheng",
		anim_name = var75_0.c_Atk,
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
		anim_name = var75_0.c_Skill_1
	},
	c_Dmg = {
		time = 0,
		anim_name = var75_0.c_Dmg,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance_m = Vector3(-150, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	c_Dmg_S = {
		time = 0,
		anim_name = var75_0.c_Dmg
	},
	c_MoveL = {
		time = 0,
		anim_name = var75_0.c_MoveL,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	c_MoveR = {
		time = 0,
		anim_name = var75_0.c_MoveR,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(650, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	c_DMG_Back_R = {
		time = 0,
		anim_name = var75_0.c_MoveR,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	c_Neutral = {
		time = 0,
		anim_name = var75_0.c_Neutral
	}
}
local var77_0 = {
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
			var76_0.n_Atk,
			var76_0.n_Move_L
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
			var76_0.n_Move_R,
			var76_0.n_Skill_1,
			var76_0.n_Move_L
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
			var76_0.n_Skill_2
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
			var76_0.n_Skill_3,
			var76_0.n_Move_L
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
			var76_0.n_DMG,
			var76_0.n_DMG_Back_R
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
			var76_0.n_DMG_S
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
			var76_0.n_DMG_Back_R
		}
	},
	{
		dmg_index = 3,
		name = "DMGN",
		special_time = false,
		actions = {
			var76_0.n_DMG
		}
	},
	{
		name = "DMG_BACK",
		special_time = false,
		dmg_back = true,
		actions = {
			var76_0.n_DMG_Back_R
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
			var76_0.n_Combine
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
			var76_0.c_Atk,
			var76_0.c_MoveL
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
			var76_0.c_Skill_1
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
			var76_0.c_Skill_1
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
			var76_0.c_Skill_1
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
			var76_0.c_Dmg,
			var76_0.c_DMG_Back_R
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
			var76_0.c_Dmg_S
		}
	},
	{
		dmg_index = 3,
		name = "DMGN",
		special_time = false,
		actions = {
			var76_0.c_DMG
		}
	},
	{
		name = "DMG_BACK",
		special_time = false,
		dmg_back = true,
		actions = {
			var76_0.c_DMG_Back_R
		}
	}
}
local var78_0 = {
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
local var79_0 = {
	n_Move_R = {
		time = 0,
		anim_name = var78_0.n_MoveR,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(650, 0, 0)
		}
	},
	n_Atk = {
		time = 0,
		sound_trigger = "taosheng",
		anim_name = var78_0.n_Atk,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(650, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	n_Move_L = {
		time = 0,
		anim_name = var78_0.n_MoveL,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0)
		}
	},
	n_Skill_1 = {
		time = 0,
		sound_trigger = "jiguang",
		anim_name = var78_0.n_Skill_1
	},
	n_Skill_2 = {
		time = 0,
		sound_trigger = "guangjian",
		anim_name = var78_0.n_Skill_2,
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
		anim_name = var78_0.n_Skill_3
	},
	n_Combine = {
		sound_start = "bianshen",
		time = 0,
		camera = true,
		anim_name = var78_0.n_Combine,
		camera_pos = Vector2(0, 0)
	},
	n_DMG = {
		time = 0,
		anim_name = var78_0.n_DMG,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance_m = Vector3(-150, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	n_DMG_S = {
		time = 0,
		anim_name = var78_0.n_DMG
	},
	n_DMG_Back_R = {
		time = 0,
		anim_name = var78_0.n_MoveR,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0)
		}
	},
	n_Neutral = {
		time = 0,
		anim_name = var78_0.n_Neutral
	},
	c_Atk = {
		time = 0,
		sound_trigger = "taosheng",
		anim_name = var78_0.c_Atk,
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
		anim_name = var78_0.c_Skill_1
	},
	c_Dmg = {
		time = 0,
		anim_name = var78_0.c_Dmg,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance_m = Vector3(-150, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	c_Dmg_S = {
		time = 0,
		anim_name = var78_0.c_Dmg
	},
	c_MoveL = {
		time = 0,
		anim_name = var78_0.c_MoveL,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0)
		}
	},
	c_MoveR = {
		time = 0,
		anim_name = var78_0.c_MoveR,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(650, 0, 0)
		}
	},
	c_DMG_Back_R = {
		time = 0,
		anim_name = var78_0.c_MoveR,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0)
		}
	},
	c_Neutral = {
		time = 0,
		anim_name = var78_0.c_Neutral
	}
}
local var80_0 = {
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
			var79_0.n_Atk,
			var79_0.n_Move_L
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
			var79_0.n_Skill_1
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
			var79_0.n_Skill_2,
			var79_0.n_Move_L
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
			var79_0.n_Skill_3
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
			var79_0.n_DMG,
			var79_0.n_DMG_Back_R
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
			var79_0.n_DMG_S
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
			var79_0.n_DMG_Back_R
		},
		anim_init_pos = Vector2(586, 471)
	},
	{
		dmg_index = 3,
		name = "DMGN",
		special_time = false,
		actions = {
			var79_0.DMG
		}
	},
	{
		name = "DMG_BACK",
		special_time = false,
		dmg_back = true,
		actions = {
			var79_0.DMG_Back_R
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
			var79_0.n_Combine
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
			var79_0.c_Atk,
			var79_0.c_MoveL
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
			var79_0.c_Skill_1
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
			var79_0.c_Skill_1
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
			var79_0.c_Skill_1
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
			var79_0.c_Dmg,
			var79_0.c_DMG_Back_R
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
			var79_0.c_Dmg_S
		}
	},
	{
		dmg_index = 3,
		name = "DMGN",
		special_time = false,
		actions = {
			var79_0.DMG
		}
	},
	{
		name = "DMG_BACK",
		special_time = false,
		dmg_back = true,
		actions = {
			var79_0.DMG_Back_R
		}
	}
}
local var81_0 = {
	Neutral = "Neutral",
	Skill_1 = "skill_1",
	Skill_2 = "skill_2",
	Atk = "ATK",
	MoveL = "MoveL",
	DMG = "DMG",
	MoveR = "MoveR"
}
local var82_0 = {
	Move_R = {
		time = 0,
		anim_name = var81_0.MoveR,
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
		anim_name = var81_0.Atk,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(600, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	Move_L = {
		time = 0,
		anim_name = var81_0.MoveL,
		move = {
			time = 0.4,
			distance = Vector3(0, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	Skill_1 = {
		time = 0,
		sound_trigger = "jiguang",
		anim_name = var81_0.Skill_1
	},
	Skill_2 = {
		time = 0,
		sound_trigger = "baozha2",
		anim_name = var81_0.Skill_2,
		over_offset = Vector2(115, 0)
	},
	DMG = {
		time = 0,
		anim_name = var81_0.DMG,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance_m = Vector3(-150, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	DMG_Back_R = {
		time = 0,
		anim_name = var81_0.MoveR,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	DMG_S = {
		time = 0,
		anim_name = var81_0.DMG
	},
	Neutral = {
		time = 0,
		anim_name = var81_0.Neutral
	}
}
local var83_0 = {
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
			var82_0.Atk,
			var82_0.Move_L
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
			var82_0.Skill_1
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
			var82_0.Move_R,
			var82_0.Skill_2,
			var82_0.Move_L
		}
	},
	{
		dmg_index = 2,
		name = "DMG",
		special_time = false,
		actions = {
			var82_0.DMG,
			var82_0.DMG_Back_R
		}
	},
	{
		dmg_index = 1,
		name = "DMG_Stand",
		special_time = false,
		actions = {
			var82_0.DMG_S
		}
	},
	{
		dmg_index = 3,
		name = "DMGN",
		special_time = false,
		actions = {
			var82_0.DMG
		}
	},
	{
		name = "DMG_BACK",
		special_time = false,
		dmg_back = true,
		actions = {
			var82_0.DMG_Back_R
		}
	}
}
local var84_0 = {
	Neutral = "Neutral",
	Skill_1 = "skill_1",
	Skill_2 = "skill_2",
	Atk = "ATK",
	MoveL = "MoveL",
	DMG = "DMG",
	MoveR = "MoveR"
}
local var85_0 = {
	Move_R = {
		time = 0,
		anim_name = var84_0.MoveR,
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
		anim_name = var84_0.Atk,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(600, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	Move_L = {
		time = 0,
		anim_name = var84_0.MoveL,
		move = {
			time = 0.4,
			distance = Vector3(0, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	Skill_1 = {
		time = 0,
		sound_trigger = "jiguang",
		anim_name = var84_0.Skill_1
	},
	Skill_2 = {
		time = 0,
		sound_trigger = "baozha2",
		anim_name = var84_0.Skill_2,
		over_offset = Vector2(264, 0)
	},
	DMG = {
		time = 0,
		anim_name = var84_0.DMG,
		move = {
			time = 0.3,
			distance_m = Vector3(-150, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	DMG_Back_R = {
		time = 0,
		anim_name = var84_0.MoveR,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	DMG_S = {
		time = 0,
		anim_name = var84_0.DMG
	},
	Neutral = {
		time = 0,
		anim_name = var84_0.Neutral
	}
}
local var86_0 = {
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
			var85_0.Atk,
			var85_0.Move_L
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
			var85_0.Skill_1
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
			var85_0.Skill_2,
			var85_0.Move_L
		}
	},
	{
		dmg_index = 2,
		name = "DMG",
		special_time = false,
		actions = {
			var85_0.DMG,
			var85_0.DMG_Back_R
		}
	},
	{
		dmg_index = 1,
		name = "DMG_Stand",
		special_time = false,
		actions = {
			var85_0.DMG_S
		}
	},
	{
		dmg_index = 3,
		name = "DMGN",
		special_time = false,
		actions = {
			var85_0.DMG
		}
	},
	{
		name = "DMG_BACK",
		special_time = false,
		dmg_back = true,
		actions = {
			var85_0.DMG_Back_R
		}
	}
}
local var87_0 = {
	{
		index = 1,
		name = "role1",
		skill = var74_0,
		actions = var73_0
	},
	{
		index = 2,
		name = "role2",
		skill = var77_0,
		actions = var76_0
	},
	{
		index = 3,
		name = "enemy1",
		skill = var83_0,
		actions = var82_0
	},
	{
		index = 4,
		name = "enemy2",
		skill = var86_0,
		actions = var85_0
	},
	{
		index = 5,
		name = "role3",
		skill = var80_0,
		actions = var79_0,
		anim_init_pos = Vector2(586, 411)
	}
}

local function var88_0(arg0_1, arg1_1)
	local var0_1 = {
		ctor = function(arg0_2)
			arg0_2._boxTf = arg0_1
			arg0_2._event = arg1_1

			arg0_2._event:bind(var15_0, function()
				local var0_3 = var23_0.power_grid

				if var0_3 and var0_3 > 0 and var35_0[var0_3] then
					local var1_3 = var35_0[var0_3]
					local var2_3 = var1_3.rule
					local var3_3 = var1_3.id and var1_3.id or var0_3

					table.insert(arg0_2.ruleGridList, {
						id = var3_3,
						rule = var2_3
					})
				end
			end)

			arg0_2._gridEffect = findTF(arg0_2._boxTf, "effectGrid")
			arg0_2._content = findTF(arg0_2._boxTf, "viewport/content")
			arg0_2.tplGrid = findTF(arg0_1, "tplGrid")

			setActive(arg0_2.tplGrid, false)

			arg0_2.grids = {}
			arg0_2.effects = {}
			arg0_2.combo = 0
			arg0_2.ruleGridList = {}

			for iter0_2 = 1, var24_0 do
				local var0_2 = tf(instantiate(arg0_2._gridEffect))

				setParent(var0_2, arg0_2._content)
				setActive(var0_2, false)

				var0_2.anchoredPosition = Vector2(var26_0.x * iter0_2 - var26_0.x / 2, var26_0.y / 2)

				table.insert(arg0_2.effects, var0_2)
			end
		end,
		start = function(arg0_4)
			arg0_4.comboCheck = false

			arg0_4:initGrids(false)

			for iter0_4 = 1, #arg0_4.effects do
				setActive(arg0_4.effects[iter0_4], false)
			end
		end,
		step = function(arg0_5)
			if arg0_5.takeAwayTime and arg0_5.takeAwayTime > 0 then
				arg0_5.takeAwayTime = arg0_5.takeAwayTime - Time.deltaTime

				return
			end

			arg0_5.gridCreateIndex = 1

			local var0_5 = false

			for iter0_5 = 1, #arg0_5.grids do
				local var1_5 = arg0_5.grids[iter0_5]
				local var2_5 = iter0_5

				if not var1_5.moveAble then
					var0_5 = var0_5 or true

					local var3_5 = (iter0_5 - 1) * var26_0.x

					if var3_5 < var1_5.tf.anchoredPosition.x then
						var1_5.tf.anchoredPosition = Vector2(var1_5.tf.anchoredPosition.x - var1_5.speed * Time.deltaTime, 0)

						if var1_5.speed < var27_0 then
							var1_5.speed = var1_5.speed + var29_0
						end
					end

					if var3_5 >= var1_5.tf.anchoredPosition.x then
						var1_5.speed = 0
						var1_5.moveAble = true

						if var3_5 > var1_5.tf.anchoredPosition.x then
							var1_5.tf.anchoredPosition = Vector2(var3_5, 0)
						end
					end
				end

				if not var1_5.eventAble then
					GetComponent(var1_5.tf, typeof(EventTriggerListener)):AddPointDownFunc(function()
						if arg0_5.comboCheck == false then
							local var0_6, var1_6 = arg0_5:triggerDownGrid(var2_5)

							if #var0_6 >= 2 then
								arg0_5.comboCheck = true

								local var2_6 = arg0_5:getGridDouble(var0_6)

								arg0_5:takeAwayGrid(var0_6)
								arg0_5:insertGrids()

								for iter0_6 = 1, #var1_6 do
									local var3_6 = var1_6[iter0_6].index
									local var4_6 = var1_6[iter0_6].count

									arg0_5._event:emit(var14_0, {
										series = var4_6,
										combo = arg0_5.combo,
										index = var3_6,
										double = var2_6
									})
								end

								arg0_5.combo = arg0_5.combo + 1
							else
								arg0_5.comboCheck = true

								arg0_5:takeAwayGrid({
									var2_5
								})
								arg0_5:insertGrids()
							end
						end
					end)

					var1_5.eventAble = true
				end
			end

			if not var0_5 and arg0_5.comboCheck then
				local var4_5 = arg0_5:getSeriesGrids()

				if #var4_5 > 0 then
					local var5_5 = {}

					for iter1_5 = 1, #var4_5 do
						local var6_5 = var4_5[iter1_5].series
						local var7_5 = var4_5[iter1_5].index
						local var8_5 = var4_5[iter1_5].double

						for iter2_5 = 1, #var6_5 do
							table.insert(var5_5, var6_5[iter2_5])
						end

						local var9_5 = arg0_5:getGridDouble(var6_5)

						arg0_5._event:emit(var14_0, {
							series = #var6_5,
							combo = arg0_5.combo,
							index = var7_5,
							double = var9_5
						})
					end

					arg0_5:clearGridSeriesAble()
					arg0_5:takeAwayGrid(var5_5)
					arg0_5:insertGrids()

					arg0_5.comboCheck = true
					arg0_5.combo = arg0_5.combo + 1
				else
					arg0_5.comboCheck = false
					arg0_5.combo = 0
				end
			end
		end,
		getGridDouble = function(arg0_7, arg1_7)
			for iter0_7 = 1, #arg1_7 do
				if arg0_7.grids[iter0_7] and arg0_7.grids[iter0_7].rule == var32_0 then
					return true
				end
			end

			return false
		end,
		clear = function(arg0_8)
			for iter0_8 = 1, #arg0_8.grids do
				if arg0_8.grids[iter0_8].tf then
					destroy(arg0_8.grids[iter0_8].tf)
				end
			end

			arg0_8.grids = {}
			arg0_8.gridCreateIndex = 1
			arg0_8.ruleGridList = {}
		end,
		clearGridSeriesAble = function(arg0_9)
			for iter0_9 = 1, #arg0_9.grids do
				if arg0_9.grids[iter0_9].seriesAble then
					arg0_9.grids[iter0_9].seriesAble = false
				end
			end
		end,
		getSeriesGrids = function(arg0_10)
			local var0_10 = {}
			local var1_10
			local var2_10 = {}
			local var3_10 = {}
			local var4_10
			local var5_10
			local var6_10 = 0
			local var7_10 = false

			for iter0_10 = 1, #arg0_10.grids do
				if var5_10 and var5_10 == arg0_10.grids[iter0_10].index then
					var6_10 = var6_10 + 1
				elseif arg0_10.grids[iter0_10].rule == var31_0 then
					var6_10 = var6_10 + 1
				elseif var7_10 then
					var5_10 = arg0_10.grids[iter0_10].index
					var7_10 = false
				else
					if var6_10 >= 3 and arg0_10:checkGridComboFlag(var3_10) then
						table.insert(var0_10, {
							series = var3_10,
							index = var5_10
						})
					end

					local var8_10 = arg0_10.grids[iter0_10]

					var5_10 = var8_10.index
					var6_10 = 1
					var7_10 = var8_10.rule == var31_0
					var3_10 = {}
				end

				table.insert(var3_10, iter0_10)

				if iter0_10 == #arg0_10.grids and #var3_10 >= 3 and arg0_10:checkGridComboFlag(var3_10) then
					table.insert(var0_10, {
						series = var3_10,
						index = var5_10
					})

					var3_10 = {}
				end
			end

			return var0_10
		end,
		checkGridComboFlag = function(arg0_11, arg1_11)
			for iter0_11 = 1, #arg1_11 do
				if arg0_11.grids[arg1_11[iter0_11]].seriesAble and iter0_11 ~= #arg1_11 then
					return true
				end
			end

			return false
		end,
		insertGrids = function(arg0_12)
			local var0_12 = var24_0 - #arg0_12.grids

			for iter0_12 = 1, var0_12 do
				local var1_12 = arg0_12:createGridData()

				table.insert(arg0_12.grids, var1_12)
			end

			if arg0_12:checkGridsMatchAble() then
				arg0_12:instiateGrids(true)
			else
				arg0_12:initGrids(true)
			end

			arg0_12:changeAbleGrids()
		end,
		changeAbleGrids = function(arg0_13)
			for iter0_13 = 1, #arg0_13.grids do
				arg0_13.grids[iter0_13].moveAble = false
				arg0_13.grids[iter0_13].eventAble = false
				arg0_13.grids[iter0_13].speed = var28_0
			end
		end,
		takeAwayGrid = function(arg0_14, arg1_14)
			table.sort(arg1_14, function(arg0_15, arg1_15)
				return arg0_15 <= arg1_15
			end)

			arg0_14.takeAwayTime = var25_0

			local var0_14 = {}
			local var1_14 = arg1_14[1] - 1

			if var1_14 > 0 then
				arg0_14.grids[var1_14].seriesAble = true
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/" .. "xiaochu")

			for iter0_14 = #arg1_14, 1, -1 do
				table.insert(var0_14, table.remove(arg0_14.grids, arg1_14[iter0_14]))
				setActive(arg0_14.effects[arg1_14[iter0_14]], false)
				setActive(arg0_14.effects[arg1_14[iter0_14]], true)
			end

			for iter1_14 = 1, #var0_14 do
				destroy(var0_14[iter1_14].tf)

				var0_14[iter1_14] = 0
			end

			local var2_14 = {}
		end,
		triggerDownGrid = function(arg0_16, arg1_16)
			local var0_16 = arg0_16.grids[arg1_16]
			local var1_16
			local var2_16 = var0_16.rule
			local var3_16 = {}
			local var4_16 = {}

			if var2_16 ~= var31_0 then
				var3_16 = {
					arg1_16
				}
				var1_16 = var0_16.index
			end

			if not var0_16 then
				return var3_16, {}
			end

			if var2_16 == var31_0 then
				local var5_16
				local var6_16 = true
				local var7_16 = {}

				for iter0_16 = arg1_16 - 1, 1, -1 do
					if var6_16 then
						if arg0_16.grids[iter0_16].rule == var31_0 then
							table.insert(var7_16, iter0_16)
						elseif not var5_16 then
							var5_16 = arg0_16.grids[iter0_16].index

							table.insert(var7_16, iter0_16)
						elseif var5_16 == arg0_16.grids[iter0_16].index then
							table.insert(var7_16, iter0_16)
						else
							var6_16 = false
						end
					end
				end

				local var8_16
				local var9_16 = true
				local var10_16 = {}

				for iter1_16 = arg1_16 + 1, #arg0_16.grids do
					if var9_16 then
						if arg0_16.grids[iter1_16].rule == var31_0 then
							table.insert(var10_16, iter1_16)
						elseif not var8_16 then
							var8_16 = arg0_16.grids[iter1_16].index

							table.insert(var10_16, iter1_16)
						elseif var8_16 == arg0_16.grids[iter1_16].index then
							table.insert(var10_16, iter1_16)
						else
							var9_16 = false
						end
					end
				end

				if var5_16 == nil and var8_16 == nil then
					for iter2_16 = 1, #arg0_16.grids do
						table.insert(var3_16, iter2_16)
					end
				elseif var5_16 == var8_16 then
					for iter3_16 = 1, #var7_16 do
						table.insert(var3_16, var7_16[iter3_16])
					end

					table.insert(var3_16, arg1_16)

					for iter4_16 = 1, #var10_16 do
						table.insert(var3_16, var10_16[iter4_16])
					end

					var1_16 = var5_16
				else
					if #var7_16 >= #var10_16 then
						for iter5_16 = 1, #var7_16 do
							table.insert(var3_16, var7_16[iter5_16])
						end

						var1_16 = var5_16
					else
						for iter6_16 = 1, #var10_16 do
							table.insert(var3_16, var10_16[iter6_16])
						end

						var1_16 = var8_16
					end

					table.insert(var3_16, arg1_16)
				end

				table.insert(var4_16, {
					index = var1_16,
					count = #var3_16
				})
			elseif var0_16.rule == var30_0 then
				local var11_16
				local var12_16
				local var13_16 = var0_16.index
				local var14_16
				local var15_16 = true
				local var16_16 = {}

				for iter7_16 = arg1_16 - 1, 1, -1 do
					if var15_16 then
						if arg0_16.grids[iter7_16].rule == var31_0 then
							table.insert(var16_16, iter7_16)
						elseif not var14_16 then
							var14_16 = arg0_16.grids[iter7_16].index

							table.insert(var16_16, iter7_16)
						elseif var14_16 == arg0_16.grids[iter7_16].index then
							table.insert(var16_16, iter7_16)
						else
							var15_16 = false
						end
					end
				end

				local var17_16
				local var18_16 = true
				local var19_16 = {}

				for iter8_16 = arg1_16 + 1, #arg0_16.grids do
					if var18_16 then
						if arg0_16.grids[iter8_16].rule == var31_0 then
							table.insert(var19_16, iter8_16)
						elseif not var17_16 then
							var17_16 = arg0_16.grids[iter8_16].index

							table.insert(var19_16, iter8_16)
						elseif var17_16 == arg0_16.grids[iter8_16].index then
							table.insert(var19_16, iter8_16)
						else
							var18_16 = false
						end
					end
				end

				table.insert(var4_16, {
					index = var14_16,
					count = #var16_16 + 1
				})
				table.insert(var4_16, {
					index = var17_16,
					count = #var19_16 + 1
				})

				for iter9_16 = 1, #var16_16 do
					table.insert(var3_16, var16_16[iter9_16])
				end

				for iter10_16 = 1, #var19_16 do
					table.insert(var3_16, var19_16[iter10_16])
				end
			else
				for iter11_16 = arg1_16 - 1, 1, -1 do
					if arg0_16:checkGridMatch(var1_16, arg0_16.grids[iter11_16]) then
						table.insert(var3_16, iter11_16)
					else
						break
					end
				end

				for iter12_16 = arg1_16 + 1, #arg0_16.grids do
					if arg0_16:checkGridMatch(var1_16, arg0_16.grids[iter12_16]) then
						table.insert(var3_16, iter12_16)
					else
						break
					end
				end

				table.insert(var4_16, {
					index = var1_16,
					count = #var3_16
				})
			end

			table.sort(var3_16, function(arg0_17, arg1_17)
				return arg0_17 < arg1_17
			end)

			return var3_16, var4_16
		end,
		checkGridMatch = function(arg0_18, arg1_18, arg2_18)
			if arg1_18 == arg2_18.index then
				return true
			elseif arg2_18.rule == var31_0 then
				return true
			end

			return false
		end,
		initGrids = function(arg0_19, arg1_19)
			arg0_19:clear()

			for iter0_19 = 1, var24_0 do
				local var0_19 = arg0_19:createGridData()

				table.insert(arg0_19.grids, var0_19)
			end

			if arg0_19:checkGridsMatchAble() then
				arg0_19:instiateGrids(arg1_19)
			else
				arg0_19:initGrids(arg1_19)
			end

			arg0_19.comboCheck = false
		end,
		instiateGrids = function(arg0_20, arg1_20)
			for iter0_20 = 1, #arg0_20.grids do
				local var0_20 = arg0_20.grids[iter0_20]

				if not var0_20.tf then
					local var1_20 = tf(instantiate(arg0_20.tplGrid))

					SetParent(var1_20, arg0_20._content)
					setActive(var1_20, true)
					setActive(findTF(var1_20, var0_20.name), true)

					local var2_20

					if arg1_20 then
						var2_20 = (var24_0 + arg0_20.gridCreateIndex - 1) * var26_0.x
					else
						var2_20 = (arg0_20.gridCreateIndex - 1) * var26_0.x
					end

					if var0_20.rule == var31_0 then
						-- block empty
					end

					if var0_20.rule ~= var31_0 then
						setActive(findTF(var1_20, var0_20.name .. "/boom"), var0_20.rule == var30_0)
						setActive(findTF(var1_20, var0_20.name .. "/thunder"), var0_20.rule == var32_0)
					end

					var1_20.anchoredPosition = Vector2(var2_20, 0)
					arg0_20.gridCreateIndex = arg0_20.gridCreateIndex + 1
					var0_20.tf = var1_20
				end
			end
		end,
		createGridData = function(arg0_21)
			local var0_21
			local var1_21
			local var2_21
			local var3_21

			if #arg0_21.ruleGridList > 0 then
				local var4_21 = table.remove(arg0_21.ruleGridList, 1)

				var0_21 = var4_21.id
				var3_21 = var4_21.rule
			else
				var0_21 = var34_0[math.random(1, #var34_0)]
			end

			local var5_21 = var33_0[var0_21].name
			local var6_21 = var33_0[var0_21].index

			return {
				eventAble = false,
				moveAble = false,
				speed = var28_0,
				index = var6_21,
				name = var5_21,
				rule = var3_21
			}
		end,
		checkGridsMatchAble = function(arg0_22)
			return true
		end
	}

	var0_1:ctor()

	return var0_1
end

local var89_0 = false

local function var90_0(arg0_23, arg1_23, arg2_23)
	local var0_23 = {
		ctor = function(arg0_24)
			arg0_24._specialTf = arg0_23
			arg0_24._successTf = arg1_23
			arg0_24._effectSuccess = findTF(arg0_24._successTf, "effectSuccess")
			arg0_24._event = arg2_23

			arg0_24._event:bind(var14_0, function(arg0_25, arg1_25, arg2_25)
				local var0_25 = arg1_25.series or 0
				local var1_25 = arg1_25.combo
				local var2_25 = arg1_25.index
				local var3_25 = arg1_25.double

				arg0_24:addPowerAmount(var2_25, arg0_24:getPowerAmount(var0_25, var1_25, var3_25))
			end)

			arg0_24.powers = {}

			for iter0_24 = 1, #var36_0 do
				local var0_24 = findTF(arg0_24._specialTf, var36_0[iter0_24].name)
				local var1_24 = var36_0[iter0_24].index
				local var2_24 = var36_0[iter0_24].max
				local var3_24 = var36_0[iter0_24].cur
				local var4_24 = findTF(arg0_24._specialTf, var36_0[iter0_24].name .. "/text")

				setActive(var4_24, var1_0)

				local var5_24 = {
					active = false,
					tf = var0_24,
					index = var1_24,
					max = var2_24,
					cur = var3_24,
					text_tf = var4_24
				}

				table.insert(arg0_24.powers, var5_24)
			end

			arg0_24._event:bind(var20_0, function(arg0_26, arg1_26, arg2_26)
				arg0_24.inCameraFlag = true
			end)
			arg0_24._event:bind(var21_0, function(arg0_27, arg1_27, arg2_27)
				arg0_24.inCameraFlag = false
				arg0_24.inCameraFadeTime = 200
			end)

			arg0_24.successText = findTF(arg0_24._successTf, "box/text")

			setActive(arg0_24.successText, var1_0)

			arg0_24.success = {
				cur = 0,
				slider = GetComponent(findTF(arg0_24._successTf, "box"), typeof(Slider)),
				max = var45_0
			}
		end,
		start = function(arg0_28)
			for iter0_28 = 1, #arg0_28.powers do
				local var0_28 = arg0_28.powers[iter0_28]

				var0_28.cur = 0
				var0_28.active = false
			end

			arg0_28.inCameraFlag = false
			arg0_28.inCameraFadeTime = 0
			arg0_28.success.cur = 0
			arg0_28.success.active = false

			setActive(arg0_28._effectSuccess, false)
			arg0_28:resetSpecialData()
			arg0_28:step()
		end,
		step = function(arg0_29)
			for iter0_29 = 1, #arg0_29.powers do
				local var0_29 = arg0_29.powers[iter0_29]

				if var0_29.active and var0_29.cur > 0 then
					var0_29.cur = var0_29.cur - var42_0 * Time.deltaTime

					if var0_29.cur <= 0 then
						var0_29.active = false
						var0_29.cur = 0
					end
				end

				GetComponent(var0_29.tf, typeof(Slider)).value = var0_29.cur > 0 and var0_29.cur / var0_29.max or 0

				setText(var0_29.text_tf, math.floor(var0_29.cur))
			end

			setText(arg0_29.successText, math.floor(arg0_29.success.cur))

			if arg0_29.success.active and arg0_29.success.cur > 0 and var23_0.special_complete and not arg0_29.inCameraFlag then
				if arg0_29.inCameraFadeTime > 0 then
					arg0_29.inCameraFadeTime = arg0_29.inCameraFadeTime - Time.deltaTime * 1000
				else
					arg0_29.success.cur = arg0_29.success.cur - var43_0 * Time.deltaTime

					if arg0_29.success.cur <= 0 then
						arg0_29.success.active = false
						arg0_29.success.cur = 0

						arg0_29._event:emit(var19_0)
					end
				end
			end

			if arg0_29.success.cur >= arg0_29.success.max or arg0_29.success.active then
				setActive(arg0_29._effectSuccess, true)
			else
				setActive(arg0_29._effectSuccess, false)
			end

			arg0_29.success.slider.value = arg0_29.success.cur > 0 and arg0_29.success.cur / arg0_29.success.max or 0
			var23_0.special_time = arg0_29.success.active
			var23_0.grid_index = 0

			if arg0_29.waitingSpecial then
				arg0_29:addPowerAmount(1, 0)
			end
		end,
		clear = function(arg0_30)
			return
		end,
		updateSpecialData = function(arg0_31, arg1_31)
			var23_0.special_time = arg0_31.success.active
			var23_0.grid_index = arg1_31
			var23_0.power_grid = 0

			for iter0_31 = 1, #arg0_31.powers do
				if arg0_31.powers[iter0_31].index == arg1_31 and arg0_31.powers[iter0_31].cur == arg0_31.powers[iter0_31].max then
					var23_0.power_grid = arg0_31.powers[iter0_31].index
				end
			end

			arg0_31._event:emit(var15_0)
		end,
		resetSpecialData = function(arg0_32)
			var23_0.special_complete = false
		end,
		addPowerAmount = function(arg0_33, arg1_33, arg2_33)
			local var0_33 = arg0_33:getPowerByIndex(arg1_33)

			if arg0_33.success then
				if not arg0_33.success.active then
					arg0_33.success.cur = arg0_33.success.cur + arg2_33

					if arg0_33.success.cur >= arg0_33.success.max then
						arg0_33.success.cur = arg0_33.success.max

						arg0_33._event:emit(var18_0, {
							callback = function(arg0_34)
								if arg0_34 then
									if not isActive(arg0_33._effectSuccess) then
										setActive(arg0_33._effectSuccess, true)
									end

									arg0_33.success.active = true
									var23_0.special_complete = false
									arg0_33.waitingSpecial = false
								else
									arg0_33.waitingSpecial = true
								end
							end
						})
					end
				else
					arg0_33.success.cur = arg0_33.success.cur + arg2_33 / 2

					if arg0_33.success.cur >= arg0_33.success.max then
						arg0_33.success.cur = arg0_33.success.max
					end
				end
			end

			if var0_33 and not var0_33.active then
				var0_33.cur = var0_33.cur + arg2_33

				if var0_33.cur >= var0_33.max then
					var0_33.cur = var0_33.max
					var0_33.active = true
				end
			end

			if arg2_33 > 0 then
				arg0_33:updateSpecialData(arg1_33)
			end
		end,
		getPowerByIndex = function(arg0_35, arg1_35)
			for iter0_35 = 1, #arg0_35.powers do
				if arg0_35.powers[iter0_35].index == arg1_35 then
					return arg0_35.powers[iter0_35]
				end
			end

			return nil
		end,
		getPowerAmount = function(arg0_36, arg1_36, arg2_36, arg3_36)
			if arg1_36 <= 2 then
				print("分数: " .. var44_0)

				return var44_0
			end

			local var0_36 = arg3_36 and 2 or 1

			if var0_36 == 2 then
				-- block empty
			end

			local var1_36 = var23_0.special_time and var41_0 or 1

			print("方块个数: " .. arg1_36 .. ",combo次数: " .. arg2_36 .. ", 加倍方块: " .. tostring(arg3_36) .. "，变身倍率: " .. var1_36)
			print("分数: " .. (var40_0 + (arg1_36 - var39_0) * var38_0) * (1 + arg2_36 * var37_0) * var1_36)

			return (var40_0 + (arg1_36 - var39_0) * var38_0) * (1 + arg2_36 * var37_0) * var0_36 * var1_36
		end
	}

	var0_23:ctor()

	return var0_23
end

local function var91_0(arg0_37, arg1_37, arg2_37)
	local var0_37 = {
		ctor = function(arg0_38)
			arg0_38._sceneTf = arg0_37
			arg0_38._event = arg2_37
			arg0_38.bgs = {}
			arg0_38._gameTf = arg1_37
			arg0_38._box = findTF(arg0_38._gameTf, "box")
			arg0_38._specialPower = findTF(arg0_38._gameTf, "specialPower")
			arg0_38._successPower = findTF(arg0_38._gameTf, "successPower")
			arg0_38._top = findTF(arg0_38._gameTf, "top")

			for iter0_38 = 1, #var71_0 do
				local var0_38 = var71_0[iter0_38]
				local var1_38 = findTF(arg0_38._sceneTf, var71_0[iter0_38].source)
				local var2_38 = var71_0[iter0_38].rate

				table.insert(arg0_38.bgs, {
					tf = var1_38,
					rate = var2_38,
					type = var71_0[iter0_38].type
				})
			end

			arg0_38._bgBackCanvas = GetComponent(findTF(arg0_38._sceneTf, "scene_background"), typeof(CanvasGroup))
			arg0_38._bgFrontCanvas = GetComponent(findTF(arg0_38._sceneTf, "scene_front"), typeof(CanvasGroup))
			arg0_38._bgBeamCanvas = GetComponent(findTF(arg0_38._sceneTf, "scene/bgBeam"), typeof(CanvasGroup))

			arg0_38._event:bind(var16_0, function(arg0_39, arg1_39, arg2_39)
				local var0_39 = arg1_39[1]
				local var1_39 = arg1_39[2] and -1 or 1
				local var2_39 = arg1_39[3]

				if not arg0_38.inCamera then
					arg0_38:setTargetFllow(Vector2(var1_39 * var0_39.x / 10, var1_39 * var0_39.y / 10), var2_39)
				end
			end)
			arg0_38._event:bind(var20_0, function(arg0_40, arg1_40, arg2_40)
				arg0_38.inCamera = true

				local var0_40 = Vector2(550, 100)

				if arg1_40 and arg1_40.playingAction and arg1_40.playingAction.camera_pos then
					var0_40 = arg1_40.playingAction.camera_pos
				end

				arg0_38:setTargetFllow(var0_40)
				arg0_38:setBeam(false)
			end)
			arg0_38._event:bind(var21_0, function(arg0_41, arg1_41, arg2_41)
				arg0_38.followTf = nil
				arg0_38.followInit = nil

				arg0_38:setTargetFllow(Vector2(0, 0), function()
					return
				end, true)
				arg0_38:setBeam(true)

				arg0_38.inCamera = false
			end)
		end,
		start = function(arg0_43)
			arg0_43.targetVec = Vector2(var56_0.x, var56_0.y)
			arg0_43.currentVec = Vector2(var56_0.x, var56_0.y)

			for iter0_43 = 1, #arg0_43.bgs do
				local var0_43 = arg0_43.bgs[iter0_43].tf
				local var1_43 = arg0_43.bgs[iter0_43].rate
				local var2_43 = arg0_43.bgs[iter0_43].type

				if var0_43 then
					setActive(var0_43, var2_43 == var67_0 or var2_43 == var70_0)

					var0_43.anchoredPosition = Vector2(arg0_43.currentVec.x * var1_43, arg0_43.currentVec.y * var1_43)
				end
			end

			arg0_43._bgBackCanvas.alpha = 1
			arg0_43._bgFrontCanvas.alpha = 1
			arg0_43._bgBeamCanvas.alpha = 0

			setActive(arg0_43._box, true)
			setActive(arg0_43._specialPower, true)
			setActive(arg0_43._successPower, true)
			setActive(arg0_43._top, true)
		end,
		clear = function(arg0_44)
			if LeanTween.isTweening(go(arg0_44._sceneTf)) then
				LeanTween.cancel(go(arg0_44._sceneTf), false)
			end
		end,
		step = function(arg0_45)
			local var0_45 = {
				0,
				0
			}

			if arg0_45.followTf then
				var0_45 = {
					arg0_45.followTf.anchoredPosition.x - arg0_45.followInit.x,
					arg0_45.followTf.anchoredPosition.y - arg0_45.followInit.y
				}
			end

			local var1_45 = 0
			local var2_45 = 0
			local var3_45 = arg0_45.targetVec.x - var0_45[1]
			local var4_45 = arg0_45.targetVec.y - var0_45[2]

			if var3_45 ~= arg0_45.currentVec.x then
				var1_45 = (var3_45 - arg0_45.currentVec.x) * var57_0

				if math.abs(var1_45) < var58_0 then
					var1_45 = var58_0 * math.sign(var1_45)
				end

				arg0_45.currentVec.x = arg0_45.currentVec.x + var1_45

				if math.abs(arg0_45.currentVec.x - var3_45) <= var58_0 then
					arg0_45.currentVec.x = var3_45
				end
			end

			if var4_45 ~= arg0_45.currentVec.y then
				var2_45 = (var4_45 - arg0_45.currentVec.y) * var57_0

				if math.abs(var2_45) < var58_0 then
					var2_45 = var58_0 * math.sign(var2_45)
				end

				arg0_45.currentVec.y = arg0_45.currentVec.y + var2_45

				if math.abs(arg0_45.currentVec.y - var4_45) <= var58_0 then
					arg0_45.currentVec.y = var4_45
				end
			end

			if var1_45 ~= 0 or var2_45 ~= 0 then
				arg0_45:moveTo(arg0_45.currentVec)
			end
		end,
		moveTo = function(arg0_46, arg1_46)
			for iter0_46 = 1, #arg0_46.bgs do
				local var0_46 = arg0_46.bgs[iter0_46].tf
				local var1_46 = arg0_46.bgs[iter0_46].rate
				local var2_46 = arg0_46.bgs[iter0_46].type

				if var2_46 == var67_0 or var2_46 == var70_0 then
					var0_46.anchoredPosition = Vector2(arg1_46.x * var1_46, arg1_46.y * var1_46)
				end
			end
		end,
		setTargetFllow = function(arg0_47, arg1_47, arg2_47, arg3_47)
			if not arg3_47 then
				arg0_47.targetVec = arg1_47
				arg0_47.moveCallback = arg2_47
			else
				arg0_47.currentVec = arg1_47
				arg0_47.targetVec = arg1_47

				arg0_47:moveTo(arg1_47)

				if arg2_47 then
					arg2_47()
				end
			end
		end,
		setBeam = function(arg0_48, arg1_48, arg2_48)
			if LeanTween.isTweening(go(arg0_48._sceneTf)) then
				LeanTween.cancel(go(arg0_48._sceneTf), false)
			end

			if arg1_48 then
				setActive(arg0_48._box, true)
				setActive(arg0_48._specialPower, true)
				setActive(arg0_48._successPower, true)
				setActive(arg0_48._top, true)
			else
				setActive(arg0_48._box, false)
				setActive(arg0_48._specialPower, false)
				setActive(arg0_48._successPower, false)
				setActive(arg0_48._top, false)
			end

			LeanTween.value(go(arg0_48._sceneTf), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_49)
				if arg1_48 then
					arg0_48._bgBackCanvas.alpha = arg0_49
					arg0_48._bgFrontCanvas.alpha = arg0_49
					arg0_48._bgBeamCanvas.alpha = 1 - arg0_49
				else
					arg0_48._bgBackCanvas.alpha = 1 - arg0_49
					arg0_48._bgFrontCanvas.alpha = 1 - arg0_49
					arg0_48._bgBeamCanvas.alpha = arg0_49
				end
			end)):setOnComplete(System.Action(function()
				if arg2_48 then
					arg2_48()
				end
			end))
		end
	}

	var0_37:ctor()

	return var0_37
end

local function var92_0(arg0_51, arg1_51)
	local var0_51 = {
		ctor = function(arg0_52)
			arg0_52._scene = arg0_51
			arg0_52._tpl = findTF(arg0_52._scene, "tpl")
			arg0_52._leftRolePos = findTF(arg0_52._scene, "rolePos/leftRole")
			arg0_52._rightRolePos = findTF(arg0_52._scene, "rolePos/rightRole")
			arg0_52._event = arg1_51

			arg0_52._event:bind(var15_0, function()
				arg0_52:onGridTrigger()
			end)
			arg0_52._event:bind(var18_0, function(arg0_54, arg1_54, arg2_54)
				local var0_54 = false

				for iter0_54, iter1_54 in pairs(arg0_52.playingDatas) do
					if iter1_54.inPlaying then
						var0_54 = true
					end
				end

				if arg1_54.callback then
					arg1_54.callback(not var0_54)
				end

				if not var0_54 then
					arg0_52:onRoleSpecial(arg1_54)
				end
			end)
			arg0_52._event:bind(var19_0, function()
				arg0_52:onRoleSpecialEnd()
			end)
		end,
		start = function(arg0_56)
			if arg0_56.leftRole then
				destroy(arg0_56.leftRole.tf)

				arg0_56.leftRole = nil
			end

			if arg0_56.rightRole then
				destroy(arg0_56.rightRole.tf)

				arg0_56.rightRole = nil
			end

			arg0_56.leftRole = arg0_56:createRole(var46_0, true, arg0_56._leftRolePos)
			arg0_56.rightRole = arg0_56:createRole(var47_0, false, arg0_56._rightRolePos)
			arg0_56.leftRole.targetRole = arg0_56.rightRole
			arg0_56.rightRole.targetRole = arg0_56.leftRole

			arg0_56.leftRole.animator:SetTrigger("idle")
			arg0_56.leftRole.animator:SetBool("special", false)
			arg0_56.rightRole.animator:SetTrigger("idle")
			arg0_56.rightRole.animator:SetBool("special", false)

			arg0_56.leftRole.specialBody = false
			arg0_56.rightRole.specialBody = false
			arg0_56.leftRole.anchoredPosition = Vector2(0, 0)
			arg0_56.rightRole.anchoredPosition = Vector2(0, 0)
			arg0_56.leftRole.specialTime = false
			arg0_56.rightRole.specialTime = false
			arg0_56.playingDatas = {}
			arg0_56.playingDatas[arg0_56.leftRole.name] = {
				role = arg0_56.leftRole
			}
			arg0_56.playingDatas[arg0_56.leftRole.name].skillDatas = {}
			arg0_56.playingDatas[arg0_56.rightRole.name] = {
				role = arg0_56.rightRole
			}
			arg0_56.playingDatas[arg0_56.rightRole.name].skillDatas = {}
			arg0_56.skillDeltaTime = 0
			arg0_56.emptySkillTime = math.random(1, 2)
			arg0_56.addScore = {
				0,
				0
			}

			arg0_56._event:emit(var16_0, {
				Vector2(0, 0),
				false
			})
		end,
		step = function(arg0_57)
			arg0_57:checkSkillDeltaTime()
			arg0_57:checkEmptySkillTime()
		end,
		checkSkillDeltaTime = function(arg0_58)
			if arg0_58.skillDeltaTime and arg0_58.skillDeltaTime <= 0 then
				arg0_58.skillDeltaTime = var59_0
			end

			arg0_58.skillDeltaTime = arg0_58.skillDeltaTime - Time.deltaTime

			if arg0_58.skillDeltaTime <= 0 then
				local var0_58 = false

				for iter0_58, iter1_58 in pairs(arg0_58.playingDatas) do
					if iter1_58.inPlaying then
						var0_58 = true
					end
				end

				if not var0_58 then
					for iter2_58, iter3_58 in pairs(arg0_58.playingDatas) do
						if #iter3_58.skillDatas > 0 then
							arg0_58:applyOrAddSkillData(iter3_58)

							break
						end
					end
				end
			end

			var89_0 = false

			for iter4_58, iter5_58 in pairs(arg0_58.playingDatas) do
				if iter5_58.inPlaying then
					var89_0 = true
				end
			end
		end,
		checkEmptySkillTime = function(arg0_59)
			if arg0_59.emptySkillTime and arg0_59.emptySkillTime <= 0 then
				arg0_59.emptySkillTime = var60_0
			end

			arg0_59.emptySkillTime = arg0_59.emptySkillTime - Time.deltaTime

			if arg0_59.emptySkillTime <= 0 then
				local var0_59 = false

				for iter0_59, iter1_59 in pairs(arg0_59.playingDatas) do
					if iter1_59.inPlaying then
						var0_59 = true
					end
				end

				if not var0_59 then
					local var1_59 = arg0_59:getRoleEmptySkill(arg0_59.rightRole)

					if var1_59 then
						arg0_59:addRolePlaying(arg0_59.rightRole, var1_59)
					end
				end
			end
		end,
		getRoleTestSkill = function(arg0_60, arg1_60)
			return arg1_60.skill[10]
		end,
		getRoleEmptySkill = function(arg0_61, arg1_61)
			local var0_61 = {}

			for iter0_61 = 1, #arg1_61.skill do
				local var1_61 = arg1_61.skill[iter0_61]

				if tobool(var1_61.special_time) == arg1_61.specialBody and var1_61.atk_index then
					table.insert(var0_61, var1_61)
				end
			end

			if #var0_61 > 0 then
				return Clone(var0_61[math.random(1, #var0_61)])
			end

			return nil
		end,
		onRoleSpecial = function(arg0_62, arg1_62)
			arg0_62.leftRole.specialTime = true

			for iter0_62 = 1, #arg0_62.leftRole.skill do
				local var0_62 = arg0_62.leftRole.skill[iter0_62]

				if var0_62.special_trigger then
					arg0_62:addRolePlaying(arg0_62.leftRole, Clone(var0_62))
				end
			end
		end,
		onRoleSpecialEnd = function(arg0_63)
			arg0_63.leftRole.specialTime = false

			local var0_63
			local var1_63

			for iter0_63 = 1, #arg0_63.leftRole.skill do
				local var2_63 = arg0_63.leftRole.skill[iter0_63]

				if var2_63.special_time and var2_63.power_index == 1 and var2_63.atk_index > 0 then
					var1_63 = Clone(var2_63)
				end

				if not var2_63.special_trigger and var2_63.special_end then
					var0_63 = Clone(var2_63)
				end
			end

			if var1_63 then
				arg0_63:addRolePlaying(arg0_63.leftRole, var1_63)
			end

			if var0_63 then
				arg0_63:addRolePlaying(arg0_63.leftRole, var0_63)
			end
		end,
		clear = function(arg0_64)
			if LeanTween.isTweening(go(arg0_64._leftRolePos)) then
				LeanTween.cancel(go(arg0_64._leftRolePos))
			end

			if LeanTween.isTweening(go(arg0_64._rightRolePos)) then
				LeanTween.cancel(go(arg0_64._rightRolePos))
			end

			if LeanTween.isTweening(go(arg0_64.rightRole.tf)) then
				LeanTween.cancel(go(arg0_64.rightRole.tf))
			end

			if LeanTween.isTweening(go(arg0_64.leftRole.tf)) then
				LeanTween.cancel(go(arg0_64.leftRole.tf))
			end
		end,
		onGridTrigger = function(arg0_65)
			local var0_65 = var23_0.grid_index
			local var1_65 = var23_0.power_grid
			local var2_65 = var23_0.special_time

			for iter0_65 = 1, #arg0_65.leftRole.skill do
				local var3_65 = arg0_65.leftRole.skill[iter0_65]

				if tobool(var3_65.special_time) == tobool(arg0_65.leftRole.specialTime) and var3_65.power_index == var1_65 and table.contains(var3_65.grid_index, var0_65) and var3_65.atk_index then
					arg0_65:addRolePlaying(arg0_65.leftRole, Clone(var3_65))
				end
			end
		end,
		createRole = function(arg0_66, arg1_66, arg2_66, arg3_66)
			local var0_66 = arg0_66:getRoleData(arg1_66)

			if not var0_66 then
				return nil
			end

			local var1_66 = {}
			local var2_66 = tf(instantiate(findTF(arg0_66._tpl, var0_66.name)))

			SetParent(var2_66, arg3_66)

			var2_66.anchoredPosition = Vector2(0, 0)
			var2_66.localScale = Vector3(1, 1, 1)

			setActive(var2_66, true)

			if var0_66.anim_init_pos then
				findTF(var2_66, "body/anim").anchoredPosition = var0_66.anim_init_pos
			end

			local var3_66 = findTF(var2_66, "body")
			local var4_66 = findTF(var3_66, "anim")
			local var5_66 = GetComponent(var4_66, typeof(Animator))
			local var6_66 = GetComponent(var4_66, typeof(DftAniEvent))

			var6_66:SetStartEvent(function()
				if var1_66.startCallback then
					var1_66.startCallback()
				end
			end)
			var6_66:SetTriggerEvent(function()
				if var1_66.triggerCallback then
					var1_66.triggerCallback()
				end
			end)
			var6_66:SetEndEvent(function()
				if var1_66.endCallback then
					var1_66.endCallback()
				end
			end)

			var1_66.name = var0_66.name
			var1_66.tf = var2_66
			var1_66.canvasGroup = GetComponent(var2_66, typeof(CanvasGroup))
			var1_66.body = var3_66
			var1_66.animTf = var4_66
			var1_66.animator = var5_66
			var1_66.dftEvent = var6_66
			var1_66.startCallback = nil
			var1_66.triggerCallback = nil
			var1_66.endCallback = nil
			var1_66.skill = var0_66.skill
			var1_66.name = var0_66.name
			var1_66.index = var0_66.index
			var1_66.actions = var0_66.actions

			return var1_66
		end,
		getRoleData = function(arg0_70, arg1_70)
			for iter0_70 = 1, #var87_0 do
				if var87_0[iter0_70].index == arg1_70 then
					return Clone(var87_0[iter0_70])
				end
			end

			return nil
		end,
		setDftHandle = function(arg0_71, arg1_71, arg2_71, arg3_71, arg4_71)
			arg1_71.startCallback = arg2_71
			arg1_71.triggerCallback = arg3_71
			arg1_71.endCallback = arg4_71
		end,
		playAnimation = function(arg0_72, arg1_72, arg2_72)
			arg1_72.animator:Play(arg2_72, -1, 0)
		end,
		addRolePlaying = function(arg0_73, arg1_73, arg2_73, arg3_73)
			for iter0_73, iter1_73 in pairs(arg0_73.playingDatas) do
				if iter0_73 == arg1_73.name then
					if arg3_73 then
						arg0_73:applyOrAddSkillData(iter1_73, arg2_73)
					else
						table.insert(iter1_73.skillDatas, arg2_73)

						if arg2_73.power_index > 0 and arg2_73.atk_index > 1 or arg2_73.special_trigger then
							for iter2_73 = #iter1_73.skillDatas - 1, 1, -1 do
								local var0_73 = iter1_73.skillDatas[iter2_73]

								if var0_73.power_index == 0 and var0_73.atk_index == 1 then
									local var1_73 = table.remove(iter1_73.skillDatas, iter2_73)

									if var1_73.score then
										arg0_73.addScore = {
											arg0_73.addScore[1] + var1_73.score[1],
											arg0_73.addScore[2] + var1_73.score[2]
										}
									end
								end
							end
						end
					end
				end
			end
		end,
		applyOrAddSkillData = function(arg0_74, arg1_74, arg2_74)
			if arg1_74.inPlaying then
				table.insert(arg1_74.skillDatas, arg2_74)

				return
			end

			arg1_74.inPlaying = true

			local var0_74 = arg1_74.role
			local var1_74 = arg2_74 or table.remove(arg1_74.skillDatas, 1)

			arg1_74.currentSkill = var1_74
			arg1_74.actions = var1_74.actions

			local var2_74 = var1_74.anim_bool

			if var2_74 then
				var0_74.animator:SetBool(var2_74, true)
			end

			if var0_74 == arg0_74.leftRole and not var1_74.dmg_index then
				arg0_74._leftRolePos:SetSiblingIndex(1)
			elseif var0_74 == arg0_74.rightRole and not var1_74.dmg_index then
				arg0_74._rightRolePos:SetSiblingIndex(1)
			end

			local var3_74 = var1_74.anim_init_pos

			if var3_74 then
				findTF(arg1_74.role.tf, "body/anim").anchoredPosition = var3_74
			end

			if var1_74.special_end then
				arg1_74.role.specialBody = false
			elseif var1_74.special_trigger then
				arg1_74.role.specialBody = true
			end

			arg1_74.actionIndex = 1

			arg0_74:checkAction(arg1_74, function()
				arg1_74.inPlaying = false

				arg0_74._event:emit(var16_0, {
					Vector2(0, 0),
					false
				})
			end)
		end,
		checkAction = function(arg0_76, arg1_76, arg2_76)
			if arg1_76.actions and arg1_76.actionIndex <= #arg1_76.actions then
				arg1_76.playingAction = arg1_76.actions[arg1_76.actionIndex]
				arg1_76.actionIndex = arg1_76.actionIndex + 1

				local var0_76 = arg1_76.playingAction.anim_name
				local var1_76 = arg1_76.playingAction.time
				local var2_76 = arg1_76.playingAction.move
				local var3_76 = arg1_76.playingAction.over_offset
				local var4_76 = arg1_76.playingAction.camera
				local var5_76 = arg1_76.playingAction.sound_start
				local var6_76 = arg1_76.playingAction.sound_trigger
				local var7_76 = arg1_76.playingAction.sound_end
				local var8_76 = arg1_76.currentSkill.special_trigger
				local var9_76 = arg1_76.currentSkill.special_time
				local var10_76 = arg1_76.currentSkill.atk_index

				if var8_76 or var9_76 and var10_76 and var10_76 >= 2 then
					arg0_76._event:emit(var22_0, true)
				end

				if var1_76 and var1_76 > 0 then
					-- block empty
				else
					local function var11_76()
						if var5_76 then
							pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/" .. var5_76)
						end

						if var2_76 then
							arg0_76:moveRole(arg1_76.role, var2_76)
						end

						if var4_76 then
							arg1_76.role.targetRole.canvasGroup.alpha = 0

							arg0_76._event:emit(var20_0, arg1_76)
						end
					end

					local function var12_76()
						if var6_76 then
							pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/" .. var6_76)
						end

						if var4_76 then
							var4_76 = false
							arg1_76.role.targetRole.canvasGroup.alpha = 1

							arg0_76._event:emit(var21_0)
						else
							local var0_78 = arg1_76.currentSkill.anim_trigger_pos

							if var0_78 then
								findTF(arg1_76.role.tf, "body/anim").anchoredPosition = var0_78
							end

							local var1_78 = arg1_76.currentSkill.atk_index

							if var1_78 then
								local var2_78 = arg0_76:getRoleDmgData(arg1_76.role.targetRole, var1_78)
								local var3_78 = arg1_76.role.targetRole.name

								if var2_78 then
									for iter0_78, iter1_78 in pairs(arg0_76.playingDatas) do
										if iter0_78 == var3_78 then
											arg0_76:applyOrAddSkillData(iter1_78, Clone(var2_78), true)
										end
									end
								end

								local var4_78 = arg1_76.currentSkill.score

								if var4_78 and arg1_76.role == arg0_76.leftRole then
									arg0_76._event:emit(var17_0, math.random(var4_78[1] + arg0_76.addScore[1], var4_78[2] + arg0_76.addScore[2]))

									arg0_76.addScore = {
										0,
										0
									}
								end
							end
						end
					end

					local function var13_76()
						if var7_76 then
							pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/" .. var7_76)
						end

						if LeanTween.isTweening(go(arg1_76.role.tf)) then
							LeanTween.cancel(go(arg1_76.role.tf))
						end

						local var0_79 = arg1_76.currentSkill.anim_end_pos

						if var0_79 then
							findTF(arg1_76.role.tf, "body/anim").anchoredPosition = var0_79
						end

						arg0_76._event:emit(var22_0, false)

						if var3_76 then
							arg1_76.role.tf.anchoredPosition = Vector2(arg1_76.role.tf.anchoredPosition.x + var3_76.x, arg1_76.role.tf.anchoredPosition.y + var3_76.y)
						end

						if arg1_76.currentSkill.special_trigger and var23_0.special_time and not var23_0.special_complete then
							var23_0.special_complete = true
						end

						arg1_76.playingAction = nil

						arg0_76:setDftHandle(arg1_76.role, nil, nil, nil)
						arg0_76:checkAction(arg1_76, arg2_76)
					end

					arg0_76:setDftHandle(arg1_76.role, var11_76, var12_76, var13_76)
					arg0_76:playAnimation(arg1_76.role, var0_76)
				end
			else
				local var14_76 = arg1_76.currentSkill.atk_index

				if var14_76 == 3 then
					local var15_76 = arg0_76:getRoleDmgBack(arg1_76.role.targetRole, var14_76)
					local var16_76 = arg1_76.role.targetRole.name

					if var15_76 then
						for iter0_76, iter1_76 in pairs(arg0_76.playingDatas) do
							if iter0_76 == var16_76 then
								arg0_76:applyOrAddSkillData(iter1_76, Clone(var15_76))
							end
						end
					end
				end

				if arg2_76 then
					arg2_76()
				end
			end
		end,
		moveRole = function(arg0_80, arg1_80, arg2_80)
			if LeanTween.isTweening(go(arg1_80.tf)) then
				LeanTween.cancel(go(arg1_80.tf))
			end

			if arg2_80.distance then
				arg0_80._event:emit(var16_0, {
					arg2_80.distance,
					arg1_80 == arg0_80.leftRole
				})
				LeanTween.move(arg1_80.tf, Vector3(arg2_80.distance.x, arg2_80.distance.y, 0), arg2_80.time):setEase(arg2_80.ease or LeanTweenType.linear)
			elseif arg2_80.distance_m then
				local var0_80 = Vector2(arg1_80.tf.anchoredPosition.x + arg2_80.distance_m.x, arg1_80.tf.anchoredPosition.y + arg2_80.distance_m.y)

				arg0_80._event:emit(var16_0, {
					var0_80,
					arg1_80 == arg0_80.leftRole
				})
				LeanTween.move(arg1_80.tf, Vector3(var0_80.x, var0_80.y, 0), arg2_80.time):setEase(arg2_80.ease or LeanTweenType.linear)
			end
		end,
		getRoleDmgData = function(arg0_81, arg1_81, arg2_81)
			local var0_81 = arg1_81.skill

			for iter0_81 = 1, #var0_81 do
				local var1_81 = var0_81[iter0_81]

				if var1_81.dmg_index == arg2_81 and var1_81.special_time == tobool(arg1_81.specialBody) then
					return var1_81
				end
			end

			return nil
		end,
		getRoleDmgBack = function(arg0_82, arg1_82, arg2_82)
			local var0_82 = arg1_82.skill

			for iter0_82 = 1, #var0_82 do
				local var1_82 = var0_82[iter0_82]

				if var1_82.dmg_back and var1_82.special_time == tobool(arg1_82.specialBody) then
					return var1_82
				end
			end

			return nil
		end
	}

	var0_51:ctor()

	return var0_51
end

function var0_0.getUIName(arg0_83)
	return "GridGameReUI"
end

function var0_0.didEnter(arg0_84)
	arg0_84:initEvent()
	arg0_84:initData()
	arg0_84:initUI()
	arg0_84:initGameUI()
	arg0_84:initController()
	arg0_84:updateMenuUI()
	arg0_84:openMenuUI()
end

function var0_0.initEvent(arg0_85)
	arg0_85:bind(var17_0, function(arg0_86, arg1_86, arg2_86)
		arg0_85:addScore(arg1_86)
	end)
	arg0_85:bind(var22_0, function(arg0_87, arg1_87, arg2_87)
		arg0_85.ignoreTime = arg1_87
	end)
end

function var0_0.onEventHandle(arg0_88, arg1_88)
	return
end

function var0_0.initData(arg0_89)
	local var0_89 = Application.targetFrameRate or 60

	if var0_89 > 60 then
		var0_89 = 60
	end

	arg0_89.timer = Timer.New(function()
		arg0_89:onTimer()
	end, 1 / var0_89, -1)
end

function var0_0.initUI(arg0_91)
	arg0_91.backSceneTf = findTF(arg0_91._tf, "scene_background")
	arg0_91.sceneTf = findTF(arg0_91._tf, "scene")
	arg0_91.clickMask = findTF(arg0_91._tf, "clickMask")

	setText(findTF(arg0_91._tf, "ui/gameUI/top/time"), i18n("mini_game_time"))
	setText(findTF(arg0_91._tf, "ui/gameUI/top/scoreDesc"), i18n("mini_game_score"))
	setText(findTF(arg0_91._tf, "pop/LeaveUI/ad/desc"), i18n("mini_game_leave"))
	setText(findTF(arg0_91._tf, "pop/pauseUI/ad/desc"), i18n("mini_game_pause"))
	setText(findTF(arg0_91._tf, "pop/SettleMentUI/ad/currentTextDesc"), i18n("mini_game_cur_score"))
	setText(findTF(arg0_91._tf, "pop/SettleMentUI/ad/highTextDesc"), i18n("mini_game_high_score"))

	arg0_91.countUI = findTF(arg0_91._tf, "pop/CountUI")
	arg0_91.countAnimator = GetComponent(findTF(arg0_91.countUI, "count"), typeof(Animator))
	arg0_91.countDft = GetOrAddComponent(findTF(arg0_91.countUI, "count"), typeof(DftAniEvent))

	arg0_91.countDft:SetTriggerEvent(function()
		return
	end)
	arg0_91.countDft:SetEndEvent(function()
		setActive(arg0_91.countUI, false)
		arg0_91:gameStart()
	end)

	arg0_91.leaveUI = findTF(arg0_91._tf, "pop/LeaveUI")

	onButton(arg0_91, findTF(arg0_91.leaveUI, "ad/btnOk"), function()
		arg0_91:resumeGame()
		arg0_91:onGameOver()
	end, SFX_CANCEL)
	onButton(arg0_91, findTF(arg0_91.leaveUI, "ad/btnCancel"), function()
		arg0_91:resumeGame()
	end, SFX_CANCEL)

	arg0_91.pauseUI = findTF(arg0_91._tf, "pop/pauseUI")

	onButton(arg0_91, findTF(arg0_91.pauseUI, "ad/btnOk"), function()
		setActive(arg0_91.pauseUI, false)
		arg0_91:resumeGame()
	end, SFX_CANCEL)

	arg0_91.settlementUI = findTF(arg0_91._tf, "pop/SettleMentUI")

	onButton(arg0_91, findTF(arg0_91.settlementUI, "ad/btnOver"), function()
		setActive(arg0_91.settlementUI, false)
		arg0_91:openMenuUI()
	end, SFX_CANCEL)

	arg0_91.selectedUI = findTF(arg0_91._tf, "pop/selectedUI")
	arg0_91.leftSelectRole = {}

	for iter0_91 = 1, #var50_0 do
		local var0_91 = findTF(arg0_91.selectedUI, "ad/leftRole/role" .. var50_0[iter0_91])

		setActive(var0_91, true)

		local var1_91 = var50_0[iter0_91]

		onButton(arg0_91, var0_91, function()
			var46_0, var47_0 = arg0_91:checkRoleId(var1_91, var47_0, var51_0)

			arg0_91:updateSelectedUI()
		end, SFX_CONFIRM)
		table.insert(arg0_91.leftSelectRole, {
			id = var1_91,
			tf = var0_91
		})
	end

	onButton(arg0_91, findTF(arg0_91.selectedUI, "close"), function()
		setActive(arg0_91.selectedUI, false)
	end, SFX_CANCEL)

	arg0_91.rightSelectRole = {}

	for iter1_91 = 1, #var51_0 do
		local var2_91 = findTF(arg0_91.selectedUI, "ad/rightRole/role" .. var51_0[iter1_91])

		setActive(var2_91, true)

		local var3_91 = var51_0[iter1_91]

		onButton(arg0_91, var2_91, function()
			var47_0, var46_0 = arg0_91:checkRoleId(var3_91, var46_0, var50_0)

			arg0_91:updateSelectedUI()
		end, SFX_CONFIRM)
		table.insert(arg0_91.rightSelectRole, {
			id = var3_91,
			tf = var2_91
		})
	end

	onButton(arg0_91, findTF(arg0_91.selectedUI, "ad/btnOk"), function()
		setActive(arg0_91.selectedUI, false)
		setActive(arg0_91.menuUI, false)
		arg0_91:readyStart()
	end, SFX_CONFIRM)

	arg0_91.btnDay = findTF(arg0_91.selectedUI, "ad/btnDay")
	arg0_91.btnNight = findTF(arg0_91.selectedUI, "ad/btnNight")

	local var4_91 = arg0_91:getGameUsedTimes() or 0

	var70_0 = var53_0[var4_91 + 1] and var53_0[var4_91 + 1] or var69_0

	setActive(findTF(arg0_91.btnDay, "on"), var70_0 == var68_0)
	setActive(findTF(arg0_91.btnNight, "on"), var70_0 == var69_0)
	onButton(arg0_91, arg0_91.btnDay, function()
		var70_0 = var68_0

		setActive(findTF(arg0_91.btnDay, "on"), true)
		setActive(findTF(arg0_91.btnNight, "on"), false)
		arg0_91:updateMenuUI()
	end, SFX_CONFIRM)
	onButton(arg0_91, arg0_91.btnNight, function()
		var70_0 = var69_0

		setActive(findTF(arg0_91.btnDay, "on"), false)
		setActive(findTF(arg0_91.btnNight, "on"), true)
		arg0_91:updateMenuUI()
	end, SFX_CONFIRM)
	setActive(arg0_91.selectedUI, false)

	arg0_91.menuUI = findTF(arg0_91._tf, "pop/menuUI")
	arg0_91.battleScrollRect = GetComponent(findTF(arg0_91.menuUI, "battList"), typeof(ScrollRect))
	arg0_91.totalTimes = arg0_91:getGameTotalTime()

	local var5_91 = arg0_91:getGameUsedTimes() - 4 < 0 and 0 or arg0_91:getGameUsedTimes() - 4

	scrollTo(arg0_91.battleScrollRect, 0, 1 - var5_91 / (arg0_91.totalTimes - 4))
	onButton(arg0_91, findTF(arg0_91.menuUI, "rightPanelBg/arrowUp"), function()
		local var0_104 = arg0_91.battleScrollRect.normalizedPosition.y + 1 / (arg0_91.totalTimes - 4)

		if var0_104 > 1 then
			var0_104 = 1
		end

		scrollTo(arg0_91.battleScrollRect, 0, var0_104)
	end, SFX_CANCEL)
	onButton(arg0_91, findTF(arg0_91.menuUI, "rightPanelBg/arrowDown"), function()
		local var0_105 = arg0_91.battleScrollRect.normalizedPosition.y - 1 / (arg0_91.totalTimes - 4)

		if var0_105 < 0 then
			var0_105 = 0
		end

		scrollTo(arg0_91.battleScrollRect, 0, var0_105)
	end, SFX_CANCEL)
	onButton(arg0_91, findTF(arg0_91.menuUI, "btnBack"), function()
		arg0_91:closeView()
	end, SFX_CANCEL)
	onButton(arg0_91, findTF(arg0_91.menuUI, "btnRule"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.ssss_game_tip.tip
		})
	end, SFX_CONFIRM)
	onButton(arg0_91, findTF(arg0_91.menuUI, "btnStart"), function()
		local var0_108 = arg0_91:getGameUsedTimes() or 0
		local var1_108 = arg0_91:getGameTimes() or 0

		if var0_108 >= var55_0 and arg0_91.selectedUI then
			arg0_91:updateSelectedUI()
			setActive(arg0_91.selectedUI, true)
		else
			local var2_108
			local var3_108 = var0_108 == 0 and 1 or var1_108 > 0 and var0_108 + 1 or var0_108

			var70_0 = var53_0[var0_108 + 1] and var53_0[var0_108 + 1] or 1

			if var3_108 > #var52_0 then
				var3_108 = #var52_0
			end

			local var4_108 = var52_0[var3_108]

			var46_0 = var4_108[1]
			var47_0 = var4_108[2]

			setActive(arg0_91.menuUI, false)
			arg0_91:readyStart()
		end
	end, SFX_CONFIRM)

	local var6_91 = findTF(arg0_91.menuUI, "tplBattleItem")

	arg0_91.battleItems = {}
	arg0_91.dropItems = {}

	for iter2_91 = 1, 7 do
		local var7_91 = tf(instantiate(var6_91))

		var7_91.name = "battleItem_" .. iter2_91

		setParent(var7_91, findTF(arg0_91.menuUI, "battList/Viewport/Content"))

		local var8_91 = iter2_91

		GetSpriteFromAtlasAsync(var6_0, "battleDesc" .. var8_91, function(arg0_109)
			setImageSprite(findTF(var7_91, "state_open/buttomDesc"), arg0_109, true)
			setImageSprite(findTF(var7_91, "state_clear/buttomDesc"), arg0_109, true)
			setImageSprite(findTF(var7_91, "state_current/buttomDesc"), arg0_109, true)
			setImageSprite(findTF(var7_91, "state_closed/buttomDesc"), arg0_109, true)
		end)
		setActive(var7_91, true)
		table.insert(arg0_91.battleItems, var7_91)
	end

	if not arg0_91.handle then
		arg0_91.handle = UpdateBeat:CreateListener(arg0_91.Update, arg0_91)
	end

	UpdateBeat:AddListener(arg0_91.handle)
end

function var0_0.checkRoleId(arg0_110, arg1_110, arg2_110, arg3_110)
	local var0_110 = arg0_110:matchRoleId(arg1_110, arg2_110)
	local var1_110 = arg2_110

	if not var0_110 then
		for iter0_110 = 1, #arg3_110 do
			local var2_110 = arg3_110[iter0_110]

			if arg0_110:matchRoleId(arg1_110, var2_110) then
				return arg1_110, var2_110
			end
		end
	end

	return arg1_110, arg2_110
end

function var0_0.matchRoleId(arg0_111, arg1_111, arg2_111)
	if arg1_111 == arg2_111 then
		return false
	end

	for iter0_111 = 1, #var49_0 do
		local var0_111 = var49_0[iter0_111]

		if table.contains(var0_111, arg1_111) and table.contains(var0_111, arg2_111) then
			return false
		end
	end

	return true
end

function var0_0.initGameUI(arg0_112)
	arg0_112.gameUI = findTF(arg0_112._tf, "ui/gameUI")

	onButton(arg0_112, findTF(arg0_112.gameUI, "topRight/btnStop"), function()
		arg0_112:stopGame()
		setActive(arg0_112.pauseUI, true)
	end)
	onButton(arg0_112, findTF(arg0_112.gameUI, "btnLeave"), function()
		arg0_112:stopGame()
		setActive(arg0_112.leaveUI, true)
	end)

	arg0_112.gameTimeS = findTF(arg0_112.gameUI, "top/time/s")
	arg0_112.scoreTf = findTF(arg0_112.gameUI, "top/score")
	arg0_112.scoreAnimTf = findTF(arg0_112._tf, "sceneContainer/scene_front/scoreAnim")
	arg0_112.scoreAnimTextTf = findTF(arg0_112._tf, "sceneContainer/scene_front/scoreAnim/text")

	setActive(arg0_112.scoreAnimTf, false)
end

function var0_0.initController(arg0_115)
	local var0_115 = findTF(arg0_115.gameUI, "box")

	arg0_115.boxController = var88_0(var0_115, arg0_115)

	local var1_115 = findTF(arg0_115.gameUI, "specialPower")
	local var2_115 = findTF(arg0_115.gameUI, "successPower")

	arg0_115.specialController = var90_0(var1_115, var2_115, arg0_115)

	local var3_115 = findTF(arg0_115._tf, "sceneContainer")

	arg0_115.bgController = var91_0(var3_115, arg0_115.gameUI, arg0_115)

	local var4_115 = findTF(arg0_115._tf, "sceneContainer/scene")

	arg0_115.roleController = var92_0(var4_115, arg0_115)
end

function var0_0.Update(arg0_116)
	arg0_116:AddDebugInput()
end

function var0_0.AddDebugInput(arg0_117)
	if arg0_117.gameStop or arg0_117.settlementFlag then
		return
	end

	if IsUnityEditor then
		-- block empty
	end
end

function var0_0.updateSelectedUI(arg0_118)
	for iter0_118 = 1, #arg0_118.leftSelectRole do
		local var0_118 = arg0_118.leftSelectRole[iter0_118]

		if var46_0 == var0_118.id then
			setActive(findTF(var0_118.tf, "selected"), true)
			setActive(findTF(var0_118.tf, "unSelected"), false)
		else
			setActive(findTF(var0_118.tf, "selected"), false)
			setActive(findTF(var0_118.tf, "unSelected"), true)
		end
	end

	for iter1_118 = 1, #arg0_118.rightSelectRole do
		local var1_118 = arg0_118.rightSelectRole[iter1_118]

		setGray(var1_118.tf, not arg0_118:matchRoleId(var46_0, var1_118.id), true)

		if var47_0 == var1_118.id then
			setActive(findTF(var1_118.tf, "selected"), true)
			setActive(findTF(var1_118.tf, "unSelected"), false)
		else
			setActive(findTF(var1_118.tf, "selected"), false)
			setActive(findTF(var1_118.tf, "unSelected"), true)
		end
	end
end

function var0_0.updateMenuUI(arg0_119)
	local var0_119 = arg0_119:getGameUsedTimes()

	if var0_119 and var0_119 >= 7 then
		setActive(findTF(arg0_119.menuUI, "btnStart/free"), true)
	else
		setActive(findTF(arg0_119.menuUI, "btnStart/free"), false)
	end

	local var1_119 = arg0_119:getGameTimes()

	for iter0_119 = 1, #arg0_119.battleItems do
		setActive(findTF(arg0_119.battleItems[iter0_119], "state_open"), false)
		setActive(findTF(arg0_119.battleItems[iter0_119], "state_closed"), false)
		setActive(findTF(arg0_119.battleItems[iter0_119], "state_clear"), false)
		setActive(findTF(arg0_119.battleItems[iter0_119], "state_current"), false)

		if iter0_119 <= var0_119 then
			setActive(findTF(arg0_119.battleItems[iter0_119], "state_clear"), true)
		elseif iter0_119 == var0_119 + 1 and var1_119 >= 1 then
			setActive(findTF(arg0_119.battleItems[iter0_119], "state_current"), true)
		elseif var0_119 < iter0_119 and iter0_119 <= var0_119 + var1_119 then
			setActive(findTF(arg0_119.battleItems[iter0_119], "state_open"), true)
		else
			setActive(findTF(arg0_119.battleItems[iter0_119], "state_closed"), true)
		end
	end

	arg0_119.totalTimes = arg0_119:getGameTotalTime()

	local var2_119 = 1 - (arg0_119:getGameUsedTimes() - 3 < 0 and 0 or arg0_119:getGameUsedTimes() - 3) / (arg0_119.totalTimes - 4)

	if var2_119 > 1 then
		var2_119 = 1
	end

	scrollTo(arg0_119.battleScrollRect, 0, var2_119)
	setActive(findTF(arg0_119.menuUI, "btnStart/tip"), var1_119 > 0)

	local var3_119

	if var70_0 == var68_0 then
		var3_119 = var65_0
	elseif var70_0 == var69_0 then
		var3_119 = var66_0
	end

	for iter1_119, iter2_119 in ipairs(var64_0) do
		local var4_119 = findTF(arg0_119._tf, "bg/" .. iter2_119)

		setActive(var4_119, table.contains(var3_119, iter2_119))
	end

	setActive(findTF(arg0_119.menuUI, "bg/title_day"), var70_0 == var68_0)
	setActive(findTF(arg0_119.menuUI, "bg/title_night"), var70_0 ~= var68_0)
	arg0_119:CheckGet()
end

function var0_0.CheckGet(arg0_120)
	setActive(findTF(arg0_120.menuUI, "got"), false)

	if arg0_120:getUltimate() and arg0_120:getUltimate() ~= 0 then
		setActive(findTF(arg0_120.menuUI, "got"), true)
	end

	if arg0_120:getUltimate() == 0 then
		if arg0_120:getGameTotalTime() > arg0_120:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_120:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0_120.menuUI, "got"), true)
	end
end

function var0_0.openMenuUI(arg0_121)
	setActive(findTF(arg0_121._tf, "sceneContainer/scene_front"), false)
	setActive(findTF(arg0_121._tf, "sceneContainer/scene_background"), false)
	setActive(findTF(arg0_121._tf, "sceneContainer/scene"), false)
	setActive(arg0_121.gameUI, false)
	setActive(arg0_121.menuUI, true)
	setActive(arg0_121.selectedUI, false)
	arg0_121:updateMenuUI()

	local var0_121 = arg0_121:getBGM()

	if not var0_121 then
		if pg.CriMgr.GetInstance():IsDefaultBGM() then
			var0_121 = pg.voice_bgm.NewMainScene.default_bgm
		else
			var0_121 = pg.voice_bgm.NewMainScene.bgm
		end
	end

	if arg0_121.bgm ~= var0_121 then
		arg0_121.bgm = var0_121

		pg.BgmMgr.GetInstance():Push(arg0_121.__cname, var0_121)
	end
end

function var0_0.clearUI(arg0_122)
	setActive(arg0_122.sceneTf, false)
	setActive(arg0_122.settlementUI, false)
	setActive(arg0_122.countUI, false)
	setActive(arg0_122.menuUI, false)
	setActive(arg0_122.gameUI, false)
	setActive(arg0_122.selectedUI, false)
end

function var0_0.readyStart(arg0_123)
	setActive(arg0_123.countUI, true)
	arg0_123.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var3_0)

	if var2_0 and arg0_123.bgm ~= var2_0 then
		arg0_123.bgm = var2_0

		pg.BgmMgr.GetInstance():Push(arg0_123.__cname, var2_0)
	end
end

function var0_0.gameStart(arg0_124)
	setActive(findTF(arg0_124._tf, "sceneContainer/scene_front"), true)
	setActive(findTF(arg0_124._tf, "sceneContainer/scene_background"), true)
	setActive(findTF(arg0_124._tf, "sceneContainer/scene"), true)
	setActive(arg0_124.scoreAnimTf, false)
	setActive(arg0_124.gameUI, true)

	arg0_124.gameStartFlag = true
	arg0_124.scoreNum = 0
	arg0_124.playerPosIndex = 2
	arg0_124.gameStepTime = 0
	arg0_124.gameTime = var7_0
	arg0_124.ignoreTime = false

	arg0_124.boxController:start()
	arg0_124.specialController:start()
	arg0_124.bgController:start()
	arg0_124.roleController:start()
	arg0_124:updateGameUI()
	arg0_124:timerStart()
end

function var0_0.getGameTimes(arg0_125)
	return arg0_125:GetMGHubData().count
end

function var0_0.getGameUsedTimes(arg0_126)
	return arg0_126:GetMGHubData().usedtime
end

function var0_0.getUltimate(arg0_127)
	return arg0_127:GetMGHubData().ultimate
end

function var0_0.getGameTotalTime(arg0_128)
	return (arg0_128:GetMGHubData():getConfig("reward_need"))
end

function var0_0.changeSpeed(arg0_129, arg1_129)
	return
end

function var0_0.onTimer(arg0_130)
	arg0_130:gameStep()
end

function var0_0.gameStep(arg0_131)
	if not arg0_131.ignoreTime then
		arg0_131.gameTime = arg0_131.gameTime - Time.deltaTime

		if arg0_131.gameTime < 0 then
			arg0_131.gameTime = 0
		end

		arg0_131.gameStepTime = arg0_131.gameStepTime + Time.deltaTime
	end

	arg0_131.boxController:step()
	arg0_131.specialController:step()
	arg0_131.bgController:step()
	arg0_131.roleController:step()
	arg0_131:updateGameUI()

	if arg0_131.gameTime <= 0 then
		arg0_131:onGameOver()

		return
	end
end

function var0_0.timerStart(arg0_132)
	if not arg0_132.timer.running then
		arg0_132.timer:Start()
	end
end

function var0_0.timerStop(arg0_133)
	if arg0_133.timer.running then
		arg0_133.timer:Stop()
	end
end

function var0_0.updateGameUI(arg0_134)
	setText(arg0_134.scoreTf, arg0_134.scoreNum)
	setText(arg0_134.gameTimeS, math.ceil(arg0_134.gameTime))
end

function var0_0.addScore(arg0_135, arg1_135)
	setActive(arg0_135.scoreAnimTf, false)
	setActive(arg0_135.scoreAnimTf, true)
	setText(arg0_135.scoreAnimTextTf, "+" .. tostring(arg1_135))

	arg0_135.scoreNum = arg0_135.scoreNum + arg1_135

	if arg0_135.scoreNum < 0 then
		arg0_135.scoreNum = 0
	end
end

function var0_0.onGameOver(arg0_136)
	if arg0_136.settlementFlag then
		return
	end

	arg0_136:timerStop()

	arg0_136.settlementFlag = true

	setActive(arg0_136.clickMask, true)

	if arg0_136.roleController then
		arg0_136.roleController:clear()
	end

	if arg0_136.bgController then
		arg0_136.bgController:clear()
	end

	LeanTween.delayedCall(go(arg0_136._tf), 0.1, System.Action(function()
		arg0_136.settlementFlag = false
		arg0_136.gameStartFlag = false

		setActive(arg0_136.clickMask, false)
		arg0_136:showSettlement()
	end))
end

function var0_0.showSettlement(arg0_138)
	setActive(arg0_138.settlementUI, true)
	GetComponent(findTF(arg0_138.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0_138 = arg0_138:GetMGData():GetRuntimeData("elements")
	local var1_138 = arg0_138.scoreNum
	local var2_138 = var0_138 and #var0_138 > 0 and var0_138[1] or 0

	setActive(findTF(arg0_138.settlementUI, "ad/new"), var2_138 < var1_138)

	if var2_138 <= var1_138 then
		var2_138 = var1_138

		arg0_138:StoreDataToServer({
			var2_138
		})
	end

	local var3_138 = findTF(arg0_138.settlementUI, "ad/highText")
	local var4_138 = findTF(arg0_138.settlementUI, "ad/currentText")

	setText(var3_138, var2_138)
	setText(var4_138, var1_138)

	if arg0_138:getGameTimes() and arg0_138:getGameTimes() > 0 then
		arg0_138.sendSuccessFlag = true

		arg0_138:SendSuccess(0)
	end
end

function var0_0.resumeGame(arg0_139)
	arg0_139.gameStop = false

	setActive(arg0_139.leaveUI, false)
	arg0_139:changeSpeed(1)
	arg0_139:timerStart()
end

function var0_0.stopGame(arg0_140)
	arg0_140.gameStop = true

	arg0_140:timerStop()
	arg0_140:changeSpeed(0)
end

function var0_0.onBackPressed(arg0_141)
	if not arg0_141.gameStartFlag then
		arg0_141:emit(var0_0.ON_BACK_PRESSED)
	else
		if arg0_141.settlementFlag then
			return
		end

		if isActive(arg0_141.pauseUI) then
			setActive(arg0_141.pauseUI, false)
		end

		arg0_141:stopGame()
		setActive(arg0_141.leaveUI, true)
	end
end

function var0_0.willExit(arg0_142)
	if arg0_142.handle then
		UpdateBeat:RemoveListener(arg0_142.handle)
	end

	if arg0_142._tf and LeanTween.isTweening(go(arg0_142._tf)) then
		LeanTween.cancel(go(arg0_142._tf))
	end

	if arg0_142.timer and arg0_142.timer.running then
		arg0_142.timer:Stop()
	end

	Time.timeScale = 1
	arg0_142.timer = nil
end

return var0_0
