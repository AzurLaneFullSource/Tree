return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAntiAirWeaponFireNear"
			},
			arg_list = {
				rant = 2500,
				target = "TargetSelf",
				skill_id = 1090390,
				time = 5
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				buff_id = 1090392,
				time = 20,
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
	name = "防空模式·哥伦比亚",
	init_effect = "",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 1090390,
	icon = 4090,
	last_effect = ""
}
