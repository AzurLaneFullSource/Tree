return {
	init_effect = "",
	name = "2024风帆二期活动 幻想之力",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201158,
	icon = 201158,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201158,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				time = 15,
				target = "TargetSelf",
				skill_id = 201158
			}
		}
	}
}
