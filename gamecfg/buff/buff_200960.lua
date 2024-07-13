return {
	init_effect = "",
	name = "2024幼儿园活动 轻巡石膏喵 召唤雕像1",
	time = 5,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200960,
	icon = 200960,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 200960,
				target = "TargetSelf"
			}
		}
	}
}
