return {
	time = 0,
	name = "2025拉斐尔活动 剧情战触发 马可波罗支援强化BUFF",
	init_effect = "",
	stack = 1,
	id = 201301,
	picture = "",
	last_effect = "zhihuiRing02_buff",
	desc = "",
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "damageRatioBullet",
				number = 1
			}
		},
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "injureRatio",
				number = 0.5
			}
		}
	}
}
