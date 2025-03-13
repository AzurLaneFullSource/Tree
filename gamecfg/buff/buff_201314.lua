return {
	time = 1,
	name = "2025信标BOSS 大黄蜂meta 电磁脉冲",
	init_effect = "",
	stack = 1,
	id = 201314,
	picture = "",
	last_effect = "qiershazhi_chongjibo",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onRemove"
			},
			arg_list = {
				buff_id = 8965,
				target = "TargetHarmNearest"
			}
		}
	}
}
