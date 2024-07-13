return {
	init_effect = "",
	name = "2024阿尔萨斯活动 拟态物初始向前移动",
	time = 0.5,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200946,
	icon = 200946,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffNewAI",
			trigger = {
				"onAttach"
			},
			arg_list = {
				ai_onAttach = 20005
			}
		}
	}
}
