return {
	init_effect = "",
	name = "2024匹兹堡活动 EX BOSS本体监听",
	time = 3,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201005,
	icon = 201005,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCleanse",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id_list = {
					201002
				}
			}
		}
	}
}
