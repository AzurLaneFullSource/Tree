return {
	init_effect = "",
	name = "2024天城航母活动 苍红之炎 支援弹幕 灼烧效果",
	time = 1,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 99,
	id = 201102,
	icon = 201102,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffHP",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				maxHPRatio = -0.02
			}
		}
	}
}
