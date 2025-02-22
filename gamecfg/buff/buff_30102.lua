return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countTarget = 8,
				countType = 30100,
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
				skill_id = 30102,
				countType = 30100
			}
		}
	},
	{
		desc = "主炮每进行8次攻击，触发专属弹幕"
	},
	desc_get = "主炮每进行8次攻击，触发专属弹幕",
	name = "专属弹幕",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行8次攻击，触发专属弹幕",
	stack = 1,
	id = 30102,
	icon = 30100,
	last_effect = ""
}
