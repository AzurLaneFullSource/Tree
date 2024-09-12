return {
	init_effect = "",
	name = "2024天城航母活动 EX 困难模式二阶段灵体被动",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201105,
	icon = 201105,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach"
			},
			arg_list = {
				group = 201105,
				attr = "damageReduceFromAmmoType_2",
				number = 0.5
			}
		},
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach"
			},
			arg_list = {
				group = 201105,
				attr = "damageReduceFromAmmoType_4",
				number = 0.5
			}
		},
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach"
			},
			arg_list = {
				group = 201105,
				attr = "damageReduceFromAmmoType_7",
				number = 0.5
			}
		},
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach"
			},
			arg_list = {
				attr = "igniteReduce",
				number = -90000
			}
		}
	}
}
