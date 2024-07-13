return {
	init_effect = "",
	name = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "",
	stack = 10,
	id = 19845,
	icon = 19840,
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
				countType = 19840
			}
		},
		{
			type = "BattleBuffCancelBuff",
			trigger = {
				"onBattleBuffCount"
			},
			arg_list = {
				count = 1,
				countType = 19840
			}
		}
	}
}
