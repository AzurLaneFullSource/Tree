return {
	time = 0,
	name = "2025愚人节 剧情战",
	init_effect = "",
	stack = 1,
	id = 201355,
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
				maxHPRatio = -0.08
			}
		}
	}
}
