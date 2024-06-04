return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countTarget = 24,
				countType = 30260,
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
				skill_id = 30261,
				countType = 30260
			}
		}
	},
	{
		desc = "主炮每进行24次攻击，触发专属弹幕-莫加多尔I"
	},
	init_effect = "",
	name = "全弹发射",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行24次攻击，触发专属弹幕-莫加多尔I",
	stack = 1,
	id = 30261,
	icon = 30260,
	last_effect = ""
}
