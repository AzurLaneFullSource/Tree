return {
	uiEffect = "",
	name = "雷达支援",
	cd = 0,
	painting = 0,
	id = 17851,
	picture = "0",
	castCV = "",
	desc = "雷达支援",
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
			target_choise = "TargetAllHarm",
			targetAniEffect = "",
			arg_list = {
				buff_id = 17859
			}
		}
	}
}
