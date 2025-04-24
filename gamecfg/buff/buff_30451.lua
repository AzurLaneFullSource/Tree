return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countTarget = 12,
				countType = 30450,
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
				skill_id = 30451,
				countType = 30450
			}
		}
	},
	{
		desc = "主炮每进行12次攻击，触发专属弹幕-小安克雷奇I"
	},
	desc_get = "主炮每进行12次攻击，触发专属弹幕-小安克雷奇I",
	name = "专属弹幕-小安克雷奇I",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行12次攻击，触发专属弹幕-小安克雷奇I",
	stack = 1,
	id = 30451,
	icon = 20200,
	last_effect = ""
}
