return {
	time = 0,
	name = "2024大凤meta 领域",
	init_effect = "",
	stack = 1,
	id = 201177,
	picture = "",
	last_effect = "",
	desc = "",
	effect_list = {
		{
			type = "BattleBuffHealingCorrupt",
			trigger = {
				"onTakeHealing"
			},
			arg_list = {
				corruptRate = 1,
				damageRate = 1
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onBeforeFatalDamage"
			},
			arg_list = {
				buff_id = 201178,
				target = "TargetShipTag",
				ship_tag_list = {
					"BOSS"
				}
			}
		}
	}
}
