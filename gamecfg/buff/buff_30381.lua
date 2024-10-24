return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countTarget = 22,
				countType = 30380,
				index = {
					1,
					2
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
				skill_id = 30381,
				countType = 30380
			}
		}
	},
	{
		desc = "主炮每进行30次攻击，触发专属弹幕-朴茨茅斯冒险号I"
	},
	desc_get = "主炮每进行22次攻击，触发专属弹幕-朴茨茅斯冒险号I",
	name = "专属弹幕-朴茨茅斯冒险号I",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行22次攻击，触发专属弹幕-朴茨茅斯冒险号I",
	stack = 1,
	id = 30381,
	icon = 30380,
	last_effect = ""
}
