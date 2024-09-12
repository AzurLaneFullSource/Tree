return {
	id = 201104,
	name = "2024天城航母活动 EX 一阶段转场",
	cd = 0,
	painting = 0,
	effect_list = {
		{
			type = "BattleSkillEditCustomWarning",
			arg_list = {
				key = "warning",
				y = 0.6,
				dialogue = "battle_text_tianchengCV_1",
				duration = 4,
				x = 0,
				op = 1
			}
		},
		{
			type = "BattleSkillPlayFX",
			target_choise = {},
			arg_list = {
				delay = 1,
				effect = "shanshuo",
				casterRelativeCorrdinate = {
					hrz = 0,
					vrt = -10
				}
			}
		}
	}
}
