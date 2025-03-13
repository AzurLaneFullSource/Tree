return {
	uiEffect = "",
	name = "特型领舰",
	cd = 0,
	painting = 1,
	id = 1010960,
	picture = "0",
	castCV = "skill",
	desc = "特型领舰",
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
				"TargetShipType"
			},
			arg_list = {
				buff_id = 1010961,
				ship_type_list = {
					1,
					20,
					21
				}
			}
		}
	}
}
