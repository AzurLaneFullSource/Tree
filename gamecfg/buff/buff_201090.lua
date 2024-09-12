return {
	init_effect = "",
	name = "2024天城航母活动 世界切片：苍红",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201090,
	icon = 201090,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddAttrRatio",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "dodgeRate",
				number = 500
			}
		},
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "igniteReduce",
				number = 2000
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onFlagShip"
			},
			arg_list = {
				buff_id = 201091,
				target = "TargetSelf"
			}
		}
	}
}
