return {
	time = 3,
	name = "2025医院活动 特别问诊",
	init_effect = "",
	stack = 1,
	id = 201323,
	picture = "",
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onFlagShip"
			},
			arg_list = {
				buff_id = 201324
			}
		}
	}
}
