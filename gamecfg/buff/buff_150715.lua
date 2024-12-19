return {
	init_effect = "",
	name = "召唤物飞剑龙持续时间",
	time = 12,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 150715,
	icon = 150715,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onRemove"
			},
			arg_list = {
				skill_id = 17301
			}
		}
	}
}
