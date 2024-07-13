return {
	init_effect = "",
	name = "",
	time = 3,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 17943,
	icon = 17940,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				minTargetNumber = 1,
				quota = 1,
				time = 0.5,
				skill_id = 17941,
				target = "TargetSelf",
				check_target = {
					"TargetAllHarm",
					"TargetShipTag"
				},
				ship_tag_list = {
					"MJDE1AIM"
				}
			}
		}
	}
}
