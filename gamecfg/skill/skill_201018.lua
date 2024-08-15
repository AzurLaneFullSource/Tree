return {
	uiEffect = "",
	name = "2024匹兹堡活动 剧情战 我方导弹船",
	cd = 0,
	painting = 0,
	id = 201018,
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
					monsterTemplateID = 16646304,
					buffList = {},
					corrdinate = {
						-98,
						0,
						78
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
							switchParam = 3,
							switchTo = 2,
							index = 1,
							switchType = 1,
							setAI = 70265
						},
						{
							index = 2,
							switchType = 1,
							switchTo = 3,
							switchParam = 0.5,
							addWeapon = {
								3186001
							}
						},
						{
							index = 3,
							switchType = 1,
							switchTo = 0,
							switchParam = 300,
							addWeapon = {
								3186002
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
					monsterTemplateID = 16646304,
					buffList = {},
					corrdinate = {
						-98,
						0,
						55
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
							switchParam = 3,
							switchTo = 2,
							index = 1,
							switchType = 1,
							setAI = 70265
						},
						{
							index = 2,
							switchType = 1,
							switchTo = 3,
							switchParam = 2.5,
							addWeapon = {
								3186001
							}
						},
						{
							index = 3,
							switchType = 1,
							switchTo = 0,
							switchParam = 300,
							addWeapon = {
								3186002
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
					monsterTemplateID = 16646304,
					buffList = {},
					corrdinate = {
						-98,
						0,
						32
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
							switchParam = 3,
							switchTo = 2,
							index = 1,
							switchType = 1,
							setAI = 70265
						},
						{
							index = 2,
							switchType = 1,
							switchTo = 3,
							switchParam = 4.5,
							addWeapon = {
								3186001
							}
						},
						{
							index = 3,
							switchType = 1,
							switchTo = 0,
							switchParam = 300,
							addWeapon = {
								3186002
							}
						}
					}
				}
			}
		}
	}
}
