return {
	init_effect = "",
	name = "黑长门 海域状态 特效",
	time = 3,
	picture = "",
	desc = "",
	stack = 1,
	id = 201069,
	icon = 201069,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 201070,
				target = "TargetPlayerFlagShip"
			}
		}
	}
}
