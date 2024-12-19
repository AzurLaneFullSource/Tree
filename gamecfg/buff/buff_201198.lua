return {
	init_effect = "",
	name = "2024鲁梅活动 永恒之星",
	time = 7,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201198,
	icon = 201198,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onRemove"
			},
			arg_list = {
				buff_id = 201199
			}
		}
	}
}
