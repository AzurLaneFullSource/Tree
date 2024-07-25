return {
	init_effect = "",
	name = "2024斯特拉斯堡活动 我方全体回血",
	time = 3,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200971,
	icon = 200971,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				quota = 1,
				target = "TargetAllHelp",
				time = 0.5,
				skill_id = 8969
			}
		}
	}
}
