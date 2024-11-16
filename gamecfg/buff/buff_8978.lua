return {
	init_effect = "",
	name = "2024中飞联动 敌机雷达",
	time = 0,
	color = "blue",
	picture = "",
	desc = "",
	stack = 1,
	id = 8978,
	last_effect = "zhongfei_miaozhun",
	effect_list = {
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				tag = "Lock"
			}
		}
	}
}
