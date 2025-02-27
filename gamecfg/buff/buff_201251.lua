return {
	init_effect = "",
	name = "2025拉斐尔活动 新EX模式我方判定更改",
	time = 1.1,
	picture = "",
	desc = "",
	stack = 1,
	id = 201251,
	icon = 201251,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onRemove"
			},
			arg_list = {
				buff_id = 201252,
				minTargetNumber = 3,
				target = "TargetSelf",
				check_target = {
					"TargetPlayerVanguardFleet"
				}
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onRemove"
			},
			arg_list = {
				buff_id = 201253,
				maxTargetNumber = 2,
				target = "TargetSelf",
				check_target = {
					"TargetPlayerVanguardFleet"
				}
			}
		}
	}
}
