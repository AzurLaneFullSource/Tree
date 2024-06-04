return {
	uiEffect = "",
	name = "2024阿尔萨斯活动 亡语回血",
	cd = 0,
	painting = 0,
	id = 200933,
	picture = "0",
	aniEffect = "",
	desc = "",
	effect_list = {
		{
			type = "BattleSkillAddBuff",
			target_choise = {
				"TargetAllHelp",
				"TargetHelpLeastHPRatio"
			},
			arg_list = {
				buff_id = 200927,
				exceptCaster = true
			}
		}
	}
}
