return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countType = 30320,
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
				skill_id = 30322,
				countType = 30320
			}
		}
	},
	{
		desc = "主炮每进行10次攻击，触发专属弹幕-果敢II"
	},
	desc_get = "主炮每进行10次攻击，触发专属弹幕-果敢II",
	name = "专属弹幕-果敢II",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行10次攻击，触发专属弹幕-果敢II",
	stack = 1,
	id = 30322,
	icon = 30320,
	last_effect = ""
}
