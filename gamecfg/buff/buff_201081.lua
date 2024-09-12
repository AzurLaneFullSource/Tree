return {
	init_effect = "",
	name = "2024天城航母活动 灵狐第一波闪烁",
	time = 15,
	picture = "",
	desc = "",
	stack = 1,
	id = 201081,
	icon = 201081,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				quota = 1,
				time = 1.6,
				skill_id = 201081
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				quota = 1,
				time = 5.1,
				skill_id = 201081
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				quota = 1,
				time = 6.1,
				skill_id = 201081
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				quota = 1,
				time = 7.1,
				skill_id = 201081
			}
		}
	}
}
