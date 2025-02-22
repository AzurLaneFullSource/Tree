return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countTarget = 8,
				countType = 29930,
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
				skill_id = 29932,
				countType = 29930
			}
		}
	},
	{
		desc = "主炮每进行8次攻击，触发专属弹幕-酒匂II"
	},
	desc_get = "主炮每进行8次攻击，触发专属弹幕-酒匂II",
	name = "专属弹幕-酒匂II",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行8次攻击，触发专属弹幕-酒匂II",
	stack = 1,
	id = 29932,
	icon = 29930,
	last_effect = ""
}
