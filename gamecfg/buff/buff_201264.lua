return {
	init_effect = "",
	name = "2025拉斐尔活动 战车代行者护盾心态",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201264,
	icon = 201264,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffActionKeyOffset",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				key = "_shield"
			}
		}
	}
}
