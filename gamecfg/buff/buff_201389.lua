return {
	time = 0,
	name = "2025狮UR活动 塞壬支援 B图",
	init_effect = "",
	stack = 1,
	id = 201389,
	picture = "",
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				buff_id = 201390,
				target = "TargetSelf",
				time = 1
			}
		}
	}
}
