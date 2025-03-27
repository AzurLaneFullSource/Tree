return {
	time = 0,
	name = "2025医院活动 特别问诊",
	init_effect = "",
	stack = 1,
	id = 201324,
	picture = "",
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				time = 3,
				target = "TargetSelf",
				skill_id = 201324
			}
		}
	}
}
