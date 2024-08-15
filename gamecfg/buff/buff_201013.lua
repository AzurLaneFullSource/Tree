return {
	init_effect = "",
	name = "2024 匹兹堡活动EX 挑战 支援船入场",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201012,
	icon = 201012,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201012,
				target = "TargetSelf"
			}
		}
	}
}
