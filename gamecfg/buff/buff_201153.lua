return {
	init_effect = "",
	name = "2024风帆二期活动 寂静之海",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201153,
	icon = 201153,
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
		}
	}
}
