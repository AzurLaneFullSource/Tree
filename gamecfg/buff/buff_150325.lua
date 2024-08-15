return {
	init_effect = "",
	name = "减速",
	time = 2,
	picture = "",
	desc = "",
	stack = 1,
	id = 150325,
	icon = 150325,
	last_effect = "Darkness",
	effect_list = {
		{
			type = "BattleBuffFixVelocity",
			trigger = {
				"onAttach",
				"onStack",
				"onRemove"
			},
			arg_list = {
				add = 0,
				mul = -6000
			}
		}
	}
}
