return {
	init_effect = "",
	name = "2024天城航母活动 EX 三阶段狂暴",
	time = 3,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201109,
	icon = 201109,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201109,
				target = "TargetSelf"
			}
		}
	}
}
