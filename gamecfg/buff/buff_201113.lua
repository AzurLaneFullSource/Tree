return {
	init_effect = "",
	name = "2024天城航母活动 EX 结界 判断",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201113,
	icon = 201113,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				tag = "FLAG"
			}
		}
	}
}
