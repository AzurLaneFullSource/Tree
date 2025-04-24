return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 1,
	id = 151132,
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
			target_choise = "TargetSelf",
			type = "BattleSkillEditTag",
			arg_list = {
				tag = "kashanzengyi"
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			targetAniEffect = "",
			target_choise = {
				"TargetAllHelp"
			},
			arg_list = {
				buff_id = 151133
			}
		}
	}
}
