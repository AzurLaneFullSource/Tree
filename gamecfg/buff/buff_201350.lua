return {
	time = 0,
	name = "取消敌人移动范围限制",
	init_effect = "",
	stack = 1,
	id = 201350,
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
				group = 1,
				attr = "immuneAreaLimit",
				number = 1
			}
		},
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "immuneMaxAreaLimit",
				number = 1
			}
		}
	}
}
