return {
	init_effect = "",
	name = "",
	time = 5,
	picture = "",
	desc = "果敢加血tag",
	stack = 1,
	id = 150245,
	icon = 150240,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach"
			},
			arg_list = {
				tag = "guoganHP"
			}
		}
	}
}
