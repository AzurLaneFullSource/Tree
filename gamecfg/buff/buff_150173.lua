return {
	init_effect = "",
	name = "",
	time = 0,
	picture = "",
	desc = "标记-LightArmorZ47",
	stack = 1,
	id = 150173,
	icon = 150170,
	last_effect = "Darkness",
	effect_list = {
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				tag = "LightArmorZ47"
			}
		}
	}
}
