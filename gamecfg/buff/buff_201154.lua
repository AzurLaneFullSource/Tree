return {
	init_effect = "",
	name = "2024风帆二期活动 寂静之海",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201154,
	icon = 201154,
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
				number = -0.1
			}
		}
	}
}
