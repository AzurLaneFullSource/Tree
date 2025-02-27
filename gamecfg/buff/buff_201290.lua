return {
	init_effect = "",
	name = "2025拉斐尔活动 战车改造域 避免对BOSS生效",
	time = 3,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201290,
	icon = 201290,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 201285,
				maxTargetNumber = 0,
				target = "TargetSelf",
				check_target = {
					"TargetSelf",
					"TargetShipTag"
				},
				ship_tag_list = {
					"BOSS"
				}
			}
		}
	}
}
