return {
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onBeHit"
			},
			arg_list = {
				countTarget = 9,
				time = 1,
				countType = 150930
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onBattleBuffCount"
			},
			arg_list = {
				target = "TargetSelf",
				skill_id = 150930,
				countType = 150930
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onBattleBuffCount"
			},
			arg_list = {
				target = "TargetSelf",
				skill_id = 150931,
				countType = 150930
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
	id = 150930,
	icon = 150930,
	last_effect = ""
}
