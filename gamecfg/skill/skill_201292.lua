return {
	uiEffect = "",
	name = "2025拉斐尔活动D2 代行者VII「Pulverization」 召唤小怪",
	cd = 0,
	painting = 0,
	id = 201292,
	picture = "0",
	aniEffect = "",
	desc = "",
	effect_list = {
		{
			target_choise = "TargetNil",
			type = "BattleSkillSummon",
			arg_list = {
				delay = 0,
				spawnData = {
					monsterTemplateID = 16703304,
					sickness = 0.5,
					corrdinate = {
						-15,
						0,
						72
					},
					buffList = {
						200280
					},
					phase = {
						{
							switchParam = 0.5,
							switchTo = 1,
							index = 0,
							switchType = 1,
							setAI = 20006
						},
						{
							index = 1,
							switchType = 1,
							switchTo = 2,
							switchParam = 4,
							addWeapon = {
								3243101
							}
						},
						{
							switchType = 1,
							switchTo = 3,
							index = 2,
							switchParam = 40,
							setAI = 70149,
							addWeapon = {
								3243102
							},
							removeWeapon = {
								3243101
							}
						},
						{
							index = 3,
							switchType = 1,
							switchTo = 1,
							switchParam = 300,
							addBuff = {
								200440
							}
						}
					}
				}
			}
		},
		{
			target_choise = "TargetNil",
			type = "BattleSkillSummon",
			arg_list = {
				delay = 0,
				spawnData = {
					monsterTemplateID = 16703304,
					sickness = 0.5,
					corrdinate = {
						-15,
						0,
						28
					},
					buffList = {
						200280
					},
					phase = {
						{
							switchParam = 0.5,
							switchTo = 1,
							index = 0,
							switchType = 1,
							setAI = 20006
						},
						{
							index = 1,
							switchType = 1,
							switchTo = 2,
							switchParam = 4,
							addWeapon = {
								3243101
							}
						},
						{
							switchType = 1,
							switchTo = 3,
							index = 2,
							switchParam = 40,
							setAI = 70150,
							addWeapon = {
								3243102
							},
							removeWeapon = {
								3243101
							}
						},
						{
							index = 3,
							switchType = 1,
							switchTo = 1,
							switchParam = 300,
							addBuff = {
								200440
							}
						}
					}
				}
			}
		}
	}
}
