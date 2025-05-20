return {
	init_effect = "",
	name = "2025狮UR活动 SP 召唤物死亡强化本体",
	time = 0,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 201374,
	icon = 201374,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffHP",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				maxHPRatio = 0.1
			}
		},
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				attr = "damageRatioBullet",
				number = 0.15
			}
		}
	}
}
