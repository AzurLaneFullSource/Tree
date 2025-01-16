return {
	id = 1889003,
	stages = {
		{
			stageIndex = 1,
			failCondition = 1,
			timeCount = 180,
			passCondition = 1,
			backGroundStageID = 1,
			totalArea = {
				-75,
				20,
				90,
				70
			},
			playerArea = {
				-75,
				20,
				42,
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
							deadFX = "chengbao_yanhua_stg",
							delay = 0,
							monsterTemplateID = 16589301,
							sickness = 0.5,
							corrdinate = {
								30,
								0,
								30
							},
							buffList = {
								8001,
								8002
							}
						},
						{
							deadFX = "chengbao_yanhua_stg",
							delay = 0,
							monsterTemplateID = 16589301,
							sickness = 0.5,
							corrdinate = {
								30,
								0,
								70
							},
							buffList = {
								8001,
								8002
							}
						},
						{
							monsterTemplateID = 16589302,
							delay = 0,
							deadFX = "chengbao_yanhua_stg",
							corrdinate = {
								-5,
								0,
								50
							}
						}
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 102,
					conditionType = 1,
					preWaves = {
						101,
						202
					},
					triggerParam = {},
					spawn = {
						{
							deadFX = "chengbao_yanhua_stg",
							delay = 0,
							monsterTemplateID = 16589301,
							sickness = 0.5,
							corrdinate = {
								30,
								0,
								30
							},
							buffList = {
								8001,
								8002
							}
						},
						{
							deadFX = "chengbao_yanhua_stg",
							delay = 1,
							monsterTemplateID = 16589301,
							sickness = 0.5,
							corrdinate = {
								30,
								0,
								60
							},
							buffList = {
								8001,
								8002
							}
						},
						{
							deadFX = "chengbao_yanhua_stg",
							delay = 1,
							monsterTemplateID = 16589301,
							sickness = 0.5,
							corrdinate = {
								30,
								0,
								40
							},
							buffList = {
								8001,
								8002
							}
						},
						{
							deadFX = "chengbao_yanhua_stg",
							delay = 0,
							monsterTemplateID = 16589301,
							sickness = 0.5,
							corrdinate = {
								30,
								0,
								70
							},
							buffList = {
								8001,
								8002
							}
						},
						{
							monsterTemplateID = 16589302,
							delay = 0,
							deadFX = "chengbao_yanhua_stg",
							corrdinate = {
								-5,
								0,
								50
							}
						}
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 103,
					conditionType = 1,
					preWaves = {
						102,
						203
					},
					triggerParam = {},
					spawn = {
						{
							deadFX = "chengbao_yanhua_stg",
							delay = 0,
							monsterTemplateID = 16589301,
							sickness = 0.5,
							corrdinate = {
								30,
								0,
								30
							},
							buffList = {
								8001,
								8002
							}
						},
						{
							deadFX = "chengbao_yanhua_stg",
							delay = 0,
							monsterTemplateID = 16589301,
							sickness = 0.5,
							corrdinate = {
								30,
								0,
								50
							},
							buffList = {
								8001,
								8002
							}
						},
						{
							deadFX = "chengbao_yanhua_stg",
							delay = 0,
							monsterTemplateID = 16589301,
							sickness = 0.5,
							corrdinate = {
								30,
								0,
								70
							},
							buffList = {
								8001,
								8002
							}
						},
						{
							monsterTemplateID = 16589302,
							delay = 0,
							deadFX = "chengbao_yanhua_stg",
							corrdinate = {
								-5,
								0,
								40
							}
						},
						{
							monsterTemplateID = 16589302,
							delay = 0,
							deadFX = "chengbao_yanhua_stg",
							corrdinate = {
								-5,
								0,
								60
							}
						}
					}
				},
				{
					triggerType = 0,
					waveIndex = 104,
					conditionType = 0,
					preWaves = {
						101,
						102,
						103
					},
					triggerParams = {},
					spawn = {
						{
							score = 0,
							moveCast = true,
							delay = 0,
							monsterTemplateID = 16699301,
							corrdinate = {
								-5,
								0,
								50
							},
							bossData = {
								hpBarNum = 80,
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
									switchParam = 7,
									switchTo = 2,
									switchType = 1,
									addWeapon = {
										3239401,
										3239402
									},
									removeWeapon = {}
								},
								{
									switchType = 1,
									switchTo = 3,
									index = 2,
									switchParam = 8,
									setAI = 10001,
									addWeapon = {
										3239403,
										3239404
									},
									removeWeapon = {
										3239401,
										3239402
									}
								},
								{
									switchParam = 2,
									switchTo = 4,
									index = 3,
									switchType = 1,
									setAI = 70125
								},
								{
									index = 4,
									switchParam = 10.5,
									switchTo = 5,
									switchType = 1,
									addWeapon = {
										3239405,
										3239406,
										3239407
									},
									removeWeapon = {
										3239403,
										3239404
									}
								},
								{
									switchType = 1,
									switchTo = 6,
									index = 5,
									switchParam = 5,
									setAI = 10001,
									addWeapon = {
										3239408
									},
									removeWeapon = {
										3239405,
										3239406,
										3239407
									}
								},
								{
									switchType = 1,
									switchTo = 1,
									index = 6,
									switchParam = 2,
									setAI = 70125,
									removeWeapon = {
										3239408
									}
								}
							}
						}
					}
				},
				{
					triggerType = 8,
					key = true,
					waveIndex = 900,
					preWaves = {
						104
					},
					triggerParams = {}
				}
			}
		}
	},
	fleet_prefab = {}
}
