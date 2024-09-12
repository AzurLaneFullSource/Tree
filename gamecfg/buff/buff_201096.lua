return {
	init_effect = "",
	name = "2024天城航母活动 奈落之渊 非META不良效果",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201096,
	icon = 201096,
	last_effect = "",
	effect_list = {
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
		},
		{
			type = "BattleBuffHealingCorrupt",
			trigger = {
				"onTakeHealing"
			},
			arg_list = {
				corruptRate = 0.08,
				damageRate = 0
			}
		}
	}
}
