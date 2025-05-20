return {
	time = 3,
	name = "2025狮UR活动 剧情战触发 召唤塞壬单位（人形） 开场随机位置",
	init_effect = "",
	stack = 1,
	id = 201418,
	picture = "",
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 201407,
				target = "TargetSelf"
			}
		}
	}
}
