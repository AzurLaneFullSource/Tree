return {
	init_effect = "",
	name = "进水",
	time = 18.1,
	picture = "",
	desc = "U31水雷战列减速",
	stack = 1,
	id = 150208,
	icon = 150200,
	last_effect = "Darkness",
	effect_list = {
		{
			type = "BattleBuffAddAttrRatio",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "velocity",
				number = -2000
			}
		}
	}
}
