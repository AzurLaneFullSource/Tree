return {
	init_effect = "",
	name = "2024鲁梅活动 飞剑龙持续时间",
	time = 30,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201196,
	icon = 201196,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onRemove"
			},
			arg_list = {
				skill_id = 17301
			}
		}
	}
}
