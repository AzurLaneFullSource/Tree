return {
	uiEffect = "",
	name = "2024匹兹堡活动 EX挑战 我方召唤导弹船",
	cd = 0,
	painting = 0,
	id = 201008,
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
					monsterTemplateID = 16645005,
					damageSrcWarp = true,
					buffList = {
						201015
					},
					corrdinate = {
						-98,
						0,
						50
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
							switchParam = 300,
							switchTo = 0,
							switchType = 1,
							addBuff = {
								201012
							},
							addWeapon = {
								3185001,
								3185002
							}
						}
					}
				}
			}
		}
	}
}
