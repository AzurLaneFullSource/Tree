return {
	time = 0,
	name = "2025医院活动 无限循环回廊",
	init_effect = "",
	stack = 1,
	id = 201333,
	picture = "",
	last_effect = "Health",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				time = 3,
				target = "TargetSelf",
				skill_id = 201331
			}
		}
	}
}
