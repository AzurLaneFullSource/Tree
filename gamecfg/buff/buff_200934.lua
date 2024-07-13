return {
	init_effect = "",
	name = "2024阿尔萨斯活动 直接遥控下潜",
	time = 0.5,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200934,
	icon = 200934,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 200917,
				target = "TargetSelf"
			}
		}
	}
}
