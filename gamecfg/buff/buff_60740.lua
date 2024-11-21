return {
	init_effect = "",
	name = "",
	time = 50,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 60740,
	icon = 60740,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 60741,
				target = "TargetSelf"
			}
		}
	}
}
