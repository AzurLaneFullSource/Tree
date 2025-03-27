return {
	time = 0,
	name = "2025医院活动 探索计数 2层效果",
	init_effect = "",
	stack = 1,
	id = 201337,
	picture = "",
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach"
			},
			arg_list = {
				tag = "explore-2"
			}
		}
	}
}
