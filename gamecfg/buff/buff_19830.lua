return {
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onStartGame"
			},
			pop = {},
			arg_list = {
				buff_id = 19831
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				time = 25,
				target = "TargetSelf",
				skill_id = 19831
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onHPRatioUpdate"
			},
			arg_list = {
				hpUpperBound = 0.4,
				target = "TargetSelf",
				skill_id = 19830,
				quota = 1
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
	id = 19830,
	icon = 19830,
	last_effect = ""
}
