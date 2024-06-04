return {
	init_effect = "",
	name = "",
	time = 0,
	picture = "",
	desc = "标记",
	stack = 1,
	id = 150023,
	icon = 150020,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				tag = "Judgement_ava"
			}
		}
	}
}
