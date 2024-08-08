return {
	uiEffect = "",
	name = "快速起飞·长岛",
	cd = 0,
	painting = 1,
	id = 1090285,
	picture = "0",
	castCV = "skill",
	desc = "快速起飞·长岛",
	aniEffect = {
		effect = "jineng",
		offset = {
			0,
			-2,
			0
		}
	},
	effect_list = {
		{
			type = "BattleSkillInstantCoolDown",
			casterAniEffect = "",
			target_choise = "TargetNil",
			targetAniEffect = "",
			arg_list = {
				weaponType = "AirAssist"
			}
		}
	}
}
