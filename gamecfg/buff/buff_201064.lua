return {
	init_effect = "",
	name = "黑长门 海域状态 月盈触发",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201064,
	icon = 201064,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 201066,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				buff_id = 201066,
				target = "TargetSelf",
				time = 30
			}
		}
	}
}
