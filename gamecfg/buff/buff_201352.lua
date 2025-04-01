return {
	time = 0.5,
	name = "2025愚人节 剧情战",
	init_effect = "",
	stack = 1,
	id = 201352,
	picture = "",
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onRemove"
			},
			arg_list = {
				skill_id = 201352,
				target = "TargetSelf"
			}
		}
	}
}
