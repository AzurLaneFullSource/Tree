return {
	init_effect = "",
	name = "2024春节共斗 牵引",
	time = 1,
	picture = "",
	desc = "",
	stack = 1,
	id = 201237,
	icon = 201237,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCleanse",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id_list = {
					201230
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201230,
				target = "TargetSelf"
			}
		}
	}
}
