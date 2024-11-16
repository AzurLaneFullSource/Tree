return {
	init_effect = "",
	name = "2024中飞联动 敌机雷达",
	time = 0,
	color = "blue",
	picture = "",
	desc = "",
	stack = 1,
	id = 8979,
	last_effect = "zhongfei_saomiao",
	effect_list = {
		{
			type = "BattleBuffAura",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 8978,
				cld_data = {
					box = {
						range = 200
					}
				}
			}
		}
	}
}
