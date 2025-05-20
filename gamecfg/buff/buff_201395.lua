return {
	time = 0,
	name = "2025狮UR活动 塞壬支援 D图",
	init_effect = "",
	stack = 1,
	id = 201395,
	picture = "",
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				buff_id = 201396,
				target = "TargetSelf",
				time = 1
			}
		}
	}
}
