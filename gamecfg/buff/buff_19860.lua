return {
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onStartGame"
			},
			pop = {},
			arg_list = {
				buff_id = 19861
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				maxWeaponNumber = 0,
				skill_id = 19862,
				target = "TargetSelf",
				check_weapon = true,
				label = {
					"IJN",
					"AA"
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				minWeaponNumber = 1,
				skill_id = 19863,
				target = "TargetSelf",
				check_weapon = true,
				label = {
					"IJN",
					"AA"
				}
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onHPRatioUpdate"
			},
			arg_list = {
				hpUpperBound = 0.3,
				buff_id = 19865,
				target = "TargetSelf",
				quota = 1
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
	id = 19860,
	icon = 19860,
	last_effect = ""
}
