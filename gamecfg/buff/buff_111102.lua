return {
	init_effect = "",
	name = "护甲判别",
	time = 5,
	picture = "",
	desc = "",
	stack = 1,
	id = 111102,
	icon = 111100,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				tag = "xiaoan"
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 111102,
				quota = 1
			}
		}
	}
}
