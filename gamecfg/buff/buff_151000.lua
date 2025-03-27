return {
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				isBuffStackByCheckTarget = true,
				minTargetNumber = 1,
				buff_id = 151001,
				exceptCaster = true,
				check_target = {
					"TargetAllHelp",
					"TargetPlayerVanguardFleet"
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				minTargetNumber = 2,
				skill_id = 151001,
				target = "TargetSelf",
				check_target = {
					"TargetPlayerVanguardFleet"
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onLeader"
			},
			arg_list = {
				skill_id = 151002,
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
	time = 0.5,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 151000,
	icon = 151000,
	last_effect = ""
}
