return {
	init_effect = "",
	name = "2024瑞凤活动 我方支援弹幕 静海惊雷",
	time = 1,
	picture = "",
	desc = "",
	stack = 1,
	id = 201026,
	icon = 201026,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffHP",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				casterMaxHPRatio = -0.05
			}
		}
	}
}