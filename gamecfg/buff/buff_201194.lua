return {
	init_effect = "",
	name = "2024鲁梅活动 飞剑龙支援",
	time = 3,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201194,
	icon = 201194,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onFlagShip"
			},
			arg_list = {
				buff_id = 201195
			}
		}
	}
}
