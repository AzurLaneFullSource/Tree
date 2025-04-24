return {
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onStartGame"
			},
			pop = {},
			arg_list = {
				buff_id = 151121,
				quota = 1,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onChargeWeaponFire"
			},
			arg_list = {
				skill_id = 151120,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onStartGame",
				"onHPRatioUpdate"
			},
			arg_list = {
				quota = 1,
				hpUpperBound = 0.9,
				skill_id = 151121,
				target = "TargetSelf",
				check_target = {
					"TargetSelf"
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onStartGame",
				"onHPRatioUpdate"
			},
			arg_list = {
				quota = 1,
				hpUpperBound = 0.8,
				skill_id = 151121,
				target = "TargetSelf",
				check_target = {
					"TargetSelf"
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onStartGame",
				"onHPRatioUpdate"
			},
			arg_list = {
				quota = 1,
				hpUpperBound = 0.7,
				skill_id = 151121,
				target = "TargetSelf",
				check_target = {
					"TargetSelf"
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
	init_effect = "",
	name = "",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 151120,
	icon = 151120,
	last_effect = ""
}
