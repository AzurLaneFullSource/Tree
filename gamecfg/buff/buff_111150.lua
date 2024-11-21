return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				skill_id = 111150
			}
		},
		{
			type = "BattleBuffAura",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				friendly_fire = false,
				buff_id = 111158,
				cld_data = {
					box = {
						range = 160
					}
				}
			}
		}
	},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	desc_get = "",
	name = "",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 111150,
	icon = 111150,
	last_effect = ""
}
