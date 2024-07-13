return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			pop = {},
			trigger = {
				"onStartGame"
			},
			arg_list = {
				skill_id = 1090272
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				skill_id = 1090271,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				time = 15,
				skill_id = 1090273,
				target = "TargetSelf"
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
	name = "战术指挥·莱比锡",
	init_effect = "",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 1090270,
	icon = 1050,
	last_effect = ""
}
