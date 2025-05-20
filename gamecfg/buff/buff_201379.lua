return {
	init_effect = "",
	name = "2025狮UR活动 辉翼狮支援",
	time = 2,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201379,
	icon = 201379,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onRemove"
			},
			arg_list = {
				buff_id = 201380
			}
		}
	}
}
