return {
	init_effect = "",
	name = "黑长门 樱花结界 月盈效果",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201056,
	icon = 201056,
	last_effect = "jiejie_dunpai",
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "injureRatio",
				number = -0.25
			}
		}
	}
}
