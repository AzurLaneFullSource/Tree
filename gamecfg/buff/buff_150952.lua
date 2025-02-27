return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onTakeDamage"
			},
			arg_list = {
				maxHPRatio = 0.2,
				countType = 150950
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onBattleBuffCount"
			},
			arg_list = {
				buff_id = 150957,
				target = "TargetSelf",
				countType = 150950
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
	id = 150952,
	icon = 150950,
	last_effect = ""
}
