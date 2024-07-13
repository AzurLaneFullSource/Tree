return {
	init_effect = "",
	name = "",
	time = 6,
	picture = "",
	desc = "",
	stack = 1,
	id = 19797,
	icon = 19790,
	last_effect = "Pojia01",
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "injureRatioByCannon",
				number = 0.08
			}
		}
	}
}
