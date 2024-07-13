return {
	init_effect = "",
	name = "2024幼儿园活动 剧情战小斯佩技能",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200964,
	icon = 200964,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				target = "TargetSelf",
				time = 10,
				skill_id = 200964
			}
		}
	}
}
