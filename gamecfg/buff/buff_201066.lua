return {
	init_effect = "",
	name = "黑长门 海域状态 月盈效果",
	time = 15,
	picture = "",
	desc = "",
	stack = 1,
	id = 201066,
	icon = 201066,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAura",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 201068,
				cld_data = {
					box = {
						range = 200
					}
				}
			}
		}
	}
}
