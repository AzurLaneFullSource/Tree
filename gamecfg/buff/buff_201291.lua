return {
	init_effect = "",
	name = "2025拉斐尔活动B2 代行者VII「Pulverization」 召唤小怪",
	time = 3,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201291,
	icon = 201291,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201291,
				target = "TargetSelf"
			}
		}
	}
}
