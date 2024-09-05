return {
	time = 0,
	name = "",
	init_effect = "",
	stack = 1,
	id = 1011497,
	picture = "",
	last_effect = "",
	desc = "敦刻尔克buff适用者标记",
	effect_list = {
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach"
			},
			arg_list = {
				tag = "dunkeerke_eater"
			}
		}
	}
}
