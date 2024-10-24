return {
	init_effect = "",
	name = "旗舰受到伤害降低，依据指挥属性",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "该入口提供战外挂载到战内",
	stack = 1,
	id = 40411,
	icon = 40410,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddAttrCommander",
			trigger = {
				"onAttach"
			},
			arg_list = {
				ability = "command",
				convertRate = -0.0002,
				convertAttr = "injureRatio"
			}
		}
	}
}
