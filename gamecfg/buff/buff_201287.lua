return {
	init_effect = "",
	name = "2025拉斐尔活动 飞空战舰支援",
	time = 3,
	picture = "",
	desc = "",
	stack = 1,
	id = 201287,
	icon = 201287,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onFlagShip"
			},
			arg_list = {
				buff_id = 201288
			}
		}
	}
}
