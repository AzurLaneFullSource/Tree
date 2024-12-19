return {
	uiEffect = "",
	name = "2024鲁梅活动 移出屏幕然后清除该单位",
	cd = 0,
	painting = 0,
	id = 201229,
	picture = "0",
	aniEffect = "",
	desc = "",
	effect_list = {
		{
			type = "BattleSkillTeleport",
			target_choise = {},
			arg_list = {
				delay = 0.4,
				absoulteCorrdinate = {
					x = -100,
					z = 50
				}
			}
		},
		{
			type = "BattleSkillPlayFX",
			target_choise = {},
			arg_list = {
				delay = 0.1,
				effect = "shanshuo",
				casterRelativeCorrdinate = {
					hrz = 0,
					vrt = 0
				}
			}
		}
	}
}
