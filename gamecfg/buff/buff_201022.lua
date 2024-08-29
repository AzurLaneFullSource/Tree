return {
	init_effect = "",
	name = "2024瑞凤活动 朱红秘境",
	time = 13,
	picture = "",
	desc = "",
	stack = 1,
	id = 201022,
	icon = 201022,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAura",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 201023,
				cld_data = {
					box = {
						range = 300
					}
				}
			}
		}
	}
}
