return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 1,
	id = 801401,
	picture = "0",
	castCV = "skill",
	desc = "辉光",
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
			target_choise = "TargetPlayerMainFleet",
			targetAniEffect = "",
			arg_list = {
				buff_id = 801402
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			target_choise = "TargetHarmRandom",
			targetAniEffect = "",
			arg_list = {
				buff_id = 801403
			}
		}
	}
}
