return {
	time = 8,
	name = "",
	init_effect = "jinengchufablue",
	color = "blue",
	picture = "",
	desc = "完全闪避",
	stack = 1,
	id = 801334,
	icon = 801330,
	last_effect = "",
	blink = {
		0,
		0.7,
		1,
		0.3,
		0.3
	},
	effect_list = {
		{
			type = "BattleBuffAddAttr",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				group = 801330,
				attr = "perfectDodge",
				number = 1
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 801333
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				time = 1,
				initialCD = true,
				skill_id = 801334
			}
		}
	}
}
