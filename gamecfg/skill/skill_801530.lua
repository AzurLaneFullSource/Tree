return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 1,
	id = 801530,
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
			targetAniEffect = "",
			target_choise = {
				"TargetAllHarm",
				"TargetShipTag"
			},
			arg_list = {
				buff_id = 801534,
				ship_tag_list = {
					"shufuzhiyan"
				}
			}
		}
	}
}
