return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 200917,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onRemove"
			},
			arg_list = {
				skill_id = 200918,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onRemove"
			},
			arg_list = {
				buff_id = 8002,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onRemove"
			},
			arg_list = {
				buff_id = 8976,
				target = "TargetSelf"
			}
		}
	},
	{},
	{},
	init_effect = "",
	name = "2024阿尔萨斯活动 自爆船BUFF",
	time = 3,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200918,
	icon = 200918,
	last_effect = ""
}
