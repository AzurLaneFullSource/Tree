return {
	time = 3.1,
	name = "2025医院活动 特别问诊",
	init_effect = "",
	stack = 1,
	id = 201325,
	picture = "",
	last_effect = "zihuozhuoshao",
	effect_list = {
		{
			type = "BattleBuffHP",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				maxHPRatio = -0.02
			}
		}
	}
}
