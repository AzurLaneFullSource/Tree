return {
	init_effect = "",
	name = "2025狮UR活动 辉翼狮支援 持续时间",
	time = 20,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201369,
	icon = 201369,
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
