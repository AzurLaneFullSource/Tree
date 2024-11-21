return {
	uiEffect = "",
	name = "",
	cd = 0,
	id = 111143,
	picture = "0",
	desc = "",
	effect_list = {
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			target_choise = "TargetSelf",
			targetAniEffect = "",
			arg_list = {
				buff_id = 111145
			}
		},
		{
			type = "BattleSkillHeal",
			casterAniEffect = "",
			target_choise = "TargetSelf",
			targetAniEffect = "",
			arg_list = {
				maxHPRatio = 0.1
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			target_choise = "TargetShipTag",
			targetAniEffect = "",
			arg_list = {
				buff_id = 111142,
				minTargetNumber = 0,
				ship_tag_list = {
					"haruna_only"
				}
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			targetAniEffect = "",
			target_choise = {
				"TargetPlayerMainFleet",
				"TargetShipTag"
			},
			arg_list = {
				buff_id = 111147,
				ship_tag_list = {
					"ToloveHaruna"
				}
			}
		}
	}
}
