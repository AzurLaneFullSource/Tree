return {
	init_effect = "",
	name = "",
	time = 40,
	color = "red",
	picture = "",
	desc = "受到伤害降低",
	stack = 1,
	id = 60841,
	icon = 60840,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "injureRatio",
				number = -0.05
			}
		}
	}
}
