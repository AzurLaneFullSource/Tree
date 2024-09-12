return {
	init_effect = "",
	name = "2024天城航母活动 EX 结界",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201112,
	icon = 201112,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAura",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 201113,
				cld_data = {
					box = {
						range = 12
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
				buff_id = 201113,
				cld_data = {
					box = {
						range = 200
					}
				}
			}
		}
	}
}
