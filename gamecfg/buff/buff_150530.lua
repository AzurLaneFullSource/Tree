return {
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onTakeDamage"
			},
			arg_list = {
				buff_id = 150531,
				target = "TargetDamageSource"
			}
		},
		{
			type = "BattleBuffFixVelocity",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				add = 0,
				mul = -1000
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onTakeDamage"
			},
			arg_list = {
				target = "TargetSelf",
				buff_id = 150532
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
	id = 150530,
	icon = 150530,
	last_effect = ""
}
