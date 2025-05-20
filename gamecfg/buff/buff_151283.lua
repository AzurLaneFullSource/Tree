return {
	init_effect = "",
	name = "",
	time = 10,
	picture = "",
	desc = "命中降低",
	stack = 1,
	id = 151283,
	icon = 151280,
	last_effect = "Darkness",
	effect_list = {
		{
			type = "BattleBuffAddAttrRatio",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "attackRating",
				number = -1500
			}
		}
	}
}
