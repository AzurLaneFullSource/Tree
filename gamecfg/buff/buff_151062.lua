return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				maxTargetNumber = 0,
				skill_id = 151061,
				target = "TargetSelf",
				check_target = {
					"TargetAllFoe",
					"TargetShipTag"
				},
				ship_tag_list = {
					"FranklinSP"
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				minTargetNumber = 1,
				skill_id = 151062,
				target = "TargetSelf",
				check_target = {
					"TargetAllFoe",
					"TargetShipTag"
				},
				ship_tag_list = {
					"FranklinSP"
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
	time = 1,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 151062,
	icon = 151060,
	last_effect = ""
}
