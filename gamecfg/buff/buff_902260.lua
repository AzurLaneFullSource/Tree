return {
	init_effect = "",
	name = "",
	time = 0,
	color = "blue",
	picture = "",
	desc = "",
	stack = 1,
	id = 902260,
	icon = 902260,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBulletAttr",
			trigger = {
				"onBulletCreate"
			},
			arg_list = {
				attr = "cri",
				number = 0.2,
				index = {
					1
				}
			}
		},
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach"
			},
			arg_list = {
				attr = "chargeBulletAccuracy",
				number = 4
			}
		}
	}
}
