return {
	time = 0,
	name = "2025狮UR活动 蔷薇塔 我方效果",
	init_effect = "",
	stack = 1,
	id = 201410,
	picture = "",
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
				number = -0.05
			}
		}
	}
}
