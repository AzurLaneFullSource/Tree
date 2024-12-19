return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countType = 30392,
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
				skill_id = 30392,
				countType = 30392
			}
		},
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countType = 30393,
				countTarget = 20,
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
		desc = "主炮每进行10次攻击，触发专属弹幕-Z47II"
	},
	desc_get = "主炮每进行10次攻击，触发专属弹幕-Z52II",
	name = "专属弹幕-Z52II",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行10次攻击，触发专属弹幕-Z52II",
	stack = 1,
	id = 30392,
	icon = 30390,
	last_effect = ""
}
