return {
	init_effect = "",
	name = "2024天城航母活动 奈落之渊 META有利效果",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201095,
	icon = 201095,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "damageRatioBullet",
				number = 0.1
			}
		},
		{
			type = "BattleBuffHealingCorrupt",
			trigger = {
				"onTakeHealing"
			},
			arg_list = {
				corruptRate = -0.1,
				damageRate = 0
			}
		}
	}
}
