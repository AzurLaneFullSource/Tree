return {
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "damageRatioBullet",
				number = -0.1,
				index = {
					1
				}
			}
		},
		{
			type = "BattleBuffAddReloadRequirement",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				type = 23,
				number = -0.2
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
	time = 0,
	name = "春菜加射速和减伤害",
	init_effect = "",
	stack = 1,
	id = 111155,
	picture = "",
	last_effect = "",
	desc = "加射速和减伤害"
}
