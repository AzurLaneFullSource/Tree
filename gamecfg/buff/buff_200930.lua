return {
	init_effect = "",
	name = "2024阿尔萨斯活动 辉光之城-绽放",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200930,
	icon = 200930,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onFoeDying"
			},
			arg_list = {
				buff_id = 200931,
				target = "TargetSelf",
				killer = "self"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onFoeDying"
			},
			arg_list = {
				buff_id = 200932,
				target = "TargetPlayerFlagShip",
				killer = "self"
			}
		}
	}
}
