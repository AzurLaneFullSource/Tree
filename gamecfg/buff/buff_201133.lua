return {
	init_effect = "",
	name = "2024天城航母活动 剧情战 赤城特殊弹幕",
	time = 10,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201133,
	icon = 201133,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				quota = 1,
				target = "TargetSelf",
				time = 4,
				skill_id = 201133
			}
		}
	}
}
