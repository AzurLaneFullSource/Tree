return {
	map_id = 10001,
	id = 1867001,
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
					key = true,
					waveIndex = 101,
					conditionType = 1,
					preWaves = {
						100
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16677001,
							delay = 0.1,
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
									switchParam = 1.5,
									addWeapon = {
										3217001
									}
								},
								{
									switchType = 1,
									switchTo = 3,
									index = 2,
									switchParam = 3.5,
									setAI = 10001,
									addWeapon = {
										3217002
									}
								},
								{
									switchType = 1,
									switchTo = 4,
									index = 3,
									switchParam = 1,
									setAI = 70188,
									removeWeapon = {
										3217001,
										3217002
									}
								},
								{
									index = 4,
									switchType = 1,
									switchTo = 5,
									switchParam = 2,
									addWeapon = {
										3217003,
										3217004
									}
								},
								{
									index = 5,
									switchType = 1,
									switchTo = 6,
									switchParam = 2,
									addWeapon = {
										3217005,
										3217006
									}
								},
								{
									index = 6,
									switchType = 1,
									switchTo = 7,
									switchParam = 1,
									removeWeapon = {
										3217005
									}
								},
								{
									index = 7,
									switchType = 1,
									switchTo = 8,
									switchParam = 2,
									addWeapon = {
										3217005
									}
								},
								{
									index = 8,
									switchType = 1,
									switchTo = 9,
									switchParam = 1,
									removeWeapon = {
										3217005
									}
								},
								{
									index = 9,
									switchType = 1,
									switchTo = 10,
									switchParam = 3.8,
									addWeapon = {
										3217005
									}
								},
								{
									index = 10,
									switchType = 1,
									switchTo = 11,
									switchParam = 1,
									removeWeapon = {
										3217003,
										3217004,
										3217005,
										3217006
									}
								},
								{
									index = 11,
									switchType = 1,
									switchTo = 12,
									switchParam = 4.5,
									addWeapon = {
										3217007,
										3217008
									}
								},
								{
									index = 12,
									switchType = 1,
									switchTo = 13,
									switchParam = 11.5,
									addWeapon = {
										3217009
									}
								},
								{
									index = 13,
									switchParam = 6,
									switchTo = 14,
									switchType = 1,
									addWeapon = {
										3217010,
										3217011
									},
									removeWeapon = {
										3217007,
										3217008,
										3217009
									}
								},
								{
									index = 14,
									switchType = 1,
									switchTo = 15,
									switchParam = 6,
									addWeapon = {
										3217012
									}
								},
								{
									index = 15,
									switchType = 1,
									switchTo = 16,
									switchParam = 6,
									addWeapon = {
										3217013
									}
								},
								{
									index = 16,
									switchType = 1,
									switchTo = 1,
									switchParam = 2,
									removeWeapon = {
										3217010,
										3217011,
										3217012,
										3217013
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
						101
					},
					triggerParams = {}
				},
				{
					triggerType = 11,
					waveIndex = 4001,
					conditionType = 1,
					preWaves = {},
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
