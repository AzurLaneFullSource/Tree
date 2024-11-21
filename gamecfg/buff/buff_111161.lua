return {
	init_effect = "",
	name = "",
	time = 3,
	picture = "",
	desc = "",
	stack = 1,
	id = 111161,
	icon = 111160,
	last_effect = "Darkness",
	effect_list = {
		{
			type = "BattleBuffFixVelocity",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				add = 0,
				mul = -1500
			}
		}
	}
}
