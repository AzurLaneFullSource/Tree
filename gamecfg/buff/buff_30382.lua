return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countTarget = 30,
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
				skill_id = 30382,
				countType = 30380
			}
		}
	},
	{
		desc = "主炮每进行10次攻击，触发专属弹幕-朴茨茅斯冒险号II"
	},
	desc_get = "主炮每进行30次攻击，触发专属弹幕-朴茨茅斯冒险号II",
	name = "专属弹幕-朴茨茅斯冒险号II",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行30次攻击，触发专属弹幕-朴茨茅斯冒险号II",
	stack = 1,
	id = 30382,
	icon = 30380,
	last_effect = ""
}
