return {
	id = 1813303,
	stages = {
		{
			stageIndex = 1,
			failCondition = 1,
			timeCount = 180,
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
					triggerType = 1,
					waveIndex = 202,
					preWaves = {},
					triggerParams = {
						timeout = 20
					}
				},
				{
					triggerType = 1,
					waveIndex = 203,
					preWaves = {},
					triggerParams = {
						timeout = 40
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
							monsterTemplateID = 16613203,
							reinforceDelay = 4,
							deadFX = "bomb_unknownV",
							sickness = 0.1,
							delay = 1,
							corrdinate = {
								0,
								0,
								50
							},
							buffList = {
								8001,
								8007
							}
						}
					},
					reinforcement = {
						{
							monsterTemplateID = 16613013,
							delay = 0,
							deadFX = "bomb_unknownV",
							sickness = 0.1,
							corrdinate = {
								-12,
								0,
								62
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16613013,
							delay = 0,
							deadFX = "bomb_unknownV",
							sickness = 0.1,
							corrdinate = {
								-12,
								0,
								38
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16613012,
							delay = 0,
							deadFX = "bomb_unknownV",
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
							monsterTemplateID = 16613012,
							delay = 0,
							deadFX = "bomb_unknownV",
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
						}
					}
				},
				{
					triggerType = 0,
					waveIndex = 2001,
					conditionType = 1,
					preWaves = {
						100
					},
					triggerParam = {},
					spawn = {},
					reinforcement = {
						{
							monsterTemplateID = 16613017,
							moveCast = true,
							delay = 8,
							corrdinate = {
								5,
								0,
								50
							},
							buffList = {
								8001
							},
							phase = {
								{
									switchParam = 8,
									dive = "STATE_RAID",
									switchTo = 1,
									index = 0,
									switchType = 1,
									setAI = 20005
								}
							}
						},
						reinforceDuration = 180
					}
				},
				{
					triggerType = 0,
					waveIndex = 2002,
					conditionType = 1,
					preWaves = {
						100
					},
					triggerParam = {},
					spawn = {},
					reinforcement = {
						{
							monsterTemplateID = 16613016,
							delay = 4,
							deadFX = "bomb_unknownV",
							sickness = 0.1,
							corrdinate = {
								5,
								0,
								66
							},
							buffList = {
								8001
							}
						},
						{
							monsterTemplateID = 16613016,
							delay = 4,
							deadFX = "bomb_unknownV",
							sickness = 0.1,
							corrdinate = {
								5,
								0,
								34
							},
							buffList = {
								8001
							}
						},
						reinforceDuration = 180
					}
				},
				{
					triggerType = 0,
					waveIndex = 3001,
					conditionType = 1,
					preWaves = {
						100
					},
					blockFlags = {
						200925
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16616004,
							delay = 0,
							corrdinate = {
								-20,
								0,
								50
							},
							buffList = {}
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
	fleet_prefab = {}
}
