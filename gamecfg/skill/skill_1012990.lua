return {
	uiEffect = "",
	name = "塔什干专武",
	cd = 0,
	painting = 1,
	id = 1012990,
	picture = "0",
	castCV = "",
	desc = "阵营中北联驱逐炮武器效率提高",
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
				"TargetNationalityFriendly",
				"TargetShipType"
			},
			arg_list = {
				buff_id = 1012992,
				nationality = 7,
				ship_type_list = {
					1,
					20,
					21
				}
			}
		}
	}
}
