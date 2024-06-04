return {
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 200923,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				buff_id = 200923,
				target = "TargetSelf",
				time = 25
			}
		}
	},
	{},
	{},
	{},
	{},
	{},
	init_effect = "",
	name = "2024阿尔萨斯活动 死神之桥 隐身",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200922,
	icon = 200922,
	last_effect = ""
}
