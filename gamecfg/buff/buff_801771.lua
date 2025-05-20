return {
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onHPRatioUpdate"
			},
			arg_list = {
				buff_id = 801772,
				dhpGreaterMaxhp = -0.015,
				target = {
					"TargetAllHelp",
					"TargetShipTag"
				},
				ship_tag_list = {
					"GloriousMETA"
				}
			}
		},
		{
			type = "BattleBuffReflectDamage",
			trigger = {
				"onDamageConclude"
			},
			arg_list = {
				reflectRate = 0.05,
				valve = 0.015,
				reflectTarget = {
					target_choise = {
						"TargetAllFoe",
						"TargetHarmNearest"
					}
				}
			}
		},
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				tag = "qiangweikeyin"
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
	id = 801771,
	icon = 801770,
	last_effect = "guangrongmeta1"
}
