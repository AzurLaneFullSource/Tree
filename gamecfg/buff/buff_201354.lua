return {
	time = 0,
	name = "2025愚人节 剧情战",
	init_effect = "",
	stack = 1,
	id = 201354,
	picture = "",
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				buff_id = 201355,
				time = 1
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
				skill_id = 201354
			}
		}
	}
}
