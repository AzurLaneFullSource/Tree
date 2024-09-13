return {
	init_effect = "",
	name = "2024天城航母活动 EX 我方触发支援大招 真伤",
	time = 1,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 99,
	id = 201119,
	icon = 201119,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffHP",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				maxHPRatio = -0.07
			}
		}
	}
}
