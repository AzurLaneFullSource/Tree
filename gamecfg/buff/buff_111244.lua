return {
	time = 0,
	name = "",
	init_effect = "",
	stack = 1,
	id = 111244,
	picture = "",
	last_effect = "",
	desc = "春菜一技能适用者tag",
	effect_list = {
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach"
			},
			arg_list = {
				tag = "haruna_miehuo"
			}
		}
	}
}
