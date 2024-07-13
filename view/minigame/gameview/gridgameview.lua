local var0_0 = class("GridGameView", import("..BaseMiniGameView"))
local var1_0 = "battle-boss-4"
local var2_0 = "event:/ui/ddldaoshu2"
local var3_0 = "event:/ui/niujiao"
local var4_0 = "event:/ui/taosheng"
local var5_0 = 70
local var6_0 = "mini_game_time"
local var7_0 = "mini_game_score"
local var8_0 = "mini_game_leave"
local var9_0 = "mini_game_pause"
local var10_0 = "mini_game_cur_score"
local var11_0 = "mini_game_high_score"
local var12_0 = "event grid combo"
local var13_0 = "event grid trigger"
local var14_0 = "event move role"
local var15_0 = "event add score"
local var16_0 = "event role special"
local var17_0 = "event special end"
local var18_0 = "event camera in"
local var19_0 = "event camedra out"
local var20_0 = "event ignore time"
local var21_0 = {
	power_grid = 0,
	grid_index = 0,
	special_time = false,
	special_complete = false
}
local var22_0 = {
	{
		index = 1,
		name = "red",
		max = 800
	},
	{
		index = 2,
		name = "yellow",
		max = 800
	},
	{
		index = 3,
		name = "blue",
		max = 800
	}
}
local var23_0 = 0.2
local var24_0 = 50
local var25_0 = 3
local var26_0 = 150
local var27_0 = 500
local var28_0 = 300
local var29_0 = 50
local var30_0 = 4000
local var31_0 = 1
local var32_0 = 3
local var33_0 = {
	1,
	2
}
local var34_0 = {
	1,
	2,
	3
}
local var35_0 = {
	{
		1,
		3
	},
	{
		2,
		3
	},
	{
		1,
		2
	},
	{
		2,
		1
	},
	{
		1,
		3
	},
	{
		2,
		3
	},
	{
		1,
		2
	}
}
local var36_0 = Vector2(0, 0)
local var37_0 = 0.07
local var38_0 = 0.3
local var39_0 = 0.5
local var40_0 = 5
local var41_0 = "sound start"
local var42_0 = "sound trigger"
local var43_0 = "sound end"
local var44_0 = {
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
local var45_0 = {
	n_Move_R = {
		time = 0,
		anim_name = var44_0.n_MoveR,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(650, 0, 0)
		}
	},
	n_Atk = {
		time = 0,
		sound_trigger = "taosheng",
		anim_name = var44_0.n_Atk,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(650, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	n_Move_L = {
		time = 0,
		anim_name = var44_0.n_MoveL,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0)
		}
	},
	n_Skill_1 = {
		time = 0,
		sound_trigger = "jiguang",
		anim_name = var44_0.n_Skill_1
	},
	n_Skill_2 = {
		time = 0,
		sound_trigger = "guangjian",
		anim_name = var44_0.n_Skill_2,
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
		anim_name = var44_0.n_Skill_3
	},
	n_Combine = {
		sound_start = "bianshen",
		time = 0,
		camera = true,
		anim_name = var44_0.n_Combine
	},
	n_DMG = {
		time = 0,
		anim_name = var44_0.n_DMG,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(-50, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	n_DMG_S = {
		time = 0,
		anim_name = var44_0.n_DMG
	},
	n_DMG_Back_R = {
		time = 0,
		anim_name = var44_0.n_MoveR,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0)
		}
	},
	n_Neutral = {
		time = 0,
		anim_name = var44_0.n_Neutral
	},
	c_Atk = {
		time = 0,
		sound_trigger = "taosheng",
		anim_name = var44_0.c_Atk,
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
		anim_name = var44_0.c_Skill_1
	},
	c_Dmg = {
		time = 0,
		anim_name = var44_0.c_Dmg,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(-50, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	c_Dmg_S = {
		time = 0,
		anim_name = var44_0.c_Dmg
	},
	c_MoveL = {
		time = 0,
		anim_name = var44_0.c_MoveL,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0)
		}
	},
	c_MoveR = {
		time = 0,
		anim_name = var44_0.c_MoveR,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(650, 0, 0)
		}
	},
	c_DMG_Back_R = {
		time = 0,
		anim_name = var44_0.c_MoveR,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0)
		}
	},
	c_Neutral = {
		time = 0,
		anim_name = var44_0.c_Neutral
	}
}
local var46_0 = {
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
			var45_0.n_Atk,
			var45_0.n_Move_L
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
			var45_0.n_Skill_1
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
			var45_0.n_Skill_2,
			var45_0.n_Move_L
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
			var45_0.n_Skill_3
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
			var45_0.n_DMG,
			var45_0.n_DMG_Back_R
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
			var45_0.n_DMG_S
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
			var45_0.n_DMG_Back_R
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
			var45_0.n_Combine
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
			var45_0.c_Atk,
			var45_0.c_MoveL
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
			var45_0.c_Skill_1
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
			var45_0.c_Skill_1
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
			var45_0.c_Skill_1
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
			var45_0.c_Dmg,
			var45_0.c_DMG_Back_R
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
			var45_0.c_Dmg_S
		}
	}
}
local var47_0 = {
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
local var48_0 = {
	n_Move_R = {
		time = 0,
		anim_name = var47_0.n_MoveR,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(500, 0, 0)
		}
	},
	n_Atk = {
		time = 0,
		sound_trigger = "taosheng",
		anim_name = var47_0.n_Atk,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(600, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	n_Move_L = {
		time = 0,
		anim_name = var47_0.n_MoveL,
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
		anim_name = var47_0.n_Skill_1,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(600, 0, 0)
		}
	},
	n_Skill_2 = {
		time = 0,
		sound_trigger = "baozha2",
		anim_name = var47_0.n_Skill_2
	},
	n_Skill_3 = {
		time = 0,
		sound_trigger = "baozha2",
		anim_name = var47_0.n_Skill_3,
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
		anim_name = var47_0.n_Combine
	},
	n_DMG = {
		time = 0,
		anim_name = var47_0.n_DMG,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(-50, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	n_DMG_S = {
		time = 0,
		anim_name = var47_0.n_DMG
	},
	n_DMG_Back_R = {
		time = 0,
		anim_name = var47_0.n_MoveR,
		move = {
			time = 0.2,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0)
		}
	},
	n_Neutral = {
		time = 0,
		anim_name = var47_0.n_Neutral
	},
	c_Atk = {
		time = 0,
		sound_trigger = "taosheng",
		anim_name = var47_0.c_Atk,
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
		anim_name = var47_0.c_Skill_1
	},
	c_Dmg = {
		time = 0,
		anim_name = var47_0.c_Dmg,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(-50, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	c_Dmg_S = {
		time = 0,
		anim_name = var47_0.c_Dmg
	},
	c_MoveL = {
		time = 0,
		anim_name = var47_0.c_MoveL,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	c_MoveR = {
		time = 0,
		anim_name = var47_0.c_MoveR,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(650, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	c_DMG_Back_R = {
		time = 0,
		anim_name = var47_0.c_MoveR,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	c_Neutral = {
		time = 0,
		anim_name = var47_0.c_Neutral
	}
}
local var49_0 = {
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
			var48_0.n_Atk,
			var48_0.n_Move_L
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
			var48_0.n_Move_R,
			var48_0.n_Skill_1,
			var48_0.n_Move_L
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
			var48_0.n_Skill_2
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
			var48_0.n_Skill_3,
			var48_0.n_Move_L
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
			var48_0.n_DMG,
			var48_0.n_DMG_Back_R
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
			var48_0.n_DMG_S
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
			var48_0.n_DMG_Back_R
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
			var48_0.n_Combine
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
			var48_0.c_Atk,
			var48_0.c_MoveL
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
			var48_0.c_Skill_1
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
			var48_0.c_Skill_1
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
			var48_0.c_Skill_1
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
			var48_0.c_Dmg,
			var48_0.c_DMG_Back_R
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
			var48_0.c_Dmg_S
		}
	}
}
local var50_0 = {
	Neutral = "Neutral",
	Skill_1 = "skill_1",
	Skill_2 = "skill_2",
	Atk = "ATK",
	MoveL = "MoveL",
	DMG = "DMG",
	MoveR = "MoveR"
}
local var51_0 = {
	Move_R = {
		time = 0,
		anim_name = var50_0.MoveR,
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
		anim_name = var50_0.Atk,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(600, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	Move_L = {
		time = 0,
		anim_name = var50_0.MoveL,
		move = {
			time = 0.4,
			distance = Vector3(0, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	Skill_1 = {
		time = 0,
		sound_trigger = "jiguang",
		anim_name = var50_0.Skill_1
	},
	Skill_2 = {
		time = 0,
		sound_trigger = "baozha2",
		anim_name = var50_0.Skill_2,
		over_offset = Vector2(115, 0)
	},
	DMG = {
		time = 0,
		anim_name = var50_0.DMG,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(-50, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	DMG_Back_R = {
		time = 0,
		anim_name = var50_0.MoveR,
		move = {
			time = 0.3,
			start = Vector2(0, 0),
			distance = Vector3(0, 0, 0),
			ease = LeanTweenType.easeOutCirc
		}
	},
	DMG_S = {
		time = 0,
		anim_name = var50_0.DMG
	},
	Neutral = {
		time = 0,
		anim_name = var50_0.Neutral
	}
}
local var52_0 = {
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
			var51_0.Atk,
			var51_0.Move_L
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
			var51_0.Skill_1
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
			var51_0.Move_R,
			var51_0.Skill_2,
			var51_0.Move_L
		}
	},
	{
		dmg_index = 2,
		name = "DMG",
		special_time = false,
		actions = {
			var51_0.DMG,
			var51_0.DMG_Back_R
		}
	},
	{
		dmg_index = 1,
		name = "DMG_Stand",
		special_time = false,
		actions = {
			var51_0.DMG_S
		}
	}
}
local var53_0 = {
	{
		index = 1,
		name = "role1",
		skill = var46_0,
		actions = var45_0
	},
	{
		index = 2,
		name = "role2",
		skill = var49_0,
		actions = var48_0
	},
	{
		index = 3,
		name = "enemy1",
		skill = var52_0,
		actions = var51_0
	}
}

local function var54_0(arg0_1, arg1_1)
	local var0_1 = {}
	local var1_1 = 12
	local var2_1 = 0.3
	local var3_1 = Vector2(138, 150)
	local var4_1 = 2500
	local var5_1 = 0
	local var6_1 = 100
	local var7_1 = {
		{
			index = 1,
			name = "red"
		},
		{
			index = 2,
			name = "yellow"
		},
		{
			index = 3,
			name = "blue"
		}
	}

	function var0_1.ctor(arg0_2)
		arg0_2._boxTf = arg0_1
		arg0_2._event = arg1_1
		arg0_2._gridEffect = findTF(arg0_2._boxTf, "effectGrid")
		arg0_2._content = findTF(arg0_2._boxTf, "viewport/content")
		arg0_2.tplGrid = findTF(arg0_1, "tplGrid")

		setActive(arg0_2.tplGrid, false)

		arg0_2.grids = {}
		arg0_2.effects = {}
		arg0_2.combo = 0

		for iter0_2 = 1, var1_1 do
			local var0_2 = tf(instantiate(arg0_2._gridEffect))

			setParent(var0_2, arg0_2._content)
			setActive(var0_2, false)

			var0_2.anchoredPosition = Vector2(var3_1.x * iter0_2 - var3_1.x / 2, var3_1.y / 2)

			table.insert(arg0_2.effects, var0_2)
		end
	end

	function var0_1.start(arg0_3)
		arg0_3.nextCheck = false

		arg0_3:initGrids(false)

		for iter0_3 = 1, #arg0_3.effects do
			setActive(arg0_3.effects[iter0_3], false)
		end
	end

	function var0_1.step(arg0_4)
		if arg0_4.takeAwayTime and arg0_4.takeAwayTime > 0 then
			arg0_4.takeAwayTime = arg0_4.takeAwayTime - Time.deltaTime

			return
		end

		arg0_4.gridCreateIndex = 1

		local var0_4 = false

		for iter0_4 = 1, #arg0_4.grids do
			local var1_4 = arg0_4.grids[iter0_4]
			local var2_4 = iter0_4

			if not var1_4.checkAble then
				var0_4 = var0_4 or true

				local var3_4 = (iter0_4 - 1) * var3_1.x

				if var3_4 < var1_4.tf.anchoredPosition.x then
					var1_4.tf.anchoredPosition = Vector2(var1_4.tf.anchoredPosition.x - var1_4.speed * Time.deltaTime, 0)

					if var1_4.speed < var4_1 then
						var1_4.speed = var1_4.speed + var6_1
					end
				end

				if var3_4 >= var1_4.tf.anchoredPosition.x then
					var1_4.speed = 0
					var1_4.checkAble = true

					if var3_4 > var1_4.tf.anchoredPosition.x then
						var1_4.tf.anchoredPosition = Vector2(var3_4, 0)
					end
				end
			end

			if not var1_4.eventAble then
				GetComponent(var1_4.tf, typeof(EventTriggerListener)):AddPointDownFunc(function()
					if arg0_4.nextCheck == false then
						local var0_5, var1_5 = arg0_4:triggerDownGrid(var2_4)

						if #var0_5 >= 2 then
							arg0_4.nextCheck = true

							arg0_4:takeAwayGrid(var0_5)
							arg0_4:insertGrids()
							arg0_4._event:emit(var12_0, {
								series = #var0_5,
								combo = arg0_4.combo,
								index = var1_5
							})

							arg0_4.combo = arg0_4.combo + 1
						else
							arg0_4.nextCheck = true

							arg0_4:takeAwayGrid({
								var2_4
							})
							arg0_4:insertGrids()
						end
					end
				end)

				var1_4.eventAble = true
			end
		end

		if not var0_4 and arg0_4.nextCheck then
			local var4_4 = arg0_4:getSeriesGrids()

			if #var4_4 > 0 then
				local var5_4 = {}

				for iter1_4 = 1, #var4_4 do
					local var6_4 = var4_4[iter1_4].series
					local var7_4 = var4_4[iter1_4].gridIndex

					for iter2_4 = 1, #var6_4 do
						table.insert(var5_4, var6_4[iter2_4])
					end

					arg0_4._event:emit(var12_0, {
						series = #var6_4,
						combo = arg0_4.combo,
						index = var7_4
					})
				end

				arg0_4:clearGridSeriesAble()
				arg0_4:takeAwayGrid(var5_4)
				arg0_4:insertGrids()

				arg0_4.nextCheck = true
				arg0_4.combo = arg0_4.combo + 1
			else
				arg0_4.nextCheck = false

				if not var21_0.special_time then
					arg0_4.combo = 0
				end
			end
		end
	end

	function var0_1.clear(arg0_6)
		for iter0_6 = 1, #arg0_6.grids do
			if arg0_6.grids[iter0_6].tf then
				destroy(arg0_6.grids[iter0_6].tf)
			end
		end

		arg0_6.grids = {}
		arg0_6.gridCreateIndex = 1
	end

	function var0_1.clearGridSeriesAble(arg0_7)
		for iter0_7 = 1, #arg0_7.grids do
			if arg0_7.grids[iter0_7].seriesAble then
				arg0_7.grids[iter0_7].seriesAble = false
			end
		end
	end

	function var0_1.getSeriesGrids(arg0_8)
		local var0_8 = {}
		local var1_8
		local var2_8 = {}

		for iter0_8 = 1, #arg0_8.grids do
			local var3_8 = arg0_8.grids[iter0_8]

			if not var1_8 then
				var1_8 = var3_8.index

				table.insert(var2_8, iter0_8)
			elseif var1_8 == var3_8.index then
				table.insert(var2_8, iter0_8)

				if #var2_8 >= 3 and iter0_8 == #arg0_8.grids and arg0_8:checkSeriesAble(var2_8) then
					table.insert(var0_8, {
						series = var2_8,
						gridIndex = var1_8
					})
				end
			elseif var1_8 ~= var3_8.index then
				if #var2_8 >= 3 and arg0_8:checkSeriesAble(var2_8) then
					table.insert(var0_8, {
						series = var2_8,
						gridIndex = var1_8
					})
				end

				var2_8 = {}
				var1_8 = var3_8.index

				table.insert(var2_8, iter0_8)
			end
		end

		return var0_8
	end

	function var0_1.checkSeriesAble(arg0_9, arg1_9)
		for iter0_9 = 1, #arg1_9 do
			if arg0_9.grids[arg1_9[iter0_9]].seriesAble then
				return true
			end
		end

		return false
	end

	function var0_1.insertGrids(arg0_10)
		local var0_10 = var1_1 - #arg0_10.grids

		for iter0_10 = 1, var0_10 do
			local var1_10 = arg0_10:createGridData()

			table.insert(arg0_10.grids, var1_10)
		end

		if arg0_10:checkGridsSeries() then
			arg0_10:instiateGrids(true)
		else
			arg0_10:initGrids(true)
		end

		arg0_10:changeAbleGrids()
	end

	function var0_1.changeAbleGrids(arg0_11)
		for iter0_11 = 1, #arg0_11.grids do
			arg0_11.grids[iter0_11].checkAble = false
			arg0_11.grids[iter0_11].eventAble = false
			arg0_11.grids[iter0_11].speed = var5_1
		end
	end

	function var0_1.takeAwayGrid(arg0_12, arg1_12)
		table.sort(arg1_12, function(arg0_13, arg1_13)
			return arg0_13 <= arg1_13
		end)

		arg0_12.takeAwayTime = var2_1

		local var0_12 = {}

		if arg1_12[1] - 1 > 0 then
			arg0_12.grids[arg1_12[1] - 1].seriesAble = true
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/" .. "xiaochu")

		for iter0_12 = #arg1_12, 1, -1 do
			table.insert(var0_12, table.remove(arg0_12.grids, arg1_12[iter0_12]))
			setActive(arg0_12.effects[arg1_12[iter0_12]], false)
			setActive(arg0_12.effects[arg1_12[iter0_12]], true)
		end

		for iter1_12 = 1, #var0_12 do
			destroy(var0_12[iter1_12].tf)

			var0_12[iter1_12] = 0
		end

		local var1_12 = {}
	end

	function var0_1.triggerDownGrid(arg0_14, arg1_14)
		local var0_14 = arg0_14.grids[arg1_14]
		local var1_14 = {
			arg1_14
		}

		if not var0_14 then
			return var1_14, 0
		end

		for iter0_14 = arg1_14 - 1, 1, -1 do
			local var2_14 = arg0_14.grids[iter0_14]

			if var0_14.index == var2_14.index then
				table.insert(var1_14, iter0_14)
			else
				break
			end
		end

		for iter1_14 = arg1_14 + 1, #arg0_14.grids do
			local var3_14 = arg0_14.grids[iter1_14]

			if var0_14.index == var3_14.index then
				table.insert(var1_14, iter1_14)
			else
				break
			end
		end

		table.sort(var1_14, function(arg0_15, arg1_15)
			return arg0_15 <= arg1_15
		end)

		return var1_14, var0_14.index
	end

	function var0_1.initGrids(arg0_16, arg1_16)
		arg0_16:clear()

		for iter0_16 = 1, var1_1 do
			local var0_16 = arg0_16:createGridData()

			table.insert(arg0_16.grids, var0_16)
		end

		if arg0_16:checkGridsSeries() then
			arg0_16:instiateGrids(arg1_16)
		else
			arg0_16:initGrids(arg1_16)
		end

		arg0_16.nextCheck = false
	end

	function var0_1.instiateGrids(arg0_17, arg1_17)
		for iter0_17 = 1, #arg0_17.grids do
			local var0_17 = arg0_17.grids[iter0_17]

			if not var0_17.tf then
				local var1_17 = tf(instantiate(arg0_17.tplGrid))

				SetParent(var1_17, arg0_17._content)
				setActive(var1_17, true)
				setActive(findTF(var1_17, var0_17.name), true)

				local var2_17

				if arg1_17 then
					var2_17 = (var1_1 + arg0_17.gridCreateIndex - 1) * var3_1.x
				else
					var2_17 = (arg0_17.gridCreateIndex - 1) * var3_1.x
				end

				var1_17.anchoredPosition = Vector2(var2_17, 0)
				arg0_17.gridCreateIndex = arg0_17.gridCreateIndex + 1
				var0_17.tf = var1_17
			end
		end
	end

	function var0_1.createGridData(arg0_18, arg1_18)
		local var0_18

		if arg1_18 then
			var0_18 = Clone(var7_1[arg1_18])
		else
			var0_18 = Clone(var7_1[math.random(1, #var7_1)])
		end

		local var1_18 = var0_18.index
		local var2_18 = var0_18.name

		return {
			eventAble = false,
			checkAble = false,
			speed = var5_1,
			index = var1_18,
			name = var2_18
		}
	end

	function var0_1.checkGridsSeries(arg0_19)
		return true
	end

	var0_1:ctor()

	return var0_1
end

local var55_0 = false

local function var56_0(arg0_20, arg1_20, arg2_20)
	local var0_20 = {
		ctor = function(arg0_21)
			arg0_21._specialTf = arg0_20
			arg0_21._successTf = arg1_20
			arg0_21._effectSuccess = findTF(arg0_21._successTf, "effectSuccess")
			arg0_21._event = arg2_20

			arg0_21._event:bind(var12_0, function(arg0_22, arg1_22, arg2_22)
				local var0_22 = arg1_22.series
				local var1_22 = arg1_22.combo
				local var2_22 = arg1_22.index

				arg0_21:addPowerAmount(var2_22, arg0_21:getPowerAmount(var0_22, var1_22))
			end)

			arg0_21.powers = {}

			for iter0_21 = 1, #var22_0 do
				local var0_21 = findTF(arg0_21._specialTf, var22_0[iter0_21].name)
				local var1_21 = var22_0[iter0_21].index
				local var2_21 = var22_0[iter0_21].max
				local var3_21 = var22_0[iter0_21].cur
				local var4_21 = {
					active = false,
					tf = var0_21,
					index = var1_21,
					max = var2_21,
					cur = var3_21
				}

				table.insert(arg0_21.powers, var4_21)
			end

			arg0_21.success = {
				cur = 0,
				slider = GetComponent(findTF(arg0_21._successTf, "box"), typeof(Slider)),
				max = var30_0
			}
		end,
		start = function(arg0_23)
			for iter0_23 = 1, #arg0_23.powers do
				local var0_23 = arg0_23.powers[iter0_23]

				var0_23.cur = 0
				var0_23.active = false
			end

			arg0_23.success.cur = 0
			arg0_23.success.active = false

			setActive(arg0_23._effectSuccess, false)
			arg0_23:resetSpecialData()
			arg0_23:step()
		end,
		step = function(arg0_24)
			for iter0_24 = 1, #arg0_24.powers do
				local var0_24 = arg0_24.powers[iter0_24]

				if var0_24.active and var0_24.cur > 0 then
					var0_24.cur = var0_24.cur - var27_0 * Time.deltaTime

					if var0_24.cur <= 0 then
						var0_24.active = false
						var0_24.cur = 0
					end
				end

				GetComponent(var0_24.tf, typeof(Slider)).value = var0_24.cur > 0 and var0_24.cur / var0_24.max or 0
			end

			if arg0_24.success.active and arg0_24.success.cur > 0 and var21_0.special_complete then
				arg0_24.success.cur = arg0_24.success.cur - var28_0 * Time.deltaTime

				if arg0_24.success.cur <= 0 then
					arg0_24.success.active = false
					arg0_24.success.cur = 0

					arg0_24._event:emit(var17_0)
				end
			end

			if arg0_24.success.cur >= arg0_24.success.max or arg0_24.success.active then
				setActive(arg0_24._effectSuccess, true)
			else
				setActive(arg0_24._effectSuccess, false)
			end

			arg0_24.success.slider.value = arg0_24.success.cur > 0 and arg0_24.success.cur / arg0_24.success.max or 0
			var21_0.special_time = arg0_24.success.active
			var21_0.grid_index = 0
		end,
		clear = function(arg0_25)
			return
		end,
		updateSpecialData = function(arg0_26, arg1_26)
			var21_0.special_time = arg0_26.success.active
			var21_0.grid_index = arg1_26
			var21_0.power_grid = 0

			for iter0_26 = 1, #arg0_26.powers do
				if arg0_26.powers[iter0_26].index == arg1_26 and arg0_26.powers[iter0_26].cur == arg0_26.powers[iter0_26].max then
					var21_0.power_grid = arg0_26.powers[iter0_26].index
				end
			end

			arg0_26._event:emit(var13_0)
		end,
		resetSpecialData = function(arg0_27)
			var21_0.special_complete = false
		end,
		addPowerAmount = function(arg0_28, arg1_28, arg2_28)
			local var0_28 = arg0_28:getPowerByIndex(arg1_28)

			if arg0_28.success and not arg0_28.success.active then
				arg0_28.success.cur = arg0_28.success.cur + arg2_28

				if arg0_28.success.cur >= arg0_28.success.max then
					arg0_28.success.cur = arg0_28.success.max

					if not isActive(arg0_28._effectSuccess) then
						setActive(arg0_28._effectSuccess, true)
					end

					arg0_28.success.active = true
					var21_0.special_complete = false

					arg0_28._event:emit(var16_0)
				end
			end

			if var0_28 and not var0_28.active then
				var0_28.cur = var0_28.cur + arg2_28

				if var0_28.cur >= var0_28.max then
					var0_28.cur = var0_28.max
					var0_28.active = true
				end
			end

			if arg2_28 > 0 then
				arg0_28:updateSpecialData(arg1_28)
			end
		end,
		getPowerByIndex = function(arg0_29, arg1_29)
			for iter0_29 = 1, #arg0_29.powers do
				if arg0_29.powers[iter0_29].index == arg1_29 then
					return arg0_29.powers[iter0_29]
				end
			end

			return nil
		end,
		getPowerAmount = function(arg0_30, arg1_30, arg2_30)
			if arg1_30 <= 2 then
				return var29_0
			end

			return (var26_0 + (arg1_30 - var25_0) * var24_0) * (1 + arg2_30 * var23_0)
		end
	}

	var0_20:ctor()

	return var0_20
end

local function var57_0(arg0_31, arg1_31, arg2_31)
	local var0_31 = {}
	local var1_31 = {
		{
			rate = 0.05,
			source = "scene_background/bg01"
		},
		{
			rate = 0.1,
			source = "scene_background/bg02"
		},
		{
			rate = 0.2,
			source = "scene_background/bg03"
		},
		{
			rate = 0.8,
			source = "scene_background/bg04"
		},
		{
			rate = 1.2,
			source = "scene_front/bg05"
		},
		{
			rate = 1,
			source = "scene/rolePos"
		}
	}

	function var0_31.ctor(arg0_32)
		arg0_32._sceneTf = arg0_31
		arg0_32._event = arg2_31
		arg0_32.bgs = {}
		arg0_32._gameTf = arg1_31
		arg0_32._box = findTF(arg0_32._gameTf, "box")
		arg0_32._specialPower = findTF(arg0_32._gameTf, "specialPower")
		arg0_32._successPower = findTF(arg0_32._gameTf, "successPower")
		arg0_32._top = findTF(arg0_32._gameTf, "top")

		for iter0_32 = 1, #var1_31 do
			local var0_32 = var1_31[iter0_32]
			local var1_32 = findTF(arg0_32._sceneTf, var1_31[iter0_32].source)
			local var2_32 = var1_31[iter0_32].rate

			table.insert(arg0_32.bgs, {
				tf = var1_32,
				rate = var2_32
			})
		end

		arg0_32._bgBackCanvas = GetComponent(findTF(arg0_32._sceneTf, "scene_background"), typeof(CanvasGroup))
		arg0_32._bgFrontCanvas = GetComponent(findTF(arg0_32._sceneTf, "scene_front"), typeof(CanvasGroup))
		arg0_32._bgBeamCanvas = GetComponent(findTF(arg0_32._sceneTf, "scene/bgBeam"), typeof(CanvasGroup))

		arg0_32._event:bind(var14_0, function(arg0_33, arg1_33, arg2_33)
			local var0_33 = arg1_33[1]
			local var1_33 = arg1_33[2] and -1 or 1
			local var2_33 = arg1_33[3]

			if not arg0_32.inCamera then
				arg0_32:setTargetFllow(Vector2(var1_33 * var0_33.x / 10, var1_33 * var0_33.y / 10), var2_33)
			end
		end)
		arg0_32._event:bind(var18_0, function(arg0_34, arg1_34, arg2_34)
			arg0_32.inCamera = true

			arg0_32:setTargetFllow(Vector2(550, 100))
			arg0_32:setBeam(false)
		end)
		arg0_32._event:bind(var19_0, function(arg0_35, arg1_35, arg2_35)
			arg0_32:setTargetFllow(Vector2(0, 0), function()
				return
			end, true)
			arg0_32:setBeam(true)

			arg0_32.inCamera = false
		end)
	end

	function var0_31.start(arg0_37)
		arg0_37.targetVec = Vector2(var36_0.x, var36_0.y)
		arg0_37.currentVec = Vector2(var36_0.x, var36_0.y)

		for iter0_37 = 1, #arg0_37.bgs do
			local var0_37 = arg0_37.bgs[iter0_37].tf
			local var1_37 = arg0_37.bgs[iter0_37].rate

			var0_37.anchoredPosition = Vector2(arg0_37.currentVec.x * var1_37, arg0_37.currentVec.y * var1_37)
		end

		arg0_37._bgBackCanvas.alpha = 1
		arg0_37._bgFrontCanvas.alpha = 1
		arg0_37._bgBeamCanvas.alpha = 0

		setActive(arg0_37._box, true)
		setActive(arg0_37._specialPower, true)
		setActive(arg0_37._successPower, true)
		setActive(arg0_37._top, true)
	end

	function var0_31.clear(arg0_38)
		if LeanTween.isTweening(go(arg0_38._sceneTf)) then
			LeanTween.cancel(go(arg0_38._sceneTf), false)
		end
	end

	function var0_31.step(arg0_39)
		local var0_39 = 0
		local var1_39 = 0

		if arg0_39.targetVec.x ~= arg0_39.currentVec.x then
			var0_39 = (arg0_39.targetVec.x - arg0_39.currentVec.x) * var37_0

			if math.abs(var0_39) < var38_0 then
				var0_39 = var38_0 * math.sign(var0_39)
			end

			arg0_39.currentVec.x = arg0_39.currentVec.x + var0_39

			if math.abs(arg0_39.currentVec.x - arg0_39.targetVec.x) <= var38_0 then
				arg0_39.currentVec.x = arg0_39.targetVec.x
			end
		end

		if arg0_39.targetVec.y ~= arg0_39.currentVec.y then
			var1_39 = (arg0_39.targetVec.y - arg0_39.currentVec.y) * var37_0

			if math.abs(var1_39) < var38_0 then
				var1_39 = var38_0 * math.sign(var1_39)
			end

			arg0_39.currentVec.y = arg0_39.currentVec.y + var1_39

			if math.abs(arg0_39.currentVec.y - arg0_39.targetVec.y) <= var38_0 then
				arg0_39.currentVec.y = arg0_39.targetVec.y
			end
		end

		if var0_39 ~= 0 or var1_39 ~= 0 then
			arg0_39:moveTo(arg0_39.currentVec)
		end
	end

	function var0_31.moveTo(arg0_40, arg1_40)
		for iter0_40 = 1, #arg0_40.bgs do
			local var0_40 = arg0_40.bgs[iter0_40].tf
			local var1_40 = arg0_40.bgs[iter0_40].rate

			var0_40.anchoredPosition = Vector2(arg1_40.x * var1_40, arg1_40.y * var1_40)
		end
	end

	function var0_31.setTargetFllow(arg0_41, arg1_41, arg2_41, arg3_41)
		if not arg3_41 then
			arg0_41.targetVec = arg1_41
			arg0_41.moveCallback = arg2_41
		else
			arg0_41.currentVec = arg1_41
			arg0_41.targetVec = arg1_41

			arg0_41:moveTo(arg1_41)

			if arg2_41 then
				arg2_41()
			end
		end
	end

	function var0_31.setBeam(arg0_42, arg1_42, arg2_42)
		if LeanTween.isTweening(go(arg0_42._sceneTf)) then
			LeanTween.cancel(go(arg0_42._sceneTf), false)
		end

		if arg1_42 then
			setActive(arg0_42._box, true)
			setActive(arg0_42._specialPower, true)
			setActive(arg0_42._successPower, true)
			setActive(arg0_42._top, true)
		else
			setActive(arg0_42._box, false)
			setActive(arg0_42._specialPower, false)
			setActive(arg0_42._successPower, false)
			setActive(arg0_42._top, false)
		end

		LeanTween.value(go(arg0_42._sceneTf), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_43)
			if arg1_42 then
				arg0_42._bgBackCanvas.alpha = arg0_43
				arg0_42._bgFrontCanvas.alpha = arg0_43
				arg0_42._bgBeamCanvas.alpha = 1 - arg0_43
			else
				arg0_42._bgBackCanvas.alpha = 1 - arg0_43
				arg0_42._bgFrontCanvas.alpha = 1 - arg0_43
				arg0_42._bgBeamCanvas.alpha = arg0_43
			end
		end)):setOnComplete(System.Action(function()
			if arg2_42 then
				arg2_42()
			end
		end))
	end

	var0_31:ctor()

	return var0_31
end

local function var58_0(arg0_45, arg1_45)
	local var0_45 = {
		ctor = function(arg0_46)
			arg0_46._scene = arg0_45
			arg0_46._tpl = findTF(arg0_46._scene, "tpl")
			arg0_46._leftRolePos = findTF(arg0_46._scene, "rolePos/leftRole")
			arg0_46._rightRolePos = findTF(arg0_46._scene, "rolePos/rightRole")
			arg0_46._event = arg1_45

			arg0_46._event:bind(var13_0, function()
				arg0_46:onGridTrigger()
			end)
			arg0_46._event:bind(var16_0, function()
				arg0_46:onRoleSpecial()
			end)
			arg0_46._event:bind(var17_0, function()
				arg0_46:onRoleSpecialEnd()
			end)
		end,
		start = function(arg0_50)
			if arg0_50.leftRole then
				destroy(arg0_50.leftRole.tf)

				arg0_50.leftRole = nil
			end

			if arg0_50.rightRole then
				destroy(arg0_50.rightRole.tf)

				arg0_50.rightRole = nil
			end

			arg0_50.leftRole = arg0_50:createRole(var31_0, true, arg0_50._leftRolePos)
			arg0_50.rightRole = arg0_50:createRole(var32_0, false, arg0_50._rightRolePos)
			arg0_50.leftRole.targetRole = arg0_50.rightRole
			arg0_50.rightRole.targetRole = arg0_50.leftRole

			arg0_50.leftRole.animator:SetTrigger("idle")
			arg0_50.leftRole.animator:SetBool("special", false)
			arg0_50.rightRole.animator:SetTrigger("idle")
			arg0_50.rightRole.animator:SetBool("special", false)

			arg0_50.leftRole.specialBody = false
			arg0_50.rightRole.specialBody = false
			arg0_50.leftRole.anchoredPosition = Vector2(0, 0)
			arg0_50.rightRole.anchoredPosition = Vector2(0, 0)
			arg0_50.leftRole.specialTime = false
			arg0_50.rightRole.specialTime = false
			arg0_50.playingDatas = {}
			arg0_50.playingDatas[arg0_50.leftRole.name] = {
				role = arg0_50.leftRole
			}
			arg0_50.playingDatas[arg0_50.leftRole.name].skillDatas = {}
			arg0_50.playingDatas[arg0_50.rightRole.name] = {
				role = arg0_50.rightRole
			}
			arg0_50.playingDatas[arg0_50.rightRole.name].skillDatas = {}
			arg0_50.skillDeltaTime = 0
			arg0_50.emptySkillTime = math.random(1, 2)
			arg0_50.addScore = {
				0,
				0
			}

			arg0_50._event:emit(var14_0, {
				Vector2(0, 0),
				false
			})
		end,
		step = function(arg0_51)
			arg0_51:checkSkillDeltaTime()
			arg0_51:checkEmptySkillTime()
		end,
		checkSkillDeltaTime = function(arg0_52)
			if arg0_52.skillDeltaTime and arg0_52.skillDeltaTime <= 0 then
				arg0_52.skillDeltaTime = var39_0
			end

			arg0_52.skillDeltaTime = arg0_52.skillDeltaTime - Time.deltaTime

			if arg0_52.skillDeltaTime <= 0 then
				local var0_52 = false

				for iter0_52, iter1_52 in pairs(arg0_52.playingDatas) do
					if iter1_52.inPlaying then
						var0_52 = true
					end
				end

				if not var0_52 then
					for iter2_52, iter3_52 in pairs(arg0_52.playingDatas) do
						if #iter3_52.skillDatas > 0 then
							if iter3_52.role == arg0_52.leftRole then
								print("开始执行角色攻击")
							end

							arg0_52:applySkillData(iter3_52)

							break
						end
					end
				end
			end

			var55_0 = false

			for iter4_52, iter5_52 in pairs(arg0_52.playingDatas) do
				if iter5_52.inPlaying then
					var55_0 = true
				end
			end
		end,
		checkEmptySkillTime = function(arg0_53)
			if arg0_53.emptySkillTime and arg0_53.emptySkillTime <= 0 then
				arg0_53.emptySkillTime = var40_0
			end

			arg0_53.emptySkillTime = arg0_53.emptySkillTime - Time.deltaTime

			if arg0_53.emptySkillTime <= 0 then
				local var0_53 = false

				for iter0_53, iter1_53 in pairs(arg0_53.playingDatas) do
					if iter1_53.inPlaying then
						var0_53 = true
					end
				end

				if not var0_53 then
					local var1_53 = arg0_53:getRoleEmptySkill(arg0_53.rightRole)

					if var1_53 then
						arg0_53:addRolePlaying(arg0_53.rightRole, var1_53)
					end
				end
			end
		end,
		getRoleEmptySkill = function(arg0_54, arg1_54)
			local var0_54 = {}

			for iter0_54 = 1, #arg1_54.skill do
				local var1_54 = arg1_54.skill[iter0_54]

				if tobool(var1_54.special_time) == arg1_54.specialBody and var1_54.atk_index then
					table.insert(var0_54, var1_54)
				end
			end

			if #var0_54 > 0 then
				return Clone(var0_54[math.random(1, #var0_54)])
			end

			return nil
		end,
		onRoleSpecial = function(arg0_55)
			arg0_55.leftRole.specialTime = true

			for iter0_55 = 1, #arg0_55.leftRole.skill do
				local var0_55 = arg0_55.leftRole.skill[iter0_55]

				if var0_55.special_trigger then
					arg0_55:addRolePlaying(arg0_55.leftRole, Clone(var0_55))
				end
			end
		end,
		onRoleSpecialEnd = function(arg0_56)
			arg0_56.leftRole.specialTime = false

			for iter0_56 = 1, #arg0_56.leftRole.skill do
				local var0_56 = arg0_56.leftRole.skill[iter0_56]

				if not var0_56.special_trigger and var0_56.special_end then
					arg0_56:addRolePlaying(arg0_56.leftRole, Clone(var0_56))
				end
			end
		end,
		clear = function(arg0_57)
			if LeanTween.isTweening(go(arg0_57._leftRolePos)) then
				LeanTween.cancel(go(arg0_57._leftRolePos))
			end

			if LeanTween.isTweening(go(arg0_57._rightRolePos)) then
				LeanTween.cancel(go(arg0_57._rightRolePos))
			end

			if LeanTween.isTweening(go(arg0_57.rightRole.tf)) then
				LeanTween.cancel(go(arg0_57.rightRole.tf))
			end

			if LeanTween.isTweening(go(arg0_57.leftRole.tf)) then
				LeanTween.cancel(go(arg0_57.leftRole.tf))
			end
		end,
		onGridTrigger = function(arg0_58)
			local var0_58 = var21_0.grid_index
			local var1_58 = var21_0.power_grid
			local var2_58 = var21_0.special_time

			for iter0_58 = 1, #arg0_58.leftRole.skill do
				local var3_58 = arg0_58.leftRole.skill[iter0_58]

				if tobool(var3_58.special_time) == tobool(arg0_58.leftRole.specialTime) and var3_58.power_index == var1_58 and table.contains(var3_58.grid_index, var0_58) and var3_58.atk_index then
					arg0_58:addRolePlaying(arg0_58.leftRole, Clone(var3_58))
				end
			end
		end,
		createRole = function(arg0_59, arg1_59, arg2_59, arg3_59)
			local var0_59 = arg0_59:getRoleData(arg1_59)

			if not var0_59 then
				return nil
			end

			local var1_59 = {}
			local var2_59 = tf(instantiate(findTF(arg0_59._tpl, var0_59.name)))

			SetParent(var2_59, arg3_59)

			var2_59.anchoredPosition = Vector2(0, 0)
			var2_59.localScale = Vector3(1, 1, 1)

			setActive(var2_59, true)

			local var3_59 = findTF(var2_59, "body")
			local var4_59 = findTF(var3_59, "anim")
			local var5_59 = GetComponent(var4_59, typeof(Animator))
			local var6_59 = GetComponent(var4_59, typeof(DftAniEvent))

			var6_59:SetStartEvent(function()
				if var1_59.startCallback then
					var1_59.startCallback()
				end
			end)
			var6_59:SetTriggerEvent(function()
				if var1_59.triggerCallback then
					var1_59.triggerCallback()
				end
			end)
			var6_59:SetEndEvent(function()
				if var1_59.endCallback then
					var1_59.endCallback()
				end
			end)

			var1_59.name = var0_59.name
			var1_59.tf = var2_59
			var1_59.canvasGroup = GetComponent(var2_59, typeof(CanvasGroup))
			var1_59.body = var3_59
			var1_59.animTf = var4_59
			var1_59.animator = var5_59
			var1_59.dftEvent = var6_59
			var1_59.startCallback = nil
			var1_59.triggerCallback = nil
			var1_59.endCallback = nil
			var1_59.skill = var0_59.skill
			var1_59.name = var0_59.name
			var1_59.index = var0_59.index
			var1_59.actions = var0_59.actions

			return var1_59
		end,
		getRoleData = function(arg0_63, arg1_63)
			for iter0_63 = 1, #var53_0 do
				if var53_0[iter0_63].index == arg1_63 then
					return Clone(var53_0[iter0_63])
				end
			end

			return nil
		end,
		setDftHandle = function(arg0_64, arg1_64, arg2_64, arg3_64, arg4_64)
			arg1_64.startCallback = arg2_64
			arg1_64.triggerCallback = arg3_64
			arg1_64.endCallback = arg4_64
		end,
		playAnimation = function(arg0_65, arg1_65, arg2_65)
			print(arg1_65.name .. " 执行动画 ：" .. arg2_65 .. "  active:" .. tostring(arg1_65.animator.isActiveAndEnabled) .. tostring(Time.GetTimestamp()))
			arg1_65.animator:Play("emptyAnimation", -1, 0)
			arg1_65.animator:Play(arg2_65, -1, 0)
		end,
		addRolePlaying = function(arg0_66, arg1_66, arg2_66, arg3_66)
			for iter0_66, iter1_66 in pairs(arg0_66.playingDatas) do
				if iter0_66 == arg1_66.name then
					if arg3_66 then
						arg0_66:applySkillData(iter1_66, arg2_66)
					else
						table.insert(iter1_66.skillDatas, arg2_66)

						if arg2_66.power_index > 0 and arg2_66.atk_index > 1 or arg2_66.special_trigger then
							for iter2_66 = #iter1_66.skillDatas - 1, 1, -1 do
								local var0_66 = iter1_66.skillDatas[iter2_66]

								if var0_66.power_index == 0 and var0_66.atk_index == 1 then
									local var1_66 = table.remove(iter1_66.skillDatas, iter2_66)

									if var1_66.score then
										arg0_66.addScore = {
											arg0_66.addScore[1] + var1_66.score[1],
											arg0_66.addScore[2] + var1_66.score[2]
										}
									end
								end
							end
						end
					end
				end
			end
		end,
		applySkillData = function(arg0_67, arg1_67, arg2_67)
			arg1_67.inPlaying = true

			local var0_67 = arg1_67.role
			local var1_67 = arg2_67 or table.remove(arg1_67.skillDatas, 1)

			arg1_67.currentSkill = var1_67
			arg1_67.actions = var1_67.actions

			local var2_67 = var1_67.anim_bool

			if var2_67 then
				var0_67.animator:SetBool(var2_67, true)
			end

			if var0_67 == arg0_67.leftRole and not var1_67.dmg_index then
				arg0_67._leftRolePos:SetSiblingIndex(1)
			elseif var0_67 == arg0_67.rightRole and not var1_67.dmg_index then
				arg0_67._rightRolePos:SetSiblingIndex(1)
			end

			if var1_67.special_end then
				arg1_67.role.specialBody = false
			elseif var1_67.special_trigger then
				arg1_67.role.specialBody = true
			end

			arg1_67.actionIndex = 1

			arg0_67:checkAction(arg1_67, function()
				arg1_67.inPlaying = false

				print(arg1_67.role.name .. "动画播放完毕")
			end)
		end,
		checkAction = function(arg0_69, arg1_69, arg2_69)
			if arg1_69.actions and arg1_69.actionIndex <= #arg1_69.actions then
				print("准备执行" .. arg1_69.actions[arg1_69.actionIndex].anim_name .. "上一个动作:" .. tostring(arg1_69.playingAction and arg1_69.playingAction.anim_name))

				arg1_69.playingAction = arg1_69.actions[arg1_69.actionIndex]
				arg1_69.actionIndex = arg1_69.actionIndex + 1

				local var0_69 = arg1_69.playingAction.anim_name
				local var1_69 = arg1_69.playingAction.time
				local var2_69 = arg1_69.playingAction.move
				local var3_69 = arg1_69.playingAction.over_offset
				local var4_69 = arg1_69.playingAction.camera
				local var5_69 = arg1_69.playingAction.sound_start
				local var6_69 = arg1_69.playingAction.sound_trigger
				local var7_69 = arg1_69.playingAction.sound_end
				local var8_69 = arg1_69.currentSkill.special_trigger
				local var9_69 = arg1_69.currentSkill.special_time
				local var10_69 = arg1_69.currentSkill.atk_index

				if var8_69 or var9_69 and var10_69 and var10_69 >= 2 then
					arg0_69._event:emit(var20_0, true)
				end

				if var1_69 and var1_69 > 0 then
					-- block empty
				else
					local function var11_69()
						if var5_69 then
							pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/" .. var5_69)
						end

						if var2_69 then
							arg0_69:moveRole(arg1_69.role, var2_69)
						end

						if var4_69 then
							arg1_69.role.targetRole.canvasGroup.alpha = 0

							arg0_69._event:emit(var18_0)
						end
					end

					local function var12_69()
						if var6_69 then
							pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/" .. var6_69)
						end

						if var4_69 then
							var4_69 = false
							arg1_69.role.targetRole.canvasGroup.alpha = 1

							arg0_69._event:emit(var19_0)
						else
							local var0_71 = arg1_69.currentSkill.atk_index

							if var0_71 then
								local var1_71 = arg0_69:getRoleDmgData(arg1_69.role.targetRole, var0_71)

								if var1_71 then
									arg0_69:addRolePlaying(arg1_69.role.targetRole, Clone(var1_71), true)
								end

								local var2_71 = arg1_69.currentSkill.score

								if var2_71 and arg1_69.role == arg0_69.leftRole then
									arg0_69._event:emit(var15_0, math.random(var2_71[1] + arg0_69.addScore[1], var2_71[2] + arg0_69.addScore[2]))

									arg0_69.addScore = {
										0,
										0
									}
								end
							end
						end
					end

					local function var13_69()
						if var7_69 then
							pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/" .. var7_69)
						end

						if LeanTween.isTweening(go(arg1_69.role.tf)) then
							LeanTween.cancel(go(arg1_69.role.tf))
						end

						arg0_69._event:emit(var20_0, false)

						if var3_69 then
							arg1_69.role.tf.anchoredPosition = Vector2(arg1_69.role.tf.anchoredPosition.x + var3_69.x, arg1_69.role.tf.anchoredPosition.y + var3_69.y)
						end

						if arg1_69.currentSkill.special_trigger and var21_0.special_time and not var21_0.special_complete then
							var21_0.special_complete = true
						end

						arg1_69.playingAction = nil

						arg0_69:setDftHandle(arg1_69.role, nil, nil, nil)
						print(arg1_69.role.name .. "执行 " .. var0_69 .. "结束")
						arg0_69:checkAction(arg1_69, arg2_69)
					end

					arg0_69:setDftHandle(arg1_69.role, var11_69, var12_69, var13_69)
					arg0_69:playAnimation(arg1_69.role, var0_69)
				end
			else
				if arg1_69.role == arg0_69.leftRole then
					print(arg1_69.role.name .. "队列结束")
				end

				if arg2_69 then
					arg2_69()
				end
			end
		end,
		moveRole = function(arg0_73, arg1_73, arg2_73)
			if LeanTween.isTweening(go(arg1_73.tf)) then
				LeanTween.cancel(go(arg1_73.tf))
			end

			arg0_73._event:emit(var14_0, {
				arg2_73.distance,
				arg1_73 == arg0_73.leftRole
			})
			LeanTween.move(arg1_73.tf, Vector3(arg2_73.distance.x, arg2_73.distance.y, 0), arg2_73.time):setEase(arg2_73.ease or LeanTweenType.linear)
		end,
		getRoleDmgData = function(arg0_74, arg1_74, arg2_74)
			local var0_74 = arg1_74.skill

			for iter0_74 = 1, #var0_74 do
				local var1_74 = var0_74[iter0_74]

				if var1_74.dmg_index == arg2_74 and var1_74.special_time == tobool(arg1_74.specialBody) then
					return var1_74
				end
			end

			return nil
		end
	}

	var0_45:ctor()

	return var0_45
end

function var0_0.getUIName(arg0_75)
	return "GridGameUI"
end

function var0_0.didEnter(arg0_76)
	arg0_76:initEvent()
	arg0_76:initData()
	arg0_76:initUI()
	arg0_76:initGameUI()
	arg0_76:initController()
	arg0_76:updateMenuUI()
	arg0_76:openMenuUI()
end

function var0_0.initEvent(arg0_77)
	arg0_77:bind(var15_0, function(arg0_78, arg1_78, arg2_78)
		arg0_77:addScore(arg1_78)
	end)
	arg0_77:bind(var20_0, function(arg0_79, arg1_79, arg2_79)
		arg0_77.ignoreTime = arg1_79
	end)
end

function var0_0.onEventHandle(arg0_80, arg1_80)
	return
end

function var0_0.initData(arg0_81)
	local var0_81 = Application.targetFrameRate or 60

	if var0_81 > 60 then
		var0_81 = 60
	end

	arg0_81.timer = Timer.New(function()
		arg0_81:onTimer()
	end, 1 / var0_81, -1)
end

function var0_0.initUI(arg0_83)
	arg0_83.backSceneTf = findTF(arg0_83._tf, "scene_background")
	arg0_83.sceneTf = findTF(arg0_83._tf, "scene")
	arg0_83.clickMask = findTF(arg0_83._tf, "clickMask")

	setText(findTF(arg0_83._tf, "ui/gameUI/top/time"), i18n("mini_game_time"))
	setText(findTF(arg0_83._tf, "ui/gameUI/top/scoreDesc"), i18n("mini_game_score"))
	setText(findTF(arg0_83._tf, "pop/LeaveUI/ad/desc"), i18n("mini_game_leave"))
	setText(findTF(arg0_83._tf, "pop/pauseUI/ad/desc"), i18n("mini_game_pause"))
	setText(findTF(arg0_83._tf, "pop/SettleMentUI/ad/currentTextDesc"), i18n("mini_game_cur_score"))
	setText(findTF(arg0_83._tf, "pop/SettleMentUI/ad/highTextDesc"), i18n("mini_game_high_score"))

	arg0_83.countUI = findTF(arg0_83._tf, "pop/CountUI")
	arg0_83.countAnimator = GetComponent(findTF(arg0_83.countUI, "count"), typeof(Animator))
	arg0_83.countDft = GetOrAddComponent(findTF(arg0_83.countUI, "count"), typeof(DftAniEvent))

	arg0_83.countDft:SetTriggerEvent(function()
		return
	end)
	arg0_83.countDft:SetEndEvent(function()
		setActive(arg0_83.countUI, false)
		arg0_83:gameStart()
	end)

	arg0_83.leaveUI = findTF(arg0_83._tf, "pop/LeaveUI")

	onButton(arg0_83, findTF(arg0_83.leaveUI, "ad/btnOk"), function()
		arg0_83:resumeGame()
		arg0_83:onGameOver()
	end, SFX_CANCEL)
	onButton(arg0_83, findTF(arg0_83.leaveUI, "ad/btnCancel"), function()
		arg0_83:resumeGame()
	end, SFX_CANCEL)

	arg0_83.pauseUI = findTF(arg0_83._tf, "pop/pauseUI")

	onButton(arg0_83, findTF(arg0_83.pauseUI, "ad/btnOk"), function()
		setActive(arg0_83.pauseUI, false)
		arg0_83:resumeGame()
	end, SFX_CANCEL)

	arg0_83.settlementUI = findTF(arg0_83._tf, "pop/SettleMentUI")

	onButton(arg0_83, findTF(arg0_83.settlementUI, "ad/btnOver"), function()
		setActive(arg0_83.settlementUI, false)
		arg0_83:openMenuUI()
	end, SFX_CANCEL)

	arg0_83.selectedUI = findTF(arg0_83._tf, "pop/selectedUI")
	arg0_83.leftSelectRole = {}

	for iter0_83 = 1, #var33_0 do
		local var0_83 = findTF(arg0_83.selectedUI, "ad/leftRole/role" .. var33_0[iter0_83])
		local var1_83 = var33_0[iter0_83]

		onButton(arg0_83, var0_83, function()
			if var32_0 == var1_83 then
				var32_0 = var31_0
			end

			var31_0 = var1_83

			arg0_83:updateSelectedUI()
		end, SFX_CONFIRM)
		table.insert(arg0_83.leftSelectRole, {
			id = var1_83,
			tf = var0_83
		})
	end

	onButton(arg0_83, findTF(arg0_83.selectedUI, "close"), function()
		setActive(arg0_83.selectedUI, false)
	end, SFX_CANCEL)

	arg0_83.rightSelectRole = {}

	for iter1_83 = 1, #var34_0 do
		local var2_83 = findTF(arg0_83.selectedUI, "ad/rightRole/role" .. var34_0[iter1_83])
		local var3_83 = var34_0[iter1_83]

		onButton(arg0_83, var2_83, function()
			if var31_0 == var3_83 then
				var31_0 = var32_0

				if not table.contains(var33_0, var31_0) then
					for iter0_92, iter1_92 in ipairs(var33_0) do
						if iter1_92 ~= var3_83 then
							var31_0 = iter1_92
						end
					end
				end
			end

			var32_0 = var3_83

			arg0_83:updateSelectedUI()
		end, SFX_CONFIRM)
		table.insert(arg0_83.rightSelectRole, {
			id = var3_83,
			tf = var2_83
		})
	end

	onButton(arg0_83, findTF(arg0_83.selectedUI, "ad/btnOk"), function()
		setActive(arg0_83.selectedUI, false)
		setActive(arg0_83.menuUI, false)
		arg0_83:readyStart()
	end, SFX_CONFIRM)
	setActive(arg0_83.selectedUI, false)

	arg0_83.menuUI = findTF(arg0_83._tf, "pop/menuUI")
	arg0_83.battleScrollRect = GetComponent(findTF(arg0_83.menuUI, "battList"), typeof(ScrollRect))
	arg0_83.totalTimes = arg0_83:getGameTotalTime()

	local var4_83 = arg0_83:getGameUsedTimes() - 4 < 0 and 0 or arg0_83:getGameUsedTimes() - 4

	scrollTo(arg0_83.battleScrollRect, 0, 1 - var4_83 / (arg0_83.totalTimes - 4))
	onButton(arg0_83, findTF(arg0_83.menuUI, "rightPanelBg/arrowUp"), function()
		local var0_94 = arg0_83.battleScrollRect.normalizedPosition.y + 1 / (arg0_83.totalTimes - 4)

		if var0_94 > 1 then
			var0_94 = 1
		end

		scrollTo(arg0_83.battleScrollRect, 0, var0_94)
	end, SFX_CANCEL)
	onButton(arg0_83, findTF(arg0_83.menuUI, "rightPanelBg/arrowDown"), function()
		local var0_95 = arg0_83.battleScrollRect.normalizedPosition.y - 1 / (arg0_83.totalTimes - 4)

		if var0_95 < 0 then
			var0_95 = 0
		end

		scrollTo(arg0_83.battleScrollRect, 0, var0_95)
	end, SFX_CANCEL)
	onButton(arg0_83, findTF(arg0_83.menuUI, "btnBack"), function()
		arg0_83:closeView()
	end, SFX_CANCEL)
	onButton(arg0_83, findTF(arg0_83.menuUI, "btnRule"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.ssss_game_tip.tip
		})
	end, SFX_CONFIRM)
	onButton(arg0_83, findTF(arg0_83.menuUI, "btnStart"), function()
		local var0_98 = arg0_83:getGameUsedTimes() or 0
		local var1_98 = arg0_83:getGameTimes() or 0

		if var0_98 >= #var35_0 and arg0_83.selectedUI then
			arg0_83:updateSelectedUI()
			setActive(arg0_83.selectedUI, true)
		else
			local var2_98
			local var3_98 = var0_98 == 0 and 1 or var1_98 > 0 and var0_98 + 1 or var0_98

			if var3_98 > #var35_0 then
				var3_98 = #var35_0
			end

			local var4_98 = var35_0[var3_98]

			var31_0 = var4_98[1]
			var32_0 = var4_98[2]

			setActive(arg0_83.menuUI, false)
			arg0_83:readyStart()
		end
	end, SFX_CONFIRM)

	local var5_83 = findTF(arg0_83.menuUI, "tplBattleItem")

	arg0_83.battleItems = {}
	arg0_83.dropItems = {}

	for iter2_83 = 1, 7 do
		local var6_83 = tf(instantiate(var5_83))

		var6_83.name = "battleItem_" .. iter2_83

		setParent(var6_83, findTF(arg0_83.menuUI, "battList/Viewport/Content"))

		local var7_83 = iter2_83

		GetSpriteFromAtlasAsync("ui/gridgameui_atlas", "battleDesc" .. var7_83, function(arg0_99)
			setImageSprite(findTF(var6_83, "state_open/buttomDesc"), arg0_99, true)
			setImageSprite(findTF(var6_83, "state_clear/buttomDesc"), arg0_99, true)
			setImageSprite(findTF(var6_83, "state_current/buttomDesc"), arg0_99, true)
			setImageSprite(findTF(var6_83, "state_closed/buttomDesc"), arg0_99, true)
		end)
		setActive(var6_83, true)
		table.insert(arg0_83.battleItems, var6_83)
	end

	if not arg0_83.handle then
		arg0_83.handle = UpdateBeat:CreateListener(arg0_83.Update, arg0_83)
	end

	UpdateBeat:AddListener(arg0_83.handle)
end

function var0_0.initGameUI(arg0_100)
	arg0_100.gameUI = findTF(arg0_100._tf, "ui/gameUI")

	onButton(arg0_100, findTF(arg0_100.gameUI, "topRight/btnStop"), function()
		arg0_100:stopGame()
		setActive(arg0_100.pauseUI, true)
	end)
	onButton(arg0_100, findTF(arg0_100.gameUI, "btnLeave"), function()
		arg0_100:stopGame()
		setActive(arg0_100.leaveUI, true)
	end)

	arg0_100.gameTimeS = findTF(arg0_100.gameUI, "top/time/s")
	arg0_100.scoreTf = findTF(arg0_100.gameUI, "top/score")
	arg0_100.scoreAnimTf = findTF(arg0_100._tf, "sceneContainer/scene_front/scoreAnim")
	arg0_100.scoreAnimTextTf = findTF(arg0_100._tf, "sceneContainer/scene_front/scoreAnim/text")

	setActive(arg0_100.scoreAnimTf, false)
end

function var0_0.initController(arg0_103)
	local var0_103 = findTF(arg0_103.gameUI, "box")

	arg0_103.boxController = var54_0(var0_103, arg0_103)

	local var1_103 = findTF(arg0_103.gameUI, "specialPower")
	local var2_103 = findTF(arg0_103.gameUI, "successPower")

	arg0_103.specialController = var56_0(var1_103, var2_103, arg0_103)

	local var3_103 = findTF(arg0_103._tf, "sceneContainer")

	arg0_103.bgController = var57_0(var3_103, arg0_103.gameUI, arg0_103)

	local var4_103 = findTF(arg0_103._tf, "sceneContainer/scene")

	arg0_103.roleController = var58_0(var4_103, arg0_103)
end

function var0_0.Update(arg0_104)
	arg0_104:AddDebugInput()
end

function var0_0.AddDebugInput(arg0_105)
	if arg0_105.gameStop or arg0_105.settlementFlag then
		return
	end

	if IsUnityEditor then
		-- block empty
	end
end

function var0_0.updateSelectedUI(arg0_106)
	for iter0_106 = 1, #arg0_106.leftSelectRole do
		local var0_106 = arg0_106.leftSelectRole[iter0_106]

		if var31_0 == var0_106.id then
			setActive(findTF(var0_106.tf, "selected"), true)
			setActive(findTF(var0_106.tf, "unSelected"), false)
		else
			setActive(findTF(var0_106.tf, "selected"), false)
			setActive(findTF(var0_106.tf, "unSelected"), true)
		end
	end

	for iter1_106 = 1, #arg0_106.rightSelectRole do
		local var1_106 = arg0_106.rightSelectRole[iter1_106]

		if var32_0 == var1_106.id then
			setActive(findTF(var1_106.tf, "selected"), true)
			setActive(findTF(var1_106.tf, "unSelected"), false)
		else
			setActive(findTF(var1_106.tf, "selected"), false)
			setActive(findTF(var1_106.tf, "unSelected"), true)
		end
	end
end

function var0_0.updateMenuUI(arg0_107)
	local var0_107 = arg0_107:getGameUsedTimes()

	if var0_107 and var0_107 >= 7 then
		setActive(findTF(arg0_107.menuUI, "btnStart/free"), true)
	else
		setActive(findTF(arg0_107.menuUI, "btnStart/free"), false)
	end

	local var1_107 = arg0_107:getGameTimes()

	for iter0_107 = 1, #arg0_107.battleItems do
		setActive(findTF(arg0_107.battleItems[iter0_107], "state_open"), false)
		setActive(findTF(arg0_107.battleItems[iter0_107], "state_closed"), false)
		setActive(findTF(arg0_107.battleItems[iter0_107], "state_clear"), false)
		setActive(findTF(arg0_107.battleItems[iter0_107], "state_current"), false)

		if iter0_107 <= var0_107 then
			setActive(findTF(arg0_107.battleItems[iter0_107], "state_clear"), true)
		elseif iter0_107 == var0_107 + 1 and var1_107 >= 1 then
			setActive(findTF(arg0_107.battleItems[iter0_107], "state_current"), true)
		elseif var0_107 < iter0_107 and iter0_107 <= var0_107 + var1_107 then
			setActive(findTF(arg0_107.battleItems[iter0_107], "state_open"), true)
		else
			setActive(findTF(arg0_107.battleItems[iter0_107], "state_closed"), true)
		end
	end

	arg0_107.totalTimes = arg0_107:getGameTotalTime()

	local var2_107 = 1 - (arg0_107:getGameUsedTimes() - 3 < 0 and 0 or arg0_107:getGameUsedTimes() - 3) / (arg0_107.totalTimes - 4)

	if var2_107 > 1 then
		var2_107 = 1
	end

	scrollTo(arg0_107.battleScrollRect, 0, var2_107)
	setActive(findTF(arg0_107.menuUI, "btnStart/tip"), var1_107 > 0)
	arg0_107:CheckGet()
end

function var0_0.CheckGet(arg0_108)
	setActive(findTF(arg0_108.menuUI, "got"), false)

	if arg0_108:getUltimate() and arg0_108:getUltimate() ~= 0 then
		setActive(findTF(arg0_108.menuUI, "got"), true)
	end

	if arg0_108:getUltimate() == 0 then
		if arg0_108:getGameTotalTime() > arg0_108:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_108:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0_108.menuUI, "got"), true)
	end
end

function var0_0.openMenuUI(arg0_109)
	setActive(findTF(arg0_109._tf, "sceneContainer/scene_front"), false)
	setActive(findTF(arg0_109._tf, "sceneContainer/scene_background"), false)
	setActive(findTF(arg0_109._tf, "sceneContainer/scene"), false)
	setActive(arg0_109.gameUI, false)
	setActive(arg0_109.menuUI, true)
	setActive(arg0_109.selectedUI, false)
	arg0_109:updateMenuUI()

	local var0_109 = arg0_109:getBGM()

	if not var0_109 then
		if pg.CriMgr.GetInstance():IsDefaultBGM() then
			var0_109 = pg.voice_bgm.NewMainScene.default_bgm
		else
			var0_109 = pg.voice_bgm.NewMainScene.bgm
		end
	end

	if arg0_109.bgm ~= var0_109 then
		arg0_109.bgm = var0_109

		pg.BgmMgr.GetInstance():Push(arg0_109.__cname, var0_109)
	end
end

function var0_0.clearUI(arg0_110)
	setActive(arg0_110.sceneTf, false)
	setActive(arg0_110.settlementUI, false)
	setActive(arg0_110.countUI, false)
	setActive(arg0_110.menuUI, false)
	setActive(arg0_110.gameUI, false)
	setActive(arg0_110.selectedUI, false)
end

function var0_0.readyStart(arg0_111)
	setActive(arg0_111.countUI, true)
	arg0_111.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2_0)

	if var1_0 and arg0_111.bgm ~= var1_0 then
		arg0_111.bgm = var1_0

		pg.BgmMgr.GetInstance():Push(arg0_111.__cname, var1_0)
	end
end

function var0_0.gameStart(arg0_112)
	setActive(findTF(arg0_112._tf, "sceneContainer/scene_front"), true)
	setActive(findTF(arg0_112._tf, "sceneContainer/scene_background"), true)
	setActive(findTF(arg0_112._tf, "sceneContainer/scene"), true)
	setActive(arg0_112.scoreAnimTf, false)
	setActive(arg0_112.gameUI, true)

	arg0_112.gameStartFlag = true
	arg0_112.scoreNum = 0
	arg0_112.playerPosIndex = 2
	arg0_112.gameStepTime = 0
	arg0_112.gameTime = var5_0
	arg0_112.ignoreTime = false

	arg0_112.boxController:start()
	arg0_112.specialController:start()
	arg0_112.bgController:start()
	arg0_112.roleController:start()
	arg0_112:updateGameUI()
	arg0_112:timerStart()
end

function var0_0.getGameTimes(arg0_113)
	return arg0_113:GetMGHubData().count
end

function var0_0.getGameUsedTimes(arg0_114)
	return arg0_114:GetMGHubData().usedtime
end

function var0_0.getUltimate(arg0_115)
	return arg0_115:GetMGHubData().ultimate
end

function var0_0.getGameTotalTime(arg0_116)
	return (arg0_116:GetMGHubData():getConfig("reward_need"))
end

function var0_0.changeSpeed(arg0_117, arg1_117)
	return
end

function var0_0.onTimer(arg0_118)
	arg0_118:gameStep()
end

function var0_0.gameStep(arg0_119)
	if not arg0_119.ignoreTime then
		arg0_119.gameTime = arg0_119.gameTime - Time.deltaTime

		if arg0_119.gameTime < 0 then
			arg0_119.gameTime = 0
		end

		arg0_119.gameStepTime = arg0_119.gameStepTime + Time.deltaTime
	end

	arg0_119.boxController:step()
	arg0_119.specialController:step()
	arg0_119.bgController:step()
	arg0_119.roleController:step()
	arg0_119:updateGameUI()

	if arg0_119.gameTime <= 0 then
		arg0_119:onGameOver()

		return
	end
end

function var0_0.timerStart(arg0_120)
	if not arg0_120.timer.running then
		arg0_120.timer:Start()
	end
end

function var0_0.timerStop(arg0_121)
	if arg0_121.timer.running then
		arg0_121.timer:Stop()
	end
end

function var0_0.updateGameUI(arg0_122)
	setText(arg0_122.scoreTf, arg0_122.scoreNum)
	setText(arg0_122.gameTimeS, math.ceil(arg0_122.gameTime))
end

function var0_0.addScore(arg0_123, arg1_123)
	setActive(arg0_123.scoreAnimTf, false)
	setActive(arg0_123.scoreAnimTf, true)
	setText(arg0_123.scoreAnimTextTf, "+" .. tostring(arg1_123))

	arg0_123.scoreNum = arg0_123.scoreNum + arg1_123

	if arg0_123.scoreNum < 0 then
		arg0_123.scoreNum = 0
	end
end

function var0_0.onGameOver(arg0_124)
	if arg0_124.settlementFlag then
		return
	end

	arg0_124:timerStop()

	arg0_124.settlementFlag = true

	setActive(arg0_124.clickMask, true)

	if arg0_124.roleController then
		arg0_124.roleController:clear()
	end

	if arg0_124.bgController then
		arg0_124.bgController:clear()
	end

	LeanTween.delayedCall(go(arg0_124._tf), 0.1, System.Action(function()
		arg0_124.settlementFlag = false
		arg0_124.gameStartFlag = false

		setActive(arg0_124.clickMask, false)
		arg0_124:showSettlement()
	end))
end

function var0_0.showSettlement(arg0_126)
	setActive(arg0_126.settlementUI, true)
	GetComponent(findTF(arg0_126.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0_126 = arg0_126:GetMGData():GetRuntimeData("elements")
	local var1_126 = arg0_126.scoreNum
	local var2_126 = var0_126 and #var0_126 > 0 and var0_126[1] or 0

	setActive(findTF(arg0_126.settlementUI, "ad/new"), var2_126 < var1_126)

	if var2_126 <= var1_126 then
		var2_126 = var1_126

		arg0_126:StoreDataToServer({
			var2_126
		})
	end

	local var3_126 = findTF(arg0_126.settlementUI, "ad/highText")
	local var4_126 = findTF(arg0_126.settlementUI, "ad/currentText")

	setText(var3_126, var2_126)
	setText(var4_126, var1_126)

	if arg0_126:getGameTimes() and arg0_126:getGameTimes() > 0 then
		arg0_126.sendSuccessFlag = true

		arg0_126:SendSuccess(0)
	end
end

function var0_0.resumeGame(arg0_127)
	arg0_127.gameStop = false

	setActive(arg0_127.leaveUI, false)
	arg0_127:changeSpeed(1)
	arg0_127:timerStart()
end

function var0_0.stopGame(arg0_128)
	arg0_128.gameStop = true

	arg0_128:timerStop()
	arg0_128:changeSpeed(0)
end

function var0_0.onBackPressed(arg0_129)
	if not arg0_129.gameStartFlag then
		arg0_129:emit(var0_0.ON_BACK_PRESSED)
	else
		if arg0_129.settlementFlag then
			return
		end

		if isActive(arg0_129.pauseUI) then
			setActive(arg0_129.pauseUI, false)
		end

		arg0_129:stopGame()
		setActive(arg0_129.leaveUI, true)
	end
end

function var0_0.willExit(arg0_130)
	if arg0_130.handle then
		UpdateBeat:RemoveListener(arg0_130.handle)
	end

	if arg0_130._tf and LeanTween.isTweening(go(arg0_130._tf)) then
		LeanTween.cancel(go(arg0_130._tf))
	end

	if arg0_130.timer and arg0_130.timer.running then
		arg0_130.timer:Stop()
	end

	Time.timeScale = 1
	arg0_130.timer = nil
end

return var0_0
