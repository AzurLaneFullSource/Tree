return {
	init_effect = "",
	name = "",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 151181,
	icon = 151180,
	last_effect = "Darkness",
	effect_list = {
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				tag = "TrinidadTarget"
			}
		},
		{
			type = "BattleBuffAddAircraftTag",
			trigger = {
				"onAircraftCreate"
			},
			arg_list = {
				tag_list = {
					"TrinidadTarget"
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onSink"
			},
			arg_list = {
				skill_id = 151181,
				target = "TargetSelf",
				deathCause = {
					1,
					3,
					4,
					5
				}
			}
		}
	}
}
