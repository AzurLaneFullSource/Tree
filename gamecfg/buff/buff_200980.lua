return {
	init_effect = "",
	name = "2024匹兹堡活动 大风暴",
	time = 3,
	picture = "",
	desc = "",
	stack = 1,
	id = 200980,
	icon = 200980,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onFlagShip"
			},
			arg_list = {
				target = "TargetSelf",
				buff_id = 200981
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				target = "TargetSelf",
				buff_id = 200982
			}
		}
	}
}
