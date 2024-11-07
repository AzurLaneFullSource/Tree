return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				skill_id = 1090331
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				time = 5,
				skill_id = 1090330,
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
	name = "雷击指挥·白露",
	init_effect = "",
	time = 0,
	color = "yellow",
	picture = "1",
	desc = "",
	stack = 1,
	id = 1090330,
	icon = 1010,
	last_effect = ""
}
