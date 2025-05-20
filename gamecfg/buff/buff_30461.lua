return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countTarget = 15,
				countType = 30460,
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
				skill_id = 30461,
				countType = 30460
			}
		}
	},
	{},
	init_effect = "",
	name = "专属弹幕",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮每进行15次攻击，触发专属弹幕-克利奥佩特拉I",
	stack = 1,
	id = 30461,
	icon = 30460,
	last_effect = ""
}
