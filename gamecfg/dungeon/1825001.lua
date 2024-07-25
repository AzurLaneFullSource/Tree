return {
	map_id = 10001,
	id = 1815001,
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
					triggerType = 1,
					key = true,
					waveIndex = 105,
					preWaves = {},
					triggerParams = {
						timeout = 1
					}
				},
				{
					triggerType = 0,
					waveIndex = 2001,
					conditionType = 1,
					preWaves = {},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16595003,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								-5,
								0,
								50
							},
							buffList = {
								200973
							}
						}
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
					blockFlags = {
						1
					},
					spawn = {
						{
							monsterTemplateID = 16635002,
							delay = 0,
							corrdinate = {
								-10,
								0,
								50
							},
							bossData = {
								hpBarNum = 100,
								icon = ""
							},
							buffList = {
								200914,
								200974,
								200976
							},
							phase = {
								{
									index = 0,
									switchType = 1,
									switchTo = 1,
									switchParam = 1.5
								},
								{
									index = 1,
									switchType = 1,
									switchTo = 2,
									switchParam = 7,
									addWeapon = {
										3175001
									}
								},
								{
									index = 2,
									switchType = 1,
									switchTo = 3,
									switchParam = 1,
									removeWeapon = {
										3175001
									}
								},
								{
									index = 3,
									switchType = 1,
									switchTo = 4,
									switchParam = 15,
									addWeapon = {
										3175004
									}
								},
								{
									index = 4,
									switchParam = 18,
									switchTo = 5,
									switchType = 1,
									addWeapon = {
										3175002,
										3175003
									},
									removeWeapon = {
										3175004
									}
								},
								{
									index = 5,
									switchType = 1,
									switchTo = 6,
									switchParam = 5,
									removeWeapon = {
										3175002
									}
								},
								{
									index = 6,
									switchType = 1,
									switchTo = 7,
									switchParam = 2,
									removeWeapon = {
										3175003
									}
								},
								{
									index = 7,
									switchType = 1,
									switchTo = 8,
									switchParam = 3,
									addWeapon = {
										3175005,
										3175007
									}
								},
								{
									index = 8,
									switchType = 1,
									switchTo = 9,
									switchParam = 5,
									addWeapon = {
										3175006
									}
								},
								{
									index = 9,
									switchType = 1,
									switchTo = 1,
									switchParam = 2,
									removeWeapon = {
										3175005,
										3175006,
										3175007
									}
								}
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
						100
					},
					triggerParam = {},
					blockFlags = {
						2
					},
					spawn = {
						{
							monsterTemplateID = 16635001,
							delay = 0,
							corrdinate = {
								-10,
								0,
								50
							},
							bossData = {
								hpBarNum = 100,
								icon = ""
							},
							buffList = {
								200914
							},
							phase = {
								{
									index = 0,
									switchType = 1,
									switchTo = 1,
									switchParam = 1.5
								},
								{
									index = 1,
									switchType = 1,
									switchTo = 2,
									switchParam = 5,
									addWeapon = {
										3175101
									}
								},
								{
									index = 2,
									switchType = 1,
									switchTo = 3,
									switchParam = 2,
									addWeapon = {
										3175104
									}
								},
								{
									index = 3,
									switchType = 1,
									switchTo = 4,
									switchParam = 12,
									removeWeapon = {
										3175101
									}
								},
								{
									index = 4,
									switchType = 1,
									switchTo = 5,
									switchParam = 2.5,
									removeWeapon = {
										3175104
									}
								},
								{
									index = 5,
									switchType = 1,
									switchTo = 6,
									switchParam = 12,
									addWeapon = {
										3175102,
										3175103
									}
								},
								{
									index = 6,
									switchType = 1,
									switchTo = 7,
									switchParam = 4,
									removeWeapon = {
										3175102
									}
								},
								{
									index = 7,
									switchType = 1,
									switchTo = 8,
									switchParam = 1.5,
									removeWeapon = {
										3175103
									}
								},
								{
									index = 8,
									switchType = 1,
									switchTo = 9,
									switchParam = 3,
									addWeapon = {
										3175105,
										3175107
									}
								},
								{
									index = 9,
									switchType = 1,
									switchTo = 10,
									switchParam = 5,
									addWeapon = {
										3175106
									}
								},
								{
									index = 10,
									switchType = 1,
									switchTo = 1,
									switchParam = 1.5,
									removeWeapon = {
										3175105,
										3175106,
										3175107
									}
								}
							}
						}
					}
				},
				{
					triggerType = 8,
					waveIndex = 900,
					conditionType = 1,
					preWaves = {
						101,
						102
					},
					triggerParams = {}
				},
				{
					triggerType = 11,
					waveIndex = 4001,
					conditionType = 1,
					preWaves = {
						100
					},
					triggerParams = {
						op = 0,
						key = "warning"
					}
				}
			}
		}
	},
	fleet_prefab = {}
}
