return {
	map_id = 10001,
	id = 1896004,
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
									switchType = 1,
									switchTo = 4,
									index = 3,
									switchParam = 9.5,
									setAI = 70252,
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
									switchType = 1,
									switchTo = 6,
									switchParam = 8,
									addWeapon = {
										3243208
									}
								},
								{
									switchType = 1,
									switchTo = 7,
									index = 6,
									switchParam = 2,
									setAI = 70188,
									addBuff = {
										201303
									}
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
									switchType = 1,
									switchTo = 9,
									index = 8,
									switchParam = 10,
									setAI = 70283,
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
									switchTo = 11,
									switchParam = 9,
									addWeapon = {
										3243211
									}
								},
								{
									index = 11,
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
						id = "FANLONGNEIDESHENGUANG28-1"
					}
				},
				{
					triggerType = 1,
					waveIndex = 202,
					preWaves = {
						501
					},
					triggerParams = {
						timeout = 30
					}
				},
				{
					triggerType = 3,
					waveIndex = 502,
					preWaves = {
						202
					},
					triggerParams = {
						id = "FANLONGNEIDESHENGUANG28-2"
					}
				},
				{
					triggerType = 8,
					key = true,
					waveIndex = 900,
					preWaves = {
						502
					},
					triggerParams = {}
				}
			}
		}
	},
	fleet_prefab = {
		vanguard_unitList = {
			{
				tmpID = 900489,
				configId = 900489,
				skinId = 9703060,
				id = 1,
				level = 120,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 400,
					air = 0,
					antiaircraft = 200,
					torpedo = 400,
					durability = 100000,
					reload = 600,
					armor = 0,
					dodge = 30,
					speed = 30,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 801592,
						level = 10
					}
				}
			},
			{
				tmpID = 900490,
				configId = 900490,
				skinId = 9703010,
				id = 2,
				level = 120,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 400,
					air = 0,
					antiaircraft = 200,
					torpedo = 400,
					durability = 100000,
					reload = 600,
					armor = 0,
					dodge = 30,
					speed = 30,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 800532,
						level = 10
					}
				}
			}
		},
		main_unitList = {
			{
				tmpID = 900492,
				configId = 900492,
				skinId = 9705080,
				id = 1,
				level = 120,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 600,
					air = 0,
					antiaircraft = 250,
					torpedo = 0,
					durability = 50000,
					reload = 600,
					armor = 0,
					dodge = 50,
					speed = 20,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 801632,
						level = 10
					},
					{
						id = 2,
						level = 10
					},
					{
						id = 340,
						level = 10
					}
				}
			},
			{
				tmpID = 900491,
				configId = 900491,
				skinId = 9705070,
				id = 2,
				level = 120,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 600,
					air = 0,
					antiaircraft = 250,
					torpedo = 0,
					durability = 50000,
					reload = 600,
					armor = 0,
					dodge = 50,
					speed = 20,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 801482,
						level = 10
					},
					{
						id = 2,
						level = 10
					},
					{
						id = 340,
						level = 10
					}
				}
			}
		}
	}
}
