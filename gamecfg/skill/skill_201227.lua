return {
	uiEffect = "",
	name = "2024鲁梅活动 EX 希佩尔支援",
	cd = 0,
	painting = 0,
	id = 201221,
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
					deadFX = "none",
					monsterTemplateID = 16695003,
					sickness = 0.1,
					corrdinate = {
						-65,
						0,
						50
					},
					buffList = {},
					phase = {
						{
							switchParam = 1,
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
							addBuff = {
								201228
							}
						},
						{
							switchParam = 13,
							switchTo = 3,
							index = 2,
							switchType = 1,
							setAI = 70282
						},
						{
							switchParam = 1,
							switchTo = 4,
							index = 3,
							switchType = 1,
							setAI = 20006
						},
						{
							index = 4,
							switchType = 1,
							switchTo = 1,
							switchParam = 300,
							addBuff = {
								201229
							}
						}
					}
				}
			}
		}
	}
}
