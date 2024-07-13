return {
	uiEffect = "",
	name = "我是NO.1！",
	cd = 0,
	painting = 1,
	id = 10090,
	picture = "0",
	castCV = "skill",
	desc = "我是NO.1！",
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
			target_choise = "TargetAllHelp",
			targetAniEffect = "",
			arg_list = {
				buff_id = 10091
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			targetAniEffect = "",
			target_choise = {
				"TargetAllHelp",
				"TargetShipTag"
			},
			arg_list = {
				buff_id = 10092,
				ship_tag_list = {
					"3D5SP"
				}
			}
		}
	}
}
