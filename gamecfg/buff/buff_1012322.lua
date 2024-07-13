return {
	init_effect = "",
	name = "",
	time = 5,
	picture = "",
	desc = "",
	stack = 1,
	id = 1012322,
	icon = 12320,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				tag = "eduzhuanwu"
			}
		},
		{
			type = "BattleBuffCleanse",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				buff_id_list = {
					1012321
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				skill_id = 1012321
			}
		}
	}
}
