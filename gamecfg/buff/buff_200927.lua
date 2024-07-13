return {
	init_effect = "",
	name = "2024阿尔萨斯活动 亡语回血",
	time = 0.5,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 99,
	id = 200927,
	icon = 200927,
	last_effect = "Health",
	effect_list = {
		{
			type = "BattleBuffHP",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				casterMaxHPRatio = 0.2
			}
		}
	}
}
