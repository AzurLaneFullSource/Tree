return {
	init_effect = "",
	name = "2024匹兹堡活动 大风暴",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 200981,
	icon = 200981,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAura",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 200982,
				cld_data = {
					box = {
						range = 200
					}
				}
			}
		}
	}
}
