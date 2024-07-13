return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countType = 30280,
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
				target = "TargetSelf",
				skill_id = 30282,
				countType = 30280
			}
		},
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countTarget = 10,
				countType = 30285,
				index = {
					1
				}
			}
		}
	},
	{
		desc = "主炮每进行10次攻击，触发专属弹幕-Z47II"
	},
	desc_get = "主炮每进行10次攻击，触发专属弹幕-Z47II",
	name = "专属弹幕-Z47II",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行10次攻击，触发专属弹幕-Z47II",
	stack = 1,
	id = 30282,
	icon = 30280,
	last_effect = ""
}
