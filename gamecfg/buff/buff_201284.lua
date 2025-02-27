return {
	init_effect = "",
	name = "2025拉斐尔活动 战车改造域",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201284,
	icon = 201284,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "injureRatio",
				number = 0.03
			}
		}
	}
}
