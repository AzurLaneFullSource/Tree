return {
	init_effect = "",
	name = "2024鲁梅活动 BOSS入场无敌",
	time = 5,
	picture = "",
	desc = "",
	stack = 1,
	id = 201210,
	icon = 201210,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201215
			}
		}
	}
}
