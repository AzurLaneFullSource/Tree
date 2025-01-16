return {
	init_effect = "",
	name = "减速",
	time = 10,
	picture = "",
	desc = "10s减速",
	stack = 1,
	id = 150859,
	icon = 150850,
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
				mul = -2000
			}
		}
	}
}
