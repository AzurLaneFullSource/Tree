return {
	init_effect = "",
	name = "2025拉斐尔活动 新EX模式我方判定更改",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201259,
	icon = 201259,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				tag = "sinkSecond"
			}
		}
	}
}
