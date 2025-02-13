return {
	uiEffect = "",
	name = "防空模式·哥伦比亚",
	cd = 0,
	painting = 1,
	id = 1090390,
	picture = "0",
	castCV = "skill",
	desc = "防空模式·哥伦比亚",
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
				buff_id = 1090391
			}
		}
	}
}
