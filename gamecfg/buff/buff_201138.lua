return {
	init_effect = "",
	name = "2024天城航母活动 EX BAN技能",
	time = 3,
	picture = "",
	desc = "",
	stack = 1,
	id = 201138,
	icon = 201138,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 201139,
				target = "TargetAllHarm"
			}
		}
	}
}
