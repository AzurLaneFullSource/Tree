return {
	init_effect = "",
	name = "",
	time = 8.1,
	color = "blue",
	picture = "",
	desc = "",
	stack = 1,
	id = 18761,
	icon = 19760,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				minTargetNumber = 1,
				target = "TargetSelf",
				skill_id = 18763,
				time = 2
			}
		}
	}
}
