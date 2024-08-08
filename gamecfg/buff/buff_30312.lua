return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countTarget = 8,
				countType = 30311,
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
				skill_id = 30312,
				countType = 30311
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onBattleBuffCount"
			},
			arg_list = {
				target = "TargetSelf",
				skill_id = 30314,
				countType = 19840
			}
		}
	},
	{
		desc = "主炮每进行8次攻击，触发专属弹幕-那不勒斯II"
	},
	desc_get = "主炮每进行8次攻击，触发专属弹幕-那不勒斯II",
	name = "专属弹幕-那不勒斯II",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行8次攻击，触发专属弹幕-那不勒斯II",
	stack = 1,
	id = 30312,
	icon = 30310,
	last_effect = ""
}
