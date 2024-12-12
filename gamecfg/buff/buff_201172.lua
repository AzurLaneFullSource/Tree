return {
	time = 1,
	name = "2024大凤meta 召唤物",
	init_effect = "",
	stack = 1,
	id = 201172,
	picture = "",
	last_effect = "",
	desc = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 201173,
				exceptCaster = true,
				target = "TargetAllHelp"
			}
		}
	}
}
