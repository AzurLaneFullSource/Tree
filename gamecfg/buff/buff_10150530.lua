return {
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onTakeDamage"
			},
			arg_list = {
				buff_id = 10150531,
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
				buff_id = 10150532
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
	id = 10150530,
	icon = 150530,
	last_effect = ""
}
