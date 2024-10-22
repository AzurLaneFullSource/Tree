return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countType = 29210,
				countTarget = 10,
				gunnerBonus = true,
				index = {
					1
				}
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onBattleBuffCount"
			},
			arg_list = {
				buff_id = 29214,
				target = "TargetSelf",
				countType = 29210
			}
		}
	},
	{
		desc = "主炮每进行10次攻击，触发专属弹幕-Z46II"
	},
	desc_get = "主炮每进行10次攻击，触发专属弹幕-Z46II",
	name = "专属弹幕-Z46II",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行10次攻击，触发专属弹幕-Z46II",
	stack = 1,
	id = 29212,
	icon = 29210,
	last_effect = ""
}
