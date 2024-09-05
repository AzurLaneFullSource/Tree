return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 1,
	id = 1011491,
	picture = "0",
	desc = "蒙布朗：自身和随机一名主力舰队成员炮击、装填属性提高",
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
				"TargetSelf"
			},
			arg_list = {
				buff_id = 1011491
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			targetAniEffect = "",
			target_choise = {
				"TargetAllHelp",
				"TargetPlayerMainFleet",
				"TargetRandom"
			},
			arg_list = {
				buff_id = 1011491,
				exceptCaster = true,
				randomCount = 1
			}
		}
	}
}
