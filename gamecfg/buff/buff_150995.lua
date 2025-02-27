return {
	init_effect = "",
	name = "",
	time = 2.1,
	picture = "",
	desc = "扣血",
	stack = 1,
	id = 150995,
	icon = 150990,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffHP",
			trigger = {
				"onAttach"
			},
			arg_list = {
				maxHPRatio = -0.03
			}
		}
	}
}
