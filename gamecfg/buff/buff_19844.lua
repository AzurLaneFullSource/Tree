return {
	init_effect = "",
	name = "",
	time = 0.1,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 19844,
	icon = 150172,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCleanse",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				buff_id_list = {
					19843
				}
			}
		}
	}
}
