return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 1,
	id = 150671,
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
				"TargetAllHelp",
				"TargetFleetIndex"
			},
			arg_list = {
				buff_id = 150671,
				fleetPos = "UpperConsort"
			}
		}
	}
}
