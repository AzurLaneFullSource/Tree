return {
	init_effect = "",
	name = "2024鲁梅活动 清除杂兵",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201191,
	icon = 201191,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 8831,
				target = "TargetSelf"
			}
		}
	}
}
