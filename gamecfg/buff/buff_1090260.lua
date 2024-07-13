return {
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				buff_id = 1090261,
				time = 20,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onTakeDamage"
			},
			arg_list = {
				target = "TargetSelf",
				initialCD = true,
				skill_id = 1090261,
				time = 15
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onTakeDamage"
			},
			arg_list = {
				quota = 3,
				target = "TargetSelf",
				skill_id = 1090262
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
	id = 1090260,
	icon = 2000,
	last_effect = ""
}
