return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 200939,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				time = 5,
				target = "TargetSelf",
				skill_id = 200939
			}
		}
	},
	{},
	{},
	{},
	{},
	{},
	init_effect = "",
	name = "2024阿尔萨斯活动 死神之影精英 定期刷新浮游炮",
	time = 12,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200945,
	icon = 200945,
	last_effect = ""
}
