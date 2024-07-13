return {
	init_effect = "",
	name = "",
	time = 0.4,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 6,
	id = 150017,
	icon = 150010,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				skill_id = 150110,
				target = "TargetSelf"
			}
		}
	}
}
