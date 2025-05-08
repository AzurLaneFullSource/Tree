return {
	init_effect = "",
	name = "穿甲对重甲破甲",
	time = 8,
	picture = "",
	desc = "",
	stack = 1,
	id = 1012489,
	icon = 1012480,
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
