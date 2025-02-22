return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countTarget = 12,
				countType = 29250,
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
				skill_id = 29251,
				countType = 29250
			}
		}
	},
	{
		desc = "主炮每进行12次攻击，触发专属弹幕-路易九世I"
	},
	desc_get = "主炮每进行12次攻击，触发专属弹幕-路易九世I",
	name = "专属弹幕-路易九世I",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行12次攻击，触发专属弹幕-路易九世I",
	stack = 1,
	id = 29251,
	icon = 29250,
	last_effect = ""
}
