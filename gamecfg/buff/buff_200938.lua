return {
	init_effect = "",
	name = "2024阿尔萨斯活动SP 连续召唤浮游炮发射激光 随机落点",
	time = 3,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200938,
	icon = 200938,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 200749,
				target = "TargetSelf"
			}
		}
	}
}
