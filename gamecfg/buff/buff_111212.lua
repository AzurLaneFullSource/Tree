return {
	init_effect = "",
	name = "",
	time = 5,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 111212,
	icon = 111210,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffNewWeapon",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				weapon_id = 500
			}
		}
	}
}
