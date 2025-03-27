return {
	time = 0,
	name = "2025医院活动 探索计数 1层效果",
	init_effect = "",
	stack = 1,
	id = 201336,
	picture = "",
	last_effect = "nuofukedanchuan_buff_01",
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "damageRatioBullet",
				number = 0.2
			}
		}
	}
}
