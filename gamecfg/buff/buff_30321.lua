return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countTarget = 15,
				countType = 30320,
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
				skill_id = 30321,
				countType = 30320
			}
		}
	},
	{
		desc = "主炮每进行15次攻击，触发专属弹幕-果敢I"
	},
	desc_get = "主炮每进行15次攻击，触发专属弹幕-果敢I",
	name = "专属弹幕-果敢I",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行15次攻击，触发专属弹幕-果敢I",
	stack = 1,
	id = 30321,
	icon = 30320,
	last_effect = ""
}
