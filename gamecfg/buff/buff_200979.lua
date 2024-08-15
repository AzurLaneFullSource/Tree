return {
	init_effect = "",
	name = "2024匹兹堡活动 苍红幻境",
	time = 13,
	picture = "",
	desc = "",
	stack = 1,
	id = 200979,
	icon = 200979,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffHealingCorrupt",
			trigger = {
				"onTakeHealing"
			},
			arg_list = {
				corruptRate = 0.1,
				damageRate = 0
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
				number = 0.05
			}
		}
	}
}
