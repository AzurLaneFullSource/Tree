return {
	time = 0,
	name = "",
	init_effect = "",
	stack = 1,
	id = 111158,
	picture = "",
	last_effect = "",
	desc = "近距离敌人标签",
	effect_list = {
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				tag = "chuncai_haipa"
			}
		}
	}
}
