return {
	uiEffect = "",
	name = "2025狮UR活动 EX 困难 狮子召唤物",
	cd = 0,
	painting = 0,
	id = 201372,
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
					deadFX = "shanshuo",
					monsterTemplateID = 16735012,
					sickness = 0.5,
					corrdinate = {
						-15,
						0,
						78
					},
					buffList = {
						200826,
						201350
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
							switchParam = 10,
							addWeapon = {
								3275210
							}
						},
						{
							index = 2,
							switchType = 1,
							switchTo = 3,
							switchParam = 1.5,
							removeWeapon = {
								3275210
							}
						},
						{
							switchType = 1,
							switchTo = 4,
							index = 3,
							switchParam = 2,
							setAI = 80000,
							addWeapon = {
								3275212
							}
						},
						{
							index = 4,
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
					deadFX = "shanshuo",
					monsterTemplateID = 16735012,
					sickness = 0.5,
					corrdinate = {
						-15,
						0,
						28
					},
					buffList = {
						200826,
						201350
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
							switchParam = 10,
							addWeapon = {
								3275211
							}
						},
						{
							index = 2,
							switchType = 1,
							switchTo = 3,
							switchParam = 1.5,
							removeWeapon = {
								3275211
							}
						},
						{
							switchType = 1,
							switchTo = 4,
							index = 3,
							switchParam = 2,
							setAI = 80000,
							addWeapon = {
								3275212
							}
						},
						{
							index = 4,
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
