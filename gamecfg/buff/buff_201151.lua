return {
	init_effect = "",
	name = "2024风帆二期活动 海上风暴",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201151,
	icon = 201151,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "damageRatioBullet",
				number = 0.1
			}
		}
	}
}
