return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countType = 29020,
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
				skill_id = 29023,
				countType = 29020
			}
		}
	},
	{
		desc = "主炮每进行10次攻击，触发专属弹幕-埃尔德里奇II"
	},
	desc_get = "主炮每进行10次攻击，触发专属弹幕-埃尔德里奇III",
	name = "专属弹幕-埃尔德里奇III",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行10次攻击，触发专属弹幕-埃尔德里奇III",
	stack = 1,
	id = 29023,
	icon = 29020,
	last_effect = ""
}
