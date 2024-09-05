return {
	init_effect = "",
	name = "黑长门 樱花结界大 月亏触发",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201058,
	icon = 201058,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 201060,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				buff_id = 201060,
				target = "TargetSelf",
				time = 30
			}
		}
	}
}
