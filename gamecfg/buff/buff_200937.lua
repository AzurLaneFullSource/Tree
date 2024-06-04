return {
	init_effect = "",
	name = "2024阿尔萨斯活动SP 连续召唤浮游炮发射激光",
	time = 8,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200937,
	icon = 200937,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach",
				"onUpdate"
			},
			arg_list = {
				time = 0.8,
				target = "TargetSelf",
				skill_id = 200937
			}
		}
	}
}
