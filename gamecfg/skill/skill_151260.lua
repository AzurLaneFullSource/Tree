return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 1,
	id = 151260,
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
				buff_id = 151262,
				fleetPos = "FlagShip"
			}
		}
	}
}
