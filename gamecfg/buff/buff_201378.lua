return {
	init_effect = "",
	name = "2025狮UR活动 辉翼狮支援",
	time = 3,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201378,
	icon = 201378,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onFlagShip"
			},
			arg_list = {
				buff_id = 201379
			}
		}
	}
}
