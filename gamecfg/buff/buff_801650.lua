return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAirAssistReady"
			},
			arg_list = {
				skill_id = 801650,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onBulletHit"
			},
			arg_list = {
				quota = 5,
				skill_id = 801651,
				target = "TargetSelf",
				index = {
					801650
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAirAssistReady"
			},
			arg_list = {
				minTargetNumber = 1,
				target = "TargetSelf",
				skill_id = 801653,
				check_target = {
					"TargetSelf",
					"TargetShipTag"
				},
				ship_tag_list = {
					"Satellite_Ready"
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				skill_id = 801654
			}
		}
	},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	init_effect = "",
	name = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 801650,
	icon = 801650,
	last_effect = ""
}
