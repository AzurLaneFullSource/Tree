return {
	init_effect = "",
	name = "黑长门 海域状态 特效",
	time = 15,
	picture = "",
	desc = "",
	stack = 1,
	id = 201070,
	icon = 201070,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 201071,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onRemove"
			},
			arg_list = {
				buff_id = 201072,
				target = "TargetSelf"
			}
		}
	}
}
