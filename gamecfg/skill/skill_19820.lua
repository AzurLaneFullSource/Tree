return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 1,
	id = 19820,
	picture = "0",
	castCV = "skill",
	desc = "",
	effect_list = {
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			target_choise = "TargetShipTag",
			targetAniEffect = "",
			arg_list = {
				buff_id = 19821,
				delay = 1.5,
				ship_tag_list = {
					"naximofubeilianjiansu"
				}
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			target_choise = "TargetHarmRandomByWeight",
			targetAniEffect = "",
			arg_list = {
				buff_id = 19823
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			target_choise = "TargetSelf",
			targetAniEffect = "",
			arg_list = {
				buff_id = 19824
			}
		}
	}
}
