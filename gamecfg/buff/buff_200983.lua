return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				target = "TargetSelf",
				skill_id = 200983
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				time = 20,
				skill_id = 200983,
				target = "TargetSelf"
			}
		}
	},
	{},
	{},
	{},
	init_effect = "",
	name = "2024匹兹堡活动 苍红之息",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 200983,
	icon = 200983,
	last_effect = ""
}
