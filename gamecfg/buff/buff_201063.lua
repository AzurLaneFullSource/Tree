return {
	init_effect = "",
	name = "黑长门 海域状态 月亏触发",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201063,
	icon = 201063,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 201065,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				buff_id = 201065,
				target = "TargetSelf",
				time = 30
			}
		}
	}
}
