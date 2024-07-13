return {
	init_effect = "",
	name = "2024幼儿园活动 剧情战 召唤雕像1",
	time = 5,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200966,
	icon = 200966,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 200966,
				target = "TargetSelf"
			}
		}
	}
}
