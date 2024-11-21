return {
	init_effect = "ShellMissBig",
	name = "",
	time = 5,
	color = "red",
	picture = "",
	desc = "提高属性",
	stack = 2,
	id = 111088,
	icon = 111070,
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
				mul = -2500
			}
		}
	}
}
