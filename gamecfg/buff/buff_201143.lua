return {
	init_effect = "",
	name = "2024风帆二期活动 T2怪群 刷新随机位置",
	time = 3,
	picture = "",
	desc = "",
	stack = 1,
	id = 201143,
	icon = 201143,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 200824,
				target = "TargetSelf"
			}
		}
	}
}
