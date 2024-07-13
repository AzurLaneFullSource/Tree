return {
	uiEffect = "",
	name = "2024幼儿园活动 轻巡石膏喵 召唤雕像1",
	cd = 0,
	painting = 0,
	id = 200960,
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
					monsterTemplateID = 16624401,
					sickness = 0.5,
					corrdinate = {
						-24,
						0,
						68
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
								3164403,
								3164404
							}
						},
						{
							index = 2,
							switchType = 1,
							switchTo = 3,
							switchParam = 1,
							removeWeapon = {
								3164403
							}
						},
						{
							index = 3,
							switchType = 1,
							switchTo = 4,
							switchParam = 3.5,
							addWeapon = {
								3164403
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
					deadFX = "youeryuan_bomb",
					monsterTemplateID = 16624401,
					sickness = 0.5,
					corrdinate = {
						-24,
						0,
						32
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
								3164403,
								3164404
							}
						},
						{
							index = 2,
							switchType = 1,
							switchTo = 3,
							switchParam = 1,
							removeWeapon = {
								3164403
							}
						},
						{
							index = 3,
							switchType = 1,
							switchTo = 4,
							switchParam = 3.5,
							addWeapon = {
								3164403
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
