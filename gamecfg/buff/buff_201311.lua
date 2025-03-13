return {
	time = 0,
	name = "2025信标BOSS 大黄蜂meta 光学迷彩",
	init_effect = "",
	stack = 1,
	id = 201311,
	picture = "",
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffSwitchShader",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				shader = "GRID_TRANSPARENT",
				invisible = 0.1
			}
		}
	}
}
