return {
	init_effect = "",
	name = "中飞联动一我方移速",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 8781,
	icon = 8780,
	last_effect = "plane_shadow",
	effect_list = {
		{
			type = "BattleBuffFixVelocity",
			trigger = {
				"onAttach"
			},
			arg_list = {
				add = 10,
				mul = 0
			}
		},
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach"
			},
			arg_list = {
				group = 19000,
				attr = "DMG_TAG_EHC_N_99",
				number = 0.8
			}
		}
	}
}
