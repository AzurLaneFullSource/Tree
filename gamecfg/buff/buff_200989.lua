return {
	init_effect = "",
	name = "2024匹兹堡活动D 冻雨打击支援",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 200989,
	icon = 200989,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 200989,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				time = 25,
				target = "TargetSelf",
				skill_id = 200989
			}
		}
	}
}