return {
	init_effect = "",
	name = "奇怪装置D",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 60590,
	icon = 60590,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				skill_id = 60590
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				skill_id = 60590,
				time = 10
			}
		},
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				tag = "StrangeDeviceD"
			}
		}
	}
}
