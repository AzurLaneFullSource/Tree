return {
	init_effect = "",
	name = "2025拉斐尔活动 战车 适应性装甲",
	time = 0,
	picture = "",
	desc = "",
	stack = 10,
	id = 201247,
	icon = 201247,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onStack",
				"onRemove"
			},
			arg_list = {
				attr = "injureRatioByBulletTorpedo",
				number = -0.03
			}
		}
	}
}
