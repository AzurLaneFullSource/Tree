return {
	init_effect = "",
	name = "潜艇-指挥-雷击II具体效果",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "潜艇-指挥-雷击II具体效果",
	stack = 1,
	id = 40521,
	icon = 40520,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddAttrRatioCommander",
			trigger = {
				"onAttach"
			},
			arg_list = {
				ability = "command",
				convertRate = 0.8,
				convertAttr = "torpedoPower"
			}
		}
	}
}
