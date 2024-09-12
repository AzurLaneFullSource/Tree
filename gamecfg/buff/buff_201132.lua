return {
	init_effect = "",
	name = "2024天城航母活动 剧情战 比叡meta弹幕",
	time = 3,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201132,
	icon = 201132,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201132,
				target = "TargetSelf"
			}
		}
	}
}
