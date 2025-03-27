return {
	uiEffect = "",
	name = "2025医院活动 探索计数 4层效果 旋涡",
	cd = 0,
	painting = 0,
	id = 201346,
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
					monsterTemplateID = 16714004,
					sickness = 0.1,
					corrdinate = {
						20,
						0,
						55
					},
					buffList = {
						201348,
						201350
					},
					phase = {
						{
							index = 0,
							switchType = 1,
							switchTo = 1,
							switchParam = 0.5
						},
						{
							switchType = 1,
							switchTo = 0,
							index = 1,
							switchParam = 300,
							setAI = 70286,
							addBuff = {}
						}
					}
				}
			}
		}
	}
}
