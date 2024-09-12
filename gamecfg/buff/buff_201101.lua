return {
	init_effect = "",
	name = "2024天城航母活动 苍红之炎 支援弹幕 灼烧效果",
	time = 8.5,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201101,
	icon = 201101,
	last_effect = "cangyanzhuoshao",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201102,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				time = 2,
				target = "TargetSelf",
				skill_id = 201102
			}
		}
	}
}
