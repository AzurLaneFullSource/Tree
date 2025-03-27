return {
	init_effect = "",
	name = "进水",
	time = 15.1,
	picture = "",
	desc = "进水持续伤害",
	stack = 1,
	id = 151069,
	icon = 151060,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffDOT",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				attr = "airPower",
				number = 20,
				time = 3,
				dotType = 2,
				k = 0.3
			}
		},
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				tag = "flood"
			}
		}
	}
}
