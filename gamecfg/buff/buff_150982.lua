return {
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onTorpedoWeaponFire"
			},
			arg_list = {
				buff_id = 150983,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onBeHit"
			},
			arg_list = {
				buff_id = 150983,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				buff_id = 150984,
				target = "TargetSelf",
				time = 4
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
	id = 150982,
	icon = 150982,
	last_effect = ""
}
