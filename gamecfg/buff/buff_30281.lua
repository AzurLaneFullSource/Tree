return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countTarget = 15,
				countType = 30280,
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
				skill_id = 30281,
				countType = 30280
			}
		},
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countTarget = 30,
				countType = 30285,
				index = {
					1
				}
			}
		}
	},
	{
		desc = "主炮每进行15次攻击，触发专属弹幕-Z47I"
	},
	desc_get = "主炮每进行15次攻击，触发专属弹幕-Z47I",
	name = "专属弹幕-Z47I",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行15次攻击，触发专属弹幕-Z47I",
	stack = 1,
	id = 30281,
	icon = 30280,
	last_effect = ""
}
