return {
	time = 0,
	name = "2024大凤meta 领域期间我方损失单位会令BOSS进一步增强",
	init_effect = "",
	stack = 99,
	id = 201178,
	picture = "",
	last_effect = "",
	desc = "",
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onStack",
				"onRemove"
			},
			arg_list = {
				attr = "damageRatioBullet",
				number = 0.1
			}
		}
	}
}
