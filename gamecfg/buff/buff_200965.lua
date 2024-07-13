return {
	init_effect = "",
	name = "2024幼儿园活动 剧情战召唤潜艇",
	time = 5,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200965,
	icon = 200965,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				quota = 1,
				target = "TargetSelf",
				time = 0.5,
				skill_id = 200965
			}
		}
	}
}
