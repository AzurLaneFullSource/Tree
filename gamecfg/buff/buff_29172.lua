return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countType = 29170,
				countTarget = 10,
				gunnerBonus = true,
				index = {
					1
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onBattleBuffCount"
			},
			arg_list = {
				maxTargetNumber = 0,
				skill_id = 29172,
				target = "TargetSelf",
				countType = 29170,
				check_target = {
					"TargetSelf",
					"TargetShipTag"
				},
				ship_tag_list = {
					"Z1SP"
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onBattleBuffCount"
			},
			arg_list = {
				minTargetNumber = 1,
				skill_id = 29174,
				target = "TargetSelf",
				countType = 29170,
				check_target = {
					"TargetSelf",
					"TargetShipTag"
				},
				ship_tag_list = {
					"Z1SP"
				}
			}
		}
	},
	{
		desc = "主炮每进行10次攻击，触发专属弹幕-Z1II"
	},
	desc_get = "主炮每进行10次攻击，触发专属弹幕-Z1II",
	name = "专属弹幕-Z1II",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行10次攻击，触发专属弹幕-Z1II",
	stack = 1,
	id = 29172,
	icon = 29170,
	last_effect = ""
}
