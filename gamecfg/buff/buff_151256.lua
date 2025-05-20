return {
	color = "yellow",
	name = "",
	time = 3,
	picture = "",
	desc = "",
	stack = 1,
	id = 151256,
	icon = 151250,
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
