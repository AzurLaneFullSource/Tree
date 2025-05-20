return {
	init_effect = "",
	name = "",
	time = 3,
	color = "red",
	picture = "",
	desc = "撞残跑路，撞死回血",
	stack = 1,
	id = 151191,
	icon = 151190,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCount",
			trigger = {
				"onTakeDamage"
			},
			arg_list = {
				maxHPRatio = 0.08,
				countTarget = 0,
				countType = 151190
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onBattleBuffCount"
			},
			arg_list = {
				target = "TargetSelf",
				skill_id = 151191,
				countType = 151190
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onFoeDying"
			},
			arg_list = {
				quota = 1,
				target = "TargetSelf",
				killer = "self",
				skill_id = 151192
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				quota = 1,
				target = "TargetSelf",
				skill_id = 151193
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onAttach"
			},
			arg_list = {
				buff_id = 151194,
				quota = 1,
				target = "TargetSelf"
			}
		}
	}
}
