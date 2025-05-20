return {
	effect_list = {},
	{
		effect_list = {
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onUpdate"
				},
				arg_list = {
					quota = 1,
					target = "TargetSelf",
					time = 0.5,
					skill_id = 201412
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onUpdate"
				},
				arg_list = {
					quota = 1,
					target = "TargetSelf",
					time = 3,
					skill_id = 201419
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onUpdate"
				},
				arg_list = {
					quota = 1,
					target = "TargetSelf",
					time = 20,
					skill_id = 201419
				}
			}
		}
	},
	{
		effect_list = {
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onUpdate"
				},
				arg_list = {
					quota = 1,
					target = "TargetSelf",
					time = 0.5,
					skill_id = 201412
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onUpdate"
				},
				arg_list = {
					quota = 1,
					target = "TargetSelf",
					time = 28,
					skill_id = 201381
				}
			}
		}
	},
	time = 0,
	name = "2025狮UR活动 剧情战触发",
	init_effect = "",
	stack = 1,
	id = 201412,
	picture = "",
	last_effect = "",
	desc = ""
}
