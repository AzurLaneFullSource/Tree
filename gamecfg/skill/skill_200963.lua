return {
	uiEffect = "",
	name = "2024幼儿园活动 轻巡石膏喵 召唤雕像4",
	cd = 0,
	painting = 0,
	id = 200963,
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
					deadFX = "youeryuan_bomb",
					monsterTemplateID = 16624404,
					sickness = 0.5,
					corrdinate = {
						-15,
						0,
						75
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
								3164411,
								3164412
							}
						},
						{
							index = 2,
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
					deadFX = "youeryuan_bomb",
					monsterTemplateID = 16624404,
					sickness = 0.5,
					corrdinate = {
						-15,
						0,
						25
					},
					phase = {
						{
							switchParam = 2.5,
							switchTo = 1,
							index = 0,
							switchType = 1,
							setAI = 20006
						},
						{
							index = 1,
							switchType = 1,
							switchTo = 2,
							switchParam = 8,
							addWeapon = {
								3164411,
								3164412
							}
						},
						{
							index = 2,
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
