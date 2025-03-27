return {
	time = 6,
	name = "2025医院活动 奇怪响声",
	init_effect = "",
	stack = 1,
	id = 201321,
	picture = "",
	last_effect = "xuanyun",
	effect_list = {
		{
			type = "BattleBuffFixVelocity",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				add = -6,
				mul = 0
			}
		},
		{
			type = "BattleBuffAddAttrRatio",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "attackRating",
				number = -1000
			}
		}
	}
}
