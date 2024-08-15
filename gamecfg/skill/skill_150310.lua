return {
	uiEffect = "",
	name = "彩虹计划·改",
	cd = 0,
	painting = 1,
	id = 150310,
	picture = "0",
	castCV = "skill",
	desc = "彩虹计划·改",
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
			target_choise = "TargetPlayerVanguardFleet",
			targetAniEffect = "",
			arg_list = {
				buff_id = 150311
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			target_choise = "TargetSelf",
			targetAniEffect = "",
			arg_list = {
				buff_id = 150312
			}
		}
	}
}
