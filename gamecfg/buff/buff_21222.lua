return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countTarget = 6,
				countType = 21220,
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
				skill_id = 21222,
				countType = 21220
			}
		}
	},
	{
		desc = "主炮每进行6次攻击，触发全弹发射-肯特级II"
	},
	init_effect = "",
	name = "全弹发射",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行6次攻击，触发全弹发射-肯特级II",
	stack = 1,
	id = 21222,
	icon = 20200,
	last_effect = ""
}
