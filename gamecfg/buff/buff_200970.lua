return {
	init_effect = "",
	name = "2024斯特拉斯堡活动 我方全体回血",
	time = 3,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200970,
	icon = 200970,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 200971,
				target = "TargetPlayerFlagShip"
			}
		}
	}
}
