return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 1,
	id = 150591,
	picture = "0",
	castCV = "",
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
			targetAniEffect = "",
			target_choise = {
				"TargetAllHelp",
				"TargetShipTag",
				"TargetRandom"
			},
			arg_list = {
				buff_id = 150592,
				randomCount = 1,
				ship_tag_list = {
					"SawaiBodyguard"
				}
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			target_choise = "TargetSelf",
			targetAniEffect = "",
			arg_list = {
				buff_id = 150593
			}
		}
	}
}
