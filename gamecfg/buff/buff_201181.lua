return {
	time = 0,
	name = "2024大凤meta 领域效果",
	init_effect = "",
	stack = 1,
	id = 201181,
	picture = "",
	last_effect = "",
	desc = "",
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
