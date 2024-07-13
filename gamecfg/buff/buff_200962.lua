return {
	init_effect = "",
	name = "2024幼儿园活动 轻巡石膏喵 召唤雕像3",
	time = 5,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200962,
	icon = 200962,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 200962,
				target = "TargetSelf"
			}
		}
	}
}
