return {
	uiEffect = "",
	name = "守卫之盾",
	cd = 0,
	painting = 0,
	id = 801541,
	picture = "0",
	castCV = "",
	desc = "守卫之盾",
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
				buff_id = 801544
			}
		}
	}
}
