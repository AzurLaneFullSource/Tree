return {
	time = 27,
	name = "2025医院活动 访客限制令",
	init_effect = "",
	stack = 1,
	id = 201322,
	picture = "",
	last_effect = "2234_biaoji",
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "damageRatioBullet",
				number = -0.1
			}
		}
	}
}
