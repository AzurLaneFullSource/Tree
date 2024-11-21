return {
	uiEffect = "",
	name = "风纪整肃",
	cd = 0,
	castCV = "skill",
	id = 111270,
	picture = "0",
	desc = "风纪整肃",
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
			target_choise = "TargetPlayerVanguardFleet",
			targetAniEffect = "",
			arg_list = {
				buff_id = 111271
			}
		}
	}
}
