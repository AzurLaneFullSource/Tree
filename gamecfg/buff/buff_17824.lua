return {
	init_effect = "",
	name = "定身",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 17824,
	icon = 17824,
	last_effect = "Darkness",
	effect_list = {
		{
			type = "BattleBuffStun",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onRemove"
			},
			arg_list = {
				buff_id = 17825
			}
		}
	}
}
