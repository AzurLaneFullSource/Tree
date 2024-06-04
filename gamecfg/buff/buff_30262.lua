return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countType = 30260,
				countTarget = 16,
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
				skill_id = 30262,
				countType = 30260
			}
		}
	},
	{
		desc = "主炮每进行16次攻击，触发专属弹幕-莫加多尔II"
	},
	init_effect = "",
	name = "全弹发射",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行16次攻击，触发专属弹幕-莫加多尔II",
	stack = 1,
	id = 30262,
	icon = 30260,
	last_effect = ""
}
