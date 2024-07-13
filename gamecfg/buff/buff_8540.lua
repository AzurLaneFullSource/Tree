return {
	init_effect = "",
	name = "战术模拟",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 8540,
	icon = 8530,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				skill_id = 8540
			}
		}
	}
}
