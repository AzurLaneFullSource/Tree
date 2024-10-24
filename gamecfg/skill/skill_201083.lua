return {
	id = 201083,
	name = "2024天城航母活动B3 赤城meta 灵体召唤",
	cd = 0,
	painting = 0,
	effect_list = {
		{
			target_choise = "TargetNil",
			type = "BattleSkillSummon",
			arg_list = {
				delay = 0,
				spawnData = {
					monsterTemplateID = 16661304,
					buffList = {
						201084
					},
					corrdinate = {
						-15,
						0,
						70
					},
					phase = {
						{
							switchParam = 3.5,
							switchTo = 1,
							index = 0,
							switchType = 1,
							setAI = 70267
						},
						{
							index = 1,
							switchType = 1,
							switchTo = 0,
							switchParam = 300,
							addWeapon = {
								3201202,
								3201203,
								3201204,
								3201205
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
					monsterTemplateID = 16661305,
					buffList = {
						201084
					},
					corrdinate = {
						-15,
						0,
						30
					},
					phase = {
						{
							switchParam = 1.5,
							switchTo = 1,
							index = 0,
							switchType = 1,
							setAI = 70268
						},
						{
							index = 1,
							switchType = 1,
							switchTo = 0,
							switchParam = 300,
							addWeapon = {
								3201206,
								3201207,
								3201208,
								3201209
							}
						}
					}
				}
			}
		}
	}
}
