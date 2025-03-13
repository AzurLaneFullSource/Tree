return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				skill_id = 1011560,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onChargeWeaponFire"
			},
			arg_list = {
				buff_id = 1011562,
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
	desc_get = "更换主炮弹药种类",
	name = "2700磅的正义+",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "更换主炮弹药种类",
	stack = 1,
	id = 1011560,
	icon = 11560,
	last_effect = ""
}
