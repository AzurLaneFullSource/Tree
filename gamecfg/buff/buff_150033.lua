return {
	init_effect = "",
	name = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 150033,
	icon = 150030,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onBulletCollide"
			},
			arg_list = {
				rant = 10000,
				skill_id = 150034,
				index = {
					1
				}
			}
		}
	}
}
