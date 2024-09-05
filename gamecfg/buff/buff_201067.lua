return {
	init_effect = "",
	name = "黑长门 海域状态 月亏效果",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201067,
	icon = 201067,
	last_effect = "changmen_alter_sign01",
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				attr = "injureRatio",
				number = -0.2
			}
		},
		{
			type = "BattleBuffHealingCorrupt",
			trigger = {
				"onTakeHealing"
			},
			arg_list = {
				corruptRate = 0.5,
				damageRate = 0
			}
		}
	}
}
