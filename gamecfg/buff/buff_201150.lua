return {
	init_effect = "",
	name = "2024风帆二期活动 海上风暴",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201150,
	icon = 201150,
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
