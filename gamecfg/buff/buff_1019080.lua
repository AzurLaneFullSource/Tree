return {
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onStartGame"
			},
			pop = {},
			arg_list = {
				buff_id = 19081
			}
		},
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach"
			},
			arg_list = {
				tag = "chuyunzhuanwu"
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onChargeWeaponFire"
			},
			arg_list = {
				skill_id = 1019080,
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
	name = "",
	init_effect = "",
	time = 0,
	color = "",
	picture = "",
	desc = "",
	stack = 1,
	id = 1019080,
	icon = 19080,
	last_effect = ""
}
