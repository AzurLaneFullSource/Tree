return {
	init_effect = "",
	name = "2024天城航母活动 EX 我方触发支援大招",
	time = 10,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201120,
	icon = 201120,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffNewWeapon",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				weapon_id = 3205127
			}
		}
	}
}
