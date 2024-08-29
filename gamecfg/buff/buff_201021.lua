return {
	init_effect = "",
	name = "2024瑞凤活动 朱红秘境",
	time = 13,
	picture = "",
	desc = "",
	stack = 1,
	id = 201021,
	icon = 201021,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddAttrRatio",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "loadSpeed",
				number = -1000
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onFlagShip"
			},
			arg_list = {
				buff_id = 201022,
				target = "TargetSelf"
			}
		}
	}
}
