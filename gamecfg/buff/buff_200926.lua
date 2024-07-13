return {
	init_effect = "",
	name = "2024阿尔萨斯活动 亡语回血",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200926,
	icon = 200926,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onBeforeFatalDamage"
			},
			arg_list = {
				skill_id = 200926,
				target = "TargetSelf"
			}
		}
	}
}
