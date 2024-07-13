return {
	init_effect = "",
	name = "2024威奇塔meta 狂战士之血",
	time = 0,
	picture = "",
	desc = "",
	stack = 99,
	id = 200957,
	icon = 200957,
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
				attr = "damageRatioBullet",
				number = 0.05
			}
		}
	}
}
