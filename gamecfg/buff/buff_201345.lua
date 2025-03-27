return {
	time = 3,
	name = "2025医院活动 探索计数 3层效果",
	init_effect = "",
	stack = 1,
	id = 201345,
	picture = "",
	last_effect = "leiji_zi",
	effect_list = {
		{
			type = "BattleBuffHP",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				maxHPRatio = -0.05
			}
		}
	}
}
