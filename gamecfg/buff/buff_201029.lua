return {
	init_effect = "",
	name = "2024瑞凤活动 我方支援弹幕 苍蓝之约",
	time = 7,
	picture = "",
	desc = "",
	stack = 1,
	id = 201029,
	icon = 201029,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onRemove"
			},
			arg_list = {
				buff_id = 201030,
				target = "TargetPlayerFlagShip"
			}
		}
	}
}