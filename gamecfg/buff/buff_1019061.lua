return {
	icon = 1019060,
	name = "",
	time = 1.5,
	stack = 1,
	id = 1019060,
	picture = "",
	last_effect = "",
	desc = "闪避",
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				group = 1019060,
				attr = "perfectDodge",
				number = 1
			}
		}
	}
}
