return {
	init_effect = "",
	name = "2025拉斐尔活动 新EX模式我方判定更改",
	time = 1,
	picture = "",
	desc = "",
	stack = 1,
	id = 201262,
	icon = 201262,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCleanse",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id_list = {
					201255
				}
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 201254
			}
		}
	}
}
