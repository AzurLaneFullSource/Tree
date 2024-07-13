return {
	init_effect = "",
	name = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "防空炮开火监听",
	stack = 1,
	id = 60602,
	icon = 60600,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAntiAirWeaponFireNear"
			},
			arg_list = {
				buff_id = 60603
			}
		}
	}
}
