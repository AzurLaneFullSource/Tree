return {
	effect_list = {
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				tag = "laffeybot1"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onSink"
			},
			arg_list = {
				buff_id = 17441,
				target = {
					"TargetAllHelp",
					"TargetShipTag"
				},
				ship_tag_list = {
					"Laffey II"
				}
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onRemove"
			},
			arg_list = {
				buff_id = 17441,
				target = {
					"TargetAllHelp",
					"TargetShipTag"
				},
				ship_tag_list = {
					"Laffey II"
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onRemove"
			},
			arg_list = {
				skill_id = 17301
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
	time = 15,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 17302,
	icon = 17300,
	last_effect = ""
}
