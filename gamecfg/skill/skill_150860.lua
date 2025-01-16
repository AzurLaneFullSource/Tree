return {
	uiEffect = "",
	name = "抚顺技能",
	cd = 0,
	painting = 1,
	id = 150860,
	picture = "0",
	castCV = "skill",
	desc = "抚顺技能",
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
			target_choise = "TargetSelf",
			targetAniEffect = "",
			arg_list = {
				buff_id = 150861
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			target_choise = "TargetSelf",
			targetAniEffect = "",
			arg_list = {
				buff_id = 150862
			}
		}
	}
}
