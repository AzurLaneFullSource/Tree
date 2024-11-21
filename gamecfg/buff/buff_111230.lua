return {
	init_effect = "",
	name = "小暗金色斩击",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 111230,
	icon = 111100,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				target = "TargetSelf",
				time = 30,
				skill_id = 111230
			}
		}
	}
}
