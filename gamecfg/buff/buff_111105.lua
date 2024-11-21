return {
	init_effect = "",
	name = "穿甲弹幕",
	time = 5,
	picture = "",
	desc = "",
	stack = 1,
	id = 111105,
	icon = 111100,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 111106
			}
		}
	}
}
