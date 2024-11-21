return {
	map_id = 10001,
	id = 1876001,
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
							monsterTemplateID = 16686001,
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
										3226001,
										3226003
									}
								},
								{
									index = 2,
									switchParam = 9,
									switchTo = 3,
									switchType = 1,
									addWeapon = {
										3226002,
										3226006
									},
									removeWeapon = {
										3226001,
										3226003
									}
								},
								{
									index = 3,
									switchParam = 4,
									switchTo = 4,
									switchType = 1,
									addWeapon = {
										3226004
									},
									removeWeapon = {
										3226002,
										3226006
									}
								},
								{
									switchType = 1,
									switchTo = 5,
									index = 4,
									switchParam = 7,
									setAI = 20006,
									addWeapon = {
										3226005
									}
								},
								{
									index = 5,
									switchType = 1,
									switchTo = 1,
									switchParam = 1,
									removeWeapon = {
										3226004,
										3226005
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
