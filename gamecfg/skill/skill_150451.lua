return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 0,
	id = 150451,
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
				"TargetShipType"
			},
			arg_list = {
				buff_id = 150452,
				ship_type_list = {
					4,
					5
				}
			}
		}
	}
}
