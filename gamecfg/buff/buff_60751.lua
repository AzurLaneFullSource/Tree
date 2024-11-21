return {
	time = 1.5,
	name = "",
	init_effect = "jinengchufablue",
	stack = 1,
	id = 60751,
	picture = "",
	last_effect = "",
	icon = 60751,
	blink = {
		0,
		0.7,
		1,
		0.3,
		0.3
	},
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				group = 60751,
				attr = "perfectDodge",
				number = 1
			}
		},
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				group = 60751,
				attr = "immuneDirectHit",
				number = 1
			}
		}
	}
}
