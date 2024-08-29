return {
	init_effect = "",
	name = "2024瑞凤活动 T3 假面赤城召唤物死亡后重复召唤",
	time = 0.1,
	picture = "",
	desc = "",
	stack = 1,
	id = 201038,
	icon = 201038,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				buff_id = 201036,
				maxTargetNumber = 0,
				target = "TargetSelf",
				check_target = {
					"TargetAllHelp",
					"TargetShipTag"
				},
				ship_tag_list = {
					"BOSS"
				}
			}
		}
	}
}
