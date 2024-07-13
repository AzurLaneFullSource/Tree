return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countTarget = 15,
				countType = 30300,
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
				skill_id = 30301,
				countType = 30300
			}
		}
	},
	{
		desc = "主炮每进行15次攻击，触发专属弹幕-哈尔福德I"
	},
	desc_get = "主炮每进行15次攻击，触发专属弹幕-哈尔福德I",
	name = "专属弹幕-哈尔福德I",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行15次攻击，触发专属弹幕-哈尔福德I",
	stack = 1,
	id = 30301,
	icon = 30300,
	last_effect = ""
}
