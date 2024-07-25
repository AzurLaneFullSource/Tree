return {
	uiEffect = "",
	name = "",
	cd = 0,
	id = 801331,
	picture = "1",
	desc = "",
	effect_list = {
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			targetAniEffect = "",
			target_choise = {
				"TargetSelf"
			},
			arg_list = {
				buff_id = 801333
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
				buff_id = 801334,
				ship_tag_list = {
					"KasumiHA"
				}
			}
		}
	}
}
