return {
	init_effect = "",
	name = "2024鲁梅活动 永恒之星",
	time = 3,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201197,
	icon = 201197,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onFlagShip"
			},
			arg_list = {
				buff_id = 201198
			}
		}
	}
}
