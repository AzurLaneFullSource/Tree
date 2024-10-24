return {
	uiEffect = "",
	name = "",
	cd = 0,
	id = 40511,
	picture = "0",
	desc = "回血",
	effect_list = {
		{
			type = "BattleSkillHeal",
			casterAniEffect = "",
			target_choise = "TargetSelf",
			targetAniEffect = "",
			arg_list = {
				maxHPRatio = 0.05
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			targetAniEffect = "",
			target_choise = {
				"TargetAllHelp",
				"TargetShipTag"
			},
			arg_list = {
				buff_id = 40512,
				ship_tag_list = {
					"FancyNyaSkill"
				}
			}
		}
	}
}
