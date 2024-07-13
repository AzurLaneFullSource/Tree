return {
	init_effect = "",
	name = "2024阿尔萨斯活动 直接遥控上浮",
	time = 0.5,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200935,
	icon = 200935,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 200918,
				target = "TargetSelf"
			}
		}
	}
}
