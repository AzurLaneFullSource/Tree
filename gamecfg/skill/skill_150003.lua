return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 0,
	id = 150003,
	picture = "0",
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
				"TargetPlayerVanguardFleet",
				"TargetShipTag"
			},
			arg_list = {
				buff_id = 150005,
				ship_tag_list = {
					"BrennusHP"
				}
			}
		}
	}
}
