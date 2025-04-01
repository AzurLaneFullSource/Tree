return {
	uiEffect = "",
	name = "2025愚人节 剧情战",
	cd = 0,
	painting = 0,
	id = 201351,
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
					delay = 0,
					monsterTemplateID = 13400013,
					sickness = 1,
					corrdinate = {
						-50,
						0,
						55
					},
					buffList = {},
					phase = {
						{
							switchParam = 5,
							switchTo = 1,
							index = 0,
							switchType = 1,
							setAI = 20006
						},
						{
							index = 1,
							switchType = 1,
							switchTo = 0,
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
