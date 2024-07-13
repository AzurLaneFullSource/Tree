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
				time = 15,
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
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200942,
	icon = 200942,
	last_effect = ""
}
