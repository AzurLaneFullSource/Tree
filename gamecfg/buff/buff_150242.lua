return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onHPRatioUpdate"
			},
			arg_list = {
				minTargetNumber = 1,
				quota = 1,
				target = "TargetSelf",
				hpUpperBound = 0.6,
				skill_id = 150242,
				check_target = {
					"TargetPlayerVanguardFleet",
					"TargetShipTag"
				},
				ship_tag_list = {
					"guogan60"
				}
			}
		}
	},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	desc_get = "",
	name = "",
	init_effect = "",
	time = 0,
	color = "blue",
	picture = "",
	desc = "",
	stack = 1,
	id = 150242,
	icon = 150240,
	last_effect = ""
}
