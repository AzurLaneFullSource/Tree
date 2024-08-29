return {
	init_effect = "",
	name = "2024瑞凤活动 我方支援弹幕 静海惊雷",
	time = 1,
	picture = "",
	desc = "",
	stack = 1,
	id = 201020,
	icon = 201020,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				skill_id = 201020,
				target = "TargetSelf"
			}
		}
	}
}
