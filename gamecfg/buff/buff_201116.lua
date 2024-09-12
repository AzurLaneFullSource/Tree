return {
	init_effect = "",
	name = "2024天城航母活动 EX 我方触发支援大招",
	time = 1,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201116,
	icon = 201116,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onRemove"
			},
			arg_list = {
				buff_id = 201117,
				target = "TargetPlayerFlagShip"
			}
		}
	}
}
