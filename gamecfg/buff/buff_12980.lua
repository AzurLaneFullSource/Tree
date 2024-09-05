return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				quota = 1,
				maxTargetNumber = 0,
				skill_id = 12980,
				target = "TargetSelf",
				check_target = {
					"TargetShipTag"
				},
				ship_tag_list = {
					"Tashkentexclusiveweapon"
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onFoeDying"
			},
			arg_list = {
				quota = 5,
				target = "TargetSelf",
				killer = "self",
				skill_id = 12982
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				minTargetNumber = 1,
				quota = 1,
				skill_id = 1012993,
				target = "TargetSelf",
				check_target = {
					"TargetShipTag"
				},
				ship_tag_list = {
					"Tashkentexclusiveweapon"
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
	id = 12980,
	icon = 12980,
	last_effect = ""
}
