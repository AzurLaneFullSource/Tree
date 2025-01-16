return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countTarget = 9,
				countType = 28250,
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
				skill_id = 28251,
				countType = 28250
			}
		}
	},
	{
		desc = "主炮每进行9次攻击，触发特殊弹幕-建武"
	},
	init_effect = "",
	name = "特殊弹幕",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行9次攻击，触发特殊弹幕-建武",
	stack = 1,
	id = 28251,
	icon = 20200,
	last_effect = ""
}
