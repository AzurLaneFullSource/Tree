return {
	init_effect = "",
	name = "2024天城航母活动 EX 二阶段转场",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201140,
	icon = 201140,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onBeforeFatalDamage"
			},
			arg_list = {
				skill_id = 8692,
				target = "TargetHarmFarthest"
			}
		}
	}
}
