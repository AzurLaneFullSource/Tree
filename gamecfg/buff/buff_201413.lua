return {
	time = 0,
	name = "2025狮UR活动 剧情战触发 召唤塞壬单位",
	init_effect = "",
	stack = 1,
	id = 201413,
	picture = "",
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201368,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAllInStrike"
			},
			arg_list = {
				skill_id = 201408,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				buff_id = 201414,
				target = "TargetSelf",
				time = 1
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				buff_id = 201416,
				target = "TargetSelf",
				time = 2
			}
		}
	}
}
