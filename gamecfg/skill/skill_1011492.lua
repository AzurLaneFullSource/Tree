return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 1,
	id = 1011492,
	picture = "0",
	desc = "甜甜圈：自身和随机一名先锋舰队成员炮击属性提高、暴击率、暴击伤害提高",
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
				buff_id = 1011492
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			targetAniEffect = "",
			target_choise = {
				"TargetAllHelp",
				"TargetPlayerVanguardFleet",
				"TargetRandom"
			},
			arg_list = {
				buff_id = 1011492,
				randomCount = 1
			}
		}
	}
}