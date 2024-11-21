return {
	map_id = 10001,
	id = 1876002,
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
							monsterTemplateID = 16686002,
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
									switchParam = 0.1,
									setAI = 10001,
									addWeapon = {
										3226104,
										3226105,
										3226109
									}
								},
								{
									index = 2,
									switchType = 1,
									switchTo = 3,
									switchParam = 9,
									addWeapon = {
										3226101
									}
								},
								{
									index = 3,
									switchParam = 8,
									switchTo = 4,
									switchType = 1,
									addWeapon = {
										3226102
									},
									removeWeapon = {
										3226101
									}
								},
								{
									switchType = 1,
									switchTo = 5,
									index = 4,
									switchParam = 2,
									setAI = 70188,
									removeWeapon = {
										3226102
									}
								},
								{
									index = 5,
									switchType = 1,
									switchTo = 6,
									switchParam = 15,
									addWeapon = {
										3226103
									}
								},
								{
									index = 6,
									switchType = 1,
									switchTo = 2,
									switchParam = 1,
									removeWeapon = {
										3226103
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
