return {
	time = 1,
	name = "2024天城航母活动 B3 赤城meta 监听召唤物存活情况",
	init_effect = "",
	stack = 1,
	id = 201088,
	picture = "",
	last_effect = "bossbomb_red",
	desc = "",
	effect_list = {
		{
			type = "BattleBuffCleanse",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id_list = {
					201085
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201088
			}
		}
	}
}
