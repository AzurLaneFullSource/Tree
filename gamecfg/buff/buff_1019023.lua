return {
	init_effect = "",
	name = "",
	time = 5,
	picture = "",
	desc = "护盾",
	stack = 1,
	id = 1019023,
	icon = 1019020,
	last_effect = "Shield",
	effect_list = {
		{
			type = "BattleBuffShield",
			trigger = {
				"onStack",
				"onTakeDamage"
			},
			arg_list = {
				casterMaxHPRatio = 0.05
			}
		}
	}
}
