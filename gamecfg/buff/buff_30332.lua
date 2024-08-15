return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countTarget = 10,
				countType = 30330,
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
				skill_id = 30332,
				countType = 30330
			}
		}
	},
	{
		desc = "主炮每进行10次攻击，触发专属弹幕-法戈II"
	},
	init_effect = "",
	name = "专属弹幕-法戈II",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行10次攻击，触发专属弹幕-法戈II",
	stack = 1,
	id = 30332,
	icon = 30330,
	last_effect = ""
}
