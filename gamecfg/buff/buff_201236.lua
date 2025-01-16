return {
	init_effect = "",
	name = "2024春节共斗 牵引",
	time = 0.1,
	picture = "",
	desc = "",
	stack = 1,
	id = 201236,
	icon = 201236,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 201233,
				range = 80,
				target = "TargetHarmNearest"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onRemove"
			},
			arg_list = {
				buff_id = 201231,
				minTargetNumber = 1,
				target = "TargetShipTag",
				ship_tag_list = {
					"SIGN"
				}
			}
		}
	}
}
