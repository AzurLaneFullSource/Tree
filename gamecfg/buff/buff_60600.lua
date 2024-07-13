return {
	init_effect = "",
	name = "",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 60600,
	icon = 60600,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				minTargetNumber = 1,
				buff_id = 60601,
				target = "TargetSelf",
				nationality = 3,
				check_target = {
					"TargetSelf",
					"TargetPlayerVanguardFleet",
					"TargetNationality"
				}
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				minTargetNumber = 1,
				buff_id = 60602,
				target = "TargetSelf",
				nationality = 3,
				check_target = {
					"TargetSelf",
					"TargetPlayerVanguardFleet",
					"TargetNationality"
				}
			}
		}
	}
}
