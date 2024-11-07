return {
	uiEffect = "",
	name = "雷击指挥·先锋",
	cd = 0,
	painting = 1,
	id = 1090331,
	picture = "0",
	castCV = "skill",
	desc = "提高舰队中所有驱逐舰的雷击属性",
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
				"TargetPlayerVanguardFleet"
			},
			arg_list = {
				buff_id = 1010
			}
		}
	}
}
