return {
	uiEffect = "",
	name = "机械龙虾维修者",
	cd = 0,
	painting = 1,
	id = 151111,
	picture = "0",
	castCV = "skill",
	desc = "治疗",
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
			target_choise = "TargetAllHelp",
			targetAniEffect = "",
			arg_list = {
				buff_id = 151112,
				delay = 1
			}
		}
	}
}
