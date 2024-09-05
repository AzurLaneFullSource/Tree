return {
	init_effect = "",
	name = "",
	time = 6,
	picture = "",
	desc = "",
	stack = 1,
	id = 1090315,
	icon = 1090310,
	last_effect = "Darkness",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 401,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffCleanse",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				buff_id_list = {
					1090314
				}
			}
		}
	}
}
