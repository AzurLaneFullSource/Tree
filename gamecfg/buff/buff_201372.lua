return {
	init_effect = "",
	name = "2025狮UR活动 EX 困难 狮子召唤物",
	time = 3,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 201372,
	icon = 201372,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201372,
				target = "TargetSelf"
			}
		}
	}
}
