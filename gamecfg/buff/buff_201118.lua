return {
	init_effect = "",
	name = "2024天城航母活动 EX 我方触发支援大招 真伤",
	time = 4,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201118,
	icon = 201118,
	last_effect = "cangyanzhuoshao",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201118,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				time = 0.2,
				target = "TargetSelf",
				skill_id = 201118
			}
		}
	}
}
