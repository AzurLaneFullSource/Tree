return {
	time = 0,
	name = "",
	init_effect = "jinengchufared",
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 19782,
	icon = 19780,
	last_effect = "",
	blink = {
		1,
		0,
		0,
		0.3,
		0.3
	},
	effect_list = {
		{
			type = "BattleBuffAddAttrBloodrage",
			trigger = {
				"onAttach",
				"onHPRatioUpdate"
			},
			arg_list = {
				threshold = 1,
				value = 6,
				attrBound = 0.15,
				attr = "damageRatioBullet"
			}
		}
	}
}
