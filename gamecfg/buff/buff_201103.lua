return {
	init_effect = "",
	name = "2024天城航母活动 EX 一阶段转场",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201103,
	icon = 201103,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onHPRatioUpdate"
			},
			arg_list = {
				buff_id = 201104,
				hpUpperBound = 0.5,
				target = "TargetSelf",
				quota = 1
			}
		},
		{
			type = "BattleBuffLockHealth",
			trigger = {
				"onAttach"
			},
			arg_list = {
				target = "TargetSelf",
				value = 0.5
			}
		}
	}
}
