return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 0,
	id = 150941,
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
			target_choise = "TargetFleetIndex",
			targetAniEffect = "",
			arg_list = {
				buff_id = 150942,
				fleetPos = "Leader"
			}
		}
	}
}
