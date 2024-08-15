return {
	init_effect = "",
	name = "2024匹兹堡活动 大风暴",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 200982,
	icon = 200982,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffFixVelocity",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				add = -3,
				mul = 0
			}
		},
		{
			type = "BattleBuffAddAttrRatio",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "attackRating",
				number = -500
			}
		}
	}
}
