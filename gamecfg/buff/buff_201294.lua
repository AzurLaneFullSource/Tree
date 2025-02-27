return {
	init_effect = "",
	name = "2025拉斐尔活动EX 困难 召唤小怪",
	time = 3,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201294,
	icon = 201294,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201294,
				target = "TargetSelf"
			}
		}
	}
}
