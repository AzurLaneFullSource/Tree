return {
	init_effect = "",
	name = "2024瑞凤活动 朱红秘境",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201023,
	icon = 201023,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddAttrRatio",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "loadSpeed",
				number = 2000
			}
		}
	}
}
