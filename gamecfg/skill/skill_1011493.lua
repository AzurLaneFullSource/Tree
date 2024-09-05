return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 1,
	id = 1011493,
	picture = "0",
	desc = "马卡龙：自身和随机一名水面舰队成员炮击、命中属性提高",
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
				buff_id = 1011493
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			targetAniEffect = "",
			target_choise = {
				"TargetAllHelp",
				"TargetShipTag",
				"TargetRandom"
			},
			arg_list = {
				buff_id = 1011493,
				randomCount = 1,
				ship_tag_list = {
					"dunkeerke_eater"
				}
			}
		}
	}
}
