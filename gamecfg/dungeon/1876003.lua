return {
	map_id = 10001,
	id = 1876003,
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
					key = true,
					waveIndex = 101,
					conditionType = 1,
					preWaves = {
						100
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16686003,
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
							buffList = {},
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
									switchParam = 6,
									setAI = 10001,
									addWeapon = {
										3226201
									}
								},
								{
									index = 2,
									switchParam = 7,
									switchTo = 3,
									switchType = 1,
									addWeapon = {
										3226202,
										3226203
									},
									removeWeapon = {
										3226201
									}
								},
								{
									index = 3,
									switchParam = 7.5,
									switchTo = 4,
									switchType = 1,
									addWeapon = {
										3226204,
										3226205
									},
									removeWeapon = {
										3226202,
										3226203
									}
								},
								{
									switchType = 1,
									switchTo = 5,
									index = 4,
									switchParam = 2,
									setAI = 70188,
									addWeapon = {
										3226201
									},
									removeWeapon = {
										3226204,
										3226205
									}
								},
								{
									index = 5,
									switchType = 1,
									switchTo = 6,
									switchParam = 13,
									addWeapon = {
										3226207,
										3226206
									}
								},
								{
									index = 6,
									switchType = 1,
									switchTo = 1,
									switchParam = 0.2,
									removeWeapon = {
										3226201,
										3226206,
										3226207
									}
								}
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
	fleet_prefab = {}
}
