return {
	init_effect = "",
	name = "2024瑞凤活动 我方支援弹幕 天晴浪高",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201031,
	icon = 201031,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddAttrRatio",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "attackRating",
				number = 500
			}
		},
		{
			type = "BattleBuffAddAttrRatio",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "dodgeRate",
				number = 500
			}
		}
	}
}
