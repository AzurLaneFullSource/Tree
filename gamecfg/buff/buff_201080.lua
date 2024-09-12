return {
	init_effect = "",
	name = "2024天城航母活动 灵狐入场动作",
	time = 3,
	picture = "",
	desc = "",
	stack = 1,
	id = 201080,
	icon = 201080,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201080
			}
		},
		{
			type = "BattleBuffCease",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {}
		}
	}
}
