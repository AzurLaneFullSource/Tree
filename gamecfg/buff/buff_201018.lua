return {
	init_effect = "",
	name = "2024匹兹堡活动 剧情战 我方导弹船",
	time = 3,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201018,
	icon = 201018,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201018,
				target = "TargetSelf"
			}
		}
	}
}
