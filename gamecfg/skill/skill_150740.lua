return {
	uiEffect = "",
	name = "布雷作战",
	cd = 0,
	painting = 1,
	id = 150740,
	picture = "0",
	castCV = "skill",
	desc = "",
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
			type = "BattleSkillWeaponFire",
			casterAniEffect = "",
			target_choise = "TargetNil",
			targetAniEffect = "",
			arg_list = {
				delay = 1,
				weaponType = "TorpedoWeapon"
			}
		}
	}
}
