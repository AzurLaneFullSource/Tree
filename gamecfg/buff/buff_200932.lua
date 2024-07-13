return {
	init_effect = "",
	name = "2024阿尔萨斯活动 辉光之城-绽放 触发弹幕",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 99,
	id = 200932,
	icon = 200932,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				countTarget = 10,
				countType = 200932
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onBattleBuffCount"
			},
			arg_list = {
				buff_id = 200933,
				target = "TargetSelf",
				countType = 200932
			}
		}
	}
}
