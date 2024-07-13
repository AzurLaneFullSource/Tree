return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countType = 30302,
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
				skill_id = 30302,
				countType = 30302
			}
		}
	},
	{
		desc = "主炮每进行10次攻击，触发全弹发射-哈尔福德II"
	},
	init_effect = "",
	name = "全弹发射",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行10次攻击，触发全弹发射-哈尔福德II",
	stack = 1,
	id = 30302,
	icon = 30300,
	last_effect = ""
}
