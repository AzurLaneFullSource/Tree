return {
	uiEffect = "",
	name = "2025拉斐尔活动EX 普通 召唤小怪",
	cd = 0,
	painting = 0,
	id = 201293,
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
					monsterTemplateID = 16705011,
					sickness = 0.5,
					corrdinate = {
						-25,
						0,
						65
					},
					buffList = {
						200826
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
							switchParam = 2,
							switchTo = 2,
							index = 1,
							switchType = 1,
							setAI = 20005
						},
						{
							switchType = 1,
							switchTo = 3,
							index = 2,
							switchParam = 3.5,
							setAI = 20006,
							addWeapon = {
								3245005
							}
						},
						{
							index = 3,
							switchParam = 1.5,
							switchTo = 4,
							switchType = 1,
							addWeapon = {
								3245006
							},
							removeWeapon = {}
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
					monsterTemplateID = 16705011,
					sickness = 0.5,
					corrdinate = {
						-25,
						0,
						35
					},
					buffList = {
						200826
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
							switchParam = 2,
							switchTo = 2,
							index = 1,
							switchType = 1,
							setAI = 20005
						},
						{
							switchType = 1,
							switchTo = 3,
							index = 2,
							switchParam = 3.5,
							setAI = 20006,
							addWeapon = {
								3245005
							}
						},
						{
							index = 3,
							switchParam = 1.5,
							switchTo = 4,
							switchType = 1,
							addWeapon = {
								3245006
							},
							removeWeapon = {}
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
