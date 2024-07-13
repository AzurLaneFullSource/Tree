return {
	uiEffect = "",
	name = "2024阿尔萨斯活动SP 连续召唤浮游炮发射激光",
	cd = 0,
	painting = 0,
	id = 200937,
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
					monsterTemplateID = 16614303,
					sickness = 0.5,
					corrdinate = {
						20,
						0,
						50
					},
					buffList = {
						200938
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
							switchParam = 2.5,
							addWeapon = {
								3154009
							}
						},
						{
							index = 2,
							switchParam = 300,
							switchTo = 1,
							switchType = 1,
							addBuff = {
								8001,
								8002
							},
							removeWeapon = {
								3154009
							}
						}
					}
				}
			}
		}
	}
}
