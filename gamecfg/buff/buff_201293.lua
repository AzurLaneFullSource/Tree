return {
	init_effect = "",
	name = "2025拉斐尔活动EX 普通 召唤小怪",
	time = 3,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201293,
	icon = 201293,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201293,
				target = "TargetSelf"
			}
		}
	}
}
