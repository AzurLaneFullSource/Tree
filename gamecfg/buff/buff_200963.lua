return {
	init_effect = "",
	name = "2024幼儿园活动 轻巡石膏喵 召唤雕像4",
	time = 5,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200963,
	icon = 200963,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 200963,
				target = "TargetSelf"
			}
		}
	}
}
