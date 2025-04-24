return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onShieldBroken"
			},
			arg_list = {
				skill_id = 151044,
				shieldBuffID = 151042
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				target = "TargetSelf",
				initialCD = true,
				skill_id = 151042,
				time = 1
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
	init_effect = "",
	name = "",
	time = 5,
	color = "blue",
	picture = "",
	desc = "",
	stack = 1,
	id = 151043,
	icon = 151040,
	last_effect = ""
}
