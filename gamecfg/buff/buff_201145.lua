return {
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				buff_id = 201146,
				maxTargetNumber = 0,
				nationality = 96,
				check_target = {
					"TargetAllHelp",
					"TargetNationality"
				}
			}
		}
	},
	{},
	{},
	init_effect = "",
	name = "2024风帆二期活动 T2怪群",
	time = 0.1,
	picture = "",
	desc = "",
	stack = 1,
	id = 201145,
	icon = 201145,
	last_effect = ""
}
