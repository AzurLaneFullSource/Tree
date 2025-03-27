return {
	time = 0,
	name = "2025医院活动 定期巡查",
	init_effect = "",
	stack = 1,
	id = 201315,
	picture = "",
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffRegisterWaveFlags",
			trigger = {
				"onAttach"
			},
			arg_list = {
				flags = {
					201315
				}
			}
		}
	}
}
