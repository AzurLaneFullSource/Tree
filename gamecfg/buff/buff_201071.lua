return {
	init_effect = "",
	name = "黑长门 海域状态 特效",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201071,
	icon = 201071,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 201073,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				buff_id = 201073,
				target = "TargetSelf",
				time = 30
			}
		}
	}
}
