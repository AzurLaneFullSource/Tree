return {
	init_effect = "",
	name = "2024鲁梅活动 星空之下 敌方支援弹幕 标记",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201193,
	icon = 201193,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffRegisterWaveFlags",
			trigger = {
				"onAttach"
			},
			arg_list = {
				flags = {
					201193
				}
			}
		}
	}
}
