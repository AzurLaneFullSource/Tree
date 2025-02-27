return {
	uiEffect = "",
	name = "2025拉斐尔活动 神光之网",
	cd = 0,
	painting = 0,
	id = 201271,
	picture = "0",
	aniEffect = "",
	desc = "",
	effect_list = {
		{
			target_choise = "TargetNil",
			type = "BattleSkillSummon",
			arg_list = {
				spawnData = {
					deadFX = "none",
					monsterTemplateID = 16706001,
					delay = 0,
					corrdinate = {
						-35,
						0,
						55
					},
					buffList = {
						201272
					},
					phase = {
						{
							index = 0,
							switchType = 1,
							switchTo = 1,
							switchParam = 10
						},
						{
							index = 1,
							switchType = 1,
							switchTo = 0,
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
