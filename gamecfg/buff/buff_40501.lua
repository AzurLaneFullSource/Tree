return {
	init_effect = "",
	name = "",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "战术-炮击II",
	stack = 1,
	id = 40501,
	icon = 40500,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddAttrRatioCommander",
			trigger = {
				"onAttach"
			},
			arg_list = {
				ability = "tactic",
				convertRate = 0.8,
				convertAttr = "cannonPower"
			}
		}
	}
}
