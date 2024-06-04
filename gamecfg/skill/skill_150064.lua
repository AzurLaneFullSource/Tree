return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 1,
	id = 150064,
	picture = "0",
	castCV = "skill",
	desc = "",
	effect_list = {
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			targetAniEffect = "",
			target_choise = {
				"TargetSelf"
			},
			arg_list = {
				buff_id = 150062
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			targetAniEffect = "",
			target_choise = {
				"TargetAllHelp",
				"TargetShipType"
			},
			arg_list = {
				buff_id = 150062,
				ship_type_list = {
					4,
					5
				}
			}
		}
	}
}
