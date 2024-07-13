return {
	uiEffect = "",
	name = "战术模拟",
	cd = 0,
	painting = 1,
	id = 8540,
	picture = "0",
	castCV = "",
	desc = "战术模拟",
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
				buff_id = 8541
			}
		}
	}
}
