return {
	time = 50,
	name = "",
	init_effect = "jinengchufared",
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 60741,
	icon = 60740,
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
				"onRemove"
			},
			arg_list = {
				attr = "attackRating",
				number = 350
			}
		}
	}
}
