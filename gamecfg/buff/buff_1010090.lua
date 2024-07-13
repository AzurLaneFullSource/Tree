return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAntiAirWeaponFireNear"
			},
			arg_list = {
				rant = 1500,
				target = "TargetSelf",
				skill_id = 1010090,
				time = 8
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onFire"
			},
			arg_list = {
				skill_id = 1010091,
				target = "TargetSelf",
				index = {
					1
				}
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
	desc_get = "防空炮开火时有15%概率触发，队伍防空属性提升30.0%(满级50.0%)，持续8秒",
	name = "我是NO.1！ +",
	init_effect = "",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "防空炮开火时有15%概率触发，队伍防空属性提升$1，持续8秒",
	stack = 1,
	id = 1010090,
	icon = 10090,
	last_effect = ""
}
