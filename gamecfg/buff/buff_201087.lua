return {
	time = 0.1,
	name = "2024天城航母活动 B3 赤城meta 监听召唤物存活情况",
	init_effect = "",
	stack = 99,
	id = 201087,
	picture = "",
	last_effect = "",
	desc = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				buff_id = 201088,
				maxTargetNumber = 0,
				target = "TargetSelf",
				nationality = 3,
				check_target = {
					"TargetAllHelp",
					"TargetNationality"
				}
			}
		}
	}
}
