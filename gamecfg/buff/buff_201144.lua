return {
	effect_list = {},
	{
		effect_list = {
			{
				type = "BattleBuffAddBuff",
				trigger = {
					"onAttach",
					"onStack"
				},
				arg_list = {
					buff_id = 201146,
					maxTargetNumber = 6,
					nationality = 96,
					check_target = {
						"TargetAllHelp",
						"TargetNationality"
					}
				}
			}
		}
	},
	{
		effect_list = {
			{
				type = "BattleBuffAddBuff",
				trigger = {
					"onAttach",
					"onStack"
				},
				arg_list = {
					buff_id = 201146,
					maxTargetNumber = 4,
					nationality = 96,
					check_target = {
						"TargetAllHelp",
						"TargetNationality"
					}
				}
			}
		}
	},
	init_effect = "",
	name = "2024风帆二期活动 T2怪群",
	time = 1,
	picture = "",
	desc = "",
	stack = 1,
	id = 201144,
	icon = 201144,
	last_effect = ""
}
