return {
	init_effect = "",
	name = "黑长门 海域状态 月盈效果",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201068,
	icon = 201068,
	last_effect = "changmen_alter_sign02",
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "injureRatio",
				number = 0.2
			}
		},
		{
			type = "BattleBuffHealingCorrupt",
			trigger = {
				"onTakeHealing"
			},
			arg_list = {
				corruptRate = -1,
				damageRate = 0
			}
		}
	}
}
