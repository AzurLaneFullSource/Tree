return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				quota = 8,
				initialCD = true,
				time = 0.2,
				skill_id = 150026
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onStack"
			},
			pop = {},
			arg_list = {
				buff_id = 150027
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
	time = 5,
	color = "red",
	picture = "",
	desc = "",
	stack = 2,
	id = 150026,
	icon = 150020,
	last_effect = ""
}
