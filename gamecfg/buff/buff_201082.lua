return {
	init_effect = "",
	name = "2024天城航母活动 SP 九尾妖狐召唤自爆船",
	time = 10,
	picture = "",
	desc = "",
	stack = 1,
	id = 201082,
	icon = 201082,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201082
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				quota = 2,
				time = 3,
				skill_id = 201082
			}
		}
	}
}
