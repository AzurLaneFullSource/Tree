return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			pop = {},
			trigger = {
				"onStartGame"
			},
			arg_list = {
				skill_id = 801776,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				buff_id = 801771,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				minTargetNumber = 2,
				time = 15,
				skill_id = 801770,
				target = "TargetSelf",
				check_target = {
					"TargetAllHelp",
					"TargetPlayerMainFleet"
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
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 801770,
	icon = 801770,
	last_effect = ""
}
