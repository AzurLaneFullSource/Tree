return {
	init_effect = "",
	name = "2025拉斐尔活动 永夜战旗",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201279,
	icon = 201279,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddAttrRatio",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "attackRating",
				number = -300
			}
		},
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "igniteReduce",
				number = 300
			}
		}
	}
}
