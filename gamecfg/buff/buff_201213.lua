return {
	init_effect = "",
	name = "2024鲁梅活动 潜艇小怪上浮时减伤",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201213,
	icon = 201213,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "injureRatio",
				number = -0.8
			}
		}
	}
}
