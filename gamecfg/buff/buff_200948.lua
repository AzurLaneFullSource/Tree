return {
	init_effect = "",
	name = "2024阿尔萨斯活动 拟态驱逐BOSS 命中光环",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200948,
	icon = 200948,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAura",
			trigger = {
				"onAttach"
			},
			arg_list = {
				friendly_fire = true,
				buff_id = 200949,
				cld_data = {
					box = {
						range = 50
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
				buff_id = 200950,
				cld_data = {
					box = {
						range = 150
					}
				}
			}
		}
	}
}
