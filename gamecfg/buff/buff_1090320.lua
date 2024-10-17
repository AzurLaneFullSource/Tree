return {
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				buff_id = 1090321,
				time = 20,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				quota = 1,
				time = 3,
				skill_id = 1090321
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				skill_id = 1090321,
				time = 15
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
	desc_get = "每隔20秒，有15.0%(满级30.0%)的概率发动，自体完全回避所有攻击，持续6秒",
	name = "紧急回避·大斗犬",
	init_effect = "",
	time = 0,
	color = "blue",
	picture = "",
	desc = "每隔20秒，有$1的概率发动，自体完全回避所有攻击，持续6秒",
	stack = 1,
	id = 1090320,
	icon = 4070,
	last_effect = ""
}
