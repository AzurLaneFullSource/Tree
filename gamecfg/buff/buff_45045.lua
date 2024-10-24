return {
	init_effect = "jinengchufared",
	name = "指挥喵天赋-碧海亲和",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 45045,
	icon = 45040,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 45046,
				target = {
					"TargetPlayerVanguardFleet"
				}
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 45047,
				target = {
					"TargetPlayerMainFleet"
				}
			}
		}
	}
}
