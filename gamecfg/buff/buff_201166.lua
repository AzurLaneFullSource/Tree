return {
	time = 0,
	name = "2024tolove联动 EX BOSS随时间流逝受到伤害增加",
	init_effect = "",
	stack = 99,
	id = 201166,
	picture = "",
	last_effect = "",
	desc = "",
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onStack",
				"onRemove"
			},
			arg_list = {
				attr = "injureRatio",
				number = 0.05
			}
		}
	}
}
