return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 1,
	id = 19802,
	picture = "0",
	castCV = "skill",
	desc = "耐久回复",
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
			type = "BattleSkillHeal",
			target_choise = {
				"TargetSelf"
			},
			arg_list = {
				maxHPRatio = 0.04
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			target_choise = "TargetSelf",
			targetAniEffect = "",
			arg_list = {
				buff_id = 19805
			}
		}
	}
}
