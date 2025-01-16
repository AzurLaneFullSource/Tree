return {
	init_effect = "",
	name = "2024春节共斗 牵引",
	time = 11,
	picture = "",
	desc = "",
	stack = 1,
	id = 201230,
	icon = 201230,
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
				"onUpdate"
			},
			arg_list = {
				buff_id = 201236,
				target = "TargetSelf",
				time = 0.5
			}
		}
	}
}
