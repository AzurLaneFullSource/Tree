return {
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onUpperSubConsort",
				"onLowerSubConsort"
			},
			arg_list = {
				buff_id = 1012403,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onSubmarineRaid"
			},
			arg_list = {
				skill_id = 1012401,
				target = "TargetSelf"
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
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 1012400,
	icon = 12400,
	last_effect = ""
}
