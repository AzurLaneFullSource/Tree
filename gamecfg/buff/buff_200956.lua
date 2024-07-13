return {
	init_effect = "",
	name = "2024威奇塔meta 狂战士之血",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 200956,
	icon = 200956,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onHPRatioUpdate"
			},
			arg_list = {
				maxHPRatio = 0.05,
				keep = true,
				countTarget = 1,
				countType = 200956
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onBattleBuffCount"
			},
			arg_list = {
				buff_id = 200957,
				target = "TargetSelf",
				countType = 200956
			}
		}
	}
}
