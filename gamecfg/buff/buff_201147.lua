return {
	init_effect = "",
	name = "2024风帆二期活动 寂静涡流 群体增伤减伤光环",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201147,
	icon = 201147,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAura",
			trigger = {
				"onAttach"
			},
			arg_list = {
				friendly_fire = true,
				buff_id = 201148,
				exceptCaster = true,
				cld_data = {
					box = {
						range = 50
					}
				}
			}
		}
	}
}
