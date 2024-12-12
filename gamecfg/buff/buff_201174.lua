return {
	time = 1,
	name = "2024大凤meta 主动清除场上召唤物",
	init_effect = "",
	stack = 1,
	id = 201174,
	picture = "",
	last_effect = "",
	desc = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onRemove"
			},
			arg_list = {
				buff_id = 200440,
				exceptCaster = true,
				target = "TargetAllHelp"
			}
		}
	}
}
