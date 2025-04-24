return {
	time = 3,
	name = "2025荷兰活动 扬起郁金之旗",
	init_effect = "",
	stack = 1,
	id = 201364,
	picture = "",
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffHP",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				maxHPRatio = 0.02
			}
		}
	}
}
