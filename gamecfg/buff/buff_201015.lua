return {
	init_effect = "",
	name = "2024匹兹堡活动EX 挑战 支援船护甲",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201015,
	icon = 201015,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				tag = "NPC"
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
				number = 5
			}
		},
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "damageReduceFromAmmoType_1",
				number = 0.9
			}
		}
	}
}
