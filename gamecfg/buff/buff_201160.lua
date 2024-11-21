return {
	init_effect = "",
	name = "2024tolove联动 EX 随机组合",
	time = 7,
	picture = "",
	desc = "",
	stack = 1,
	id = 201160,
	icon = 201160,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 201164,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				buff_id = 201161,
				target = "TargetSelf",
				time = 2
			}
		}
	}
}
