return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countTarget = 16,
				countType = 20130,
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
				skill_id = 20133,
				countType = 20130
			}
		}
	},
	{
		desc = "主炮每进行16次攻击，触发全弹发射-亚特兰大级III"
	},
	init_effect = "",
	name = "全弹发射",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行16次攻击，触发全弹发射-亚特兰大级III",
	stack = 1,
	id = 20133,
	icon = 20100,
	last_effect = ""
}
