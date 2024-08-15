return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 0,
	id = 150373,
	picture = "0",
	castCV = "",
	desc = "伤害提高",
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
				buff_id = 150373
			}
		}
	}
}
