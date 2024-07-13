return {
	init_effect = "",
	name = "2024阿尔萨斯活动 死神之桥 触发",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200925,
	icon = 200925,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffRegisterWaveFlags",
			trigger = {
				"onAttach"
			},
			arg_list = {
				flags = {
					200925
				}
			}
		}
	}
}
