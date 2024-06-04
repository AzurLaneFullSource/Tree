return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 1,
	id = 150000,
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
			target_choise = "TargetSelf",
			targetAniEffect = "",
			arg_list = {
				buff_id = 150001
			}
		},
		{
			target_choise = "TargetSelf",
			type = "BattleSkillEditFleetAttr",
			arg_list = {
				value = 6,
				attr = "shenpanzhijian"
			}
		},
		{
			type = "BattleSkillAddBuff",
			casterAniEffect = "",
			target_choise = "TargetSelf",
			targetAniEffect = "",
			arg_list = {
				buff_id = 150002
			}
		}
	}
}
