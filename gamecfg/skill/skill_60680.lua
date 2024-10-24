return {
	uiEffect = "",
	name = "",
	cd = 0,
	painting = 0,
	id = 60680,
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
			type = "BattleSkillSummon",
			casterAniEffect = "",
			target_choise = "TargetNil",
			targetAniEffect = "",
			arg_list = {
				spawnData = {
					monsterTemplateID = 50082,
					sickness = 0.1,
					corrdinate = {
						-50,
						0,
						60
					},
					buffList = {
						60681
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
