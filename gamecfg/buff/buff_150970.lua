return {
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onFlagShip"
			},
			arg_list = {
				target = "TargetSelf",
				buff_id = 150971
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onUpperConsort"
			},
			arg_list = {
				buff_id = 150972,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onLowerConsort"
			},
			arg_list = {
				target = "TargetSelf",
				buff_id = 150973
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
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 150970,
	icon = 150940,
	last_effect = ""
}
