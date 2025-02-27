return {
	init_effect = "",
	name = "2025拉斐尔活动 神光之网",
	time = 3,
	picture = "",
	desc = "",
	stack = 1,
	id = 201275,
	icon = 201275,
	last_effect = "Health",
	effect_list = {
		{
			type = "BattleBuffHP",
			trigger = {
				"onAttach"
			},
			arg_list = {
				maxHPRatio = 0.03
			}
		}
	}
}
