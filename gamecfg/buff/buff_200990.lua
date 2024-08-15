return {
	init_effect = "",
	name = "2024匹兹堡活动SP 冻雨打击支援",
	time = 3,
	picture = "",
	desc = "",
	stack = 1,
	id = 200990,
	icon = 200990,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onFlagShip"
			},
			arg_list = {
				buff_id = 200991
			}
		}
	}
}
