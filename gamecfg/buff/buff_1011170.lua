return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				minTargetNumber = 1,
				starget = "TargetSelf",
				skill_id = 1011170,
				target = "TargetSelf",
				check_target = {
					"TargetAllHelp",
					"TargetShipTag"
				},
				ship_tag_list = {
					"Sheffield"
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
	desc_get = "与谢菲尔德同时出击时，炮击、雷击提升",
	name = "牙买加技能",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "与谢菲尔德同时出击时，炮击、雷击提升",
	stack = 1,
	id = 1011170,
	icon = 11170,
	last_effect = ""
}
