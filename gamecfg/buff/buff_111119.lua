return {
	init_effect = "",
	name = "小暗弹幕破甲",
	time = 6,
	picture = "",
	desc = "",
	stack = 1,
	id = 111119,
	icon = 111100,
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
				number = 0.05
			}
		}
	}
}
