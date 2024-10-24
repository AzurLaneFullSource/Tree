return {
	effect_list = {
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				tag = "pucimaosihuixue"
			}
		},
		{
			type = "BattleBuffCleanse",
			trigger = {
				"onHPRatioUpdate"
			},
			arg_list = {
				hpLowerBound = 0.5,
				hpSigned = 0,
				buff_id_list = {
					150643
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
	desc_get = "",
	name = "",
	init_effect = "",
	time = 0,
	color = "blue",
	picture = "",
	desc = "",
	stack = 1,
	id = 150643,
	icon = 150640,
	last_effect = ""
}
