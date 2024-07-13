return {
	uiEffect = "",
	name = "",
	cd = 0,
	id = 17941,
	desc = "",
	effect_list = {
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			target_choise = "TargetSelf",
			targetAniEffect = "",
			arg_list = {
				buff_id = 17948,
				delay = 0.1
			}
		},
		{
			type = "BattleSkillTeleport",
			target_choise = {
				"TargetAllHarm",
				"TargetShipTag"
			},
			arg_list = {
				delay = 0.1,
				targetRelativeCorrdinate = {
					hrz = 8,
					vrt = 0
				},
				ship_tag_list = {
					"MJDE1AIM"
				}
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			target_choise = "TargetSelf",
			targetAniEffect = "",
			arg_list = {
				buff_id = 17944,
				delay = 0.1
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			target_choise = "TargetSelf",
			targetAniEffect = "",
			arg_list = {
				buff_id = 17946,
				delay = 0.4
			}
		}
	}
}
