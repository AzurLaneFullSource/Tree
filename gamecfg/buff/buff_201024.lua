return {
	init_effect = "",
	name = "2024瑞凤活动 我方支援弹幕 静海惊雷",
	time = 7,
	picture = "",
	desc = "",
	stack = 1,
	id = 201024,
	icon = 201024,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onRemove"
			},
			arg_list = {
				buff_id = 201025,
				target = "TargetPlayerFlagShip"
			}
		}
	}
}