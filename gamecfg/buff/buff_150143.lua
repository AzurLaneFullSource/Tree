return {
	init_effect = "",
	name = "",
	time = 5.1,
	picture = "",
	desc = "",
	stack = 1,
	id = 150143,
	icon = 150140,
	last_effect = "zhuoshao",
	effect_list = {
		{
			type = "BattleBuffDOT",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				attr = "cannonPower",
				exposeGroup = 1,
				time = 1,
				cloakExpose = 36,
				number = 150,
				dotType = 1,
				k = 0
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				time = 1,
				skill_id = 150142,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 60,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onRemove"
			},
			arg_list = {
				skill_id = 61,
				target = "TargetSelf"
			}
		}
	}
}
