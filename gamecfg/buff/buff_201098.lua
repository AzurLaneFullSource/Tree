return {
	init_effect = "",
	name = "2024天城航母活动 苍红之炎",
	time = 7,
	picture = "",
	desc = "",
	stack = 1,
	id = 201098,
	icon = 201098,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onRemove"
			},
			arg_list = {
				buff_id = 201099,
				target = "TargetSelf"
			}
		}
	}
}
