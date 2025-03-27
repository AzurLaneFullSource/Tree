return {
	time = 0,
	name = "2025医院活动 奇怪响声",
	init_effect = "",
	stack = 1,
	id = 201319,
	picture = "",
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 201320
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				buff_id = 201320,
				time = 15
			}
		}
	}
}
