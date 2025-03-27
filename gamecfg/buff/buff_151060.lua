return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				minTargetNumber = 2,
				quota = 1,
				skill_id = 151060,
				check_target = {
					"TargetPlayerMainFleet",
					"TargetNationality"
				},
				nationality = {
					1
				}
			}
		},
		{
			type = "BattleBuffField",
			trigger = {},
			arg_list = {
				buff_id = 151068,
				target = {
					"TargetAllFoe"
				}
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAllInStrikeSteady"
			},
			arg_list = {
				buff_id = 151062,
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
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 151060,
	icon = 151060,
	last_effect = ""
}
