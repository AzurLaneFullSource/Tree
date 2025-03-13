return {
	time = 0,
	name = "",
	init_effect = "jinengchufared",
	picture = "",
	desc = "",
	stack = 5,
	id = 801651,
	icon = 801650,
	last_effect = "",
	blink = {
		1,
		0,
		0,
		0.3,
		0.3
	},
	effect_list = {
		{
			type = "BattleBuffAddAttrRatio",
			trigger = {
				"onAttach",
				"onStack",
				"onRemove"
			},
			arg_list = {
				attr = "airPower",
				number = 200
			}
		},
		{
			type = "BattleBuffAddAttrRatio",
			trigger = {
				"onAttach",
				"onStack",
				"onRemove"
			},
			arg_list = {
				attr = "attackRating",
				number = 200
			}
		}
	}
}
