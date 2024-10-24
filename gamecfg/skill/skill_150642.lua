return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 1,
	id = 150242,
	picture = "0",
	castCV = "skill",
	desc = "",
	effect_list = {
		{
			type = "BattleSkillHeal",
			casterAniEffect = "",
			targetAniEffect = "",
			target_choise = {
				"TargetAllHelp",
				"TargetHelpLeastHPRatio"
			},
			arg_list = {
				maxHPRatio = 0.04
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			targetAniEffect = "",
			target_choise = {
				"TargetAllHelp",
				"TargetHelpLeastHPRatio"
			},
			arg_list = {
				buff_id = 150645
			}
		}
	}
}
