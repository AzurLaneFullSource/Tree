return {
	init_effect = "",
	name = "",
	time = 20,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 60801,
	icon = 60800,
	last_effect = "Shield_1",
	effect_list = {
		{
			type = "BattleBuffShield",
			trigger = {
				"onStack",
				"onTakeDamage"
			},
			arg_list = {
				maxHPRatio = 0.02
			}
		}
	}
}
