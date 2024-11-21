return {
	init_effect = "",
	name = "",
	time = 5,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 111201,
	icon = 111200,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffNewWeapon",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				weapon_id = 498
			}
		}
	}
}
