return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onChargeWeaponFire"
			},
			arg_list = {
				skill_id = 1011490,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onChargeWeaponFire"
			},
			arg_list = {
				buff_id = 1011496,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				buff_id = 1011497,
				exceptCaster = true,
				target = "TargetAllHelp"
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
	name = "正面火力+",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "第一次必定触发",
	stack = 1,
	id = 1011490,
	icon = 11490,
	last_effect = ""
}
