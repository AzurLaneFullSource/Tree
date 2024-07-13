return {
	init_effect = "",
	name = "2024阿尔萨斯活动 辉光之城-绽放 触发弹幕",
	time = 0.5,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200933,
	icon = 200933,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCleanse",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				buff_id_list = {
					200932
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 200933,
				target = "TargetSelf"
			}
		}
	}
}
