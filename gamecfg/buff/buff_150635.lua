return {
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onFoeDying"
			},
			arg_list = {
				buff_id = 150632,
				killer = "self",
				target = {
					"TargetAllHelp",
					"TargetShipTag"
				},
				ship_tag_list = {
					"Portsmouth"
				}
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onFoeDying"
			},
			arg_list = {
				buff_id = 150633,
				killer = "self",
				target = {
					"TargetAllHelp",
					"TargetShipTag"
				},
				ship_tag_list = {
					"Portsmouth"
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
	desc_get = "",
	name = "",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 150635,
	icon = 150630,
	last_effect = ""
}
