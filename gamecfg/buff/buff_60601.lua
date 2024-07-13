return {
	time = 0,
	name = "",
	init_effect = "",
	color = "red",
	picture = "",
	desc = "提高炮击属性",
	stack = 1,
	id = 60601,
	icon = 60600,
	last_effect = "",
	blink = {
		1,
		0,
		0,
		0.3,
		0.3
	},
	effect_list = {
		{
			type = "BattleBuffAddAttrRatio",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "cannonPower",
				number = 500
			}
		}
	}
}
