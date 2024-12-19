return {
	map_id = 10001,
	id = 1885001,
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
				150,
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
			stageBuff = {
				{
					id = 295010,
					level = 1
				}
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
							monsterTemplateID = 16695001,
							delay = 0,
							sickness = 1,
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
								201210,
								201211,
								200825,
								201192
							},
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
									switchParam = 4,
									addWeapon = {
										3235001
									}
								},
								{
									index = 2,
									switchType = 1,
									switchTo = 3,
									switchParam = 2,
									addWeapon = {
										3235003
									}
								},
								{
									index = 3,
									switchType = 1,
									switchTo = 4,
									switchParam = 2,
									addWeapon = {
										3235002
									}
								},
								{
									index = 4,
									switchType = 1,
									switchTo = 5,
									switchParam = 8,
									addWeapon = {
										3235004
									}
								},
								{
									index = 5,
									switchType = 1,
									switchTo = 6,
									switchParam = 8,
									addWeapon = {
										3235005
									}
								},
								{
									index = 6,
									switchParam = 3,
									switchTo = 7,
									switchType = 1,
									addWeapon = {
										3235006
									},
									removeWeapon = {
										3235001,
										3235002,
										3235004,
										3235005
									}
								},
								{
									index = 7,
									switchType = 1,
									switchTo = 8,
									switchParam = 1,
									removeWeapon = {
										3235006
									}
								},
								{
									index = 8,
									switchParam = 4,
									switchTo = 9,
									switchType = 1,
									addWeapon = {
										3235007
									},
									removeWeapon = {
										3235006
									}
								},
								{
									index = 9,
									switchParam = 10,
									switchTo = 10,
									switchType = 1,
									addWeapon = {
										3235006,
										3235008
									},
									removeWeapon = {}
								},
								{
									index = 10,
									switchType = 1,
									switchTo = 11,
									switchParam = 2,
									removeWeapon = {
										3235003,
										3235006,
										3235007,
										3235008
									}
								},
								{
									index = 11,
									switchType = 1,
									switchTo = 12,
									switchParam = 2,
									addWeapon = {
										3235009
									}
								},
								{
									index = 12,
									switchType = 1,
									switchTo = 13,
									switchParam = 16,
									addWeapon = {
										3235010
									}
								},
								{
									index = 13,
									switchType = 1,
									switchTo = 1,
									switchParam = 1,
									removeWeapon = {
										3235009,
										3235010
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
