return {
	init_effect = "",
	name = "2024 匹兹堡活动EX 开场检测",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201011,
	icon = 201011,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffRegisterWaveFlags",
			trigger = {
				"onAttach"
			},
			arg_list = {
				flags = {
					1
				}
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
				time = 0.1,
				skill_id = 201011
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
				time = 1,
				skill_id = 200975
			}
		}
	}
}
