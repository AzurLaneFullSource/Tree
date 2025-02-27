return {
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onSubmarineRaid"
			},
			arg_list = {
				buff_id = 150981,
				quota = 1
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onSubmarineRaid"
			},
			arg_list = {
				quota = 1,
				target = "TargetSelf",
				skill_id = 150982
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onSubmarineRaid"
			},
			arg_list = {
				buff_id = 150982,
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
	name = "危机等级上升！",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 150980,
	icon = 150980,
	last_effect = ""
}
