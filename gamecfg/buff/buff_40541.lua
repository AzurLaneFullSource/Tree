return {
	init_effect = "",
	name = "",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "5点额外氧气",
	stack = 1,
	id = 40541,
	icon = 40540,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach"
			},
			arg_list = {
				attr = "oxyMax",
				number = 5
			}
		}
	}
}
