return {
	init_effect = "",
	name = "黑长门 樱花结界 月亏效果",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201055,
	icon = 201055,
	last_effect = "zihuozhuoshao",
	effect_list = {
		{
			type = "BattleBuffDOT",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				attr = "cannonPower",
				number = 6,
				time = 3,
				dotType = 10,
				k = 0.5
			}
		}
	}
}
