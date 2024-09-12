return {
	init_effect = "",
	name = "2024天城航母活动 EX 结界 监听",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201114,
	icon = 201114,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				buff_id = 201115,
				target = "TargetSelf",
				time = 0.1
			}
		}
	}
}
