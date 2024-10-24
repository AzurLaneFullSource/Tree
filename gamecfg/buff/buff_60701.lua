return {
	init_effect = "",
	name = "",
	time = 0,
	picture = "",
	desc = "装填、命中降低",
	stack = 1,
	id = 60701,
	icon = 60701,
	last_effect = "Darkness",
	effect_list = {
		{
			type = "BattleBuffAddAttrRatio",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "loadSpeed",
				number = -350
			}
		},
		{
			type = "BattleBuffAddAttrRatio",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "attackRating",
				number = -350
			}
		}
	}
}
