return {
	init_effect = "",
	name = "2024阿尔萨斯活动SP 死神之影召唤浮游炮1",
	time = 5,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200936,
	icon = 200936,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 200936,
				target = "TargetSelf"
			}
		}
	}
}
