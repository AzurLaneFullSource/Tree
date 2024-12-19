return {
	init_effect = "",
	name = "2024鲁梅活动 剧情战触发 希佩尔弹幕",
	time = 10,
	picture = "",
	desc = "",
	stack = 1,
	id = 201221,
	icon = 201221,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201221,
				target = "TargetSelf"
			}
		}
	}
}
