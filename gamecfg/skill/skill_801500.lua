return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 1,
	id = 801500,
	picture = "0",
	desc = "",
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
				buff_id = 801502
			}
		},
		{
			type = "BattleSkillDamage",
			casterAniEffect = "",
			target_choise = "TargetSelf",
			targetAniEffect = "",
			arg_list = {
				number = 130
			}
		}
	}
}
