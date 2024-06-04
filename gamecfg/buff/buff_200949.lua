return {
	init_effect = "",
	name = "2024阿尔萨斯活动 拟态驱逐BOSS 命中光环",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200949,
	icon = 200949,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddAttrRatio",
			trigger = {
				"onStack",
				"onRemove"
			},
			arg_list = {
				attr = "attackRating",
				number = 2500
			}
		}
	}
}
