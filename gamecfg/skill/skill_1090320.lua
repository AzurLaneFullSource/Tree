return {
	uiEffect = "",
	name = "紧急回避·大斗犬",
	cd = 0,
	painting = 1,
	id = 1090320,
	picture = "0",
	castCV = "skill",
	desc = "紧急回避",
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
				buff_id = 4070
			}
		}
	}
}
