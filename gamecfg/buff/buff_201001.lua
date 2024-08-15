return {
	init_effect = "",
	name = "2024匹兹堡活动 X半影 黑色火球效果 8秒特殊灼烧",
	time = 8.1,
	picture = "",
	desc = "",
	stack = 1,
	id = 201001,
	icon = 201001,
	last_effect = "qinshibuff1",
	effect_list = {
		{
			type = "BattleBuffDOT",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				attr = "cannonPower",
				number = 5,
				time = 2,
				dotType = 1,
				k = 1.5
			}
		}
	}
}
