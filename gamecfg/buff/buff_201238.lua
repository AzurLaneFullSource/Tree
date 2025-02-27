return {
	init_effect = "",
	name = "2025拉斐尔活动 战车 过热射击",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201238,
	icon = 201238,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201238,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				buff_id = 201239,
				target = "TargetSelf",
				time = 3
			}
		}
	}
}
