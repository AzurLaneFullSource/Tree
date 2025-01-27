return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countTarget = 12,
				countType = 23130,
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
				skill_id = 23131,
				countType = 23130
			}
		}
	},
	{
		desc = "主炮每进行12次攻击，触发全弹发射-皮劳I"
	},
	init_effect = "",
	name = "全弹发射",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行12次攻击，触发全弹发射-皮劳I",
	stack = 1,
	id = 23131,
	icon = 20100,
	last_effect = ""
}
