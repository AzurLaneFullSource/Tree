return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 1,
	id = 801572,
	picture = "0",
	castCV = "skill",
	desc = "",
	effect_list = {
		{
			target_choise = "TargetSelf",
			type = "BattleSkillCLSArea",
			arg_list = {
				buff_id = 401,
				effect = "boerzhanuo_qingdan",
				move_type = 1,
				range = 45,
				speed_x = 0,
				damage_param_a = 600,
				damage_param_b = 0,
				life_time = 0.2,
				damage_tag_list = {
					"Bolzano.META"
				},
				bullet_type_list = {
					1,
					3
				}
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			targetAniEffect = "",
			target_choise = {
				"TargetSelf"
			},
			arg_list = {
				buff_id = 801572
			}
		}
	}
}
