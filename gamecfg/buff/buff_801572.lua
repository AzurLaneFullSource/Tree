return {
	init_effect = "",
	name = "",
	time = 10,
	picture = "",
	desc = "",
	stack = 1,
	id = 801572,
	icon = 801570,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCleanse",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id_list = {
					801571
				}
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onRemove"
			},
			arg_list = {
				buff_id = 801571,
				target = "TargetSelf"
			}
		}
	}
}
