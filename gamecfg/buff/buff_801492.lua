return {
	init_effect = "",
	name = "",
	time = 10,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 801492,
	icon = 801490,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffNewWeapon",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				weapon_id = 502
			}
		}
	}
}
