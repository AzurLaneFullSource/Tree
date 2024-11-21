return {
	init_effect = "",
	name = "高爆弹幕",
	time = 3,
	picture = "",
	desc = "",
	stack = 1,
	id = 111114,
	icon = 111100,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 111114
			}
		}
	}
}
