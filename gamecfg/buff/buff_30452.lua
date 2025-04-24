return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countTarget = 8,
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
				skill_id = 30452,
				countType = 30450
			}
		}
	},
	{
		desc = "主炮每进行8次攻击，触发专属弹幕-小安克雷奇II"
	},
	desc_get = "主炮每进行8次攻击，触发专属弹幕-小安克雷奇II",
	name = "专属弹幕-小安克雷奇II",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行8次攻击，触发专属弹幕-小安克雷奇II",
	stack = 1,
	id = 30452,
	icon = 20200,
	last_effect = ""
}
