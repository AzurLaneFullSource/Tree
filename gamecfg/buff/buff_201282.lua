return {
	init_effect = "",
	name = "2025拉斐尔活动 战车改造域",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201282,
	icon = 201282,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAura",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 201283,
				cld_data = {
					box = {
						range = 300
					}
				}
			}
		},
		{
			type = "BattleBuffAura",
			trigger = {
				"onAttach"
			},
			arg_list = {
				friendly_fire = true,
				buff_id = 201283,
				cld_data = {
					box = {
						range = 300
					}
				}
			}
		}
	}
}
