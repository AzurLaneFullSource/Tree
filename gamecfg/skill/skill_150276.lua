return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 0,
	id = 150276,
	picture = "0",
	castCV = "",
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
			type = "BattleSkillSummon",
			casterAniEffect = "",
			target_choise = "TargetNil",
			targetAniEffect = "",
			arg_list = {
				spawnData = {
					monsterTemplateID = 50081,
					sickness = 0.1,
					buffList = {
						150278
					},
					phase = {
						{
							index = 0,
							setAI = 20006
						}
					}
				}
			}
		},
		{
			type = "BattleSkillSummon",
			casterAniEffect = "",
			target_choise = "TargetNil",
			targetAniEffect = "",
			arg_list = {
				spawnData = {
					monsterTemplateID = 50081,
					sickness = 0.1,
					buffList = {
						150279
					},
					phase = {
						{
							index = 0,
							setAI = 20006
						}
					}
				}
			}
		}
	}
}
