return {
	blink = {
		0,
		0.7,
		1,
		0.3,
		0.3
	},
	blink = {
		1,
		0,
		0,
		0.3,
		0.3
	},
	effect_list = {
		{
			type = "BattleBuffAddAttrRatio",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				attr = "torpedoPower",
				number = 300
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				quota = 7,
				target = "TargetSelf",
				skill_id = 150982
			}
		},
		{
			type = "BattleBuffCount",
			trigger = {
				"onStack"
			},
			arg_list = {
				countTarget = 7,
				countType = 150984
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onBattleBuffCount"
			},
			arg_list = {
				quota = 1,
				target = "TargetSelf",
				skill_id = 150981,
				countType = 150984
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
	id = 150984,
	name = "雷击属性提升",
	time = 0,
	picture = "",
	desc = "雷击提高",
	stack = 7,
	color = "red",
	icon = 150980,
	last_effect = ""
}
