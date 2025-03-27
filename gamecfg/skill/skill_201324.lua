return {
	uiEffect = "",
	name = "2025医院活动 特别问诊",
	cd = 0,
	painting = 0,
	id = 201324,
	picture = "0",
	aniEffect = "",
	desc = "",
	effect_list = {
		{
			type = "BattleSkillAddBuff",
			target_choise = {
				"TargetAllHelp",
				"TargetHighestHPRatio"
			},
			arg_list = {
				buff_id = 201325
			}
		}
	}
}
