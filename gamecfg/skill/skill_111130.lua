return {
	uiEffect = "",
	name = "春菜开局buff",
	cd = 0,
	painting = 1,
	id = 111130,
	picture = "0",
	castCV = "skill",
	desc = "选择耐久最低",
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
			target_choise = {
				"TargetAllHelp",
				"TargetHelpLeastHPRatio"
			},
			arg_list = {
				buff_id = 111131
			}
		}
	}
}
