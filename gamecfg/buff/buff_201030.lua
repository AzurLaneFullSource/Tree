return {
	init_effect = "",
	name = "2024瑞凤活动 我方支援弹幕 苍蓝之约",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201030,
	icon = 201030,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201030,
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
				skill_id = 201030
			}
		}
	}
}
