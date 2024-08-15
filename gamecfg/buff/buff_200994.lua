return {
	init_effect = "",
	name = "2024匹兹堡活动 冻雨打击支援 冻结效果",
	time = 7,
	picture = "",
	desc = "",
	stack = 1,
	id = 200994,
	icon = 200994,
	last_effect = "dh_lengdongfeidan_dongjie",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 200995
			}
		}
	}
}
