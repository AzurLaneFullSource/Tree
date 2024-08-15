return {
	init_effect = "",
	name = "2024匹兹堡活动 X半影 次数盾 打破增加本体易伤",
	time = 0,
	picture = "",
	desc = "",
	stack = 10,
	id = 200999,
	icon = 200999,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				attr = "injureRatio",
				number = 0.1
			}
		}
	}
}
