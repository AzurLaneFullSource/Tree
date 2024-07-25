return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 1,
	id = 801320,
	picture = "0",
	castCV = "skill",
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
				"TargetShipType"
			},
			arg_list = {
				buff_id = 801321,
				ship_type_list = {
					1,
					20,
					21
				}
			}
		}
	}
}
