return {
	init_effect = "",
	name = "2024天城航母活动 苍红之炎",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201099,
	icon = 201099,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 201100,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				buff_id = 201100,
				target = "TargetSelf",
				time = 20
			}
		}
	}
}
