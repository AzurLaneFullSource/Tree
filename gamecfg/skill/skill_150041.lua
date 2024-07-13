return {
	uiEffect = "",
	name = "",
	cd = 0,
	id = 150041,
	picture = "1",
	desc = "",
	effect_list = {
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			targetAniEffect = "",
			target_choise = {
				"TargetAllHelp",
				"TargetShipTag"
			},
			arg_list = {
				buff_id = 150043,
				ship_tag_list = {
					"AlsaceHA"
				}
			}
		},
		{
			type = "BattleSkillEditTag",
			casterAniEffect = "",
			target_choise = "TargetSelf",
			targetAniEffect = "",
			arg_list = {
				tag = "AlsaceSkill_lowhp",
				operation = 1
			}
		}
	}
}
