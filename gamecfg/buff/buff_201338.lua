return {
	time = 0,
	name = "2025医院活动 探索计数 2层效果",
	init_effect = "",
	stack = 1,
	id = 201338,
	picture = "",
	last_effect = "jiejie_dunpai",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 201339,
				target = "TargetAllHarm"
			}
		}
	}
}
