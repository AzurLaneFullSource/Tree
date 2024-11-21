return {
	map_id = 10001,
	id = 1877001,
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
							monsterTemplateID = 16687001,
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
									switchParam = 10,
									addWeapon = {
										3227001,
										3227002
									}
								},
								{
									index = 2,
									switchParam = 2,
									switchTo = 3,
									switchType = 1,
									addWeapon = {
										3227003,
										3227004
									},
									removeWeapon = {
										3227001,
										3227002
									}
								},
								{
									index = 3,
									switchType = 1,
									switchTo = 4,
									switchParam = 9,
									addWeapon = {
										3227005
									}
								},
								{
									index = 4,
									switchType = 1,
									switchTo = 5,
									switchParam = 3,
									removeWeapon = {
										3227003,
										3227004,
										3227009
									}
								},
								{
									index = 5,
									switchType = 1,
									switchTo = 6,
									switchParam = 2,
									addWeapon = {
										3227010
									}
								},
								{
									index = 6,
									switchType = 1,
									switchTo = 7,
									switchParam = 15,
									addWeapon = {
										3227011,
										3227012
									}
								},
								{
									index = 7,
									switchType = 1,
									switchTo = 1,
									switchParam = 3,
									removeWeapon = {
										3227010,
										3227011,
										3227012
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
