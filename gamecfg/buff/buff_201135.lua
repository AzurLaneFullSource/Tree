return {
	init_effect = "",
	name = "2024天城航母活动 剧情战 长门meta弹幕",
	time = 3,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201135,
	icon = 201135,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201135,
				target = "TargetSelf"
			}
		}
	}
}
