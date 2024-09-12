return {
	init_effect = "",
	name = "2024天城航母活动 苍红之炎",
	time = 3,
	picture = "",
	desc = "",
	stack = 1,
	id = 201097,
	icon = 201097,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onFlagShip"
			},
			arg_list = {
				buff_id = 201098,
				target = "TargetSelf"
			}
		}
	}
}
