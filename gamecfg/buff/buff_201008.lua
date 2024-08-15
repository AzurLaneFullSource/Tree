return {
	init_effect = "",
	name = "2024匹兹堡活动 EX挑战 我方召唤导弹船",
	time = 3,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201008,
	icon = 201008,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 201009,
				target = "TargetPlayerFlagShip"
			}
		}
	}
}
