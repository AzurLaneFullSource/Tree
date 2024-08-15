return {
	time = 0,
	name = "",
	init_effect = "jinengchufablue",
	color = "red",
	picture = "",
	desc = "提高航速",
	stack = 1,
	id = 150313,
	icon = 150313,
	last_effect = "",
	blink = {
		0,
		0.7,
		1,
		0.3,
		0.3
	},
	effect_list = {
		{
			type = "BattleBuffFixVelocity",
			trigger = {
				"onAttach"
			},
			arg_list = {
				add = 10,
				mul = 0
			}
		}
	}
}
