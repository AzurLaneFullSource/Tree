return {
	uiEffect = "",
	name = "2024幼儿园活动 剧情战 召唤雕像2",
	cd = 0,
	painting = 0,
	id = 200967,
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
					monsterTemplateID = 16625402,
					sickness = 0.5,
					corrdinate = {
						-32,
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
							switchParam = 2,
							addWeapon = {
								3164405
							}
						},
						{
							index = 2,
							switchType = 1,
							switchTo = 3,
							switchParam = 5,
							addWeapon = {
								3164406
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
					deadFX = "youeryuan_bomb",
					monsterTemplateID = 16625402,
					sickness = 0.5,
					corrdinate = {
						-32,
						0,
						25
					},
					phase = {
						{
							switchParam = 1.5,
							switchTo = 1,
							index = 0,
							switchType = 1,
							setAI = 20006
						},
						{
							index = 1,
							switchType = 1,
							switchTo = 2,
							switchParam = 1,
							addWeapon = {
								3164405
							}
						},
						{
							index = 2,
							switchType = 1,
							switchTo = 3,
							switchParam = 5,
							addWeapon = {
								3164406
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
