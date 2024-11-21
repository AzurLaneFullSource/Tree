return {
	uiEffect = "",
	name = "",
	cd = 0,
	castCV = "",
	id = 111083,
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
				"TargetAllHarm",
				"TargetRandom"
			},
			arg_list = {
				buff_id = 111087,
				randomCount = 1
			}
		}
	}
}
