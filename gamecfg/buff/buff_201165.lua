return {
	time = 0,
	name = "2024tolove联动 EX BOSS随时间流逝受到伤害增加",
	init_effect = "",
	stack = 1,
	id = 201165,
	picture = "",
	last_effect = "",
	desc = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach",
				"onUpdate"
			},
			arg_list = {
				buff_id = 201166,
				target = "TargetSelf",
				time = 5
			}
		}
	}
}
