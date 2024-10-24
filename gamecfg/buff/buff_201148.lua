return {
	time = 0,
	name = "2024风帆二期活动 寂静涡流 群体增伤减伤光环",
	init_effect = "",
	color = "blue",
	picture = "",
	desc = "",
	stack = 1,
	id = 201148,
	icon = 201148,
	last_effect = "",
	blink = {
		0,
		0,
		0.5,
		0.3,
		0.3
	},
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "damageRatioBullet",
				number = 0.03
			}
		},
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "injureRatio",
				number = -0.03
			}
		}
	}
}
