return {
	time = 0.5,
	name = "2025狮UR活动 塞壬支援 SP图",
	init_effect = "",
	stack = 1,
	id = 201399,
	picture = "",
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				buff_id = 201400,
				maxTargetNumber = 4,
				nationality = 99,
				check_target = {
					"TargetEntityUnit",
					"TargetNationality"
				}
			}
		}
	}
}
