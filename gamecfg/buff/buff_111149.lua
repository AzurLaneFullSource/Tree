return {
	time = 0,
	name = "",
	init_effect = "",
	stack = 1,
	id = 111149,
	picture = "",
	last_effect = "",
	desc = "春菜一技能适用者tag_还没回血过的",
	effect_list = {
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				tag = "haruna_only"
			}
		}
	}
}
