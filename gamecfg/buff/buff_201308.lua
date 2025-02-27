return {
	time = 6,
	name = "2025拉斐尔活动 剧情战 神菠萝武器",
	init_effect = "",
	stack = 1,
	id = 201308,
	picture = "",
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffNewWeapon",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				weapon_id = 3247008
			}
		}
	}
}
