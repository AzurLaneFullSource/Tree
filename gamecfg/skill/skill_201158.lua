return {
	id = 201158,
	name = "2024风帆二期活动 幻想之力",
	cd = 0,
	painting = "huanxianghao",
	effect_list = {
		{
			type = "BattleSkillFire",
			target_choise = {
				"TargetAllHarm",
				"TargetHighestHP"
			},
			arg_list = {
				emitter = "BattleBulletEmitter",
				delay = 1,
				weapon_id = 3218504,
				attack_attribute_convert = {
					attr_type = "fleetGS",
					A = 80,
					B = 400
				}
			}
		}
	}
}
