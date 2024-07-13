return {
	init_effect = "",
	name = "",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "更换舰载机",
	stack = 1,
	id = 60630,
	icon = 60610,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffShiftWeapon",
			trigger = {
				"onAttach"
			},
			arg_list = {
				detach_id = 17472,
				weapon_id = 17492
			}
		}
	}
}
