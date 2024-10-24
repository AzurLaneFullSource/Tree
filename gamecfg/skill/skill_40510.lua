return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 1,
	id = 40510,
	picture = "0",
	aniEffect = "",
	desc = "",
	effect_list = {
		{
			type = "BattleSkillEditTag",
			casterAniEffect = "",
			target_choise = "TargetSelf",
			targetAniEffect = "",
			arg_list = {
				tag = "FancyNyaSkill",
				operation = 1
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			targetAniEffect = "",
			target_choise = {
				"TargetAllHelp"
			},
			arg_list = {
				buff_id = 40511
			}
		}
	}
}
