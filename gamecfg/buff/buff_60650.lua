return {
	init_effect = "",
	name = "联合演习纪念币",
	time = 0,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 60650,
	icon = 60650,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach"
			},
			arg_list = {
				group = 60650,
				attr = "DMG_FROM_TAG_1_N_6",
				number = -0.03
			}
		},
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach"
			},
			arg_list = {
				group = 60650,
				attr = "DMG_FROM_TAG_1_N_8",
				number = -0.03
			}
		},
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach"
			},
			arg_list = {
				group = 60650,
				attr = "DMG_FROM_TAG_1_N_9",
				number = -0.03
			}
		}
	}
}
