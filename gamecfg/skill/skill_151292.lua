return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 1,
	id = 151292,
	picture = "0",
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
			targetAniEffect = "",
			target_choise = {
				"TargetAllHelp",
				"TargetPlayerVanguardFleet",
				"TargetNationality"
			},
			arg_list = {
				buff_id = 151294,
				nationality = 2
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			target_choise = "TargetHarmRandom",
			targetAniEffect = "",
			arg_list = {
				buff_id = 151299
			}
		}
	}
}
