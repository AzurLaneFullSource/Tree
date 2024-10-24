return {
	uiEffect = "",
	name = "货箱维修",
	cd = 0,
	painting = 0,
	id = 60681,
	picture = "0",
	aniEffect = "",
	desc = "货箱维修",
	effect_list = {
		{
			type = "BattleSkillHeal",
			casterAniEffect = "",
			targetAniEffect = "",
			target_choise = {
				"TargetAllHelp",
				"TargetRandom"
			},
			arg_list = {
				number = 10,
				randomCount = 1
			}
		}
	}
}
