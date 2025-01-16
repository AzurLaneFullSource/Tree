return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countTarget = 18,
				countType = 28240,
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
				skill_id = 28241,
				countType = 28240
			}
		}
	},
	{
		desc = "主炮每进行18次攻击，触发全弹发射-海容级I"
	},
	init_effect = "",
	name = "全弹发射",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行18次攻击，触发全弹发射-海容级I",
	stack = 1,
	id = 28241,
	icon = 20100,
	last_effect = ""
}
