return {
	uiEffect = "",
	name = "飞机召唤",
	cd = 0,
	painting = 1,
	id = 150391,
	picture = "1",
	castCV = "skill",
	desc = "",
	effect_list = {
		{
			type = "BattleSkillFire",
			casterAniEffect = "",
			target_choise = "TargetNil",
			targetAniEffect = "",
			arg_list = {
				weapon_id = 496
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
				buff_id = 150394
			}
		}
	}
}
