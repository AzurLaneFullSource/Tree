return {
	init_effect = "",
	name = "2025狮UR活动 SP 召唤物死亡强化本体",
	time = 0,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 201373,
	icon = 201373,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onBeforeFatalDamage"
			},
			arg_list = {
				buff_id = 201374,
				target = "TargetShipTag",
				ship_tag_list = {
					"BOSS"
				}
			}
		}
	}
}
