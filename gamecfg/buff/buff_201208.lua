return {
	init_effect = "",
	name = "2024鲁梅活动 A3 召唤小怪",
	time = 1.6,
	picture = "",
	desc = "",
	stack = 1,
	id = 201208,
	icon = 201208,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				time = 0.3,
				target = "TargetSelf",
				skill_id = 201208
			}
		}
	}
}
