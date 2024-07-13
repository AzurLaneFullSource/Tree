return {
	init_effect = "",
	name = "2024幼儿园活动 战列石膏喵 化学试剂中毒效果",
	time = 10.1,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200959,
	icon = 200959,
	last_effect = "poison_buff",
	effect_list = {
		{
			type = "BattleBuffDOT",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				attr = "cannonPower",
				exposeGroup = 1,
				time = 2,
				cloakExpose = 36,
				number = 0.4,
				dotType = 1,
				k = 3
			}
		}
	}
}
