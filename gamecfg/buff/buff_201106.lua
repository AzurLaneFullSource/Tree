return {
	init_effect = "",
	name = "2024天城航母活动 EX 困难模式二阶段灵体被动",
	time = 0.1,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201106,
	icon = 201106,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onRemove"
			},
			arg_list = {
				buff_id = 201107,
				exceptCaster = true,
				target = "TargetAllHelp"
			}
		}
	}
}
