return {
	init_effect = "",
	name = "2024瑞凤活动 我方支援弹幕 静海惊雷",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201025,
	icon = 201025,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201025,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				target = "TargetSelf",
				time = 20,
				skill_id = 201025
			}
		}
	}
}
