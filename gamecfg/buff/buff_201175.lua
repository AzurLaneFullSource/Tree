return {
	time = 0,
	name = "2024大凤meta 领域监听",
	init_effect = "",
	stack = 99,
	id = 201175,
	picture = "",
	last_effect = "",
	desc = "",
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onHPRatioUpdate"
			},
			arg_list = {
				maxHPRatio = 0.5,
				countTarget = 1,
				countType = 201175
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onBattleBuffCount"
			},
			arg_list = {
				buff_id = 201176,
				target = "TargetSelf",
				countType = 201175
			}
		}
	}
}
