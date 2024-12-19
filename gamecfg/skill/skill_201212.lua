return {
	id = 201212,
	name = "2024鲁梅活动 BOSS星之兽召唤小怪 SP",
	cd = 0,
	painting = 0,
	effect_list = {
		{
			target_choise = "TargetNil",
			type = "BattleSkillSummon",
			arg_list = {
				delay = 0,
				spawnData = {
					monsterTemplateID = 16694302,
					sickness = 0.1,
					corrdinate = {
						-15,
						0,
						74
					},
					buffList = {
						201192,
						8001,
						8007,
						8909
					},
					phase = {
						{
							switchType = 1,
							dive = "STATE_RAID",
							switchTo = 1,
							index = 0,
							switchParam = 1.5,
							setAI = 20005
						},
						{
							switchParam = 0.5,
							dive = "STATE_FLOAT",
							switchTo = 2,
							index = 1,
							switchType = 1,
							setAI = 20006,
							addBuff = {
								201213
							}
						},
						{
							index = 2,
							switchType = 1,
							switchTo = 3,
							switchParam = 5,
							addWeapon = {
								3234007
							}
						},
						{
							index = 3,
							switchType = 1,
							switchTo = 4,
							switchParam = 8.5,
							addWeapon = {
								3234008
							}
						},
						{
							switchParam = 300,
							dive = "STATE_RAID",
							switchTo = 1,
							index = 4,
							switchType = 1,
							setAI = 20005,
							removeBuff = {
								201213,
								8007
							},
							addWeapon = {
								3234009
							},
							removeWeapon = {
								3234007,
								3234008
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
					monsterTemplateID = 16694302,
					sickness = 0.1,
					corrdinate = {
						-20,
						0,
						62
					},
					buffList = {
						201192,
						8001,
						8007,
						8909
					},
					phase = {
						{
							switchType = 1,
							dive = "STATE_RAID",
							switchTo = 1,
							index = 0,
							switchParam = 1.5,
							setAI = 20005
						},
						{
							switchParam = 1,
							dive = "STATE_FLOAT",
							switchTo = 2,
							index = 1,
							switchType = 1,
							setAI = 20006,
							addBuff = {
								201213
							}
						},
						{
							index = 2,
							switchType = 1,
							switchTo = 3,
							switchParam = 5,
							addWeapon = {
								3234007
							}
						},
						{
							index = 3,
							switchType = 1,
							switchTo = 4,
							switchParam = 8.5,
							addWeapon = {
								3234008
							}
						},
						{
							switchParam = 300,
							dive = "STATE_RAID",
							switchTo = 1,
							index = 4,
							switchType = 1,
							setAI = 20005,
							removeBuff = {
								201213,
								8007
							},
							addWeapon = {
								3234009
							},
							removeWeapon = {
								3234007,
								3234008
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
					monsterTemplateID = 16694302,
					sickness = 0.1,
					corrdinate = {
						-20,
						0,
						38
					},
					buffList = {
						201192,
						8001,
						8007,
						8909
					},
					phase = {
						{
							switchType = 1,
							dive = "STATE_RAID",
							switchTo = 1,
							index = 0,
							switchParam = 1.5,
							setAI = 20005
						},
						{
							switchParam = 1,
							dive = "STATE_FLOAT",
							switchTo = 2,
							index = 1,
							switchType = 1,
							setAI = 20006,
							addBuff = {
								201213
							}
						},
						{
							index = 2,
							switchType = 1,
							switchTo = 3,
							switchParam = 5,
							addWeapon = {
								3234007
							}
						},
						{
							index = 3,
							switchType = 1,
							switchTo = 4,
							switchParam = 8.5,
							addWeapon = {
								3234008
							}
						},
						{
							switchParam = 300,
							dive = "STATE_RAID",
							switchTo = 1,
							index = 4,
							switchType = 1,
							setAI = 20005,
							removeBuff = {
								201213,
								8007
							},
							addWeapon = {
								3234009
							},
							removeWeapon = {
								3234007,
								3234008
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
					monsterTemplateID = 16694302,
					sickness = 0.1,
					corrdinate = {
						-15,
						0,
						26
					},
					buffList = {
						201192,
						8001,
						8007,
						8909
					},
					phase = {
						{
							switchType = 1,
							dive = "STATE_RAID",
							switchTo = 1,
							index = 0,
							switchParam = 1.5,
							setAI = 20005
						},
						{
							switchParam = 0.5,
							dive = "STATE_FLOAT",
							switchTo = 2,
							index = 1,
							switchType = 1,
							setAI = 20006,
							addBuff = {
								201213
							}
						},
						{
							index = 2,
							switchType = 1,
							switchTo = 3,
							switchParam = 5,
							addWeapon = {
								3234007
							}
						},
						{
							index = 3,
							switchType = 1,
							switchTo = 4,
							switchParam = 8.5,
							addWeapon = {
								3234008
							}
						},
						{
							switchParam = 300,
							dive = "STATE_RAID",
							switchTo = 1,
							index = 4,
							switchType = 1,
							setAI = 20005,
							removeBuff = {
								201213,
								8007
							},
							addWeapon = {
								3234009
							},
							removeWeapon = {
								3234007,
								3234008
							}
						}
					}
				}
			}
		}
	}
}
