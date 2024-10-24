return {
	init_effect = "",
	name = "碧海亲和V",
	time = 0,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 45046,
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
				attr = "torpedoPower",
				number = 10
			}
		}
	}
}
