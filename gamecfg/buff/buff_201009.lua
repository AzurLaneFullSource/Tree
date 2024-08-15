return {
	init_effect = "",
	name = "2024匹兹堡活动 EX挑战 我方召唤导弹船",
	time = 3,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201009,
	icon = 201009,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201008,
				target = "TargetSelf"
			}
		}
	}
}
