return {
	init_effect = "",
	name = "2024鲁梅活动 剧情战触发 直接摧毁BOSS",
	time = 3,
	picture = "",
	desc = "",
	stack = 1,
	id = 201223,
	icon = 201223,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 200440,
				target = "TargetAllHelp"
			}
		}
	}
}
