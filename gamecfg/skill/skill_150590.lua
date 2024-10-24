return {
	uiEffect = "",
	name = "",
	cd = 0,
	picture = "0",
	id = 150590,
	castCV = "",
	icon = 150590,
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
				"TargetShipTag"
			},
			arg_list = {
				buff_id = 150598,
				ship_tag_list = {
					"SawaiTask"
				}
			}
		}
	}
}
