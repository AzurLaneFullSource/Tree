return {
	init_effect = "",
	name = "2024鲁梅活动 剧情战 玩家即死处理",
	time = 5,
	picture = "",
	desc = "",
	stack = 1,
	id = 201217,
	icon = 201217,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 200195,
				target = "TargetHarmFarthest"
			}
		}
	}
}
