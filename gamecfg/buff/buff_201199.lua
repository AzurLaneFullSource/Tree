return {
	init_effect = "",
	name = "2024鲁梅活动 永恒之星",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201199,
	icon = 201199,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 201200
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				buff_id = 201200,
				time = 20
			}
		}
	}
}
