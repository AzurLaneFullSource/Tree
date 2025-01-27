return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countType = 26030,
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
				skill_id = 26032,
				countType = 26030
			}
		}
	},
	{
		desc = "主炮每进行10次攻击，触发全弹发射-愤怒级II"
	},
	init_effect = "",
	name = "全弹发射",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行10次攻击，触发全弹发射-愤怒级II",
	stack = 1,
	id = 26032,
	icon = 20100,
	last_effect = ""
}
