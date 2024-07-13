return {
	time = 8,
	name = "",
	init_effect = "jinengchufablue",
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 19833,
	icon = 19830,
	last_effect = "",
	blink = {
		0,
		0.7,
		1,
		0.3,
		0.3
	},
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "igniteReduce",
				number = 10000
			}
		}
	}
}
