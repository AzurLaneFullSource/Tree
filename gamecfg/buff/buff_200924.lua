return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 200920,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				time = 25,
				target = "TargetSelf",
				skill_id = 200920
			}
		}
	},
	{},
	{},
	{},
	{},
	{},
	init_effect = "",
	name = "2024阿尔萨斯活动 死神之桥 攻击",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200924,
	icon = 200924,
	last_effect = ""
}
