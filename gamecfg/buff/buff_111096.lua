return {
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 111097,
				minTargetNumber = 1,
				target = "TargetSelf",
				check_target = {
					"TargetSelf",
					"TargetPlayerVanguardFleet"
				}
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 111098,
				minTargetNumber = 1,
				target = "TargetSelf",
				check_target = {
					"TargetSelf",
					"TargetPlayerMainFleet"
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				quota = 1,
				target = "TargetSelf",
				skill_id = 111093
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
	time = 1,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 111096,
	icon = 111090,
	last_effect = ""
}
