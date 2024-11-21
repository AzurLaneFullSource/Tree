return {
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				buff_id = 111241,
				fleetPos = "Leader",
				target = "TargetFleetIndex"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				buff_id = 111244,
				fleetPos = "Leader",
				target = "TargetFleetIndex"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onSink"
			},
			arg_list = {
				buff_id = 111243,
				minTargetNumber = 1,
				target = "TargetShipTag",
				ship_tag_list = {
					"haruna_miehuo"
				}
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
	id = 111240,
	icon = 111240,
	last_effect = ""
}
