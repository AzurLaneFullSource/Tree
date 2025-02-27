return {
	uiEffect = "",
	name = "2025拉斐尔活动 飞空战舰支援",
	cd = 0,
	painting = "dafenqi",
	id = 201289,
	picture = "0",
	aniEffect = "",
	desc = "",
	effect_list = {
		{
			target_choise = "TargetNil",
			type = "BattleSkillFire",
			arg_list = {
				emitter = "BattleBulletEmitter",
				weapon_id = 3246201,
				attack_attribute_convert = {
					attr_type = "fleetGS",
					A = 80,
					B = 400
				}
			}
		},
		{
			target_choise = "TargetNil",
			type = "BattleSkillFire",
			arg_list = {
				emitter = "BattleBulletEmitter",
				weapon_id = 3246202,
				attack_attribute_convert = {
					attr_type = "fleetGS",
					A = 80,
					B = 400
				}
			}
		}
	}
}
