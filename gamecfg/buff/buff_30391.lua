return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countTarget = 15,
				countType = 30391,
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
				skill_id = 30391,
				countType = 30391
			}
		},
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countType = 30393,
				countTarget = 30,
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
				skill_id = 30393,
				countType = 30393
			}
		}
	},
	{
		desc = "主炮每进行15次攻击，触发专属弹幕-Z47I"
	},
	desc_get = "主炮每进行15次攻击，触发专属弹幕-Z52I",
	name = "专属弹幕-Z52I",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行15次攻击，触发专属弹幕-Z52I",
	stack = 1,
	id = 30391,
	icon = 30390,
	last_effect = ""
}
