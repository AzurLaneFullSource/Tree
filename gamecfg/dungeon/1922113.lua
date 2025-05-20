return {
	id = 1921113,
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
						timeout = 18
					}
				},
				{
					triggerType = 1,
					waveIndex = 203,
					preWaves = {},
					triggerParams = {
						timeout = 33
					}
				},
				{
					triggerType = 1,
					waveIndex = 204,
					preWaves = {},
					triggerParams = {
						timeout = 44
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
							monsterTemplateID = 16692002,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								0,
								0,
								65
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16692003,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								-5,
								0,
								50
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16692002,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								0,
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
					triggerType = 0,
					waveIndex = 102,
					conditionType = 1,
					preWaves = {
						101,
						202
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16692003,
							reinforceDelay = 6,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								0,
								0,
								60
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16692003,
							reinforceDelay = 6,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								0,
								0,
								40
							},
							buffList = {
								8001,
								8007
							}
						}
					},
					reinforcement = {
						{
							monsterTemplateID = 16692002,
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
							monsterTemplateID = 16692001,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								-10,
								0,
								65
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16692001,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								-10,
								0,
								35
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16692002,
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
						}
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 104,
					conditionType = 0,
					preWaves = {
						500,
						102,
						101
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16732302,
							reinforceDelay = 6,
							delay = 0.1,
							corrdinate = {
								-10,
								0,
								50
							},
							bossData = {
								hpBarNum = 20,
								icon = ""
							},
							buffList = {},
							phase = {
								{
									switchParam = 2,
									switchTo = 1,
									index = 0,
									switchType = 1,
									setAI = 20006
								},
								{
									index = 1,
									switchType = 1,
									switchTo = 2,
									switchParam = 3.5,
									addWeapon = {
										3272101,
										3272103
									}
								},
								{
									index = 2,
									switchType = 1,
									switchTo = 3,
									switchParam = 6,
									addWeapon = {
										3272102
									}
								},
								{
									index = 3,
									switchParam = 12,
									switchTo = 4,
									switchType = 1,
									addWeapon = {
										3272104,
										3272105,
										3272106,
										3272107
									},
									removeWeapon = {
										3272101,
										3272102,
										3272103
									}
								},
								{
									index = 4,
									switchType = 1,
									switchTo = 5,
									switchParam = 1,
									removeWeapon = {
										3272104,
										3272105,
										3272106,
										3272107
									}
								},
								{
									index = 5,
									switchType = 1,
									switchTo = 6,
									switchParam = 5,
									addWeapon = {
										3272108,
										3272109
									}
								},
								{
									index = 6,
									switchType = 1,
									switchTo = 7,
									switchParam = 6,
									addWeapon = {
										3272110
									}
								},
								{
									index = 7,
									switchType = 1,
									switchTo = 1,
									switchParam = 2,
									removeWeapon = {
										3272108,
										3272109,
										3272110
									}
								}
							}
						}
					},
					reinforcement = {
						{
							monsterTemplateID = 16692002,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								5,
								0,
								75
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16692002,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								5,
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
