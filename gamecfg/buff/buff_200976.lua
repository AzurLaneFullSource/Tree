return {
	init_effect = "",
	name = "2024 斯特拉斯堡活动EX 修改白鹰精英损管效果",
	time = 3,
	picture = "",
	desc = "",
	stack = 1,
	id = 200976,
	icon = 200976,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				check_target = "TargetAllHarm",
				minTargetNumber = 1,
				target = "TargetShipTag",
				buff_id = 200977,
				ship_tag_list = {
					"USDC"
				}
			}
		}
	}
}
