return {
	time = 0,
	name = "2025医院活动 探索计数 3层效果",
	init_effect = "",
	stack = 1,
	id = 201343,
	picture = "",
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach"
			},
			arg_list = {
				tag = "explore-3"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 201344,
				target = "TargetAllHelp"
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				time = 5,
				target = "TargetSelf",
				skill_id = 201343
			}
		}
	}
}
