return {
	time = 0,
	name = "2025狮UR活动 蔷薇塔 敌方效果",
	init_effect = "",
	stack = 1,
	id = 201411,
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
				attr = "damageRatioBullet",
				number = -0.05
			}
		}
	}
}
