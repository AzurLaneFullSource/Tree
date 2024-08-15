return {
	init_effect = "",
	name = "2024匹兹堡活动EX 无人机装备添加判断用TAG",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201017,
	icon = 201017,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				tag = "Fargo's-Drone"
			}
		}
	}
}
