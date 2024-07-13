return {
	init_effect = "",
	name = "",
	time = 4,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 150203,
	icon = 150200,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffNewAI",
			trigger = {
				"onAttach"
			},
			arg_list = {
				ai_onAttach = 15016
			}
		}
	}
}
