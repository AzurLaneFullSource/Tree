return {
	init_effect = "",
	name = "空白BUFF",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 200454,
	icon = 200454,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				tag = "xiyinxiaoguo"
			}
		}
	}
}
