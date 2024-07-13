return {
	uiEffect = "",
	name = "2024幼儿园活动 剧情战召唤潜艇",
	cd = 0,
	painting = 0,
	id = 200965,
	picture = "0",
	aniEffect = "",
	desc = "",
	effect_list = {
		{
			type = "BattleSkillSummon",
			casterAniEffect = "",
			target_choise = "TargetNil",
			targetAniEffect = "",
			arg_list = {
				delay = 0,
				spawnData = {
					monsterTemplateID = 16625405,
					buffList = {},
					corrdinate = {
						-88,
						0,
						58
					},
					phase = {
						{
							switchType = 1,
							switchTo = 1,
							index = 0,
							switchParam = 30,
							setAI = 70263,
							addWeapon = {
								45453,
								25313
							}
						},
						{
							switchParam = -120,
							dive = "STATE_RETREAT",
							switchTo = 2,
							index = 1,
							switchType = 4
						},
						{
							index = 2,
							retreat = true
						}
					}
				}
			}
		}
	}
}
