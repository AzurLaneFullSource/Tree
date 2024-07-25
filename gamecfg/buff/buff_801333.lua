return {
	init_effect = "",
	name = "",
	time = 8,
	picture = "",
	desc = "标记",
	stack = 1,
	id = 801333,
	icon = 801330,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach"
			},
			arg_list = {
				tag = "KasumiSkillTarget"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onRemove"
			},
			arg_list = {
				buff_id = 801335,
				target = "TargetSelf"
			}
		}
	}
}
