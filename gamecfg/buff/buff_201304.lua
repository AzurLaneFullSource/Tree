return {
	time = 0.5,
	name = "2025拉斐尔活动 剧情战触发 无敌护盾且监听到不存在友军时才正式加入战斗",
	init_effect = "",
	stack = 99,
	id = 201304,
	picture = "",
	last_effect = "",
	desc = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				buff_id = 201305,
				maxTargetNumber = 0,
				target = "TargetSelf",
				nationality = 99,
				check_target = {
					"TargetAllHelp",
					"TargetNationality"
				}
			}
		}
	}
}
