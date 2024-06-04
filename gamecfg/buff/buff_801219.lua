return {
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				maxTargetNumber = 0,
				buff_id = 801217,
				check_target = {
					"TargetSelf",
					"TargetShipTag"
				},
				ship_tag_list = {
					"beiyaenmeta"
				}
			}
		},
		{
			type = "BattleBuffCleanse",
			trigger = {
				"onRemove"
			},
			arg_list = {
				buff_id_list = {
					801217
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
	desc_get = "暴风领域",
	name = "",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 801219,
	icon = 800647,
	last_effect = ""
}
