return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 1,
	id = 150230,
	picture = "0",
	castCV = "skill",
	desc = "提高暴击、爆伤",
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
			target_choise = "TargetSelf",
			targetAniEffect = "",
			arg_list = {
				buff_id = 150231
			}
		}
	}
}
