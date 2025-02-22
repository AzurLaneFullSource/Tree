return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countType = 29110,
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
				skill_id = 29112,
				countType = 29110
			}
		}
	},
	{
		desc = "主炮每进行10次攻击，触发专属弹幕-{namecode:6}II"
	},
	desc_get = "主炮每进行10次攻击，触发专属弹幕-{namecode:6}II",
	name = "专属弹幕-{namecode:6}II",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行10次攻击，触发专属弹幕-{namecode:6}II",
	stack = 1,
	id = 29112,
	icon = 29110,
	last_effect = ""
}
