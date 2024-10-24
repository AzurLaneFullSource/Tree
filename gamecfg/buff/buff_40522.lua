return {
	init_effect = "",
	name = "FFS-指挥-炮击II具体效果",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "FFS-指挥-炮击II具体效果",
	stack = 1,
	id = 40522,
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
				convertAttr = "cannonPower"
			}
		}
	}
}
