return {
	time = 2,
	name = "2025荷兰活动 扬起郁金之旗",
	init_effect = "",
	stack = 1,
	id = 201361,
	picture = "",
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onRemove"
			},
			arg_list = {
				buff_id = 201362
			}
		}
	}
}
