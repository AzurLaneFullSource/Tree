return {
	uiEffect = "",
	name = "2025狮UR活动 塞壬支援 B图",
	cd = 0,
	painting = 0,
	id = 201390,
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
					monsterTemplateID = 16735514,
					sickness = 1,
					corrdinate = {
						-10,
						0,
						50
					},
					buffList = {
						201392,
						8001,
						8007
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
							switchParam = 300,
							switchTo = 0,
							index = 1,
							switchType = 1,
							setAI = 70288
						}
					}
				}
			}
		}
	}
}
