return {
	init_effect = "",
	name = "碧海亲和M",
	time = 0,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 45047,
	icon = 45040,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onStack",
				"onRemove"
			},
			arg_list = {
				attr = "cannonPower",
				number = 10
			}
		},
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onStack",
				"onRemove"
			},
			arg_list = {
				attr = "airPower",
				number = 10
			}
		}
	}
}
