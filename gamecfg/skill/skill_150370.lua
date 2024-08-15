return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 1,
	id = 150370,
	picture = "",
	castCV = "skill",
	desc = "弹条用,进随机选角色buff",
	aniEffect = {
		effect = "jineng",
		offset = {
			0,
			-2,
			0
		}
	},
	effect_list = {
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			targetAniEffect = "",
			target_choise = {
				"TargetSelf"
			},
			arg_list = {
				buff_id = 150375
			}
		}
	}
}
