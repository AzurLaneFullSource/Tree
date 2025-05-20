return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 0,
	id = 801775,
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
				"TargetPlayerMainFleet",
				"TargetRandom"
			},
			arg_list = {
				buff_id = 801775,
				exceptCaster = true,
				randomCount = 1
			}
		}
	}
}
