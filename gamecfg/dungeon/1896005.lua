return {
	map_id = 10001,
	id = 1896005,
	stages = {
		{
			stageIndex = 1,
			failCondition = 1,
			timeCount = 300,
			passCondition = 1,
			backGroundStageID = 1,
			totalArea = {
				-80,
				20,
				90,
				70
			},
			playerArea = {
				-80,
				20,
				45,
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
					waveIndex = 101,
					conditionType = 1,
					preWaves = {
						100
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16707104,
							delay = 0,
							corrdinate = {
								-10,
								0,
								50
							},
							buffList = {
								200280,
								200825,
								201238,
								201240,
								201306
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
									index = 1,
									switchType = 1,
									switchTo = 2,
									switchParam = 2,
									addWeapon = {
										3243201,
										3243202
									}
								},
								{
									index = 2,
									switchType = 1,
									switchTo = 3,
									switchParam = 6,
									addWeapon = {
										3243203,
										3243204
									}
								},
								{
									index = 3,
									switchType = 1,
									switchTo = 4,
									switchParam = 9.5,
									addBuff = {
										201303
									},
									addWeapon = {
										3243205,
										3243206,
										3243207,
										3243208
									},
									removeWeapon = {
										3243203,
										3243204
									}
								},
								{
									index = 4,
									switchType = 1,
									switchTo = 5,
									switchParam = 0.5,
									removeWeapon = {
										3243208
									}
								},
								{
									index = 5,
									switchParam = 8,
									switchTo = 6,
									switchType = 1,
									addBuff = {
										201303
									},
									addWeapon = {
										3243208
									}
								},
								{
									index = 6,
									switchType = 1,
									switchTo = 7,
									switchParam = 2
								},
								{
									index = 7,
									switchType = 1,
									switchTo = 8,
									switchParam = 1,
									removeWeapon = {
										3243205,
										3243206,
										3243207,
										3243208
									}
								},
								{
									index = 8,
									switchParam = 10,
									switchTo = 9,
									switchType = 1,
									addBuff = {
										201303
									},
									addWeapon = {
										3243209,
										3243210,
										3243211
									}
								},
								{
									index = 9,
									switchType = 1,
									switchTo = 10,
									switchParam = 1,
									removeWeapon = {
										3243211
									}
								},
								{
									index = 10,
									switchType = 1,
									switchTo = 2,
									switchParam = 1.5,
									removeWeapon = {
										3243209,
										3243210,
										3243211
									}
								}
							}
						}
					}
				},
				{
					triggerType = 1,
					waveIndex = 201,
					preWaves = {
						100
					},
					triggerParams = {
						timeout = 0.5
					}
				},
				{
					triggerType = 3,
					waveIndex = 501,
					preWaves = {
						201
					},
					triggerParams = {
						id = "FANLONGNEIDESHENGUANG29-1"
					}
				},
				{
					triggerType = 1,
					waveIndex = 202,
					preWaves = {
						501
					},
					triggerParams = {
						timeout = 10
					}
				},
				{
					triggerType = 3,
					waveIndex = 502,
					preWaves = {
						202
					},
					triggerParams = {
						id = "FANLONGNEIDESHENGUANG29-2"
					}
				},
				{
					triggerType = 1,
					waveIndex = 203,
					preWaves = {
						502
					},
					triggerParams = {
						timeout = 13
					}
				},
				{
					triggerType = 3,
					waveIndex = 503,
					preWaves = {
						203
					},
					triggerParams = {
						id = "FANLONGNEIDESHENGUANG29-3"
					}
				},
				{
					triggerType = 1,
					waveIndex = 204,
					preWaves = {
						503
					},
					triggerParams = {
						timeout = 17
					}
				},
				{
					triggerType = 3,
					waveIndex = 504,
					preWaves = {
						204
					},
					triggerParams = {
						id = "FANLONGNEIDESHENGUANG29-4"
					}
				},
				{
					triggerType = 8,
					key = true,
					waveIndex = 900,
					preWaves = {
						504
					},
					triggerParams = {}
				}
			}
		}
	},
	fleet_prefab = {
		vanguard_unitList = {
			{
				tmpID = 900485,
				configId = 900485,
				skinId = 900485,
				id = 1,
				level = 120,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 500,
					air = 0,
					antiaircraft = 200,
					torpedo = 500,
					durability = 500000,
					reload = 600,
					armor = 0,
					dodge = 30,
					speed = 30,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 201300,
						level = 3
					},
					{
						id = 201307,
						level = 10
					}
				}
			}
		}
	}
}
