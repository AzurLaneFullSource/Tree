return {
	uiEffect = "",
	name = "鞭炮",
	cd = 0,
	painting = 1,
	id = 150890,
	picture = "0",
	castCV = "skill",
	desc = "鞭炮",
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
			type = "BattleSkillFire",
			casterAniEffect = "",
			target_choise = "TargetNil",
			targetAniEffect = "",
			arg_list = {
				weapon_id = 167281
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			target_choise = "TargetPlayerVanguardFleet",
			targetAniEffect = "",
			arg_list = {
				buff_id = 150893
			}
		}
	}
}
