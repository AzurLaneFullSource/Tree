return {
	init_effect = "",
	name = "",
	time = 0,
	picture = "",
	desc = "标记",
	stack = 1,
	id = 18732,
	icon = 18730,
	last_effect = "Darkness",
	effect_list = {
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				tag = "FLDE"
			}
		}
	}
}
