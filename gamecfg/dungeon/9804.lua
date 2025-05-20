return {
	id = 9804,
	stages = {
		{
			stageIndex = 1,
			failCondition = 1,
			timeCount = 600,
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
			mainUnitPosition = {
				{
					Vector3(-105, 0, 58),
					Vector3(-105, 0, 78),
					Vector3(-105, 0, 38)
				},
				[-1] = {
					Vector3(15, 0, 58),
					Vector3(15, 0, 78),
					Vector3(15, 0, 38)
				}
			},
			fleetCorrdinate = {
				-90,
				0,
				55
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
					triggerType = 1,
					waveIndex = 202,
					preWaves = {},
					triggerParams = {
						timeout = 15
					}
				},
				{
					triggerType = 1,
					waveIndex = 203,
					preWaves = {},
					triggerParams = {
						timeout = 30
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
							monsterTemplateID = 16693001,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								10,
								0,
								75
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16693003,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								-5,
								0,
								65
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16693003,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								-5,
								0,
								45
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16693001,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								10,
								0,
								35
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							score = 0,
							reinforceDelay = 5,
							monsterTemplateID = 16733205,
							sickness = 0.1,
							delay = 1,
							moveCast = true,
							corrdinate = {
								8,
								0,
								55
							},
							bossData = {
								hpBarNum = 100,
								icon = ""
							},
							buffList = {
								8001,
								8007
							}
						}
					}
				},
				{
					triggerType = 0,
					waveIndex = 102,
					conditionType = 1,
					preWaves = {
						202
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16693002,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								-5,
								0,
								75
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16693003,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								-10,
								0,
								50
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16693002,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								-5,
								0,
								25
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16693001,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								0,
								0,
								55
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16693001,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								0,
								0,
								45
							},
							buffList = {
								8001,
								8007
							}
						}
					}
				},
				{
					triggerType = 0,
					waveIndex = 103,
					conditionType = 1,
					preWaves = {
						203
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16734001,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								10,
								0,
								75
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16734003,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								-5,
								0,
								65
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16734003,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								-5,
								0,
								45
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16734001,
							moveCast = true,
							delay = 0,
							score = 0,
							corrdinate = {
								10,
								0,
								35
							},
							buffList = {
								8001,
								8007
							}
						}
					}
				},
				{
					triggerType = 8,
					waveIndex = 900,
					preWaves = {
						101
					},
					triggerParams = {}
				}
			}
		}
	},
	fleet_prefab = {
		vanguard_unitList = {
			{
				tmpID = 900811,
				configId = 900811,
				skinId = 201380,
				id = 1,
				level = 120,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 300,
					air = 0,
					antiaircraft = 500,
					torpedo = 400,
					durability = 10000,
					reload = 240,
					armor = 0,
					dodge = 250,
					speed = 51.6,
					luck = 0,
					hit = 120
				},
				skills = {
					{
						id = 151250,
						level = 10
					},
					{
						id = 151260,
						level = 10
					},
					{
						id = 151270,
						level = 10
					},
					{
						id = 30472,
						level = 1
					}
				}
			}
		},
		main_unitList = {
			{
				tmpID = 900812,
				configId = 900812,
				skinId = 205010,
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
					antiaircraft = 300,
					torpedo = 0,
					durability = 900000,
					reload = 150,
					armor = 3,
					dodge = 33,
					speed = 20,
					luck = 25,
					hit = 70
				},
				skills = {
					{
						id = 10300,
						level = 10
					}
				}
			}
		}
	}
}
