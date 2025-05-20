return {
	init_effect = "",
	name = "2025狮UR活动 EX 普通 狮子召唤物",
	time = 3,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 201371,
	icon = 201371,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201371,
				target = "TargetSelf"
			}
		}
	}
}
