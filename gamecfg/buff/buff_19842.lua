return {
	init_effect = "",
	name = "",
	time = 0,
	picture = "",
	desc = "近距离敌人标签",
	stack = 1,
	id = 19842,
	icon = 19840,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				tag = "Napoli-40E"
			}
		}
	}
}
