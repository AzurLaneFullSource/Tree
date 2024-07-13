return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 1,
	id = 19870,
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
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			target_choise = "TargetHarmFarthest",
			targetAniEffect = "",
			arg_list = {
				buff_id = 19871
			}
		},
		{
			type = "BattleSkillFire",
			casterAniEffect = "",
			target_choise = "TargetHarmFarthest",
			targetAniEffect = "",
			arg_list = {
				weapon_id = 61032
			}
		}
	}
}
