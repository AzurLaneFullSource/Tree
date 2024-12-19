return {
	init_effect = "",
	name = "2024鲁梅活动 敌人免疫点燃",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201192,
	icon = 201192,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "igniteReduce",
				number = 10000
			}
		}
	}
}
