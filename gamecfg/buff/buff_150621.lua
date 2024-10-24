return {
	desc_get = "",
	name = "",
	init_effect = "",
	time = 5,
	color = "blue",
	picture = "",
	desc = "",
	stack = 1,
	id = 150621,
	icon = 150620,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onRemove"
			},
			arg_list = {
				skill_id = 150621
			}
		}
	}
}
