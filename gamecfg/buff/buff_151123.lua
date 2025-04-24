return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				minTargetNumber = 1,
				quota = 1,
				time = 5,
				target = "TargetSelf",
				hpUpperBound = 0.9,
				skill_id = 151121,
				check_target = {
					"TargetAllHelp"
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				minTargetNumber = 1,
				quota = 1,
				time = 5,
				target = "TargetSelf",
				hpUpperBound = 0.8,
				skill_id = 151121,
				check_target = {
					"TargetAllHelp"
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				minTargetNumber = 1,
				quota = 1,
				time = 5,
				target = "TargetSelf",
				hpUpperBound = 0.7,
				skill_id = 151121,
				check_target = {
					"TargetAllHelp"
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
	init_effect = "",
	name = "",
	time = 6,
	color = "blue",
	picture = "",
	desc = "",
	stack = 1,
	id = 151123,
	icon = 151120,
	last_effect = ""
}
