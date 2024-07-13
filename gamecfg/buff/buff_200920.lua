return {
	effect_list = {
		{
			type = "BattleBuffSetBattleUnitType",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				value = -99
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onRemove"
			},
			arg_list = {
				buff_id = 200921,
				target = "TargetSelf"
			}
		}
	},
	{},
	{},
	{},
	{},
	{},
	init_effect = "",
	name = "2024阿尔萨斯活动 死神之桥 本体",
	time = 12,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200920,
	icon = 200920,
	last_effect = ""
}
