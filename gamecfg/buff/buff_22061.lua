return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countTarget = 24,
				countType = 22060,
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
				skill_id = 22061,
				countType = 22060
			}
		}
	},
	{
		desc = "主炮每进行24次攻击，触发全弹发射-{namecode:26}级I"
	},
	init_effect = "",
	name = "全弹发射",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行24次攻击，触发全弹发射-{namecode:26}级I",
	stack = 1,
	id = 22061,
	icon = 20000,
	last_effect = ""
}
