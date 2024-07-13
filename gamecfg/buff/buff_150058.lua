return {
	init_effect = "",
	name = "敌方自我识别护甲",
	time = 1,
	picture = "",
	desc = "",
	stack = 2,
	id = 150058,
	icon = 150050,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				minTargetNumber = 1,
				armor_type = 1,
				quota = 1,
				skill_id = 150059,
				target = "TargetSelf",
				check_target = {
					"TargetSelf",
					"TargetShipArmor"
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				minTargetNumber = 1,
				armor_type = 2,
				quota = 1,
				skill_id = 150060,
				target = "TargetSelf",
				check_target = {
					"TargetSelf",
					"TargetShipArmor"
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				minTargetNumber = 1,
				armor_type = 3,
				quota = 1,
				skill_id = 150061,
				target = "TargetSelf",
				check_target = {
					"TargetSelf",
					"TargetShipArmor"
				}
			}
		}
	}
}
