return {
	id = 296270,
	stages = {
		{
			stageIndex = 1,
			failCondition = 1,
			timeCount = 80,
			passCondition = 1,
			backGroundStageID = 1,
			totalArea = {
				-70,
				20,
				90,
				70
			},
			playerArea = {
				-70,
				20,
				37,
				68
			},
			enemyArea = {},
			fleetCorrdinate = {
				-80,
				0,
				75
			},
			waves = {
				{
					triggerType = 1,
					waveIndex = 100,
					preWaves = {},
					triggerParams = {
						timeout = 0.5
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 101,
					conditionType = 1,
					preWaves = {
						100
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 295270,
							delay = 0,
							score = 0,
							sickness = 0.1,
							corrdinate = {
								-10,
								0,
								53
							},
							buffList = {
								201309
							},
							bossData = {
								hpBarNum = 100,
								icon = ""
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
									switchType = 1,
									switchTo = 2,
									index = 1,
									switchParam = 12,
									setAI = 70252,
									addWeapon = {
										2980054,
										2980059
									}
								},
								{
									index = 2,
									switchType = 1,
									switchTo = 3,
									switchParam = 2,
									addWeapon = {
										2980049
									}
								},
								{
									index = 3,
									switchParam = 10,
									switchTo = 4,
									switchType = 1,
									addWeapon = {
										2980064,
										2980069,
										2980074
									},
									removeWeapon = {
										2980054,
										2980059
									}
								},
								{
									index = 4,
									switchType = 1,
									switchTo = 5,
									switchParam = 2,
									removeWeapon = {
										2980064,
										2980069,
										2980074
									}
								},
								{
									index = 5,
									switchType = 1,
									switchTo = 6,
									switchParam = 2,
									addWeapon = {
										2980084
									}
								},
								{
									index = 6,
									switchType = 1,
									switchTo = 7,
									switchParam = 3,
									addWeapon = {
										2980089
									}
								},
								{
									index = 7,
									switchType = 1,
									switchTo = 8,
									switchParam = 9.5,
									addWeapon = {
										2980094
									}
								},
								{
									index = 8,
									switchType = 1,
									switchTo = 9,
									switchParam = 2,
									removeWeapon = {
										2980084,
										2980089,
										2980094
									}
								},
								{
									index = 9,
									switchType = 1,
									switchTo = 10,
									switchParam = 15,
									addWeapon = {
										2980074,
										2980099,
										2980104
									}
								},
								{
									switchType = 1,
									switchTo = 11,
									index = 10,
									switchParam = 2,
									setAI = 75016,
									removeWeapon = {
										2980049,
										2980074,
										2980099,
										2980104
									}
								},
								{
									index = 11,
									switchType = 1,
									switchTo = 12,
									switchParam = 3.5,
									addWeapon = {
										2980109
									}
								},
								{
									index = 12,
									switchType = 1,
									switchTo = 1,
									switchParam = 300,
									addWeapon = {
										2980114
									}
								}
							}
						}
					},
					airFighter = {
						{
							interval = 6,
							onceNumber = 3,
							formation = 10006,
							delay = 2,
							templateID = 2980004,
							totalNumber = 6,
							weaponID = {
								2980019,
								2980024
							},
							attr = {
								airPower = 40,
								maxHP = 15,
								attackRating = 23
							}
						},
						{
							interval = 6,
							onceNumber = 3,
							formation = 10006,
							delay = 4,
							templateID = 2980009,
							totalNumber = 6,
							weaponID = {
								2980029,
								2980034
							},
							attr = {
								airPower = 40,
								maxHP = 15,
								attackRating = 23
							}
						},
						{
							interval = 4,
							onceNumber = 4,
							formation = 10006,
							delay = 2,
							templateID = 2980014,
							totalNumber = 12,
							weaponID = {
								2980039,
								2980044
							},
							attr = {
								airPower = 40,
								maxHP = 15,
								attackRating = 23
							}
						},
						{
							interval = 6,
							onceNumber = 3,
							formation = 10006,
							delay = 26,
							templateID = 2980004,
							totalNumber = 6,
							weaponID = {
								2980019,
								2980024
							},
							attr = {
								airPower = 40,
								maxHP = 15,
								attackRating = 23
							}
						},
						{
							interval = 6,
							onceNumber = 3,
							formation = 10006,
							delay = 28,
							templateID = 2980009,
							totalNumber = 6,
							weaponID = {
								2980029,
								2980034
							},
							attr = {
								airPower = 40,
								maxHP = 15,
								attackRating = 23
							}
						},
						{
							interval = 4,
							onceNumber = 4,
							formation = 10006,
							delay = 26,
							templateID = 2980014,
							totalNumber = 12,
							weaponID = {
								2980039,
								2980044
							},
							attr = {
								airPower = 40,
								maxHP = 15,
								attackRating = 23
							}
						},
						{
							interval = 6,
							onceNumber = 3,
							formation = 10006,
							delay = 50,
							templateID = 2980004,
							totalNumber = 6,
							weaponID = {
								2980019,
								2980024
							},
							attr = {
								airPower = 40,
								maxHP = 15,
								attackRating = 23
							}
						},
						{
							interval = 6,
							onceNumber = 3,
							formation = 10006,
							delay = 52,
							templateID = 2980009,
							totalNumber = 6,
							weaponID = {
								2980029,
								2980034
							},
							attr = {
								airPower = 40,
								maxHP = 15,
								attackRating = 23
							}
						},
						{
							interval = 4,
							onceNumber = 4,
							formation = 10006,
							delay = 50,
							templateID = 2980014,
							totalNumber = 12,
							weaponID = {
								2980039,
								2980044
							},
							attr = {
								airPower = 40,
								maxHP = 15,
								attackRating = 23
							}
						}
					}
				},
				{
					triggerType = 8,
					key = true,
					waveIndex = 900,
					preWaves = {
						101
					},
					triggerParams = {}
				}
			}
		}
	},
	fleet_prefab = {}
}
