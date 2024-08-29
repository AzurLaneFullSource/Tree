return {
	init_effect = "",
	name = "2024瑞凤活动 T3 假面赤城召唤物",
	time = 1,
	picture = "",
	desc = "",
	stack = 1,
	id = 201036,
	icon = 201036,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				time = 2,
				target = "TargetSelf",
				skill_id = 201036
			}
		}
	}
}
