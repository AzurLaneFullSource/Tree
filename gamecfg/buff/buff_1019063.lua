return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				quota = 4,
				initialCD = true,
				time = 0.5,
				target = "TargetSelf",
				skill_id = 1019061
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				quota = 1,
				target = "TargetSelf",
				time = 2,
				skill_id = 1019062
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
	time = 3,
	color = "blue",
	picture = "",
	desc = "",
	stack = 1,
	id = 1019062,
	icon = 1019062,
	last_effect = ""
}
